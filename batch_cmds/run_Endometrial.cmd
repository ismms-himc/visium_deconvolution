# Endometrium batch 1
(cat << EOF
SAGN24_CWWG9X03301_0_v2
SAGN24_CWWGBLDXZ01_0_v2
SAGN24_CWWGDOKY201_0_v2
SAGN24_CWWGPV5TY01_0_v2
SAGN24_CWWGSPZZX01_0_v2
SAGN24_CWWGTQ4PT01_0_v2
SAGN24_CWWGUKK5E01_0_v2
SAGN24_CWWGUVJF701_0_v2
EOF
) |  parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_Endometrial.sh \
/sc/arion/projects/HIMC/himc-project-data/SAGN24/data/10X/{}
"

# failed samples

cat failed.Endometrium.samples | parallel --dryrun -j1 -k \
"
/sc/arion/projects/HIMC/nextflow/visium_deconvolution/batch_cmds/run_Endometrial.sh \
{}
"

# re-run spotlight

cut -d, -f1 Endometrium.samples  | parallel --dryrun -j1 -k "sh run_Endometrial_spotlight.sh {}"

# run non-annotated sinem samples 
# June 29,2023
tail -n+22 Endometrium.samples  | parallel --dryrun -j1 -k "sh run_Endometrial.sh {}"

# August 28, 2023

tail -n+50 Endometrium.samples | parallel --dryrun -j1 -k "sh run_Endometrial.sh {}"

# December 11, 2023, new reference
cat Endometrium.samples | parallel --dryrun -j1 -k "sh run_Endometrial.sh {}"
