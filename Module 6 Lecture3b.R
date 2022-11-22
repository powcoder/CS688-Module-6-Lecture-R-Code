rm(list=ls()); cat("\014") # clear all
setwd("C:/Users/Michael Joner/Google Drive/BU CS 688/Instructor/6 Module")

library(jsonlite) # could use library(RJSONIO)
library(dplyr)
library(purrr)

webpage <- "12months_departures_joiners.json"
  # download file from https://onlinecampus.bu.edu/bbcswebdav/pid-7573957-dt-content-rid-36140779_1/courses/20sprgmetcs688_o2/course/documents/metcs688_12months_departures_joiners.json
  # you must be logged in to Blackboard to do this ==> can't simply run getURL() on the above address
  # so use web browser and save file to your computer!
data <- fromJSON(webpage)

typeof(data)
names(data)
typeof(data$nodes)
length(data$nodes)
data$nodes[[1]]

nodes.info <- data$nodes %>% bind_rows  # only really needed with RJSONIO library
head(nodes.info)
tail(nodes.info)
dim(nodes.info)
months <- unique(nodes.info$month)
months
table(nodes.info$month)

library(lubridate)
nodes.info$lubrimonth <- parse_date_time(nodes.info$month,"my")  # m = month, y = year
tabl <- table(nodes.info$lubrimonth)
names(tabl) <- months
tabl

levels <- unique(nodes.info$name)
levels
table(nodes.info$name)


# rest of file: optional - more practice working on the JSON format
# practice making Sankey diagrams

# Links - optional?
typeof(data$links)
length(data$links)
data$links[[1]]

links.info <- data$links
#if using library(RJSONIO), needs to be--->  links.info <- data$links%>% map_df(bind_rows)
head(links.info)
tail(links.info)
table(links.info$source)
table(links.info$target)

links.info$SourceName <- paste0(links.info$source, "-", nodes.info$name[links.info$source+1])
head(links.info)
tail(links.info)

links.info$TargetName <- paste0(links.info$target, "-", nodes.info$name[links.info$target+1])
head(links.info)
tail(links.info)

# Sankey chart data for first 3 monthly periods - optional
source.data <- nodes.info$node[nodes.info$month %in%c("Nov-11", "Dec-11", "Jan-12")]
source.data

links.data <- links.info[links.info$source %in% source.data,
              c("SourceName", "TargetName", "value")]
dim(links.data)
head(links.data)
tail(links.data)

options <- "{
  node: {
    label: {
      fontName: 'Times-Roman',
      fontSize: 12,
      color: '#000',
      bold: true,
      italic: false
    },
    labelPadding: 6, 
    nodePadding: 30, 
    width: 5         
  },
  link: {
    color: { fill: '#d799ae' } 
  }
}"

library(googleVis)

chart.data <- gvisSankey(links.data,
                from="SourceName", to="TargetName", weight="value",
                options=list(width=600, height=500, sankey=options))
plot(chart.data)

months.names <- data.frame(rbind(c("Nov-11...", "Dec-11...", "Jan-12...")))
months.names

names(months.names) <- paste(c("Nov-11", "Dec-11", "Jan-12"),
                             c("Dec-11", "Jan-12", "Feb-12"),
                             sep="====>")
months.names

chart.names <- gvisTable(months.names, options=list(width=600))
plot(chart.names)

months.info <- nodes.info[nodes.info$month %in% 
                          c("Nov-11", "Dec-11", "Jan-12", "Feb-12"), 
                          c("month", "node", "name")]
months.info
chart.table <- gvisTable(months.info)
plot(chart.table)

charttemp <- gvisMerge(chart.data, chart.names)
plot(charttemp)

chart1 <- gvisMerge(gvisMerge(chart.data, chart.names),
                    chart.table, horizontal = TRUE)
plot(chart1)

