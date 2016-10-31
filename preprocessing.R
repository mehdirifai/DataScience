library(caret)
library(RANN)

new_predictors =  read.csv("~/Desktop/Prosper/new_predictors5.csv")
new_predictors$Unnamed..0 <- NULL 

name = names(new_predictors)


## using Sonia's function and the datasets extracted with selectKbest on python to fill the NAs of every predictors using conditional replacement
for (i in 1:length(name)){
  if (class(new_predictors[[name[i]]])=="numeric"){
    file_name='selects3_.csv'
    new_name = sub( '(?<=.{9})', name[i], file_name, perl=TRUE )
    preprocess = read.csv(paste("~/Desktop/Prosper/",new_name,sep=""), header = TRUE)
    preprocess$X <- NULL 
    # list_variables = colnames(predictors)
    fill_NA = preProcess(prepro, method = c("BoxCox", "center", "scale","knnImpute"))
    new_predictor = predict(fill_NA, prepro)
    new_predictors[name[i]] = new_predictor['t1']
  }
}

## finalize the NA filling and scaling the quantitative data
quant_dataset = na.roughfix(new_predictors)
for (i in 1:length(name)){
  if (class(quant_dataset[[name[i]]])=="numeric"){
  quant_dataset[name[i]] = scale(quant_dataset[name[i]])}
}

write.csv(quant_dataset,"quant_data.csv")
preprocessed_data = read.csv("~/Desktop/Prosper/preprocessed_data_v5.csv")
columns = names(preprocessed_data)

## scaling the quantitative and qualitative dataset
for (i in 1:length(columns)){
  if (class(preprocessed_data[[columns[i]]])=="numeric"){
    preprocessed_data[columns[i]] = scale(preprocessed_data[columns[i]])}
}

write.csv(new_data,"preprocessed_datasetv4.csv")
