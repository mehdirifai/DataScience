data <- read.csv("~/Documents/python/Trainingset.csv")
data3 <- read.csv("~/Documents/R/dataTDCfv.csv")
data2 <- read.csv("~/Documents/R/TDC_PMI6.csv")

data2$rate<-(1.02*data2$RevolvingCreditBalance-as.numeric(as.character(data2$RevBal_MOB2)))/data2$LoanAmount

data2<-na.omit(data2)
data2$TDC_flag<- rep(0,38887)

for (i in 1:38887){
  if (data2$RevolvingCreditBalance[i]<10000){
    if (data2$rate[i]>0.3){
      data2$TDC_flag[i]=1}
  }
  if (data2$RevolvingCreditBalance[i]>10000){
    if (data2$rate[i]>0.5){
      data2$TDC_flag[i]=1}
  }}
data3 <- merge(data3,data2,by="LoanID")
data$ALL201<-data3$ALL201


userLR<-read.csv("~/Documents/loan_request_train.csv")
userLR$LoanID<-userLR$Loanid
data$LoanID<-data3$LoanID
data <- merge(data,userLR,by="LoanID")
data$LoanAmountRequest<-data$user_req_loan_amt
data3 <- merge(data3,userLR,by="LoanID")
data3$LoanAmountRequest<-data3$user_req_loan_amt


data1 <- read.csv("~/Documents/python/final.csv")


data1$rate<-(1.02*data1$REV201-data1$RevBal_MOB2)/data1$LoanAmount
data1<-data1[!is.na(data1$rate),]
data1$TDC_flag<- rep(0,29448)
for (i in 1:29448){
  if (data1$REV201[i]<10000){
    if (data1$rate[i]>0.3){
      data1$TDC_flag[i]=1}
    
  }
  if (data1$REV201[i]>10000){
    if (data1$rate[i]>0.5){
      data1$TDC_flag[i]=1}
  }}

data4<-read.csv("~/Documents/loan_request_test.csv")
data4$LoanID<-data4$Loanid

test <- read.csv("~/Documents/python/Testset.csv")
test$UserCreditProfileID<-data1$UserCreditProfileID
test$ALL201<-data1$ALL201
test$LoanID<-data1$LoanID
test<-merge(test,data4,by='LoanID')
test$LoanAmountRequest<-test$user_req_loan_amt
data1<-merge(data1,data4,by='LoanID')
data1$LoanAmountRequest<-data1$user_req_loan_amt
test<-test[test$LoanID!=250099,]
test<-test[test$LoanID!=228039,]
test<-test[test$LoanID!=225786,]
data1<-data1[data1$LoanID!=250099,]
data1<-data1[data1$LoanID!=228039,]
data1<-data1[data1$LoanID!=225786,]

DTItest<-read.csv("~/Documents/DTI_test.csv")

DTItrain<-read.csv("~/Documents/DTI_train.csv")

DTItest$LoanID<-DTItest$loanid
DTItrain$LoanID<-DTItrain$loanid

DTItest<-DTItest[!duplicated(DTItest),]
DTItrain<-DTItrain[!duplicated(DTItrain),]

test<-merge(test,DTItest,by='LoanID')

data1<-merge(data1,DTItest,by='LoanID')

data<-merge(data,DTItrain,by='LoanID')

data3<-merge(data3,DTItrain,by='LoanID')

Scoretest<-read.csv("~/Documents/FICOtest.csv")
Score<-read.csv("~/Documents/FICO.csv")
Scoretest<-Scoretest[!duplicated(Scoretest),]
Score<-Score[!duplicated(Score),]
test$Score<-NULL
test<-merge(test,Scoretest,by='LoanID')

data1$Score<-NULL
data1<-merge(data1,Scoretest,by='LoanID')

data$Score<-NULL
data<-merge(data,Score,by='LoanID')

data3$Score<-NULL
data3<-merge(data3,Score,by='LoanID')


##gbm

