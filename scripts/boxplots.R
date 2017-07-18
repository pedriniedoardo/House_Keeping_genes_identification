# shape the data in order to be accepted by ggplot
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

# order the genes by stability according to normfinder
normfinder <- ggplot(df3_3,aes(x=factor(gene,levels = ord),y=exp,fill=factor(group)))+
  geom_boxplot()+
  theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  ggtitle("normfinder ranked genes")+xlab("")

# my approach would be by using the p-value as ordering criterion 
p_value <- ggplot(df3_3,aes(x=factor(gene,levels = names(sort(value,decreasing = T))),y=exp,fill=factor(group)))+
  geom_boxplot()+
  theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  ggtitle("p_value ranked genes")+xlab("")

# rank according to genorm
genorm <- ggplot(df3_3,aes(x=factor(gene,levels = rank2$ranking),y=exp,fill=factor(group)))+
  geom_boxplot()+
  theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  ggtitle("genorm ranked genes")+xlab("")

# build the first grob
library(gridExtra)
grob1 <- do.call("grid.arrange", c(list(normfinder,genorm,p_value), ncol=1))
