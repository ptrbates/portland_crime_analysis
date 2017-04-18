library('lubridate')
library('tidyverse')

get_count <- function(df1) {
  return(data.frame("date" = ymd(paste(year(df1$report_date), "-",
                                       month(df1$report_date), "-01")),
                    "major_offense_type" = df1$major_offense_type) %>%
           plyr::count(c("date", "major_offense_type"))
  )
}

aa <- full_df %>%
  get_count() %>%
  merge(unemp_df) %>%
  spread(key = major_offense_type, value = freq)

aa[is.na(aa)] <- 0

offenses <- as.character(unique(full_df$major_offense_type))

corr_df <- data.frame(round(cor(aa[offenses], aa[offenses]), 3))

strong_corr <- corr_df[abs(round(corr_df, 3)) >= .7 & abs(corr_df) < 1]

corr_plot <- function(df1, var1, var2) {
  r <- round(cor(df1[[var1]], df1[[var2]]), 3)
  plot_title <- paste("Correlation between", var1, "and", var2, "\nr =", r)
  file_name <- paste("plots/correlations/corr_", var1, "_", var2, 
                     ".png", sep = "")
  my_plot <- ggplot(data = df1, aes(x = df1[[var1]], y = df1[[var2]])) +
    geom_point() +
    labs(title = plot_title) +
    xlab(var1) +
    ylab(var2) +
    ggsave(filename = file_name)
}

strong_corr <- list(list('Burglary', 'Motor Vehicle Theft'), 
                    list('Trespass', 'Burglary'),
                    list('Trespass', 'Motor Vehicle Theft'), 
                    list('Larceny', 'Burglary'),
                    list('Assault, Simple', 'Trespass'),
                    list('Trespass', 'Drugs'),
                    list('Trespass', 'Fraud'),
                    list('Fraud', 'Drugs'),
                    list('Assault, Simple', 'Aggravated Assault'))

corr_plot2 <- function(df1, list1) {
  for (i in 1:length(list1)) {
    var1 <- list1[[i]][[1]]
    var2 <- list1[[i]][[2]]
    plot_title <- paste("Correlation between", var1, "and", var2, "\nr =")
    file_name <- paste("plots/correlations/corr_", var1, "_", var2, 
                       ".png", sep = "")
    r <- round(cor(df1[[var1]], df1[[var2]]), 3)
    my_plot <- ggplot(data = df1, aes(x = df1[[var1]], y = df1[[var2]])) +
      geom_point() +
      labs(title = plot_title) +
      xlab(var1) +
      ylab(var2) +
      ggsave(filename = file_name)
  }
}

corr_plot2(aa, strong_corr)