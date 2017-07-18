df <- read.csv("testHK.csv")
df$Tumor.type<-as.character(df$Tumor.type)
Normfinder("testHK.csv",ctVal = FALSE)
norm <- Normfinder("testHK.csv",ctVal = FALSE)
ord <- rownames(norm$Ordered)

# Normfinder("testHK.csv",ctVal = TRUE)

# # try a bigger dataset
# df
# 
# dff_big<-

# see the boxplots
df2<-t(df)
# make the first row as column
colnames(df2)<-df2[1,]
# remove the first row from df2
df3<-as.data.frame(df2[-1,])
# make all the column as numeric
df3_2 <- as.data.frame(lapply(df3,function(x){
  return(as.numeric(as.character(x)))
}))
# arrange the df for ggplot2
library(tidyr)
library(ggplot2)
df3_3 <- gather(data = df3_2,key = gene,value = exp,-group)

# my approach would be by using the p-value as ordering criterion 

list_df3_3<-split(df3_3,f = df3_3$gene)
list2<-lapply(list_df3_3,function(x){
  t.test(x$exp[x$group==1],x$exp[x$group==2])$p.value
})

value<-unlist(list2)
sort(value,decreasing = T)
