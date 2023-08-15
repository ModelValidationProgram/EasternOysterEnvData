LA5 - Processed Environmental Data
================
Madeline Eppley
8/15/2023

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
#Data was downloaded on 8/15/2023
#Source - https://waterdata.usgs.gov/monitoring-location/073802512/#parameterCode=00065&period=P7D - Hackberry Bay NW of Grand Isle, LA - 073802512

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("08-15-2023")
source_description <- ("USGS Water Data Culch Plant/Hackberry Bay - 073802512")
site_name <- ("LA5") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Read in the data using the USGS Data Retrieval Package in R. This will skip the step of downloading a .csv file or similar and importing that file from the desktop. We will import the salinity and temperature data separately and store them with “\_sal” or “\_temp” in the variable names. Then we will combine them into one file together.

``` r
siteNumber <- "073802512" # USGS Site Code

# Import our site info and read the associated metdata.
LA5Info <- readNWISsite(siteNumber)
comment(LA5Info)
```

    ##  [1] "#"                                                                                        
    ##  [2] "#"                                                                                        
    ##  [3] "# US Geological Survey"                                                                   
    ##  [4] "# retrieved: 2023-08-15 13:36:29 -04:00\t(sdas01)"                                        
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
rawUnitValues_sal <- readNWISuv(siteNumber, parameterCd_sal, "2007-10-01", "2022-06-21")
rawUnitValues_temp <- readNWISuv(siteNumber, parameterCd_temp,"2007-10-01", "2022-06-21")

# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
View(rawUnitValues_sal)
View(rawUnitValues_temp)
```

### Combine the salinity and temperature data into one common data frame and name it with the appropriate site code using the “raw\_” format. Filter the combined data frame to include no duplicate columns and rename column headers.

``` r
# Join the data frames by common time using the dateTime column
raw_LA5 <- rawUnitValues_sal %>%
  inner_join(rawUnitValues_temp, by = "dateTime")


# We now have "double" columns for site code, agency, time zone, and other parameters. Remove those columns. 
raw_LA5 <- subset(raw_LA5, select = -c(agency_cd.y, X_00480_00000_cd, site_no.y, X_00010_00000_cd, tz_cd.x, tz_cd.y))

#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_LA5 <- raw_LA5 %>% rename("temp" = "X_00010_00000", "salinity" = "X_00480_00000", "site" = "site_no.x", "agency" = "agency_cd.x") 
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_LA5$datetime <- as.POSIXct(raw_LA5$dateTime, "%Y/%m/%d %H:%M:%S", tz = "")

