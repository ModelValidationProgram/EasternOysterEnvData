TX4 - Processed Environmental Data
================
Madeline Eppley
8/14/2023

``` r
setwd("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData")
```

### Install required packaages

``` r
#install.packages("dataRetrieval")
```

### Load required packages.

``` r
library("dplyr") #Used for working with data frames
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library("lubridate") #Used for time-date conversions
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
library("readr") #Used to read the CSV file
library("ggplot2") 
library("dataRetrieval") #Used to download USGS data
library("tidyverse") #Used to join data frames
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ forcats 1.0.0     ✔ tibble  3.2.1
    ## ✔ purrr   1.0.1     ✔ tidyr   1.3.0
    ## ✔ stringr 1.5.0

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

### Note the date of data download and source. All available data should be used for each site regardless of year. Note from the CSV file how often the site was sampled, and if there are replicates in the data. Also describe if the sampling occurred at only low tide, only high tide, or continuously.

``` r
#Data was downloaded on 8/14/2023
#Source - https://waterdata.usgs.gov/monitoring-location/08067303/#parameterCode=00010&period=P7D - Galveston Bay/Trinity Bay Site Fish nr Baytown Site Number 08067303

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("08-14-2023")
source_description <- ("USGS Water Data Galveston Bay - 08067303")
site_name <- ("TX4") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Read in the data using the USGS Data Retrieval Package in R. This will skip the step of downloading a .csv file or similar and importing that file from the desktop. We will import the salinity and temperature data separately and store them with “\_sal” or “\_temp” in the variable names. Then we will combine them into one file together.

``` r
siteNumber <- "08067303" # USGS Site Code

# Import our site info and read the associated metdata.
TX4Info <- readNWISsite(siteNumber)
comment(TX4Info)
```

    ##  [1] "#"                                                                                        
    ##  [2] "#"                                                                                        
    ##  [3] "# US Geological Survey"                                                                   
    ##  [4] "# retrieved: 2023-08-14 13:29:15 -04:00\t(caas01)"                                        
    ##  [5] "#"                                                                                        
    ##  [6] "# The Site File stores location and general information about groundwater,"               
    ##  [7] "# surface water, and meteorological sites"                                                
    ##  [8] "# for sites in USA."                                                                      
    ##  [9] "#"                                                                                        
    ## [10] "# File-format description:  http://help.waterdata.usgs.gov/faq/about-tab-delimited-output"
    ## [11] "# Automated-retrieval info: http://waterservices.usgs.gov/rest/Site-Service.html"         
    ## [12] "#"                                                                                        
    ## [13] "# Contact:   gs-w_support_nwisweb@usgs.gov"                                               
    ## [14] "#"                                                                                        
    ## [15] "# The following selected fields are included in this output:"                             
    ## [16] "#"                                                                                        
    ## [17] "#  agency_cd       -- Agency"                                                             
    ## [18] "#  site_no         -- Site identification number"                                         
    ## [19] "#  station_nm      -- Site name"                                                          
    ## [20] "#  site_tp_cd      -- Site type"                                                          
    ## [21] "#  lat_va          -- DMS latitude"                                                       
    ## [22] "#  long_va         -- DMS longitude"                                                      
    ## [23] "#  dec_lat_va      -- Decimal latitude"                                                   
    ## [24] "#  dec_long_va     -- Decimal longitude"                                                  
    ## [25] "#  coord_meth_cd   -- Latitude-longitude method"                                          
    ## [26] "#  coord_acy_cd    -- Latitude-longitude accuracy"                                        
    ## [27] "#  coord_datum_cd  -- Latitude-longitude datum"                                           
    ## [28] "#  dec_coord_datum_cd -- Decimal Latitude-longitude datum"                                
    ## [29] "#  district_cd     -- District code"                                                      
    ## [30] "#  state_cd        -- State code"                                                         
    ## [31] "#  county_cd       -- County code"                                                        
    ## [32] "#  country_cd      -- Country code"                                                       
    ## [33] "#  land_net_ds     -- Land net location description"                                      
    ## [34] "#  map_nm          -- Name of location map"                                               
    ## [35] "#  map_scale_fc    -- Scale of location map"                                              
    ## [36] "#  alt_va          -- Altitude of Gage/land surface"                                      
    ## [37] "#  alt_meth_cd     -- Method altitude determined"                                         
    ## [38] "#  alt_acy_va      -- Altitude accuracy"                                                  
    ## [39] "#  alt_datum_cd    -- Altitude datum"                                                     
    ## [40] "#  huc_cd          -- Hydrologic unit code"                                               
    ## [41] "#  basin_cd        -- Drainage basin code"                                                
    ## [42] "#  topo_cd         -- Topographic setting code"                                           
    ## [43] "#  instruments_cd  -- Flags for instruments at site"                                      
    ## [44] "#  construction_dt -- Date of first construction"                                         
    ## [45] "#  inventory_dt    -- Date site established or inventoried"                               
    ## [46] "#  drain_area_va   -- Drainage area"                                                      
    ## [47] "#  contrib_drain_area_va -- Contributing drainage area"                                   
    ## [48] "#  tz_cd           -- Time Zone abbreviation"                                             
    ## [49] "#  local_time_fg   -- Site honors Daylight Savings Time"                                  
    ## [50] "#  reliability_cd  -- Data reliability code"                                              
    ## [51] "#  gw_file_cd      -- Data-other GW files"                                                
    ## [52] "#  nat_aqfr_cd     -- National aquifer code"                                              
    ## [53] "#  aqfr_cd         -- Local aquifer code"                                                 
    ## [54] "#  aqfr_type_cd    -- Local aquifer type code"                                            
    ## [55] "#  well_depth_va   -- Well depth"                                                         
    ## [56] "#  hole_depth_va   -- Hole depth"                                                         
    ## [57] "#  depth_src_cd    -- Source of depth data"                                               
    ## [58] "#  project_no      -- Project number"                                                     
    ## [59] "#"

