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
str(data)

#remove the county code------------------
str(data$County)
#remove the last 6 code
pattern <- "\\(.*\\)"
data$County=str_replace_all(data$County,pattern,"")
head(data$County)
tail(data$County)
as.factor(data$County)

#check 
data
head(data)

#remove missing values ------------------
data
data<-subset(data,data$`AAIC per 100.000`!= "* ")
data<-subset(data,data$Trend!="*")
data<-subset(data,data$`5 years Trend`!="*")

data<-subset(data,data$`AAIC per 100.000`!= "_ ")
data<-subset(data,data$Trend!="_ ")
data<-subset(data,data$`5 years Trend`!="_ ")

data<-subset(data,data$`AAIC per 100.000`!= "__ ")
data<-subset(data,data$Trend!="__ ")
data<-subset(data,data$`5 years Trend`!="__ ")

data$`AAIC per 100.000` <- str_remove(data$`AAIC per 100.000`," #")
data$`AAIC per 100.000`[1064]



#change the number of rows
rownames(data)=seq(1:nrow(data))
view(data)

#extracting first code in FIPS

for(i in 1:nrow(data))
{
  data$StateCode[i]=floor(data$FIPS[i]/1000)
}
view(data)
tail(data)

#data2 is for the state code, remove the FIPS
data2<-data %>% select(-Trend,-FIPS)
head(data2)
view(data2)
str(data2)

#state code as level of factor
data2$StateCode<-as.factor(data2$StateCode)
str(data2$StateCode)

str(data2)
data2$`AAIC per 100.000`<-as.numeric(data2$`AAIC per 100.000`)
data2$`Average Annual Count`<-as.numeric(data2$`Average Annual Count`)
data2$`5 years Trend`<-as.numeric(data2$`5 years Trend`)
str(data2)




attach(data2)
#new data is data with average and group_by their code
#newdata<- data2 %>% group_by(StateCode) %>% summarize(`AAIC per 100.000`=mean(`AAIC per 100.000`),
                                                      #`Average Annual Count`=mean(`Average Annual Count`),`5 years Trend`=mean(`5 years Trend`))
head(newdata)
tail(newdata)
view(newdata)

newdata<- data2 %>% group_by(StateCode) %>% summarize(`AAIC per 100.000`=mean(`AAIC per 100.000`,by=StateCode),
                                             `Average Annual Count`=mean(`Average Annual Count`,by= StateCode),`5 years Trend`=mean(`5 years Trend`,by= StateCode))

str(newdata)
attach(newdata)

hh<-newdata %>% mutate(State=fct_recode(StateCode,"US"="0","Alabama"="1","Alaska"="2","Arizona"="4","Arkansas"="5","California"="6", "Colorado"="8","Connecticut"="9","Delaware"="10",
                                  "BC"="11","Florida"="12","Georgia"="13","Hawaii"="15","Idaho"="16",
                                  "Illinois"="17","Indiana"="18","Iowa"="19","Kentucky"="21","Louisiana"="22","Maine"="23","Maryland"="24","Massachusetts"="25","Michigan"="26"
                                  , "Mississippi"="28","Missouri"="29","Montana"="30","Nebraska"="31","New Hampshire"="33","New Jersey"="34",
                                  "New Mexico"="35","New York"="36","North Carolina"="37","North Dakota"="38","Ohio"="39",
                                  "Oklahoma"="40","Oregon"="41","Pennsylvania"="42","Rhode Island"="44","South Carolina"="45"," South Dakota"="46","Tennessee"="47",
                                  "Texas"="48","Utah"="49","Vermont"="50","Virginia"="51","Washington"="53","West Virginia"="54","Wisconsin"="55","Wyoming"="56"))


head(hh)