# Drop the old date-time column
raw_LA5 <- subset(raw_LA5, select = -c(dateTime))

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_LA5)
```

    ##     agency              site              salinity           temp      
    ##  Length:154474      Length:154474      Min.   : 0.200   Min.   : 1.70  
    ##  Class :character   Class :character   1st Qu.: 4.800   1st Qu.:17.60  
    ##  Mode  :character   Mode  :character   Median : 8.900   Median :24.30  
    ##                                        Mean   : 9.411   Mean   :23.06  
    ##                                        3rd Qu.:13.000   3rd Qu.:29.10  
    ##                                        Max.   :30.000   Max.   :35.10  
    ##     datetime                     
    ##  Min.   :2007-10-01 06:00:00.00  
    ##  1st Qu.:2012-11-26 22:15:00.00  
    ##  Median :2016-12-02 14:45:00.00  
    ##  Mean   :2015-12-07 03:10:47.55  
    ##  3rd Qu.:2019-03-01 22:52:30.00  
    ##  Max.   :2021-08-29 14:00:00.00

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Print the range (minimum and maximum) of dates of data collection. 
print(summary(raw_LA5$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2007-10-01 06:00:00.0000" "2012-11-26 22:15:00.0000" 
    ##                     Median                       Mean 
    ## "2016-12-02 14:45:00.0000" "2015-12-07 03:10:47.5613" 
    ##                    3rd Qu.                       Max. 
    ## "2019-03-01 22:52:30.0000" "2021-08-29 14:00:00.0000"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_LA5$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.200   4.800   8.900   9.411  13.000  30.000

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_LA5$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.70   17.60   24.30   23.06   29.10   35.10

``` r
#Store variables that we will include in the final data frame. Pull metadata from the USGS website link located above or the site description from the comment function above. 
lat <- 29.39855505
lon <- -90.0411844
firstyear <- 2007
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_LA5<- raw_LA5 %>%
    filter(between(salinity, 0, 40) & between(temp, -1, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_LA5$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.200   4.800   8.900   9.411  13.000  30.000

``` r
print(summary(filtered_LA5$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.70   17.60   24.30   23.06   29.10   35.10

``` r
#Store our data into a variable name with just the site name. 
LA5 <- filtered_LA5
```

### Write the final processed data frame to a .csv file to create a reproducible “raw” file

``` r
write.table(LA5, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/LA5_raw.csv", sep = ",", append = TRUE, col.names = TRUE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame
```

    ## Warning in write.table(LA5,
    ## "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/LA5_raw.csv", :
    ## appending column names to file

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(LA5, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for LA5 - Sister Lake") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

![](LA5-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(LA5, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(-10, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for LA5 - Sister Lake") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](LA5-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
LA5_envrmonth <- LA5 %>%
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
print(LA5_envrmonth)
```

    ## # A tibble: 164 × 10
    ## # Groups:   year [15]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2007    10          3.3         25           15.9              737     16.7
    ##  2  2007    11          5.9         22           13.2              720     13.5
    ##  3  2007    12          4.7         25           15.7              743     11.8
    ##  4  2008     1          1.4         23            8.77             744      5  
    ##  5  2008     2          0.4         14            3.33             695     11.8
    ##  6  2008     3          0.4         16            4.41             744     12  
    ##  7  2008     4          0.6         11            6.12             720     16.6
    ##  8  2008     5          0.5         12            3.50             744     22.5
    ##  9  2008     6          0.8          8.3          3.62             719     27.8
    ## 10  2008     7          0.3         12            4.14             744     28.5
    ## # ℹ 154 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
LA5_envryear <- LA5 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(LA5_envryear)
```

    ## # A tibble: 15 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2007          3.3           25         14.9      11.8     28.6      20.0
    ##  2  2008          0.2           28          7.54      5       33.9      22.4
    ##  3  2009          0.2           25          8.72      8.2     33.9      22.8
    ##  4  2010          0.2           23          6.62      1.7     34.7      22.0
    ##  5  2011          1.4           30         13.5       9.8     33.6      24.7
    ##  6  2012          0.5           30         12.4       9.1     33.5      23.2
    ##  7  2013          0.2           30          9.33      9.1     33.3      22.2
    ##  8  2014          0.4           28         11.1       3.4     33.3      21.9
    ##  9  2015          0.2           29         10.3       6.8     35.1      23.4
    ## 10  2016          0.2           27          8.22      8.8     33.8      24.4
    ## 11  2017          0.2           29          9.89      6       33        23.5
    ## 12  2018          0.3           29         10.9       3.2     33.7      22.9
    ## 13  2019          0.2           29          7.45      8.9     34.3      22.6
    ## 14  2020          0.3           29         10.3       9.5     33.7      23.3
    ## 15  2021          0.2           26          5.73      5.8     33.9      23.9

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(LA5_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for LA5 - Sister Lake") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](LA5-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(LA5$temp)
Mean_max_temperature_C <- mean(LA5_envryear$max_temp)
Mean_min_temperature_C <- mean(LA5_envryear$min_temp)
Temperature_st_dev <- sd(LA5$temp)
Temperature_n <- nrow(LA5)
Temperature_years <- nrow(LA5_envryear)

#Create a data frame to store the temperature results
LA5_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(LA5_temp)
```

    ##      site_name download_date
    ## [1,] "LA5"     "08-15-2023" 
    ##      source_description                                      lat          
    ## [1,] "USGS Water Data Culch Plant/Hackberry Bay - 073802512" "29.39855505"
    ##      lon           firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "-90.0411844" "2007"    "2022"    "23.0643920659787"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "33.4866666666667"     "7.14"                 "6.58208470345455"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "154474"      "15"              "continuous"

``` r
# Write to the combined file with all sites 
write.table(LA5_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(LA5_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/LA5_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(LA5$salinity)
Mean_max_Salinity_ppt <- mean(LA5_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(LA5_envryear$min_salinity)
Salinity_st_dev <- sd(LA5$salinity)
Salinity_n <- nrow(LA5)
Salinity_years <- nrow(LA5_envryear)


#Create a data frame to store the temperature results
LA5_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(LA5_salinity)
```

    ##      site_name download_date
    ## [1,] "LA5"     "08-15-2023" 
    ##      source_description                                      lat          
    ## [1,] "USGS Water Data Culch Plant/Hackberry Bay - 073802512" "29.39855505"
    ##      lon           firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "-90.0411844" "2007"    "2022"    "9.41110542874529"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "27.8"                "0.533333333333333"   "5.69871314184645" "154474"  
    ##      Salinity_years collection_type
    ## [1,] "15"           "continuous"

``` r
# Write to the combined file with all sites 
write.table(LA5_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(LA5_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/LA5_salinity.csv", row.names = FALSE)
```
