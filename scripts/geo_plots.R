source('~/Projects/portland_crime_analysis/scripts/crimes_by_category.R')

library('ggmap')
library('mapproj')

# get city map from stamen
portland_map <- get_map(location = c(-122.81, 45.43, -122.47, 45.63), 
                        maptype = "terrain", source = "stamen")

map_crime <- function(df, map) {
  ggmap(map) +
    geom_point(data = df, aes(x = lat, y = long, 
                              color = major_offense_type),
               size = .5, alpha = .5)
}

map_crime(short_pers, portland_map)