data_gbm<-subset(data,select=c(TDC_flag,REV201,LoanAmountRequest,DTI_LeverageStagNoMG,MonthlyDebt,
                               STAG_REVDebtToTotal,ILN702,REV202,BAC035,ALL805,DTI_LeverageStag,ALE403,AggregateMonthlyPaymentOnTrades6Months,         
                               STAG_REVDebtToTotalNoMG,RevToTotalTrades,REV401,ILN302,RTR401,REV301,BAC042,ILN301,Score,
                               ALL702,BankcardUtilization,REV404,BAC303,ALL202,RTL002,SumAvailableCreditOpenBC,
                               ALL703,REV302,ILN703,ALL701,BAC302,ILN701,AvgAgeRevTrades,DTIwoProspLoanAllEmp,
                               ALL724,AggregateBalanceCreditRatioOnAllTrades6Months,RTR403,
                               RTR071))

test_gbm<-subset(test,select=c(TDC_flag,REV201,LoanAmountRequest,DTI_LeverageStagNoMG,MonthlyDebt,
                               STAG_REVDebtToTotal,ILN702,REV202,BAC035,ALL805,DTI_LeverageStag,ALE403,AggregateMonthlyPaymentOnTrades6Months,         
                               STAG_REVDebtToTotalNoMG,RevToTotalTrades,REV401,ILN302,RTR401,REV301,BAC042,ILN301,Score,
                               ALL702,BankcardUtilization,REV404,BAC303,ALL202,RTL002,SumAvailableCreditOpenBC,
                               ALL703,REV302,ILN703,ALL701,BAC302,ILN701,AvgAgeRevTrades,DTIwoProspLoanAllEmp,
                               ALL724,AggregateBalanceCreditRatioOnAllTrades6Months,RTR403,
                               RTR071,LoanID))

write.csv(data_gbm,'data_gbm_v2.csv')
write.csv(test_gbm,'test_gbm_v2.csv')
write.csv(test,'test_v2.csv')

