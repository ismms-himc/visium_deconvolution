#CELLS=$(tail -n+2 $1/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += $0} END {print sum/NR}')
#echo $CELLS
SAMPLE=$(basename $1)
echo $SAMPLE

cd /sc/arion/projects/HIMC/nextflow/visium_deconvolution/

bsub_premium ${SAMPLE} \
"
nextflow run main.nf \\
--rna_h5ad /sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/HCC/HCC_sce2adata_with39and41_for_conversion.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/HCC/HCC_sce2adata_with39and41_for_conversion.h5seurat \\
--spatial_h5ad $1 \\
--celltype_key annot \\
--c2l_batch sample_name \\
--c2l_covariates None \\
--outdir_final $1/deconvolution/HCC_sce2adata_with39and41_for_conversion/ \\
-w work/$SAMPLE \\
-c nextflow.config
"
