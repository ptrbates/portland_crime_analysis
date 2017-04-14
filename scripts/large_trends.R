library('dplyr')
library('tidyr')

# Calculate percentage change from 2004 to 2014
offense_change <- function(df1) {

  # Group the data by year and offense type
  aa <- plyr::count(df1, c("year(report_date)", "major_offense_type"))
  aa$year <- aa$year.report_date.
  aa$year.report_date. <- NULL
  
  # Modify the data frame so that each offense is on one row
  aa <- aa %>%
    filter(year == 2004 | year == 2014) %>%
    spread(key = year, value = freq)
  
  # Calculate the percentage change from 2004 to 2014
  return(paste(aa$major_offense_type, ": ", 
               (round(100 * (aa$`2014` - aa$`2004`) / aa$`2004`, 
                      digits = 1)),
               sep=""))

}

offense_change(pers_df)
offense_change(short_pers)
offense_change(prop_df)
offense_change(short_prop)
offense_change(stat_df)