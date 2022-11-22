setwd("C:/Users/Michael Joner/Google Drive/BU CS 688/Instructor/6 Module")
#install.packages("googleVis")
library(googleVis)

# Line Chart
student.data = data.frame(
  Student = c("Alice", "Bob", "Charlie", "Dave", "Ed"),
  Exam = c(90, 80, 60, 85, 75),
  Quiz = c(8, 6, 9, 7, 10))
student.data

#https://www.rdocumentation.org/packages/googleVis/versions/0.6.0/topics/gvisLineChart
chart1 <- gvisLineChart(student.data)
plot(chart1)

chart1$type
chart1$chartid
chart1$html$header
chart1$html$chart
chart1$html$caption
chart1$html$footer

names(chart1$html$chart)
chart1$html$chart['jsChart']
chart1$html$chart['divChart']

# Save chart html to file
#cat(chart1$html$chart, file = "chart1.html")
# print(chart1, file = "chart1all.html")

# Line Chart with 2 axis
#targetAxisIndex - Which axis to assign this series to, where 0 is the default axis, 
#and 1 is the opposite axis. Default value is 0; set to 1 to define a chart where 
#different series are rendered against different axes. 
#At least one series must be allocated to the default axis. 
#You can define a different scale for different axes.
chart2 <- gvisLineChart(student.data,"Student", 
                c("Exam","Quiz"),
                options=list(
                  series="[{targetAxisIndex: 0}, {targetAxisIndex:1}]",
                  vAxes="[{title:'Exam'}, {title:'Quiz'}]"
                ))
plot(chart2)
#cat(chart2$html$chart, file = "chart2.html")

# chart with options
chart3 <-  
  gvisLineChart(student.data, 
                xvar="Student", 
                yvar=c("Exam","Quiz"),
                options=list(
                  title="Student Scores",
                  titleTextStyle="{color:'red', 
                          fontName:'Courier', 
                          fontSize:16}", 
                  backgroundColor="#D3D3D3",                          
                  vAxis="{gridlines:{color:'red', count:5}}",
                  hAxis="{title:'Student', titleTextStyle:{color:'blue'}}",
                  series="[{color:'green', targetAxisIndex: 0}, 
                           {color: 'orange',targetAxisIndex:1}]",
                  vAxes="[{title:'Exam'}, {title:'Quiz'}]",
                  legend="bottom",
                  curveType="function",
                  width=500, height=300                         
                        ))
plot(chart3)
#cat(chart3$html$chart, file = "chart3.html")

# Inline editing
chart4 <-  
  gvisLineChart(student.data, 
                xvar = "Student", 
                yvar = c("Exam","Quiz"),
                options=list(
                  series="[{targetAxisIndex: 0},
                           {targetAxisIndex:1}]",
                  vAxes="[{title:'Exam'}, {title:'Quiz'}]",
                  gvis.editor="Edit me!"))
plot(chart4)
#cat(chart4$html$chart, file = "chart4.html")

# Bar Chart
chart5 <- gvisBarChart(student.data)
plot(chart5)
#cat(chart5$html$chart, file = "chart5.html")

chart6 <- gvisBarChart(student.data,
                       xvar="Student", 
                       yvar=c("Exam","Quiz"),
                       options=list(isStacked = TRUE))
plot(chart6)
#cat(chart6$html$chart, file = "chart6.html")

# Column chart
chart7 <- gvisColumnChart(student.data)
plot(chart7)
#cat(chart7$html$chart, file = "chart7.html")

chart8 <- gvisColumnChart(student.data,
                       xvar="Student", 
                       yvar=c("Exam","Quiz"),
                       options=list(isStacked = TRUE))
plot(chart8)
#cat(chart8$html$chart, file = "chart8.html")

chart8b <- gvisColumnChart(student.data,
                          xvar="Student", 
                          yvar=c("Exam"),
                          options=list(selectionMode = "multiple"))
plot(chart8b)
#cat(chart8b$html$chart, file = "chart8b.html")

# Combo chart
chart11 <- 
  gvisComboChart(student.data,
                 xvar="Student",
                 yvar=c("Exam", "Quiz"),
                 options=list(seriesType="bars",
                              series='{1: {type:"line"}}'))
plot(chart11)
#cat(chart11$html$chart, file = "chart11.html")

chart12 <- 
  gvisComboChart(student.data,
                 xvar="Student",
                 yvar=c("Exam", "Quiz"),
                 options=list(seriesType="line",
                              series='{1: {type:"bars"}}'))
plot(chart12)
#cat(chart12$html$chart, file = "chart12.html")

# Scatter chart
?women
head(women)

chart13 <- gvisScatterChart(women)
plot(chart13)
#cat(chart13$html$chart, file = "chart13.html")

chart13b <- gvisScatterChart(women[,2:1])
plot(chart13b)
#cat(chart13$html$chart, file = "chart13b.html")

chart14 <- 
  gvisScatterChart(women,
                   options=list(
                     legend="none",
                     lineWidth=2, pointSize=10,
                     pointShape="diamond",
                     title="Weight vs Height", 
                     vAxis="{title:'weight (lbs)'}",
                     hAxis="{title:'height (in)'}", 
                     width=400, height=400))
plot(chart14)
#cat(chart14$html$chart, file = "chart14.html")

?iris
head(iris)
chart15 <- gvisScatterChart(iris[,1:4],
                            options=list(
                              legend="top",
                              hAxis="{title:'Sepal Length'}", 
                              width=600, height=400))
plot(chart15)
#cat(chart15$html$chart, file = "chart15.html")

data.iris <- iris
data.iris$Index <- 1:nrow(iris)
head(data.iris, n = 2)

head(data.iris[, c(6, 1:4)], n = 2)
chart15_1 <- gvisScatterChart(data.iris[, c(6, 1:4)],
                            options=list(
                              hAxis="{title:'Index'}", 
                              width=700, height=600))
plot(chart15_1)
#cat(chart15_1$html$chart, file = "chart15_1.html")

# Table
head(Stock)

chart23 <- 
  gvisTable(Stock,
            formats=list(Value="#,###"))
plot(chart23)
#cat(chart23$html$chart, file = "chart23.html")

# Table with Pages
names(Population)
head(Population[, c(1:4, 6:7)])
Population[1,5]

chart24 <- 
  gvisTable(Population,
            formats=list(Population="#,###",
                         '% of World Population'='#.#%'),
            options=list(page='enable'))
plot(chart24)
#cat(chart24$html$chart, file = "chart24.html")

# Sankey chart
data.SK <- data.frame(
  From=c('GB','FR','IN', 'IN','JP','SG','JFK','JFK','SFO','SFO'),
  To=c(rep('JFK', 3), rep('SFO', 3), rep(c('BOS', 'DC'),2)),
  Weight=c(5,7,6,2,9,4, 10,8, 6,9))
data.SK

chart29 <- 
  gvisSankey(data.SK,
             from="From", to="To", weight="Weight",
             options=list(
               sankey="{link: {color: { fill: '#d799ae' } },
                                node: { color: { fill: '#00ff00' },
                                label: { color: '#871b47' } }}"))
plot(chart29)
#cat(chart29$html$chart, file = "chart29.html")


