# -*- coding: utf-8 -*-
"""
Created on Mon Apr  6 00:06:03 2015

@author: mehdirifai
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
import seaborn


data = pd.read_csv('uber.csv')

data = data.fillna('NAN')
# get the list of predictors that contain NAs

columns = list(data.columns.values)      
for col in columns:
    print col
    print data[col].value_counts()
    
      
data= data[data['loan_status']!='NAN']
data = data.reset_index(drop =True)

# drop the predictors that corresponds to loan performances (not relevant if we want to predict if the borrower 
# is going to default or not because it is information that we have after giving the loan)
Perf= ['collection_recovery_fee','collections_12_mths_ex_med','funded_amnt','funded_amnt_inv','last_pymnt_amnt',
 'total_pymnt','total_pymnt_inv','total_rec_int','total_rec_late_fee','total_rec_prncp','last_pymnt_d']

data.drop(Perf,inplace=True,axis=1)
# drop predictors that we are not allowed to use in a legal point of view
Not_allowed = ['zip_code']
data.drop(Not_allowed,inplace=True,axis=1)
# drop the id predictors when it comes to build the models
ID = ['member_id','id']
data.drop(ID,inplace=True,axis=1)
# drop predictors that contain no information either because they have too many NA of because they are almost constant 
Non_information = ['policy_code','next_pymnt_d','mths_since_last_major_derog','mths_since_last_record','initial_list_status','pymnt_plan','pub_rec']
data.drop(Non_information,inplace=True,axis=1)

# desc is irrelevant in this case. However, we can think about a text mining utility of this predictor that can also be useful 
# as a prediction: extract key words, analyze the length of the text, grammar mistakes,...

data.drop('desc',inplace=True,axis=1)

# qualitative predictors with too many categories -> create too many dummy variables since the models do not support categorcial data
cat = ['title','addr_state','earliest_cr_line','last_credit_pull_d','issue_d','purpose']
data.drop(cat,inplace=True,axis=1)
## get the list of the columns that contain NAs and analyze them to figure out a way to get rid of them or replace them
columns = list(data.columns.values)
list_NA = []
for col in columns:
    values = list(data[col].unique())
    if 'NAN' in values :
        list_NA = list_NA + [col]
               
for col in list_NA:
    print col
    print data[col].value_counts()
 
# Flag the Na before trying to replace them    
for col in list_NA:
    flag = col+'_Flag' 
    data[flag]=data[col]
    for i in range(len(data[col])):
        if data[col][i]=='NAN':
            data[flag][i]=1
        else:
            data[flag][i]=0



data[' revol_util '] = data[' revol_util '].replace(' -   ',0)
# A robust way to deal with the Na is to replace them with the median. Above all since except for 'mths_since_last_delinq'
# all of them contain only a very low number of NA. Another would consist in predicting the missing values. However,
# since the small number of NA that we have I don't think it is relevant.
l = ['inq_last_6mths','open_acc','total_acc','delinq_2yrs','annual_inc','mths_since_last_delinq',' revol_util ']

for i in l:
    data[i] = data[i].replace('NAN',data[data[i]!='NAN'][i].median())
 

# replace some categorical data by quantitative data

for i in range(len(data['loan term'])):
    if data['loan term'][i]==' 36 months':
        data['loan term'][i]=36
    else:
        data['loan term'][i]=60
 
# FICO is between 300 and 800 so just selected the median of each category          
for i in range(len(data['FICO'])):
    if data['FICO'][i]=='750-799':
        data['FICO'][i]=775
    elif data['FICO'][i]=='800-850':
        data['FICO'][i]=825
    elif data['FICO'][i]=='700-749':
        data['FICO'][i]=725
    elif data['FICO'][i]=='600-649':
        data['FICO'][i]=625
    elif data['FICO'][i]=='650-699':
        data['FICO'][i]=675
    elif data['FICO'][i]=='550-599':
        data['FICO'][i]=550
    elif data['FICO'][i]=='G':
        data['FICO'][i]=425
        

for i in range(len(data['emp_length'])):
    if data['emp_length'][i]=='< 1 year':
        data['emp_length'][i]=0
    elif data['emp_length'][i]=='1 year':
        data['emp_length'][i]=1
    elif data['emp_length'][i]=='2 years':
        data['emp_length'][i]=2
    elif data['emp_length'][i]=='3 years':
        data['emp_length'][i]=3
    elif data['emp_length'][i]=='4 years':
        data['emp_length'][i]=4
    elif data['emp_length'][i]=='5 years':
        data['emp_length'][i]=5
    elif data['emp_length'][i]=='6 years':
        data['emp_length'][i]=6
    elif data['emp_length'][i]=='7 years':
        data['emp_length'][i]=7
    elif data['emp_length'][i]=='8 years':
        data['emp_length'][i]=8
    elif data['emp_length'][i]=='9 years':
        data['emp_length'][i]=9
    elif data['emp_length'][i]=='10+ years':
        data['emp_length'][i]=10 
  
data['emp_length'] = data['emp_length'].replace('n/a',data[data['emp_length']!='n/a']['emp_length'].median())
      
# make the response a classification problem
        
for i in range(len(data['loan_status'])):
    if data['loan_status'][i]=='Default':
        data['loan_status'][i]=0
    else:
        data['loan_status'][i]=1




# turn categorical values into dummy variables
dum = ['is_inc_v','home_ownership']
 
for col in dum:    
    dummies = pd.get_dummies(data[col], prefix=col) # Create dummy variables 
    data = pd.concat([data, dummies], axis = 1)
    data = data.drop(col, 1)
    
   
# turn predictors into floats 
columns = list(data.columns.values)
for col in columns:
    data[col] = data[col].astype('float')
    
# plot the distribution of the predictors using histograms
for col in columns:
    fig, ax = plt.subplots()
    data[col].hist()
    plt.title(col+'distribution')
    plt.savefig(col)

# plot the correlation matrix of the dataset to see if some predictors are more correlated to the response
seaborn.corrplot(data, sig_stars=True, annot= False, sig_tail='both', sig_corr=False, cmap=None, cmap_range=None, cbar=True, diag_names=True, method='spearman', ax=None)
plt.savefig('correlation_spearman_matrix.png')

# separate the response from the features
y = data['loan_status']
data.drop('loan_status',inplace=True,axis=1)   
  
def Logistic_Regression(X,y,fold):
# shuffle and split training and test sets
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
        classifier = LogisticRegression(random_state=0)
        y_score = classifier.fit(X_train, y_train).decision_function(X_test)
        
        
        print len(y_score), len(y_test)
        fpr = dict()
        tpr = dict()
        roc_auc = dict()
        fpr[0], tpr[0], _ = roc_curve(y_test, y_score)
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
    plt.title('ROC curve Logistic Regression')
    plt.legend(loc="lower right") 
    plt.show()
    plt.savefig('ROC curve Logistic Regression')
    return gini/fold 
 
Logistic_Regression(data,y,5)

# Boosting function
def Boosting(X,y,fold,trees,rate):
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
        classifier = GradientBoostingClassifier(n_estimators=trees, learning_rate=rate, max_depth=1, random_state=0)
        y_score = classifier.fit(X_train, y_train).decision_function(X_test)
        
        
        
        fpr = dict()
        tpr = dict()
        roc_auc = dict()
        fpr[0], tpr[0], _ = roc_curve(y_test[:, 0], y_score[:, 0])
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
rate = [0.001,0.01,0.1,0.3,0.5,0.75,1]
trees = [500,1000,2000,3000,4000,5000]
results=[]
for r in rate:
    for t in trees:
        Q=Q+ [Boosting(data,y,5,t,r)]
        print Q

# Best model r=0.01 and t= 4000
Boosting(data,y,5,4000,0.01)
