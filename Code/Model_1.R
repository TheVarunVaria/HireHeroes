
options(java.parameters = "-Xmx2048m")

#mydata <- read.xlsx("Merged_Contact_HireInformation.xlsx", sheetName = "Sheet2")
#data <- read.table("Merged_Contact_HireInformation.xlsx",sep=",", header=T, strip.white = T, na.strings = c("NA","NaN","","?"))

library(readxl)
setwd('/Volumes/GoogleDrive/My Drive/Teradata/')
getwd()
my_data <- read_excel("Merged_Contact_HireInformation.xlsx", sheet = 1)
head(my_data)
summary(my_data)
colnames(my_data)

col_to_drop <- c('RecordTypeId','CreatedById.x','LastModifiedDate.x','LastActivityDate.x',)
my_data[col_to_drop]<-NULL

col_selected <- c('priority_veteran__c','O2O_Program_Participant__c','VCTP_Participant__c','Active_Color__c','Gender__c','Race__c','Job_Type__c','Used_Volunteer_Services__c','On_Job_Board__c','Created_LinkedIn_account__c','Highest_Level_of_Education_Completed__c','Service_Branch__c','Service_Rank__c','Time__to__hire__flag')
my_data_subset <- my_data[col_selected]
my_data_subset <- my_data_subset[complete.cases(my_data_subset), ]

my_data_subset$O2O_Program_Participant__c <- as.factor(my_data_subset$O2O_Program_Participant__c)
my_data_subset$VCTP_Participant__c <- as.factor(my_data_subset$VCTP_Participant__c)
my_data_subset$priority_veteran__c <- as.factor(my_data_subset$priority_veteran__c)
my_data_subset$Active_Color__c <- as.factor(my_data_subset$Active_Color__c)
my_data_subset$Gender__c <- as.factor(my_data_subset$Gender__c)
my_data_subset$Race__c <- as.factor(my_data_subset$Race__c)
my_data_subset$Job_Type__c <- as.factor(my_data_subset$Job_Type__c)
my_data_subset$Highest_Level_of_Education_Completed__c <- as.factor(my_data_subset$Highest_Level_of_Education_Completed__c)
my_data_subset$On_Job_Board__c <- as.factor(my_data_subset$On_Job_Board__c)
my_data_subset$Used_Volunteer_Services__c <- as.factor(my_data_subset$Used_Volunteer_Services__c)
my_data_subset$Service_Branch__c <- as.factor(my_data_subset$Service_Branch__c)
my_data_subset$Service_Rank__c <- as.factor(my_data_subset$Service_Rank__c)
my_data_subset$Created_LinkedIn_account__c <- as.factor(my_data_subset$Created_LinkedIn_account__c)

#summary(my_data_subset$Created_LinkedIn_account__c)
my_data_subset$Time__to__hire__flag <-as.factor(my_data_subset$Time__to__hire__flag)

summary(my_data_subset)

train_data <- head(my_data_subset, n = 2000)
colnames(train_data)

test_data <- tail(my_data_subset, n = 690)
colnames(test_data)

library(randomForest)
rf <-randomForest(Time__to__hire__flag~., data=my_data_subset, ntree=10, na.action=na.exclude, importance=T,
                  proximity=T) 

print(rf)
importance(rf)


my_data_subset1 <- my_data %>% filter(Used_Volunteer_Services__c==1) %>% select(Time__to__hire__c)
ftable(xtabs(~Used_Volunteer_Services__c+Time__to__hire__flag, data=my_data))
table_HOLOW<- table(data$Hospital.Ownership,data$low_rating)

summary(my_data_subset1$Time__to__hire__c)

hist(my_data_subset1$Time__to__hire__c)


library(caret)
#Logit
lreg <-train(Time__to__hire__flag~., data=train_data,method="glm",family=binomial()) 
#feature importance
varImp(lreg)

### predict on test dataset
lreg_pred<-predict(lreg,test_data)

##results
confusionMatrix(lreg_pred,test_data$Time__to__hire__flag, positive = '1')





