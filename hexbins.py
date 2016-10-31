# -*- coding: utf-8 -*-
"""
Created on Tue Apr  7 16:44:59 2015

@author: mehdirifai
"""

svm = pd.read_csv('SVM+Boosting_10_kfold.csv')
glm = pd.read_csv('score_TrainTest_GLM.csv')
rf = pd.read_csv('RF_classproba.csv')
nsc = pd.read_csv('nsc_results_new.csv')

data['res_svm'] = data['response'] - data['svmproba']
data['res_glm'] = data['response'] - data['yhat']
data['res_gbm'] = data['response'] - data['gbcproba']
data['res_nsc'] = data['response'] - data['final_results']
data['res_rf'] = data['response'] - data['Probability']





l = ['res_svm','res_glm','res_gbm','res_nsc','res_rf']

g = ['RevolvingAvailablePercent','STG_BAC752','STG_BAC901','STG_ILN901','STG_REV202','STG_REV901','InquiriesLast6Months','NowDelinquentDerog','STG_ALL051','STG_ALL082','STG_ALL104','STG_ALL202','STG_ALL806','STG_ALL807','STG_ALL901','STG_ALL903','STG_BAC584']

for j in g:

    fig = plt.figure(figsize=(15,15))

    k=1


    for i in l:

        plt.subplot(3,2,k)
        
        plt.hexbin(data[j],data[i],gridsize=25,bins='log',cmap=plt.cm.jet)
        
        plt.xlabel(j)

        plt.ylabel(i)
        plt.ylim([-1, 1])
        k+=1

        name = 'Model comparison for {0} (hexbin)'.format(j)

        fig.suptitle(name)

        plt.savefig(name)



g = ['RevolvingAvailablePercent','STG_BAC752','STG_BAC901','STG_ILN901','STG_REV202','STG_REV901','InquiriesLast6Months','NowDelinquentDerog','STG_ALL051','STG_ALL082','STG_ALL104','STG_ALL202','STG_ALL806','STG_ALL807','STG_ALL901','STG_ALL903','STG_BAC584']

for i in g:

    plt.figure()

    data[i].hist()

    plt.title(i+' distribution')

    plt.savefig(i)