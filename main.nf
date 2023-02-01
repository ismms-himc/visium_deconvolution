/* 
 * pipeline input parameters 
 */
//params.rna_h5ad = "$baseDir/example_data/starmap_sc_rna.h5ad"
//params.spatial_h5ad = "$baseDir/example_data/starmap_spatial.h5ad"
params.rna_h5ad = "/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5ad"
params.rna_h5Seurat = "/sc/arion/projects/HIMC/reference/single_cell_references/Melanoma_combined_reference/melanoma_combine_reference.h5ad"
params.spatial_h5ad = "/sc/arion/projects/HIMC/himc-project-data/SEK10/data/10X/SEK10_42722_0_v3"
params.celltype_key = "celltype"
params.c2l_batch = "None"
params.c2l_covariates = "None"
params.c2l_cellsPerSpot = 30
params.outdir = "."
params.outdir_final = "$baseDir/nextflow_testing/42722"
params.tools='cell2location, tangram, seurat, stereoscope, spotlight, destvi, spatialdwls'

log.info """\
         D E C O N V O L U T I O N   P I P E L I N E    
         ===========================================
         rna_h5ad     : ${params.rna_h5ad}
         spatial_h5ad : ${params.spatial_h5ad}
         celltype_key : ${params.celltype_key}
         outdir       : ${params.outdir}
         """
         .stripIndent()

rna_h5ad = file(params.rna_h5ad)
rna_h5Seurat = file(params.rna_h5Seurat)
spatial_h5ad = file(params.spatial_h5ad)
 
/* 
 * define the `index` process that create a binary index 
 * given the transcriptome file
 */
process cell2location {
    label 'gpu'
    errorStrategy 'ignore'
    publishDir "$params.outdir_final/", mode: 'copy'
    
    input:
    file rna_h5ad from rna_h5ad
    file spatial_h5ad from spatial_h5ad
    val celltype_key from params.celltype_key
    val c2l_batch from params.c2l_batch
    val c2l_covariates from params.c2l_covariates
    val c2l_cellsPerSpot from params.c2l_cellsPerSpot
    params.outdir
    params.tools

    when:
    params.tools.contains('cell2location')
     
    output:
    path 'Cell2location_result.txt' into cell2location_ch

    script:       
    """
    python \
    $baseDir/bin/Cell2location_pipeline.py \
    $rna_h5ad \
    $spatial_h5ad \
    $celltype_key \
    $c2l_batch \
    $c2l_covariates \
    $c2l_cellsPerSpot \
    $params.outdir
    """
}

process tangram {
    label 'gpu'
    errorStrategy 'ignore'
    publishDir "$params.outdir_final/", mode: 'copy'

    
    input:
    file rna_h5ad from rna_h5ad
    file spatial_h5ad from spatial_h5ad
    val celltype_key from params.celltype_key
    params.outdir
    params.tools

    when:
    params.tools.contains('tangram')
     
    output:
    path 'Tangram_result.txt' into tangram_ch

    script:
    """
    python \
    $baseDir/bin/Tangram_pipeline.py \
    $rna_h5ad \
    $spatial_h5ad \
    $celltype_key \
    $params.outdir
    """
}

process destvi {
    label 'gpu'
    errorStrategy 'ignore'
    publishDir "$params.outdir_final/", mode: 'copy'

    
    input:
    file rna_h5ad from rna_h5ad
    file spatial_h5ad from spatial_h5ad
    val celltype_key from params.celltype_key
    params.outdir
    
    when:
    params.tools.contains('destvi')
     
    output:
    path 'DestVI_result.txt' into destvi_ch

    script:
    """
    python \
    $baseDir/bin/DestVI_pipeline.py \
    $rna_h5ad \
    $spatial_h5ad \
    $celltype_key \
    $params.outdir
    """
}

process stereoscope {
    label 'gpu'
    errorStrategy 'ignore'
    publishDir "$params.outdir_final/", mode: 'copy'

    
    input:
    file rna_h5ad from rna_h5ad
    file spatial_h5ad from spatial_h5ad
    val celltype_key from params.celltype_key
    params.outdir
    params.tools

    when:
    params.tools.contains('stereoscope')
     
    output:
    path 'Stereoscope_result.txt' into stereoscope_ch

    script:
    """
    python \
    $baseDir/bin/Stereoscope_pipeline.py \
    $rna_h5ad \
    $spatial_h5ad \
    $celltype_key \
    $params.outdir
    """
}

process seurat {
    label 'non_gpu'
    errorStrategy 'ignore'
    publishDir "$params.outdir_final/", mode: 'copy'

    
    input:
    file rna_h5Seurat from rna_h5Seurat
    file spatial_h5ad from spatial_h5ad
    val celltype_key from params.celltype_key
    params.outdir
    params.tools

    when:
    params.tools.contains('seurat')
     
    output:
    path 'Seurat_result.txt' into seurat_ch

    script:
    """
    Rscript \
    $baseDir/bin/Seurat_pipeline.r \
    $rna_h5Seurat \
    $spatial_h5ad \
    $celltype_key \
    $params.outdir
    """
}

process spotlight {
    label 'non_gpu'
    errorStrategy 'ignore'
    publishDir "$params.outdir_final/", mode: 'copy'

    
    input:
    file rna_h5Seurat from rna_h5Seurat
    file spatial_h5ad from spatial_h5ad
    val celltype_key from params.celltype_key
    params.outdir
    params.tools

    when:
    params.tools.contains('spotlight')
     
    output:
    path 'SPOTlight_result.txt' into spotlight_ch

    script:
    """
    Rscript \
    $baseDir/bin/SPOTlight_pipeline_2.r \
    $rna_h5Seurat \
    $spatial_h5ad \
    $celltype_key \
    $params.outdir
    """
}

 
process spatialdwls {
    label 'non_gpu'
    errorStrategy 'ignore'
    publishDir "$params.outdir_final/", mode: 'copy'

    
    input:
    file rna_h5Seurat from rna_h5Seurat
    file spatial_h5ad from spatial_h5ad
    val celltype_key from params.celltype_key
    params.outdir
    params.tools

    when:
    params.tools.contains('spatialdwls')
     
    output:
    path 'SpatialDWLS_result.txt' into spatialdwls_ch

    script:
    """
    Rscript \
    $baseDir/bin/SpatialDWLS_pipeline.r \
    $rna_h5Seurat \
    $spatial_h5ad \
    $celltype_key \
    $params.outdir
    """
}
