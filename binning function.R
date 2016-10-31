##Input: dataset,the variables you want to use for the splits, size of split (number between 0 and 0.5 that can divide 1), 
# the monotonic trends ('+' if increasing, '-' if decreasing)
##Output: the data split, the number of observations per split, the rules that lead to the split

binning<-function(dataset,variables,size,trend){
  
  bins=list()
  obs=list()
  rules=list()
  bins[[1]]<-dataset
  obs[[1]]<-dim(dataset)[1]
  rules[[1]]<-rep('null',length(variables))
  
  for (i in 1:length(variables)){
    q <- quantile(unlist(dataset[variables[i]]),probs = seq(0, 1, size))
    
    if (trend[i]=='+'){
      m=length(bins)
      
      for (k in 1:m){
        m=length(bins)
        
        for (j in 1:length(q)){
           data_bis<-bins[[k]]
           rule<-rules[[k]]
           data_copy1<-data_bis[unlist(data_bis[variables[i]])>=q[[j]],]   #segment the data by applying succesive quantile cuts
           bins[[m+j]]<-data_copy1     #save the split in the bin list
           obs[[m+j]]<-dim(data_copy1)[1]   #save the number of observations in the obs list
           rule[i]<-q[[j]]        
           rules[[m+j]]<-rule         #save the cut in the rules list
           }}}
    
    if (trend[i]=='-'){
      m=length(bins)
      
      for (k in 1:m){
        m=length(bins)
        
        for (j in 1:length(q)){
          data_bis<-bins[[k]]
          rule<-rules[[k]]
          data_copy2<-data_bis[unlist(data_bis[variables[i]])<q[[j]],] 
          bins[[m+j]]<-data_copy2
          obs[[m+j]]<-dim(data_copy2)[1]
          rule[i]<-q[[j]]
          rules[[m+j]]<-rule
        }}}} 
  
  return(list('bins'=bins,'obs'=obs,'rules'=rules)) }



