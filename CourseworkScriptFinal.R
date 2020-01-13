library(sf)
library(dplyr)
library(tmap)

#read in elections results CSV
elections <- read.csv("1976-2016-president.csv", 
                      header = TRUE, sep = ",")                      
head(elections)
class(elections)

#check columns have been read in correctly
datatypelist <- data.frame(cbind(lapply(elections,class)))
datatypelist


#get all elections for 2016
elections2016 <- elections [grep("2016",elections[,1]),]

#check
head(elections2016)
nrow(elections2016)

colnames(elections2016)

#pick out just the number of votes for Trump in the 2016 election
trumpvotes <- elections2016 %>% group_by(state) %>% filter(candidate=="Trump, Donald J.")

#check 
head(trumpvotes)
colnames(trumpvotes)

#create a new column to calculate the % of votes Trump received in each state
trumpvotes$percenttrump <-  trumpvotes$candidatevotes/trumpvotes$totalvotes*100

#check
colnames(trumpvotes)
trumpvotes$percenttrump
class(trumpvotes)

#read in shapefile for US States
States <- st_read("states_21basic/states.shp")

States

#current projection is an unknown EPSG so project into WGS84 (preferred CRS) 
statesWGS84 <- st_transform(States, 4326)

statesWGS84


#check
tmap_mode("view")
qtm(statesWGS84)

#join Trump votes and states on the states names columns 
colnames(statesWGS84)
colnames(trumpvotes)

trumpmap2016 <- merge(statesWGS84, 
                      trumpvotes, 
                      by.x="STATE_NAME",
                      by.y="state", 
                      no.dups= TRUE)

#check all working and plotting correctly 
nrow(trumpmap2016)
class(trumpmap2016)

tmap_mode("view")
tm_shape(trumpmap2016) +
  tm_polygons("percenttrump",
              style="cont",
              midpoint=NA,
              title="% vote for trump")
















