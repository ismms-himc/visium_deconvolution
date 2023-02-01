/sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/MIME22_BIC18-A5_0_v2/
/sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/MIME22_BIC18-A7_0_v2/
/sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/MIME22_BIC21-A5_0_v2/
/sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/MIME22_BIC21-A6_0_v2/
/sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/MIME22_BIC31-B4_0_v3/
/sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/MIME22_BIC31B6-V2_0_v2/

# Tabula Sapiens dataset
(cat << EOF
MIME22_BIC18-A5_0_v2
MIME22_BIC18-A7_0_v2
MIME22_BIC21-A5_0_v2
MIME22_BIC21-A6_0_v2
MIME22_BIC31-B4_0_v3
MIME22_BIC31B6-V2_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{} \
'nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Large_Intestine/TS_Large_Intestine.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Large_Intestine/TS_Large_Intestine.h5seurat \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/{} \\
--celltype_key free_annotation \\
--c2l_batch None \\
--c2l_covariates None \\
--c2l_cellsPerSpot 30 \\
--outdir_final /sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/{}/deconvolution/TabulaMurisSapiens_LargeIntestine/'
"

# CRC Immune hubs
(cat << EOF
MIME22_BIC18-A5_0_v2
MIME22_BIC18-A7_0_v2
MIME22_BIC21-A5_0_v2
MIME22_BIC21-A6_0_v2
MIME22_BIC31-B4_0_v3
MIME22_BIC31B6-V2_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{} \
'nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/CRC_immune_hubs/CRC_immune_hubs_downsampled.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/CRC_immune_hubs/CRC_immune_hubs_downsampled.h5seurat \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/{} \\
--celltype_key ClusterFull \\
--c2l_batch None \\
--c2l_covariates None \\
--c2l_cellsPerSpot 30 \\
--outdir_final /sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/{}/deconvolution/CRC_immune_hubs_downsampled/'
"

### debug

bsub_premium \
MIME22_BIC31B6-V2_0_v2_c2l \
"
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/CRC_immune_hubs/CRC_immune_hubs_downsampled.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/CRC_immune_hubs/CRC_immune_hubs_downsampled.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/MIME22_BIC31B6-V2_0_v2 \
--celltype_key ClusterFull \
--c2l_batch None \
--c2l_covariates None \
--c2l_cellsPerSpot 30 \
--outdir_final /sc/arion/projects/HIMC/himc-project-data/MIME22/data/10X/MIME22_BIC31B6-V2_0_v2/deconvolution/CRC_immune_hubs_downsampled/ \
--tools cell2location
"

