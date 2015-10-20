library(dplyr)

# read tidy data
stations <- read.csv("data/station_locations.csv")
spills <- read.csv("data/sortedspills_ny2.csv")
metals <- read.csv("data/hurricane_metals.csv")
wastewater <- read.csv("data/table19-final-maybe-for-real-this-time.txt", sep = "\t")

# friendlier column name
stations <- dplyr::rename(stations, Lat = Latitude..decimal.degrees., Long = Longitude..decimal.degrees.)

# get list for drop downs
metals.list <- names(metals)[9:31]
wastewater.list <- sort(names(select(wastewater, -ends_with("Qualifier"), -Sample.time, -Sample.date, -Map.location.number) ))

# join wastewater with stations to get lat/lon
wasterwater <- inner_join(x = wastewater, y = stations, by = c("Site.code" = "Site.code"))
wastewater <- dplyr::rename(wasterwater, Location.Name = USGS.site.name)


#metals <- inner_join(x =  metals, y = stations, by = c("Site.code" = "Site.code"))