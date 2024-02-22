#CELLS=$(tail -n+2 $1/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += $0} END {print sum/NR}')
#echo $CELLS
CELLS=10
SAMPLE=$(basename $1)
echo $SAMPLE

cd /sc/arion/projects/HIMC/nextflow/visium_deconvolution/

#################
# RCC_counts_removed
#################

echo \
"
nextflow run main.nf \\
  --rna_h5ad /sc/arion/projects/HIMC/collaborations/merad_lab/li/RCC_counts_removed.h5ad \\
  --rna_h5Seurat /sc/arion/projects/HIMC/collaborations/merad_lab/li/RCC_counts_removed.rds \\
  --outdir_final /sc/arion/projects/HIMC/darwin/merad_lab/meylan/$SAMPLE/deconvolution/RCC_counts_removed/ \\
  --spatial_h5ad $1 \\
  --celltype_key annotation \\
  --c2l_cellsPerSpot $CELLS \\
  -w work/${SAMPLE}_1 \\
  -c nextflow.config \\
  --tools 'cell2location'
" > tmp/${SAMPLE}_1.sh
echo $(readlink -f tmp/${SAMPLE}_1.sh)

bsub_premium ${SAMPLE}_1 "sh tmp/${SAMPLE}_1.sh"

#################
# RCC_Pelka_counts 
#################

echo \
"
nextflow run main.nf \\
  --rna_h5ad  /sc/arion/projects/HIMC/collaborations/merad_lab/li/RCC_Pelka_counts.h5ad \\
  --rna_h5Seurat /sc/arion/projects/HIMC/collaborations/merad_lab/li/RCC_Pelka_counts.rds \\
  --outdir_final /sc/arion/projects/HIMC/darwin/merad_lab/meylan/$SAMPLE/deconvolution/RCC_Pelka_counts/ \\
  --spatial_h5ad $1 \\
  --celltype_key annotation \\
  --c2l_cellsPerSpot $CELLS \\
  -w work/${SAMPLE}_2 \\
  -c nextflow.config \\
  --tools 'cell2location'
" > tmp/${SAMPLE}_2.sh
echo $(readlink -f tmp/${SAMPLE}_2.sh)

bsub_premium ${SAMPLE}_2 "sh tmp/${SAMPLE}_2.sh"
