#####This script creates a plot 6 and saves it as PNG #####

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
  filter(fips %in% c("06037", "24510")) %>% 
  mutate(city = if_else(fips == "24510", "Baltimore city", "Los Angeles"))

### Open the PNG device
png("plot6.png")

### Draw the plot 1
ggplot(data, aes(x = factor(year), y = total)) +
  geom_col() +
  facet_grid(cols = vars(city)) + 
  labs(title = expression("Total emissions of PM" [2.5]* " from motor vehicles in selected cities"),
       x = "year",
       y = expression("total emissions of PM" [2.5]* " in tons"))

### Close the PNG device
dev.off()

### Calculate the percentage change of total emissions compared to previous year for each city ###
data_change <- data %>% 
  mutate(Change = (total/lag(total) - 1) * 100) %>% 
  filter(!is.na(Change))

### Open the PNG device
png("plot6b.png")

### Draw the plot 1
ggplot(data_change, aes(x = factor(year), y = Change)) +
  geom_col() +
  facet_grid(cols = vars(city)) + 
  labs(title = expression("Percentage change of PM" [2.5]* " compared to the previous year"),
       x = "year",
       y = expression("percentage change of PM" [2.5]*""))

### Close the PNG device
dev.off()