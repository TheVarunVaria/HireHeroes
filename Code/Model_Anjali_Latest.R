library(readxl)
library(dplyr)
library(randomForest)
library(caret)
library(mice)

my_data <- read_excel("Modified - Contacts 3.xlsx")
colnames(my_data)
#-----------------------------
getwd()
activities <- read.csv("SalesForce_2018Activities.csv", header=T, strip.white = T, na.strings = c("NA","NaN","","?"))

subset_cols <- c("WHOID",	"STATUS", "TYPE", "Duration_CreatedAndClosed",	"REMINDERDATETIME",
                 "ISREMINDERSET","TASKSUBTYPE",	"DATA_QUALITY_SCORE__C", "CORRESPONDENCE_TYPE__C", 
                 "DISCUSSION_TOPIC__C",	"DAYS_SINCE_ACTIVITY_DATE__C", "FOR_RECORD_COUNT_IN_REPORTS__C", 
                 "BUS_DAYS_SINCE_ACTIVITY_DATE__C",	"DAYS_SINCE_CALL_ACTIVITY__C",	"DAYS_SINCE_EMAIL_ACTIVITY__C",
                 "ASSIGNED_REGION__C","ASSIGNED_PROFILE__C",	"ASSIGNED_REGION_WITH_VOLUNTEER__C", "RINGDNA__ABANDONED_CALL__C",
                 "RINGDNA__AUTOMATED_VOICEMAIL_USED__C",	"RINGDNA__AUTOMATED_VOICEMAIL__C",	"RINGDNA__CALL_CONNECTED__C",
                 "RINGDNA__CALL_DIRECTION__C",	"RINGDNA__CALL_DISPOSITION__C",
                 "RINGDNA__CALL_DURATION_MIN__C", "RINGDNA__CALL_HOUR_OF_DAY_LOCAL__C",	"RINGDNA__CALL_RATING__C",
                 "RINGDNA__CALLED_BACK__C","RINGDNA__CREATED_BY_RINGDNA__C")

activities <- activities %>%
  select(subset_cols)

#NUMBER OF LOGGED
loggedAct <- activities %>% 
  select("WHOID")


loggedAct <- as.data.frame(table(loggedAct))

loggedAct <- data.frame(loggedAct$loggedAct, loggedAct$Freq)
names(loggedAct) <- c("Id", "Num_Activities")

loggedAct$Id <- as.character(loggedAct$Id)
my_data$Id <- as.character(my_data$Id)
my_data <- left_join(my_data,loggedAct)

#Summing the missing values
colSums(is.na(my_data))

#Imputing missing values of Race with - Prefer not to answer
my_data$Race__c[is.na(my_data$Race__c)] <- "Prefer not to answer"


my_data$Num_Activities[is.na(my_data$Num_Activities)] <- 0
my_data$WHOID <- NULL

#my_data$"Race__c" <- NULL
my_data$"O2O_Status__c" <- NULL
my_data$"Hire_Records__c"<- NULL
my_data$"Possible_Job_Matches__c"<-NULL
#my_data$"Mileage_Willing_To_Commute__c" <- NULL
#my_data$"Id"<- NULL 
my_data$"AccountId"<- NULL                              
my_data$"RecordTypeId"<- NULL 
my_data$"LastModifiedById"<- NULL
my_data$"MailingState"<- NULL                              
my_data$"MailingPostalCode" <- NULL                       
my_data$"MailingCountry"<- NULL                           
my_data$"OwnerId"<- NULL                                  
my_data$"CreatedDate"<- NULL                              
my_data$"CreatedById"<- NULL                           
my_data$"LastModifiedDate"<- NULL
my_data$"LastActivityDate"<- NULL                        
my_data$"Multiple_AVR__c" <- NULL                          
my_data$"Start_Date__c"<- NULL                             
my_data$"Additional_Service_Needs__c"<- NULL              
my_data$"Last_Rank__c"<- NULL                              
my_data$"O2O_Partners_Previously_Applied_To__c"  <- NULL   
my_data$"Active__c" <- NULL
my_data$"Send_Retention_Survey__c"<- NULL
my_data$"DD214__c"<- NULL 
my_data$"Purple_Heart_Recipient__c"<- NULL
my_data$"Active_Color__c"<- NULL 
my_data$"Desired_Job_Function__c"<- NULL
my_data$"Military_Occupation__c" <- NULL 
my_data$"Submitted_for_Mentor__c"<- NULL
my_data$"VTS_Recommended_Seniority_Level__c" <- NULL
my_data$"Dat_Initial_Assessment_was_Completed__c"<- NULL
my_data$"Online_Training_Participant__c"<- NULL
my_data$"Donor__c"<- NULL
my_data$"Awards_and_Decorations_Earned__c" <- NULL
my_data$"Client__c"<- NULL                            
my_data$"Disability_Rating__c"<- NULL                      
my_data$"Client_Type__c"<- NULL                            
my_data$"Service_Branch__c" <- NULL                        
my_data$"Multiple_Hire_Review_Complete__c"<- NULL          
my_data$"Federal_Hire__c"<- NULL                           
my_data$"Hired_with_EO_assistance__c"<- NULL               
my_data$"Applied_to_hired_position_on_Job_Board__c" <- NULL
my_data$"Get_Start_Date__c" <- NULL
my_data$"Hiring_Account__c"<- NULL                         
my_data$"Service_Rank__c" <- NULL                          
my_data$"Staff_member_assigned_to_be_mentor__c" <- NULL    
my_data$"Date_assigned_to_staff__c" <- NULL                
my_data$"Date_Turned_Purple__c" <- NULL                    
my_data$"CODE_Release_on_File__c" <- NULL                  
my_data$"MyTrak_About_Me__c" <- NULL                       
my_data$"MyTrak_Military_Experience__c" <- NULL            
my_data$"MyTrak_My_Goals__c" <- NULL                        
my_data$"Date_Resume_Completed__c"<- NULL               
my_data$"Desired_City_of_Employment__c" <- NULL            
my_data$"Confirmed_Hired_Date__c" <- NULL                  
my_data$"Position_Hired_For__c" <- NULL
my_data$"Job_Type__c" <- NULL                             
my_data$"Education_Summary__c" <- NULL                     
my_data$"Hired_but_still_active_and_looking__c"  <- NULL   
my_data$"ringdna100__Email_Attempts__c"  <- NULL           
my_data$"Date_turned_grey__c" <- NULL                      
my_data$"Date_turned_green__c" <- NULL                     
my_data$"Date_of_first_contact__c"  <- NULL                
my_data$"Areas_of_Experience__c"  <- NULL                  
my_data$"Preferred_Method_of_Contact__c" <- NULL
my_data$"If_Security_Clearance_Yes_What_kind__c"  <- NULL  
my_data$"Salary_Range__c" <- NULL                        
my_data$"Date_Turned_Blue__c" <- NULL                     
my_data$"Foreign_Service_Summary__c" <- NULL               
my_data$"Workshop_Staff_Members__c" <- NULL                
my_data$"Reason_Vet_Turned_Grey__c"<- NULL                 
my_data$"Volunteer_Services__c" <- NULL                    
my_data$"Desired_Geographic_Region_of_Employment__c"<- NULL
my_data$"Submitted_for_Hire__c" <- NULL                    
my_data$"Office_Manager_Approved__c" <- NULL               
my_data$"Regional_Manager_Approved__c"<- NULL              
my_data$"Hire_Heroes_USA_Confirmed_Hire__c" <- NULL        
my_data$"Funding_Source__c"  <- NULL                       
my_data$"Desired_Industry_for_Employment__c" <- NULL       
my_data$"Desired_Earnings_Type__c" <- NULL                 
my_data$"Send_Green_Survey__c" <- NULL                     
my_data$"RealZip__RealZip__c" <- NULL                      
my_data$"CreatedDate/Initial Date(Imputed)" <- NULL
my_data$"Days to Hire" <- NULL
my_data$"ringdna100__Call_Attempts__c" <- NULL
my_data$`Hired_in 180 days_flag` <- NULL

