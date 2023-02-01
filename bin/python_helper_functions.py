import numpy as np

def check_nonnegative_integers(X):
    """
    Checks values of X to ensure it is count data
    From scanpy https://github.com/scverse/scanpy/blob/d26be443373549f26226de367f0213f153556915/scanpy/_utils/__init__.py#L487
    """
    from numbers import Integral

    data = X if isinstance(X, np.ndarray) else X.data
    # Check no negatives
    if np.signbit(data).any():
        return False
    # Check all are integers
    elif issubclass(data.dtype.type, Integral):
        return True
    elif np.any(~np.equal(np.mod(data, 1), 0)):
        return False
    else:
        return True

def get_raw_counts(adata):
  if check_nonnegative_integers(adata.X):
    adata.layers["counts"] = adata.X.copy()
  elif adata.raw:
    if check_nonnegative_integers(adata.raw.to_adata().X):
      adata.layers["counts"] = adata.raw.to_adata().X.copy()
      adata.layers["log_counts"] = adata.X.copy()
      adata.X = adata.raw.to_adata().X.copy()
  return adata
