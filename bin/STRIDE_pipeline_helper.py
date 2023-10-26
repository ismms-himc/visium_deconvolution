import scanpy as sc
import sys
import pandas as pd

scrna_path=sys.argv[1]
spatial_path=sys.argv[2]
celltype_key=sys.argv[3]
output_path=sys.argv[4]

# save cell type column for STRIDE
adata = sc.read_h5ad(scrna_path)
adata.obs[celltype_key].to_csv(output_path + '/STRIDE_out/celltype.txt', sep='\t', header=False)
del adata

# save spatial coordinates 
adata = sc.read_visium(spatial_path)
#df = pd.DataFrame(adata.obsm['spatial'])
#df.index = adata.index
#df.columns = ['row','column']
df = adata.obs.copy()
df = df.drop(columns=['in_tissue'])
df.to_csv(output_path + '/STRIDE_out/coor.txt', sep='\t', header=True)
