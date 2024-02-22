#!/usr/bin/env sh

# Melanoma

cat Melanoma.samples | parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_Melanoma.sh \
{}
"

# singler

cat Melanoma.samples | cut -d, -f1 | parallel --dryrun -j1 -k "bsub_premium_himem singler_{/} '/sc/arion/projects/HIMC/software/singler/run_singler.sh {}/filtered_feature_bc_matrix.h5 /sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_acral_cutaneous_GSE215121/CM_processed_wrawcounts.h5ad annotation'"
