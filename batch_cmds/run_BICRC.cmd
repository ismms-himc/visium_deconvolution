#!/usr/bin/env sh

# CRCPilot3 MIME22_BIC11A4-V2_0_v2 and MIME22_BIC11A6-V2_0_v2

cat BICRC.samples | grep CRCPilot3 | grep -v BIC31 | cut -d, -f1 | parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_BICRC.sh \
{}
"

# BIC13
cat BICRC.samples | grep VisiumFFPEInternal | cut -d, -f1 | parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_BICRC.sh \
{}
"

# all samples

cat BICRC.samples | cut -d, -f1 | parallel --dryrun -j1 -k "
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_BICRC.sh \
{}
"

# singler

cat BICRC.samples | cut -d, -f1 | parallel --dryrun -j1 -k "bsub_premium_himem singler_{/} '/sc/arion/projects/HIMC/software/singler/run_singler.sh {}/filtered_feature_bc_matrix.h5 /sc/arion/projects/HIMC/reference/single_cell_references/CRC_immune_hubs/CRC_immune_hubs.h5ad ClusterFull'"
