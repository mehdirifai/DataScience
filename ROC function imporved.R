## Plots several ROC curves on the same grid using ggplot2

#Input: dataframes containing the prediction vector and the true response (list of dataframes), titles you want to assign to your ROC curves (vector of characters)

#Output: ROC curves


library(ggplot2)
library(ROCR)

ROC_plotting<-function(dataframes, titles, plot_title){
  colors=c('red','steelblue','green','orange','purple','yellow','burlywood','brown','darkgray','darkslategray')
  
  co<<-colors[1:length(dataframes)]
  #check that all the input dataframes have the right shape
  for (i in 1:length(dataframes)){
    dataframe<-dataframes[[i]]
    if ((ncol(dataframe)!=0) & (ncol(dataframe)!=2)){
      print("Error! change dataframes: 0 or 2 columns only needed")}}
  rocdata<-NULL
  
  roc.data<-list()
  div<-as.factor(sample(1:3,3,replace=FALSE))
  #check if dataset contains a descison function and response variable
  for (i in 1:length(dataframes)){
    dataframe<-dataframes[[i]]
    predob = prediction(dataframe[,1],dataframe[,2])
    perf = performance(predob, "tpr", "fpr")
    auc <- performance(predob, measure = "auc")
    auc <- round(auc@y.values[[1]],digits=3)                                        ##compute the AUC and the tpr as a function of the fpr
    roc.data[[i]] <- data.frame(fpr=unlist(perf@x.values),
                            tpr=unlist(perf@y.values),model="GLM")
    titles[i]<-paste(titles[i],auc)
    roc.data[[i]]$group<-i
    roc.data[[i]]$color<-co[i]
    rocdata<-rbind(rocdata,roc.data[[i]])
    print(titles[i])
    print(co[i])
    }
    print(titles)
    print(co)
    View(rocdata)
    #colors=c('red','steelblue','green','orange','purple','yellow','burlywood','brown','darkgray','darkslategray')
    
    #co<<-colors[1:length(dataframes)]

    
  #merge the data sets to plot the ROCs using ggplot  
  #rocdata<-NULL
  #for (j in 1:length(dataframes)){
  #  rocdata<-rbind(rocdata,roc.data[[j]])}
    ggplot(rocdata,aes(x=fpr,y=tpr,group=factor(group),col=color)) + geom_abline() +geom_line() + scale_color_manual(labels=titles,name='AUCs',values=co) + ggtitle(plot_title)
}


df4<-data.frame(fraud2014=fraud3$fraudprobscore,flg1=fraud3$flg,ida=fraud3$idascoreIDScore,
                flg2=fraud3$flg)

month<-c(10,11,12,1,2,3)
title<-c('October 2015','November 2015','December 2015','January 2016','February 2016','March 2016')
for (i in 1:6){
fraud5<-fraud3[fraud3$st==month[i],]
l<-list()
d<-data.frame(fraud2014=fraud5$fraudprobscore,flg1=fraud5$flg)
l[[1]]=d
d<-data.frame(fraud2014=fraud5$idascoreIDScore,flg1=fraud5$flg)
l[[2]]=d
ROC_plotting(l,c('Fraud2014','IDAScore'),title[i])
}

fraud5<-fraud3[fraud3$st==11,]
l<-list()
d<-data.frame(fraud2014=fraud5$fraudprobscore,flg1=fraud5$flg)
l[[1]]=d
d<-data.frame(fraud2014=fraud5$idascoreIDScore,flg1=fraud5$flg)
l[[2]]=d
ROC_plotting(l,c('Fraud2014','IDAScore'),'November 2015')

fraud5<-fraud3[fraud3$st==12,]
l<-list()
d<-data.frame(fraud2014=fraud5$fraudprobscore,flg1=fraud5$flg)
l[[1]]=d
d<-data.frame(fraud2014=fraud5$idascoreIDScore,flg1=fraud5$flg)
l[[2]]=d
ROC_plotting(l,c('Fraud2014','IDAScore'),'December 2015')

