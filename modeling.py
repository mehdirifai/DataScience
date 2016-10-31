# -*- coding: utf-8 -*-
"""
Created on Tue Aug 18 13:34:27 2015

@author: mrifai
"""
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
from sklearn.linear_model import LogisticRegression
from sklearn.cross_validation import KFold
import scipy.stats
from sklearn.feature_selection import SelectKBest
from sklearn.metrics import accuracy_score
from sklearn import metrics

data = pd.read_csv('Pythondata.csv',delimiter=',') 

data.drop('Unnamed: 0',inplace=True,axis=1)
        
y=data['TDC_flag']

data.drop('TDC_flag',inplace=True,axis=1)

# Boosting function
def Boosting(X,y,fold,trees,rate,depth):
# shuffle and split training and test sets to build the 5-fold crossvalidation
    gini=0
    y = label_binarize(y, classes = [0,1])
    n_classes = y.shape[1]
    n_classes
    kf = KFold(len(y), n_folds=fold)
    k=0
    plt.figure()
    for train, test in kf:
        k+=1
        X_train = np.array(X)[train]
        y_train = np.array(y)[train]
        X_test = np.array(X)[test]
        y_test = np.array(y)[test]
# predict each the response using a gradient boosting classifier
        classifier = GradientBoostingClassifier(n_estimators=trees, learning_rate=rate, max_depth=depth, random_state=0)
        y_score = classifier.fit(X_train, y_train).decision_function(X_test)
        y_pred = classifier.fit(X_train, y_train).predict(X_test)
        y_proba = classifier.fit(X_train, y_train).predict_proba(X_test)
    
        accuracy = accuracy_score(y_test,y_pred)
        Fscore= f1_score(y_test,y_pred)
        print accuracy, Fscore
      
        fpr = dict()
        tpr = dict()
        roc_auc = dict()
        fpr[0], tpr[0], _ = roc_curve(y_test[:, 0], y_score)
        roc_auc[0] = auc(fpr[0], tpr[0])

# Compute micro-average ROC curve and ROC area
        fpr["micro"], tpr["micro"], _ = roc_curve(y_test.ravel(), y_score.ravel())
        roc_auc["micro"] = auc(fpr["micro"], tpr["micro"])
        gini = gini+ 2*(roc_auc['micro']-0.5)
# Plot of a ROC curve 
        plt.plot(fpr[0], tpr[0], label='fold {0}'.format(k)+' (area = %0.2f)' % roc_auc[0])
        plt.plot([0, 1], [0, 1], 'k--')
        plt.xlim([0.0, 1.0])
        plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('ROC curve boosting')
    plt.legend(loc="lower right") 
    plt.show()
    plt.savefig('ROC curve Boosting')
    return [gini/fold,trees,rate] 


# test different value of rates and trees and pick up the model with the highest performance in the crossvalidation set    
depth=[1,2,4,6]
rate = [0.001,0.01,0.1,0.5,1]
trees = [1000,3000,5000]
results=[]
for d in depth:
    for r in rate:
        for t in trees:
            results=results+ [Boosting(data,y,3,t,r,d)]
            print results

