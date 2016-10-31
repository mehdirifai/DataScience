data = read.csv("~/Desktop/homework/dataset2.csv")
data$X <-NULL
dataPCA = data
dataPCA$ExtRevenue <- NULL
pr.out=prcomp(dataPCA, scale=TRUE)
biplot(pr.out, xlabs=rep(".", nrow(dataPCA)))
biplot(pr.out,  scale=0)
pr.var=pr.out$sdev^2
pr.var
pve=pr.var/sum(pr.var)
pve
plot(pve, xlab="Principal Component", ylab="Proportion of
     Variance Explained ", ylim=c(0,1) ,type='b')
plot(cumsum(pve), xlab="Principal Component", ylab="
     Cumulative Proportion of Variance Explained ", ylim=c(0,1) ,
     type='b')

nearZeroVar(x, freqCut = 95/5, uniqueCut = 10, saveMetrics = FALSE)
