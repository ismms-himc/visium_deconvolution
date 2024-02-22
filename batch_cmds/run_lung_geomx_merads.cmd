/sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_40765_0_v5
/sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_41485_0_v5
/sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_41486_0_v5
/sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/SEKI10_Lu932_1_v3
/sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/SEKI10_Lu936_1_1_v3
/sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/SEKI10_Lu936_2_1_v3

# Get avg number of cells/spot
head -n3 run_lung_geomx_merads.cmd | parallel -j1 -k "tail -n+2 {}/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += \$0} END {print sum/NR}'"
tail -n+4 run_lung_geomx_merads.cmd | head -n3 | parallel -j1 -k "tail -n+2 {}/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += \$0} END {print sum/NR}'"

################################################################################
# Vladimir reference
################################################################################

# GeoMX
(cat << EOF
SAGN29_40765_0_v5
SAGN29_41485_0_v5
SAGN29_41486_0_v5
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp/{}.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/reference_lung_completed.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/reference_lung_completed.rds \ 
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/{} \
--celltype_key selection_annotation \
--c2l_batch Sample \
--c2l_covariates Sample_Origin \
--c2l_cellsPerSpot 25 \
--outdir_final /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/{}/deconvolution/Lung_curated_Vladimir/ \
-w work/{}
EOF
bsub_premium {} 'sh tmp/{}.sh'
"

# Merad

(cat << EOF
SEKI10_Lu932_1_v3
SEKI10_Lu936_1_1_v3
SEKI10_Lu936_2_1_v3
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp/{}.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/reference_lung_completed.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/reference_lung_completed.rds \ 
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/{} \
--celltype_key selection_annotation \
--c2l_batch Sample \
--c2l_covariates Sample_Origin \
--c2l_cellsPerSpot 25 \
--outdir_final /sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/{}/deconvolution/Lung_curated_Vladimir/ \
-w work/{}
EOF
bsub_premium {} 'sh tmp/{}.sh'
"





# Full reference doesn't work....use subsampled
/sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung.h5ad
/sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5ad

####################### GeoMX ##########################################

(cat << EOF
SAGN29_40765_0_v5
SAGN29_41485_0_v5
SAGN29_41486_0_v5
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{} \
'
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5seurat  \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/{} \\
--celltype_key Cell_type_final \\
--c2l_batch Sample \\
--c2l_covariates Sample_Origin \\
--c2l_cellsPerSpot 25 \\
--outdir_final nextflow_testing/{}'
"

(cat << EOF
SAGN29_40765_0_v5
SAGN29_41485_0_v5
SAGN29_41486_0_v5
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp/{}.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5seurat  \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/{} \
--celltype_key Cell_type_final \
--c2l_batch Sample \
--c2l_covariates Sample_Origin \
--c2l_cellsPerSpot 25 \
--outdir_final nextflow_testing/{} \
--tools 'spotlight, stride, destvi, stereoscope, cell2location' \
-w /sc/arion/projects/HIMC/nextflow/visium_deconvolution/work/
EOF
bsub_premium {} 'sh tmp/{}.sh'
"

####################### Merad ##########################################

(cat << EOF
SEKI10_Lu932_1_v3
SEKI10_Lu936_1_1_v3
SEKI10_Lu936_2_1_v3
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{} \
'
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5seurat  \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/{} \\
--celltype_key Cell_type_final \\
--c2l_batch Sample \\
--c2l_covariates Sample_Origin \\
--c2l_cellsPerSpot 25 \\
--outdir_final nextflow_testing/{}'
"

(cat << EOF
SEKI10_Lu932_1_v3
SEKI10_Lu936_1_1_v3
SEKI10_Lu936_2_1_v3
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp/{}.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung_SUBSAMPLED.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SEKI10/data/10X/{} \
--celltype_key Cell_type_final \
--c2l_batch Sample \
--c2l_covariates Sample_Origin \
--c2l_cellsPerSpot 25 \
--outdir_final nextflow_testing/{} \
--tools 'stride, destvi, stereoscope, cell2location' \
-w /sc/arion/projects/HIMC/nextflow/visium_deconvolution/work/{}
EOF
bsub_premium {} 'sh tmp/{}.sh'
"
