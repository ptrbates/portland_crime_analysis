source('~/Projects/portland_crime_analysis/scripts/crimes_by_category.R')

library('ggmap')
library('mapproj')
library('lubridate')

# get city map from stamen
portland_map <- get_map(location = c(-122.81, 45.43, -122.47, 45.63), 
                        maptype = "terrain", source = "stamen")

rhg_cols <- c("#771C19", "#AA3929", "#E25033", "#F27314", "#F8A31B", 
              "#E2C59F", "#B6C5CC", "#8E9CA3", "#556670", "#000000")

map_crime <- function(df, map, chart_title, s = 1, a = 1) {
  ggmap(map) +
    geom_point(data = df, aes(x = lat, y = long, color = factor(year(report_date))),
               size = s, alpha = a) +
<<<<<<< HEAD
    labs(title = chart_title) + 
    theme(legend.title = element_blank()) +
    theme(axis.title = element_blank()) +
    theme(axis.text = element_blank()) +
=======
    labs(title = chart_title, x = NULL, y = NULL) + 
>>>>>>> cb4af94c1251dd64a342df6c4f92d30c2bcf3440
    scale_fill_manual(values = rhg_cols, name = "Year") +
    theme(legend.title=element_blank()) +
    ggsave(filename = paste("plots/maps/", chart_title, ".png", sep = ""))
    
}

cc <- pers_df[pers_df$major_offense_type == "Homicide",]
dd <- prop_df[prop_df$major_offense_type == "Motor Vehicle Theft",]

map_crime(cc, portland_map, "Figure 19:\nGeographic Distribution of Homicides, 2004 - 2014")
map_crime(dd, portland_map, "Figure 20:\nGeographic Distribution of Motor Vehicle Theft, 2004 - 2014", 
          a=.25, s=.6)

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
