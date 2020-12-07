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
   2. What are the top three counties with the highest and lowest incidence and death rate? Do they have any specific attributes?
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
**PctHS25_Over:** Percentage of county residents ages 25 and over with their highest education attained being a high school diploma (b) \
**PctBachDeg25_Over:** Percentage of county residents ages 25 and over with their highest education attained being a bachelor's degree (b) \
**PctEmployed16_Over:** Percentage of county residents ages 16 and over who are employed (b) \
**PctUnemployed16_Over:** Percentage of county residents ages 16 and over who are unemployed (b) \
**PctPrivateCoverageAlone:** Percentage of county residents with private health coverage alone (no public assistance) (b) \
**PctPublicCoverageAlone:** Percentage of county residents with government-provided health coverage alone (b) \
**PctWhite:** Percentage of county residents who identify as White (b) \
**PctBlack:** Percentage of county residents who identify as Black (b) \
**PctAsian:** Percentage of county residents who identify as Asian (b) \
**PctOtherRace:** Percentage of county residents who identify in a category which is not White, Black, or Asian (b) \
> The variables with (a) were collected between 2010 - 2016 and the variables with (b) were collected from the 2013 US Census

A fair amount of cleaning was done to our dataset as we had quite a few observations with missing values. We removed 714 out of the 3047 observations our raw dataset had. We also decided to remove some variables in our dataset as we felt we had a large number of predictors and were worried about variables such as “Percentage of Married Households” and “Household Size” adding noise to our model. Thus by removing these variables which do not relate to not only lung cancer but any form of cancer and focusing on the variables which do, we were able to have a more accessible dataset which contained predictors we believed would have some correlation with incidence and death rates. Another important effect of removing extra variables was that we were able to avoid the risk of overfitting our model which can happen when there are not only too many predictors present but also predictors which would not be good indicators. An example being what does a high correlation between the number of lung cancer deaths and percentage of married households really tell us about our data. We know that an overfit model can cause our regression model to become tailored to the number of predictors we include and will fit the extra “noise” in our dataset and reflect our sample instead of fitting the overall population. Therefore, another benefit to us removing some variables is that our model would better approximate our population instead of tailoring to our sample. 

Since we choose to analyze which predictors were more significant for death versus incidence we choose incidence rate as the dependent for one model and the death rate for our other model. The reason we chose the rate values instead of the raw numbers (total cases and total deaths) was because the rates take population size into account. Since we are comparing the cancer cases and deaths from different U.S. counties we need to take into consideration that each county will differ with population size. If we had just used the total number of cases and total number of deaths, this would make it very difficult for us to draw any reasonable conclusions as the larger counties would have higher numbers for both cases and deaths. Thus making our analysis biased towards the larger counties. Therefore by using the rates we are able to appropriately compare the cancer statistics between the different counties while taking their sizes into account. 

Before we begin fitting models and drawing conclusions from our summary statistics, it is important to determine whethere our model has any relationships which are worth investigating. We decided to create pairs plots for both our sets of data (death and incidence) to take a look at the variable relations.

