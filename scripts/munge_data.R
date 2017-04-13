source('~/Projects/portland_crime_analysis/scripts/import_data.R')

library('sp')
library('dplyr')
library('lubridate')

# maps_df contains only those crimes with location information
maps_df <- full_df[!is.na(full_df$x_coordinate),]

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

# create no_maps, which doesn't have location information
# then join maps_df and no_maps back together
no_maps <- full_df[is.na(full_df$x_coordinate),]
no_maps$x_coordinate <- NULL
no_maps$y_coordinate <- NULL
full_df <- rbind.fill(maps_df, no_maps)

# tidy up the unemployment data frame
unemp_df <- transmute(unemp_df, date = myd(paste(Period, Year, "01")),
                unemp_rate = `unemployment rate`)

# remove extra variables, unload packages
rm('sub_maps_df', 'latlong', 'maps_df', 'no_maps')
