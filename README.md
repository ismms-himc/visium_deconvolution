Deconvolution of 10x Visium data using the tools below
* Cell2Location
* RCTD
* Stereoscope
* Seurat
* SPOTlight
* Tangram
* CARD
* STRIDE
* SpatialDWLS


Example usage

```
nextflow run main.nf \
  --rna_h5ad /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung.h5ad \ # Reference scanpy h5ad object
  --rna_h5Seurat /sc/arion/projects/HIMC/reference/single_cell_references/andrewLeader_plus_GSE131907_lung/andrewLeader_plus_GSE131907_lung.rds \ # Reference seurat or RDS object
  --outdir_final /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_40765_0_v5/deconvolution/andrewLeader_plus_GSE131907_lung/ \ # Save output location
  --spatial_h5ad /sc/arion/projects/HIMC/himc-project-data/SAGN29/data/10X/SAGN29_40765_0_v5 \ # Visium dataset
  --celltype_key Cell_type_final \ # Column in to use in Reference
  --c2l_batch Sample \ # Cell2Locaton Batch argument OPTIONAL
  --c2l_covariates Sample_Origin \ # Cell2Locaton Covariates argument OPTIONAL
  --c2l_cellsPerSpot 20 \ # Cell2Locaton Estimated Cells Per Spot argument OPTIONAL
  -w work/SAGN29_40765_0_v5 \
  -c nextflow.config
```

To run just one tool specify the argument below
```
  --tools RCTD
```

Or multiple tools (CAUTION can be buggy at times, would just run one tool instead of full user input
```
  --tools 'RCTD, Cell2Location'
```

Previous commands for huge batch (HCC, NSCLC, CRC etc.) can be found in 
```
batch_cmds/
```

The scripts are grouped by organ. For example NSCLC
```
# sample list can be found in
Lung.samples

# script to run per sample
run_Lung.sh

# batch command can be found here
run_Lung.cmd
```

Notes
* If want want to test the tool in an interactive session instead of submitting a job, change the config parameter
```
-c nextflow_local.config
```
* You can use the GPU nodes to run Cell2location
```
-c nextflow_c2la100.config
--tools cell2location
```
* Docker images were either created by me or found on DockerHub. Image locations can be viewed in
```
-c nextflow.config
```



