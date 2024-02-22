# Melanoma

SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5ad'
SP='/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3'
CT='celltype'
OUT='results/42722'

#######################
CELL2LOCATION
#######################

bsub_gpu 42722_c2l \
"
ml singularity;

singularity exec --nv \
/sc/arion/projects/HIMC/singularity_images/sp_cell2location_latest.sif \
python \
bin/Cell2location_pipeline.py \
$SC \
$SP \
$CT \
orig.ident \
technology \
15 \
$OUT
"

#######################
Tangram
#######################

bsub_gpu 42722_tangram \
"
ml singularity;

singularity exec --nv \
/sc/arion/projects/HIMC/singularity_images/tangram_latest.sif \
python \
bin/Tangram_pipeline.py \
$SC \
$SP \
$CT \
$OUT
"

#######################
DestVI
#######################

SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference_downsampled.h5ad'
SP='/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3'
CT='celltype'
OUT='results/42722'

bsub_gpu 42722_destvi \
"
ml singularity;

singularity exec --nv \
/sc/arion/projects/HIMC/singularity_images/sp_destvi_latest.sif \
python \
bin/DestVI_pipeline.py \
$SC \
$SP \
$CT \
$OUT \
test
"

#######################
Stereoscope
#######################

SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference_downsampled.h5ad'
SP='/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3'
CT='celltype'
OUT='results/42722'

bsub_gpu 42722_stereoscope \
"
ml singularity;

singularity exec --nv \
/sc/arion/projects/HIMC/singularity_images/sp_destvi_latest.sif \
python \
bin/Stereoscope_pipeline.py \
$SC \
$SP \
$CT \
$OUT \
test
"

#######################
Seurat
#######################

SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5Seurat'
SP='/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3'
CT='celltype'
OUT='results/42722'

bsub_express_cr 42722_seurat \
"
ml singularity;

singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_seurat_4.2.1.sif \
Rscript \
bin/Seurat_pipeline.r \
$SC \
$SP \
$CT \
$OUT
"


#######################
SpatialDWLS
#######################

SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference_downsampled.h5seurat'
SP='/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3'
CT='celltype'
OUT='results/42722'

bsub_express_cr 42722_SpatialDWLS \
"
ml singularity;

singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_giotto_1.1.2.sif \
Rscript \
bin/SpatialDWLS_pipeline.r \
$SC \
$SP \
$CT \
$OUT \
test
"

#######################
RCTD
#######################

SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference_downsampled.h5seurat'
#SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference_downsampled.h5Seurat'
SP='/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3'
CT='celltype'
OUT='results/42722'

bsub_express_cr 42722_RCTD \
"
ml singularity;

singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_rctd_2.0.3.sif \
Rscript \
bin/RCTD_pipeline.r \
$SC \
$SP \
$CT \
$OUT \
test
"

#######################
SPOTLight
#######################

SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference_downsampled.h5seurat'
#SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5Seurat'
SP='/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3'
CT='celltype'
OUT='results/42722'

bsub_express_cr 42722_SPOTlight \
"
ml singularity;

singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_spotlight_1.0.0.sif \
Rscript \
bin/SPOTlight_pipeline_2.r \
$SC \
$SP \
$CT \
$OUT \
test
"

#######################
STRIDE
#######################

SC='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference_downsampled.h5ad'
SP='/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3'
CT='celltype'
#CT='/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference_celltype.txt'
OUT='results/42722'

bsub_express_cr 42722_STRIDE \
"
ml singularity;

singularity exec --nv \
/sc/arion/projects/HIMC/singularity_images/sp_stride_latest.sif \
sh bin/STRIDE_pipeline.sh \
$SC \
$SP \
$CT \
$OUT
"
