# load the data
df_test <- read.csv("testHK.csv")
# identify the numeric variable and extract the matrix
id_test <- unlist(lapply(df_test,is.numeric))
mat2 <- as.matrix(df_test[-nrow(df_test),id_test]) 
str(mat2)
# build the qPCRBatch file
raw2 <- new("qPCRBatch", exprs = mat2, featureCategory =
              as.data.frame(array("OK",  dim=dim(mat2))))
# add accessory information
sampleNames(raw2) <- colnames(df_test)[-1]
featureNames(raw2) <- as.character(df_test$Tumor.type[-nrow(df_test)])
head(exprs(raw2))
# build pheno data
pheno2 <- data.frame("Sample.no."=sampleNames(raw2),
                     "Classification"=unlist(df_test[which(df_test$Tumor.type=="group"),])[-1])

rownames(pheno2) <- pheno2$Sample.no.

pData(raw2)
# assign the pheno to the df
pData(raw2)<-pheno2
# check the pheno
pData(raw2)
fData(raw2)
# run the function
rank2<-selectHKs(raw2, method = "geNorm",
                 Symbols = featureNames(raw2),
                 minNrHK = 2, log = FALSE)
# extract the rank
rank2$ranking
