/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42720_0_v4
/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v4

# Get avg number of cells/spot
head -n2 run_Melanoma_v4.cmd | parallel -j1 -k "tail -n+2 {}/qupath_processing/stardist_detections_per_barcode.csv | cut -d, -f2 | grep -v 0 | awk '{sum += \$0} END {print sum/NR}'"

(cat << EOF
SEK10_42720_0_v4
SEK10_42722_0_v4
EOF
) |  parallel --dryrun -j1 -k \
"
bsub_premium \
{} \
'
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5ad \\
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5Seurat \\
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/{} \\
--celltype_key celltype \\
--c2l_batch orig.ident \\
--c2l_covariates technology \\
--c2l_cellsPerSpot 25 \\
--outdir_final nextflow_testing/{}'
"

(cat << EOF
SEK10_42720_0_v4
EOF
) |  parallel --dryrun -j1 -k \
"
cat << EOF > tmp.sh
nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5Seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/{} \
--celltype_key celltype \
--c2l_batch orig.ident \
--c2l_covariates technology \
--c2l_cellsPerSpot 25 \
--outdir_final nextflow_testing/{} \
--tools 'spotlight, stride, destvi, stereoscope, spatialdwls'
EOF
bsub_premium {} 'sh tmp.sh'
"

#####
Tools are only outputting Cell2Location, Seurat and Tangram....
#####

nextflow run main.nf \
--rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5ad \
--rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5Seurat \
--spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v4 \
--celltype_key celltype \
--c2l_cellsPerSpot 25 \
--outdir_final nextflow_testing/SEK10_42722_0_v4_test \
--tools 'spotlight, stride, destvi, stereoscope, '