fraud5<-fraud3[fraud3$st==1,]
l<-list()
d<-data.frame(fraud2014=fraud5$fraudprobscore,flg1=fraud5$flg)
l[[1]]=d
d<-data.frame(fraud2014=fraud5$idascoreIDScore,flg1=fraud5$flg)
l[[2]]=d
ROC_plotting(l,c('Fraud2014','IDAScore'),'January 2016')

fraud5<-fraud3[fraud3$st==2,]
l<-list()
d<-data.frame(fraud2014=fraud5$fraudprobscore,flg1=fraud5$flg)
l[[1]]=d
d<-data.frame(fraud2014=fraud5$idascoreIDScore,flg1=fraud5$flg)
l[[2]]=d
ROC_plotting(l,c('Fraud2014','IDAScore'),'February 2016')

fraud5<-fraud3[fraud3$st==3,]
l<-list()
d<-data.frame(fraud2014=fraud5$fraudprobscore,flg1=fraud5$flg)
l[[1]]=d
d<-data.frame(fraud2014=fraud5$idascoreIDScore,flg1=fraud5$flg)
l[[2]]=d
ROC_plotting(l,c('Fraud2014','IDAScore'),'March 2016')


a<-catch_rates(fraud3[fraud3$st==3,]$flg,fraud3[fraud3$st==3,]$idascoreIDScore)
r1<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r1['group']<-1
r1['col']<-'red'
a<-catch_rates(fraud3[fraud3$st==3,]$flg,fraud3[fraud3$st==3,]$fraudprobscore)
r2<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r2['group']<-2
r2['col']<-'steelblue'
r<-rbind(r1,r2)
ggplot(r,aes(x=cumu_prop_pop,y=cumu_list_catch_rt,group=group,col=col))+
  scale_color_manual(labels=c('IDA','Fraud2014'),name='AUCs',values=c('red','steelblue'))+geom_line()+ggtitle('March 2016')


a<-catch_rates(fraud3[fraud3$st==2,]$flg,fraud3[fraud3$st==2,]$idascoreIDScore)
r1<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r1['group']<-1
r1['col']<-'red'
a<-catch_rates(fraud3[fraud3$st==2,]$flg,fraud3[fraud3$st==2,]$fraudprobscore)
r2<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r2['group']<-2
r2['col']<-'steelblue'
r<-rbind(r1,r2)
ggplot(r,aes(x=cumu_prop_pop,y=cumu_list_catch_rt,group=group,col=col))+
  scale_color_manual(labels=c('IDA','Fraud2014'),name='AUCs',values=c('red','steelblue'))+geom_line()+ggtitle('February 2016')

a<-catch_rates(fraud3[fraud3$st==1,]$flg,fraud3[fraud3$st==1,]$idascoreIDScore)
r1<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r1['group']<-1
r1['col']<-'red'
a<-catch_rates(fraud3[fraud3$st==1,]$flg,fraud3[fraud3$st==1,]$fraudprobscore)
r2<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r2['group']<-2
r2['col']<-'steelblue'
r<-rbind(r1,r2)
ggplot(r,aes(x=cumu_prop_pop,y=cumu_list_catch_rt,group=group,col=col))+
  scale_color_manual(labels=c('IDA','Fraud2014'),name='AUCs',values=c('red','steelblue'))+geom_line()+ggtitle('January 2016')

a<-catch_rates(fraud3[fraud3$st==12,]$flg,fraud3[fraud3$st==12,]$idascoreIDScore)
r1<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r1['group']<-1
r1['col']<-'red'
a<-catch_rates(fraud3[fraud3$st==12,]$flg,fraud3[fraud3$st==12,]$fraudprobscore)
r2<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r2['group']<-2
r2['col']<-'steelblue'
r<-rbind(r1,r2)
ggplot(r,aes(x=cumu_prop_pop,y=cumu_list_catch_rt,group=group,col=col))+
  scale_color_manual(labels=c('IDA','Fraud2014'),name='AUCs',values=c('red','steelblue'))+geom_line()+ggtitle('December 2015')

