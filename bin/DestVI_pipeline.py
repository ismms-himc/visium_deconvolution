import scanpy as sc
import numpy as np
import pandas as pd

import scvi
from scvi.model import CondSCVI, DestVI

import sys
import os

import python_helper_functions as phf
import matplotlib.pyplot as plt

scrna_path = sys.argv[1]
spatial_path = sys.argv[2]
celltype_key = sys.argv[3]
output_path = sys.argv[4]
is_test = sys.argv[5]

st_adata = sc.read_visium(spatial_path)
st_adata.var_names_make_unique()
if is_test != "False":
  print('Downsampling for testing')
  st_adata = phf.downsample(st_adata)


sc_adata = sc.read_h5ad(scrna_path)

# DestVI always takes raw counts as input
# Pull out raw data and not log transformed normalized data
sc_adata = phf.get_raw_counts(sc_adata)

# filter low celltype counts
celltype_counts = sc_adata.obs[celltype_key].value_counts()
celltype_drop = celltype_counts.index[celltype_counts <= 10]
print(f'Drop celltype {list(celltype_drop)} contain less 10 sample')
sc_adata = sc_adata[~sc_adata.obs[celltype_key].isin(celltype_drop),].copy()

# filter data with 0 cell coutns
sc.pp.filter_cells(sc_adata, min_counts=1)

# filter genes to be the same on the spatial data (Why is this here, already
# a step below....)
#intersect = np.intersect1d(sc_adata.var_names, st_adata.var_names)
#st_adata = st_adata[:, intersect].copy()
#sc_adata = sc_adata[:, intersect].copy()
#G = len(intersect)

# let us filter some genes (changing from 2000 to 4000 resolves nan error
# in st_model.train(max_epochs=2500) 
#G = 2000
#G = 7000 # still fails for some samples
G = 10000 # still fails for some samples
sc.pp.filter_genes(sc_adata, min_counts=10)

sc_adata.layers["counts"] = sc_adata.X.copy()

sc.pp.highly_variable_genes(
    sc_adata,
    n_top_genes=G,
    subset=True,
    layer="counts",
    flavor="seurat_v3"
)

sc.pp.normalize_total(sc_adata, target_sum=10e4)
sc.pp.log1p(sc_adata)
sc_adata.raw = sc_adata

st_adata.layers["counts"] = st_adata.X.copy()
sc.pp.normalize_total(st_adata, target_sum=10e4)
sc.pp.log1p(st_adata)
st_adata.raw = st_adata

# filter genes to be the same on the spatial data
intersect = np.intersect1d(sc_adata.var_names, st_adata.var_names)
st_adata = st_adata[:, intersect].copy()
sc_adata = sc_adata[:, intersect].copy()
G = len(intersect)

scvi.model.CondSCVI.setup_anndata(sc_adata, layer="counts", labels_key=celltype_key)
sc_model = CondSCVI(sc_adata, weight_obs=True)
sc_model.train(max_epochs=400,lr=0.001) # use defaults
sc_model.history["elbo_train"].plot()
scvi.model.DestVI.setup_anndata(st_adata, layer="counts")
st_model = DestVI.from_rna_model(st_adata, sc_model)
st_model.train(max_epochs=2500)
st_model.history["elbo_train"].plot()
#plot.savefig(output_path + '/DestVI_elbow.png')
st_model.get_proportions().to_csv(output_path + '/DestVI_result.txt')

# plot proportions
st_adata.obsm["proportions"] = st_model.get_proportions()
ct_list = st_adata.obsm["proportions"].columns.tolist()
for ct in ct_list:
  data = st_adata.obsm["proportions"][ct].values
  st_adata.obs[ct] = np.clip(data, 0, np.quantile(data, 0.99))
plt.rcParams["figure.figsize"] = (8, 8)
sc.settings.figdir = output_path + '/figures'
sc.pl.embedding(st_adata, basis="spatial", color=ct_list, cmap="Reds", s=80,
    save="_DestVI_spatial_proportions.pdf")
