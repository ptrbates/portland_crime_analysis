library('lubridate')

get_count <- function(df1) {
  return(data.frame("date" = ymd(paste(year(df1$report_date), "-",
                                       month(df1$report_date), "-01")),
                    "major_offense_type" = df1$major_offense_type) %>%
           plyr::count(c("date", "major_offense_type"))
  )
}

aa <- get_count(prop_df)

bb <- merge(aa, unemp_df)

cc <- bb[bb$major_offense_type == "Larceny",]

cor(cc$unemp_rate, cc$freq)

ggplot(data = bb[bb$major_offense_type == "Burglary",], 
       aes(x = unemp_rate, y = freq)) +
  geom_point()
