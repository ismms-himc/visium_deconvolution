#CELLS=$(tail -n+2 $1/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += $0} END {print sum/NR}')
#echo $CELLS
SAMPLE=$(basename $1)
echo $SAMPLE

cd /sc/arion/projects/HIMC/nextflow/visium_deconvolution/

bsub_premium $SAMPLE \
"
nextflow run main.nf \\
--rna_h5ad /sc/arion/projects/HIMC/collaborations/galsky_lab/galsky_sc.h5ad \\ 
--rna_h5Seurat /sc/arion/projects/HIMC/collaborations/galsky_lab/galsky_sc_forRDSconversion_2.rds \\
--spatial_h5ad $1 \\
--celltype_key ann_highlevel \\
--c2l_batch sampleID \\
--c2l_covariates patientID \\
--outdir_final $1/deconvolution/galsky_sc_ann_highlevel/ \\
-w work/$SAMPLE \\
-c nextflow.config
"
