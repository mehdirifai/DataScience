library(ggplot2)
library(ROCR)

ROC_plotting<-function(dataframe1, dataframe2, dataframe3, dataframe4, dataframe5, dataframe6, title1, title2, title3, title4, title5, title6){
  
  #check that all the input dataframes have the right shape
  if ((ncol(dataframe1)!=0) & (ncol(dataframe1)!=2)){print("Error! change dataframe1: 0 or 2 columns only needed")}
  if ((ncol(dataframe2)!=0) & (ncol(dataframe2)!=2)){print("Error! change dataframe2: 0 or 2 columns only needed")}
  if ((ncol(dataframe3)!=0) & (ncol(dataframe3)!=2)){print("Error! change dataframe3: 0 or 2 columns only needed")}
  if ((ncol(dataframe4)!=0) & (ncol(dataframe4)!=2)){print("Error! change dataframe4: 0 or 2 columns only needed")}
  if ((ncol(dataframe5)!=0) & (ncol(dataframe5)!=2)){print("Error! change dataframe5: 0 or 2 columns only needed")}
  if ((ncol(dataframe6)!=0) & (ncol(dataframe6)!=2)){print("Error! change dataframe6: 0 or 2 columns only needed")}
  
  
  
columns = ncol(dataframe1)+ ncol(dataframe2)+ ncol(dataframe3)+ ncol(dataframe4)+ ncol(dataframe5)+ ncol(dataframe6) 
  #check if dataset contains a descison function and response variable
  if (ncol(dataframe1)==2){
    
    predob = prediction(dataframe1[,1],dataframe1[,2])
    perf = performance(predob, "tpr", "fpr")
    auc <- performance(predob, measure = "auc")
    auc <- auc@y.values[[1]]                                        ##compute the AUC and the tpr as a function of the fpr
  
    roc.data1 <- data.frame(fpr=unlist(perf@x.values),
                         tpr=unlist(perf@y.values),model="GLM")
    
    title1<<-paste(title1,auc)
  
    #we repeat the process for every dataset
  if (ncol(dataframe2)==2){
    
    predob = prediction(dataframe2[,1],dataframe2[,2])
    perf = performance(predob, "tpr", "fpr")
    auc2 <- performance(predob, measure = "auc")
    auc2 <- auc2@y.values[[1]]
 
    roc.data2 <- data.frame(fpr=unlist(perf@x.values),
                          tpr=unlist(perf@y.values),model="GLM")
    
    title2<<-paste(title2,auc2)

  if (ncol(dataframe3)==2){
    
    predob = prediction(dataframe3[,1],dataframe3[,2])
    perf = performance(predob, "tpr", "fpr")
    auc3 <- performance(predob, measure = "auc")
    auc3 <- auc3@y.values[[1]]
 
    roc.data3 <- data.frame(fpr=unlist(perf@x.values),
                          tpr=unlist(perf@y.values),model="GLM")
    title3<<-paste(title3,auc3)
  if (ncol(dataframe4)==2){
    predob = prediction(dataframe4[,1],dataframe4[,2])
    perf = performance(predob, "tpr", "fpr")
    auc4 <- performance(predob, measure = "auc")
    auc4 <- auc4@y.values[[1]]

    roc.data4 <- data.frame(fpr=unlist(perf@x.values),
                          tpr=unlist(perf@y.values),model="GLM")
    title4<<-paste(title4,auc4)
  if (ncol(dataframe5)==2){
    predob = prediction(dataframe5[,1],dataframe5[,2])
    perf = performance(predob, "tpr", "fpr")
    auc5 <- performance(predob, measure = "auc")
    auc5 <- auc5@y.values[[1]]

    roc.data5 <- data.frame(fpr=unlist(perf@x.values),
                          tpr=unlist(perf@y.values),model="GLM")
    title5<<-paste(title5,auc5)
  if (ncol(dataframe6)==2){
    
    predob = prediction(dataframe6[,1],dataframe6[,2])
    perf = performance(predob, "tpr", "fpr")
    auc6 <- performance(predob, measure = "auc")
    auc6 <- auc6@y.values[[1]]
    print(auc6)
    roc.data6 <- data.frame(fpr=unlist(perf@x.values),
                            tpr=unlist(perf@y.values),model="GLM")
    title6<<-paste(title6,auc6)
    }}}}}}
  
   #plot the ROC curves according to the number of dataset we input
  if (columns==2){
    ggplot()  +  geom_line(data=roc.data1,aes(x=fpr,y=tpr,color="steelblue"))+
    geom_abline()  + 
    ggtitle("ROC Curves")}
  
  else if (columns==4){

    ggplot()  +  geom_line(data=roc.data1,aes(x=fpr,y=tpr,color=title1))+
    geom_line(data=roc.data2,aes(x=fpr,y=tpr,color=as.character(title2)))  +  geom_abline()  + 
    scale_color_manual(labels=c(title1,as.character(title2)),name='AUCs',values=c('red','steelblue'))+
    ggtitle("ROC Curves")}
  
  else if (columns==6){
    ggplot()  +  geom_line(data=roc.data1,aes(x=fpr,y=tpr,color=title1))+
    geom_line(data=roc.data2,aes(x=fpr,y=tpr,color=title2))  +geom_line(data=roc.data3,aes(x=fpr,y=tpr,color=title3))+  geom_abline()  + 
    scale_color_manual(labels=c(title1,title2,title3),name='AUCs',values=c('red','steelblue','green'))+
    ggtitle("ROC Curves")}
  
  else if (columns==8){
    ggplot()  +   geom_line(data=roc.data1,aes(x=fpr,y=tpr,color=title1))+
    geom_line(data=roc.data2,aes(x=fpr,y=tpr,color=as.character(title2)))  +geom_line(data=roc.data3,aes(x=fpr,y=tpr,color=title3))+ geom_line(data=roc.data4,aes(x=fpr,y=tpr,color=title4),linetype="dotted")+  geom_abline()  + 
    scale_color_manual(labels=c(title1,title2,title3,title4),name='AUCs',values=c('red','steelblue','green','orange'))+
    ggtitle("ROC Curves")}
  
  else if (columns==10){
    ggplot()  +  geom_line(data=roc.data1,aes(x=fpr,y=tpr,color=title1))+
    geom_line(data=roc.data2,aes(x=fpr,y=tpr,color=title2))  +geom_line(data=roc.data3,aes(x=fpr,y=tpr,color=title3))+ geom_line(data=roc.data4,aes(x=fpr,y=tpr,color=title4),linetype="dotted")+geom_line(data=roc.data5,aes(x=fpr,y=tpr,color=title5),linetype="dotted")+ geom_abline()  + 
    scale_color_manual(labels=c(title1,title2,title3,title4,title5),name='AUCs',values=c('red','steelblue','green','orange','purple'))+
    ggtitle("ROC Curves")}
  
  else if (columns==12){
    ggplot()  +  geom_line(data=roc.data1,aes(x=fpr,y=tpr,color=title1))+
    geom_line(data=roc.data2,aes(x=fpr,y=tpr,color=title2))  +geom_line(data=roc.data3,aes(x=fpr,y=tpr,color=title3))+ geom_line(data=roc.data4,aes(x=fpr,y=tpr,color=title4),linetype="dotted")+geom_line(data=roc.data5,aes(x=fpr,y=tpr,color=title5),linetype="dotted")+geom_line(data=roc.data5,aes(x=fpr,y=tpr,color=title6),linetype="dotted")+ geom_abline()  + 
    scale_color_manual(labels=c(title1,title2,title3,title4,title5,title6),name='AUCs',values=c('red','steelblue','green','orange','purple','yellow'))+
    ggtitle("ROC Curves")}
}