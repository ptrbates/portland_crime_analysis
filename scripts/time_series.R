source('~/Projects/portland_crime_analysis/scripts/crimes_by_category.R')

library('tidyverse')
library('lubridate')

# function to make the standard line graph
time_series_plot <- function(df, chart_title, category, y_label) {
  ggplot(data = df, aes(x = df$date)) +
    geom_line(aes(y = df[[category]])) +
    scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
    labs(title = chart_title, x = "Date", y = "Unemployment (%)") +
    ggsave(filename = paste("plots/lines/", chart_title, ".png", sep = ""))
}

# line graph of unemployment
time_series_plot(unemp_df, "Figure 14:\nPortland's Unemployment Rate, 2004 - 2014", "unemp_rate")


# plot line graphs
time_series_plot2 <- function(df1, chart_title) {
  aa <- plyr::count(df1, c("year(report_date)", "major_offense_type"))
  aa$year <- aa$year.report_date.
  aa$year.report_date. <- NULL
  ggplot(data = aa, aes(x = year, color = major_offense_type,
                         y = freq, group = major_offense_type)) +
    geom_line() +
    theme(legend.title=element_blank()) +
    scale_x_continuous(breaks = 
                         c(2004, 2006, 2008, 2010, 2012, 2014)) +
    labs(title = chart_title, x = "Date", y = "Count") +
    ggsave(filename = paste("plots/lines/", chart_title, ".png", sep = ""))
}

time_series_plot2(pers_df, "Figure 3:\nTrends in Personal Crimes")
time_series_plot2(short_pers, "Figure 5:\nTrends in Personal Crimes:\nLess Frequent Offenses")
time_series_plot2(prop_df, "Figure 8:\nTrends in Property Crimes")
time_series_plot2(short_prop, "Figure 9:\nTrends in Property Crimes:\nLess Frequent Offenses")
time_series_plot2(stat_df, "Figure 12:\nTrends in Statutory Crimes")


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

bb <- clean(bb)

ggplot(data = bb, aes(x = month, y = freq)) + 
  geom_line(aes(group = major_offense_type, 
                color = major_offense_type)) +
  geom_vline(xintercept = 8.29) +
  ylab("Count") +
  xlab("Date") +
  theme(legend.title=element_blank()) +
  scale_y_log10() +
  labs(title = "Figure 16:\nCrime Reports, June 2014 to December 2014") +
  ggsave(filename = "plots/lines/Figure 16:\nCrime Rates from June 2014 to December 2014.png")
  

rm('aa','bb','bb1','cc','clean','time_series_plot','time_series_plot2')
