# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import matplotlib as mpl
import statsmodels.api as sm
import scipy




data = pd.read_csv('data.csv',delimiter=',') 
data = pd.read_csv('clusdata.csv',delimiter=',') 

l=['ProsperRatingTypeID','OriginationFeeAmount','OriginationFeePercent','MonthlyPayment','MonthlyPaymentLast','EndingMonthlyPayment','EndingOriginationFeeAmount','EndingMonthlyPaymentLast','rate','PrjALR_D','RevBal_MOB2','RevolvingCreditBalance.y','CategoryBin','EndingBorrowerAPR','EndingFinanceCharge','EndingAmountFinanced','EndingTotalPaidBack','TotalPaidBack','ID','ListingCategoryID','TermsApprovalDate','WholeLoanStartDate','WholeLoanEndDate','AmountFunded','LastModifiedDate','UserID','CreditPullDate','RevolvingCreditBalance.x','VersionStartDate','VersionEndDate','ModifiedDate','Unnamed: 0','LoanID','UserCreditProfileID','StartTime','CreationDate','EndDate','GBL007','ModifiedTransactionId','CreatedTransactionId','CreditGrade','ILN110','ExperianDocumentID','CreditBureauID','FirstRecordedCreditLine','CreatedUser','ModifiedUser','CreditScoreTypeID','UnderwriterID','UserLoanHistorySnapshotID',
'EstimatedReturn','AccountID','MaxRateToBid','AltKeySearchID','FinanceCharge','AmountFinanced','ExperianCreditProfileResponseID','MaxYieldToBid','CurrentRate','EffectiveYield','EstimatedLoss','EstimatedLossImpact','MaxRate','ProsperRatingLossRangeID','ProsperRatingTypeID','Purpose']

data.drop(l,inplace=True,axis=1)


int_float = list(data.columns.values)


def integers(data):
    types=data.dtypes
    types_dictionnary = data.columns.to_series().groupby(data.dtypes).groups    
    list_of_types = types_dictionnary.keys()
    return types_dictionnary[list_of_types[1]]

    
def reel(data):
    types=data.dtypes
    types_dictionnary = data.columns.to_series().groupby(data.dtypes).groups    
    list_of_types = types_dictionnary.keys()
    return types_dictionnary[list_of_types[0]]
    
for i in integers(data):
    data[i]= data[i].astype('float')
    
def fac(data):
    types=data.dtypes
    types_dictionnary = data.columns.to_series().groupby(data.dtypes).groups    
    list_of_types = types_dictionnary.keys()
    return types_dictionnary[list_of_types[0]]
    
data.drop(fac(data),inplace=True,axis=1)

data.drop('Unnamed: 0',inplace=True,axis=1)

int_float = list(data.columns.values)

sns.set_context(rc={"figure.figsize": (75, 75)})
sns.corrplot(data, annot=False, diag_names=False)
plt.savefig('correlation_spearman_matrix.png')


# exctract the list of the predictors that have more than 0.8 spearman correlation with other predictors
correlation3={}
for i in range(0,len(int_float)-1):
    predictor1 = int_float[i]
    correlation3[predictor1]=[]
    for j in range(i+1,len(int_float)):
        predictor2 = int_float[j]
        if abs(scipy.stats.spearmanr(data[predictor1],data[predictor2])[0]) > 0.99:
            correlation3[predictor1] = correlation3[predictor1] + [predictor2]

# compute the average correlation of a predictors with the others
def avg_corr(pred):
    L=[]
    for elm in correlation:
        L=L + [abs(scipy.stats.spearmanr(predictors[pred],predictors[elm])[0])]
    return np.mean(L)
 
# spot the correlated predictors that we are going to get rid of
for i in correlation:
    if correlation[i] != [] and correlation[i]!=0:
        for j in correlation[i]:
            if j !=0:
                if avg_corr(j) < avg_corr(i): #get rid of the one that has the highest average correlation
                    correlation[i] = 0
                else:
                    correlation[j] = 0
                    
                    
for col in int_float:
    if len(tmp[col].value_counts())==1:
        print col
        
        
