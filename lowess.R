x = read.csv("~/Desktop/Prosper/models.csv")

x$ExperianID<-NULL
x$X<-NULL


data  = read.csv("~/Desktop/Prosper/resmodel.csv")

for (i in 1:28){
  for (j in 1:5){
  file = c(name[i],name2[j],'.png')
  file2 = paste(file, collapse="--")
  file3 = c('~/Desktop/residual plots 2/',file2)
  file4 = paste(file3, collapse="--")
  png(filename=file4)
  data['plotx'] = data[name[i]]
  data['ploty'] = data[name2[j]]
  plot(ploty~plotx,data,xlab=name[i],ylab=name2[j], pch = 16 ,col = 'blue')
  lines(lowess(ploty~plotx,data, col = 2),col='red')
  lines(lowess(ploty~plotx,data[which(ploty>0),], col = 2),col='green')
  lines(lowess(ploty~plotx,data[which(ploty<0),], col = 2),col='green')
  dev.off()
}}