Incidence Data            |  Death Data
:-------------------------:|:-------------------------:
![Incidence Model](https://user-images.githubusercontent.com/58491399/101408468-4d1b9a00-3891-11eb-9804-4a4458aab4bc.png)  | ![Death Model](https://user-images.githubusercontent.com/58491399/101408736-b1d6f480-3891-11eb-811f-54e29259696a.png)
> Click on the plots to expand the picture \
**Figure 1: Pairs Plots for Our Two Models**

We can see in both of our plots that we definitely see relationships between many of the variables, especially between our respective dependent and independent variables. Therefore we would like to move forward and begin fitting models to further investigate these relationships.

For our additional data point we decided to choose Washington DC for our county because although it is part of the US, it is not an official state. For the values of the variables, we found information regarding lung cancer data collected in 2020 for Washington DC from the [American Cancer Society](https://cancerstatisticscenter.cancer.org/#!/state/District%20of%20Columbia) and combined this with US 2020 census information from [DC Health Matters](https://www.dchealthmatters.org/index.php?module=demographicdata&controller=index&action=index). We chose these values since we were interested to see how data from a different year would compare to our dataset. We expected this point to be an outlier as with the U.S. population growing over the years since our data was collected, you would expect the number of cases to also rise. Thus we thought it would be interesting to note the difference in our data from the past and this more recent data point to see if indeed it would be considered an outlier.

## Methods 
> In this section we will be describing the methods used to perform our analysis.

After assessing the relations between our variables we begin our model fitting by deciding to fit two linear models, one where we use the incidence rate as our dependent and the other using death rate as the independent. Our reasoning behind this approach came from the questions we were looking to answer; which variables contribute more to death and which more to incidence? We started off the models with the same independent variables except for one: 

- avgAnnCount 
- avgDeathsPerYear 
- medIncome 
- popEst2015 
- povertyPercent 
- MedianAge 
- PctPrivateCoverageAlone 
- PctPublicCoverageAlone 
- PctWhite 
- PctBlack 
- PctAsian 
- PctOtherRace 
- PctHS25_Over 
- PctBachDeg25_Over 
- PctUnemployed16_Over 
> The incidence model did not include avgDeathsPerYear as we felt it did not make sense to use this variable as a predictor for the number of cases 

We fit both models with all the independent variables and perform a thorough analysis including taking a look at the residuals. We start off with the full model to ensure that we are starting off with a functioning model before we start to do any computations and perform any analysis. We also want to ensure that the underlying assumptions are met such as constant variance and normally distributed errors which is why a residual analysis is done. 

Then to ensure we had the best performing subset of parameters from our dataset we decided to use not only stepwise regression but also backward elimination. We know that although it is best to keep as many predictors as possible to ensure that we are able to find all and any factors which relate to our dependent variable it is also important to not have a large amount of predictors as the variance of our dependent variables increase with the number of predictors. Therefore, with the large number of predictors we had in our data, we believed that variable selection would help us to eliminate any noise created by extra predictors as well as identify any multicollinearity. The reason for us choosing to perform two variable selection methods was that so we can compare the models we got out of both and see if there were any differences in model fit. This would ensure that we would be going forward with a model we would feel confident using to answer our questions about this data. 

After we found a subset of predictors we felt confident in analyzing, our next step was to take a look at the residuals again to make sure there are no significant changes as well as assess the normality assumptions again. Then we wanted to check whether our variable selection had taken care of any multicollinearity present in our model so we checked the variance inflation factors (VIFs). The VIFs  are the diagonal elements of the inverse of the **X’X** matrix and they measure the collinearity between the respective beta’s of the regressors. VIF values larger than 10 identify serious multicollinearity problems. It is important to identify any multicollinearity present in a linear model as it can cause poor prediction equations as well as sensitive regression coefficients. Therefore, by identifying these predictors beforehand we are ensuring that we are able to use our model to evaluate the relationship between our predictors and dependents. 

Next we look for high leverage and influential points. Points with high leverage are important to identify as although they do not affect our regression coefficients they will affect our model summary statistics which is important for us as we are looking to see which predictors are more significant for death versus incidence. Influential points are important to identify as they do have an impact on our regression coefficients by pulling our regression line away from the majority and towards itself. If we do determine some points in our data are highly influential, we will remove them and refit the model to assess whether the model is better off without them. 

We will identify leverage points by taking a look at the diagonal elements of our hat matrix. According to the  “Introduction to Linear Regression” textbook by Montgomery, Peck and Vining, “...large hat diagonals reveal observations that are potentially influential because they are remote in x space from the rest of the sample.” Therefore by computing our hat matrix and taking a look at the diagonal values we can identify the high leverage points by comparing them to the value computed by **2p/n** where **p** is the number of regressors and **n** is the number of observations. We compare our diagonals to this **2p/n** value as we consider any diagonal larger than this distant enough from the majority of our data to be considered a leverage point. Once we identify these leverage points we will then check to see if any are influential. We consider observations that have not only large diagonal values in the hat matrix but also a large Cook’s distance to be influential. Cook’s distance measures the effect of deleting a specific observation and alues greater than one are considered to be influential. 

Once we had identified our influential observations we needed to take a closer look to determine what should be done with them. Is there a reason these observations are influential? Would removing the observations and refitting our model give us a better fitting regression line? Is the data point valid or was there a mistake made in data collection? These questions need to be asked before discarding what could be valuable observations. 

Now that we had fitted our model and identified any influential points, dealing with them however we decided to, we took a look at the summary of our models and began performing our analysis. Here, we did a residual analysis on our now completed models, took a look at the summary statistics and interpreted values such as our adjusted R<sup>2</sup> to see how well we fit the model, the residual standard error to assess the quality of our fit, and of course conducted a hypothesis test to see if there is a significant linear relationship between at least one of the predictors and the response. 

Then, once we had assessed our summary one of the last steps we would like to conduct is model validation. Before we interpreted our findings and began to answer our questions about the data we assessed the validity of the model. This is to not only ensure that we as the creators had created a model which would accurately operate in our analysis but also be useful for others to conduct their own analysis’. We chose to perform model validation by studying the regression coefficients and determining whether their signs and magnitudes are reasonable as well as investigating the prediction performance of the model. Since we are unable to collect new data for our dataset we decided to perform model validation by cross validation. In cross validation we split our data into two sets, an estimation set and a prediction data. We use the estimation set to build our regression model and our prediction set to study the predictability of the estimation set. …..

...add explanation of how validation was performed

Finally, the last step in our investigation regarding which factors are more significant to death than incidence would be to interpret our findings. Now that we had fitted our model, found any influential points, analyzed signs of multicollinearity and done all else to ensure we have the best performing models for our project we can take a look at our findings and be able to answer our questions regarding this dataset. 


## Results 
## Conclusion 
To address the first question we had in this study, we will start off with the first variable, avgAnnCount. We see it has more effect on the incidence model which makes sense since this variable is the number of reported cases annually. However, the variable medIncome affects the death model a lot more than the other. The reason for this is presumably because treatment for cancer costs more than a diagnosis. Therefore, one’s income level has a more important role in life or death.

As we have mentioned previously, one of our expectations was for povertyPercent to affect the death model more, and we see that this is indeed the case. After performing the stepwise regression for both the incidence and death model, we see that povertyPercent is not an important variable for the incidence model. Therefore, we only kept it in our death model.

Health care in the US is one of the reasons most people go bankrupt. This is because they don’t have universal health care and so citizens can either choose between private health care insurance of government funded insurance. While private health care is more expensive, it is also more flexible and so most Americans end up choosing this option. It is no surprise that private and public health care appears to affect both our incidence and death model. However, we do see that private health care affects our incidence model more since the p-value for the incidence model is lower than the death model. We believe that this is due to the fact that private health care coverage is better than public health coverage.

Why are PctAsians not included in the incidence model? They are included when we do forward selection, however we noticed that the adjusted R-Square for the forward selection and stepwise regression are the same whether we include PctAsians or not. Therefore we conclude that PctAsians does not have much of an impact on our incidence model. One reason for this could be the fact that the percentage of asians in the US is relatively small and looking at our given dataset, PctAsians has the highest number of zeros with 194 in total. This could mean that PctAsian is more inaccurate compared to the other percentages or perhaps the numbers were so low it got rounded to 0. Why are Whites not included in the death model? If we do include PctWhite, it would lower the adjusted R square.

## Appendix 

