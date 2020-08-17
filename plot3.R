#####This script creates a plot 3 and saves it as PNG #####

### Initialize libraries
if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
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
  group_by(type, fips, year) %>% 
  summarize(total = sum(Emissions)) %>% 
  filter(fips == "24510")

NEI_summarized$year = as.factor(NEI_summarized$year)
NEI_summarized$type = as.factor(NEI_summarized$type)
levels(NEI_summarized$type) <- c("Non-road", "Non-point", "Road", "Point")
NEI_summarized$type <- factor(NEI_summarized$type, levels = c("Point", "Non-point", "Road", "Non-road"))

### Open the PNG device
png("plot3.png")

### Draw the plot 1
ggplot(NEI_summarized, aes(x = year, y = total, fill = type)) +
  geom_col() +
  facet_grid(cols = vars(type)) +
  guides(fill = F)

### Close the PNG device
dev.off()