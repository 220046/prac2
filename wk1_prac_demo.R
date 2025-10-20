library(sf)
library(tmap) 
library(tmaptools)
library(RSQLite)
library(tidyverse)

#read in the shapefile
shape <- st_read(
  "C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\statistical-gis-boundaries-london\\ESRI\\London_Borough_Excluding_MHW.shp")
# read in the csv
mycsv <- read_csv("C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\fly_tipping.csv")  
# merge csv and shapefile
shape <- shape%>%
  merge(.,
        mycsv,
        by.x="GSS_CODE", 
        by.y="Row Labels")
# set tmap to plot
tmap_mode("plot")
# have a look at the map
qtm(shape, fill = "2011_12")
# write to a .gpkg
shape %>%
  st_write(.,"C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\Rwk1.gpkg",
           "london_boroughs_fly_tipping",
           delete_layer=TRUE)
# connect to the .gpkg
con <- dbConnect(SQLite(),dbname="C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\Rwk1.gpkg")
# list what is in it
con %>%
  dbListTables()
# add the original .csv
con %>%
  dbWriteTable(.,
               "original_csv",
               mycsv,
               overwrite=TRUE)
# disconnect from it
con %>% 
  dbDisconnect()