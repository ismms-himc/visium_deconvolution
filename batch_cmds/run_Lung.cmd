#!/usr/bin/env sh

# Merad and GeoMX

cat Lung.samples | parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_Lung.sh \
{}
"

cat failed.Lung.samples | parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_Lung_c2l.sh \
{}
"

# singler

cat Lung.samples | parallel --dryrun -j1 -k "bsub_premium_himem singler_{/} '/sc/arion/projects/HIMC/software/singler/run_singler.sh {}/filtered_feature_bc_matrix.h5 /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung.h5ad Cell_type_final'"
