#


library(readxl)
setwd('/Volumes/GoogleDrive/My Drive/Teradata/Data')
getwd()
my_data_subset <- read_excel("Modified - Contacts 3_features_Dikshya.xlsx", sheet = 1)
head(my_data_subset)
cols <- colnames(my_data_subset)

my_data_subset[cols] <- lapply(my_data_subset[cols], factor) 
summary(my_data_subset)

'''
my_data_subset$MailingState <- as.factor(my_data_subset$MailingState)
my_data_subset$Gender__c <- as.factor(my_data_subset$Gender__c)
my_data_subset$Race__c <- as.factor(my_data_subset$Race__c)
my_data_subset$Status__c <- as.factor(my_data_subset$Status__c)

my_data_subset$O2O_Program_Participant__c <- as.factor(my_data_subset$O2O_Program_Participant__c)
my_data_subset$VCTP_Participant__c <- as.factor(my_data_subset$VCTP_Participant__c)
my_data_subset$priority_veteran__c <- as.factor(my_data_subset$priority_veteran__c)
my_data_subset$Active_Color__c <- as.factor(my_data_subset$Active_Color__c)
my_data_subset$Job_Type__c <- as.factor(my_data_subset$Job_Type__c)
my_data_subset$Highest_Level_of_Education_Completed__c <- as.factor(my_data_subset$Highest_Level_of_Education_Completed__c)
my_data_subset$On_Job_Board__c <- as.factor(my_data_subset$On_Job_Board__c)
my_data_subset$Used_Volunteer_Services__c <- as.factor(my_data_subset$Used_Volunteer_Services__c)
my_data_subset$Service_Branch__c <- as.factor(my_data_subset$Service_Branch__c)
my_data_subset$Service_Rank__c <- as.factor(my_data_subset$Service_Rank__c)
my_data_subset$Created_LinkedIn_account__c <- as.factor(my_data_subset$Created_LinkedIn_account__c)
my_data_subset$Hired_in_180_days_flag<- as.factor(my_data_subset$Hired_in_180_days_flag )
summary(my_data_subset)
sub <- my_data_subset[complete.cases(my_data_subset),]

for(i in 1:ncol(my_data_subset)){

my_data_subset[,i] <- as.factor(my_data_subset[,i])

}
col_to_drop <- c("AccountId")
my_data[col_to_drop]<-NULL
'''


my_data_subset <- my_data_subset[complete.cases(my_data_subset),]

#library(rpart)
#data_balanced_under <- rpart(Hired_in_180_days_flag ~ ., method = "class", data =  my_data_subset)
#data_balanced_under <- ovun.sample(Hired_in_180_days_flag ~ ., data = my_data_subset, method = "under", N = 30000, seed = 1)$my_data_subset

library(dplyr)
Hiredin180 <- my_data_subset %>% filter(my_data_subset$Hired_in_180_days_flag =='Hired<180')
Hiredinmore180 <- my_data_subset %>% filter(my_data_subset$Hired_in_180_days_flag =='Hired>180')
NotHired <- my_data_subset %>% filter(my_data_subset$Hired_in_180_days_flag =='Not Hired')

#set.seed(100)
SampSize = 8000
Hiredin180 <-head(Hiredin180,SampSize)
Hiredinmore180 <-head(Hiredinmore180,SampSize)
NotHired <-head(NotHired,SampSize)

#train <- Hiredin180 + Hiredin180 + NotHired
#df_list <- list(Hiredin180 ,Hiredin180 ,NotHired)
data <- rbind(Hiredin180 ,Hiredinmore180 ,NotHired)
data <- data[sample(nrow(data)),]

cols <- colnames(my_data_subset)

data[cols] <- lapply(data[cols], factor) 

summary(data)

library(randomForest)
rf <-randomForest(Hired_in_180_days_flag~., data=data, ntree=100, na.action=na.exclude, importance=T,
                  proximity=T) 


print(rf)
importance(rf)
varImpPlot(rf)
#10 trees to 150 trees
for(ntree in 10*c(1:15)) {
  set.seed(42)
  rf = randomForest(Hired_in_180_days_flag~., data=data, ntree=ntree, na.action=na.exclude, importance=T,
                    proximity=F)
  print(rf)
}

set.seed(42)
mtry <- tuneRF(data[-26], data$Hired_in_180_days_flag, ntreeTry=90,  stepFactor=1.5, improve=0.01, trace=TRUE, plot=TRUE,na.action=na.exclude)

rf <- randomForest(Hired_in_180_days_flag~., data=data, mtry= 15, ntree=90, na.action=na.exclude, importance=T,
                  proximity=F)
print(rf)

SampSize = 1500
Hiredin180 <-tail(Hiredin180,SampSize)
Hiredinmore180 <-tail(Hiredinmore180,SampSize)
NotHired <-tail(NotHired,SampSize)
dataT <- rbind(Hiredin180 ,Hiredinmore180 ,NotHired)
dataT <- dataT[sample(nrow(dataT)),]

library(caret)

predicted_values <- predict(rf, dataT) # Use the classifier to make the predictions. With the package that we used, type "raw" will give us the probabilities

head(predicted_values)

confusionMatrix(predicted_values, dataT$Hired_in_180_days_flag, positive = levels(dataT$Hired_in_180_days_flag)[1])


library(nnet)
ann1 <- nnet(Hired_in_180_days_flag~., data=data, size=24, maxit=1000) 
