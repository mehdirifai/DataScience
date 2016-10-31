#libraries Hmsic, MASS, Rmarkdown, Cairo, ISLR
# Compute the covariance matrix
for (i in 1:150){
  for (j in 1:150){
    if (class(predresp1[[names(predresp1)[i+345]]])=="numeric" & class(predresp1[[names(predresp1)[j+345]]])=="numeric") { A[i,j]=cov(predresp1[[names(predresp1)[i+345]]]),predresp1[[names(predresp1)[j+345]]])[1]
    }
    if (class(predresp1[[names(predresp1)[i+345]]])=="integer" & class(predresp1[[names(predresp1)[j+345]]])=="integer") { A[i,j]=cov(predresp1[[names(predresp1)[i+345]]],predresp1[[names(predresp1)[j+345]]])[1]
    }
    if (class(predresp1[[names(predresp1)[i+345]]])=="integer" & class(predresp1[[names(predresp1)[j+345]]])=="numeric"){ A[i,j]=cov(predresp1[[names(predresp1)[i+345]]],predresp1[[names(predresp1)[j+345]]])[1]
    }
    if (class(predresp1[[names(predresp1)[i+345]]])=="numeric" & class(predresp1[[names(predresp1)[j+345]]])=="integer"){ A[i,j]=cov(predresp1[[names(predresp1)[i+345]]],predresp1[[names(predresp1)[j+345]]])[1]
    }
    
   }}
###

#extract the histograms of the predictors

#1st method
for (i in 1:150){
  data= predresp1[[names(predresp1)[i+345]]]
  name ='hist.jpeg'
  new_name = sub( '(?<=.{4})', i, name, perl=TRUE )
  jpeg(filename = new_name,height=728,width=1024)
  plot = hist(data)  
  dev.off()
}

#2nd method
for (i in 1:150){
  data= predresp1[[names(predresp1)[i+345]]]
  name ='hist'
  new_name = paste(name,names(predresp1)[i+345],'.jpeg', sep='_')
  jpeg(filename = new_name ,height=728,width=1024)
  plot = hist(data)  
  dev.off()
}
##


#compute the standardized covariance matrix
D=matrix(nrow=150,ncol=150)
for (i in 1:150){
  for (j in 1:150){
    if (class(predresp1[[names(predresp1)[i+345]]])=="numeric" & class(predresp1[[names(predresp1)[j+345]]])=="numeric") { D[i,j]=cov(scale(predresp1[[names(predresp1)[i+345]]]),scale(predresp1[[names(predresp1)[j+345]]]))[1]
    }
if (class(predresp1[[names(predresp1)[i+345]]])=="integer" & class(predresp1[[names(predresp1)[j+345]]])=="integer") { D[i,j]=cov(scale(predresp1[[names(predresp1)[i+345]]]),scale(predresp1[[names(predresp1)[j+345]]]))[1]
}
if (class(predresp1[[names(predresp1)[i+345]]])=="integer" & class(predresp1[[names(predresp1)[j+345]]])=="numeric"){ D[i,j]=cov(scale(predresp1[[names(predresp1)[i+345]]]),scale(predresp1[[names(predresp1)[j+345]]]))[1]
}
if (class(predresp1[[names(predresp1)[i+345]]])=="numeric" & class(predresp1[[names(predresp1)[j+345]]])=="integer"){ D[i,j]=cov(scale(predresp1[[names(predresp1)[i+345]]]),scale(predresp1[[names(predresp1)[j+345]]]))[1]
}

  }}

## count the number of integer and numeric columns in my dataset 
s=0
for (i in 345:495){
  if (class(predresp1[[names(predresp1)[i]]])=="numeric"){s=s+1}
  if (class(predresp1[[names(predresp1)[i]]])=="integer"){s=s+1}
}
##

