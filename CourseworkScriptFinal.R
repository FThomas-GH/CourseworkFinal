library(sf)
library(dplyr)

#read in elections results CSV
elections <- read.csv("1976-2016-president.csv", 
                      header = TRUE, sep = ",")                      

head(elections)


