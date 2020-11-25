install.packages("tidyverse")
library(tidyverse)
library(dplyr)
library(stringr)

#reading death and incidence data
death <- read.csv("death .csv", header = T )
incd <- read.csv("incd2.csv", stringsAsFactors = FALSE, fileEncoding = "latin1")

#Sort death data by FIPS
death_new <- death[order(death$FIPS), ]

#Merge both datasets
data <- merge(death_new,incd, by = "FIPS", all.x = T)
head(data)
colnames(data)

#Removing columns
ndata <- data[,-c(3,5,6,10:12,14,15,19,20)]
ncol(ndata)
colnames(ndata)
head(ndata)

#Renaming columns
names(ndata)[2] <- "County"
names(ndata)[3] <- "AA_deathRate"
names(ndata)[4] <- "Average_deaths_per_year"
names(ndata)[5] <- "Recent_trend_death"
names(ndata)[6] <- "5YearDeathTrend"
names(ndata)[7] <- "AAIC per 100.000"
names(ndata)[8] <- "Average Annual Count"
names(ndata)[9] <- "Recent_trend_incd"
names(ndata)[10] <- "5YearIncdTrend"
colnames(ndata)

#Extracting 1st digit of FIPS as State code 
for(i in 1:nrow(ndata))
{
  ndata$StateCode[i]=floor(ndata$FIPS[i]/1000)
}
head(ndata$StateCode)
tail(ndata$StateCode)

#Removing observations that contains ** and *
ndata <- subset(ndata, ndata$Recent_trend != "**" & death_new$Recent_trend != "*")


#remove the county code------------------
str(ndata$County)
#remove the last 6 code
pattern <- "\\(.*\\)"
ndata$County=str_replace_all(ndata$County,pattern,"")
head(ndata$County)
tail(ndata$County)
as.factor(ndata$County)

#check 
data
head(data)

#remove missing values ------------------
data
ndata<-subset(ndata,ndata$Recent_trend_death != '*' & ndata$'5YearDeathTrend' != '*' & ndata$AA_deathRate != '*'
              & ndata$Average_deaths_per_year != '*' & ndata$`AAIC per 100.000`!= '* ' & ndata$Recent_trend_incd != '*'
              & ndata$'5YearIncdTrend' != '*')

ndata <- subset(ndata, ndata$Recent_trend_death != '**' & ndata$'5YearDeathTrend' != '**' )

ndata<-subset(ndata,ndata$`AAIC per 100.000`!= "_ ")
ndata<-subset(ndata,ndata$Recent_trend_incd !="_ " & ndata$Recent_trend_death != "_")
ndata<-subset(ndata,ndata$'5YearIncdTrend' !="_ " & ndata$'5YearDeathTrend' != "_ ")

ndata<-subset(ndata,ndata$`AAIC per 100.000`!= "__ ")
ndata<-subset(ndata,ndata$Recent_trend_incd!="__ ")
ndata<-subset(ndata,ndata$'5YearIncdTrend'!="__ ")

ndata$`AAIC per 100.000` <- str_remove(ndata$`AAIC per 100.000`," #") #this is where I stop
ndata$`AAIC per 100.000`[1064]


#change the number of rows
rownames(data)=seq(1:nrow(data))
view(data)

#extracting first code in FIPS


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


