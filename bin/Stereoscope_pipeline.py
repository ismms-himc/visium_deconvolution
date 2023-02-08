#import sys 
#sys.path.insert(1, '/opt/conda/envs/stereoscope/lib/python3.7/site-packages')
# USE DESTVI SINGULARITY IMAGE!!!
import scanpy as sc
import numpy as np
import pandas as pd

import scvi
from scvi.external import RNAStereoscope, SpatialStereoscope

import python_helper_functions as phf

import sys

import os
np.random.seed()
def get_freer_gpu():
    os.system('nvidia-smi -q -d Memory |grep -A4 GPU|grep Free >tmp')
    memory_available = [int(x.split()[2]) for x in open('tmp', 'r').readlines()]
    max_idx = np.where(memory_available == np.max(memory_available))[0]
    return np.random.permutation(max_idx)[0]
#os.environ['CUDA_VISIBLE_DEVICES'] = str(get_freer_gpu())


scrna_path = sys.argv[1]
spatial_path = sys.argv[2]
celltype_key = sys.argv[3]
output_path = sys.argv[4]

sc_adata = sc.read_h5ad(scrna_path)
st_adata = sc.read_visium(spatial_path)
st_adata.var_names_make_unique()

sc.pp.filter_genes(sc_adata, min_counts = 10)
sc.pp.filter_cells(sc_adata, min_counts = 10)

non_mito_genes_list = [name for name in sc_adata.var_names if not name.startswith('MT-')]
sc_adata = sc_adata[:, non_mito_genes_list]

# Pull out raw data and not log transformed normalized data
sc_adata = phf.get_raw_counts(sc_adata)

sc.pp.normalize_total(sc_adata, target_sum = 1e5)
sc.pp.log1p(sc_adata)
sc_adata.raw = sc_adata

sc.pp.highly_variable_genes(
    sc_adata,
    n_top_genes = 7000,
    subset=True,
    layer="counts",
    flavor="seurat_v3",
    span = 1
)

intersect = np.intersect1d(sc_adata.var_names, st_adata.var_names)
st_adata = st_adata[:, intersect].copy()
sc_adata = sc_adata[:, intersect].copy()

RNAStereoscope.setup_anndata(sc_adata, layer = "counts", labels_key = celltype_key)

stereo_sc_model = RNAStereoscope(sc_adata)
stereo_sc_model.train(max_epochs = 100)
stereo_sc_model.history["elbo_train"][10:].plot()

st_adata.layers["counts"] = st_adata.X.copy()
SpatialStereoscope.setup_anndata(st_adata, layer="counts")

spatial_model = SpatialStereoscope.from_rna_model(st_adata, stereo_sc_model)
spatial_model.train(max_epochs = 10000)
spatial_model.history["elbo_train"][10:].plot()

spatial_model.get_proportions().to_csv(output_path + '/Stereoscope_result.txt')
st_adata.obsm["deconvolution"] = spatial_model.get_proportions()

ct_list= st_adata.obsm["deconvolution"].columns.tolist()
for ct in ct_list:
  data = st_adata.obsm["deconvolution"][ct].values
  st_adata.obs[ct] = np.clip(data, 0, np.quantile(data, 0.99))

plt.rcParams["figure.figsize"] = (8, 8)
sc.settings.figdir = output_path + '/figures'
sc.pl.embedding(st_adata, basis="spatial", color=ct_list, cmap="Reds",s=80,
              save_fig="_Stereoscope_spatial.jpg")
