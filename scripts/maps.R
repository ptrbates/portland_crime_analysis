source('~/Projects/portland_crime_analysis/scripts/crimes_by_category.R')

library('ggmap')
library('mapproj')
library('lubridate')

# get city map from stamen
portland_map <- get_map(location = c(-122.81, 45.43, -122.47, 45.63), 
                        maptype = "terrain", source = "stamen")

map_crime <- function(df, map, chart_title, s = 1, a = 1) {
  ggmap(map) +
    geom_point(data = df, aes(x = lat, y = long),
               size = s, alpha = a) +
    labs(title = chart_title)
}

aa <- pers_df[pers_df$major_offense_type == "Robbery" & 
                year(pers_df$report_date) == 2010,]

bb <- full_df[full_df$major_offense_type == "Motor Vehicle Theft" &
                year(full_df$report_date) == 2010,]
bb$report_date <- as.factor(month(bb$report_date))

map_crime(aa, portland_map, "Robbery", s = 1, a = .4)

map_crime2 <- function(df, map, chart_title, s = 1, a = 1) {
  ggmap(map) +
    geom_point(data = df, aes(x = lat, y = long),
               size = s, alpha = a) +
    labs(title = chart_title)
}

map_crime2(bb, portland_map, "Motor Vehicle Thefts 2010", s = .75, a = .5)
