GA2 - Processed Environmental Data
================
Madeline Eppley
3/19/2024

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
#Data was downloaded on 3/19/2024
#Source - https://waterdata.usgs.gov/monitoring-location/022035975/#parameterCode=00065&period=P7D - Hudson Creek at Meridian Landing, Near Meridian,Ga - 022035975

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("03-19-2024")
source_description <- ("USGS Water Data Meridian Landing - 022035975")
site_name <- ("GA2") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Read in the data using the USGS Data Retrieval Package in R. This will skip the step of downloading a .csv file or similar and importing that file from the desktop. We will import the salinity and temperature data separately and store them with “\_sal” or “\_temp” in the variable names. Then we will combine them into one file together.

``` r
siteNumber <- "022035975" # USGS Site Code

# Import our site info and read the associated metdata.
GA2Info <- readNWISsite(siteNumber)
comment(GA2Info)
```

    ##  [1] "#"                                                                                        
    ##  [2] "#"                                                                                        
    ##  [3] "# US Geological Survey"                                                                   
    ##  [4] "# retrieved: 2024-03-19 18:09:16 -04:00\t(vaas01)"                                        
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
rawUnitValues_sal <- readNWISuv(siteNumber, parameterCd_sal, "2007-10-01", "2022-07-18")
rawUnitValues_temp <- readNWISuv(siteNumber, parameterCd_temp,"2007-10-01", "2022-07-18")

# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
#View(rawUnitValues_sal)
#View(rawUnitValues_temp)
```

### Combine the salinity and temperature data into one common data frame and name it with the appropriate site code using the “raw\_” format. Filter the combined data frame to include no duplicate columns and rename column headers.

``` r
# Join the data frames by common time using the dateTime column
raw_GA2 <- rawUnitValues_sal %>%
  inner_join(rawUnitValues_temp, by = "dateTime")


# We now have "double" columns for site code, agency, time zone, and other parameters. Remove those columns. 
raw_GA2 <- subset(raw_GA2, select = -c(agency_cd.y, X_00480_00000_cd, site_no.y, X_00010_00000_cd, tz_cd.x, tz_cd.y))

#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_GA2 <- raw_GA2 %>% rename("temp" = "X_00010_00000", "salinity" = "X_00480_00000", "site" = "site_no.x", "agency" = "agency_cd.x") 
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_GA2$datetime <- as.POSIXct(raw_GA2$dateTime, "%Y/%m/%d %H:%M:%S", tz = "")