data_gbm$REV201_AggBalanceOnAllOpenRevTradesReptdLast6Mos<-data_gbm$REV201
data_gbm$REV201<-NULL
data_gbm$ILN702_AgeOfMostRecentlyOpenedInstallTrade<-data_gbm$ILN702
data_gbm$ILN702<-NULL
data_gbm$REV202_AverageBalanceOnAllOpenRevTradesReptdLast6Mos<-data_gbm$REV202
data_gbm$REV202<-NULL
data_gbm$BAC035_NumOpenBankcardTradesBalanceGE1000ReptdLast6Mos<-data_gbm$BAC035
data_gbm$BAC035<-NULL
data_gbm$ALL805_MostRecentInquiry<-data_gbm$ALL805
data_gbm$ALL805<-NULL
data_gbm$ALE403_UtilAllOpenAutoTradesReptdLast6Mos<-data_gbm$ALE403
data_gbm$ALE403<-NULL
data_gbm$REV401_AggOfAvailableCreditOnAllOpenRevTradesReptdLast6Mos<-data_gbm$REV401
data_gbm$REV401<-NULL
data_gbm$ILN302_AverageLoanAmountOnAllOpenInstallTradesReptdLast6Mos<-data_gbm$ILN302
data_gbm$ILN302<-NULL
data_gbm$REV301_AggOfCreditOnAllOpenRevTradesReptdLast6Mos<-data_gbm$REV301
data_gbm$REV301<-NULL
data_gbm$BAC042_NumOpenBankcardTradesUtilGE50ReptdLast6Mos<-data_gbm$BAC042
data_gbm$BAC042<-NULL
data_gbm$ILN301_AggLoanAmountOnAllOpenInstallTradesReptdLast6Mos<-data_gbm$ILN301
data_gbm$ILN301<-NULL
data_gbm$ALL702_AgeOfMostRecentlyOpenedTrade<-data_gbm$ALL702
data_gbm$ALL702<-NULL
data_gbm$REV404_UtilOnAllOpenRevTradesOpenedLast12Mos<-data_gbm$REV404
data_gbm$REV404<-NULL
data_gbm$BAC303_HighestCreditOnAllOpenBankcardTradesReptdLast6Mos<-data_gbm$BAC303
data_gbm$BAC303<-NULL
data_gbm$ALL202_AverageBalanceOnAllOpenTradesReptdLast6Mos<-data_gbm$ALL202
data_gbm$ALL202<-NULL
data_gbm$RTL002_NumOpenPaidClosedOrInactiveRetailTrades<-data_gbm$RTL002
data_gbm$RTL002<-NULL
data_gbm$ALL703_AverageAgeOfAllTrades<-data_gbm$ALL703
data_gbm$ALL703<-NULL
data_gbm$REV302_AverageCreditOnAllOpenRevTradesReptdLast6Mos<-data_gbm$REV302
data_gbm$REV302<-NULL
data_gbm$ILN703_AverageAgeOfAllInstallTrades<-data_gbm$ILN703
data_gbm$ILN703<-NULL
data_gbm$ALL701_AgeOfOldestTrade<-data_gbm$ALL701
data_gbm$ALL701<-NULL
data_gbm$BAC302_AverageCreditOrLoanAmtOpenBankcardTradesReptdLast6Mos<-data_gbm$BAC302
data_gbm$BAC302<-NULL
data_gbm$ILN701_AgeOfOldestInstallTrade<-data_gbm$ILN701
data_gbm$ILN701<-NULL
data_gbm$ALL724_MostRecent30To60DayDelinqOnAnyTrade<-data_gbm$ALL724
data_gbm$ALL724<-NULL
data_gbm$RTR403_UtilOnAllOpenRetailRevTradesReptdLast6Mos<-data_gbm$RTR403
data_gbm$RTR403<-NULL
data_gbm$RTR071_NumRetailRevTradesNeverDelinqOrDerog<-data_gbm$RTR071
data_gbm$RTR071<-NULL
data_gbm$RTR401_AggAvailCreditOnAllOpenRetailRevTradesReptdLast6Mos<-data_gbm$RTR401
data_gbm$RTR401<-NULL

