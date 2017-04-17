source('~/Projects/portland_crime_analysis/scripts/crimes_by_category.R')

library('ggplot2')
library('plyr')
library('lubridate')

# function to make the standard line graph
time_series_plot <- function(df, chart_title, category, y_label) {
  ggplot(data = df, aes(x = df$date, y = df[[category]])) +
    geom_line() +
    ylab(y_label) +
    xlab("Date") +
    scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
    labs(title = chart_title)
}

# line graph of unemployment
time_series_plot(unemp_df, "Unemployment Rate", "unemp_rate", 
         "Unemployment Rate (%)")


# plot line graphs
time_series_plot2 <- function(df1, chart_title) {
  aa <- plyr::count(df1, c("year(report_date)", "major_offense_type"))
  aa$year <- aa$year.report_date.
  aa$year.report_date. <- NULL
  
  ggplot(data = aa, aes(x = year, color = major_offense_type,
                         y = freq, group = major_offense_type)) +
    geom_line() +
    ylab("Count") +
    xlab("Date") +
    scale_x_continuous(breaks = 
                         c(2004, 2006, 2008, 2010, 2012, 2014)) +
    labs(title = chart_title) 
}

time_series_plot2(short_prop, "Property Crimes:\nLess Frequent")
time_series_plot2(short_pers, "Personal Crimes:\nLess Frequent")
time_series_plot2(pers_df, "Personal Crimes")
time_series_plot2(prop_df, "Property Crimes")
time_series_plot2(stat_df, "Statutory Crimes")


# investigate the "Ferguson Effect"

aa <- plyr::count(pers_df[year(pers_df$report_date) == 2014,], 
                  c("month(report_date)", "major_offense_type"))
bb <- plyr::count(prop_df[year(pers_df$report_date) == 2014,], 
                  c("month(report_date)", "major_offense_type"))
cc <- plyr::count(stat_df[year(pers_df$report_date) == 2014,], 
                  c("month(report_date)", "major_offense_type"))

clean <- function(df1) {
  df1$month <- df1$month.report_date.
  df1$month.report_date. <- NULL
  df1 <- filter(df1, month >= 6)
}

aa <- clean(aa)
bb <- clean(bb)
cc <- clean(cc)

bb1 <- bb[bb$major_offense_type != "Larceny",]

ggplot(data = bb, aes(x = month, y = freq)) + 
  geom_line(aes(group = major_offense_type, 
                color = major_offense_type)) +
  ylab("Count") +
  xlab("Date") +
  scale_y_log10() +
  labs(title = "Crime Rates from June 2014 to December 2014")
  
