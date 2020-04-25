# Sample way to plot

# Example of plotting our spacial data 

# install.packages(c("cowplot", "googleway", "ggplot2", "ggrepel", "ggspatial", "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata", "sf"))
library(dplyr)
library(leaflet)
library("ggplot2")
#theme_set(theme_bw())
#library("sf")
#library("rnaturalearth")
#library("rnaturalearthdata")
#library(dplyr)
#library("forcats")

#setwd("~.....")

table2 = read.table(".....csv", header=TRUE, sep=",") # takes 10 seconds
table2 <- table2[, c("Long","Lat")]
attach(table2)

table2 <- na.omit(table2)  
table2 <- subset(table2, table2$Lat>20)

set.seed(1)
location_list <- sample_n(table2, 1200) # Randomly select 1000


# -------------- Another method below ----------------------------- 

#world <- ne_countries(scale = "medium", returnclass = "sf")
#class(world)

#sites <- data.frame(longitude = c(-71.107779), latitude = c(42.325122))

#ggplot(data = world) + geom_sf() +
#  geom_point(data = sites, aes(x = longitude, y = latitude), size = 4, 
#             shape = 23, fill = "darkred") +
#   coord_sf(xlim = c(-72, -70.5), ylim = c(42, 43), expand = FALSE)
# 
# sites <- st_as_sf(sites, coords = c("longitude", "latitude"), 
#                    crs = 4326, agr = "constant")

# ggplot(data = world) +
#   geom_sf() +
#   geom_sf(data = sites, size = 4, shape = 23, fill = "darkred") +
#   coord_sf(xlim = c(-72, -70.5), ylim = c(42, 43), expand = FALSE)
# 
# bgMap = get_map(as.vector(bbox(sites)), source = "google", zoom = 13) # useless without zoom level