test_gbm$REV201_AggBalanceOnAllOpenRevTradesReptdLast6Mos<-test_gbm$REV201
test_gbm$REV201<-NULL
test_gbm$ILN702_AgeOfMostRecentlyOpenedInstallTrade<-test_gbm$ILN702
test_gbm$ILN702<-NULL
test_gbm$REV202_AverageBalanceOnAllOpenRevTradesReptdLast6Mos<-test_gbm$REV202
test_gbm$REV202<-NULL
test_gbm$BAC035_NumOpenBankcardTradesBalanceGE1000ReptdLast6Mos<-test_gbm$BAC035
test_gbm$BAC035<-NULL
test_gbm$ALL805_MostRecentInquiry<-test_gbm$ALL805
test_gbm$ALL805<-NULL
test_gbm$ALE403_UtilAllOpenAutoTradesReptdLast6Mos<-test_gbm$ALE403
test_gbm$ALE403<-NULL
test_gbm$REV401_AggOfAvailableCreditOnAllOpenRevTradesReptdLast6Mos<-test_gbm$REV401
test_gbm$REV401<-NULL
test_gbm$ILN302_AverageLoanAmountOnAllOpenInstallTradesReptdLast6Mos<-test_gbm$ILN302
test_gbm$ILN302<-NULL
test_gbm$REV301_AggOfCreditOnAllOpenRevTradesReptdLast6Mos<-test_gbm$REV301
test_gbm$REV301<-NULL
test_gbm$BAC042_NumOpenBankcardTradesUtilGE50ReptdLast6Mos<-test_gbm$BAC042
test_gbm$BAC042<-NULL
test_gbm$ILN301_AggLoanAmountOnAllOpenInstallTradesReptdLast6Mos<-test_gbm$ILN301
test_gbm$ILN301<-NULL
test_gbm$ALL702_AgeOfMostRecentlyOpenedTrade<-test_gbm$ALL702
test_gbm$ALL702<-NULL
test_gbm$REV404_UtilOnAllOpenRevTradesOpenedLast12Mos<-test_gbm$REV404
test_gbm$REV404<-NULL
test_gbm$BAC303_HighestCreditOnAllOpenBankcardTradesReptdLast6Mos<-test_gbm$BAC303
test_gbm$BAC303<-NULL
test_gbm$ALL202_AverageBalanceOnAllOpenTradesReptdLast6Mos<-test_gbm$ALL202
test_gbm$ALL202<-NULL
test_gbm$RTL002_NumOpenPaidClosedOrInactiveRetailTrades<-test_gbm$RTL002
test_gbm$RTL002<-NULL
test_gbm$ALL703_AverageAgeOfAllTrades<-test_gbm$ALL703
test_gbm$ALL703<-NULL
test_gbm$REV302_AverageCreditOnAllOpenRevTradesReptdLast6Mos<-test_gbm$REV302
test_gbm$REV302<-NULL
test_gbm$ILN703_AverageAgeOfAllInstallTrades<-test_gbm$ILN703
test_gbm$ILN703<-NULL
test_gbm$ALL701_AgeOfOldestTrade<-test_gbm$ALL701
test_gbm$ALL701<-NULL
test_gbm$BAC302_AverageCreditOrLoanAmtOpenBankcardTradesReptdLast6Mos<-test_gbm$BAC302
test_gbm$BAC302<-NULL
test_gbm$ILN701_AgeOfOldestInstallTrade<-test_gbm$ILN701
test_gbm$ILN701<-NULL
test_gbm$ALL724_MostRecent30To60DayDelinqOnAnyTrade<-test_gbm$ALL724
test_gbm$ALL724<-NULL
test_gbm$RTR403_UtilOnAllOpenRetailRevTradesReptdLast6Mos<-test_gbm$RTR403
test_gbm$RTR403<-NULL
test_gbm$RTR071_NumRetailRevTradesNeverDelinqOrDerog<-test_gbm$RTR071
test_gbm$RTR071<-NULL
test_gbm$RTR401_AggAvailCreditOnAllOpenRetailRevTradesReptdLast6Mos<-test_gbm$RTR401
test_gbm$RTR401<-NULL


