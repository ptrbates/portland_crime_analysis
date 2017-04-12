library('dplyr')
library('sp')

# maps_df contains only those crimes with location information
maps_df <- select(df1, report_date, major_offense_type, x_coordinate, y_coordinate)
maps_df <- maps_df[!is.na(df1$x_coordinate),]

# convert state-plane coordinates to lat/long
sub_maps_df <- data.frame(x = maps_df$x_coordinate, 
                          y = maps_df$y_coordinate)
coordinates(sub_maps_df) <- ~ x + y
proj4string(sub_maps_df) <- CRS("+init=epsg:2269")
latlong = data.frame(spTransform(sub_maps_df, CRS("+init=epsg:4326")))
maps_df['lat'] = latlong['x']
maps_df['long'] = latlong['y']
maps_df$x_coordinate <- NULL
maps_df$y_coordinate <- NULL


# remove extra variables, unload packages

rm('sub_maps_df', 'latlong')

detach('package:dplyr', unload = TRUE)