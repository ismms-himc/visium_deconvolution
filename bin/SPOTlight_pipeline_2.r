.libPaths(c("/usr/local/lib/R/site-library", "/usr/local/lib/R/library"))
library(Matrix)
library(data.table)
library(Seurat)
library(dplyr)
library(SPOTlight)
library(igraph)
library(RColorBrewer)
library(SeuratDisk)
library(future)
# check the current active plan
plan("multiprocess", workers = 32)
options(future.globals.maxSize = 50000 * 1024^2) # for 50 Gb RAM

args<-commandArgs(T)
scrna_path = args[1]
spatial_path = args[2]
celltype_final = args[3]
output_path = args[4]

scrna_suf <- strsplit(scrna_path,'\\.')[[1]][-1]

if (scrna_suf == 'h5Seurat' || scrna_suf == 'h5seurat')  {
  sc = LoadH5Seurat(scrna_path)
} else if (scrna_suf == 'RDS' || scrna_suf == 'rds') {
  sc = readRDS(scrna_path)
}


st <- Load10X_Spatial(spatial_path)

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
  
decon_mtrx <- spotlight_ls$mat
write.csv(decon_mtrx, paste0(output_path, '/SPOTlight_result.txt'))
