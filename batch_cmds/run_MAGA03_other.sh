#CELLS=$(tail -n+2 $1/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += $0} END {print sum/NR}')
#echo $CELLS
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

bsub_premium ${SAMPLE}_stereoscope \
"
nextflow run main.nf \\
--rna_h5ad /sc/arion/projects/HIMC/collaborations/galsky_lab/galsky_sc.h5ad \\ 
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/endometrial_human/endometrial_reference.rds \\
--spatial_h5ad $1 \\
--celltype_key minorlabel \\
--c2l_batch sampleID \\
--c2l_covariates patientID \\
--outdir_final $1/deconvolution/galsky_sc/ \\
--tools 'stereoscope' \\
-w work/$SAMPLE \\
-c nextflow.config
"

bsub_premium ${SAMPLE}_destvi \
"
nextflow run main.nf \\
--rna_h5ad /sc/arion/projects/HIMC/collaborations/galsky_lab/galsky_sc.h5ad \\ 
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/endometrial_human/endometrial_reference.rds \\
--spatial_h5ad $1 \\
--celltype_key minorlabel \\
--c2l_batch sampleID \\
--c2l_covariates patientID \\
--outdir_final $1/deconvolution/galsky_sc/ \\
--tools 'destvi' \\
-w work/$SAMPLE \\
-c nextflow.config
"
