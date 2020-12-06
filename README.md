![Cancer Graphic](https://user-images.githubusercontent.com/58491399/101261025-d93e8d80-36e8-11eb-9fce-ff649b77174c.jpeg)

## Index
**1.** [Abstract](https://github.com/shernatasha/projects/blob/master/README.md#abstract) \
**2.** [Introduction](https://github.com/shernatasha/projects/blob/master/README.md#introduction) \
**3.** [Data Description](https://github.com/shernatasha/projects/blob/master/README.md#datadescription) \
**4.** [Methods](https://github.com/shernatasha/projects/blob/master/README.md#methods) \
**5.** [Results](https://github.com/shernatasha/projects/blob/master/README.md#results) \
**6.** [Conclusion](https://github.com/shernatasha/projects/blob/master/README.md#conclusion)\
**7.** [Appendix](https://github.com/shernatasha/projects/blob/master/README.md#appendix) 

## Abstract
It is a well known fact that smoking kills and more specifically it increases your chances of developing lung cancer. However, research states that 80-90% of lung cancer cases are linked to smoking. Then what is the other 10-20% caused by? In this study we will take a closer look at lung cancer findings from the United States and identify which demographic factors contribute to higher lung cancer rates by taking a look at both incidence and death. We will do this by fitting two linear models and observing which variables are significant in each. Also, by taking a look at the US counties with high values of incidence and death we can showcase the significant variables in action. This will allow us to not only find which factors contribute to cancer cases but also if certain factors impact incidence more or death.

## Introduction 
In the USA cancer is the second leading cause of death, right behind heart disease. It affects an average of 1.8 million people each year. With no guaranteed way to prevent one from getting cancer, and still no “true” cure, more people are getting concerned. One reason we are still unable to find a perfect cure for cancer is due to the fact that there are so many types. Therefore, it is important to note that the data we are working with only contain information about lung cancer. Majority of lung cancer cases are caused by smoking or other activities that induce risk to the respiratory system. This includes exposure to smoke, radon gas, or radiation therapy. From 1991 to 2017, lung cancer death rates have been steadily declining due to the decreasing levels of smoking rates. Thus, the general purpose of this study is to see what route we could take to stay on the trend of declining lung cancer rates. This includes studying the relationship between the variables we are given in our dataset and the incidence/death rates.

For our first question of interest we are looking into which variables affect incident and death rates the most in general. For example, with a quick glance at our data we have several expectations for our results. The first one being that poverty should affect the death rate more so than the incidence rates. The reason is that people who are living in poverty may be able to detect their symptoms of lung cancer early on, but may not be able to afford the proper treatment. Another expectation we have is that private healthcare should affect the incidence rate more while public coverage affects death cases more. We believe this is due to the fact that if you have private healthcare, it is more likely for you to be diagnosed early on with cancer. Meanwhile with public healthcare, you may be diagnosed later on and thus, not have the resources for treatment.

This leads to our second area of interest, which is looking more specifically at each individual county. Since the dataset we are given has information sorted by each county, we kept it as is instead of combining data from the same states together. This is to prevent any loss of information from aggregating the numbers. We will look into the top and bottom three counties for both the incidence and death rate. From this we are going to analyze what variables play a role in differentiating the top and bottom three counties. 

Therefore, in this study we will be investigating the results for the following two questions:
   1. Which variables contribute more to death and more to incident numbers? Why?
   2. What are the top three counties with the highest and lowest incidence and death rate
         - This allow us to showcase our findings from question 1 by taking examples straight from our data 

## Data	Description 

Our dataset contains data about lung cancer demographics relating to US counties collected between 2010 - 2016.

**Description of Variables** \
**deathRate:** Average deaths per 100,000 people (a) \
**avgAnnCount:** Average number of cases diagnosed annually (a) \
**incidenceRate:** Average number of cases per 100,000 people(a) \
**medianIncome:** Median income per US county (b) \
**popEst2015:** Population of the US county (b) \
**povertyPercent:** Percentage of county population in poverty (b) \
**binnedInc:** Median income per capita (b) \
**MedianAge:** Median age of county residents (b) \
**Geography:** County name (b) \
**PctPrivateCoverageAlone:** Percentage of county residents with private health coverage alone (no public assistance) (b) \
**PctPublicCoverageAlone:** Percentage of county residents with government-provided health coverage alone (b) \
**PctWhite:** Percentage of county residents who identify as White (b) \
**PctBlack:** Percentage of county residents who identify as Black (b) \
**PctAsian:** Percentage of county residents who identify as Asian (b) \
**PctOtherRace:** Percentage of county residents who identify in a category which is not White, Black, or Asian (b) \
> The variables with (a) were collected between 2010 - 2016 and the variables with (b) were collected from the 2013 US Census

A fair amount of cleaning was done to our dataset as we had quite a few observations with missing values. We removed 609 out of the 3047 observations our raw dataset had. We also decided to remove some variables in our dataset as we felt we had a large number of predictors and were worried about variables such as “Percentage of Married Households” and “Household Size” adding noise to our model. Thus by removing these variables which do not relate to not only lung cancer but any form of cancer and focusing on the variables which do, we were able to have a more accessible dataset which contained predictors we believed would have some correlation with incidence and death rates. Another important effect of removing extra variables was that we were able to avoid the risk of overfitting our model which can happen when there are not only too many predictors present but also predictors which would not be good indicators. An example being what does a high correlation between the number of lung cancer deaths and percentage of married households really tell us about our data. We know that an overfit model can cause our regression model to become tailored to the number of predictors we include and will fit the extra “noise” in our dataset and reflect our sample instead of fitting the overall population. Therefore, another benefit to us removing some variables is that our model would better approximate our population instead of tailoring to our sample. 

Since we choose to analyze which predictors were more significant for death versus incidence we choose incidence rate as the dependent for one model and the death rate for our other model. The reason we chose the rate values instead of the raw numbers (total cases and total deaths) was because the rates take population size into account. Since we are comparing the cancer cases and deaths from different U.S. counties we need to take into consideration that each county will differ with population size. If we had just used the total number of cases and total number of deaths, this would make it very difficult for us to draw any reasonable conclusions as the larger counties would have higher numbers for both cases and deaths. Thus making our analysis biased towards the larger counties. Therefore by using the rates we are able to appropriately compare the cancer statistics between the different counties while taking their sizes into account. 

For our additional data point we decided to choose Washington DC for our county because although it is part of the US, it is not an official state. For the values of the variables, we decided to look up information regarding lung cancer data collected in 2019 for Washington DC. We chose these values since we were interested to see how data from a different year would compare to our dataset. We expected this point to be an outlier as with the U.S. population growing over the years since our data was collected, you would expect the number of cases to also rise. Thus we thought it would be interesting to note the difference in our data from the past and this more recent data point to see if indeed it would be considered an outlier.

## Methods 
## Results 
## Conclusion 
## Appendix 

