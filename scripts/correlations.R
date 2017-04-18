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

corr_vec <- cor(aa$unemp_rate, aa[offenses])
weak_corr <- corr_vec[abs(corr_vec) < .3]
mod_corr <- corr_vec[abs(corr_vec) > .3]



