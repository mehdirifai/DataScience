# -*- coding: utf-8 -*-
"""
Created on Sun Jun 21 14:53:27 2015

@author: mehdirifai
"""
import numpy as np
import pandas as pd
import seaborn


data = pd.read_csv('namefile',delimiter=',') 

## plot correlation matrix

seaborn.corrplot(data, sig_stars=True, annot= False, sig_tail='both', sig_corr=False, cmap=None, cmap_range=None, cbar=True, diag_names=True, method='spearman', ax=None)
plt.savefig('correlation_spearman_matrix.png')