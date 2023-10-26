library(zellkonverter)
library(Seurat)

adata <- readH5AD('crc_v8_complete_dropDupCells.h5ad')
seu <- as.Seurat(adata, counts='X', data='X')
saveRDS(seu, 'crc_v8_complete_dropDupCells.rds')
