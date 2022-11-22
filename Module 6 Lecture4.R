# Module 6 - Sports Analytics
rm(list=ls()); cat("\014") # clear all
#### Basketball Data Analytics ---- 
setwd("C:/Users/Michael Joner/Google Drive/BU CS 688/Instructor/6 Module")
#install.packages("SportsAnalytics")
library(googleVis)
library(SportsAnalytics)

nba0708 <- fetch_NBAPlayerStatistics("07-08")
# save(nba0708, file="nba0708.RData")
# load(file="nba0708.RData")

names(nba0708)
dim(nba0708)
table(nba0708$Team)
nba0708.bos <- subset(nba0708, Team == 'BOS')
# nba0708.bos <- nba0708[nba0708$Team=='BOS',]

nba0708.bos[,c(2,4:12)]
chart1 <- gvisTable(nba0708.bos[,c(2,4:12)])
plot(chart1)
# print(chart1, file = "chart1.html")

# warning: this chart doesn't follow good data visualization principles and needs work
#  provided by way of example only
chart2 <- 
  gvisColumnChart(
    nba0708.bos,
    xvar = "Name",
    yvar = c("FieldGoalsMade", "FieldGoalsAttempted"),
    options=list(
      legend="top",
      height=500, width=850))
plot(chart2)
# print(chart2, file = "chart2.html")

#### Basketball Championship Data -----
library(stringr)
library(rvest)
library(dplyr)

### Who won the NBA finals?
webpageChamp <- "https://en.wikipedia.org/wiki/List_of_NBA_champions"
dataChamp <- webpageChamp %>% read_html %>% html_nodes("table.wikitable")
dataChamp <- (dataChamp[2] %>% html_table)[[1]]

head(dataChamp %>% select(Year,`Western champion`,Result,`Eastern champion`))

dataChamp$WestWins <- as.numeric(substr(dataChamp$Result,1,1))
dataChamp$EastWins <- as.numeric(substr(dataChamp$Result,3,3))
dataChamp$Winner <- ifelse(dataChamp$WestWins>dataChamp$EastWins,dataChamp$`Western champion`,dataChamp$`Eastern champion`)
head(dataChamp %>% select(Year,Winner))

dataChamp$`Western champion` <- str_extract(dataChamp$`Western champion`,"^(.*?) \\(")
dataChamp$`Western champion` <- substr(dataChamp$`Western champion`,1,nchar(dataChamp$`Western champion`)-2)
dataChamp$`Eastern champion` <- str_extract(dataChamp$`Eastern champion`,"^(.*?) \\(")
dataChamp$`Eastern champion` <- substr(dataChamp$`Eastern champion`,1,nchar(dataChamp$`Eastern champion`)-2)
dataChamp$Winner <- ifelse(dataChamp$WestWins>dataChamp$EastWins,dataChamp$`Western champion`,dataChamp$`Eastern champion`)
head(dataChamp %>% select(Year,Winner))

### Regular Season MVP

webpageMVP <- "https://en.wikipedia.org/wiki/NBA_Most_Valuable_Player_Award"
dataMVP <- webpageMVP %>% read_html %>% html_nodes("table.wikitable")
dataMVP <- (dataMVP[2] %>% html_table)[[1]]

head(dataMVP)

dataMVP$Player <- gsub("\\(.*\\)","",dataMVP$Player)
dataMVP$Player <- gsub("\\[.*\\]","",dataMVP$Player)
dataMVP$Player <- gsub("\\*","",dataMVP$Player)
dataMVP$Player <- gsub("\\^","",dataMVP$Player)
dataMVP$Player <- str_trim(dataMVP$Player)
head(dataMVP)

### Finals MVP

webpageFMVP <- "https://en.wikipedia.org/wiki/NBA_Finals_Most_Valuable_Player_Award"
dataFMVP <- webpageFMVP %>% read_html %>% html_nodes("table.wikitable")
dataFMVP <- (dataFMVP[2] %>% html_table)[[1]]

head(dataFMVP)

dataFMVP$Player <- gsub("\\(.*\\)","",dataFMVP$Player)
dataFMVP$Player <- gsub("\\[.*\\]","",dataFMVP$Player)
dataFMVP$Player <- gsub("\\*","",dataFMVP$Player)
dataFMVP$Player <- gsub("\\^","",dataFMVP$Player)
dataFMVP$Player <- str_trim(dataFMVP$Player)
head(dataFMVP)

