library(tidyverse)
library(stringr)
library(dplyr)

#read data
cancer<-read.csv("cancer_reg.csv", stringsAsFactors = FALSE)
names(cancer)

#remove variable that we dont need
names(cancer)
cancer<-cancer[,-c(8,9,11:12,14:24,26:27,33:34)]
view(cancer)
ncol(cancer)
names(cancer)

#delete missing values
cancer<-cancer[complete.cases(cancer),]
rownames(cancer)=seq(1:nrow(cancer))
view(cancer)

cancer<-as.data.frame(cancer)
str(cancer)

# group into states
attach(cancer)
datapoint <- data.frame(avgAnnCount = 3600, avgDeathsPerYear = 1020, TARGET_deathRate = 164.1, incidenceRate = 463.3, medIncome = 90695,
                        popEst2015 = 717189, povertyPercent = 18.6, MedianAge = 33.9, 
                        Geography = "Washington, District of Columbia", PctPrivateCoverageAlone = 68,
                        PctPublicCoverageAlone = 34.1, PctWhite = 41.96, PctBlack = 44.53, PctAsian = 4.35,
                        PctOtherRace = 9.16)

cancer<-rbind(cancer,datapoint)
cancer<-rename(cancer,"DeathRate"="TARGET_deathRate")
tail(cancer)

names(cancer)
#delete incidence rate-----------
cancer<-cancer[,-c(4)]


attach(cancer)

#SCATTER PLOT OF ORIGINAL DATA ---------------
pairs(DeathRate~medIncome+popEst2015+povertyPercent+MedianAge,data=cancer)
pairs(DeathRate~PctPrivateCoverageAlone+PctPublicCoverageAlone,data=cancer)
pairs(DeathRate~PctWhite+PctBlack+PctAsian+PctOtherRace,data=cancer) 
pairs(DeathRate~avgAnnCount+avgDeathsPerYear,data=cancer)


#LINEAR MODEL
#FIT ALL LINEAR MODEL------------
names(cancer)
#remove geography and check the newdata, cancer2---------
cancer2<-cancer[,-c(8)]
head(cancer2)
tail(cancer2)

#FIT FULL MODEL -----------
deathfitall <- lm(DeathRate ~ ., data = cancer2)


#fit the best model using stepwise regression
library(MASS)
step.model<-stepAIC(deathfitall,direction="both",trace=FALSE)
step.model

#to know the step of the stepwise regression---------------
step(deathfitall,direction="both")
summary(step.model)

#best model
names(cancer2)
attach(cancer2)

bestmodel<-lm(DeathRate ~ avgAnnCount + avgDeathsPerYear + medIncome + 
                popEst2015 + povertyPercent + PctPrivateCoverageAlone + PctPublicCoverageAlone + 
                PctBlack + PctAsian + PctOtherRace,data = cancer2)
plot(bestmodel)
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
#plot 1 : spread out equally
#Plot 2: suggest a slight positive skew to the distribution of the residual, but not large to be concern
#plot 3: the point slightly slanting upward
summary(fitmodel)
vif(fitmodel) 
#all of the VIF is less than 10

#find Leverage points---------------
#INFLUENCE POINTS
X <- cbind(rep(1,nrow(cancer2)), cancer2$avgAnnCount,
           cancer2$medIncome , cancer2$povertyPercent , cancer2$PctPrivateCoverageAlone , cancer2$PctPublicCoverageAlone,
           cancer2$PctBlack ,
           cancer2$PctAsian ,cancer2$PctOtherRace)
H <- X %*% solve(t(X) %*% X) %*% t(X)
#exceed 2p/n should be looked more closely
exc<-2*ncol(cancer2)/nrow(cancer2)
##0.01066011
#potentially influence point: points greater than 0.0106601
#to get influence points ----------
cancer_inf<-influence(fitmodel)
which(cancer_inf$hat>exc)
halfnorm(cancer_inf$hat,labs=names(cancer_inf$hat),ylab='Leverage')
#798,1841 influence points, the other points are potential

#REMOVE INFLUENTIAL POINTS-----------
names(cancer2)
cancer2<-cancer[,-c(2,5)]
names(cancer2)
cancer2<-cancer2[-c(798,1841),]
view(cancer2)

#finding leverage point
hii <- diag(H)
studentRes <- studres(fitmodel)
studentRes
which(hii > 2)
#no leverage point

#cook's distance
cancer_cook<-cooks.distance(fitmodel)
sort(cancer_cook,decreasing=TRUE)
#highest : point 2169: 0.151217962
#no points greater than 1 






