source('~/Projects/portland_crime_analysis/scripts/munge_data.R')

# Get a list of the offenses listed from full_df
offenses <- as.character(unique(full_df$major_offense_type))

# Histograms for various offenses
plot_hist <- function(df1, list1) {
  for (i in 1:length(list1)) {
    var1 <- list1[[i]]
    plot_title <- paste("Monthly frequency distribution for", var1)
    file_name <- paste("plots/histograms/hist_", var1, ".png", sep = "")
    ggplot(data = df1, aes(x = df1[var1])) +
      geom_histogram() +
      scale_x_continuous() +
      geom_vline(xintercept = mean(df1[[var1]])) +
      labs(title = plot_title) +
      xlab(var1) +
      ggsave(filename = file_name)
  }
}

plot_hist(freq_df, offenses)
