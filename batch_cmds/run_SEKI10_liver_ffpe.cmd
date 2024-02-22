cat SEKI10_liver_ffpe.txt |  parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_SEKI10_liver_ffpe.sh \
{}
"
