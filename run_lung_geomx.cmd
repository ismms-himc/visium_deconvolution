/sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_40765_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_40766_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_41485_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_41486_0_v1

########################################################################
# andrewLeader_plus_GSE131907_lung_SUBSAMPLED
########################################################################

bsub_premium \
SAGN29_40765_0_v1 \
"
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_40765_0_v1 \
--celltype_key Cell_type_final \
--c2l_batch Sample \
--c2l_covariates Sample_Origin \
--c2l_cellsPerSpot 30 \
--outdir_final nextflow_testing/SAGN29_40765_0_v1/andrewLeader_plus_GSE131907_lung_SUBSAMPLED \
--tools 'destvi, spotlight, seurat, spatialdwls'
"

bsub_premium \
SAGN29_40766_0_v1 \
"
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_40766_0_v1 \
--celltype_key Cell_type_final \
--c2l_batch Sample \
--c2l_covariates Sample_Origin \
--c2l_cellsPerSpot 30 \
--outdir_final nextflow_testing/SAGN29_40766_0_v1/andrewLeader_plus_GSE131907_lung_SUBSAMPLED \
--tools 'destvi, spotlight, seurat, spatialdwls'
"

bsub_premium \
SAGN29_41485_0_v1 \
"
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_41485_0_v1 \
--celltype_key Cell_type_final \
--c2l_batch Sample \
--c2l_covariates Sample_Origin \
--c2l_cellsPerSpot 30 \
--outdir_final nextflow_testing/SAGN29_41485_0_v1/andrewLeader_plus_GSE131907_lung_SUBSAMPLED \
--tools 'destvi, spotlight, seurat, spatialdwls'
"

bsub_premium \
SAGN29_41486_0_v1 \
"
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_41486_0_v1 \
--celltype_key Cell_type_final \
--c2l_batch Sample \
--c2l_covariates Sample_Origin \
--c2l_cellsPerSpot 30 \
--outdir_final nextflow_testing/SAGN29_41486_0_v1/andrewLeader_plus_GSE131907_lung_SUBSAMPLED \
--tools 'destvi, spotlight, seurat, spatialdwls'
"

###################
#SCRATCH
###################
SC='/sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5seurat'
SP='/sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_40765_0_v2'
CT='Cell_type_final'
OUT='results/40765'


bsub_gpu 40765_destvi \
"
ml singularity;

singularity exec --nv \
/sc/arion/projects/HIMC/singularity_images/sp_destvi_latest.sif \
python \
bin/DestVI_pipeline.py \
$SC \
$SP \
$CT \
$OUT
"

singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_spotlight_1.0.0.sif \
Rscript \
bin/SPOTlight_pipeline_2.r \
$SC \
$SP \
$CT \
$OUT


