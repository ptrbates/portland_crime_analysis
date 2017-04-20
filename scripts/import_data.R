library('tidyverse')
library('plyr')
library('readxl')

c_names <- c('record_id', 'report_date', 'report_time',
             'major_offense_type', 'address', 'neighborhood',
             'police_precinct', 'police_district',
             'x_coordinate', 'y_coordinate')

c_types <- cols(
  'record_id' = col_integer(),
  'report_date' = col_date(format = '%m%.%d%.%Y'),
  'report_time' = col_time(format = '%H%.%M%.%S'),
  'major_offense_type' = col_factor(levels = NULL),
  'address' = col_character(),
  'neighborhood' = col_factor(levels = NULL),
  'police_precinct'= col_factor(levels = NULL),
  'police_district' = col_factor(levels = NULL),
  'x_coordinate' = col_double(),
  'y_coordinate' = col_double()
)

filename_list <- c('csv/crime_incident_data_2004.csv', 
                   'csv/crime_incident_data_2005.csv',
                   'csv/crime_incident_data_2006.csv', 
                   'csv/crime_incident_data_2007.csv',
                   'csv/crime_incident_data_2008.csv', 
                   'csv/crime_incident_data_2009.csv',
                   'csv/crime_incident_data_2010.csv', 
                   'csv/crime_incident_data_2011.csv',
                   'csv/crime_incident_data_2012.csv', 
                   'csv/crime_incident_data_2013.csv',
                   'csv/crime_incident_data_2014.csv'
)

get_data <- function(filename) {
  read_csv(filename, skip = 1, col_names = c_names, 
           col_types = c_types)
}

# construct full crime data frame
full_df <- rbind.fill(map(filename_list, get_data))

# construct population data frame
pop_df <- read_csv('csv/portland_population.csv',
                   col_names = c('year', 'population'),
                   cols(year = col_date(format = '%Y'),
                        population = col_integer()))

# construct unemployment data frame
unemp_df <- read_csv('csv/portland_unemployment.csv',
                     col_names = TRUE,
                     col_types = 'cc___d')


# read data from excel sheet regarding neighborhood demographic data
nei_df <- read_excel("csv/Census_2010_Data_Cleanedup.xls", 
                     sheet = "Census_2010_Neighborhoods", skip = 5, n_max = 95)

nei_df <- transmute(nei_df, neighborhood = as.character(nei_df$`NEIGHBORHOOD ASSOCIATION`),
                    total_pop = as.integer(nei_df$P0010001), 
                    white = as.integer(nei_df$P007000310),
                    black_aa = as.integer(nei_df$P007000411),
                    AIAN = as.integer(nei_df$P007000512),
                    asian = as.integer(nei_df$P007000613),
                    NHOPI = as.integer(nei_df$P007000714),
                    other = as.integer(nei_df$P007000815))

# remove extra variables, unload packages

rm('c_names', 'c_types', 'filename_list', 'get_data')
