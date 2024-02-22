CELLS=$(tail -n+2 $1/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += $0} END {print sum/NR}')
echo $CELLS
SAMPLE=$(basename $1)
echo $SAMPLE

cd /sc/arion/projects/HIMC/nextflow/visium_deconvolution/

echo \
"
nextflow run main.nf \\
  --rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/reference_lung_completed.h5ad \\
  --rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/reference_lung_completed.rds \\
  --outdir_final $1/deconvolution/Lung_curated_Vladimir/ \\
  --spatial_h5ad $1 \\
  --celltype_key selection_annotation \\
  --c2l_batch Sample \\
  --c2l_covariates Sample_Origin \\
  --c2l_cellsPerSpot $CELLS \\
  --tools 'cell2location' \\
  -w work/$SAMPLE \\
  -c nextflow.config
" > tmp/${SAMPLE}.sh
echo $(readlink -f tmp/${SAMPLE}.sh)

bsub_premium $SAMPLE "sh tmp/${SAMPLE}.sh"

#bsub_premium $SAMPLE \
#"
#nextflow run main.nf \
#  --rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/CRC_Merad_lab/crc_v8_complete.h5ad \ 
#  --rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/CRC_Merad_lab/crc_v8_complete.rds \ 
#  --outdir_final $1/deconvolution/CRC_curated_Vladimir/ \
#  --spatial_h5ad $1 \ 
#  --celltype_key selection_annotation \
#  --c2l_batch SAMPLE \
#  --c2l_covariates PROTOCOL \
#  --c2l_cellsPerSpot $CELLS \
#  -w work/$SAMPLE \
#  -c nextflow.config
#"
#-c nextflow_c2la100.config
