#####This script creates a plot 2 and saves it as PNG #####

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
  group_by(fips, year) %>% 
  summarize(total = sum(Emissions)) %>% 
  filter(fips == "24510")

### Open the PNG device
png("plot2.png")

### Draw the plot 1
with(NEI_summarized,
     barplot(height = total,
             names.arg = year,
             main = expression("Total emissions of PM" [2.5]* " in the Baltimore City, MD from 1999 to 2008"),
             xlab = "year",
             ylab = expression("total emissions of PM" [2.5]* " in tons")))

### Close the PNG device
dev.off()