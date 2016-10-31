data = read.csv("~/Desktop/Prosper/databoosting3.csv")
y=read.csv("~/Desktop/Prosper/classes.csv")
y=data['InferredScore60Final']
data$X <-NULL
x=data


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



## test several cost values and use cross-validation to choose the one with the highest area under the curve
  s = numeric()
  for (j in 1:k){
    trainPredictors = x[folds!=j,] ## create the folds
    trainClasses = y[folds!=j,]
    testPredictors = x[folds==j,]
    testClasses = y[folds==j,]
    bstfit=gbm(InferredScore60Final~., trainPredictors, distribution= "bernoulli", n.trees=2000, shrinkage = 0.1, interaction.depth =1) ## fit the model
    testmodel = predict(bstfit,testPredictors,n.trees=2000)
    predob = prediction(testmodel ,testPredictors["InferredScore60Final"])
    auc <- performance(predob, "auc")
    auc <- unlist(slot(auc, "y.values"))
    rocplot(testmodel ,testPredictors["InferredScore60Final"], col = 'cornflowerblue',main=auc)
    abline(0,1)
    s= c(s,auc)
    print(s)
  }
print(mean(s))


3.62628*fitted-2.09354
  