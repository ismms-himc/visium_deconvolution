scrna_path=$1
spatial_path=$2
celltype_key=$3
output_path=$4

dir_path=`dirname $scrna_path`
dataset=`echo $dir_path | rev | cut -d/ -f1 | rev`

#get celltype path
mkdir -vp $output_path/STRIDE_out
python3 bin/STRIDE_pipeline_helper.py \
 $scrna_path \
 $spatial_path \
 $celltype_key \
 $output_path
celltype_path=$output_path/STRIDE_out/celltype.txt

prefix='STRIDE'
echo $dataset
echo $celltype_path
STRIDE deconvolve --sc-count $scrna_path \
--sc-celltype $celltype_path \
--st-count ${spatial_path}/filtered_feature_bc_matrix.h5 \
--outdir $output_path/STRIDE_out --outprefix $prefix --normalize

cp -f $output_path/STRIDE_out/STRIDE_spot_celltype_frac.txt $output_path/STRIDE_result.txt
rm -f $celltype_path

# plot
STRIDE plot \
  --deconv-file $output_path/STRIDE_out/STRIDE_spot_celltype_frac.txt \
  --st-loc coor.txt \
  --plot-type scatterpie \
  --pt-size 12 --outdir $output_path/STRIDE_out
