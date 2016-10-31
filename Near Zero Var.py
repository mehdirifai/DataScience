# -*- coding: utf-8 -*-
"""
Created on Sun Jun 21 16:17:08 2015

@author: mehdirifai
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

data = pd.read_csv('predictors.csv',delimiter=',') 
columns = list(data.columns.values)

for col in columns:
    if len(data['STG_ALL078'].value_counts())==1:
        data.drop(col,inplace=True,axis=1)
