#####This script creates a plot 1 and saves it as PNG #####

### Initialize libraries
if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

### Load the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### Explore the NEI data
glimpse(NEI)
summary(NEI)

### Preapre data for plotting
NEI_summarized <- NEI %>%
  as_tibble() %>% 
  group_by(year) %>% 
  summarize(total = sum(Emissions))

### Open the PNG device
png("plot1.png")

### Draw the plot 1
with(NEI_summarized,
     barplot(height = total/10^6,
             names.arg = year,
             main = expression("Total emissions of PM" [2.5]* " in the US for years 1999 to 2008"),
             xlab = "year",
             ylab = expression("total emissions of PM" [2.5]* " in millions of tons")))

### Close the PNG device
dev.off()