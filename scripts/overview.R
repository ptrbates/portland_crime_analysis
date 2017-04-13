source('~/Projects/portland_crime_analysis/scripts/crimes_by_category.R')

library('ggplot2')

overview_plot <- function(df, chart_title = '') {
  ggplot(data = df, aes(x = major_offense_type)) +
    geom_bar(aes(fill = major_offense_type)) +
    facet_wrap(~ year(report_date), nrow = 3) + 
    scale_x_discrete(labels = NULL) +
    guides(fill=guide_legend(title="Offense")) +
    labs(title = chart_title) +
    xlab(NULL) +
    ylab(NULL)
}


# Several Overview plots
overview_plot(pers_df, "Personal Crimes:\nOverview")
overview_plot(short_pers, "Personal Crimes:\nLess Frequent")
overview_plot(prop_df, "Property Crimes:\nOverview")
overview_plot(short_prop, "Property Crimes:\nLess Frequent")
overview_plot(stat_df, "Statutory Crimes")



# remove variables, unload packages

rm('overview_plot')
