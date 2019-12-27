#loading the library
library(Boruta)
#install.packages("Boruta", repos = "https://cran.r-project.org")

boruta <- Boruta(my_data$`Hired/NotHired`~., data = new_data, doTrace = 2)
print(boruta)

#plotting the Importance for boruta
plot(boruta, xlab = "", xaxt = "n")
lz<-lapply(1:ncol(boruta$ImpHistory),function(i)
  boruta$ImpHistory[is.finite(boruta$ImpHistory[,i]),i])
names(lz) <- colnames(boruta$ImpHistory)
Labels <- sort(sapply(lz,median))
axis(side = 1,las=2,labels = names(Labels),
     at = 1:ncol(boruta$ImpHistory), cex.axis = 0.7)

#Boruta Second Part
summary(new_data)
boruta_new <- Boruta(`Hired/NotHired`~.,data =new_data,doTrace = 2)
summary(new_data)

#ploting the Importance for boruta_new
plot(boruta_new, xlab = "", xaxt = "n")
lz<-lapply(1:ncol(boruta_new$ImpHistory),function(i)
  boruta$ImpHistory[is.finite(boruta_new$ImpHistory[,i]),i])
names(lz) <- colnames(boruta_new$ImpHistory)
Labels <- sort(sapply(lz,median))
axis(side = 1,las=2,labels = names(Labels),
     at = 1:ncol(boruta_new$ImpHistory), cex.axis = 0.7)



pca <- prcomp(new_data, center = TRUE, scale. = TRUE)
str(new_data)
summary(new_data)
