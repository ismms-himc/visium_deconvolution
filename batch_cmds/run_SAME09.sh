#CELLS=$(tail -n+2 $1/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += $0} END {print sum/NR}')
#echo $CELLS
SAMPLE=$(basename $1)
echo $SAMPLE

cd /sc/arion/projects/HIMC/nextflow/visium_deconvolution/

#bsub_premium $SAMPLE \
#"
#nextflow run main.nf \\
#--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/IBD/completed_LP.h5ad \\
#--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/IBD/completed_LP.rds \\ 
#--spatial_h5ad $1 \\
#--celltype_key labels \\
#--c2l_batch IBDCD076_CD45pos_TI \\
#--c2l_covariates Biopsy_site \\
#--outdir_final $1/deconvolution/completed_LP/ \\
#-w work/$SAMPLE \\
#-c nextflow.config
#"

# made raw counts default matrix in reference. Rerun RCTD

bsub_premium ${SAMPLE}_rctd \
"
nextflow run main.nf \\
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/IBD/completed_LP_rawcounts.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/IBD/completed_LP_rawcounts.rds \\ 
--spatial_h5ad $1 \\
--celltype_key labels \\
--c2l_batch IBDCD076_CD45pos_TI \\
--c2l_covariates Biopsy_site \\
--outdir_final $1/deconvolution/completed_LP/ \\
-w work/$SAMPLE \\
--tools rctd \\
-c nextflow.config
"
