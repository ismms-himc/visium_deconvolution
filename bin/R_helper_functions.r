create_output_dir <- function(output_path) {
  dir.create(output_path, recursive = TRUE, showWarnings = FALSE)
}

load_spatial <- function(spatial_path) {
  st <- Load10X_Spatial(spatial_path)
  #RenameAssays(object = st, Spatial = 'RNA')
  return(st)
}

get_assay_name <- function(st) {
  if ("Spatial" %in% Assays(st)) {
    return("Spatial")
  } else {
    return("RNA")
  }
}

filter_sp_barcodes <- function(st, assay_name) {
  if (assay_name == "Spatial") {
    spatial <- subset(st, subset = nCount_Spatial > 5)
  } else {
    spatial <- subset(st, subset = nCount_RNA > 5)
  }
  return(spatial)
}

load_scref <- function(scrna_path) {
  scrna_suf <- strsplit(scrna_path,'\\.')[[1]][-1]
  if (scrna_suf == 'h5Seurat' || scrna_suf == 'h5seurat')  {
        sc = LoadH5Seurat(scrna_path)
  } else if (scrna_suf == 'RDS' || scrna_suf == 'rds') {
        sc = readRDS(scrna_path)
  }
  return(sc)
}

downsample <- function(seurat_object, prop=0.1) {
  seurat_object <- subset(seurat_object, cells = sample(Cells(seurat_object), prop*ncol(seurat_object)))
  return(seurat_object)
}
