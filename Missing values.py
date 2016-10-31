# -*- coding: utf-8 -*-
"""
Created on Sat Jun 20 13:33:08 2015

@author: mehdirifai
"""
import pandas as pd

data = pd.read_csv('predictors.csv',delimiter=',') 
columns = list(data.columns.values)

## create a dictionnary with the proportion of the NAs
dicNA={}
for col in columns:
    dicNA[col]=float(sum(data[col].isnull()))/float(len(data[col]))

## get of the NA columns
tresh = 0.7
for col in columns:
    if dicNA[col]<tresh:
        dicNA.pop(col,None)

## flag the NAs
data['namecol_Flag'].isnull().astype('float')

## fill NAs with median
data['namecol_Flag'] = data['namecol_Flag'].fillna(data['namecol_Flag'].median())



