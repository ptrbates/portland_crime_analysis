library('tidyverse')
library('lubridate')

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# Time series for total crime reports
ggplot(data = freq_df_y, aes(x = date, y = total)) +
  geom_line() +
  geom_point() +
  ylim(c(0,85000))+
  labs(x = "Year", y = NULL) +
  ggsave(filename = "plots/presentation_plots/reports_per_year.png")

# Time series for homicide reports
ggplot(data = freq_df_y, aes(x = date, y = Homicide)) +
  geom_line() +
  geom_point() +
  ylim(c(0,50))+
  labs(x = "Year", y = NULL) +
  ggsave(filename = "plots/presentation_plots/homicides_per_year.png")

mean(freq_df_y$Homicide)
sd(freq_df_y$Homicide)

# Time series for burglary reports
ggplot(data = freq_df_y, aes(x = date, y = Burglary)) +
  geom_line() +
  geom_point() +
  ylim(0,8000) +
  labs(x = "Year", y = NULL) +
  ggsave(filename = "plots/presentation_plots/burglaries_per_year.png")

mean(freq_df_y$Burglary)
sd(freq_df_y$Burglary)

# Time series for DUII reports
ggplot(data = freq_df_y, aes(x = date, y = DUII)) +
  geom_line() +
  geom_point() +
  ylim(c(0,3000))+
  labs(x = "Year", y = NULL) +
  ggsave(filename = "plots/presentation_plots/duii_per_year.png")

mean(freq_df_y$DUII)
sd(freq_df_y$DUII)

# Time series for Liquor Law and Drug reports
ggplot(data = freq_df_y) +
  geom_line(aes(x = date, y = Drugs), color = 'dark blue') +
  geom_point(aes(x = date, y = Drugs)) +
  geom_line(aes(x = date, y = `Liquor Laws`), color = 'dark red') +
  geom_point(aes(x = date, y = `Liquor Laws`)) +
  ylim(c(0,5000))+
  labs(x = "Year", y = NULL) +
  ggsave(filename = "plots/presentation_plots/liquor_drugs_per_year.png")

# Correlation between Liquor Law and Drug reports
ggplot(data = freq_df_y, aes(x = `Liquor Laws`, y = Drugs)) +
  geom_point() +
  xlim(c(1500,4000)) +
  ylim(c(1500,5000)) +
  labs(x = 'Drug Offenses', y = 'Liquor Law Offenses') +
  ggsave(filename = "plots/presentation_plots/liquor_drugs_correlation.png")

cor(freq_df_y$Drugs, freq_df_y$`Liquor Laws`)

# Correlation between population and total reports
ggplot(data = freq_df_y, aes(x = population, y = total)) +
  geom_point() +
  xlim(c(525000,625000)) +
  ylim(c(0,90000)) +
  labs(x = 'Population', y = 'Crime Reports') +
  ggsave(filename = "plots/presentation_plots/population_total_correlation.png")

cor(freq_df_y$population, freq_df_y$total)

# Correlation between unemployment and larceny reports
ggplot(data = freq_df, aes(x = unemp_rate, y = Larceny)) +
  geom_point() +
  xlim(c(4,11.5)) +
  ylim(c(1000,3000)) +
  labs(x = 'Unemployment Rate (%)', y = 'Larceny Reports') +
  ggsave(filename = "plots/presentation_plots/unemp_larceny_correlation.png")

cor(freq_df$unemp_rate, freq_df$Larceny)

# The Ferguson Effect plot
ggplot(data = complete, aes(x = Robbery, fill = d)) +
  geom_bar(position = "dodge") +
  geom_vline(xintercept = mean(summary_df$Robbery)) +
  geom_vline(xintercept = mean(after_f$Robbery)) +
  labs(x = "Robberies per day", y = "Frequency") +
  scale_x_continuous(breaks = pretty_breaks(9)) +
  theme(legend.title = element_blank()) +
  ggsave(filename = 'plots/presentation_plots/ferguson.png')

t.test(summary_df$Robbery, after_f$Robbery)

# Effects of neighborhood racial demographics

ggplot(data = seg_df) +
  geom_point(aes(x = 100*percent_white, y = robbery_count_2010, 
                 color = "White"), alpha = 0.5) +
  geom_point(aes(x = 100*percent_black_aa, y = robbery_count_2010, 
                 color = "Black or\nAfrican American"), alpha = 0.5) +
  geom_point(aes(x = 100*percent_not_white, y = robbery_count_2010, 
                 color = "Not White"), alpha = 0.5) +
  scale_color_manual("", breaks = c("White", "Black or\nAfrican American", 
                                    "Not White"),
                     values = c("dark red", "dark blue", "dark green")) +
  xlim(c(0,100)) +
  labs(x = "Percent", y = "Robberies in 2010") +
  ggsave(filename = "plots/presentation_plots/segregation_analysis.png")
