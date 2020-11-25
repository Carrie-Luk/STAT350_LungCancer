library(tidyverse)
getwd()
#READ DATA ------------

data<-read.csv("incd2.csv",stringsAsFactors = FALSE)
head(data)
tail(data)
view(data)

#selecting the variables and rename the variables -----------
names(data)
data<-data[complete.cases(data),]
data<-data %>% select(County,FIPS,`Age.Adjusted.Incidence.Rate.Ê....cases.per.100.000`,`Average.Annual.Count`,`Recent.Trend`,`Recent.5.Year.Trend.....in.Incidence.Rates`)
head(data)

#rename variables
data <-data %>% rename("AAIC per 100.000"='Age.Adjusted.Incidence.Rate.Ê....cases.per.100.000',"Average Annual Count"='Average.Annual.Count',"Trend"='Recent.Trend',"5 years Trend"='Recent.5.Year.Trend.....in.Incidence.Rates')
str(data$FIPS)

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
view(data)
attach(data)
detach(data)
library(stringr)

#extracting first code in FIPS

for(i in 1:nrow(data))
{
  data$FIPS[i]=floor(data$FIPS[i]/1000)
  if(data$FIPS[i]>10)
  {
    data$FIPS[i]=floor(data$FIPS[i]/10)
  }
}
view(data)
tail(data)



data$FIPS<-factor(data$FIPS)
str(data$FIPS)
# data<-data$FIPS %>% as.numeric(data$FIPS)
str(data)
head(data)

data<-data %>% select(-Trend)
str(data)
head(data)
data$`AAIC per 100.000`<-as.double(data$`AAIC per 100.000`,na.rm=TRUE)
data$`Average Annual Count`<-as.double(data$`Average Annual Count`,na.rm=TRUE)
data$`5 years Trend`<-as.double(data$`5 years Trend`,na.rm=TRUE)
str(data)

attach(data)
data2<- data %>% group_by(FIPS) %>% summarize(`AAIC per 100.000`=mean(`AAIC per 100.000`,by=FIPS,na.rm=TRUE),
                                              `Average Annual Count`=mean(`Average Annual Count`,by= FIPS,na.rm=TRUE),`5 years Trend`=mean(`5 years Trend`,by= FIPS,na.rm=TRUE))
data2
data2$FIPS<-as.factor(data2$FIPS)
attach(data2)


#masih ada NA and 11 nya error
data2 %>% mutate(State=fct_recode(FIPS,"US"="0","Alabama"="1","Alaska"="2","Arizona"="4","Arkansas"="5","California"="6", "Colorado"="8","Connecticut"="9","Delaware"="10",
                                  "BC"="11","Florida"="12","Georgia"="13","Hawaii"="15","Idaho"="16",
                                  "Illinois"="17","Indiana"="18","Iowa"="19","Kentucky"="21","Louisiana"="22","Maine"="23","Maryland"="24","Massachusetts"="25","Michigan"="26"
                                  , "Minnesota"="27","Mississippi"="28","Missouri"="29","Montana"="30","Nebraska"="31","Nevada"="32","New Hampshire"="33","New Jersey"="34",
                                  "New Mexico"="35","New York"="36","North Carolina"="37","North Dakota"="38","Ohio"="39",
                                  "Oklahoma"="40","Oregon"="41","Pennsylvania"="42","Rhode Island"="44","South Carolina"="45"," South Dakota"="46","Tennessee"="47",
                                  "Texas"="48","Utah"="49","Vermont"="50","Virginia"="51","Washington"="53","West Virginia"="54","Wisconsin"="55","Wyoming"="56"))





