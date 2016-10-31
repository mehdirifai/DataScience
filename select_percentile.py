# -*- coding: utf-8 -*-
"""
Created on Sun Dec 28 19:54:54 2014

@author: mehdirifai
"""


import pandas as pd
import numpy as np
from sklearn import cross_validation
from sklearn import datasets
from sklearn import svm
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_classif
import matplotlib.pyplot as plt
from sklearn import svm, datasets
from sklearn.metrics import roc_curve, auc
from sklearn.cross_validation import train_test_split
from sklearn.preprocessing import label_binarize
from sklearn.multiclass import OneVsRestClassifier
from sklearn.cross_validation import StratifiedKFold

 
import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm, datasets, feature_selection, cross_validation
from sklearn.pipeline import Pipeline

###############################################################################
# Import the data

dataset = pd.read_csv("data_with_SW.csv")

mean = sum(list(dataset["InferredScore60Final"]*dataset["SampleWeight"]/sum(list(dataset["SampleWeight"]))))

dataset.InferredScore60Final[dataset["InferredScore60Final"] <= mean] = 0
dataset.InferredScore60Final[dataset["InferredScore60Final"] > mean] = 1

y = dataset['InferredScore60Final']

# Throw away data, to be in the curse of dimension settings

X = pd.read_csv('data_2nd_approach.csv')
X.drop("InferredScore60Final",inplace=True,axis=1)


###############################################################################
# Create a feature-selection transform and an instance of SVM that we
# combine together to have an full-blown estimator

transform = feature_selection.SelectPercentile(feature_selection.f_classif)

clf = Pipeline([('anova', transform), ('svc', svm.SVC(kernel='rbf',C=1.0))])

###############################################################################
# Plot the cross-validation score as a function of percentile of features
score_means = list()
score_stds = list()
percentiles = (0.5, 1, 1.5, 2, 3, 4, 5, 10, 20, 40, 70, 100)


for percentile in percentiles:
    clf.set_params(anova__percentile=percentile)
    # Compute cross-validation score using all CPUs
    this_scores = cross_validation.cross_val_score(clf, X, y, n_jobs=1)
    score_means.append(this_scores.mean())
    print score_means
    score_stds.append(this_scores.std())

plt.errorbar(percentiles, score_means, np.array(score_stds))

plt.title(
    'Performance of the SVM-Anova varying the percentile of features selected')
plt.xlabel('Percentile')
plt.ylabel('Prediction rate')
plt.axis('tight')
plt.savefig('Performance of the SVM-Anova varying the percentile of features.png')
plt.show()