library('ggmap')
library('mapproj')
library('ggplot2')

# get city map from google
portland_map <- get_map(location = c(lon = -122.6549420, 
                                     lat = 45.5390863), 
                        maptype = "terrain", zoom = 12)

ggmap(portland_map, xlim = c(-122.8454699, -122.4636521), 
      ylim = c(45.4256013, 45.6522505), maprange = FALSE) +
  geom_point(data = maps_df, aes(x = lat, y = long), 
             size = 0.1,alpha = 0.01)