``` r
# Store the parameter codes that we want to collect data for. The USGS codes salinity as 00480 and temperature (C) as 00010. 
parameterCd_sal <- "00480"
parameterCd_temp <- "00010"
 
# We will retrieve the unit values, or the data values collected at regular intervals. Note the regularity of collection, for this site it is every 15 minutes. 
rawUnitValues_sal <- readNWISuv(siteNumber, parameterCd_sal, "2020-10-26", "2022-06-6")
rawUnitValues_temp <- readNWISuv(siteNumber, parameterCd_temp,"2020-10-26", "2022-06-6")

# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
View(rawUnitValues_sal)
View(rawUnitValues_temp)
```

### Combine the salinity and temperature data into one common data frame and name it with the appropriate site code using the “raw\_” format. Filter the combined data frame to include no duplicate columns and rename column headers.

``` r
# Join the data frames by common time using the dateTime column
raw_TX4 <- rawUnitValues_sal %>%
  inner_join(rawUnitValues_temp, by = "dateTime")


# We now have "double" columns for site code, agency, time zone, and other parameters. Remove those columns. 
raw_TX4 <- subset(raw_TX4, select = -c(agency_cd.y, X_00480_00000_cd, site_no.y, X_00010_00000_cd, tz_cd.x, tz_cd.y))

#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_TX4 <- raw_TX4 %>% rename("temp" = "X_00010_00000", "salinity" = "X_00480_00000", "site" = "site_no.x", "agency" = "agency_cd.x") 
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_TX4$datetime <- as.POSIXct(raw_TX4$dateTime, "%Y/%m/%d %H:%M:%S", tz = "")

# Drop the old date-time column
raw_TX4 <- subset(raw_TX4, select = -c(dateTime))

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_TX4)
```

    ##     agency              site              salinity          temp     
    ##  Length:52330       Length:52330       Min.   : 0.00   Min.   : 3.9  
    ##  Class :character   Class :character   1st Qu.:10.00   1st Qu.:14.9  
    ##  Mode  :character   Mode  :character   Median :13.00   Median :19.9  
    ##                                        Mean   :11.88   Mean   :20.6  
    ##                                        3rd Qu.:16.00   3rd Qu.:27.1  
    ##                                        Max.   :21.00   Max.   :33.2  
    ##     datetime                     
    ##  Min.   :2020-10-26 19:30:00.00  
    ##  1st Qu.:2021-03-12 02:33:45.00  
    ##  Median :2021-09-07 07:52:30.00  
    ##  Mean   :2021-08-23 23:22:34.27  
    ##  3rd Qu.:2022-01-21 17:11:15.00  
    ##  Max.   :2022-06-07 04:45:00.00

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Print the range (minimum and maximum) of dates of data collection. 
print(summary(raw_TX4$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2020-10-26 19:30:00.0000" "2021-03-12 02:33:45.0000" 
    ##                     Median                       Mean 
    ## "2021-09-07 07:52:30.0000" "2021-08-23 23:22:34.2824" 
    ##                    3rd Qu.                       Max. 
    ## "2022-01-21 17:11:15.0000" "2022-06-07 04:45:00.0000"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_TX4$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   10.00   13.00   11.88   16.00   21.00

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_TX4$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     3.9    14.9    19.9    20.6    27.1    33.2

``` r
#Store variables that we will include in the final data frame. Pull metadata from the USGS website link located above or the site description from the comment function above. 
lat <-  29.6703
lon <- -94.8536
firstyear <- 2020
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_TX4<- raw_TX4 %>%
    filter(between(salinity, 0, 40) & between(temp, -1, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_TX4$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   10.00   13.00   11.88   16.00   21.00

``` r
print(summary(filtered_TX4$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     3.9    14.9    19.9    20.6    27.1    33.2

``` r
#Store our data into a variable name with just the site name. 
TX4 <- filtered_TX4
```

### Write the final processed data frame to a .csv file to create a reproducible “raw” file

``` r
write.table(TX4, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/TX4_raw.csv", sep = ",", append = TRUE, col.names = TRUE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame
```

    ## Warning in write.table(TX4,
    ## "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/TX4_raw.csv", :
    ## appending column names to file

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(TX4, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for TX4 - Galveston Bay") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

![](TX4-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(TX4, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(-10, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for TX4 - Galveston Bay") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](TX4-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
TX4_envrmonth <- TX4 %>%
    mutate(year = year(datetime), month = month(datetime)) %>%
    group_by(year, month) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      length_salinity = length(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp),
      length_temp = length(temp))
```

    ## `summarise()` has grouped output by 'year'. You can override using the
    ## `.groups` argument.

``` r
print(TX4_envrmonth)
```

    ## # A tibble: 20 × 10
    ## # Groups:   year [3]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2020    10           13           18        16.1               498     16.9
    ##  2  2020    11           14           19        16.7              2880     14.1
    ##  3  2020    12            5           19        14.8              2975     11  
    ##  4  2021     1            0           15         8.12             2975      8.5
    ##  5  2021     2            5           20        13.8              2688      3.9
    ##  6  2021     3            3           16        11.4              2976     12.9
    ##  7  2021     4            4           16        11.5              2575     16.4
    ##  8  2021     6            0            1         0.211            2039     28  
    ##  9  2021     7            0            1         0.478            2975     27  
    ## 10  2021     8            0           14         5.39             2976     28.9
    ## 11  2021     9            8           17        13.3              2880     25.1
    ## 12  2021    10           10           15        12.6              2971     17.7
    ## 13  2021    11           10           19        14.9              2880     16  
    ## 14  2021    12            9           17        13.4              2976     14.9
    ## 15  2022     1            8           21        14.6              2970      8.4
    ## 16  2022     2           14           21        17.5              2682      7.3
    ## 17  2022     3            6           21        16.8              2968     11.3
    ## 18  2022     4            6           17        11.9              2880     19  
    ## 19  2022     5            7           17        12.9              2970     25.2
    ## 20  2022     6           10           15        13.1               596     28.2
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
TX4_envryear <- TX4 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(TX4_envryear)
```

    ## # A tibble: 3 × 7
    ##    year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##   <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ## 1  2020            5           19         15.7      11       23.8      17.3
    ## 2  2021            0           20          9.75      3.9     33.2      22.1
    ## 3  2022            6           21         14.6       7.3     30.5      19.0

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(TX4_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for TX4 - Galveston Bay") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](TX4-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

### We can now calculate a list of variables that we will have collected for all sites. This will allow us to compare sites easily. We will calculate the number of observations from each site, the mean annual, maximum annual, and minimum annual value for all variables.

Our list of variables includes:

- Mean_Annual_Temperature_C: average of all available data

- Mean_max_temperature_C: average of maximums for each year

- Mean_min_temperature_C: average of minimums for each year

- Temperature_st_dev: standard deviation of all available data

- Temperature_n: total number of data points

- Temperature_years: number of years in data set

- Mean_Annual_Salinity_ppt: average of all available data

- Mean_min_Salinity_ppt: average of minimums for each year

- Mean_max_Salinity_ppt: average of maximums for each year

- Salinity_st_dev: standard deviation of all available data

- Salinity_n: total number of data points

- Salinity_years: number of years in data set

``` r
#Calculate temperature variables. 
Mean_Annual_Temperature_C <- mean(TX4$temp)
Mean_max_temperature_C <- mean(TX4_envryear$max_temp)
Mean_min_temperature_C <- mean(TX4_envryear$min_temp)
Temperature_st_dev <- sd(TX4$temp)
Temperature_n <- nrow(TX4)
Temperature_years <- nrow(TX4_envryear)

#Create a data frame to store the temperature results
TX4_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(TX4_temp)
```

    ##      site_name download_date source_description                        
    ## [1,] "TX4"     "08-14-2023"  "USGS Water Data Galveston Bay - 08067303"
    ##      lat       lon        firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "29.6703" "-94.8536" "2020"    "2022"    "20.6018612650487"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "29.1666666666667"     "7.4"                  "6.70054399393717"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "52330"       "3"               "continuous"

``` r
# Write to the combined file with all sites 
write.table(TX4_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(TX4_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/TX4_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(TX4$salinity)
Mean_max_Salinity_ppt <- mean(TX4_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(TX4_envryear$min_salinity)
Salinity_st_dev <- sd(TX4$salinity)
Salinity_n <- nrow(TX4)
Salinity_years <- nrow(TX4_envryear)


#Create a data frame to store the temperature results
TX4_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(TX4_salinity)
```

    ##      site_name download_date source_description                        
    ## [1,] "TX4"     "08-14-2023"  "USGS Water Data Galveston Bay - 08067303"
    ##      lat       lon        firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "29.6703" "-94.8536" "2020"    "2022"    "11.8819606344353"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "20"                  "3.66666666666667"    "5.23148686250301" "52330"   
    ##      Salinity_years collection_type
    ## [1,] "3"            "continuous"

``` r
# Write to the combined file with all sites 
write.table(TX4_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(TX4_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/TX4_salinity.csv", row.names = FALSE)
```
