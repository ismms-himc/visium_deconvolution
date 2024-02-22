nextflow run main.nf -with-singularity /sc/arion/work/dsouzd04/singularity_images/cell2location-v0.06-alpha.sif
nextflow run main.nf -with-singularity /sc/arion/work/dsouzd04/singularity_images/sp_cell2location_latest.sif

# debug
singularity exec /sc/arion/work/dsouzd04/singularity_images/cell2location-v0.06-alpha.sif /opt/conda/envs/cellpymc/bin/python bin/Cell2location_pipeline.py example_data/starmap_sc_rna.h5ad example_data/starmap_spatial.h5ad celltype example_data/results


#######################
CELL2LOCATION
#######################

## EXAMPLE DATA FROM PAPER

# first run
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_cell2location_latest.sif \
/opt/conda/envs/cell2loc_env/bin/python \
bin/Cell2location_pipeline.py \
example_data/starmap_sc_rna.h5ad \
example_data/starmap_spatial.h5ad \
celltype \
example_data/results

# edited script to save figures (update.. doesn't work ... need to figure out in jupyter)
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_cell2location_latest.sif \
/opt/conda/envs/cell2loc_env/bin/python \
bin/Cell2location_pipeline.py example_data/starmap_sc_rna.h5ad \
example_data/starmap_spatial.h5ad \
celltype \
None \
None \
30 \
example_data/results

## LU932
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_cell2location_latest.sif \
/opt/conda/envs/cell2loc_env/bin/python \
bin/Cell2location_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/tangram/SEKI10_Lu932_1_v4_for_tangram.h5ad \
Cell_type_final \
Sample \
Sample_Origin \
30 \
results/Lu932

## SAGN29_40765_0_v1

singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_cell2location_latest.sif \
/opt/conda/envs/cell2loc_env/bin/python \
bin/Cell2location_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40765_0_v1_raw.h5ad \
Cell_type_final \
Sample \
Sample_Origin \
30 \
results/40765

# with bsub

bsub_gpu 40765_c2l \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_cell2location_latest.sif \
/opt/conda/envs/cell2loc_env/bin/python \
bin/Cell2location_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40765_0_v1_raw.h5ad \
Cell_type_final \
Sample \
Sample_Origin \
30 \
results/40765;
"

## SAGN29_40766_0_v1

bsub_gpu 40766_c2l \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_cell2location_latest.sif \
/opt/conda/envs/cell2loc_env/bin/python \
bin/Cell2location_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40766_0_v1_raw.h5ad \
Cell_type_final \
Sample \
Sample_Origin \
30 \
results/40766;
"

## SAGN29_41485_0_v1

bsub_gpu 41485_c2l \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_cell2location_latest.sif \
/opt/conda/envs/cell2loc_env/bin/python \
bin/Cell2location_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_41485_0_v1_raw.h5ad \
Cell_type_final \
Sample \
Sample_Origin \
30 \
results/41485;
"

## SAGN29_41486_0_v1

bsub_gpu 41486_c2l \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_cell2location_latest.sif \
/opt/conda/envs/cell2loc_env/bin/python \
bin/Cell2location_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_41486_0_v1_raw.h5ad \
Cell_type_final \
Sample \
Sample_Origin \
30 \
results/41486;
"

#######################
TANGRAM CLUSTER LEVEL
#######################

## EXAMPLE DATA FROM PAPER

singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/tangram_latest.sif \
python \
bin/Tangram_pipeline.py \
example_data/starmap_sc_rna.h5ad \
example_data/starmap_spatial.h5ad \
celltype \
example_data/results

## Lung samples

bsub_gpu 40765_tangram \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/tangram_latest.sif \
python \
bin/Tangram_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40765_0_v1_raw.h5ad \
Cell_type_final \
results/40765
"

bsub_gpu 40766_tangram \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/tangram_latest.sif \
python \
bin/Tangram_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40766_0_v1_raw.h5ad \
Cell_type_final \
results/40766
"

bsub_gpu 41485_tangram \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/tangram_latest.sif \
python \
bin/Tangram_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_41485_0_v1_raw.h5ad \
Cell_type_final \
results/41485
"

bsub_gpu 41486_tangram \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/tangram_latest.sif \
python \
bin/Tangram_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_41486_0_v1_raw.h5ad \
Cell_type_final \
results/41486
"

#######################
DESTVI # running into error with sagn samples !!!
#######################

# example data
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_destvi_latest.sif \
python \
bin/DestVI_pipeline.py \
example_data/starmap_sc_rna.h5ad \
example_data/starmap_spatial.h5ad \
celltype \
example_data/results

bsub_gpu 40765_DESTVI \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_destvi_latest.sif \
python \
bin/DestVI_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40765_0_v1_raw.h5ad \
Cell_type_final \
results/40765
"

bsub_gpu 40766_DESTVI \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_destvi_latest.sif \
python \
bin/DestVI_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40766_0_v1_raw.h5ad \
Cell_type_final \
results/40766
"

bsub_gpu 41485_DESTVI \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_destvi_latest.sif \
python \
bin/DestVI_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_41485_0_v1_raw.h5ad \
Cell_type_final \
results/41485
"

