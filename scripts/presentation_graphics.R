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

cor(freq_df_y$date, freq_df_y$total)



# Correlation between reports and population growth
ggplot(data = freq_df_y, aes(x = population, y = total)) +
  geom_point() +
  ylim(c(0,85000))+
  labs(x = "Population", y = NULL) +
  ggsave(filename = "plots/presentation_plots/population_vs_total.png")

cor(freq_df_y$population, freq_df_y$total)


  
# Time series for homicide reports
ggplot(data = freq_df_y, aes(x = date, y = Homicide)) +
  geom_line() +
  geom_point() +
  ylim(c(0,50))+
  labs(x = "Year", y = NULL) +
  ggsave(filename = "plots/presentation_plots/homicides_per_year.png")

mean(freq_df_y$Homicide)
sd(freq_df_y$Homicide)
cor(freq_df_y$date, freq_df_y$Homicide)



# Time series for burglary reports
ggplot(data = freq_df_y, aes(x = date, y = Burglary)) +
  geom_line() +
  geom_point() +
  ylim(0,8000) +
  labs(x = "Year", y = NULL) +
  ggsave(filename = "plots/presentation_plots/burglaries_per_year.png")

mean(freq_df_y$Burglary)
sd(freq_df_y$Burglary)
cor(freq_df_y$date, freq_df_y$Burglary)


# Time series for DUII reports
ggplot(data = freq_df_y, aes(x = date, y = DUII)) +
  geom_line() +
  geom_point() +
  ylim(c(0,3000))+
  labs(x = "Year", y = NULL) +
  ggsave(filename = "plots/presentation_plots/duii_per_year.png")

mean(freq_df_y$DUII)
sd(freq_df_y$DUII)
cor(freq_df_y$date, freq_df_y$DUII)



# Time series for Liquor Law and Drug reports
liq_drugs <- freq_df_y %>%
  select(date, `Liquor Laws`, Drugs) %>%
  gather(key = offense, value = freq, -date)

ggplot(data = liq_drugs, aes(x = date, y = freq, color = offense)) +
  geom_line() +
  geom_point() +
  ylim(c(0,5000)) +
  labs(x = "Year", y = NULL) +
  theme(legend.position = c(0.86, 0.25)) +
  theme(legend.background = element_blank()) +
  ggsave(filename = "plots/presentation_plots/liquor_drugs_per_year.png")

# Correlation between Liquor Law and Drug reports
ggplot(data = freq_df_y, aes(x = `Liquor Laws`, y = Drugs)) +
  geom_point() +
  geom_abline(slope = -0.941, intercept = 5628.873) +
  xlim(c(1500,4000)) +
  ylim(c(1500,5000)) +
  labs(x = 'Drug Offenses', y = 'Liquor Law Offenses') +
  ggsave(filename = "plots/presentation_plots/liquor_drugs_correlation.png")

lm(freq_df_y$Drugs ~ freq_df_y$`Liquor Laws`)
cor(freq_df_y$Drugs, freq_df_y$`Liquor Laws`)



# Correlation between unemployment and larceny reports
ggplot(data = freq_df, aes(x = unemp_rate, y = Larceny)) +
  geom_point() +
  xlim(c(4,11.5)) +
  ylim(c(1000,3000)) +
  labs(x = 'Unemployment Rate (%)', y = 'Larceny Reports') +
  ggsave(filename = "plots/presentation_plots/unemp_larceny_correlation.png")

cor(freq_df$unemp_rate, freq_df$Larceny)

# Look for other correlations
offenses <- as.character(unique(full_df$major_offense_type))
cor_list <- cor(freq_df$unemp_rate, freq_df[offenses])
cor_list[cor_list > 0]

# Correlation between unemployment and drugs
ggplot(data = freq_df, aes(x = unemp_rate, y = Drugs)) +
  geom_point() +
  xlim(c(4,11.5)) +
  ylim(c(0,700)) +
  labs(x = 'Unemployment Rate (%)', y = 'Drug Offenses') +
  ggsave(filename = "plots/presentation_plots/unemp_drugs_correlation.png")

cor(freq_df$unemp_rate, freq_df$Drugs)

# Correlation between unemployment and liquor laws
ggplot(data = freq_df, aes(x = unemp_rate, y = `Liquor Laws`)) +
  geom_point() +
  xlim(c(4,11.5)) +
  ylim(c(0,600)) + 
  labs(x = 'Unemployment Rate (%)', y = 'Liquor Law Offenses') +
  ggsave(filename = "plots/presentation_plots/unemp_liquor_correlation.png")

cor(freq_df$unemp_rate, freq_df$`Liquor Laws`)



# The Ferguson Effect plots

# Robbery distribution
robs <- full_df %>%
  select(report_date, major_offense_type) %>%
  filter(major_offense_type == "Robbery") %>%
  count(vars = 'report_date')

ggplot(data = robs, aes(x = freq)) +
  geom_bar() +
  labs(x = "Robberies per day", y = '') +
  scale_x_continuous(breaks = pretty_breaks()) +
  theme(legend.title = element_blank()) +
  ggsave(filename = 'plots/presentation_plots/robbery_frequency.png')
               
mean(robs$freq) 
sd(robs$freq)

# Ferguson plot   
ferg_robs1 <- robs[robs$report_date > as.Date("2014-03-18") & 
                     robs$report_date <= as.Date("2014-08-09"),]
ferg_robs1$ba <- "Before Ferguson"

ferg_robs2 <- robs[robs$report_date > as.Date("2014-08-09"),]
ferg_robs2$ba <- "After Ferguson"

ferg_robs <- rbind(ferg_robs1, ferg_robs2)

ggplot(data = ferg_robs, aes(x = freq, fill = ba)) +
  geom_bar(position = "dodge") +
  geom_vline(xintercept = 2.67) +
  geom_vline(xintercept = 2.60) +
  labs(x = "Robberies per day", y = '') +
  scale_x_continuous(breaks = pretty_breaks()) +
  theme(legend.title = element_blank()) +
  theme(legend.position = c(.81,.82)) +
  ggsave(filename = 'plots/presentation_plots/ferguson.png')

t.test(ferg_robs1$freq, ferg_robs2$freq)
sd(ferg_robs1$freq)
sd(ferg_robs2$freq)



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
