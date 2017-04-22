source('~/Projects/portland_crime_analysis/scripts/crimes_by_category.R')

library('tidyverse')
library('lubridate')

overview_plot <- function(df, chart_title = '') {
  ggplot(data = df, aes(x = major_offense_type)) +
    geom_bar(aes(fill = major_offense_type)) +
    facet_wrap(~ year(report_date), nrow = 3) + 
    scale_x_discrete(labels = NULL) +
    guides(fill=guide_legend(title="Offense")) +
    labs(title = chart_title) +
    xlab(NULL) +
    ylab(NULL) +
    ggsave(filename = paste("plots/bars/", chart_title, ".png", sep = ""))
}


# Several Overview plots
overview_plot(pers_df, "Figure 1:\nOverview of Personal Crimes")
overview_plot(short_pers, "Figure 2:\nOverview of Personal Crimes:\nLess Frequent Offenses")
overview_plot(prop_df, "Figure 6:\nOverview of Property Crimes")
overview_plot(short_prop, "Figure 7:\nOverview of Property Crimes:\nLess Frequent Offenses")
overview_plot(stat_df, "Figure 10:\nOverview of Statutory Crimes")



# remove variables, unload packages

rm('overview_plot')
