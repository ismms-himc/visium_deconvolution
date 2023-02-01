library(CARD)
library(Matrix)
library(data.table)
library(Seurat)
library(SeuratDisk)

args<-commandArgs(T)
scrna_path = args[1]
spatial_path = args[2]
celltype_final = args[3]
output_path = args[4]

sc <- readRDS(scrna_path)
sc_count <- GetAssayData(object = st, slot = "counts")
spatial <- Load10X_Spatial(spatial_path)
spatial_count <- GetAssayData(object = st, slot = "counts")

CARD_obj = createCARDObject(
  sc_count = sc_count,
  sc_meta = sc_meta,
  spatial_count = spatial_count,
  spatial_location = spatial_location,
  ct.varname = "cellType",
  ct.select = unique(sc_meta$cellType),
  sample.varname = "sampleInfo",
  minCountGene = 100,
  minCountSpot = 5) 
