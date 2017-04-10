library('readr')

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

cid2004 <- read_csv('crime_incident_data_2004.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2005 <- read_csv('crime_incident_data_2005.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2006 <- read_csv('crime_incident_data_2006.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2007 <- read_csv('crime_incident_data_2007.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2008 <- read_csv('crime_incident_data_2008.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2009 <- read_csv('crime_incident_data_2009.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2010 <- read_csv('crime_incident_data_2010.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2011 <- read_csv('crime_incident_data_2011.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2012 <- read_csv('crime_incident_data_2012.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2013 <- read_csv('crime_incident_data_2013.csv', skip = 1,
                    col_names = c_names, col_types = c_types)

cid2014 <- read_csv('crime_incident_data_2014.csv', skip = 1,
                    col_names = c_names, col_types = c_types)
