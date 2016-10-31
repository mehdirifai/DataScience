library(ggplot2)
library(gbm)
library(gam)
library(ROCR)

data_gbm<-read.csv("~/Documents/R/data_gbm.csv")
test_gbm<-read.csv("~/Documents/R/test_gbm.csv")
test<-read.csv("~/Documents/R/test.csv")

x<-data_gbm
## create a 3-fold partition
k=3
set.seed(1)
folds=sample(1:k,nrow(x),replace =TRUE)

## plot function of the ROC curve
library(ROCR)
rocplot=function(pred, truth,...){
  predob = prediction(pred, truth)
  perf = performance(predob, "tpr", "fpr")
  plot(perf,...)}

lambda = c(0.001,0.01,0.1) ## set of cost values tested
tree = c(3000,5000)
depth = c(4,6)
for (i in 1:length(lambda)){
  for (l in 1:length(tree)){
    for (m in 1:length(depth)){
      ## test several cost values and use cross-validation to choose the one with the highest area under the curve
      s = numeric()
      Fscore=0
      t=0
      for (j in 1:k){
        train = x[folds!=j,] ## create the folds
        testPredictors = x[folds==j,]
        #trainPredictors=train[(train$REV201<10000 & train$rate<=0) | (train$REV201<10000 & train$rate>=0.3) | (train$REV201>=10000 & train$rate<=0) | (train$REV201>=10000 & train$rate>=0.5),]
        trainPredictors<-train
        trainPredictors$rate<-NULL
        testPredictors$rate<-NULL
        bstfit=gbm(TDC_flag~., trainPredictors, distribution= "bernoulli", n.trees=tree[l],
                   shrinkage = lambda[i], interaction.depth =depth[m]) ## fit the model
        testmodel = predict(bstfit,testPredictors)
        predob = prediction(testmodel ,testPredictors["TDC_flag"])
        auc <- performance(predob, "auc")
        auc <- unlist(slot(auc, "y.values"))
        rocplot(testmodel ,testPredictors["TDC_flag"], col = 'cornflowerblue',main=auc)
        abline(0,1)
        s= c(s,auc)
        print(s)
        vec<-predict(bstfit,testPredictors,n.trees=tree[l],type='response')
        vec2<- rep(0,length(vec))
        for (u in 1:length(vec)){
          if (vec[u]>0.5){vec2[u]=1}}
        vec3<- as.numeric(as.character(testPredictors$TDC_flag))
        for (v in 1:length(vec)){t=t+abs(vec2[v]-vec3[v])}
        precision <- sum(vec2*testPredictors["TDC_flag"]) / sum(vec2)
        recall<- sum(vec2*testPredictors["TDC_flag"]) / sum(testPredictors["TDC_flag"])
        Fscore<-Fscore+2*precision*recall/(precision+recall)
        print(precision)
        print(recall)
      }
      print(t)    
      print(Fscore/k)
      print(mean(s))}}}

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

test<-merge(test,dataOD[,c('LoanID','PrjALR_D')],by='LoanID')
y<-test$TDC_flag
score<-predict(bstfit,test,n.trees=5000,type='response')
q<-quantile(score,seq(0.1,1,by=0.1))
pmi<-test$pmi6lossrate
ALR<-test$PrjALR_D
LA<-test$LoanAmount

df<-data.frame(score,y,pmi,ALR,LA)
q
for (i in 1:9){
  df1<-df[df$score<q[i],]
  print(sum(df1$y))
  print(sum(df1$y)/length(df1$y))
}

v<-numeric()
df1<-df[df$score<q[1],]
print(sum(df1$y))
v<-c(v,sum(df1$y)/length(df1$y))
#print((sum(df1$ALR*df1$LA)/sum(df1$pmi*df1$LA))/(sum(df$ALR*df$LA)/sum(df$pmi*df$LA)))
print(mean(df1$ALR*df1$LA))
for (i in 1:8){
  df1<-df[df$score>=q[i] & df$score<q[i+1],]
  print(sum(df1$y))
  v<-c(v,sum(df1$y)/length(df1$y))
  #print((sum(df1$ALR*df1$LA)/sum(df1$pmi*df1$LA))/(sum(df$ALR*df$LA)/sum(df$pmi*df$LA)))
  print(mean(df1$ALR*df1$LA))
  }

df1<-df[df$score>=q[9],]
print(sum(df1$y))
v<-c(v,sum(df1$y)/length(df1$y))
#print((sum(df1$ALR*df1$LA)/sum(df1$pmi*df1$LA))/(sum(df$ALR*df$LA)/sum(df$pmi*df$LA)))
print(mean(df1$ALR*df1$LA))
