library(leaflet)
library(dplyr)

# read tidy data
stations <- read.csv("data/station_locations.csv")
spills <- read.csv("data/sortedspills_ny2.csv")
metals <- read.csv("data/hurricane_metals.csv")
wastewater <- read.csv("data/table19-final-maybe-for-real-this-time.txt", sep = "\t")

stations <- dplyr::rename(stations, lat = Latitude..decimal.degrees., long = Longitude..decimal.degrees.)
#stations <- dplyr::rename(stations, lat = Latitude, long = Longitude) 

leaflet(stations) %>% addTiles() %>% addMarkers(popup = ~Site.code)

colorData <- metals[["Aluminum"]]
pal <- colorBin("Spectral", colorData, 7, pretty = FALSE)
myPopup <- paste(metals$Location.Name, "<BR>", "Aluminum:", metals$Aluminum)
leaflet(metals) %>% addTiles() %>% addCircles(popup = ~Location.Name)

leaflet(metals) %>% addTiles() %>% addCircles(popup = myPopup, radius = 1000, color = pal(colorData), fillOpacity = 0.4) %>% addLegend("bottomright", pal = pal, values = colorData, title = "Aluminum (mg/kb)")

leaflet(Andrew) %>% 
  addTiles() %>% 
  addCircles(~Long, ~Lat, radius = radius, popup = ~Tip, fillColor = pal(colorData), color = pal(colorData), fillOpacity = 0.4) %>% 
  addLegend("bottomleft", pal = pal, values = colorData, title = "Category")