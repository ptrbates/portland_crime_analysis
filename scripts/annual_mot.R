library('tidyverse')

ggplot(data = df1) +
  geom_bar(mapping = aes(x = major_offense_type))