## count the number of character and factor columns in my dataset
t=0
for (i in 345:495){
  if (class(predresp1[[names(predresp1)[i]]])=="character"){t=t+1}
  if (class(predresp1[[names(predresp1)[i]]])=="factor"){t=t+1}
  }

## count the number of character and factor columns in my dataset
m=0
L=numeric()
for (i in 1:597){
  if (class(predresp1[[names(predresp1)[i]]])=="character"){
    m=m+1
    L=L}
  if (class(predresp1[[names(predresp1)[i]]])=="factor"){m=m+1}
}
attach(predresp1)
Occupation=as.factor(Occupation)
predresp1[Occupation]

K=numeric()
for (i in 1:599){
  L=numeric()
  if (class(predresp1[[names(predresp1)[i]]])=="numeric"){
    x=predresp1[[names(predresp1)[i]]]
    for (j in 1:100){
      L[j]=ks.test(x,"pnorm",mean(x),sd(x))$p.value
      if (mean(L)>0.1){K[i]=1}
      else { K[i]=0}
    }
  }
  if (class(predresp1[[names(predresp1)[i]]])=="integer"){ 
    x=predresp1[[names(predresp1)[i]]]
    for (j in 1:100){
    L[j]=ks.test(x,"pnorm",mean(x),sd(x))$p.value
    if (mean(L)>0.1){K[i]=1}
    else { K[i]=0}
    }}}
n=0

P=numeric()
for (j in 1:100){
  P[j]=ks.test(rnorm(50),"pnorm")$p.value
  if (mean(P)>0.1){P[i]=1}
  else { P[i]=0}
}
x=predresp1[["STG_REV006"]]
y=predresp1[["STG_REV007"]]

T=data.matrix(predresp1, rownames.force = NA)
V=matrix(nrow=150,ncol=150)
for (i in 345:495){for (j in 346:495){
  if (class(predresp1[[names(predresp1)[i]]])=="numeric" & class(predresp1[[names(predresp1)[j]]])=="numeric"){x=predresp1[[names(predresp1)[i]]]
                                                                                                               y=predresp1[[names(predresp1)[j]]]
                                                                                                               V[i-345,j-345]=rcorr(matrix(c(x,y),ncol=2),type="spearman")$r[1,2]}
  if (class(predresp1[[names(predresp1)[i]]])=="numeric" & class(predresp1[[names(predresp1)[j]]])=="integer"){x=predresp1[[names(predresp1)[i]]]
                                                                                                               y=predresp1[[names(predresp1)[j]]]
                                                                                                               V[i-345,j-345]=rcorr(matrix(c(x,y),ncol=2),type="spearman")$r[1,2]}
  if (class(predresp1[[names(predresp1)[i]]])=="integer" & class(predresp1[[names(predresp1)[j]]])=="numeric"){x=predresp1[[names(predresp1)[i]]]
                                                                                                               y=predresp1[[names(predresp1)[j]]]
                                                                                                               V[i-345,j-345]=rcorr(matrix(c(x,y),ncol=2),type="spearman")$r[1,2]}  
  if (class(predresp1[[names(predresp1)[i]]])=="integer" & class(predresp1[[names(predresp1)[j]]])=="integer"){x=predresp1[[names(predresp1)[i]]]
                                                                                                               y=predresp1[[names(predresp1)[j]]]
                                                                                                               V[i-345,j-345]=rcorr(matrix(c(x,y),ncol=2),type="spearman")$r[1,2]}}
}

}

x=predresp1[["BorrowerState"]]
y=predresp1[["InferredScore60Final"]]
rcorr(matrix(c(x,y),ncol=2),type="spearman")
cor(matrix(c(x,y),ncol=2), method="kendall", use="pairwise") 

Q=numeric()
for (i in 345:495){
x=predresp1[[names(predresp1)[i]]]
y = rcorr(matrix(c(x,predresp1[["InferredScore60Final"]]),ncol=2),type="spearman")$r[1,2]
if (y >0.8){Q[i-345]=names(predresp1)[i]}