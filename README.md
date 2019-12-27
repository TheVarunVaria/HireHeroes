# Helping Veterans get hired in civilian workforce using data science 

## Overview

United States is home to many military families, made up of veterans, active-duty service members, spouses, and dependents. US active service consisted of 1,358,193 i.e. 0.4% of the US population and was the third largest active military army in the world as of 2018. The U.S. Department of Labor estimates that the military trains people in skills applicable in at least 962 civilian occupations. To support Hire Heroes in accomplishing their mission it is necessary to determine the relationship between a client’s demographic profile, amount of time spent working with individual clients (time to complete an assessment, time to complete resume, # of logged activities, etc.)  and the time required for the veterans to get hired. 


## Business Goal

Our business goal is to help HHUSA in its primary function by building a prediction model and identifying the most critical factors that are influencing a veteran to get hired. 

## Data Profile

Out of the 13 datasets provided, we chose to use 3 datasets - Contacts (Demographic information of the client), Activities (activities the client participated in), and Hire Information. Hired/Not Hired was one of our derived variables; where 1 meant client was hired within 180 days and 0 meant client was not hired within 180 days.

```{r}
#Reading contacts file
my_data <- read_excel("Modified - Contacts 3.xlsx")

#Reading the acitivities file
activities <- read.csv("SalesForce_2018Activities.csv", header=T, strip.white = T, na.strings = c("NA","NaN","","?"))
```
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

Naive Bayes Classifier ~ baseline: 
This is a logic-based technique which is simple yet so powerful that it is often known to outperform complex algorithms for very large datasets. This algorithm is based on Bayes theorem but with strong assumptions regarding independence. This was used as our baseline model. 
For our model, we apply a Naïve Bayes model with 10-fold cross validation, which gets 68% accuracy.

Neural Networks:
Neural Network (or Artificial Neural Network) has the ability to learn by examples. ANN is an information processing model inspired by the biological neuron system. It is composed of a large number of highly interconnected processing elements known as the neuron to solve problems. It follows the non-linear path and process information in parallel throughout the nodes. A neural network is a complex adaptive system. Adaptive means it has the ability to change its internal structure by adjusting weights of inputs. 

NN Model 1 
●	Parameters / Tuning - 3 hidden nodes (a 64-3-1 network with 199 weights), max iteration - 100 
●	AUC - 0.8991
NN Model 2
●	Parameters / Tuning - 10 hidden nodes (a 64-10-1 network with 661 weights), max iteration - 100 
●	AUC - 0.924

GLM Net: 
This stands for Lasso and Elastic-Net Regularized Generalized Linear Models. It’s extremely efficient procedures for fitting the entire lasso or elastic-net regularization path for linear regression, logistic and multinomial regression models, Poisson regression and the Cox model. 

GLM Model
●	Parameters / Tuning - 3-fold Cross Validation with default parameters
●	AUC - 0.9101
●	Accuracy 0.8306

GBM:
This stands for Generalized Boosted Regression Models. This is an implementation of extensions to Freund and Schapire's AdaBoost algorithm and Friedman's gradient boosting machine. Includes regression methods for least squares, absolute loss, t-distribution loss, quantile regression, logistic, multinomial logistic, Poisson, Cox proportional hazards partial likelihood, AdaBoost exponential loss, Huberized hinge loss, and Learning to Rank measures (LambdaMart). 

GBM Model
●	Parameters / Tuning - 3-fold Cross Validation with default parameters
●	AUC: 0.9271
●	Accuracy: 0.8597 

Random Forest:
Random Forest is a flexible, easy to use machine learning algorithm that produces, even without hyper-parameter tuning, a great result most of the time. It is also one of the most used algorithms, because it’s simplicity and the fact that it can be used for both classification and regression tasks. In this post, you are going to learn, how the random forest algorithm works and several other important things about it.
For our analysis, we’ve used the following variants of the model:
a)	Random Forest with no tuning (default values): Reported AUC is 0.9195
b)	Random Forest with fine tuning: 
Used function tuneRF(). Parameters used:
●	ntrees: 10 to 150, best value: 120
●	mtry: 3 to 5, best value: 5
     c)	Random Forest with parameter tuning and Cross Validation:
Used 10-fold Repeated Cross-Validation, repeating 3 times. Used ‘caret’ package, method=’rf’. Parameters used:
●	mtry: 3 to 7, best value: 7, 
●	num.tree: 10 to 150, best value: 120
    d)	Random Forest with Hyperparameter tuning and Cross Validation ~ final model:
Used 10-fold Repeated Cross-Validation, repeating 3 times. Used ‘caret’ package, method=’ranger’. Hyperparameter used:
●	mtry : 3 to 10, best value: 7
●	splitrule: ("gini", "extratrees") - used value “gini”
●	min.node.size : (1, 3, 5) - best value: 1
