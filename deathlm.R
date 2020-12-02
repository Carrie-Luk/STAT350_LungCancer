library(tidyverse)
library(stringr)
library(dplyr)
library(car)
library(MASS)
library(faraway)
library(Metrics)

#read data
cancer<-read.csv("cancer_reg.csv", stringsAsFactors = FALSE)
names(cancer)

#remove variable that we don't need
names(cancer)
cancer<-cancer[,-c(8,9,11:12,14:24,26:27,33:34)]
view(cancer)
ncol(cancer)


#delete missing values
cancer<-cancer[complete.cases(cancer),]
rownames(cancer)=seq(1:nrow(cancer))
view(cancer)

cancer<-as.data.frame(cancer)
str(cancer)

# group into states
attach(cancer)
#NEW DATA POINT -------------
datapoint <- data.frame(avgAnnCount = 3600, avgDeathsPerYear = 1020, TARGET_deathRate = 164.1, incidenceRate = 463.3, medIncome = 90695,
                        popEst2015 = 717189, povertyPercent = 18.6, MedianAge = 33.9, 
                        Geography = "Washington, District of Columbia", PctPrivateCoverageAlone = 68,
                        PctPublicCoverageAlone = 34.1, PctWhite = 41.96, PctBlack = 44.53, PctAsian = 4.35,
                        PctOtherRace = 9.16)
#bind data(cancer) with new data point
cancer<-rbind(cancer,datapoint)
#rename TARGET_deathRate with DeathRate
cancer<-rename(cancer,"DeathRate"="TARGET_deathRate")
tail(cancer)
names(cancer)

attach(cancer)

#SCATTER PLOT OF ORIGINAL DATA ---------------
pairs(DeathRate~medIncome+popEst2015+povertyPercent+MedianAge,data=cancer)
#some graph have a negative slope
pairs(DeathRate~PctPrivateCoverageAlone+PctPublicCoverageAlone,data=cancer)
pairs(DeathRate~PctWhite+PctBlack+PctAsian+PctOtherRace,data=cancer) 
pairs(DeathRate~avgAnnCount+avgDeathsPerYear,data=cancer)


#LINEAR MODEL
#FIT ALL LINEAR MODEL------------
names(cancer)
#remove geography and incidence rate into new data: cancer2---------
cancer2<-cancer[,-c(4,9)]
head(cancer2)
tail(cancer2)


#FIT FULL MODEL -----------
deathfitall <- lm(DeathRate ~ ., data = cancer2)

#fit the best model using stepwise regression

step.model<-stepAIC(deathfitall,direction="both",trace=FALSE)
step.model

#SUMMARY OF STEP MODEL -----------
stepmod_sum<-summary(step.model)
stepmod_sum 
#p value <2.2e-16; multiple R^2 = 0.2771
#only 27.71% fitted the regression line


#BEST MODEL ------------
names(cancer2)
attach(cancer2)

#BEST MODEL --> BEFORE VIF----------
bestmodel<-lm(DeathRate ~ avgAnnCount + avgDeathsPerYear + medIncome + 
                popEst2015 + povertyPercent + PctPrivateCoverageAlone + PctPublicCoverageAlone + 
                PctBlack + PctAsian + PctOtherRace,data = cancer2)
plot(bestmodel)
#plot 1: seeing variance of the residual from the plot --> more data on the right
#plot 2<- linear, but not in the best fit
#plot 3 <-slightly slanting upward; less variation on the left, but there is also less data so assuming constant var is met
#plot 4: influential points will appear outside of the cook's distance dotted line; point 798
summary(bestmodel)


#VIF------

vif(bestmodel) 
#since the VIF of avgDeathsPerYear (29.615507) and popEst2015(25.428099) are greater than 10, we exclude from the best model

#exclude popEst2015 and avgDeathsPerYear-----------------
#newdata called fitmodel -------------------

fitmodel<-lm(DeathRate ~ avgAnnCount  + medIncome + 
                          povertyPercent + PctPrivateCoverageAlone + PctPublicCoverageAlone + 
                          PctBlack + PctAsian + PctOtherRace,data = cancer2)
plot(fitmodel)
#plot 1 : more data on the right side
#Plot 2: suggest a slight positive skew to the distribution of the residual, but not large to be concern
#plot 3: the point slightly slanting upward; less variation on the left
#plot 4: no points exceed the cook's distance

