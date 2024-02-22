CELLS=$(tail -n+2 $1/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += $0} END {print sum/NR}')
echo $CELLS
SAMPLE=$(basename $1)
echo $SAMPLE

cd /sc/arion/projects/HIMC/nextflow/visium_deconvolution/

###################
# Melanoma_cutaneous_GSE215121 
###################

echo \
"
nextflow run main.nf \\
  --rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_acral_cutaneous_GSE215121/CM_processed_wrawcounts.h5ad \\
  --rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_acral_cutaneous_GSE215121/CM_processed_wrawcounts.rds \\
  --outdir_final $1/deconvolution/Melanoma_cutaneous_GSE215121/ \\
  --spatial_h5ad $1 \\
  --celltype_key annotation \\
  --c2l_batch sample \\
  --c2l_covariates site \\
  --c2l_cellsPerSpot $CELLS \\
  -w work/$SAMPLE \\
  -c nextflow.config \\
  --tools='spotlight'
" > tmp/${SAMPLE}.sh
echo $(readlink -f tmp/${SAMPLE}.sh)

bsub_premium $SAMPLE "sh tmp/${SAMPLE}.sh"
