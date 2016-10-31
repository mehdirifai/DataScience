# -*- coding: utf-8 -*-
"""
Created on Sun Jun 21 14:59:34 2015

@author: mehdirifai
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


from sklearn import linear_model, decomposition, datasets
from sklearn.pipeline import Pipeline
from sklearn.grid_search import GridSearchCV

data = pd.read_csv('pred.csv',delimiter=',') 
columns = list(data.columns.values)

# plot the distribution of the predictors using histograms
for col in columns:
    fig, ax = plt.subplots()
    data[col].hist()
    plt.title(col+'distribution')
    plt.savefig(col)


## explained variance pca

from sklearn.decomposition import PCA
pca = PCA(n_components=2)
pca.fit(data)
PCA(copy=True, n_components=2, whiten=False)
print(pca.explained_variance_ratio_) 

pca.fit(data)

plt.figure(1, figsize=(4, 3))
plt.clf()
plt.axes([.2, .2, .7, .7])
plt.plot(pca.explained_variance_, linewidth=2)
plt.axis('tight')
plt.xlim([0,10])
plt.xlabel('n_components')
plt.ylabel('explained_variance_')

## plotted pca along 2 components

## 1st method through matplotlib
from matplotlib.mlab import PCA as mlabPCA
 
mlab_pca = mlabPCA(data) 

print('PC axes in terms of the measurement axes scaled by the standard deviations:\n', mlab_pca.Wt)

plt.plot(mlab_pca.Y[:,0],mlab_pca.Y[:,1], 
         'o', markersize=7, color='blue', alpha=0.5, label='class1')


plt.xlabel('x_values')
plt.ylabel('y_values')
plt.xlim([-4,4])
plt.ylim([-4,4])
plt.legend()
plt.title('Transformed samples with class labels from matplotlib.mlab.PCA()')

plt.show()


## 2nd method through sklearn
from sklearn.decomposition import PCA as sklearnPCA

sklearn_pca = sklearnPCA(n_components=2)
sklearn_transf = sklearn_pca.fit_transform(data)

plt.plot(sklearn_transf[:,0],sklearn_transf[:,1], 
         'o', markersize=7, color='blue', alpha=0.5, label='class1')

plt.xlabel('x_values')
plt.ylabel('y_values')
plt.xlim([-4,4])
plt.ylim([-4,4])
plt.legend()
plt.title('Transformed samples using sklearn.decomposition.PCA()')
plt.show()

### http://sebastianraschka.com/Articles/2014_pca_step_by_step.html#mat_pca

