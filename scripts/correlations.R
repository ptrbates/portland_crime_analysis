source('~/Projects/portland_crime_analysis/scripts/crimes_by_category.R')

library('tidyverse')
library('lubridate')

# Get a list of the offenses listed from full_df
offenses <- as.character(unique(full_df$major_offense_type))

# Find the correlation between each offense and the unemployment rate
unemp_corr <- function(df1) {
  corr_list <- c()
  corr_list <- rbind(corr_list, cor(df1$unemp_rate, df1[offenses]))  
  return(corr_list)
}

# No strong correlations between unemployment and any offenses are found
unemp_corr_list <- unemp_corr(freq_df)



# Find the correlation between each offense and the population
pop_corr <- function(df1) {
  corr_list <- c()
  corr_list <- rbind(corr_list, cor(df1$population, df1[offenses]))  
  return(corr_list)
}

# No strong correlations between unemployment and any offenses are found
pop_corr_list <- data.frame(pop_corr(freq_df_y))
pop_corr_list <- data.frame(t(pop_corr_list[,-1]))
pop_corr_list <- mutate(pop_corr_list, coefficient = t.pop_corr_list....1..)
pop_corr_list$t.pop_corr_list....1.. <- NULL

# Find the correlations between each offense and all the others
corr_df <- data.frame(round(cor(freq_df[offenses], 
                                freq_df[offenses]), 3))

# Save plot of correlation between one variable and another
corr_plot <- function(df1, var1, var2, chart_title, xlabel, ylabel) {
  r <- round(cor(df1[[var1]], df1[[var2]]), 3)
  my_plot <- ggplot(data = df1, aes(x = df1[[var1]], y = df1[[var2]])) +
    geom_point() +
    labs(title = chart_title, x = xlabel, y = ylabel) +
    ggsave(filename = paste("plots/correlations/", chart_title, ".png", sep = ""))
}


corr_plot(freq_df_y, 'Liquor Laws', 'Drugs', 
          "Figure 11:\nCorrelation Between Liquor Law and Drug Violations\nr = -.707",
          xlabel = "Liquor Law Violations", ylabel = "Drug-Related Violations")

corr_plot(freq_df_y, 'population', 'total', 
          'Figure 13:\nCorrelation Between Population and Total Crime Reports\nr = -.799',
          xlabel = "Population", ylabel = "Total Crime Reports per Year")

corr_plot(freq_df, 'unemp_rate', 'Larceny', 
          'Figure 15:\nCorrelation Between Unemployment and Larceny Reports\nr = -.382',
          xlabel = "Unemployment Rate (%)", ylabel = "Larceny Reports per Month")



# Find correlations >= .7 but not 1: those are all self-referencing
strong_corr <- corr_df[abs(round(corr_df, 3)) >= .7 & abs(corr_df) < 1]

strong_corr <- list(list('Burglary', 'Motor Vehicle Theft'), 
                    list('Trespass', 'Burglary'),
                    list('Trespass', 'Motor Vehicle Theft'), 
                    list('Larceny', 'Burglary'),
                    list('Assault, Simple', 'Trespass'),
                    list('Trespass', 'Drugs'),
                    list('Trespass', 'Fraud'),
                    list('Fraud', 'Drugs'),
                    list('Assault, Simple', 'Aggravated Assault'))

# Save a plot of each "strong" correlation to the appropriate file
corr_plot2 <- function(df1, list1) {
  for (i in 1:length(list1)) {
    var1 <- list1[[i]][[1]]
    var2 <- list1[[i]][[2]]
    r <- round(cor(df1[[var1]], df1[[var2]]), 3)
    plot_title <- paste("Correlation between", var1, "and", var2, "\nr =", r)
    file_name <- paste("plots/correlations/corr_", var1, "_", var2, 
                       ".png", sep = "")
    ggplot(data = df1, aes(x = df1[[var1]], y = df1[[var2]])) +
      geom_point(alpha = .65) +
      labs(title = plot_title) +
      xlab(var1) +
      ylab(var2) +
      ggsave(filename = file_name)
  }
}

# Call the function for each of the strongly-correlated offenses
corr_plot2(freq_df, strong_corr)

# Remove unneeded 
rm('corr_plot','corr_plot2','strong_corr','corr_df','offenses',
   'unemp_corr_list', 'unemp_corr', 'pop_corr', 'pop_corr_list')
