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


library(devtools)
install_github("riv","tomasgreif")
library(woe)

b<-iv.mult(data3,'TDC_flag',TRUE)
iv.plot.summary(b)
iv.mult(data_gbm,'TDC_flag',vars=c('REV201','BAC042'))
iv.plot.woe(iv.mult(data_gbm,'TDC_flag',vars=c('REV201','BAC042'),summary=FALSE))

tree.data<-ctree(TDC_flag~.,data3)

summary(tree.data)
plot(tree.data)
text(tree.data,pretty=0)
tree.data

nume=numeric()
quan=numeric()

quant<-lapply(data,is.numeric)
for (i in 1:length(quant)){ 
  if (quant[i]=='TRUE'){
    nume=c(nume,labels(quant[i]))
  }
  else {
    quan=c(quan,labels(quant[i]))
  }
}

nume=numeric()
quan=numeric()

quant<-lapply(data3,is.numeric)
for (i in 1:length(quant)){ 
  if (quant[i]=='TRUE'){
    nume=c(nume,labels(quant[i]))
  }
  else {
    quan=c(quan,labels(quant[i]))
  }
}

clus<-hclustvar(data3[,nume],data3[,quan])

