# -*- coding: utf-8 -*-
"""
Created on Fri Feb 20 21:40:21 2015

@author: mehdirifai
"""


## import all the libraries needed
import pandas as pd
import numpy as np
from sklearn import cross_validation
from sklearn import datasets
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_classif
import matplotlib.pyplot as plt
from sklearn import svm, datasets
from sklearn.metrics import roc_curve, auc
from sklearn.cross_validation import train_test_split
from sklearn.preprocessing import label_binarize
from sklearn.multiclass import OneVsRestClassifier
from sklearn.cross_validation import StratifiedKFold
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.cross_validation import KFold


## import the dataset
dataset = pd.read_csv("data_with_SW.csv")

## binarize the InferredScore column
mean = sum(list(dataset["InferredScore60Final"]*dataset["SampleWeight"]/sum(list(dataset["SampleWeight"]))))

dataset.InferredScore60Final[dataset["InferredScore60Final"] <= mean] = 0
dataset.InferredScore60Final[dataset["InferredScore60Final"] > mean] = 1

## split the predictors and the response
y = dataset['InferredScore60Final']
X = dataset
X.drop('InferredScore60Final', inplace= True, axis =1)
 
 
## get rid of the excluded columns
Date = list(pd.read_csv('DateExcludeList.csv')['x'])
Meta = list(pd.read_csv('MetaExcludeList.csv')['x'])
Score = list(pd.read_csv('ScoreExcludeList.csv')['x'])
Perf = list(pd.read_csv('PerfExcludeList.csv')['x'])

Exclude = Date+Meta+Score+Perf


X.drop(Exclude,inplace=True,axis=1)

## create a Boosting function

def Boosting(X,y,a,b,c):
# shuffle and split training and test sets
    s=0
    y = label_binarize(y, classes = [0,1])
    n_classes = y.shape[1]
    n_classes
    kf = KFold(51759, n_folds=a)
    k=0
    for train, test in kf:
        k+=1
        X_train = np.array(X)[train]
        y_train = np.array(y)[train]
        X_test = np.array(X)[test]
        y_test = np.array(y)[test]
# predict each the response using a gradient boosting classifier
        classifier = GradientBoostingClassifier(n_estimators=b, learning_rate=c, max_depth=1, random_state=0)
        y_score = classifier.fit(X_train, y_train).decision_function(X_test)
        


# Compute ROC curve and ROC area for each class
        fpr = dict()
        tpr = dict()
        roc_auc = dict()
        fpr[0], tpr[0], _ = roc_curve(y_test[:, 0], y_score[:, 0])
        roc_auc[0] = auc(fpr[0], tpr[0])

# Compute micro-average ROC curve and ROC area
        fpr["micro"], tpr["micro"], _ = roc_curve(y_test.ravel(), y_score.ravel())
        roc_auc["micro"] = auc(fpr["micro"], tpr["micro"])
        s = s+ 2*(roc_auc['micro']-0.5)
# Plot of a ROC curve 
        plt.figure()
        plt.plot(fpr[0], tpr[0], label='fold {0}'.format(k)+' (area = %0.2f)' % roc_auc[0])
        plt.plot([0, 1], [0, 1], 'k--')
        plt.xlim([0.0, 1.0])
        plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('ROC curve boosting')
    plt.legend(loc="lower right") 
    plt.savefig('ROC {0}'.format(k))
    plt.show()
    
## return the average gini coefficient
    return [s/a,b,c]


## create a function that extract the features from selectKbest
columns = list(X.columns.values)

def list_feature(array):
    get_Kpredictors=[]
    for i in range(len(array)):
        if array[i]:
            get_Kpredictors=get_Kpredictors+[columns[i]]
    return get_Kpredictors



## build the dataset that we are going to use in boosting with selectKbest
predictor_selection = SelectKBest(f_classif, k = 500).fit(X , y)
array = predictor_selection.get_support()
data_dic = {}
for i in list_feature(array):
    data_dic[i] = dataset[i]
data_frame = pd.DataFrame(data_dic)

## list of parameters that we are testing

shrinkage = [0.001,0.01,0.1]
trees = [500,1000,2000,3000,4000]

## store the results in a list
results=[] 
for s in shrinkage:
    for t in trees:
        results+= [Boosting(data_frame,y,3,t,s)]
        print results