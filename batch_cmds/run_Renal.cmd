cat Renal.samples | parallel --dryrun -j1 -k " /sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_Renal.sh {}"