#######################
Stereoscope
#######################

# example data
# sp_stereoscope_latest.sif does not have scvi tools :(. Use destvi images since scvi is installed and has stereoscope
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_stereoscope_latest.sif \
python \
bin/Stereoscope_pipeline.py \
example_data/starmap_sc_rna.h5ad \
example_data/starmap_spatial.h5ad \
celltype \
example_data/results

singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_destvi_latest.sif \
python \
bin/Stereoscope_pipeline.py \
example_data/starmap_sc_rna.h5ad \
example_data/starmap_spatial.h5ad \
celltype \
example_data/results

bsub_gpu 40765_Stereoscope \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_destvi_latest.sif \
python \
bin/Stereoscope_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40765_0_v1_raw.h5ad \
Cell_type_final \
results/40765
"

bsub_gpu 40766_Stereoscope \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_destvi_latest.sif \
python \
bin/Stereoscope_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40766_0_v1_raw.h5ad \
Cell_type_final \
results/40766
"

bsub_gpu 41485_Stereoscope \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_destvi_latest.sif \
python \
bin/Stereoscope_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_41485_0_v1_raw.h5ad \
Cell_type_final \
results/41485
"

bsub_gpu 41486_Stereoscope \
"
ml singularity;
singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_destvi_latest.sif \
python \
bin/Stereoscope_pipeline.py \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5ad \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_41486_0_v1_raw.h5ad \
Cell_type_final \
results/41486
"

#######################
spatialdwls
#######################

# example data (doesnt work...need Seurat Disk)

singularity exec --nv \
/sc/arion/work/dsouzd04/singularity_images/sp_spatialdwls_latest.sif \
Rscript \
bin/SpatialDWLS_pipeline.r \
example_data/starmap_sc_rna.h5seurat \
example_data/starmap_spatial.h5seurat \
celltype \
example_data/results

# example data (R 4.2 on minerva has Giotto and Seurat Disk)

ml R/4.2.0
Rscript \
bin/SpatialDWLS_pipeline.r \
example_data/starmap_sc_rna.h5seurat \
example_data/starmap_spatial.h5seurat \
celltype \
/hpc/packages/minerva-centos7/python/3.8.2/bin/python \
example_data/results


bsub_gpu 40765_SpatialDWLS \
"
ml R/4.2.0;
Rscript \
bin/SpatialDWLS_pipeline.r \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5seurat \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40765_0_v1_raw.h5ad \
Cell_type_final \
results/40765
"

bsub_gpu 40766_SpatialDWLS \
"
ml R/4.2.0;
Rscript \
bin/SpatialDWLS_pipeline.r \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5seurat \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_40766_0_v1_raw.h5ad \
Cell_type_final \
results/40766
"

bsub_gpu 41485_SpatialDWLS \
"
ml R/4.2.0;
Rscript \
bin/SpatialDWLS_pipeline.r \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5seurat \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_41485_0_v1_raw.h5ad \
Cell_type_final \
results/41485
"

bsub_gpu 41486_SpatialDWLS \
"
ml R/4.2.0;
Rscript \
bin/SpatialDWLS_pipeline.r \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.h5seurat \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumVSGeoMIX/SAGN29_41486_0_v1_raw.h5ad \
Cell_type_final \
results/41486
"

#######################
SPOTLight
#######################

# Lu932

bsub_premium_himem Lu932_SPOTlight \
"
ml singularity;
singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_spotlight_1.0.0.sif \
Rscript \
bin/SPOTlight_pipeline_2.r \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.rds \
/sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/SEKI10_Lu932_1_v4 \
Cell_type_final \
results/Lu932
"

# Lu936_2

bsub_premium_himem Lu936_2_SPOTlight \
"
ml singularity;
singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_spotlight_1.0.0.sif \
Rscript \
bin/SPOTlight_pipeline_2.r \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.rds \
/sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/SEKI10_Lu936_2_1_v4 \
Cell_type_final \
results/Lu936_2
"

bsub_premium_cr 42722_SPOTlight \
"
ml singularity;
singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_spotlight_1.0.0.sif \
Rscript \
bin/SPOTlight_pipeline_2.r \
/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_immunotherapy_resistance_GSE115978/Melanoma_immunotherapy_resistance_GSE115978.rds \
/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v2 \
cell.types \
results/42722
"

#######################
Seurat
#######################

bsub_premium_cr Lu932_Seurat \
"
ml singularity;
singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_seurat_4.2.1.sif \
Rscript \
bin/Seurat_pipeline.r \
/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/cell2location/GSEplusAndrew/andrewLeader_plus_GSE131907_lung.rds \
/sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/SEKI10_Lu932_1_v4 \
Cell_type_final \
results/Lu932
"


bsub_premium_cr 42722_Seurat \
"
ml singularity;
singularity exec \
/sc/arion/projects/HIMC/singularity_images/himc_seurat_4.2.1.sif \
Rscript \
bin/Seurat_pipeline.r \
/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_immunotherapy_resistance_GSE115978/Melanoma_immunotherapy_resistance_GSE115978.rds \
/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3 \
cell.types \
results/42722
"

