
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
cancer<-cancer[,-c(8,9,11:12,14:19,24,26:27,33:34)]
view(cancer)
ncol(cancer)
names(cancer)

#delete missing values
cancer<-cancer[complete.cases(cancer),]
rownames(cancer)=seq(1:nrow(cancer))
view(cancer)

cancer<-as.data.frame(cancer)
str(cancer)
names(cancer)

# group into states
attach(cancer)
datapoint <- data.frame(avgAnnCount = 3600, avgDeathsPerYear = 1020, TARGET_deathRate = 164.1, incidenceRate = 463.3, medIncome = 90695,
                        popEst2015 = 717189, povertyPercent = 18.6, MedianAge = 33.9, 
                        Geography = "Washington, District of Columbia", PctHS25_Over = 17.32, PctBachDeg25_Over = 23.89,
                        PctEmployed16_Over = 71.5, PctUnemployed16_Over = 6.76, PctPrivateCoverageAlone = 68,
                        PctPublicCoverageAlone = 34.1, PctWhite = 41.96, PctBlack = 44.53, PctAsian = 4.35,
                        PctOtherRace = 9.16)
ncol(datapoint)
ncol(cancer)
cancer <- rbind(cancer,datapoint)
names(cancer)

#exclude avgDeathsPerYear, target death rate and geography from cancer data
cancer_new <- cancer[,-c(2,3,9)]
names(cancer_new)


#Pair plots of cancer data and splitting data into half 

pairs(cancer_new,
      main = "Incidence Rate vs avgAnnCount, medIncome, popEst2015, povertyPercent, MedianAge, Pct of Bach's and HS over 25,
              Pct of Unemployed and Employed over 16, Pct of Private and Public Coverage, and Pct of White, Black, 
              Asian and Other Race",
      cex.main = 0.5)

#incidence model using backward regression
incd.lm <- lm(incidenceRate ~ ., data = cancer_new)
step(incd.lm, direction = 'backward')

incd_new <- lm(cancer_new$incidenceRate ~ cancer_new$avgAnnCount + cancer_new$popEst2015 + 
                cancer_new$MedianAge + cancer_new$PctHS25_Over + 
                cancer_new$PctUnemployed16_Over + cancer_new$PctPrivateCoverageAlone + 
                cancer_new$PctPublicCoverageAlone + cancer_new$PctWhite + cancer_new$PctBlack + 
                cancer_new$PctOtherRace, data = cancer_new)

plot(incd_new) 
outlierTest(incd_new)
#possible outliers are points 228,207,84,2087
#in residuals vs fitted plot, the line(variance) is slightly slanting downwards
#Normal Q-Q plot, line is not best fit
#Scale location plot, line is also slanting downwards

#checking for large vif
vif(incd_new) #all vifs < 10 so not large

#Finding leverage points 
X <- cbind(rep(1,nrow(cancer)), cancer_new$avgAnnCount, cancer_new$medIncome,  cancer_new$popEst2015, 
           cancer_new$MedianAge, cancer_new$PctHS25_Over, cancer_new$PctBachDeg25_Over, cancer_new$PctEmployed16_Over,
           cancer_new$PctUnemployed16_Over, cancer_new$PctPrivateCoverageAlone,  cancer_new$PctPublicCoverageAlone, 
           cancer_new$PctWhite,  cancer_new$PctBlack,  cancer_new$PctOtherRace)
H <- X %*% solve(t(X) %*% X) %*% t(X)
hii <- diag(H)
studentRes <- studres(incd_new)
which(hii > 2*ncol(X)/nrow(X) & (studentRes > 3 | studentRes < -3)) #likely to be influential points: 228, 1430, 2087, 2104

#Cross validation
set.seed(123)
nsamp = ceiling(0.8*length(cancer_new$incidenceRate))
training_samps <- sample(c(1:length(cancer_new$incidenceRate)), nsamp)
training_samps <- sort(training_samps)
train_data <- cancer_new[training_samps, ]
test_data <- cancer_new[-training_samps, ]

#Fit model using training data
attach(train_data)
train.incd <- lm(incidenceRate ~ avgAnnCount + popEst2015 + MedianAge + 
                  PctHS25_Over + PctUnemployed16_Over + PctPrivateCoverageAlone + 
                  PctPublicCoverageAlone + PctWhite + PctBlack + PctOtherRace, 
                  data = train_data)

#Predict responses on test set
preds <- predict(train.incd, test_data)

#Evaluating quality of prediction
Rsq <- R2(preds, test_data$incidenceRate)
RMSPE <- RMSE(preds, test_data$incidenceRate)
MAPE <- MAE(preds,test_data$incidenceRate)
print(c(Rsq,RMSPE,MAPE))

#Standardize RMSPE by dividing RMSPE by sd
RMSPE/sd(test_data$incidenceRate)

#loop 5 times
set.seed(123)

for (i in 1:5){
  nsamp = ceiling(0.8*length(cancer_new$incidenceRate))
  training_samps <- sample(c(1:length(cancer_new$incidenceRate)), nsamp)
  training_samps <- sort(training_samps)
  train_data <- cancer_new[training_samps, ]
  test_data <- cancer_new[-training_samps, ]
  dim(test_data)
  
  #Fit model using training data
  train.incd <- lm( incidenceRate ~ avgAnnCount + medIncome + popEst2015 + 
                      MedianAge + PctPrivateCoverageAlone + PctPublicCoverageAlone + 
                      PctWhite + PctBlack + PctOtherRace, data = train_data)
  
  #Predict responses on test set
  preds <- predict(train.incd, test_data)
  
  #Evaluating quality of prediction
  Rsq <- R2(preds, test_data$incidenceRate)
  RMSPE <- RMSE(preds, test_data$incidenceRate)
  MAPE <- MAE(preds,test_data$incidenceRate)
  print(c(Rsq,RMSPE,MAPE))
  
  RMSPE/sd(test_data$incidenceRate)
  
  
}

#we want to compare the 3 highest incident rates and 3 lowest incident rates

cancer_new <- cancer_new[order(-cancer_new$incidenceRate),]

head(cancer_new)

view(cancer_new)

tail(cancer_new)











