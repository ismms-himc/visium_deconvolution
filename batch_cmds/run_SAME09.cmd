cat SAME09_samples.txt |  parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_SAME09.sh \
{}
"

