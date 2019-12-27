# Helping Veterans get hired in civilian workforce using data science 

## Overview

United States is home to many military families, made up of veterans, active-duty service members, spouses, and dependents. US active service consisted of 1,358,193 i.e. 0.4% of the US population and was the third largest active military army in the world as of 2018. The U.S. Department of Labor estimates that the military trains people in skills applicable in at least 962 civilian occupations. To support Hire Heroes in accomplishing their mission it is necessary to determine the relationship between a client’s demographic profile, amount of time spent working with individual clients (time to complete an assessment, time to complete resume, # of logged activities, etc.)  and the time required for the veterans to get hired. 


## Business Goal

Our business goal is to help HHUSA in its primary function by building a prediction model and identifying the most critical factors that are influencing a veteran to get hired. 

## Data Profile

Out of the 13 datasets provided, we chose to use 3 datasets - Contacts (Demographic information of the client), Activities (activities the client participated in), and Hire Information. Hired/Not Hired was one of our derived variables; where 1 meant client was hired within 180 days and 0 meant client was not hired within 180 days.

```{r}
setwd("/Volumes/GoogleDrive/My Drive/Teradata/Data")
my_data <- read_excel("Modified - Contacts 3.xlsx")
#colnames(my_data)

activities <- read.csv("SalesForce_2018Activities.csv", header=T, strip.white = T, na.strings = c("NA","NaN","","?"))
```