#SUMMARY OF FIT MODEL-----------
summary(fitmodel)
#adjusted R^2: 0.2673; p value is extremely small

#just to check all of the VIF is less than 10
vif(fitmodel) 


#LEVERAGE------------------
#INFLUENCIAL POINTS
X <- cbind(rep(1,nrow(cancer2)), cancer2$avgAnnCount,
           cancer2$medIncome , cancer2$povertyPercent , cancer2$PctPrivateCoverageAlone , cancer2$PctPublicCoverageAlone,
           cancer2$PctBlack ,
           cancer2$PctAsian ,cancer2$PctOtherRace)
H <- X %*% solve(t(X) %*% X) %*% t(X)

#points that exceed 2p/n should be looked more closely
#delete avgDeathperYear and popest2015 from the data
names(cancer2)
cancer2<-cancer2[,-c(2,5)]
(exc<-2*ncol(cancer2)/nrow(cancer2))
#0.00902009

#LEVERAGE --------- tutorial
#to get influence points ----------
cancer_inf<-influence(fitmodel)
which(cancer_inf$hat>exc)
halfnorm(cancer_inf$hat,labs=names(cancer_inf$hat),ylab='Leverage')
#influential point:

#finding leverage point
hii <- diag(H)
studentRes <- studres(fitmodel)
which(hii>2)
#no leverage point

#finding influence point- lecture -----------
which(hii > exc & (studentRes > 3 | studentRes < -3))
#influential point: 838,1560,2179


#cook's distance
cancer_cook<-cooks.distance(fitmodel)
sort(cancer_cook,decreasing=TRUE)
#highest : point 2169: 0.151217962
#no points greater than 1 

#DATA SPLITTING-------
#original data
#new data<- datapoint
datapoint <- data.frame(avgAnnCount = 3600, avgDeathsPerYear = 1020, TARGET_deathRate = 164.1, incidenceRate = 463.3, medIncome = 90695,
                        popEst2015 = 717189, povertyPercent = 18.6, MedianAge = 33.9, 
                        Geography = "Washington, District of Columbia", PctPrivateCoverageAlone = 68,
                        PctPublicCoverageAlone = 34.1, PctWhite = 41.96, PctBlack = 44.53, PctAsian = 4.35,
                        PctOtherRace = 9.16)



#CROSS VALIDATION------------------
set.seed(71168)
nsamp=ceiling(0.8*length(cancer2$DeathRate))
training_samps=sample(c(1:length(cancer2$DeathRate)),nsamp)
training_samps=sort(training_samps)
train_data<-cancer2[training_samps,]
test_data<-cancer2[-training_samps,]

attach(train_data)
train.lm<-lm(DeathRate~avgAnnCount+medIncome+povertyPercent+PctPrivateCoverageAlone+
               PctPublicCoverageAlone+PctBlack+PctAsian+PctOtherRace,data=train_data)
summary(train.lm)

#PREDICT THE RESPONSES ON THE TEST SET--------------
preds<-predict(train.lm,test_data)

R.sq=cor(preds,test_data$DeathRate)^2
RMSPE=rmse(preds,test_data$DeathRate)
MAPE=mae(preds,test_data$DeathRate)
print(c(R.sq,RMSPE,MAPE))
#R.sq is far from 1, means not doing so good

#to know how large is the RMSPE, we normalize it
RMSPE/sd(test_data$DeathRate)

#USE LOOP
set.seed(71168)

for(i in 1:5){
  
  nsamp=ceiling(0.8*length(cancer2$DeathRate))
  training_samps=sample(c(1:length(cancer2$DeathRate)),nsamp)
  training_samps=sort(training_samps)
  train_data<-cancer2[training_samps,]
  test_data<-cancer2[-training_samps,]
  
  
  train.lm<-lm(DeathRate~avgAnnCount+medIncome+povertyPercent+PctPrivateCoverageAlone+
                 PctPublicCoverageAlone+PctBlack+PctAsian+PctOtherRace,data=train_data)
  summary(train.lm)
  
  preds <- predict(train.lm,test_data)
  
  R.sq=cor(preds,test_data$DeathRate)^2
  RMSPE=rmse(preds,test_data$DeathRate)
  MAPE=mae(preds,test_data$DeathRate)

  
  
  print(c(i,R.sq,RMSPE,MAPE))
  
}


