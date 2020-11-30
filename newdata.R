
library(tidyverse)
library(stringr)
library(dplyr)
library(knitr)
library(caret)
library(car)


cancer<-read.csv("cancer_reg.csv", stringsAsFactors = FALSE)
names(cancer)

#remove variable that we dont need
names(cancer)
cancer<-cancer[,-c(8,9,11:12,14:24,26:27,33:34)]
view(cancer)

#delete missing values
cancer<-cancer[complete.cases(cancer),]
rownames(cancer)=seq(1:nrow(cancer))
view(cancer)

cancer<-as.data.frame(cancer)
str(cancer)

# group into states
attach(cancer)

#exclude avgDeathsPerYear, target death rate and geography from cancer data
cancer_new <- cancer[,-c(2,3,9)]
names(cancer_new)

#Pair plots of cancer data and splitting data into half 
colnames(cancer_new)
cancer_new1 <- cancer_new[,c(1:5)] 
cancer_new2 <- cancer_new[,c(3,6:10)]
colnames(cancer_new2)
pairs(cancer_new1)
pairs(cancer_new2)

#incidence model using stepwise regression
incd.lm <- lm(incidenceRate ~ ., data = cancer_new)
step(incd.lm, direction = 'both')

incd_new <- lm( incidenceRate ~ avgAnnCount + medIncome + popEst2015 + 
                  MedianAge + PctPrivateCoverageAlone + PctPublicCoverageAlone + 
                  PctWhite + PctBlack + PctOtherRace, data = cancer_new)
plot(incd_new) 
#possible outliers are points 1490, 282, 256
#in residuals vs fitted plot, the line(variance) is slightly slanting downwards
#Normal Q-Q plot, line is not best fit
#Scale location plot, line is also slanting downwards

#checking for large vif
vif(incd_new) #all vifs < 10 so not large

#Finding leverage points
X <- cbind(rep(1,nrow(cancer)), cancer_new$avgAnnCount, cancer_new$medIncome,  cancer_new$popEst2015, 
           cancer_new$MedianAge,  cancer_new$PctPrivateCoverageAlone,  cancer_new$PctPublicCoverageAlone, 
           cancer_new$PctWhite,  cancer_new$PctBlack,  cancer_new$PctOtherRace)
H <- X %*% solve(t(X) %*% X) %*% t(X)
hii <- diag(H)
studentizedRes <- studres(incd_new)