a<-catch_rates(fraud3[fraud3$st==11,]$flg,fraud3[fraud3$st==11,]$idascoreIDScore)
r1<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r1['group']<-1
r1['col']<-'red'
a<-catch_rates(fraud3[fraud3$st==11,]$flg,fraud3[fraud3$st==11,]$fraudprobscore)
r2<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r2['group']<-2
r2['col']<-'steelblue'
r<-rbind(r1,r2)
ggplot(r,aes(x=cumu_prop_pop,y=cumu_list_catch_rt,group=group,col=col))+
  scale_color_manual(labels=c('IDA','Fraud2014'),name='AUCs',values=c('red','steelblue'))+geom_line()+ggtitle('November 2015')

a<-catch_rates(fraud3[fraud3$st==10,]$flg,fraud3[fraud3$st==10,]$idascoreIDScore)
r1<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r1['group']<-1
r1['col']<-'red'
a<-catch_rates(fraud3[fraud3$st==10,]$flg,fraud3[fraud3$st==10,]$fraudprobscore)
r2<-a[,c('cumu_prop_pop','cumu_list_catch_rt')]
r2['group']<-2
r2['col']<-'steelblue'
r<-rbind(r1,r2)
ggplot(r,aes(x=cumu_prop_pop,y=cumu_list_catch_rt,group=group,col=col))+
  scale_color_manual(labels=c('IDA','Fraud2014'),name='AUCs',values=c('red','steelblue'))+geom_line()+ggtitle('October 2015')



a<-catch_rates(fraud3[fraud3$st==10,]$flg,fraud3[fraud3$st==10,]$idascoreIDScore)
r1<-a[,c('cumu_prop_pop','score')]
r1['group']<-1
r1['col']<-'steelblue'
ggplot(r1,aes(x=score,y=cumu_prop_pop,group=st))+scale_color_manual(labels=c('IDA','Fraud2014'),name='AUCs',values=c('red','steelblue','green','yellow','blue','purple'))+geom_line()+ggtitle('October 2015')

a<-catch_rates(fraud3[fraud3$st==10,]$flg,fraud3[fraud3$st==10,]$fraudprobscore)
r2<-a[,c('cumu_prop_pop','score')]
r2['group']<-2
r2['col']<-'steelblue'
r<-rbind(r1,r2)
ggplot(r,aes(x=score,y=cumu_prop_pop,group=group,col=col))+
  scale_color_manual(labels=c('IDA','Fraud2014'),name='AUCs',values=c('red','steelblue'))+geom_line()+ggtitle('October 2015')

a<-catch_rates(fraud3[fraud3$st==10,]$flg,fraud3[fraud3$st==10,]$idascoreIDScore)
r1<-a[,c('cumu_prop_pop','score')]
r1['group']<-1
r1['col']<-'steelblue'

a<-catch_rates(fraud3[fraud3$st==12,]$flg,fraud3[fraud3$st==12,]$idascoreIDScore)
r2<-a[,c('cumu_prop_pop','score')]
r2['group']<-2
r2['col']<-'red'

a<-catch_rates(fraud3[fraud3$st==3,]$flg,fraud3[fraud3$st==3,]$idascoreIDScore)
r3<-a[,c('cumu_prop_pop','score')]
r3['group']<-3
r3['col']<-'green'
r<-rbind(r1,r2,r3)
ggplot(r,aes(x=score,y=cumu_prop_pop,group=group,col=col))+
  scale_color_manual(labels=c('IDA October','IDA December','IDA March'),name='Catch Rate',values=c('red','steelblue','green'))+geom_line()+ggtitle('Catch Rate by month')
