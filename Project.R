
library(tidyverse)
library(dplyr)
library(stringr)

#reading death and incidence data
death <- read.csv("death .csv", header = T ,stringsAsFactors = FALSE)
incd <- read.csv("incd2.csv", stringsAsFactors = FALSE, fileEncoding = "latin1")

#remove , in the first row of average.Deaths.per.year ==> since it will cause an NA
death$Average.Deaths.per.Year[1] <- str_replace((death$Average.Deaths.per.Year[1]),",","")
as.numeric((death$Average.Deaths.per.Year[1]))
death$Average.Deaths.per.Year<-as.numeric(death$Average.Deaths.per.Year)


#Sort death data by FIPS
death_new <- death[order(death$FIPS), ]
view(death_new)

#Merge both datasets
data <- merge(death_new,incd, by = "FIPS", all.x = T)

#CHECK IF IT IS SORTED
head(data)
view(data)
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
head(ndata)


#remove missing values ------------------
names(ndata)
#ndata<-subset(ndata,ndata$AA_deathRate != '*')
            # & ndata$Average_deaths_per_year != '*' & ndata$`AAIC per 100.000`!= '* ' & ndata$Recent_trend_incd != '*'
             # & ndata$'5YearIncdTrend' != '*')

#removing * and **
ndata <- subset(ndata, ndata$Recent_trend_death != "**")
ndata<-subset(ndata,ndata$Recent_trend_death!="*")
ndata<-subset(ndata, ndata$`5YearDeathTrend` != '**' )
ndata<-subset(ndata,ndata$AA_deathRate != '*')
ndata<-subset(ndata,ndata$`AAIC per 100.000`!= '*')
ndata <- subset(ndata,ndata$Recent_trend_incd != '*')
ndata<-subset(ndata,ndata$Average_deaths_per_year != '*')
ndata<-subset(ndata,ndata$`AAIC per 100.000`!= '* ')
ndata<-subset(ndata,ndata$`5YearIncdTrend` != '*')

#removing "_" and "__"
ndata<-subset(ndata,ndata$`AAIC per 100.000`!= "_ ")
ndata<-subset(ndata,ndata$Recent_trend_incd !="_ " | ndata$Recent_trend_death != "_")
ndata<-subset(ndata,ndata$`5YearIncdTrend` !="_ " | ndata$`5YearDeathTrend` != "_ ")

ndata<-subset(ndata,ndata$`AAIC per 100.000`!= "__ ")
ndata<-subset(ndata,ndata$Recent_trend_incd!="__ ")
ndata<-subset(ndata,ndata$`5YearIncdTrend`!="__ ")


#remove # from the data
ndata$`AAIC per 100.000` <- str_remove(ndata$`AAIC per 100.000`," #") 


#change the number of rows
rownames(ndata)=seq(1:nrow(ndata))
#view(ndata)


#extracting first code in FIPS
#newdata is for average per state code - based on the state
#newdata is for the state code, remove the FIPS -PURELY BASED ON THE STATE CODE
names(ndata)
newdata<-ndata %>% select(- Recent_trend_death,-FIPS,-Recent_trend_incd)
head(newdata)


#state code as level of factor
newdata$StateCode<-as.factor(newdata$StateCode)
view(newdata)
#str(newdata$StateCode)

#to average, we need to convert char into int
newdata$`AAIC per 100.000`<-as.numeric(newdata$`AAIC per 100.000`)
newdata$`Average Annual Count`<-as.numeric(newdata$`Average Annual Count`)
newdata$`5YearIncdTrend`<-as.numeric(newdata$`5YearIncdTrend`)
newdata$AA_deathRate<-as.numeric(newdata$AA_deathRate) 
newdata$`5YearDeathTrend`<-as.numeric(newdata$`5YearDeathTrend`)
str(newdata)


attach(newdata)
#new data is data with average based on the state code
newdata<- newdata %>% group_by(StateCode) %>% summarize(`AAIC per 100.000`=mean(`AAIC per 100.000`),
`Average Annual Count`=mean(`Average Annual Count`),`5YearIncdTrend`=mean(`5YearIncdTrend`),AA_deathRate=mean(`AA_deathRate`),`5YearDeathTrend`=mean(`5YearDeathTrend`),`5YearDeathTrend`=mean(`5YearDeathTrend`))
head(newdata)
tail(newdata)

# naming the StateCode 
newdata<-newdata %>% mutate(State=fct_recode(StateCode,"US"="0","Alabama"="1","Alaska"="2","Arizona"="4","Arkansas"="5","California"="6", "Colorado"="8","Connecticut"="9","Delaware"="10",
                                        "BC"="11","Florida"="12","Georgia"="13","Idaho"="16",
                                        "Illinois"="17","Indiana"="18","Iowa"="19","Kentucky"="21","Louisiana"="22","Maine"="23","Maryland"="24","Massachusetts"="25","Michigan"="26"
                                        , "Mississippi"="28","Missouri"="29","Montana"="30","Nebraska"="31","New Hampshire"="33","New Jersey"="34",
                                        "New Mexico"="35","New York"="36","North Carolina"="37","North Dakota"="38","Ohio"="39",
                                        "Oklahoma"="40","Oregon"="41","Pennsylvania"="42","Rhode Island"="44","South Carolina"="45"," South Dakota"="46","Tennessee"="47",
                                        "Texas"="48","Utah"="49","Vermont"="50","Virginia"="51","Washington"="53","West Virginia"="54","Wisconsin"="55","Wyoming"="56"))
view(newdata)
