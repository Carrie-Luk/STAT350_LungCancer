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

cancer<-cancer[,-c(8,9,11:12,14:19,24,26:27,33:34)]
view(cancer)
ncol(cancer)


#delete missing values
names(cancer)
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
                        Geography = "Washington, District of Columbia", PctHS25_Over=17.32,PctBachDeg25_Over=23.89,PctEmployed16_Over=71.5,PctPrivateCoverageAlone = 68,
                        PctUnemployed16_Over=6.76,PctPublicCoverageAlone = 34.1, PctWhite = 41.96, PctBlack = 44.53, PctAsian = 4.35,
                        PctOtherRace = 9.16)

#bind data(cancer) with new data point
cancer<-rbind(cancer,datapoint)
#rename TARGET_deathRate with DeathRate
cancer<-rename(cancer,"DeathRate"="TARGET_deathRate")
tail(cancer)
names(cancer)
view(cancer)

attach(cancer)

#SCATTER PLOT OF ORIGINAL DATA ---------------
pairs(DeathRate~medIncome+popEst2015+povertyPercent+MedianAge,main="Death Rate vs medIncome, popEst2015,PovertyPercent, and Median Age",data=cancer)
#some graph have a negative slope
pairs(DeathRate~PctPrivateCoverageAlone+PctPublicCoverageAlone,main="Death Rate vs PctPrivateCoverageAlone and PctPublicCoverageAlone",data=cancer)
pairs(DeathRate~PctWhite+PctBlack+PctAsian+PctOtherRace,main="Death Rate vs ,PctWhite,PctBlack, PctAsian,and PctOtherRace",data=cancer) 
pairs(DeathRate~avgAnnCount+avgDeathsPerYear,main="Death Rate vs avgAnnCount and avgDeathsPerYear",data=cancer)
pairs(DeathRate~PctHS25_Over+PctBachDeg25_Over+PctEmployed16_Over+PctUnemployed16_Over,main="Death Rate vs PctHS25_Over,PctBachDeg25_Over,PctEmployed16_Over, PctUnemployed16_Over",data=cancer)
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

# BACKWARD!
bckwardmodel<-stepAIC(deathfitall,direction="backward",trace=FALSE)
bckwardmodel
#same as stepwise regression

#SUMMARY OF STEP MODEL -----------
stepmod_sum<-summary(step.model)
stepmod_sum 
#p value <2.2e-16; multiple R^2 = 0.3536
#only 35.36% fitted the regression line


#BEST MODEL ------------
names(cancer2)
attach(cancer2)

#BEST MODEL --> BEFORE VIF----------
bestmodel<-lm(DeathRate ~ avgAnnCount + avgDeathsPerYear + popEst2015 + 
                 povertyPercent + PctHS25_Over + PctBachDeg25_Over + PctUnemployed16_Over + 
                 PctPrivateCoverageAlone + PctPublicCoverageAlone + PctWhite + 
                 PctOtherRace, data = cancer2)
plot(bestmodel)
#plot 1: more data on the right side
#plot 2<-  but not in the best fit of linear
#plot 3 <-slightly slanting upward; less variation on the left, but there is also less data so assuming constant var is met
#plot 4: influential points will appear outside of the cook's distance dotted lines; no points appear outside of the cook's d
summary(bestmodel)


#VIF------

vif(bestmodel) 
#since the VIF of avgDeathsPerYear (31.813859 ) and popEst2015(26.690564 ) are greater than 10, we exclude from the best model

#exclude popEst2015 and avgDeathsPerYear-----------------
#newdata called fitmodel -------------------

fitmodel<-lm(DeathRate ~ avgAnnCount + povertyPercent + PctHS25_Over + PctBachDeg25_Over + PctUnemployed16_Over + 
               PctPrivateCoverageAlone + PctPublicCoverageAlone + PctWhite + 
               PctOtherRace, data = cancer2)
plot(fitmodel,col="dark blue")
#plot 1 : almost equally distributed, more data on the right
#plot 3: the point slightly slanting upward; less variation on the left
#plot 4: no points exceed the cook's distance

#SUMMARY OF FIT MODEL-----------
summary(fitmodel)
#adjusted R^2: 0.3419; p value is extremely small

#just to check all of the VIF is less than 10
vif(fitmodel) 

#delete avgDeathperYear and popest2015 from the data
names(cancer2)
cancer2<-cancer2[,-c(2,5)]

#LEVERAGE------------------
#INFLUENCIAL POINTS
X <- cbind(rep(1,nrow(cancer2)), cancer2$avgAnnCount, cancer2$povertyPercent , cancer2$PctHS25_Over,cancer2$PctBachDeg25_Over,
           cancer2$PctUnemployed16_Over,cancer2$PctPrivateCoverageAlone , cancer2$PctPublicCoverageAlone,
           cancer2$PctWhite,cancer2$PctOtherRace)
H <- X %*% solve(t(X) %*% X) %*% t(X)

#points that exceed 2p/n should be looked more closely
(exc<-2*ncol(cancer2)/nrow(cancer2))
#0.01285898

#finding leverage point
hii <- diag(H)
studentRes <- studres(fitmodel)
which(hii>2)

#finding influence point- lecture -----------
which(hii > exc&(studentRes > 3 | studentRes < -3)) 
#influential point: 798(Crowley County, Colorado),1430(Hudspeth County, Texas),1492(Schleicher County, Texas)
view(cancer2)

#DATA SPLITTING-------

#CROSS VALIDATION------------------
set.seed(71168)
nsamp=ceiling(0.8*length(cancer2$DeathRate))
training_samps=sample(c(1:length(cancer2$DeathRate)),nsamp)
training_samps=sort(training_samps)
train_data<-cancer2[training_samps,]
test_data<-cancer2[-training_samps,]

attach(train_data)
train.lm<-lm(DeathRate~avgAnnCount + povertyPercent + PctHS25_Over + PctBachDeg25_Over + PctUnemployed16_Over + 
               PctPrivateCoverageAlone + PctPublicCoverageAlone + PctWhite + 
               PctOtherRace,data=train_data)
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
  
  
  train.lm<-lm(DeathRate~avgAnnCount + povertyPercent + PctHS25_Over + PctBachDeg25_Over + PctUnemployed16_Over + 
                 PctPrivateCoverageAlone + PctPublicCoverageAlone + PctWhite + 
                 PctOtherRace,data=train_data)
  summary(train.lm)
  
  preds <- predict(train.lm,test_data)
  
  R.sq=cor(preds,test_data$DeathRate)^2
  RMSPE=rmse(preds,test_data$DeathRate)
  MAPE=mae(preds,test_data$DeathRate)

  print(c(i,R.sq,RMSPE,MAPE))
  
}

#highest and lowest 3-----------

sortcancer<-cancer[order(-cancer$DeathRate),]
head(sortcancer)
tail(sortcancer)
#highest 3 --> 1034(Woodson County, Kansas),920(Madison County, Mississippi ),1986(Powell County, Kentucky )
#lowest 3 --> 804(Eagle County, Colorado),1481(Presidio County, Texas), 825( Pitkin County, Colorado)



#LEVERAGE --------- tutorial
#high leverage point: 1393,759
cancer_inf<-influence(fitmodel)
which(cancer_inf$hat>exc)
#graph of high leverage
halfnorm(cancer_inf$hat,labs=names(cancer_inf$hat),ylab='Leverage',main="Leverage Graph")







