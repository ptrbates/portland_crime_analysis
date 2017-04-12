source('~/Projects/portland_crime_analysis/scripts/munge_data.R')

# list of property crimes
property = c("Larceny", "Trespass", "Fraud", "Burglary", "Vandalism",
             "Motor Vehicle Theft", "Robbery", "Forgery",
             "Stolen Property", "Embezzlement", "Arson")

# list of statutory crimes
statutory = c("DUII", "Curfew", "Gambling", "Disorderly Conduct",
              "Liquor Laws", "Drugs", "Weapons", "Prostitution",
              "Runaway")

# list of personal crimes
personal = c("Assault, Simple", "Homicide", "Rape", "Robbery", 
             "Aggravated Assault", "Kidnap", "Sex Offenses",
             "Offenses Against Family")

pers_df <- full_df[full_df$major_offense_type %in% personal,]
prop_df <- full_df[full_df$major_offense_type %in% property,]
stat_df <- full_df[full_df$major_offense_type %in% statutory,]

rm('personal', 'property', 'statutory')
