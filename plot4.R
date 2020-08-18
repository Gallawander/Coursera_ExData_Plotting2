#####This script creates a plot 4 and saves it as PNG #####

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
  filter(grepl("Comb|comb", Short.Name) & grepl("Coal|coal", Short.Name)) %>% 
  group_by(year) %>% 
  summarize(total = sum(Emissions))

### Open the PNG device
png("plot4.png")

### Draw the plot 1
ggplot(data, aes(x = factor(year), y = total/1000)) +
  geom_col() +
  labs(title = expression("Total emissions of PM" [2.5]* " from coal-combustion related sources"),
       x = "year",
       y = expression("total emissions of PM" [2.5]* " in kilotons"))

### Close the PNG device
dev.off()