test$REV201_AggBalanceOnAllOpenRevTradesReptdLast6Mos<-test$REV201
test$REV201<-NULL
test$ILN702_AgeOfMostRecentlyOpenedInstallTrade<-test$ILN702
test$ILN702<-NULL
test$REV202_AverageBalanceOnAllOpenRevTradesReptdLast6Mos<-test$REV202
test$REV202<-NULL
test$BAC035_NumOpenBankcardTradesBalanceGE1000ReptdLast6Mos<-test$BAC035
test$BAC035<-NULL
test$ALL805_MostRecentInquiry<-test$ALL805
test$ALL805<-NULL
test$ALE403_UtilAllOpenAutoTradesReptdLast6Mos<-test$ALE403
test$ALE403<-NULL
test$REV401_AggOfAvailableCreditOnAllOpenRevTradesReptdLast6Mos<-test$REV401
test$REV401<-NULL
test$ILN302_AverageLoanAmountOnAllOpenInstallTradesReptdLast6Mos<-test$ILN302
test$ILN302<-NULL
test$REV301_AggOfCreditOnAllOpenRevTradesReptdLast6Mos<-test$REV301
test$REV301<-NULL
test$BAC042_NumOpenBankcardTradesUtilGE50ReptdLast6Mos<-test$BAC042
test$BAC042<-NULL
test$ILN301_AggLoanAmountOnAllOpenInstallTradesReptdLast6Mos<-test$ILN301
test$ILN301<-NULL
test$ALL702_AgeOfMostRecentlyOpenedTrade<-test$ALL702
test$ALL702<-NULL
test$REV404_UtilOnAllOpenRevTradesOpenedLast12Mos<-test$REV404
test$REV404<-NULL
test$BAC303_HighestCreditOnAllOpenBankcardTradesReptdLast6Mos<-test$BAC303
test$BAC303<-NULL
test$ALL202_AverageBalanceOnAllOpenTradesReptdLast6Mos<-test$ALL202
test$ALL202<-NULL
test$RTL002_NumOpenPaidClosedOrInactiveRetailTrades<-test$RTL002
test$RTL002<-NULL
test$ALL703_AverageAgeOfAllTrades<-test$ALL703
test$ALL703<-NULL
test$REV302_AverageCreditOnAllOpenRevTradesReptdLast6Mos<-test$REV302
test$REV302<-NULL
test$ILN703_AverageAgeOfAllInstallTrades<-test$ILN703
test$ILN703<-NULL
test$ALL701_AgeOfOldestTrade<-test$ALL701
test$ALL701<-NULL
test$BAC302_AverageCreditOrLoanAmtOpenBankcardTradesReptdLast6Mos<-test$BAC302
test$BAC302<-NULL
test$ILN701_AgeOfOldestInstallTrade<-test$ILN701
test$ILN701<-NULL
test$ALL724_MostRecent30To60DayDelinqOnAnyTrade<-test$ALL724
test$ALL724<-NULL
test$RTR403_UtilOnAllOpenRetailRevTradesReptdLast6Mos<-test$RTR403
test$RTR403<-NULL
test$RTR071_NumRetailRevTradesNeverDelinqOrDerog<-test$RTR071
test$RTR071<-NULL
test$RTR401_AggAvailCreditOnAllOpenRetailRevTradesReptdLast6Mos<-test$RTR401
test$RTR401<-NULL
test$X.1<-NULL
test$X<-NULL

write.csv(data_gbm,'data_gbm.csv')
write.csv(test_gbm,'test_gbm.csv')


data_gam<-subset(data3,select=c(TDC_flag,InquiriesLast6Months,LoanAmountRequest,RTL001,REV585,BAC035,STAG_REVDebtToTotal,ILN702,REV201,AggregateBalanceCreditRatioOnAllTrades6Months,FIL022,ILN801,DTI_LeverageStagNoMG,STAG_REVDebtToTotalNoMG,ILN501,REP501,RTL075,ALL501,ALL085,ALL112,ALL151,ALL051,RTL502,ILN504,ALE080,ILN502,ILN085,ILN103,ILN724,ALL724,ALL110,ALL109,FIN601,ALL021,ALL805,RTR403,RTR401,BAC752,REV001,REV038,REP901,ALL202,ALL703,ILN703,MonthlyDebt,Score,ALE908,ILN201,RevToTotalTrades,ALL078,REV064,ALL116,ALL077,ALL076,ALL103))
test_gam<-subset(data1,select=c(TDC_flag,InquiriesLast6Months,LoanAmountRequest,RTL001,REV585,BAC035,STAG_REVDebtToTotal,ILN702,REV201,AggregateBalanceCreditRatioOnAllTrades6Months,FIL022,ILN801,DTI_LeverageStagNoMG,STAG_REVDebtToTotalNoMG,ILN501,REP501,RTL075,ALL501,ALL085,ALL112,ALL151,ALL051,RTL502,ILN504,ALE080,ILN502,ILN085,ILN103,ILN724,ALL724,ALL110,ALL109,FIN601,ALL021,ALL805,RTR403,RTR401,BAC752,REV001,REV038,REP901,ALL202,ALL703,ILN703,MonthlyDebt,Score,ALE908,ILN201,RevToTotalTrades,ALL078,REV064,ALL116,ALL077,ALL076,ALL103))

write.csv(data_gam,'data_gam.csv')
write.csv(test_gam,'test_gam.csv')

write.csv(test,'test.csv')


