/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWG9X03301_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGBLDXZ01_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGDOKY201_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGPV5TY01_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGSPZZX01_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGTQ4PT01_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGUKK5E01_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGUVJF701_0_v2


(cat << EOF
SAGN24_CWWG9X03301_0_v2
SAGN24_CWWGBLDXZ01_0_v2
SAGN24_CWWGDOKY201_0_v2
SAGN24_CWWGPV5TY01_0_v2
SAGN24_CWWGSPZZX01_0_v2
SAGN24_CWWGTQ4PT01_0_v2
SAGN24_CWWGUKK5E01_0_v2
SAGN24_CWWGUVJF701_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{}_a \
'
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \\
--celltype_key celltype \\
--c2l_batch source \\
--c2l_covariates None \\
--c2l_cellsPerSpot 30 \\
--tools cell2location \\
--outdir_final nextflow_testing/{}'
"


(cat << EOF
SAGN24_CWWG9X03301_0_v2
SAGN24_CWWGBLDXZ01_0_v2
SAGN24_CWWGDOKY201_0_v2
SAGN24_CWWGPV5TY01_0_v2
SAGN24_CWWGSPZZX01_0_v2
SAGN24_CWWGTQ4PT01_0_v2
SAGN24_CWWGUKK5E01_0_v2
SAGN24_CWWGUVJF701_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{}_b \
'
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \\
--celltype_key celltype \\
--c2l_batch source \\
--c2l_covariates None \\
--c2l_cellsPerSpot 30 \\
--tools destvi \\
--outdir_final nextflow_testing/{}'
"

(cat << EOF
SAGN24_CWWG9X03301_0_v2
SAGN24_CWWGBLDXZ01_0_v2
SAGN24_CWWGDOKY201_0_v2
SAGN24_CWWGPV5TY01_0_v2
SAGN24_CWWGSPZZX01_0_v2
SAGN24_CWWGTQ4PT01_0_v2
SAGN24_CWWGUKK5E01_0_v2
SAGN24_CWWGUVJF701_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{}_c \
'
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \\
--celltype_key celltype \\
--c2l_batch source \\
--c2l_covariates None \\
--c2l_cellsPerSpot 30 \\
--tools stereoscope \\
--outdir_final nextflow_testing/{}'
"

#################################################

bsub_premium SAGN24_CWWG9X03301_0_v2 'nextflow run main.nf --rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWG9X03301_0_v2 \
--celltype_key celltype \
--c2l_batch None \
--c2l_covariates None \
--c2l_cellsPerSpot 30 \
--outdir_final nextflow_testing/SAGN24_CWWG9X03301_0_v2'


#########################

# seurat
singularity shell /sc/arion/projects/HIMC/singularity_images/himc_seurat_4.2.1.sif

SC=/sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat
SP=/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWG9X03301_0_v2
CT='celltype'
OUT='results/'

Rscript $SC $SP $CT $OUT

#########################

# cell2location

singularity shell --nv /sc/arion/projects/HIMC/singularity_images/himc_cell2location_0.1.2.sif

SC=/sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad
SP=/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWG9X03301_0_v2
CT='celltype'
OUT='results/'

python bin/Cell2location_pipeline.py $SC $SP $CT None None 30 $OUT

SC=/sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad
SP=/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWG9X03301_0_v2
CT='celltype'
OUT='results/'

singularity exec --nv \
/sc/arion/projects/HIMC/singularity_images/himc_cell2location_0.1.2.sif \
python bin/Cell2location_pipeline.py $SC $SP $CT None None 30 $OUT

#########################

