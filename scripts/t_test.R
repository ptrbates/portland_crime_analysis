library('tidyverse')

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

# Perform the F test to compare the two variances

var.test(summary_df$`Assault, Simple`, after_f$`Assault, Simple`)
var.test(summary_df$Drugs, after_f$Drugs)
var.test(summary_df$Runaway, after_f$Runaway)
var.test(summary_df$`Disorderly Conduct`, after_f$`Disorderly Conduct`)
var.test(summary_df$`Motor Vehicle Theft`, after_f$`Motor Vehicle Theft`)
var.test(summary_df$Burglary, after_f$Burglary)

# Perform the t-test on Disorderly Conduct and Motor Vehicle Theft

t.test(summary_df$`Disorderly Conduct`, after_f$`Disorderly Conduct`, alternative = "two.sided")
t.test(summary_df$`Motor Vehicle Theft`, after_f$`Motor Vehicle Theft`, alternative = "two.sided")

ggplot(data = summary_df, aes(x = `Disorderly Conduct`)) +
  geom_density() +
  geom_vline(xintercept = mean(summary_df$`Disorderly Conduct`)) +
  geom_vline(xintercept = mean(after_f$`Disorderly Conduct`)) +
  labs(title = "Frequency distribution for Disorderly Conduct") +
  xlab('Daily Occurrences') +
  scale_x_continuous(limits = c(0,30))

ggplot(data = summary_df, aes(x = `Motor Vehicle Theft`)) +
  geom_density() +
  geom_vline(xintercept = mean(summary_df$`Motor Vehicle Theft`)) +
  geom_vline(xintercept = mean(after_f$`Motor Vehicle Theft`)) +
  labs(title = "Frequency distribution for Motor Vehicle Theft") +
  xlab('Daily Occurrences')
  scale_x_continuous(limits = c(0,30))


rm('x', 'get_count', 'y')
