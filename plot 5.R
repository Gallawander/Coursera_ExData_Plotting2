#####This script creates a plot 5 and saves it as PNG #####

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

### Explore the data
glimpse(NEI)
glimpse(SCC)

### Preapre data for plotting
data <- NEI %>%
  as_tibble() %>%
  inner_join(SCC, by = "SCC") %>%
  filter(grepl("Highway Vehicles", SCC.Level.Two)) %>% 
  group_by(fips, year) %>% 
  summarize(total = sum(Emissions)) %>% 
  filter(fips == "24510")

### Open the PNG device
png("plot5.png")

### Draw the plot 1
ggplot(data, aes(x = factor(year), y = total)) +
  geom_col() +
  labs(title = expression("Total emissions of PM" [2.5]* " from motor vehicles in Baltimore city, MD"),
       x = "year",
       y = expression("total emissions of PM" [2.5]* " in tons"))

### Close the PNG device
dev.off()