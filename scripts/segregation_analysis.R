library('lubridate')

# Construct a data frame of robbery offenses in 2010 by neighborhood
aa <- full_df %>%
  select(report_date, major_offense_type, neighborhood) %>%
  filter(major_offense_type == "Robbery" & year(report_date) == 2010) %>%
  count(c("neighborhood", "major_offense_type")) %>%
  mutate(neighborhood = as.character(neighborhood))

# Modify certain PPB neighborhood names to math with census names

aa[1,1] <- nei_df[49,1]
aa[36,1] <- nei_df[3,1]
aa[37,1] <- nei_df[8,1]
aa[45,1] <- nei_df[10,1]
aa[9,3] <- sum(aa[9,3], aa[22,3])
aa[9,1] <- nei_df[14,1]
aa[3,1] <- nei_df[63,1]
aa[30,1] <- nei_df[19,1]
aa[16,1] <- nei_df[23,1]
aa[10,1] <- nei_df[40,1]
aa[51,1] <- nei_df[56,1]
aa[48,1] <- nei_df[57,1]
aa[24,1] <- nei_df[60,1]
aa[79,1] <- nei_df[61,1]
aa[33,1] <- nei_df[62,1]
aa[59,1] <- nei_df[66,1]
aa[55,1] <- nei_df[71,1]
aa[15,1] <- nei_df[78,1]
aa[73,1] <- nei_df[83,1]
aa[21,1] <- nei_df[84,1]
aa[42,1] <- nei_df[91,1]


# Join the robbery offense data frame with the neighborhood demographic df
seg_df <- join(nei_df, aa, by = "neighborhood", type = "full")

# Delete extra rows
ex_rows <- c(96, 97, 98, 99)
seg_df <- seg_df[-ex_rows,]

# Fill in values for neighborhoods with no robberies, adjust columns
seg_df$major_offense_type <- NULL
seg_df$freq[is.na(seg_df$freq)] <- 0  
seg_df <- rename(seg_df, c("freq" = "robbery_count_2010"))

# Calculate percent of white and black_aa in each neighborhood
seg_df <- mutate(seg_df, percent_black_aa = black_aa / total_pop,
                 percent_white = white / total_pop,
                 percent_diverse = 
                   (black_aa + AIAN + asian + NHOPI + other) / total_pop)

# Calculate the correlation and plot the scatter plot for each
seg_corr <- function(var1) {
  r = round(cor(seg_df[[var1]], seg_df$robbery_count_2010), 3)
  ggplot(data = seg_df, aes(x = seg_df[[var1]], y = robbery_count_2010)) +
    geom_point(alpha = .75) +
    xlim(c(0,1)) +
    labs(title = paste("Correlation between Robbery and ", 
                       var1, "\nr = ", r, sep = ''), x = var1, y = "Robberies") +
    ggsave(filename = paste("plots/correlations/corr_", var1, "_robbery.png",
                            sep = ""))
}

seg_corr('percent_diverse')
seg_corr('percent_black_aa')
seg_corr('percent_white')

# Remove extraneous variables
rm('aa', 'ex_rows', 'seg_corr')
