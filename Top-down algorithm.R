

#Input: dataset (dataframe), list of ranked variables (vector of characters), list of functions (vector of characters), 
#variables used by the functions (matrix or dataframe of characters), problem type (vector of characters),threshold (integer), size of the percentile (float between 0 and 0.5)


#Output:
#target: optimized values of the functions
#data: the corresponding dataset
#path: the variables used in the segmentation
#cut: values of the corresponding cuts
#direction: direction of the cut (greater or smaller than the cut)

# variable used by the functions should be in a matrix. Row i is target by function i. For every row column j is var j. 

# Possible functions mean, ratiotype1 ("sum(var1)/sum(var3)"), ratiotype2 ("sum(var1*var2)/sum(var3)"), ratiotype3 ("sum(var1)/sum(var3*var4)"), ratiotype4 ("sum(var1*var2)/sum(var3*var4)")

multi_criteria_top_down<-function(dataset,variables,functions,target_variables,type,threshold,size){

data_bis<-dataset

# compute the global performance and apply the functions over the whole dataset 
performance=numeric()
for (k in 1:length(functions)){
  if (functions[k]=='mean'){
    performance=c(performance,mean(unlist(data_bis[target_variables[k,1]])))}
  else if (functions[k]=='ratiotype1'){
    performance=c(performance,sum(data_bis[target_variables[k,1]])/sum(data_bis[target_variables[k,3]]))}
  else if (functions[k]=='ratiotype2'){
    performance=c(performance,sum(data_bis[target_variables[k,1]]*data_bis[target_variables[k,2]])/sum(data_bis[target_variables[k,3]])) } 
  else if (functions[k]=='ratiotype3'){
    performance=c(performance,sum(data_bis[target_variables[k,1]])/sum(data_bis[target_variables[k,3]]*data_bis[target_variables[k,4]]))}
  else if (functions[k]=='ratiotype4'){
    performance=c(performance,sum(data_bis[target_variables[k,1]]*data_bis[target_variables[k,2]])/sum(data_bis[target_variables[k,3]]*data_bis[target_variables[k,4]]))}}


cut<-numeric()
direction<-numeric()
path<-numeric()
var<-NULL   
for (i in 1:length(variables)){
q <- quantile(unlist(data_bis[variables[i]]),probs = seq(0+size, 1-size, size))
    for (j in 1:length(q)){
      q <- quantile(unlist(data_bis[variables[i]]),probs = seq(0+size, 1-size, size))  
      result_up<-numeric()
      result_down<-numeric()
      data_copy1<-data_bis[unlist(data_bis[variables[i]])>=q[[j]],]   #segment the data by applying succesive quantile cuts
      data_copy2<-data_bis[unlist(data_bis[variables[i]])<q[[j]],]    #parse the upper and lower part of the split 
    for (k in 1:length(functions)){
      if (functions[k]=='mean'){      #check the nature of the function
        result1=mean(unlist(data_copy1[target_variables[k,1]]))    
        result2=mean(unlist(data_copy2[target_variables[k,1]]))
        if (type[k]=='max'){  #check the nature of the problem
        if (performance[k]<result1 & result2<result1){    
          if (dim(data_copy1)[1]>threshold){   
            result_up=c(result_up,result1)   #record the result only if the performance is better over that segment 
              }}
        else if (performance[k]<result2) { 
          if (dim(data_copy2)[1]>threshold){
            result_down=c(result_down,result2)
          }}}
        else if (type[k]=='min'){
          if (performance[k]>result1 & result2>result1){
            if (dim(data_copy1)[1]>threshold){   
              result_up=c(result_up,result1)
            }}
        else if (performance[k]>result2) { 
          if (dim(data_copy2)[1]>threshold){
            result_down=c(result_down,result2)
          }}
          }}
      else if (functions[k]=='ratiotype1'){
        result1=sum(data_copy1[target_variables[k,1]])/sum(data_copy1[target_variables[k,3]])
        result2=sum(data_copy2[target_variables[k,1]])/sum(data_copy2[target_variables[k,3]])
        if (type[k]=='max'){
          if (performance[k]<result1 & result2<result1){
            if (dim(data_copy1)[1]>threshold){   
              result_up=c(result_up,result1)
            }}
          else if (performance[k]<result2) { 
            if (dim(data_copy2)[1]>threshold){
              result_down=c(result_down,result2)
            }}}
        else if (type[k]=='min'){
          if (performance[k]>result1 & result2>result1){
            if (dim(data_copy1)[1]>threshold){   
              result_up=c(result_up,result1)
            }}
          else if (performance[k]>result2) { 
            if (dim(data_copy2)[1]>threshold){
              result_down=c(result_down,result2)
            }}
        }}
      else if (functions[k]=='ratiotype2'){
        result1=sum(data_copy1[target_variables[k,1]]*data_copy1[target_variables[k,2]])/sum(data_copy1[target_variables[k,3]])
        result2=sum(data_copy2[target_variables[k,1]]*data_copy2[target_variables[k,2]])/sum(data_copy2[target_variables[k,3]])
        if (type[k]=='max'){
          if (performance[k]<result1 & result2<result1){
            if (dim(data_copy1)[1]>threshold){   
              result_up=c(result_up,result1)
            }}
          else if (performance[k]<result2) { 
            if (dim(data_copy2)[1]>threshold){
              result_down=c(result_down,result2)
            }}}
        else if (type[k]=='min'){
          if (performance[k]>result1 & result2>result1){
            if (dim(data_copy1)[1]>threshold){   
              result_up=c(result_up,result1)
            }}
          else if (performance[k]>result2) { 
            if (dim(data_copy2)[1]>threshold){
              result_down=c(result_down,result2)
            }}
        }}
      else if (functions[k]=='ratiotype3'){
        result1=sum(data_copy1[target_variables[k,1]])/sum(data_copy1[target_variables[k,3]]*data_copy1[target_variables[k,4]])
        result2=sum(data_copy2[target_variables[k,1]])/sum(data_copy2[target_variables[k,3]]*data_copy2[target_variables[k,4]])
        if (type[k]=='max'){
          if (performance[k]<result1 & result2<result1){
            if (dim(data_copy1)[1]>threshold){   
              result_up=c(result_up,result1)
            }}
          else if (performance[k]<result2) { 
            if (dim(data_copy2)[1]>threshold){
              result_down=c(result_down,result2)
            }}}
        else if (type[k]=='min'){
          if (performance[k]>result1 & result2>result1){
            if (dim(data_copy1)[1]>threshold){   
              result_up=c(result_up,result1)
            }}
          else if (performance[k]>result2) { 
            if (dim(data_copy2)[1]>threshold){
              result_down=c(result_down,result2)
            }}
        }}
    else if (functions[k]=='ratiotype4'){
      result1=sum(data_copy1[target_variables[k,1]]*data_copy1[target_variables[k,2]])/sum(data_copy1[target_variables[k,3]]*data_copy1[target_variables[k,4]])
      result2=sum(data_copy2[target_variables[k,1]]*data_copy2[target_variables[k,2]])/sum(data_copy2[target_variables[k,3]]*data_copy2[target_variables[k,4]])
      if (type[k]=='max'){
        if (performance[k]<result1 & result2<result1){
          if (dim(data_copy1)[1]>threshold){   
            result_up=c(result_up,result1)
          }}
        else if (performance[k]<result2) { 
          if (dim(data_copy2)[1]>threshold){
            result_down=c(result_down,result2)
          }}}
      else if (type[k]=='min'){
        if (performance[k]>result1 & result2>result1){
          if (dim(data_copy1)[1]>threshold){   
            result_up=c(result_up,result1)
          }}
        else if (performance[k]>result2) { 
          if (dim(data_copy2)[1]>threshold){
            result_down=c(result_down,result2)
          }}
      }}} 
      if (length(result_up)==length(functions)){   
        performance<-result_up      #if the overall performance over the segment is better then we record the result as the new value to hit
        path<-c(path,variables[i])  # we also keep track of the modifications made
        cut<-c(cut,q[[j]])
        direction<-c(direction,'+')
        var<-variables[i]
      }
    else if (length(result_down)==length(functions)){
      performance<-result_down     
      path<-c(path,variables[i])
      cut<-c(cut,q[[j]])
      direction<-c(direction,'-')
      var<-variables[i]
    }}
  if (length(direction)>0) {
    if (direction[length(direction)]=='+' & var==variables[i]){           #the new segment replaces the dataset 
    data_bis<-data_bis[unlist(data_bis[variables[i]])>=cut[length(cut)],]}
    else if (direction[length(direction)]=='-' & var==variables[i]){
    data_bis<-data_bis[unlist(data_bis[variables[i]])<cut[length(cut)],]
    }
  }    
   print(dim(data_bis))
   } 

return(list('target'=performance,'path'=path,'cut'=cut,'direction'=direction,'data'=data_bis))}





