library(ggplot2)
library(gbm)
library(gam)
library(ROCR)

data_gbm<-read.csv("~/Documents/R/data_gbm.csv")
test_gbm<-read.csv("~/Documents/R/test_gbm.csv")

data_gam<-read.csv("~/Documents/R/data_gam.csv")
test_gam<-read.csv("~/Documents/R/test_gam.csv")

rocplot=function(pred, truth,...){
  predob = prediction(pred, truth)
  perf = performance(predob, "tpr", "fpr")
  plot(perf,...)}

train = data_gbm
testPredictors = test_gbm
trainPredictors=train
trainPredictors$rate<-NULL
testPredictors$rate<-NULL
bstfit=gbm(TDC_flag~., trainPredictors, distribution= "bernoulli", n.trees=5000,
           shrinkage = 0.01, interaction.depth =6) ## fit the model
testmodel = predict(bstfit,testPredictors,n.trees=5000)
predob = prediction(testmodel ,testPredictors["TDC_flag"])
auc <- performance(predob, "auc")
auc <- unlist(slot(auc, "y.values"))
rocplot(testmodel ,testPredictors["TDC_flag"], col = 'cornflowerblue',main=auc)
abline(0,1)

predob = prediction(testmodel,test_gbm["TDC_flag"])
perf = performance(predob, "tpr", "fpr")
auc <- performance(predob, measure = "auc")
auc <- auc@y.values[[1]]

roc.data <- data.frame(fpr=unlist(perf@x.values),
                       tpr=unlist(perf@y.values),model="GLM")

ggplot(roc.data, aes(x=fpr, ymin=0, ymax=tpr, color='Models'))  + 
  geom_line(aes(y=tpr,color="red"))  +  geom_abline()  +
  ggtitle(paste0("ROC Curves AUC=",auc))


train = data_gam
testPredictors = test_gam
trainPredictors=train
trainPredictors$rate<-NULL
testPredictors$rate<-NULL
gam.fit=gam(TDC_flag~s(LoanAmountRequest,10)+s(ALL703,10)+s(RTL001,10)+s(BAC035,10)+s(STAG_REVDebtToTotal,10)+s(ILN702,10)+s(REV201,10)+s(AggregateBalanceCreditRatioOnAllTrades6Months,10)+s(FIL022,10)+s(DTI_LeverageStagNoMG,10)+s(STAG_REVDebtToTotalNoMG,10)+s(ALL021,10)+s(ALL805,10)+s(BAC752,10)+s(REV038,10)+s(ALL202,10)+s(MonthlyDebt,10)+s(ALE908,10)+s(ILN201,10)+s(ALL076,10),trainPredictors, 
            family='binomial')
testmodel2 = predict(gam.fit,testPredictors)

predob2 = prediction(testmodel2 ,testPredictors["TDC_flag"])
perf2 = performance(predob2, "tpr", "fpr")
auc2 <- performance(predob2, measure = "auc")
auc2 <- auc2@y.values[[1]]

roc.data2 <- data.frame(fpr=unlist(perf2@x.values),
                        tpr=unlist(perf2@y.values), 
                        model="GLM")

ggplot(roc.data2, aes(x=fpr, ymin=0, ymax=tpr, color='Models'))  + 
  geom_line(aes(y=tpr,color="red"))  +  geom_abline()  +
  ggtitle(paste0("ROC Curves AUC=",auc2))

## common plots

x<-data_gbm
## create a 3-fold partition
k=3
set.seed(1)
folds=sample(1:k,nrow(x),replace =TRUE)
train = x[folds!=3,] ## create the folds
testPredictors = x[folds==3,]
#trainPredictors=train[(train$REV201<10000 & train$rate<=0) | (train$REV201<10000 & train$rate>=0.3) | (train$REV201>=10000 & train$rate<=0) | (train$REV201>=10000 & train$rate>=0.5),]
trainPredictors<-train
trainPredictors$rate<-NULL
testPredictors$rate<-NULL
bstfit2=gbm(TDC_flag~., trainPredictors, distribution= "bernoulli", n.trees=5000,
           shrinkage = 0.01, interaction.depth =6) ## fit the model
testmodel3 = predict(bstfit2,testPredictors,n.trees=5000)
predob3 = prediction(testmodel3 ,testPredictors["TDC_flag"])
perf3 = performance(predob3, "tpr", "fpr")
auc3 <- performance(predob3, measure = "auc")
auc3 <- auc3@y.values[[1]]

x<-data_gam
## create a 3-fold partition
k=3
set.seed(1)
folds=sample(1:k,nrow(x),replace =TRUE)
train = x[folds!=3,] ## create the folds
testPredictors = x[folds==3,]
#trainPredictors=train[(train$REV201<10000 & train$rate<=0) | (train$REV201<10000 & train$rate>=0.3) | (train$REV201>=10000 & train$rate<=0) | (train$REV201>=10000 & train$rate>=0.5),]
trainPredictors<-train
trainPredictors$rate<-NULL
testPredictors$rate<-NULL
gam.fit2=gam(TDC_flag~s(LoanAmountRequest,10)+s(ALL703,10)+s(RTL001,10)+s(BAC035,10)+s(STAG_REVDebtToTotal,10)+s(ILN702,10)+s(REV201,10)+s(AggregateBalanceCreditRatioOnAllTrades6Months,10)+s(FIL022,10)+s(DTI_LeverageStagNoMG,10)+s(STAG_REVDebtToTotalNoMG,10)+s(ALL021,10)+s(ALL805,10)+s(BAC752,10)+s(REV038,10)+s(ALL202,10)+s(MonthlyDebt,10)+s(ALE908,10)+s(ILN201,10)+s(ALL076,10),trainPredictors, 
             family='binomial')
testmodel4 = predict(gam.fit2,testPredictors)
predob4 = prediction(testmodel4 ,testPredictors["TDC_flag"])
perf4 = performance(predob4, "tpr", "fpr")
auc4 <- performance(predob4, measure = "auc")
auc4 <- auc4@y.values[[1]]
print(auc4)

roc.data1 <- data.frame(fpr=unlist(perf@x.values),
                        tpr=unlist(perf@y.values), tpr2=unlist(perf2@y.values),
                        model="GLM")

roc.data4<- data.frame(fpr2=unlist(perf3@x.values),tpr3=unlist(perf3@y.values),tpr4=unlist(perf4@y.values),model="GLM")

ggplot()  +  geom_line(data=roc.data1,aes(x=fpr,y=tpr,color="GBM OOT AUC=0.755"))+
  geom_line(data=roc.data1,aes(x=fpr,y=tpr2,color="GAM OOT AUC=0.707"))  +geom_line(data=roc.data4,aes(x=fpr2,y=tpr3,color="GBM AUC=0.76"),linetype="dotted")+geom_line(data=roc.data4,aes(x=fpr2,y=tpr4,color="GAM AUC=0.71"),linetype="dotted")+  geom_abline()  + 
  scale_color_manual(values=c("GAM OOT AUC=0.707"='red',"GBM OOT AUC=0.755"='steelblue',"GBM AUC=0.76"='green',"GAM AUC=0.71"='orange'))+guides(fill = guide_legend(title = "AUCs"))+
  ggtitle("ROC Curves")

