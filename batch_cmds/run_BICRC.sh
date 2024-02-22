#CELLS=$(tail -n+2 $1/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += $0} END {print sum/NR}')
#echo $CELLS
#CELLS=10
SAMPLE=$(basename $1)
echo $SAMPLE

cd /sc/arion/projects/HIMC/nextflow/visium_deconvolution/

#################
# Jesse Reference
#################

echo \
"
nextflow run main.nf \\
  --rna_h5ad /sc/arion/projects/HIMC/collaborations/deconvolution_references/crc/complete_crc_cellranger_QCed_bbknn_annotated_variable_v2_grained_withRaw_JBanno_downsampledRaw.h5ad \\
  --rna_h5Seurat /sc/arion/projects/HIMC/collaborations/deconvolution_references/crc/complete_crc_cellranger_QCed_bbknn_annotated_variable_v2_grained_withRaw_JBanno_downsampledRaw.rds \\
  --outdir_final $1/deconvolution/complete_crc_cellranger_QCed_bbknn_annotated_variable_v2_grained_withRaw_JBanno_downsampledRaw/ \\
  --spatial_h5ad $1 \\
  --celltype_key JB_fine \\
  --c2l_batch SAMPLE \\
  --c2l_covariates PROTOCOL \\
  --c2l_cellsPerSpot $CELLS \\
  -w work/$SAMPLE \\
  -c nextflow.config
" > tmp/${SAMPLE}.sh
echo $(readlink -f tmp/${SAMPLE}.sh)

bsub_premium $SAMPLE "sh tmp/${SAMPLE}.sh"

#################
# Vladimir Reference
#################

#echo \
#"
#nextflow run main.nf \\
#  --rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/CRC_Merad_lab/crc_v8_complete.h5ad \\
#  --rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/CRC_Merad_lab/crc_v8_complete.rds \\
#  --outdir_final $1/deconvolution/CRC_curated_Vladimir/ \\
#  --spatial_h5ad $1 \\
#  --celltype_key selection_annotation \\
#  --c2l_batch SAMPLE \\
#  --c2l_covariates PROTOCOL \\
#  --c2l_cellsPerSpot $CELLS \\
#  -w work/$SAMPLE \\
#  -c nextflow.config
#" > tmp/${SAMPLE}.sh
#echo $(readlink -f tmp/${SAMPLE}.sh)
#
#bsub_premium $SAMPLE "sh tmp/${SAMPLE}.sh"

##################
# Pelka, CRC Immune Hub
# Use downsampled for R due to memory constrains
##################

#echo \
#"
#nextflow run main.nf \\
#  --rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/CRC_immune_hubs/CRC_immune_hubs.h5ad \\
#  --rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/CRC_immune_hubs/CRC_immune_hubs_downsampled.h5seurat \\
#  --outdir_final $1/deconvolution/CRC_immune_hubs/ \\
#  --spatial_h5ad $1 \\
#  --celltype_key ClusterFull \\
#  --c2l_cellsPerSpot $CELLS \\
#  -w work/$SAMPLE \\
#  -c nextflow.config \\
#  --tools='spotlight'
#" > tmp/${SAMPLE}.sh
#echo $(readlink -f tmp/${SAMPLE}.sh)
#
#bsub_premium $SAMPLE "sh tmp/${SAMPLE}.sh"

#--tools='seurat, spotlight, spatialdwls, rctd'

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
