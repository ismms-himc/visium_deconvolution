cat MIME25_liver_oct.txt |  parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_MIME25_liver_oct.sh \
{}
"
