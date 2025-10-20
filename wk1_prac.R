# 读取shp文件并展示图片
library(sf)
shape <- st_read("C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\statistical-gis-boundaries-london\\ESRI\\London_Borough_Excluding_MHW.shp")
summary(shape)
plot(shape)

# 读取csv文件并查看文件
library(tidyverse)
mycsv <- read_csv("C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\fly_tipping.csv")  
mycsv

# 把表格合并到shp文件
shape2 <- shape%>%
  merge(.,
        mycsv,
        by.x="GSS_CODE", 
        by.y="row_labels")

# 展示合并后的表格的前十行
shape%>%
  head(., n=10)

# 制作专题地图
library(tmap)
tmap_mode("plot")
shape2 %>%
  qtm(.,fill = "2012-13")

# 将形状写入新的GeoPackage，并设置图层名称。（设置delete_layer为 true，以便在开发此实用程序时可以覆盖我的图层）
shape %>%
  st_write(.,"C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\Rwk1.gpkg",
           "london_boroughs_fly_tipping",
           delete_layer=TRUE)

# 用制作好的shp文件做csv文件
library(readr)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(),dbname="C:\\Users\\Ryan Tedder\\CASA\\GIS\\prac2\\Rwk1.gpkg")
con %>%
  dbListTables()
con %>%
  dbWriteTable(.,
               "original_csv",
               mycsv,
               overwrite=TRUE)

con %>% 
  dbDisconnect()
