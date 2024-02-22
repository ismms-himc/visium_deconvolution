/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGFWP0101_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGJCTDP01_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGKVYD001_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGW1ZCL01_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGJ7BCV01_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGJ7BNN01_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGJ7BC501_0_v2
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/SAGN24_CWWGKVY2301_0_v2

# Get avg number of cells/spot
head -n8 run_EndometrialCC_Batch2.cmd | parallel -j1 -k "tail -n+2 {}/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += \$0} END {print sum/NR}'"

# check output
head -n8 run_EndometrialCC_Batch2.cmd | parallel -j1 -k "ls -l {}/deconvolution/endometrial_curated_Vladimir/"

###############################################################
# Vladimir annotation (saved output to MIME22 by mistake in first run)
###############################################################
(cat << EOF
SAGN24_CWWGFWP0101_0_v2
SAGN24_CWWGJCTDP01_0_v2
SAGN24_CWWGKVYD001_0_v2
SAGN24_CWWGW1ZCL01_0_v2
SAGN24_CWWGJ7BCV01_0_v2
SAGN24_CWWGJ7BNN01_0_v2
SAGN24_CWWGJ7BC501_0_v2
SAGN24_CWWGKVY2301_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp/{}.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/endometrial_human/endometrial_reference.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/endometrial_human/endometrial_reference.rds \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \
--celltype_key selection_annotation \
--c2l_batch dataset \
--c2l_covariates None \
--c2l_cellsPerSpot 25 \
--outdir_final /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{}/deconvolution/endometrial_curated_Vladimir/ \
-w work/{}
EOF
bsub_premium {} 'sh tmp/{}.sh'
"

# TSUterus_plus_PBMCAzimuth
(cat << EOF
SAGN24_CWWGFWP0101_0_v2
SAGN24_CWWGJCTDP01_0_v2
SAGN24_CWWGKVYD001_0_v2
SAGN24_CWWGW1ZCL01_0_v2
SAGN24_CWWGJ7BCV01_0_v2
SAGN24_CWWGJ7BNN01_0_v2
SAGN24_CWWGJ7BC501_0_v2
SAGN24_CWWGKVY2301_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{} \
'
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \\
--celltype_key celltype \\
--c2l_batch source \\
--c2l_covariates None \\
--c2l_cellsPerSpot 25 \\
--outdir_final nextflow_testing/{}'
"

#######################################
#Debugging
#######################################

(cat << EOF
SAGN24_CWWGFWP0101_0_v2
SAGN24_CWWGJCTDP01_0_v2
SAGN24_CWWGKVYD001_0_v2
SAGN24_CWWGW1ZCL01_0_v2
SAGN24_CWWGJ7BCV01_0_v2
SAGN24_CWWGJ7BNN01_0_v2
SAGN24_CWWGJ7BC501_0_v2
SAGN24_CWWGKVY2301_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp/{}.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \
--celltype_key celltype \
--c2l_batch source \
--c2l_covariates None \
--c2l_cellsPerSpot 25 \
--outdir_final nextflow_testing/{} \
--tools 'spotlight, stride, destvi, stereoscope, spatialdwls' \
-w work/{}
EOF
bsub_premium {} 'sh tmp/{}.sh'
"


#########################################
#Run stereoscope and destvi in local mode on gpu queue
#########################################

(cat << EOF
SAGN24_CWWGFWP0101_0_v2
SAGN24_CWWGJCTDP01_0_v2
SAGN24_CWWGKVYD001_0_v2
SAGN24_CWWGW1ZCL01_0_v2
SAGN24_CWWGJ7BCV01_0_v2
SAGN24_CWWGJ7BNN01_0_v2
SAGN24_CWWGJ7BC501_0_v2
SAGN24_CWWGKVY2301_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp/{}.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \
--celltype_key celltype \
--c2l_batch source \
--c2l_covariates None \
--c2l_cellsPerSpot 25 \
--outdir_final nextflow_testing/{} \
--tools 'stereoscope' \
-w work/{} \
-c nextflow_local.config
EOF
sh tmp/{}.sh

(cat << EOF
SAGN24_CWWGFWP0101_0_v2
SAGN24_CWWGJCTDP01_0_v2
SAGN24_CWWGKVYD001_0_v2
SAGN24_CWWGW1ZCL01_0_v2
SAGN24_CWWGJ7BCV01_0_v2
SAGN24_CWWGJ7BNN01_0_v2
SAGN24_CWWGJ7BC501_0_v2
SAGN24_CWWGKVY2301_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp/{}_destvi.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \
--celltype_key celltype \
--c2l_batch source \
--c2l_covariates None \
--c2l_cellsPerSpot 25 \
--outdir_final nextflow_testing/{} \
--tools 'destvi' \
-w work/{} \
-c nextflow_local.config
EOF
sh tmp/{}_destvi.sh
"

##################################
# destvi 7000 G fails for some samples... try incresing to 10,000
##################################
(cat << EOF
SAGN24_CWWGFWP0101_0_v2
SAGN24_CWWGJ7BCV01_0_v2
SAGN24_CWWGJ7BNN01_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp/{}_destvi.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/TabulaMurisSapiens/Uterus/TSUterus_plus_PBMCAzimuth_forSeurat.h5seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{} \
--celltype_key celltype \
--c2l_batch source \
--c2l_covariates None \
--c2l_cellsPerSpot 25 \
--outdir_final nextflow_testing/{} \
--tools 'destvi' \
-w work/{} \
-c nextflow_local.config
EOF
sh tmp/{}_destvi.sh
"
