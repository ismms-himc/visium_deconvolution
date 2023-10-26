#TODO figure out how to save figures

import sys
#sys.path.insert(1, '/opt/conda/envs/cell2loc_env/lib/python3.7/site-packages')
import scanpy as sc
import anndata
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
import subprocess

import os

import cell2location
import scvi

from matplotlib import rcParams
rcParams['pdf.fonttype'] = 42 # enables correct plotting of text
import seaborn as sns
from scipy.sparse import csr_matrix
from cell2location.utils.filtering import filter_genes
import python_helper_functions as phf

sc_file_path = sys.argv[1]
spatial_file_path = sys.argv[2]
celltype_key = sys.argv[3]
batch_key = None if sys.argv[4] == 'None' else sys.argv[4]
categorical_covariate_keys = None if sys.argv[5] == 'None' else [sys.argv[5]] #list
N_cells_per_location = round(int(float(sys.argv[6])))
output_file_path = sys.argv[7]

os.makedirs(output_file_path, exist_ok = True)

print(sc.__version__)
print(str(sc))
adata_snrna_raw = sc.read_h5ad(sc_file_path)
print(adata_snrna_raw)

# Remove low expressing genes in Visium Data
# See 2D https://cell2location.readthedocs.io/en/latest/commonerrors.html
adata_vis = sc.read_visium(spatial_file_path)
adata_vis.var_names_make_unique()


#adata_snrna_raw.X = csr_matrix(adata_snrna_raw.X)
#if phf.check_nonnegative_integers(adata_snrna_raw.X):
#  adata_snrna_raw.layers["counts"] = adata_snrna_raw.X.copy()
#  adata_snrna_raw.X = csr_matrix(adata_snrna_raw.X)
#if adata_snrna_raw.raw:
#  if phf.check_nonnegative_integers(adata_snrna_raw.raw.to_adata().X):
#    print('using raw counts in adata_sc.raw')
#    adata_snrna_raw.layers["counts"] = adata_snrna_raw.raw.to_adata().X.copy()
#    adata_snrna_raw.layers["log_counts"] = adata_snrna_raw.X.copy()
#    adata_snrna_raw.X = csr_matrix(adata_snrna_raw.raw.to_adata().X.copy())

adata_snrna_raw = phf.get_raw_counts(adata_snrna_raw)
adata_vis.X = csr_matrix(adata_vis.X)

# Lu932 specifically
if spatial_file_path=='/sc/arion/projects/HIMC/software/jupyter_debarcoding/projects/VisiumFFPEInternal/sinem_files/Lu932/tangram/SEKI10_Lu932_1_v4_for_tangram.h5ad':
  adata_vis.var_names_make_unique()
  adata_vis.obs['sample'] = list(adata_vis.uns['spatial'].keys())[0]

adata_snrna_raw = adata_snrna_raw[~adata_snrna_raw.obs[celltype_key].isin(np.array(adata_snrna_raw.obs[celltype_key].value_counts()[adata_snrna_raw.obs[celltype_key].value_counts() <=1].index))]

# remove cells and genes with 0 counts everywhere
sc.pp.filter_genes(adata_snrna_raw,min_cells=1)
sc.pp.filter_cells(adata_snrna_raw,min_genes=1)

adata_snrna_raw.obs[celltype_key] = pd.Categorical(adata_snrna_raw.obs[celltype_key])
adata_snrna_raw = adata_snrna_raw[~adata_snrna_raw.obs[celltype_key].isna(), :]

selected = filter_genes(adata_snrna_raw, cell_count_cutoff=5, cell_percentage_cutoff2=0.03, nonz_mean_cutoff=1.12)
#selected.savefig('filter_genes.png')

# filter the object
print(adata_snrna_raw.shape)
adata_snrna_raw = adata_snrna_raw[:, selected].copy()
print(adata_snrna_raw.shape)

cell2location.models.RegressionModel.setup_anndata(
    adata=adata_snrna_raw,
    # cell type, covariate used for constructing signatures
    labels_key=celltype_key,
    # 10X reaction / sample / batch
    batch_key=batch_key,
    # multiplicative technical effects (platform, 3' vs 5', donor effect)
    categorical_covariate_keys=categorical_covariate_keys
    )

# create and train the regression model
from cell2location.models import RegressionModel
mod = RegressionModel(adata_snrna_raw)

# Use all data for training (validation not implemented yet, train_size=1)
# CHANGE BACK max_epochs to 250
mod.train(max_epochs=250, batch_size=2500, train_size=1, lr=0.002, use_gpu=True)

# plot ELBO loss history during training, removing first 20 epochs from the plot
#fig = mod.plot_history(20)
#fig.savefig(output_file_path + '/ELBO_loss_history.png')

'''
Show quality control plots: 1. Reconstruction accuracy to assess if there are
any issues with model training

The plot should be roughly diagonal, strong deviations signal problems that
need to be investigated. Plotting is slow because expected value of mRNA count
needs to be computed from model parameters. Random observations are used to
speed up computation.
'''
#fig = mod.plot_QC()
#fig.savefig(output_file_path + '/QC_plots.png')

# In this section, we export the estimated cell abundance (summary of the posterior distribution).
adata_snrna_raw = mod.export_posterior(
    adata_snrna_raw, sample_kwargs={'num_samples': 1000, 'batch_size': 2500, 'use_gpu': True}
)

# export estimated expression in each cluster
if 'means_per_cluster_mu_fg' in adata_snrna_raw.varm.keys():
    inf_aver = adata_snrna_raw.varm['means_per_cluster_mu_fg'][[f'means_per_cluster_mu_fg_{i}'
                                    for i in adata_snrna_raw.uns['mod']['factor_names']]].copy()
else:
    inf_aver = adata_snrna_raw.var[[f'means_per_cluster_mu_fg_{i}'
                                    for i in adata_snrna_raw.uns['mod']['factor_names']]].copy()
inf_aver.columns = adata_snrna_raw.uns['mod']['factor_names']
inf_aver.iloc[0:5, 0:5]

intersect = np.intersect1d(adata_vis.var_names, inf_aver.index)
adata_vis = adata_vis[:, intersect].copy()
inf_aver = inf_aver.loc[intersect, :].copy()

# prepare anndata for cell2location model
#scvi.data.setup_anndata(adata=adata_vis)
cell2location.models.Cell2location.setup_anndata(adata=adata_vis)
#scvi.data.view_anndata_setup(adata_vis)

# create and train the model
mod = cell2location.models.Cell2location(
    adata_vis, cell_state_df=inf_aver,
    # the expected average cell abundance: tissue-dependent
    # hyper-prior which can be estimated from paired histology:
    N_cells_per_location=N_cells_per_location,
    # hyperparameter controlling normalisation of
    # within-experiment variation in RNA detection (using default here):
    detection_alpha=200
)

# CHANGE BACK TO 30000
mod.train(max_epochs=30000,
          # train using full data (batch_size=None)
          batch_size=None,
          # use all data points in training because
          # we need to estimate cell abundance at all locations
          train_size=1,
          use_gpu=True)

# plot ELBO loss history during training, removing first 100 epochs from the plot
#fig = mod.plot_history(1000)
#plt.legend(labels=['full data training'])
#fig.savefig('ELBO_loss_history_full_data_training.png')


adata_vis = mod.export_posterior(
    adata_vis, sample_kwargs={'num_samples': 1000, 'batch_size': mod.adata.n_obs, 'use_gpu': True}
)
print(adata_vis)
adata_vis.obsm['q05_cell_abundance_w_sf'].to_csv(output_file_path + '/Cell2location_result.txt')
