df_test <- read.csv("testHK.csv")
# identify the numeric varible
id_test <- unlist(lapply(df_test,is.numeric))
mat2 <- as.matrix(df_test[-nrow(df_test),id_test]) 
str(mat2)
raw2 <- new("qPCRBatch", exprs = mat2, featureCategory =
              as.data.frame(array("OK",  dim=dim(mat2))))
sampleNames(raw2) <- colnames(df_test)[-1]
featureNames(raw2) <- as.character(df_test$Tumor.type[-nrow(df_test)])
head(exprs(raw2))

selectHKs(raw2, method = "geNorm",
          Symbols = featureNames(raw2),
          minNrHK = 2, log = FALSE)

pheno2 <- data.frame("Sample.no."=sampleNames(raw2),
                     "Classification"=unlist(df_test[which(df_test$Tumor.type=="group"),])[-1])

rownames(pheno2) <- pheno2$Sample.no.

pData(raw2)
# assign the pheno to the df
pData(raw2)<-pheno2
# check the pheno
pData(raw2)
fData(raw2)

rank2<-selectHKs(raw2, method = "geNorm",
                 Symbols = featureNames(raw2),
                 minNrHK = 2, log = FALSE)
rank2$ranking
