/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWG9X03301_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGBLDXZ01_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGDOKY201_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGPV5TY01_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGSPZZX01_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGTQ4PT01_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGUKK5E01_0_v1
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGUVJF701_0_v1


(cat << EOF
SAGN24_CWWG9X03301_0_v1
SAGN24_CWWGBLDXZ01_0_v1
SAGN24_CWWGDOKY201_0_v1
SAGN24_CWWGPV5TY01_0_v1
SAGN24_CWWGSPZZX01_0_v1
SAGN24_CWWGTQ4PT01_0_v1
SAGN24_CWWGUKK5E01_0_v1
SAGN24_CWWGUVJF701_0_v1
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{} \
'nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TS_Uterus_Endometrium_test.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TS_Uterus_Endometrium.rds \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \\
--celltype_key free_annotation \\
--c2l_batch None \\
--c2l_covariates None \\
--c2l_cellsPerSpot 30 \\
--tools 'spotlight, spatialdwls, seurat' \\
--outdir_final nextflow_testing/{}'
"


bsub_premium \
CWWGBLDXZ01 \
"
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TS_Uterus_Endometrium_test.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TS_Uterus_Endometrium.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGBLDXZ01_0_v1 \
--celltype_key free_annotation \
--c2l_batch None \
--c2l_covariates None \
--c2l_cellsPerSpot 30 \
--outdir_final nextflow_testing/SAGN24_CWWGBLDXZ01_0_v1
"

singularity exec --nv \
/sc/arion/projects/HIMC/singularity_images/sp_destvi_latest.sif \
python \
bin/DestVI_pipeline.py \
nextflow run main.nf \
SC=/sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TS_Uterus_Endometrium_test.h5ad \
SP=/sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TS_Uterus_Endometrium.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGBLDXZ01_0_v1 \
--celltype_key free_annotation \
--c2l_batch None \
--c2l_covariates None \
--c2l_cellsPerSpot 30 \
--outdir_final nextflow_testing/SAGN24_CWWGBLDXZ01_0_v1

