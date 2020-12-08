![Facebook Cover 851x315 px (2)](https://user-images.githubusercontent.com/58491399/101442228-bde1a700-38cf-11eb-90dd-724620f00c7a.jpeg)

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
In the USA cancer is the second leading cause of death, right behind heart disease. It affects an average of 1.8 million people each year. With no guaranteed way to prevent one from getting cancer, and still no “true” cure, more people are getting concerned. One reason we are still unable to find a perfect cure for cancer is due to the fact that there are so many types. Therefore, it is important to note that the data we are working with only contains information about lung cancer. Majority of lung cancer cases are caused by smoking or other activities that induce risk to the respiratory system. This includes exposure to smoke, radon gas, or radiation therapy. From 1991 to 2017, lung cancer death rates have been steadily declining due to the decreasing levels of smoking rates. Thus, the general purpose of this study is to see what route we could take to stay on the trend of declining lung cancer rates. This includes studying the relationship between the variables we are given in our dataset and the incidence/death rates.

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
> Click on the plots to expand the picture 

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

Then, once we had assessed our summary, one of the last steps we would like to conduct is model validation. Before we interpreted our findings and began to answer our questions about the data we assessed the validity of the model. This is to not only ensure that we as the creators had created a model which would accurately operate in our analysis but also be useful for others to conduct their own analysis’. Since we are unable to collect new data for our dataset we decided to perform model validation by cross validation. Here we split our data into two sets, one for estimating and the other for predicting. We use the estimating set to build our regression model and our prediction set to assess the predictability of the estimation set. To test how well our estimation set predicts values we compute the R<sup>2</sup>, the root mean square prediction error (RMSPE) and the mean absolute prediction error (MAPE). We know the R<sup>2</sup> tells us how well the model fits, the RMSPE tells us how spread out our residuals are and the MAPE tells us how accurate our predictions are. 

Finally, the last step in our investigation regarding which factors are more significant to death than incidence would be to interpret our findings. Now that we had fitted our model, found any influential points, analyzed signs of multicollinearity and done all else to ensure we have the best performing models for our project we can take a look at our findings and be able to answer our questions regarding this dataset. 

## Results 

We will start by assessing our residual plots of our full incidence model to assure that our constant variance assumption and normality assumptions are being met. 

Normal Q-Q            |  Residuals vs. Fitted
:-------------------------:|:-------------------------:
![130775558_2820270421588786_8754615875456693759_n](https://user-images.githubusercontent.com/58491399/101423002-e2785780-38ac-11eb-8c9c-d6e547bd5814.png) | ![129712940_712835399359695_2629368532734819007_n](https://user-images.githubusercontent.com/58491399/101423216-6b8f8e80-38ad-11eb-8b5c-fd14799d3b02.png)

> Click on the plots to expand the picture 

**Figure 2: Residual Analysis of Full Incidence Model**

We see from the Normal Q-Q plot that  the residuals do adequately meet the normality assumption. The deviation on the left side of the plot suggests a slight negative skew to the distribution of the residuals but they are not large enough to be of concern. We also see a few points on the right side of the graph which could be potential influential points or of high leverage. We will look closer at these after our variable selection to see if they still may be of concern. Next we see in our Residuals vs. Fitted plot that our model seems to be adequate to the linear relationship assumption. We have a very even distribution of points around zero which is a good sign of evenly distributed residuals. Though we see our data is slightly to the right of the graph, since it is not an obvious deviation we will not read too much into it. If we had a few more data points whose fitted values were less than 450, we would see the variation even out. Similarly we analyzed the Scale - Location plot and again saw a similar outcome to the Residuals vs. Fitted plot where we had points evenly distributed about the horizontal line with a slight skew to the right of the graph. Thus this plot confirms that our constant variance assumption is met. Lastly, the Residuals vs. Leverage plot showed that we did not have any high leverage points to be concerned about. 

Similarly with our full death model we see that:

Normal Q-Q            |  Residuals vs. Fitted
:-------------------------:|:-------------------------:
![Full Death - Normality](https://user-images.githubusercontent.com/58491399/101427023-f58e2600-38b2-11eb-9abb-adede829b521.png) | ![Full Death - Residuals vs  Fitted](https://user-images.githubusercontent.com/58491399/101427095-19ea0280-38b3-11eb-9790-ef7d51f1f5be.png)


> Click on the plots to expand the picture 

**Figure 3: Residual Analysis of Full Death Model**

Our Normal Q-Q plot has some slight deviations than the incidence model but this could be due to our death data containing more extreme values then our incidence data. Overall the plot looks to be lightly tailed as the majority of the data fits normally for the most part except for a few observations which may be potential influences. Then looking at the Residuals vs.  Fitted plot we see a very even spread of data with a few extra points on the right side, but nothing to be worried about. We have our data evenly spread about the zero line which shows that the linear relationship assumption has been met. We see the same three observations singled out on both the Normal Q-Q and Residuals vs. Fitted plots meaning that it will be important to take a closer look at these. Next, we analyzed the Scale-Location plot and again saw our points evenly distributed among the horizontal line which confirms that our constant variance assumption has been met. Lastly we saw on our Residuals vs. Leverage Plot that there are no high leverage points to be concerned about.

Now that we have established that our model meets all the necessary multiple regression assumptions we will perform variable selection to try and find the best performing subset of regressors. As mentioned in the methods section of our report, we decided to use two different variable selection methods: stepwise regression and backward elimination. This was so we could compare the outcomes to see if there would be the possibility of two different fitting models. After compiling both of our codes our result was that both methods of variable selection gave us the exact model. These are our newly fitted regression equations:

Death Model            |  Incidence Model
:-------------------------:|:-------------------------:
![DeathModel](https://user-images.githubusercontent.com/58491399/101448907-b1b01680-38dc-11eb-925f-6a4785df715d.png) | ![IncidenceModel](https://user-images.githubusercontent.com/58491399/101448994-d4422f80-38dc-11eb-9c1d-fcb189b045ef.png)
> Click on the plots to expand the picture 

**Figure 4: Models Produced From Variable Selection**

We can see with these newly fitted models that before performing any hypothesis tests and looking for significant predictors there are already some differences in predictors for both of our models. Though we see many similarities between the two our incidence model seems to focus more on race than the death model. We will take a closer look at the predictors once we reassess the residual analysis for both models. Once we replotted our residual plots for both the new death and incidence model we saw that there were no significant changes in the plots and found that removing some predictors still kept our normality and linear regression assumptions the same. Therefore we moved on to checking for any multicollinearity in these new models.

We decided to use a correlation matrix to first visualize any presence of multicollinearity before computing our variance inflation factors. 

Death Model            |  Incidence Model
:-------------------------:|:-------------------------:
![Screenshot (1584)](https://user-images.githubusercontent.com/58491399/101449205-3438d600-38dd-11eb-8ec1-1bf13d3c5abd.png) | ![Screenshot (1585)](https://user-images.githubusercontent.com/58491399/101449306-634f4780-38dd-11eb-9a16-4d0980c1f3e8.png)
> Click on the plots to expand the picture 

**Figure 5: Correlation Matrices for Both Models**

From these visualizations we can see that our death model has some high correlation coefficients which should be investigated whereas we do not see anything too alarming in our incidence model. We took a look at the variance inflation factors of our death model to further investigate these high coefficient values. 
***

We see here that as we expected there are some very high VIFs that we would have expected to see based on our correlation matrices. The variables avgDeathsPerYear and popEst2015 have VIFs quite larger than 10 which makes them serious indicators of multicollinearity. Therefore to increase the validity of our prediction equation and also decrease the sensitivity of our regression coefficients. We see that avgAnnCount does have a VIF on the higher end of the spectrum but because we know death rate and avgAnnCount are expected to have a high correlation we choose to leave it in the model.

Next we choose to evaluate whether our models have any influential or high leverage points which are of concern. We saw in our residual plots that there were some points which had been identified as potential influences, here we will examine them closer. 


Death Model Summary       |  Incidence Model Summary
:-------------------------:|:-------------------------:
![deathmodel](https://user-images.githubusercontent.com/58402986/101448337-b1fbe200-38db-11eb-8ebd-db7790ae84a0.png) | ![incidencemodel](https://user-images.githubusercontent.com/58402986/101450106-d4dbc580-38de-11eb-9d5e-f471f8d20b21.png)
> Click on the image to expand the picture 

**Figure 6: Death and Incidence Model Summary**

This is the summary of our death and incidence model after performing stepwise regression. For our death model, we have five variables that are not included here which are medIncome, MedianAge, PctEmployed16_Over, PctBlack, and PctAsian. Their respective p-values in the full model summary are: 0.51256, 0.94536, 0.74515, 0.14333, 0.68229. For our incidence model, we have two variables that are not included here which are PctBachDeg25_Over and PctEmployed16_Over. Their respective p-values in the full model summary are: 0.45089 and 0.99955.

![highestincidencerate](https://user-images.githubusercontent.com/58402986/101435758-c03d0480-38c1-11eb-86c6-7713a9750c9f.jpg)
**Figure 7: Top 3 Counties with the Highest Incidence Rate** 


![lowestincidencerate](https://user-images.githubusercontent.com/58402986/101436959-0a26ea00-38c4-11eb-9d82-51663c512a17.jpg)
**Figure 8: Bottom 3 Counties with the Lowest Incidence Rate**


![highestdeathrate](https://user-images.githubusercontent.com/58402986/101437038-37739800-38c4-11eb-8c25-3b4bf56a70f7.jpg)
**Figure 9: Top 3 Counties with the Highest Death Rate**


![lowestdeathrate](https://user-images.githubusercontent.com/58402986/101437096-52460c80-38c4-11eb-8bc8-129116adf3e9.jpg)
**Figure 10: Bottom 3 Counties with the Lowest Death Rate**

## Conclusion 
To address our questions of interest, we will go through several of the variables and discuss the impact it has on our models. Starting off with avgAnnCount, we see it has more effect on the incidence model which makes sense since this variable is the number of reported cases annually. However, the variable medIncome affects the death model a lot more than the other. The reason for this is presumably because treatment for cancer costs more than a diagnosis. Therefore, one’s income level has a more important role in life or death. As we have mentioned previously, one of our expectations was for povertyPercent to affect the death model more, and we see that this is indeed the case. After performing the stepwise regression for both models, we see that povertyPercent is not an important variable for the incidence model. Therefore, we decided to only keep it in our death model.

We see that PctHS25_Over and PctUnemployed16_Over are the only two educational variables that remain in the model after performing stepwise regression. We believe this is due to the fact that the other two variables are more positive or on the side of a higher level of education. Therefore the more educated one is, the easier it is for one to take preventative measures. Under this assumption, it becomes more clear that having a lower level of education results in a higher impact on our incidence model. Another reason is that if we assume an “incident” of lung cancer is reported right after someone is diagnosed with lung cancer, then the age range of our variable will have very low numbers of incidents. The same reasoning applies to our death model. We noticed that PctEmployed16_Over has a high p-value of 0.9061 here. Most people are diagnosed with lung cancer at around age 70, and so death happens later on. If we let the age range for PctEmployed16_Over be from 16-40, it is still very young compared to 70 years old. Therefore, this variable doesn’t affect our death model. While the same logic could apply for PctUnemployment16_Over, we believe that this does have an impact on our death model because this variable already represents a situation that is not as diserable.

Health care in the US is one of the reasons most people go bankrupt. This is because they don’t have universal health care and so citizens can either choose between private health care insurance of government funded insurance. While private health care is more expensive, it is also more flexible and so most Americans end up choosing this option. It is no surprise that private and public health care appears to affect both our incidence and death model. However, we do see that private health care affects our incidence model more since the p-value for the incidence model is lower than the death model. We believe that this is due to the fact that private health care coverage is better than public health coverage.

Why are Asians not included in the incidence model? They are included when I do forward selection, however we notice that the adjusted R-Square for the forward selection and stepwise regression is the same whether we include PctAsians or not. Therefore we conclude that PctAsians does not have much of an impact on our incidence model. One reason for this could be the fact that the percentage of asians in the US is relatively small and looking at our given dataset, PctAsians has the highest number of zeros with 194 total. This could mean that PctAsian is more inaccurate compared to the other percentages or perhaps the numbers were so low it got rounded to 0. The reason PctWhite is not included in the death model is because if we do, it would lower the adjusted R square.

To further support the effect of the variables we have mentioned, we will answer the second question by looking at our sorted data and listing out the counties:
Starting with the county with the highest incidence rate, the top three are:
- Williamsburg City, Virginia
- Charlottesville city, Virginia
- Powell County, Kentucky

The counties with the lowest incidence rate are:
- Hudspeth County, Texas
- Presidio County, Texas
- Aleutians West Census Area, Alaska

The counties with the highest death rate are:
- Woodson County, Kansas
- Madison County, Mississippi
- Powell County, Kentucky

The counties with the lowest death rate are:
- Eagle County, Colorado
- Presidio County, Texas
- Pitkin County, Colorado

An interesting point is that Aleutians West Census Area has a very low poverty percentage, which is also correlated with the high median income which we do see. Our data analysis implied that it is likely for the county to have a low incidence rate if the citizens have the resources to keep themselves healthy. However, the same could go for the other end of the spectrum: having the resources to be unhealthy, which could explain why counties with high incidence rates also have a high median income.

What differentiates the highest three counties and the lowest three counties? Poverty percentage appears to be lower in the counties with the lowest incidence rate, however the difference does not appear to be significant. The county with the highest incidence rate: Williamsburg City has a lower poverty percentage than Hudspeth County and Presidio County. This aligns with our stepwise regression model as we did not include poverty percentage since we believed it does not make a significant difference. Meanwhile in our death model, we see that the poverty percentage has a bigger impact. The numbers do appear to be much smaller for the counties with the lowest death rate, while they are higher for the counties with the highest death rate.

Another observation we drew from this is that there is a lot of variety in our data. For example, we expect the counties with the highest death rate to also have a generally large population. However we see that Woodson County, with the highest death rate also has a low population of 3115. While Madison County and Powell County have a much larger population. The death rate for these three counties are also very similar, but there is a huge difference in median income and population between Madison Country and Powell County. One more observation we have made from these four groups of counties is that the PctEmployed16_Over is fairly high for all of them. There doesn’t appear to be a visible pattern here at least, which further supports why this variable was not included in the death model. This applies to the rest of our data as well and could also further explain the reason why our R-Square is a low number.

We have concluded that people with higher education, higher income, and are with private health insurance companies are most likely in the group with a lower incidence or death rate. Therefore on implementation for the counties with high death or incidence rate would be to encourage education by making it more accessible or cheaper. This way citizens can have a higher chance of being employed and going with a private health coverage. 


## Appendix 

