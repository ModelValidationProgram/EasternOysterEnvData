SC1 - Processed Environmental Data
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
#Source - https://waterdata.usgs.gov/monitoring-location/021720710/#parameterCode=00480&timeSeriesId=177391&period=P7D - Cooper R at Customs House (Aux) at Charleston, SC - 021720710

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("08-15-2023")
source_description <- ("USGS Water Data Charleston Harbor - 021720710")
site_name <- ("SC1") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Read in the data using the USGS Data Retrieval Package in R. This will skip the step of downloading a .csv file or similar and importing that file from the desktop. We will import the salinity and temperature data separately and store them with “\_sal” or “\_temp” in the variable names. Then we will combine them into one file together.

``` r
siteNumber <- "021720710" # USGS Site Code

# Import our site info and read the associated metdata.
SC1Info <- readNWISsite(siteNumber)
comment(SC1Info)
```

    ##  [1] "#"                                                                                        
    ##  [2] "#"                                                                                        
    ##  [3] "# US Geological Survey"                                                                   
    ##  [4] "# retrieved: 2023-08-15 14:14:40 -04:00\t(vaas01)"                                        
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
rawUnitValues_sal <- readNWISuv(siteNumber, parameterCd_sal, "2020-08-15", "2022-08-10")
rawUnitValues_temp <- readNWISuv(siteNumber, parameterCd_temp,"2007-10-01", "2022-08-10")

# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
View(rawUnitValues_sal)
View(rawUnitValues_temp)
```

### In this case, since there are different ranges in the availability of temperature and salinity data, we will keep the data frames separate rather than combining them into a common one. Rename columns in each of the data frames. Format the data frame and remove unnecessary columns.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_SC1_sal <- rawUnitValues_sal %>% rename("salinity" = "X_BOTTOM_00480_00000", "site" = "site_no", "agency" = "agency_cd") 
raw_SC1_sal <- subset(raw_SC1_sal, select = -c(X_BOTTOM_00480_00000_cd, X_TOP_00480_00000_cd, tz_cd, X_TOP_00480_00000))

raw_SC1_temp <- rawUnitValues_temp %>% rename("temp" = "X_TOP_00010_00000", "site" = "site_no", "agency" = "agency_cd")
raw_SC1_temp <- subset(raw_SC1_temp, select = -c(X_TOP_00010_00000_cd, X_BOTTOM_00010_00000_cd, tz_cd, X_BOTTOM_00010_00000))
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_SC1_sal$datetime <- as.POSIXct(raw_SC1_sal$dateTime, "%Y/%m/%d %H:%M:%S", tz = "")

# Drop the old date-time column
raw_SC1_sal <- subset(raw_SC1_sal, select = -c(dateTime))

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_SC1_sal)
```

    ##     agency              site              salinity    
    ##  Length:68754       Length:68754       Min.   :11.00  
    ##  Class :character   Class :character   1st Qu.:22.00  
    ##  Mode  :character   Mode  :character   Median :24.00  
    ##                                        Mean   :24.09  
    ##                                        3rd Qu.:26.00  
    ##                                        Max.   :36.00  
    ##                                        NA's   :9053   
    ##     datetime                    
    ##  Min.   :2020-08-15 04:00:00.0  
    ##  1st Qu.:2021-02-13 22:33:45.0  
    ##  Median :2021-08-14 09:37:30.0  
    ##  Mean   :2021-08-14 09:39:56.4  
    ##  3rd Qu.:2022-02-12 22:11:15.0  
    ##  Max.   :2022-08-11 03:45:00.0  
    ## 

