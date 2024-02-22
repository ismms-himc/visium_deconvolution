cat Endometrium.samples | cut -d, -f1 | parallel -j1 -k "ls -d {}/deconvolution/endometrial_curated_Vladimir/Cell2location_result.txt || echo {}" | grep -v Cell2location_result.txt > failed.Endometrium.samples
cat BICRC.samples | cut -d, -f1 | parallel -j1 -k "ls -d {}/deconvolution/CRC_curated_Vladimir/Cell2location_result.txt || echo {}" | grep -v Cell2location_result.txt > failed.BICRC.samples
cat Lung.samples | cut -d, -f1 | parallel -j1 -k "ls -d {}/deconvolution/Lung_curated_Vladimir/Cell2location_result.txt || echo {}" | grep -v Cell2location_result.txt > failed.Lung.samples

cat Lung.samples | cut -d, -f1 | parallel -j1 -k "ls -d {}/deconvolution/andrewLeader_plus_GSE131907_lung/Cell2location_result.txt || echo {}" | grep -v Cell2location_result.txt > failed.Lung.samples
cat BICRC.samples | cut -d, -f1 | parallel -j1 -k "ls -d {}/deconvolution/CRC_immune_hubs/Cell2location_result.txt || echo {}" | grep -v Cell2location_result.txt > failed.BICRC.samples
cat Melanoma.samples | cut -d, -f1 | parallel -j1 -k "ls -d {}/deconvolution/Melanoma_cutaneous_GSE215121/Cell2location_result.txt || echo {}" | grep -v Cell2location_result.txt > failed.Melanoma.samples



cat Endometrium.samples | tail -n+22 | cut -d, -f1 | parallel -j1 -k "ls -d {}/deconvolution/endometrial_curated_Vladimir/Cell2location_result.txt || echo {}" | grep -v Cell2location_result.txt > failed.Endometrium.samples
