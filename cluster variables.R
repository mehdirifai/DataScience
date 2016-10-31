## Uses WOE and clustering to carry out variable selection

##input: dataset (dataframe), number of variables desired (integer), the target variable that you want to build a model upon (character) 

##output: list of variables

library(ClustOfVar)
library(devtools)
install_github("riv","tomasgreif")
library(woe)


var_clusters<-function(data,n,target){

  #if the information values is computed we just need to upload it
  if ('IV_varclus.rds' %in% list.files(path=".")){
      IV_varclus<-readRDS("IV_varclus.rds")
  }
  else{
      IV_varclus<-iv.mult(data,target,TRUE)   #if it is the fisrt time running the function on this dataset then we have to compute the information values of the predictors
      saveRDS(IV_varclus,'IV_varclus.rds')
  }

data_copy<-data
data_copy<-data_copy[,!(names(data_copy)==target)]   #keep only the dataset without the target variable

nume=numeric()
quan=numeric()

quant<-lapply(data_copy,is.numeric)         #separate numeric and the qualitative predicors
  for (i in 1:length(quant)){ 
       if (quant[i]=='TRUE'){
           nume=c(nume,labels(quant[i]))
        }
       else {
           quan=c(quan,labels(quant[i]))
        }
  }
  
#if the information values is computed we just need to upload it
  if ('hclusvar.rds' %in% list.files(path=".")){    
      clus<-readRDS(file='hclusvar.rds')
  }
  else{ 
      clus<-hclustvar(data_copy[,nume],data_copy[,quan])   #if it is the fisrt time running the function on this dataset then we have to cluster the dataset
      saveRDS(clus,'hclusvar.rds')
  }

clusters<-cutreevar(clus,k=n)       #set the number of clusters

#extract the variable that has the highest information value in each cluster
variables=numeric()
  for (i in 1:n){
      cluster<-labels(clusters$var[i][[1]])[[1]]
      df<-data.frame(cluster,iv=IV_varclus[IV_varclus$Variable %in% cluster,2])
      variables=c(variables,as.character(df[df$iv==max(df$iv),1]))
  }

return(variables)
}

#clean the directory from the information value and cluster that we have computed. We have to run this function whenever we change the dataset
clean_directory<-function(){
  unlink('hclusvar.rds')
  unlink('IV_varclus.rds')}


