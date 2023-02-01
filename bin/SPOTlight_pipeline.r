.libPaths(c("/usr/local/lib/R/site-library", "/usr/local/lib/R/library"))
library(ggplot2)
library(SPOTlight)
library(SingleCellExperiment)
library(scater)
library(scran)
library(Seurat)
library(future)
# check the current active plan
plan("multiprocess", workers = 16)
options(future.globals.maxSize= 50000 * 1024^2)

args<-commandArgs(T)
scrna_path = args[1]
spatial_path = args[2]
celltype_final = args[3]
output_path = args[4]

sc <- readRDS(scrna_path)
sc <- as.SingleCellExperiment(sc)

st <- Load10X_Spatial(spatial_path)

set.seed(123)

# Feature selection
sc <- logNormCounts(sc)

# Variance modelling
dec <- modelGeneVar(sc)

# Get the top 3000 genes.
hvg <- getTopHVGs(dec, n = 3000)

colLabels(sc) <- colData(sc)[celltype_final]

# Get vector indicating which genes are neither ribosomal or mitochondrial
genes <- !grepl(pattern = "^Rp[l|s]|Mt", x = rownames(sc))

# Compute marker genes
mgs <- scoreMarkers(sc, subset.row = genes)

# keep only those genes that are relevant for each cell identity
mgs_fil <- lapply(names(mgs), function(i) {
    x <- mgs[[i]]
    # Filter and keep relevant marker genes, those with AUC > 0.8
    x <- x[x$mean.AUC > 0.8, ]
    # Sort the genes from highest to lowest weight
    x <- x[order(x$mean.AUC, decreasing = TRUE), ]
    # Add gene and cluster id to the dataframe
    x$gene <- rownames(x)
    x$cluster <- i
    data.frame(x)
})
mgs_df <- do.call(rbind, mgs_fil)


spotlight_ls <- SPOTlight(
    x = sc,
    y = st,
    assay = 'Spatial',
    groups = sc[celltype_final],
    mgs = mgs_df,
    hvg = hvg,
    weight_id = "mean.AUC",
    group_id = "cluster",
    gene_id = "gene")

decon_mtrx <- spotlight_ls$mat
write.csv(decon_mtrx, paste0(output_path, '/SPOTlight_result.txt'))
