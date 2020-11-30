library(tidyverse)
library(stringr)
library(dplyr)

#read data
cancer<-read.csv("cancer_reg.csv", stringsAsFactors = FALSE)

#remove variable that we don't need-----------
names(cancer)
cancer<-cancer[,-c(8,9,11:12,14:24,26:27,33:34)]
view(cancer)
names(cancer)

#delete missing values/NA--------------
cancer<-cancer[complete.cases(cancer),]
rownames(cancer)=seq(1:nrow(cancer))
view(cancer)

#see summary -----------
summary(cancer)
attach(cancer)

#SCATTER PLOT OF ORIGINAL DATA ---------------
pairs(DeathRate~medIncome+popEst2015+povertyPercent+MedianAge,data=cancer)
pairs(DeathRate~PctPrivateCoverageAlone+PctPublicCoverageAlone,data=cancer)
pairs(DeathRate~PctWhite+PctBlack+PctAsian+PctOtherRace,data=cancer) 
pairs(DeathRate~avgAnnCount+avgDeathsPerYear+incidenceRate,data=cancer)


#LINEAR MODEL
#FIT ALL LINEAR MODEL------------
names(cancer)
cancer2<-cancer[,-c(9)]
cancer2<-rename(cancer2,"DeathRate"="TARGET_deathRate")
head(cancer2)
deathfitall <- lm(DeathRate ~ ., data = cancer2)
summary(deathfitall)


#fit the best model using stepwise regression
library(MASS)
step.model<-stepAIC(deathfitall,direction="both",trace=FALSE)
# step(deathfitall,direction="both")
step.model
summary(step.model)

#best model
names(cancer2)
bestmodel<-lm(DeathRate ~ avgAnnCount + avgDeathsPerYear + incidenceRate + 
                   medIncome + povertyPercent + PctPublicCoverageAlone + PctWhite + 
                   PctAsian + PctOtherRace, data = cancer2)
plot(bestmodel)
summary(bestmodel)


#outliers----------
qqPlot(bestmodel,labels=row.names(bestmodel), id.method="identify",
         simulate=TRUE, main="Q-Q Plot")
#data 232 and 966 could be potential outlier
#using outlierTest to make sure if potential outliers are indeed outliers
outlierTest(bestmodel)

#INFLUENTIAL OBSERVATIONS---------
#COOK'S DISTANCE
names(cancer2)
data<-cancer2[,-c(6,8:9,12)]
names(data)

cutoff <- 4/(nrow(data)-length(deathfitall$coefficients)-2)
cutoff
plot(bestmodel, which=4, cook.levels=cutoff)
abline(h=cutoff, lty=2, col="red")
#^helpful to identify influential observations


#added variable plots ---------
library(car)
avPlots(bestmodel,ask=FALSE,id.method="identify")
