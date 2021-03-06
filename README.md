# Empower U.S. military members, veterans, and military spouses to succeed in the civilian workforce: Using an Analytical approach

## Overview

United States is home to many military families, made up of veterans, active-duty service members, spouses, and dependents. US active service consisted of 1,358,193 i.e. 0.4% of the US population and was the third largest active military army in the world as of 2018. The U.S. Department of Labor estimates that the military trains people in skills applicable in at least 962 civilian occupations. To support Hire Heroes in accomplishing their mission it is necessary to determine the relationship between a client’s demographic profile, amount of time spent working with individual clients (time to complete an assessment, time to complete resume, # of logged activities, etc.)  and the time required for the veterans to get hired. 


## Business Goal

Our business goal is to help HHUSA in its primary function by building a prediction model and identifying the most critical factors that are influencing a veteran to get hired. 

<img src="Images/Activity.png" width="70%" />


<img src="Images/Disability.png" width="70%" />


<img src="Images/Employment_Status.png" width="70%" />

## Data Profile

Out of the 13 datasets provided, we chose to use 3 datasets - Contacts (Demographic information of the client), Activities (activities the client participated in), and Hire Information. Hired/Not Hired was one of our derived variables; where 1 meant client was hired within 180 days and 0 meant client was not hired within 180 days.

```{r}
#Reading contacts file
my_data <- read_excel("Modified - Contacts 3.xlsx")

#Reading the acitivities file
activities <- read.csv("SalesForce_2018Activities.csv", header=T, strip.white = T, na.strings = c("NA","NaN","","?"))
```

<img src="Images/Picture1.png" width="100%" />


## Methodology

The entire data for the Teradata Data Challenge is provided by a non-profit partner, Hire Heroes USA, whose mission is to empower U.S. military members, veterans and military spouses to succeed in the civilian workforce. Hire Heroes USA uses Salesforce as their CRM, so most of their data is structured based on Salesforce's use of Objects. The data provided includes 13 spreadsheets, which we’ll be using to answer the following business questions:

❖	Is there any relationship between the amount of time spent working with individual clients (time to complete an assessment, time to complete resume, # of logged activities, etc.) and how quickly they are employed?

To answer our research question, we first try to solve what services that are offered by Hire Heroes are pertinent to this problem along with some latent qualities that the individual has. We started with accessing what are qualities in an individual which assist him in some way, to get hired quickly ( within 6 months of joining Hire Heroes)
Out of all the features given to us, we focused on 35 primary features ( - original features and - derived features) that we computed after further delving into the data and with help from Hire Heroes. Originally, we had over 300+ features, with 45% of missing data.

### Phase 1

For this phase of the project, we spent most of the time in data wrangling and feature selection. To get some idea, we ran 2 models after creating the target variable ‘Hired/NotHired’, which is a derived one. 
Before any kind of data wrangling, we used 2 models namely, Random Forest and Logistic Regression, taking only the observations with no missing variable and around 300 predictors, we got an 57% and 55% respectively, which was just above random. Then we proceeded to Data Wrangling and Feature Selection - which is covered in the Data Section of this report.

### Phase 2

To answer the Classification problem (i.e. if a person is hired in 6 months - 180 days or not), we used the derived column ‘Hired/NotHired’ as our target variable and -feature list-, and used the following predictive algorithms:

### Naive Bayes Classifier ~ baseline: 
This is a logic-based technique which is simple yet so powerful that it is often known to outperform complex algorithms for very large datasets. This algorithm is based on Bayes theorem but with strong assumptions regarding independence. This was used as our baseline model. 
For our model, we apply a Naïve Bayes model with 10-fold cross validation, which gets 68% accuracy.

### Neural Networks:
Neural Network (or Artificial Neural Network) has the ability to learn by examples. ANN is an information processing model inspired by the biological neuron system. It is composed of a large number of highly interconnected processing elements known as the neuron to solve problems. It follows the non-linear path and process information in parallel throughout the nodes. A neural network is a complex adaptive system. Adaptive means it has the ability to change its internal structure by adjusting weights of inputs. 

NN Model 1
<ul>
<li>Parameters / Tuning - 3 hidden nodes (a 64-3-1 network with 199 weights), max iteration - 100 </li>
<li> AUC - 0.8991 </li>
<li> NN Model 2 </li>
<li> Parameters / Tuning - 10 hidden nodes (a 64-10-1 network with 661 weights), max iteration - 100 </li>
<li> AUC - 0.924 </li>
</ul>


<img src="Images/NNAUC.png" width="40%" />


### GLM Net: 
This stands for Lasso and Elastic-Net Regularized Generalized Linear Models. It’s extremely efficient procedures for fitting the entire lasso or elastic-net regularization path for linear regression, logistic and multinomial regression models, Poisson regression and the Cox model. 


GLM Model
<ul>
<li>Parameters / Tuning - 3-fold Cross Validation with default parameters
<li>AUC - 0.9101
<li>Accuracy 0.8306
</ul>

GBM:
This stands for Generalized Boosted Regression Models. This is an implementation of extensions to Freund and Schapire's AdaBoost algorithm and Friedman's gradient boosting machine. Includes regression methods for least squares, absolute loss, t-distribution loss, quantile regression, logistic, multinomial logistic, Poisson, Cox proportional hazards partial likelihood, AdaBoost exponential loss, Huberized hinge loss, and Learning to Rank measures (LambdaMart). 
<ul>
  
GBM Model
<li>Parameters / Tuning - 3-fold Cross Validation with default parameters
<li>AUC: 0.9271
<li>Accuracy: 0.8597 
</ul>

<img src="Images/GBMAUC.png" width="40%" />


### Random Forest:

Random Forest is a flexible, easy to use machine learning algorithm that produces, even without hyper-parameter tuning, a great result most of the time. It is also one of the most used algorithms, because it’s simplicity and the fact that it can be used for both classification and regression tasks. In this post, you are going to learn, how the random forest algorithm works and several other important things about it.
For our analysis, we’ve used the following variants of the model:
1. Random Forest with no tuning (default values): Reported AUC is 0.9195
2. Random Forest with fine tuning: 
Used function tuneRF(). Parameters used:
<ul>
<li>ntrees: 10 to 150, best value: 120
<li>mtry: 3 to 5, best value: 5
</ul>

```

rf <- randomForest(finaltraindata$`Hired/NotHired`~., data=finaltraindata, mtry=5, 
                   ntree=120, 
                   na.action=na.exclude, 
                   importance=T,
                   proximity=F)
print(rf)

```

3. Random Forest with parameter tuning and Cross Validation: 
Used 10-fold Repeated Cross-Validation, repeating 3 times. Used ‘caret’ package, method=’rf’. Parameters used:
<ul>
<li>mtry: 3 to 7, best value: 7, 
<li>num.tree: 10 to 150, best value: 120
</ul>

4. Random Forest with Hyperparameter tuning and Cross Validation ~ final model:
Used 10-fold Repeated Cross-Validation, repeating 3 times. Used ‘caret’ package, method=’ranger’. Hyperparameter used:
<ul>
<li>mtry : 3 to 10, best value: 7
<li>splitrule: ("gini", "extratrees") - used value “gini”
<li>min.node.size : (1, 3, 5) - best value: 1

</ul>



```{r}
train.control <- trainControl(method = "cv", number = 10)

rf_finetuned2 <- expand.grid(.mtry = c(6:9),
                       .splitrule = c("gini", "extratrees"),
                       .min.node.size = c(1, 3, 5))
attach(train_data)
rf_finetuned2 <- train(`Hired/NotHired`~ ., data = train_data,
                method = "ranger",
                trControl = train.control, tuneGrid = rf_grid,
                num.trees = 120)
```

<img src="Images/RFAUC.png" width="40%" />

### Survival Analysis

In Random Forest classification model, using the features from the dataset we predicted the binary outcome of Hired & Not Hired veterans. But it is also critical to determine those features that affect the time it takes for an individual to get hired. We use survival analysis to determine this effect. Survival analysis is used to analyze data in which the time until the event is of interest. The response is often referred to as a failure time(not hired) or event time(hired). In survival analysis we are identifying the difference in the rate at which a client is  getting hired within ‘n’ days for the different variables under consideration.

```
surv.data <- myrawdata %>% select ("Hired/NotHired","Finalized_HHUSA_revised_resume_on_file__c","Status__c", "MyTrak_VTS_Assigned__c", "DaystoHire(Created-Hired)")

colnames(surv.data)[colnames(surv.data) ==  'Hired/NotHired'] <- 'Hired.Flag'

colnames(surv.data)[colnames(surv.data) ==  'DaystoHire(Created-Hired)'] <- 'DaysToHire'

 colnames(surv.data)[colnames(surv.data) ==  'Finalized_HHUSA_revised_resume_on_file__c'] <- 'Resume_Created_Revised'
colnames(surv.data)[colnames(surv.data) ==  'MyTrak_VTS_Assigned__c'] <- 'Connected_To_Transition_Specialist'

mice <- mice(surv.data[,],m=1,maxit=5,meth='pmm')

comsurvData <- complete(mice,1)

comsurvData$Hired.Flag <- ifelse(surv.data$Hired.Flag =='Not Hired', 0, 1)

comsurvData$Finalized_HHUSA_revised_resume_on_file__c <- as.factor(comsurvData$Resume_Created_Revised)

comsurvData$Connected_To_Transition_Specialist <- as.factor(comsurvData$Connected_To_Transition_Specialist)

comsurvData$Status__c <- as.factor(comsurvData$Status__c)

summary(comsurvData)

#Limiting the max days days to hire in analysis to 1000

comsurvData <- comsurvData %>% 
  filter(Hired.Flag == "1") %>% 
  filter(DaysToHire < 1000)

Survival analysis for the field Connected_To_Transition_Specialist
suranl2 <- survfit(Surv(as.numeric(comsurvData$DaysToHire),comsurvData$Hired.Flag)~comsurvData$Resume_Created_Revised)

```


## Results

We can clearly see that the highest AUC is 92.9% for the Random Forest classifier with 10-fold cross validation, 120 trees and 5 variables for splitting at each tree node. An average of 19,620 instances out of 22,881 instances is found to be classified correctly with the highest score of 19,849 instances and lowest of 19,006 instances. Here our focus is on achieving the maximum True Positives, as we want to be able to predict how many people have been hired correctly.

We observe that the most important features, which can be categorized into Active Participation, Specialist Consulting and Training Workshops. This is a significant finding as we can clearly see a direct correlation with the research question of determining if there is a relationship between the time spent with clients to how quickly they are hired. Spending time with clients here mean supporting them through trainings, providing consultation, and getting them to actively participate in various activities to stay on top of the industry standards like for resumes. We observe that the clients who have been actively participating in various activities, received consulting from specialists and have attended training workshops are more likely to be hired than those who did not.

We had some interesting findings indicating that gender and disability play an important role in determining if a client is going to be hired in less than 180 days or not. A person with a disability of greater than 60% is less likely to be hired than a person without a disability. We can say that gender male consists of the majority class so the result from this would be inconclusive unless the data is balanced for male and females. 

We also found some insights from our survival analysis which definitely helps us answer our problem statement partly. The main takeaway from this analysis is that if a client was assigned a specialist who helped them through the transition process, then the chances of the client getting hired in less than 180 days in the civilian market was significantly higher. This factors into our recommendations as well and therefore, definitely is an important finding from a result point of view.

```
summary(suranl2)

ggplot(comsurvData, aes(time = DaysToHire, status = Hired.Flag, 
                        color = factor(Connected_To_Transition_Specialist))) + geom_km()
```

<img src="Images/SurvivalAnalysis.png" width="50%" />



## Conclusion

After going through the entire process of cleaning and understanding our data and interpreting the results, we have concluded there are a few significant factors which influence a veteran’s employability in the civilian market. We concluded that the most important features can be categorized into Active Participation, Specialist Consulting and Training Workshops and, these are the factors to be considered by Hire Heroes while looking at strategizing and understanding their client requirements better. Certain demographic features like Gender, Disability and Highest Level of Education show us some correlation but we need more supporting evidence to be able to validate this. Our current data suggests that these features could be skewed and therefore this could be a potential caveat to our model. However, ignoring these features could also result in potential decision-making errors and some extra validation techniques may be required to conclude with higher confidence.

In response to our initial research question, we feel that we have successfully answered it and have been able to provide them with recommendations that could help them secure more funding to improve the quality of service currently provided. 
