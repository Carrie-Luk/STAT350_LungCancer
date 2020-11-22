library(tidyverse)
getwd()
#READ DATA ------------

data<-read.csv("incd2.csv",stringsAsFactors = FALSE)
head(data)
tail(data)

#selecting the variables and rename the variables -----------
names(data)
data<-data %>% select(County,FIPS,`Age.Adjusted.Incidence.Rate.Ê....cases.per.100.000`,`Average.Annual.Count`,`Recent.Trend`,`Recent.5.Year.Trend.....in.Incidence.Rates`)
head(data)

#rename variables
data <-data %>% rename("AAIC per 100.000"='Age.Adjusted.Incidence.Rate.Ê....cases.per.100.000',"Average Annual Count"='Average.Annual.Count',"Trend"='Recent.Trend',"5 years Trend"='Recent.5.Year.Trend.....in.Incidence.Rates')


#remove the county code------------------
str(data$County)
#remove the last 6 code
data$County<-as.character(data$County)
str(data$County)

pattern <- "\\(.*\\)"
data$County=str_replace_all(data$County,pattern,"")
head(data$County)
tail(data$County)
as.factor(data$County)

#check 
data


#remove missing values ------------------
data<-subset(data,data$`AAIC per 100.000`!= "* ")
data<-subset(data,data$Trend!="*")
data<-subset(data,data$`5 years Trend`!="*")
data


