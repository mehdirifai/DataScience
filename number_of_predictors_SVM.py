# -*- coding: utf-8 -*-
"""
Created on Mon Jan  5 17:24:09 2015

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



dataset = pd.read_csv("data_with_SW.csv")

mean = sum(list(dataset["InferredScore60Final"]*dataset["SampleWeight"]/sum(list(dataset["SampleWeight"]))))

dataset.InferredScore60Final[dataset["InferredScore60Final"] <= mean] = 0
dataset.InferredScore60Final[dataset["InferredScore60Final"] > mean] = 1

y = dataset['InferredScore60Final']
X = dataset
X.drop('InferredScore60Final', inplace= True, axis =1)
 

def list_feature(array):
    get_Kpredictors=[]
    for i in range(len(array)):
        if array[i]:
            get_Kpredictors=get_Kpredictors+[columns[i]]
    return get_Kpredictors

def SVM(X,y,a):
# shuffle and split training and test sets
    y = label_binarize(y, classes = [0,1])
    n_classes = y.shape[1]
    n_classes
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=a,
                                                    random_state=0)

# predict each the response using a radial kernel svm
    classifier = OneVsRestClassifier(svm.SVC(kernel='rbf'))
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
    s = 2*(roc_auc['micro']-0.5)
# Plot of a ROC curve 
    plt.figure()
    plt.plot(fpr[0], tpr[0], label='ROC curve (area = %0.2f)' % roc_auc[0])
    plt.plot([0, 1], [0, 1], 'k--')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver operating characteristic example')
    plt.legend(loc="lower right") 
    plt.show()

## Now we crossvalidate by fitting the test dataset and predicting the training one
# predict each the response using a radial kernel svm
    classifier = OneVsRestClassifier(svm.SVC(kernel='rbf'))
    y_score = classifier.fit(X_test, y_test).decision_function(X_train)



# Compute ROC curve and ROC area for each class
    fpr = dict()
    tpr = dict()
    roc_auc = dict()
    fpr[0], tpr[0], _ = roc_curve(y_train[:, 0], y_score[:, 0])
    roc_auc[0] = auc(fpr[0], tpr[0])

# Compute micro-average ROC curve and ROC area
    fpr["micro"], tpr["micro"], _ = roc_curve(y_train.ravel(), y_score.ravel())
    roc_auc["micro"] = auc(fpr["micro"], tpr["micro"])
    s = s + 2*(roc_auc['micro']-0.5)
# Plot of a ROC curve 
    plt.figure()
    plt.plot(fpr[0], tpr[0], label='ROC curve (area = %0.2f)' % roc_auc[0])
    plt.plot([0, 1], [0, 1], 'k--')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver operating characteristic example')
    plt.legend(loc="lower right") 
    plt.show()
    print s/2


l = [5,10,15,20,30,40,50,75,100]
for j in  l:    
    columns = list(X.columns.values)
    predictor_selection = SelectKBest(f_classif, k = j).fit(X , y)
    array = predictor_selection.get_support()
    data_dic = {}
    for i in list_feature(array):
        data_dic[i] = dataset[i]
    data_frame = pd.DataFrame(data_dic) 
    SVM(data_frame,y,0.5)
  
## plotting the Gini coefficient as a function of the number of predictors for SVM
a = [0.239467824807,0.353012370722,0.346939932522,0.330913741833,0.27378886819,0.261765385426,0.25520709328,0.239391292498,0.2345309591] ## these values come from the SVM function results 
plt.figure()
plt.plot(l, a)
plt.xlim([5, 100])
plt.ylim([0.2, 0.4])
plt.xlabel('Number of predictors')
plt.ylabel('Gini coefficient')
plt.title('Gini as a function of the number of predictors')
plt.savefig('Gini as a function of the number of predictors')
plt.show()

## We can notice the peak in the Gini coefficient for 10-15 predictors it is lower for
## a lower and a higher number of predictors. It can be explained by the trade-off between
## the bias and the variance. High bias for a low number of predictors and a high variance 
## for a higher number of predictors 