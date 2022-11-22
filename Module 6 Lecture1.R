barplot(c("2014-15"=150.8,"2015-16"=57.5,"2016-17"=66.4,"2017-18"=92.8),
  main="Snowfall at Blue Hill Observatory",
  las=2
)


library(quantmod)
library(lubridate)
library(ggplot2)
AMZN <- getSymbols("AMZN", auto.assign=F)
AMZN.matrix <- as.matrix(AMZN)
times <- ymd(rownames(AMZN.matrix))
AMZN.df <- data.frame(date=times,price=AMZN.matrix[,"AMZN.Adjusted"])
AMZN.df.since2018 <- AMZN.df[AMZN.df$date>"2018-01-01",]
ggplot(data=AMZN.df.since2018,aes(x=date,y=price)) + geom_line() + labs(title="Amazon stock price since 2018")

AMZN.df.since2018$pricediff <- AMZN.df.since2018$price-AMZN.df.since2018$price[1]
ggplot(data=AMZN.df.since2018,aes(x=date,y=pricediff)) + geom_line() +
  labs(title="Change in Amazon stock price since 2018",
       y=paste0("Difference in price since ",AMZN.df.since2018$date[1])) +
  geom_hline(yintercept = 0)

library(tidyverse)
library(directlabels)
getStockGrowth <- function(symbol,since) {
  data <- getSymbols(symbol, auto.assign=F)
  data.matrix <- as.matrix(data)
  times <- ymd(rownames(data.matrix))
  start <- data.matrix[min(which(times>=since)),paste0(symbol,".Adjusted")]
  end <- data.matrix[length(times),paste0(symbol,".Adjusted")]
  df <- data.frame(symbol=symbol,start=1,end=end/start)
  names(df)[2:3] <- as.character(times[c(min(which(times>=since)),length(times))])
  return(df)
}
growthData <- rbind(
  getStockGrowth("AMZN","2018-01-01"),
  getStockGrowth("MSFT","2018-01-01"),
  getStockGrowth("TSLA","2018-01-01"),
  getStockGrowth("AAPL","2018-01-01"),
  getStockGrowth("GE","2018-01-01"),
  getStockGrowth("NFLX","2018-01-01"),
  getStockGrowth("FB","2018-01-01"))
growthDataGather <- growthData %>% gather("when","value",2:3)
growthDataGather$symbol <- as.character(growthDataGather$symbol)
ggplot(data=growthDataGather,aes(x=when,y=value,group=symbol,colour=symbol)) + geom_line() +
  scale_x_discrete(expand=c(0,0.3)) +
  scale_colour_discrete(guide="none") +
  geom_dl(aes(label=symbol),method="last.points") +
  labs(title=paste0("Value of $1 invested on ",growthDataGather$when[1]))

irisGather <- iris %>% gather("dimension","centimeters",1:4)
ggplot(data=irisGather,aes(x=dimension,y=centimeters)) + geom_boxplot() +
  labs(title="Dimensions of iris flower petals and sepals")
ggplot(data=irisGather,aes(x=dimension,y=centimeters,fill=Species)) + geom_boxplot() +
  labs(title="Dimensions of iris flower petals and sepals")


library(rvest)
webpage <- read_html("https://en.wikipedia.org/wiki/List_of_United_States_counties_by_per_capita_income")
poptable <- webpage %>% html_node("table.wikitable") %>% html_table(header = TRUE)
poptable <- subset(poptable,poptable[,1]!="")  # remove rows that have state totals
for(i in 4:8) poptable[,i] <- as.numeric(gsub("[\\$,]", "", poptable[,i]))
ggplot(data=poptable,aes(x=Population,y=`Per capitaincome`)) + geom_point() +
  labs(title="Income vs Population by U.S. county",
       y="Income per capita")

popMAandNY <- subset(poptable,poptable$State %in% c("Massachusetts","New York"))
ggplot(data=popMAandNY,aes(x=Population,y=`Per capitaincome`,colour=`State, federal district or territory`)) + geom_point() +
  labs(title="Income vs Population by MA and NY counties",
       y="Income per capita")


