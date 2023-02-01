.libPaths(c("/usr/local/lib/R/site-library", "/usr/local/lib/R/library"))
library(Seurat)
library(dplyr)
library(SeuratDisk)
library(future)
# check the current active plan
plan("multiprocess", workers = 32)
options(future.globals.maxSize= 50000*1024*1024^2)


args<-commandArgs(T)
scrna_path = args[1]
spatial_path = args[2]
celltype_final = args[3]
output_path = args[4]

scrna_suf <- strsplit(scrna_path,'\\.')[[1]][-1]

if (scrna_suf == 'h5Seurat' || scrna_suf == 'h5seurat')  {
  sc_rna = LoadH5Seurat(scrna_path)
} else if (scrna_suf == 'RDS' || scrna_suf == 'rds') {
  sc_rna = readRDS(scrna_path)
}

sc_rna <- subset(sc_rna, subset = nCount_RNA > 10)
sc_rna <- SCTransform(sc_rna)

spatial <- Load10X_Spatial(spatial_path)
if ("Spatial" %in% Assays(spatial)) {
    spatial <- subset(spatial, subset = nCount_Spatial > 5)
    spatial <- SCTransform(spatial, assay='Spatial')
} else {
    spatial <- subset(spatial, subset = nCount_RNA > 5)
    spatial <- SCTransform(spatial, assay='RNA')
}


anchors <- FindTransferAnchors(reference=sc_rna, query = spatial, dims = 1:30, normalization.method = 'SCT')
predictions <- TransferData(anchorset = anchors, refdata = sc_rna@meta.data[,celltype_final], dims = 1:30)
write.csv(predictions, paste0(output_path, '/Seurat_result.txt'))
