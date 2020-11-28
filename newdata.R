library(tidyverse)
library(stringr)
library(dplyr)

cancer<-read.csv("cancer_reg.csv", stringsAsFactors = FALSE)


#remove variable that we dont need
names(cancer)
cancer<-cancer[,-c(3,8,9,11:12,14:24,26:27,33:34)]
view(cancer)
names(cancer)

#delete missing values
cancer<-cancer[complete.cases(cancer),]
rownames(cancer)=seq(1:nrow(cancer))
view(cancer)

cancer<-as.data.frame(cancer)
str(cancer)

# group into states
attach(cancer)

#split the county and the state
split<-str_split_fixed(Geography,fixed(", "),2)
split<-as.data.frame(split)
split<-rename(split,"County"="V1","States"="V2")
data<-cbind(cancer,split[1],split[2])
head(data)
names(data)






