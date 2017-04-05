library('readr')

cid2004 <- read_csv('crime_incident_data_2004.csv', 
                    col_names = TRUE,
                    col_types = "iccc_ccc__"
)
