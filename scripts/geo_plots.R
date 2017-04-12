library('ggmap')
library('mapproj')
library('lubridate')

# get city map from stamen
portland_map <- get_map(location = c(-122.81, 45.43, -122.47, 45.63), 
                        maptype = "terrain", source = "stamen")

ggmap(portland_map) +
  geom_point(data = maps_df[year(maps_df$report_date) == 2004,], 
             aes(x = lat, y = long, color = major_offense_type), 
             size = .1, alpha = .1)

df2 <- maps_df[maps_df$major_offense_type == "Arson",]

df2[year(df2$report_date) == 2004,]