cols <- colnames(my_data)
my_data[cols] <- lapply(my_data[cols], factor) 
summary(my_data)

my_data$Num_Activities <- as.numeric(my_data$Num_Activities)
#my_data_subset <- my_data_subset[complete.cases(my_data_subset),]

Hired <- my_data %>% 
  filter(my_data$'Hired/NotHired' =="Hired")

NotHired <- my_data %>% 
  filter(my_data$'Hired/NotHired' == "Not Hired")

SampSize = 24409
Hired <-head(Hired,SampSize)
NotHired <-head(NotHired,SampSize)

data <- rbind(Hired,NotHired)

#Summing the missing values
colSums(is.na(data))

colnames(data)

#-----------imputing missing values using mice-----------
mice <- mice(data[,-c(43)],m=1,maxit=5,meth='pmm')

completedData <- complete(mice,1)

new_data <- cbind(completedData,data$`Hired/NotHired`)

colnames(new_data)[colnames(new_data) == "data$`Hired/NotHired`"] <- "Hired/NotHired"

n = nrow(new_data)

# We create an index for 70% of obs. by random
set.seed(20)

trainIndex = sample(1:n, 
                    size = round(0.7*n), 
                    replace=FALSE) 

# We use the index to create training data

train_data = new_data[trainIndex,] 

# We take the remaining 30% as the testing data

test_data = new_data[-trainIndex,] 

summary(train_data)
summary(test_data)

#-----------Random Forest-----------

rf <- randomForest(train_data$`Hired/NotHired`~., data=train_data, mtry=5, 
                   ntree=120, 
                   na.action=na.exclude, 
                   importance=T,
                   proximity=F)
print(rf)

# RF on test data

predicted_values <- predict(rf, test_data, type= "prob")

# Confusion matrix

threshold <- 0.4

pred <- factor( ifelse(predicted_values[,2] > threshold,"Not Hired","Hired") )

head(pred)

levels(test_data$'Hired/NotHired')[2]

confusionMatrix(pred, test_data$'Hired/NotHired', 
                positive = levels(test_data$'Hired/NotHired')[2]) 

#-----------NNET-----------

library(nnet)

annfit <- nnet(train_data$`Hired/NotHired`~ ., data=train_data, 
               size=10, maxit=1000)

print(annfit)

predicted_values <- predict(annfit, test_data,type= "raw")

head(predicted_values)

threshold <- 0.5

pred <- factor( ifelse(predicted_values[,1] > threshold,"Not Hired","Hired"))

confusionMatrix(pred, test_data$'Hired/NotHired', 
                positive = levels(test_data$'Hired/NotHired')[2])

#-----------GBM-----------

gbmfit <- gbm(formula = train_data$'Hired/NotHired'~.,
               data = train_data,
               distribution = "gaussian",
               cv.folds = 10,
               shrinkage = .01,
               n.minobsinnode = 10,
               n.trees = 200)

print(gbmfit)

#this part is not running

summary(gbmfit)

bestiter = gbm.perf(gbm.fit, method="cv")

bestiter

pred <- predict.gbm(object = gbm.fit,
                    newdata = test_data$'Hired/NotHired',
                    n.trees = 200,
                    type = "response")

#---------Naive

library("klaR")
library(e1071)

model = train(x,y,'nb',trControl=trainControl(method='cv',number=10))
