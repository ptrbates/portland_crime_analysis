source('~/Projects/portland_crime_analysis/scripts/import_data.R')

library('sp')
library('tidyverse')
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

# Construct the frequency data frame

# Find the monthly frequency of each offense
get_count <- function(df1) {
  return(data.frame("date" = ymd(paste(year(df1$report_date), "-",
                                       month(df1$report_date), "-01")),
                    "major_offense_type" = df1$major_offense_type) %>%
           plyr::count(c("date", "major_offense_type"))
  )
}

# Complie the frequencies into one df, with unemployment included
freq_df <- full_df %>%
  get_count() %>%
  merge(unemp_df) %>%
  spread(key = major_offense_type, value = freq)

# Fill in NA with 0 (no offenses of that type for that period)
freq_df[is.na(freq_df)] <- 0


# remove extra variables, unload packages
rm('sub_maps_df', 'latlong', 'maps_df', 'no_maps', 'get_count')
