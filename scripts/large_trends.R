library('tidyverse')

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


# Calculate regressions for each category
freq_df_y2 <- freq_df_y
freq_df_y2$year <- c(1:11)
coeffs <- data.frame(coefficients(lm(formula = as.matrix(freq_df_y2[,3:29]) ~ 
                                       freq_df_y2$year))) 
coeffs <- data.frame(t(coeffs))
coeffs <- mutate(coeffs, intercept = X.Intercept., slope = freq_df_y2.year)
coeffs$X.Intercept. <- NULL
coeffs$freq_df_y2.year <- NULL

# Define the plotting function
corr_with_lm <- function(df1, var1) {
  ggplot(data = df1, aes(x = year, y = df1[[var1]])) +
    geom_point() +
    geom_abline(slope = coeffs[var1, 'slope'], 
                intercept = coeffs[var1, 'intercept']) +
    labs(title = paste("Reports of", var1, "with Regression Line,\nSlope =",
                       round(coeffs[var1, 'slope'], 3)), 
                       x = "Year", y = paste("Reports of", var1)) +
    scale_x_continuous(breaks = df1$year, labels = c(2004:2014))
  
}



corr_with_lm(freq_df_y2, "Robbery")




# Remove unnecessary functions and variables

rm('offense_change', 'pop_corr', 'simple_regression', 'offenses', 'corr_with_lm')