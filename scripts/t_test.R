library('tidyverse')
library('lubridate')
library('scales')

# Create the summary dataframe for the entire time span
# Find the monthly frequency of each offense
get_count <- function(df1) {
  return(data.frame("date" = df1$report_date,
                    "major_offense_type" = df1$major_offense_type) %>%
           plyr::count(c("date", "major_offense_type"))
  )
}

# Complie the frequencies into one df, with unemployment included
freq_df2 <- full_df %>%
  get_count() %>%
  spread(key = major_offense_type, value = freq)

# Fill in NA with 0 (no offenses of that type for that period)
freq_df2[is.na(freq_df2)] <- 0

# Test each offense for a normal distribution using the Shapiro-Wilk test

shap_df <- freq_df2
shap_df$date <- NULL
shap_df <- data.frame(sapply(shap_df, shapiro.test))
shap_df <- data.frame(t(shap_df[,-1]))
shap_df$method <- NULL
shap_df$data.name <- NULL
norm_offs <- shap_df[shap_df$statistic > .95,]

file_name <- "plots/histograms/Figure 17:\nFrequency Distribution for Robbery Reports, 2004 - 2014.png"

ggplot(data = freq_df2, aes(x = Robbery)) +
  geom_bar() +
  labs(title = "Figure 17:\nFrequency Distribution for Robbery Reports, 2004 - 2014", 
       x = "Daily Robbery Occurrences") +
  ggsave(filename = file_name)

# Summarize the mean and sd for each offense for the entire time period

summary_df <- freq_df2
summary_df$date <- NULL
summary_df$unemp_rate <- NULL
summary_df2 <- data.frame(sapply(summary_df, mean), 
                         sapply(summary_df, sd))
x <- rownames(summary_df2)
summary_df2 <- transmute(summary_df2, offense = x,
                        mean = sapply.summary_df..mean.,
                        sd = sapply.summary_df..sd.)


# Create the summary date frame for the events after 8/9/2014

after_f <- freq_df2[freq_df2$date >= ymd("2014-08-09"),]

after_f$date <- NULL
after_f2 <- data.frame(sapply(after_f, mean),
                      sapply(after_f, sd))
x <- rownames(after_f2)
after_f2 <- transmute(after_f2, offense = x,
                      mean = sapply.after_f..mean.,
                      sd = sapply.after_f..sd.)

# Perform the t-test on Robbery

t.test(summary_df$Robbery, after_f$Robbery, 
       alternative = "two.sided")

ggplot(data = summary_df, aes(x = Robbery)) +
  geom_bar() +
  geom_vline(xintercept = mean(summary_df$Robbery), color = 'red') +
  geom_vline(xintercept = mean(after_f$Robbery), color = 'blue') +
  labs(title = "Figure 18:\nFrequency Distribution for Robbery Reports, 2004 - 2014
       \tRed Line: Overall Mean\n\tBlue Line: Post-Ferguson Mean") +
  xlab('Daily Robbery Occurrences') +
  ggsave(filename = file_name)
  
# Perform the Wilcoxon Signed-Rank test

wilcox.test(summary_df$Robbery, after_f$Robbery)






# Alternate method: only consider the four months before Ferguson and the four months after
# Summarize the mean and sd for each offense for the entire time period

summary_df <- freq_df2[freq_df2$date <= ymd("2014-08-09") & 
                         freq_df2$date >= ymd("2014-03-18"),]
summary_df$date <- NULL
summary_df$unemp_rate <- NULL
summary_df$d <- "Before Ferguson"

# Create df to show means and sds for each offense
summary_df2 <- data.frame(sapply(summary_df, mean), 
                          sapply(summary_df, sd))
x <- rownames(summary_df2)
summary_df2 <- transmute(summary_df2, offense = x,
                         mean = sapply.summary_df..mean.,
                         sd = sapply.summary_df..sd.)


# Create the summary date frame for the events after 8/9/2014

after_f <- freq_df2[freq_df2$date >= ymd("2014-08-09"),]

after_f$date <- NULL
after_f$d <- "After Ferguson"

# Create df to show means and sds for each offense
after_f2 <- data.frame(sapply(after_f, mean),
                       sapply(after_f, sd))
x <- rownames(after_f2)
after_f2 <- transmute(after_f2, offense = x,
                      mean = sapply.after_f..mean.,
                      sd = sapply.after_f..sd.)

# Rbind the summary and after_f dfs
complete <- rbind(summary_df, after_f)

# Perform the t-test on Robbery

t.test(summary_df$Robbery, after_f$Robbery, 
       alternative = "two.sided")

file_name <- "plots/histograms/Figure 18:\nFrequency Distribution for Robbery Reports, 2004 - 2014\nMeans Included.png"


ggplot(data = complete, aes(x = Robbery, fill = d)) +
  geom_bar(position = "dodge") +
  geom_vline(xintercept = mean(summary_df$Robbery)) +
  geom_vline(xintercept = mean(after_f$Robbery)) +
  labs(title = "Figure 18:\nFrequency Distribution for Robbery Reports",
       x = "Robberies per Day")+
  scale_x_continuous(breaks = pretty_breaks(10)) +
  theme(legend.title = element_blank()) +
  ggsave(filename = file_name)

# Perform the Wilcoxon Signed-Rank test

wilcox.test(summary_df$Robbery, after_f$Robbery)


rm('x', 'get_count', 'y')