``` r
# Do the same thing for the temp data frame
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_SC1_temp$datetime <- as.POSIXct(raw_SC1_temp$dateTime, "%Y/%m/%d %H:%M:%S", tz = "")

# Drop the old date-time column
raw_SC1_temp <- subset(raw_SC1_temp, select = -c(dateTime))

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_SC1_temp)
```

    ##     agency              site                temp      
    ##  Length:476830      Length:476830      Min.   : 5.00  
    ##  Class :character   Class :character   1st Qu.:14.60  
    ##  Mode  :character   Mode  :character   Median :21.40  
    ##                                        Mean   :20.94  
    ##                                        3rd Qu.:27.70  
    ##                                        Max.   :31.90  
    ##                                        NA's   :523    
    ##     datetime                     
    ##  Min.   :2007-10-01 05:00:00.00  
    ##  1st Qu.:2012-02-06 11:18:45.00  
    ##  Median :2015-08-09 16:22:30.00  
    ##  Mean   :2015-07-30 14:32:05.57  
    ##  3rd Qu.:2019-01-28 20:11:15.00  
    ##  Max.   :2022-08-11 03:45:00.00  
    ## 

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Print the range (minimum and maximum) of dates of data collection. 
print(summary(raw_SC1_sal$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2020-08-15 04:00:00.0000" "2021-02-13 22:33:45.0000" 
    ##                     Median                       Mean 
    ## "2021-08-14 09:37:30.0000" "2021-08-14 09:39:56.4002" 
    ##                    3rd Qu.                       Max. 
    ## "2022-02-12 22:11:15.0000" "2022-08-11 03:45:00.0000"

``` r
print(summary(raw_SC1_temp$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2007-10-01 05:00:00.0000" "2012-02-06 11:18:45.0000" 
    ##                     Median                       Mean 
    ## "2015-08-09 16:22:30.0000" "2015-07-30 14:32:05.5824" 
    ##                    3rd Qu.                       Max. 
    ## "2019-01-28 20:11:15.0000" "2022-08-11 03:45:00.0000"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_SC1_sal$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   11.00   22.00   24.00   24.09   26.00   36.00    9053

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_SC1_temp$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    5.00   14.60   21.40   20.94   27.70   31.90     523

``` r
#Store variables that we will include in the final data frame. Pull metadata from the USGS website link located above or the site description from the comment function above. 
lat <-  32.7804544
lon <-  -79.923699
firstyear_temp <- 2007
firstyear_sal <- 2020
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_SC1_sal<- raw_SC1_sal %>%
    filter(between(salinity, 0, 40))

filtered_SC1_temp<- raw_SC1_temp %>%
    filter(between(temp, -1, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_SC1_sal$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   11.00   22.00   24.00   24.09   26.00   36.00

``` r
print(summary(filtered_SC1_temp$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    5.00   14.60   21.40   20.94   27.70   31.90

``` r
#Store our data into a variable name with just the site name. 
SC1_sal <- filtered_SC1_sal
SC1_temp <- filtered_SC1_temp
```

### Write the final processed data frame to a .csv file to create a reproducible “raw” file

``` r
write.table(SC1_sal, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/SC1_raw_sal.csv", sep = ",", append = TRUE, col.names = TRUE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame
```

    ## Warning in write.table(SC1_sal,
    ## "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/SC1_raw_sal.csv", :
    ## appending column names to file

``` r
write.table(SC1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/SC1_raw_temp.csv", sep = ",", append = TRUE, col.names = TRUE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame
```

    ## Warning in write.table(SC1_temp,
    ## "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/SC1_raw_temp.csv", :
    ## appending column names to file

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(SC1_sal, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for SC1 - Charleston Harbor") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

![](SC1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(SC1_temp, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(-10, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for SC1 - Charleston Harbor") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](SC1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
SC1_envrmonth_sal <- SC1_sal %>%
    mutate(year = year(datetime), month = month(datetime)) %>%
    group_by(year, month) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      length_salinity = length(salinity))
```

    ## `summarise()` has grouped output by 'year'. You can override using the
    ## `.groups` argument.

``` r
SC1_envrmonth_temp <- SC1_temp %>%
    mutate(year = year(datetime), month = month(datetime)) %>%
    group_by(year, month) %>%
    summarise(      
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp),
      length_temp = length(temp))
```

    ## `summarise()` has grouped output by 'year'. You can override using the
    ## `.groups` argument.

``` r
print(SC1_envrmonth_sal)
```

    ## # A tibble: 25 × 6
    ## # Groups:   year [3]
    ##     year month min_salinity max_salinity mean_salinity length_salinity
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ##  1  2020     8           11           33          22.9            1501
    ##  2  2020     9           13           32          24.0            2137
    ##  3  2020    10           12           33          22.7            2967
    ##  4  2020    11           16           30          22.5            2872
    ##  5  2020    12           18           32          23.7            2973
    ##  6  2021     1           17           30          23.6            2971
    ##  7  2021     2           14           29          21.3            2688
    ##  8  2021     3           16           30          21.2            2974
    ##  9  2021     4           19           31          24.0            2871
    ## 10  2021     5           18           32          24.1            2971
    ## # ℹ 15 more rows

``` r
print(SC1_envrmonth_temp)
```

    ## # A tibble: 179 × 6
    ## # Groups:   year [16]
    ##     year month min_temp max_temp mean_temp length_temp
    ##    <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ##  1  2007    10     19.9     26.8      24.5        1473
    ##  2  2007    11     15       21.1      17.1        1408
    ##  3  2007    12     12.9     16.6      14.5        1378
    ##  4  2008     1      9.1     14.4      11.3        1385
    ##  5  2008     2     10.2     14.8      13.0        1388
    ##  6  2008     3     13.1     17.9      15.7        1486
    ##  7  2008     4     15.9     21.5      18.9        1437
    ##  8  2008     5     20.3     25.6      23.3        1488
    ##  9  2008     6     25       29.9      28.0        1436
    ## 10  2008     7     27.8     30.2      28.8        1486
    ## # ℹ 169 more rows

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
SC1_envryear_sal <- SC1_sal %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

SC1_envryear_temp <- SC1_temp %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(SC1_envryear_sal)
```

    ## # A tibble: 3 × 4
    ##    year min_salinity max_salinity mean_salinity
    ##   <dbl>        <dbl>        <dbl>         <dbl>
    ## 1  2020           11           33          23.1
    ## 2  2021           14           33          24.1
    ## 3  2022           17           36          25.1

``` r
print(SC1_envryear_temp)
```

    ## # A tibble: 16 × 4
    ##     year min_temp max_temp mean_temp
    ##    <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2007     12.9     26.8      18.8
    ##  2  2008      9.1     30.7      20.5
    ##  3  2009      8.9     30.7      21.2
    ##  4  2010      6.4     31.8      20.5
    ##  5  2011      6       31.4      20.7
    ##  6  2012     10.9     31.7      21.3
    ##  7  2013     11.1     30.5      20.3
    ##  8  2014      6.6     31.4      20.6
    ##  9  2015      8       31.6      21.0
    ## 10  2016      9       31.7      21.3
    ## 11  2017     10       31.9      21.8
    ## 12  2018      5       31.2      20.8
    ## 13  2019     11       31.9      20.7
    ## 14  2020     10.6     31.8      21.4
    ## 15  2021     10.1     31.2      20.9
    ## 16  2022      8.5     31.7      21.1

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(SC1_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for SC1 - Charleston Harbor") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](SC1-EnvrData_files/figure-gfm/salinity%20timeplot-1.png)<!-- -->

``` r
timeplot <- ggplot(SC1_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for SC1 - Charleston Harbor") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](SC1-EnvrData_files/figure-gfm/temperature%20timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(SC1_temp$temp)
Mean_max_temperature_C <- mean(SC1_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(SC1_envryear_temp$min_temp)
Temperature_st_dev <- sd(SC1_temp$temp)
Temperature_n <- nrow(SC1_temp)
Temperature_years <- nrow(SC1_envryear_temp)

#Create a data frame to store the temperature results
SC1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear_temp, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(SC1_temp)
```

    ##      site_name download_date source_description                             
    ## [1,] "SC1"     "08-15-2023"  "USGS Water Data Charleston Harbor - 021720710"
    ##      lat          lon          firstyear_temp finalyear
    ## [1,] "32.7804544" "-79.923699" "2007"         "2022"   
    ##      Mean_Annual_Temperature_C Mean_max_temperature_C Mean_min_temperature_C
    ## [1,] "20.940141757312"         "31.125"               "9.00625"             
    ##      Temperature_st_dev Temperature_n Temperature_years collection_type
    ## [1,] "6.77754757853782" "476307"      "16"              "continuous"

``` r
# Write to the combined file with all sites 
write.table(SC1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(SC1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/SC1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(SC1_sal$salinity)
Mean_max_Salinity_ppt <- mean(SC1_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(SC1_envryear_sal$min_salinity)
Salinity_st_dev <- sd(SC1_sal$salinity)
Salinity_n <- nrow(SC1_sal)
Salinity_years <- nrow(SC1_envryear_sal)


#Create a data frame to store the temperature results
SC1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear_sal, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(SC1_salinity)
```

    ##      site_name download_date source_description                             
    ## [1,] "SC1"     "08-15-2023"  "USGS Water Data Charleston Harbor - 021720710"
    ##      lat          lon          firstyear_sal finalyear Mean_Annual_Salinity_ppt
    ## [1,] "32.7804544" "-79.923699" "2020"        "2022"    "24.0914222542336"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev   Salinity_n
    ## [1,] "34"                  "14"                  "2.8971626428575" "59701"   
    ##      Salinity_years collection_type
    ## [1,] "3"            "continuous"

``` r
# Write to the combined file with all sites 
write.table(SC1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(SC1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/SC1_salinity.csv", row.names = FALSE)
```
