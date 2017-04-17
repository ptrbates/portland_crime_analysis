source('~/Projects/portland_crime_analysis/scripts/crimes_by_category.R')

library('ggmap')
library('mapproj')

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
bb <- full_df[full_df$major_offense_type == "Homicide",]
bb$report_date <- as.factor(year(bb$report_date))

map_crime(aa, portland_map, "Robbery", s = 1, a = .4)

map_crime2 <- function(df, map, chart_title, s = 1, a = 1) {
  ggmap(map) +
    geom_point(data = df, aes(x = lat, y = long, 
                              color = report_date),
               size = s, alpha = a) +
    labs(title = chart_title)
}

map_crime2(bb, portland_map, "Homicides 2004-2014", s = 2, a = .7)
