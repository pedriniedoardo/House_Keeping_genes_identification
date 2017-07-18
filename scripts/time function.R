# test the timing of the three algorithm
############################################################################
##############
# normfinder #
##############
df <- read.csv("testHK.csv")
df_data <- df[-15,]
time <- lapply(1:20,function(x){
  big_df<-{}
  big_df_2<-{}
  list_big_df<-{}
  for(i in 1:x){
    rdf<-df_data
    rdf$Tumor.type<-paste(rdf$Tumor.type,i)
    list_big_df[[i]]<-rdf
  }
  
  big_df<-do.call(what = rbind,args = list_big_df)
  # add the last grouping variables
  big_df_2 <- rbind(big_df,df[15,])
  dim(big_df_2)
  # write the csv
  write.csv(x = big_df_2,file = "big_df.csv",row.names = F)
  #try the normfinder in big datase
  t<-Sys.time()
  norm2 <- Normfinder("big_df.csv",ctVal = FALSE)
  return(Sys.time()-t)
})
# extract the time
library(stringr)
tim<-as.numeric(lapply(time,function(x){
  str_extract(x,pattern = "\\d.*\\d")
}))
dim<-(1:20)*14
# plot the times
library(ggplot2)
plot_normfinder <- ggplot(data.frame(second=tim,genes=dim),aes(x=genes,y=second))+
  geom_point()+
  ggtitle("normfinder efficiency")
############################################################################

####
####
####
df <- read.csv("testHK.csv")
df_data <- df[-15,]
time <- lapply(1:20,function(x){
  big_df<-{}
  big_df_2<-{}
  list_big_df<-{}
  for(i in 1:x){
    rdf<-df_data
    rdf$Tumor.type<-paste(rdf$Tumor.type,i)
    list_big_df[[i]]<-rdf
  }
  
  big_df<-do.call(what = rbind,args = list_big_df)
  # add the last grouping variables
  # big_df_2 <- rbind(big_df,df[15,])
  id_test <- unlist(lapply(big_df,is.numeric))
  mat2 <- as.matrix(big_df[,id_test]) 
  str(mat2)
  raw2 <- new("qPCRBatch", exprs = mat2, featureCategory =
                as.data.frame(array("OK",  dim=dim(mat2))))
  sampleNames(raw2) <- colnames(big_df)[-1]
  featureNames(raw2) <- as.character(big_df$Tumor.type)
  head(exprs(raw2))
  
  t<-Sys.time()
  norm2 <-selectHKs(raw2, method = "geNorm",
                            Symbols = featureNames(raw2),
                            minNrHK = 2, log = FALSE)
  return(Sys.time()-t)
})
# extract the time
library(stringr)
tim<-as.numeric(lapply(time,function(x){
  str_extract(x,pattern = "\\d.*\\d")
}))
dim<-(1:20)*14
# plot the times
library(ggplot2)
plot_genorm <- ggplot(data.frame(second=tim,genes=dim),aes(x=genes,y=second))+
  geom_point()+
  ggtitle("genorm efficiency")
############################################################################

df <- read.csv("testHK.csv")
df_data <- df[-15,]
time <- lapply(1:20,function(x){
  big_df<-{}
  big_df_2<-{}
  list_big_df<-{}
  for(i in 1:x){
    rdf<-df_data
    rdf$Tumor.type<-paste(rdf$Tumor.type,i)
    list_big_df[[i]]<-rdf
  }
  
  big_df<-do.call(what = rbind,args = list_big_df)
  # add the last grouping variables
  big_df <- rbind(big_df,df[15,])
  # dim(big_df_2)
  # # write the csv
  # write.csv(x = big_df_2,file = "big_df.csv",row.names = F)
  # #try the normfinder in big datase
  
  # see the boxplots
  big_df2 <- t(big_df)
  # make the first row as column
  colnames(big_df2) <- big_df2[1,]
  # remove the first row from df2
  big_df3 <- as.data.frame(big_df2[-1,])
  # make all the column as numeric
  big_df3_2 <- as.data.frame(lapply(big_df3,function(x){
    return(as.numeric(as.character(x)))
  }))
  # arrange the df for ggplot2
  library(tidyr)
  big_df3_3 <- gather(data = big_df3_2,key = gene,value = exp,-group)
  list_df3_3<-split(big_df3_3,f = big_df3_3$gene)
  
  t<-Sys.time()
  list2<-lapply(list_df3_3,function(x){
    t.test(x$exp[x$group==1],x$exp[x$group==2])$p.value
  })
  return(Sys.time()-t)
})
# extract the time
library(stringr)
tim<-as.numeric(lapply(time,function(x){
  str_extract(x,pattern = "\\d.*\\d")
}))
dim<-(1:20)*14
# plot the times
library(ggplot2)
plot_pvalue <- ggplot(data.frame(second=tim,genes=dim),aes(x=genes,y=second))+
  geom_point()+
  ggtitle("p_value efficiency")
####################
# plot the grob
library(gridExtra)
grob2 <- grid.arrange(plot_normfinder,plot_genorm,plot_pvalue)

grid.arrange(grob1,grob2,ncol=2)
