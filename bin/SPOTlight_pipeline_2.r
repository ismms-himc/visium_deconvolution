source("/sc/arion/projects/HIMC/nextflow/visium_deconvolution/bin/R_helper_functions.r")
#.libPaths(c("/usr/local/lib/R/site-library", "/usr/local/lib/R/library"))
library(Matrix)
library(data.table)
library(Seurat)
library(dplyr)
library(SPOTlight)
library(igraph)
library(RColorBrewer)
library(SeuratDisk)
library(future)
library(ggplot2)
# check the current active plan
plan("multiprocess", workers = 32)
options(future.globals.maxSize = 50000 * 1024^2) # for 50 Gb RAM

args<-commandArgs(T)
scrna_path = args[1]
spatial_path = args[2]
celltype_final = args[3]
output_path = args[4]
is_test=args[5]

scrna_suf <- strsplit(scrna_path,'\\.')[[1]][-1]
print(scrna_suf)

if (scrna_suf == 'h5Seurat' || scrna_suf == 'h5seurat')  {
  sc = LoadH5Seurat(scrna_path)
} else if (scrna_suf == 'RDS' || scrna_suf == 'rds') {
  sc = readRDS(scrna_path)
}


st <- Load10X_Spatial(spatial_path)
if (!is.na(is_test)) {
  print('Downsampling of 1% barcodes for testing')
  st <- downsample(st, 0.1)
}


set.seed(123)
sc <- subset(sc, subset = nCount_RNA > 10)
sc <- Seurat::SCTransform(sc, verbose = FALSE)

Idents(sc) <- sc@meta.data[,celltype_final]

cluster_markers_all <- FindAllMarkers(object = sc, 
                                              assay = "SCT",
                                              slot = "data",
                                              verbose = TRUE, 
                                              only.pos = TRUE)

groups <- sc@meta.data[[celltype_final]]

# in case celltype doesnt have any marker genes
sc <- sc[,groups %in% unique(cluster_markers_all[['cluster']])]
groups <- sc@meta.data[[celltype_final]]

st <- RenameAssays(object = st, Spatial = 'RNA')


spotlight_ls <- SPOTlight(
  x=sc,
  y=st,
  assay="RNA",
  groups=groups, # Variable in sc containing the cell-type annotation
  mgs=cluster_markers_all, # Dataframe with the marker genes
  gene_id = "gene",
  group_id = "cluster",
  weight_id = "p_val_adj",
  hvg = 3000
  )     
  
mat <- spotlight_ls$mat
write.csv(mat, paste0(output_path, '/SPOTlight_result.txt'))

# Extract NMF model fit
mod <- spotlight_ls$NMF

output_figures = paste0(output_path, '/figures/')
dir.create(output_figures, showWarnings = FALSE, recursive = TRUE)

plotTopicProfiles(x = mod,
                  y = sc@meta.data[,celltype_final],
                  facet = FALSE,
                  min_prop = 0.01,
                  ncol = 1) + 
theme(aspect.ratio = 1)
ggsave(paste0(output_figures, 'spotlight_Topic_profiles.jpg'))

plotTopicProfiles(x = mod,
                  y = sc@meta.data[,celltype_final],
                  facet = TRUE,
                  min_prop = 0.01,
                  ncol = 1) 
ggsave(paste0(output_figures, 'spotlight_Topic_profiles_facet.jpg'))

plotCorrelationMatrix(mat)
ggsave(paste0(output_figures, 'spotlight_correlation_matrix.jpg'))

plotInteractions(mat, "heatmap")
ggsave(paste0(output_figures, 'spotlight_colocalization.jpg'))

plotInteractions(mat, "network")
ggsave(paste0(output_figures, 'spotlight_network.jpg'))

plotSpatialScatterpie(x = st,
                      y = mat,
                      img = FALSE,
                      scatterpie_alpha = 1,
                      pie_scale = 0.4)
ggsave(paste0(output_figures, 'spotlight_spatial_proportions.jpg'))
