library(sf)
library(tmap) 
library(tmaptools)
library(RSQLite)
library(tidyverse)

#read in the shapefile
shape <- st_read(
  "C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\territorial-authority-2018-generalised.shp")
# read in the csv
mycsv <- read_csv(
  "C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\paid_employee.csv")  
# merge csv and shapefile
shape <- shape%>%
  merge(.,
        mycsv,
        by.x="TA2018_V1_", 
        by.y="Area_Code")
# set tmap to plot
tmap_mode("plot")
# have a look at the map
qtm(shape, fill = "Paid employee")
# write to a .gpkg
shape %>%
  st_write(.,"C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\Rwk1_housework.gpkg",
           "new_zealand_paid_employee",
           delete_layer=TRUE)
# connect to the .gpkg
con <- dbConnect(SQLite(),dbname="C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\Rwk1_housework.gpkg")
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