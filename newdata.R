library(tidyverse)
library(stringr)
library(dplyr)

cancer<-read.csv("cancer_reg.csv", stringsAsFactors = FALSE)


#remove variable that we dont need
names(cancer)
cancer<-cancer[,-c(3,8,9,14:23,25:26,28:34)]
view(cancer)
names(cancer)
cancer<-as.data.frame(cancer)
str(cancer)

# group into states
attach(cancer)

#split the county and the state
split<-str_split_fixed(Geography,fixed(","),2)
split<-as.data.frame(split)
split<-rename(split,"County"="V1","States"="V2")
data<-cbind(cancer,split[1],split[2])

#remove the Geography from the data
data<-data[,-c(10)]
data

#want to group by state
#delete the county
names(data)
statedata<-data[,-c(12)]

#average per state
statedata<- statedata %>% group_by(States) %>% summarize(`avgAnnCount`=mean(avgAnnCount),
                                                        `avgDeathsPerYear`=mean(`incidenceRate`),popEst2015=mean(`popEst2015`),`povertyPercent`=mean(`povertyPercent`),`povertyPercent`=mean(`povertyPercent`),MedianAge=mean(MedianAge),MedianAgeMale=mean(MedianAgeMale),
                                                        MedianAgeFemale=median(MedianAgeFemale),PctPublicCoverage=mean(PctPublicCoverage),PctPrivateCoverage=mean(PctPrivateCoverage))
head(statedata)
tail(statedata)
view(statedata)



