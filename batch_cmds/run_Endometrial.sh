#CELLS=$(tail -n+2 $1/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += $0} END {print sum/NR}')
#echo $CELLS
CELLS=15
SAMPLE=$(basename $1)
echo $SAMPLE

cd /sc/arion/projects/HIMC/nextflow/visium_deconvolution/

#bsub_premium $SAMPLE \
#"
#nextflow run main.nf \\
#--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/endometrial_human/endometrial_reference.h5ad \\
#--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/endometrial_human/endometrial_reference.rds \\
#--spatial_h5ad $1 \\
#--celltype_key selection_annotation \\
#--c2l_batch dataset \\
#--c2l_covariates None \\
#--c2l_cellsPerSpot $CELLS \\
#--outdir_final $1/deconvolution/endometrial_curated_Vladimir/ \\
#-w work/$SAMPLE \\
#-c nextflow.config
#"

#-c nextflow_c2la100.config

# Run Endometrial with Cellcounts as Sinem did not annotate them yet
#bsub_premium $SAMPLE \
#"
#nextflow run main.nf \\
#--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/endometrial_human/endometrial_reference.h5ad \\
#--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/endometrial_human/endometrial_reference.rds \\
#--spatial_h5ad $1 \\
#--celltype_key selection_annotation \\
#--c2l_batch dataset \\
#--c2l_covariates None \\
#--outdir_final $1/deconvolution/endometrial_curated_Vladimir/ \\
#-w work/$SAMPLE \\
#-c nextflow.config
#"

# Run Endometrial with Cellcounts as Sinem did not annotate them yet
bsub_premium $SAMPLE \
"
nextflow run main.nf \\
--rna_h5ad /sc/arion/projects/HIMC/collaborations/deconvolution_references/endometrial/endo_crc_raw_counts_final.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/collaborations/deconvolution_references/endometrial/endo_crc_raw_counts_final.rds \\
--spatial_h5ad $1 \\
--celltype_key ClusterFull \\
--c2l_batch batch \\
--c2l_covariates None \\
--outdir_final $1/deconvolution/endo_crc_raw_counts_final/ \\
-w work/$SAMPLE \\
-c nextflow.config \\
--tools 'rctd'
"