# Drop the old date-time column
raw_GA2 <- subset(raw_GA2, select = -c(dateTime))

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_GA2)
```

    ##     agency              site              salinity          temp      
    ##  Length:495777      Length:495777      Min.   : 3.00   Min.   : 4.10  
    ##  Class :character   Class :character   1st Qu.:20.00   1st Qu.:16.00  
    ##  Mode  :character   Mode  :character   Median :25.00   Median :22.40  
    ##                                        Mean   :24.12   Mean   :21.85  
    ##                                        3rd Qu.:28.00   3rd Qu.:28.30  
    ##                                        Max.   :36.00   Max.   :34.40  
    ##     datetime                     
    ##  Min.   :2007-10-01 05:00:00.00  
    ##  1st Qu.:2011-08-10 00:30:00.00  
    ##  Median :2015-04-06 06:15:00.00  
    ##  Mean   :2015-03-28 07:41:55.05  
    ##  3rd Qu.:2018-11-24 12:00:00.00  
    ##  Max.   :2022-07-19 03:30:00.00

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Print the range (minimum and maximum) of dates of data collection. 
print(summary(raw_GA2$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2007-10-01 05:00:00.0000" "2011-08-10 00:30:00.0000" 
    ##                     Median                       Mean 
    ## "2015-04-06 06:15:00.0000" "2015-03-28 07:41:55.0614" 
    ##                    3rd Qu.                       Max. 
    ## "2018-11-24 12:00:00.0000" "2022-07-19 03:30:00.0000"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_GA2$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    3.00   20.00   25.00   24.12   28.00   36.00

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_GA2$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    4.10   16.00   22.40   21.85   28.30   34.40

``` r
#Store variables that we will include in the final data frame. Pull metadata from the USGS website link located above or the site description from the comment function above. 
lat <- 31.45333333
lon <- -81.3627778
firstyear <- 2007
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_GA2<- raw_GA2 %>%
    filter(between(salinity, 0, 40) & between(temp, -1, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_GA2$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    3.00   20.00   25.00   24.12   28.00   36.00

``` r
print(summary(filtered_GA2$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    4.10   16.00   22.40   21.85   28.30   34.40

``` r
#Store our data into a variable name with just the site name. 
GA2 <- filtered_GA2
```

### Write the final processed data frame to a .csv file to create a reproducible “raw” file

``` r
write.table(GA2, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/GA2_raw.csv", sep = ",", append = TRUE, col.names = TRUE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame
```

    ## Warning in write.table(GA2,
    ## "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/GA2_raw.csv", :
    ## appending column names to file

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(GA2, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for GA2 - Meridian Ferry") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

![](GA2-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(GA2, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(-10, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for GA2 - Meridian Ferry") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](GA2-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
GA2_envrmonth <- GA2 %>%
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
print(GA2_envrmonth)
```

    ## # A tibble: 178 × 10
    ## # Groups:   year [16]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2007    10           25           30          27.4            2854     18.4
    ##  2  2007    11           28           32          30.7            1820     14.5
    ##  3  2007    12           30           32          31.3            2871     12.6
    ##  4  2008     1           25           31          28.3            2679      9  
    ##  5  2008     2           18           26          23.0            2592     11.3
    ##  6  2008     3           16           24          18.6            2782     13.6
    ##  7  2008     4           20           25          22.1            2880     16.4
    ##  8  2008     5           21           27          25.0            2755     20.8
    ##  9  2008     6           26           30          28.2            2708     26.7
    ## 10  2008     7           28           32          30.1            2570     27.5
    ## # ℹ 168 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
GA2_envryear <- GA2 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(GA2_envryear)
```

    ## # A tibble: 16 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2007         25             32          29.7     12.6     27.7      19.4
    ##  2  2008         16             33          26.9      9       32.9      21.4
    ##  3  2009          6.6           32          23.1      7.6     33.3      21.9
    ##  4  2010          8.7           32          25.0      4.3     34.1      21.8
    ##  5  2011         17             36          29.2      5       33.9      21.8
    ##  6  2012         20             34          29.5      9.7     33.9      22.2
    ##  7  2013          8.8           31          22.2     10       33        21.4
    ##  8  2014          8.8           31          23.5      6.9     32.8      20.9
    ##  9  2015         15             32          23.1      7.8     33.4      22.1
    ## 10  2016          5.4           34          23.8      8.2     34.4      22.3
    ## 11  2017         10             31          23.5      9.2     33.3      22.4
    ## 12  2018          9             29          23.2      4.1     33.1      22.1
    ## 13  2019          9             33          23.5      9       32.9      22.0
    ## 14  2020          3             29          20.0      9.3     33.8      22.5
    ## 15  2021          9             28          21.2     10       33.2      21.8
    ## 16  2022         12             30          22.3      7.7     32.7      21.5

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(GA2_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for GA2 - Meridian Ferry") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](GA2-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(GA2$temp)
Mean_max_temperature_C <- mean(GA2_envryear$max_temp)
Mean_min_temperature_C <- mean(GA2_envryear$min_temp)
Temperature_st_dev <- sd(GA2$temp)
Temperature_n <- nrow(GA2)
Temperature_years <- nrow(GA2_envryear)

#Create a data frame to store the temperature results
GA2_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(GA2_temp)
```

    ##      site_name download_date source_description                            
    ## [1,] "GA2"     "03-19-2024"  "USGS Water Data Meridian Landing - 022035975"
    ##      lat           lon           firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "31.45333333" "-81.3627778" "2007"    "2022"    "21.8450081387398"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "33.025"               "8.15"                 "6.61834412211162"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "495777"      "16"              "continuous"

``` r
# Write to the combined file with all sites 
write.table(GA2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(GA2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/GA2_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(GA2$salinity)
Mean_max_Salinity_ppt <- mean(GA2_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(GA2_envryear$min_salinity)
Salinity_st_dev <- sd(GA2$salinity)
Salinity_n <- nrow(GA2)
Salinity_years <- nrow(GA2_envryear)


#Create a data frame to store the temperature results
GA2_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(GA2_salinity)
```

    ##      site_name download_date source_description                            
    ## [1,] "GA2"     "03-19-2024"  "USGS Water Data Meridian Landing - 022035975"
    ##      lat           lon           firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "31.45333333" "-81.3627778" "2007"    "2022"    "24.1188621093758"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "31.6875"             "11.45625"            "5.35895063446324" "495777"  
    ##      Salinity_years collection_type
    ## [1,] "16"           "continuous"

``` r
# Write to the combined file with all sites 
write.table(GA2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(GA2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/GA2_salinity.csv", row.names = FALSE)
```
