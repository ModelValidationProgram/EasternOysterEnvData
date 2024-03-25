CN1 - Processed Environmental Data
================
Madeline Eppley
3/25/2024

``` r
setwd("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData")
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
```

### Note the date of data download and source. All available data should be used for each site regardless of year. Note from the CSV file how often the site was sampled, and if there are replicates in the data. Also describe if the sampling occurred at only low tide, only high tide, or continuously.

``` r
#Data was downloaded on 3/25/2024
#Source - https://data.novascotia.ca/Nature-and-Environment/Nova-Scotia-Water-Quality-Data-Station-Locations-M/svms-mkst
#The site was sampled continuously 

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("03-25-2024")
source_description <- ("Nova Scotia Gov Water Quality Data")
site_name <- ("CN1") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Salt Bay, Canada. The ID_Site for this site is CN1. 
raw_CN1_sal <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/CN1-raw_sal.csv")
```

    ## Rows: 104905 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (8): WATERBODY, STATION, DEPLOYMENT_PERIOD, TIMESTAMP, SENSOR, VARIABLE,...
    ## dbl (4): LATITUDE, LONGITUDE, DEPTH, VALUE
    ## lgl (1): LEASE
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
raw_CN1_temp <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/CN1-raw_temp.csv")
```

    ## Rows: 57278 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (8): WATERBODY, STATION, DEPLOYMENT_PERIOD, TIMESTAMP, SENSOR, VARIABLE,...
    ## dbl (4): LATITUDE, LONGITUDE, DEPTH, VALUE
    ## lgl (1): LEASE
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_CN1_sal)
```

    ## cols(
    ##   WATERBODY = col_character(),
    ##   STATION = col_character(),
    ##   LEASE = col_logical(),
    ##   LATITUDE = col_double(),
    ##   LONGITUDE = col_double(),
    ##   DEPLOYMENT_PERIOD = col_character(),
    ##   TIMESTAMP = col_character(),
    ##   SENSOR = col_character(),
    ##   DEPTH = col_double(),
    ##   VARIABLE = col_character(),
    ##   VALUE = col_double(),
    ##   UNITS = col_character(),
    ##   MOORING = col_character()
    ## )

``` r
#View(raw_CN1_sal)

spec(raw_CN1_temp)
```

    ## cols(
    ##   WATERBODY = col_character(),
    ##   STATION = col_character(),
    ##   LEASE = col_logical(),
    ##   LATITUDE = col_double(),
    ##   LONGITUDE = col_double(),
    ##   DEPLOYMENT_PERIOD = col_character(),
    ##   TIMESTAMP = col_character(),
    ##   SENSOR = col_character(),
    ##   DEPTH = col_double(),
    ##   VARIABLE = col_character(),
    ##   VALUE = col_double(),
    ##   UNITS = col_character(),
    ##   MOORING = col_character()
    ## )

``` r
#View(raw_CN1_temp)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_CN1_sal$datetime <- as.POSIXct(raw_CN1_sal$TIMESTAMP, "%Y/%m/%d %I:%M:%S %p", tz = "")
raw_CN1_temp$datetime <- as.POSIXct(raw_CN1_temp$TIMESTAMP, "%Y/%m/%d %I:%M:%S %p", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
head(raw_CN1_sal)
```

    ## # A tibble: 6 × 14
    ##   WATERBODY  STATION LEASE LATITUDE LONGITUDE DEPLOYMENT_PERIOD TIMESTAMP SENSOR
    ##   <chr>      <chr>   <lgl>    <dbl>     <dbl> <chr>             <chr>     <chr> 
    ## 1 Lobster B… Ram Is… NA        43.7     -65.8 2020-Jun-22 to 2… 2020/06/… aquaM…
    ## 2 Lobster B… Ram Is… NA        43.7     -65.8 2020-Jun-22 to 2… 2020/06/… aquaM…
    ## 3 Lobster B… Ram Is… NA        43.7     -65.8 2020-Jun-22 to 2… 2020/06/… aquaM…
    ## 4 Lobster B… Ram Is… NA        43.7     -65.8 2020-Jun-22 to 2… 2020/06/… aquaM…
    ## 5 Lobster B… Ram Is… NA        43.7     -65.8 2020-Jun-22 to 2… 2020/06/… aquaM…
    ## 6 Lobster B… Ram Is… NA        43.7     -65.8 2020-Jun-22 to 2… 2020/06/… aquaM…
    ## # ℹ 6 more variables: DEPTH <dbl>, VARIABLE <chr>, VALUE <dbl>, UNITS <chr>,
    ## #   MOORING <chr>, datetime <dttm>

``` r
head(raw_CN1_temp)
```

    ## # A tibble: 6 × 14
    ##   WATERBODY  STATION LEASE LATITUDE LONGITUDE DEPLOYMENT_PERIOD TIMESTAMP SENSOR
    ##   <chr>      <chr>   <lgl>    <dbl>     <dbl> <chr>             <chr>     <chr> 
    ## 1 Lobster B… Morris… NA        43.8     -65.9 2020-Jun-16 to 2… 2020/06/… aquaM…
    ## 2 Lobster B… Morris… NA        43.8     -65.9 2020-Jun-16 to 2… 2020/06/… aquaM…
    ## 3 Lobster B… Morris… NA        43.8     -65.9 2020-Jun-16 to 2… 2020/06/… aquaM…
    ## 4 Lobster B… Morris… NA        43.8     -65.9 2020-Jun-16 to 2… 2020/06/… aquaM…
    ## 5 Lobster B… Morris… NA        43.8     -65.9 2020-Jun-16 to 2… 2020/06/… aquaM…
    ## 6 Lobster B… Morris… NA        43.8     -65.9 2020-Jun-16 to 2… 2020/06/… aquaM…
    ## # ℹ 6 more variables: DEPTH <dbl>, VARIABLE <chr>, VALUE <dbl>, UNITS <chr>,
    ## #   MOORING <chr>, datetime <dttm>

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_CN1_sal <- raw_CN1_sal %>% rename("salinity" = "VALUE")
raw_CN1_temp <- raw_CN1_temp  %>% rename("temp" = "VALUE")

#Store variables that we will include in the final data frame
lat <- 43.79075
lon <- -65.83619
firstyear <- 2020
finalyear <- 2021
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_CN1_sal <- raw_CN1_sal %>%
    filter(between(salinity, 0, 42)) 
           
filtered_CN1_temp <- raw_CN1_temp %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_CN1_sal$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   13.60   25.30   27.50   26.91   29.30   32.90

``` r
print(summary(filtered_CN1_temp$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    5.82   12.48   11.84   18.57   24.04

``` r
#Store our data into a variable name with just the site name. 
CN1_temp <- filtered_CN1_temp
CN1_sal <- filtered_CN1_sal


# we have NAs in the our salinity data frame in the datetime column - need to remove these
count.nas_sal <- is.na(CN1_sal$datetime) # store our NAs in a variable
summary(count.nas_sal) # we have 12 NAs that are stored as "TRUE" in our count.nas
```

    ##    Mode   FALSE    TRUE 
    ## logical  104893      12

``` r
nrow(CN1_sal) # figure out how many rows we have in the original df: 104905
```

    ## [1] 104905

``` r
which(count.nas_sal == TRUE) # find the number of NA rows that we need to remove: 12
```

    ##  [1] 38074 38075 38076 38077 38078 38079 90414 90415 90416 90417 90418 90419

``` r
CN1_sal <- CN1_sal[-c(38074, 38075, 38076, 38077, 38078, 38079, 
                      90414, 90415, 90416, 90417, 90418, 90419), ] # remove the rows
nrow(CN1_sal) # check the new number of rows in the dataframe with the NAs removed
```

    ## [1] 104893

``` r
check_sal <- 104905-104893 # the value of check should be 12
check_sal # cool, we removed the 12 NA rows!
```

    ## [1] 12

``` r
# we have NAs in the our temperature data frame in the datetime column - need to remove these
count.nas_temp <- is.na(CN1_temp$datetime) # store our NAs in a variable
summary(count.nas_temp) # we have 6 NAs that are stored as "TRUE" in our count.nas
```

    ##    Mode   FALSE    TRUE 
    ## logical   56628       6

``` r
nrow(CN1_temp) # figure out how many rows we have in the original df: 56634
```

    ## [1] 56634

``` r
which(count.nas_temp == TRUE) # find the number of NA rows that we need to remove: 6
```

    ## [1] 38266 38267 38268 38269 38270 38271

``` r
CN1_temp <- CN1_temp[-c(38266, 38267, 38268, 38269, 38270, 38271), ] # remove the rows
nrow(CN1_temp) # check the new number of rows in the dataframe with the NAs removed
```

    ## [1] 56628

``` r
check_temp <- 56634-56628 # the value of check should be 12
check_temp # cool, we removed the 6 NA rows!
```

    ## [1] 6

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(CN1_sal, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for CN1 - Salt Bay, Canada") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](CN1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(CN1_temp, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for CN1 - Salt Bay, Canada") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](CN1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
CN1_envrmonth_sal <- CN1_sal %>%
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
CN1_envrmonth_temp <- CN1_temp %>%
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
print(CN1_envrmonth_sal)
```

    ## # A tibble: 25 × 6
    ## # Groups:   year [3]
    ##     year month min_salinity max_salinity mean_salinity length_salinity
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ##  1  2020     6         31.7         32.5          32.2            1197
    ##  2  2020     7         29.6         32.5          31.3            4464
    ##  3  2020     8         29.1         29.9          29.3            4464
    ##  4  2020     9         28.3         29.7          29.1            4320
    ##  5  2020    10         26.3         29.3          28.8            4464
    ##  6  2020    11         26.3         28.4          27.3            4320
    ##  7  2020    12         24.6         27.5          25.9            4464
    ##  8  2021     1         24.5         26.8          25.5            4464
    ##  9  2021     2         24.2         26.7          25.0            4032
    ## 10  2021     3         25.7         28.4          27.4            4458
    ## # ℹ 15 more rows

``` r
print(CN1_envrmonth_temp)
```

    ## # A tibble: 14 × 6
    ## # Groups:   year [2]
    ##     year month min_temp max_temp mean_temp length_temp
    ##    <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ##  1  2020     6    15.2     21.2      18.5         2052
    ##  2  2020     7    17.4     23.7      20.1         4464
    ##  3  2020     8    18.0     24.0      20.7         4464
    ##  4  2020     9    13.0     21.4      17.5         4301
    ##  5  2020    10     8.76    18.3      14.2         4464
    ##  6  2020    11     5.8     12.4       8.87        4320
    ##  7  2020    12     1.63    10.4       6.08        4464
    ##  8  2021     1     0.03     4.62      2.64        4451
    ##  9  2021     2     0        2.9       1.14        3737
    ## 10  2021     3     0        7.38      2.85        4121
    ## 11  2021     4     4.86    12.1       8.18        4320
    ## 12  2021     5     8.98    16.1      12.3         4464
    ## 13  2021     6    12.7     22.1      17.5         4320
    ## 14  2021     7    17.4     22.7      19.6         2686

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
CN1_envryear_sal <- CN1_sal %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

CN1_envryear_temp <- CN1_temp %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(CN1_envryear_sal)
```

    ## # A tibble: 3 × 4
    ##    year min_salinity max_salinity mean_salinity
    ##   <dbl>        <dbl>        <dbl>         <dbl>
    ## 1  2020         24.6         32.5          28.8
    ## 2  2021         13.7         32.9          27.1
    ## 3  2022         13.6         29.8          24.4

``` r
print(CN1_envryear_temp)
```

    ## # A tibble: 2 × 4
    ##    year min_temp max_temp mean_temp
    ##   <dbl>    <dbl>    <dbl>     <dbl>
    ## 1  2020     1.63     24.0     14.9 
    ## 2  2021     0        22.7      8.76

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(CN1_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for CN1 - Salt Bay, Canada") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](CN1-EnvrData_files/figure-gfm/timeplot%20-%20salinity-1.png)<!-- -->

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(CN1_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for CN1 - Salt Bay, Canada") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](CN1-EnvrData_files/figure-gfm/timeplot%20-%20temperature-1.png)<!-- -->

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
#Calculate temperature variables. 
Mean_Annual_Temperature_C <- mean(CN1_temp$temp)
Mean_max_temperature_C <- mean(CN1_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(CN1_envryear_temp$min_temp)
Temperature_st_dev <- sd(CN1_temp$temp)
Temperature_n <- nrow(CN1_temp)
Temperature_years <- nrow(CN1_envryear_temp)

#Create a data frame to store the temperature results
CN1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(CN1_temp)
```

    ##      site_name download_date source_description                   lat       
    ## [1,] "CN1"     "03-25-2024"  "Nova Scotia Gov Water Quality Data" "43.79075"
    ##      lon         firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "-65.83619" "2020"    "2021"    "11.8402710673165"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "23.37"                "0.815"                "6.95872212941284"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "56628"       "2"               "continuous"

``` r
# Write to the combined file with all sites 
write.table(CN1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(CN1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/CN1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(CN1_sal$salinity)
Mean_max_Salinity_ppt <- mean(CN1_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(CN1_envryear_sal$min_salinity)
Salinity_st_dev <- sd(CN1_sal$salinity)
Salinity_n <- nrow(CN1_sal)
Salinity_years <- nrow(CN1_envryear_sal)


#Create a data frame to store the temperature results
CN1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(CN1_salinity)
```

    ##      site_name download_date source_description                   lat       
    ## [1,] "CN1"     "03-25-2024"  "Nova Scotia Gov Water Quality Data" "43.79075"
    ##      lon         firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "-65.83619" "2020"    "2021"    "26.9132353922569"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "31.7333333333333"    "17.3"                "3.49429194890227" "104893"  
    ##      Salinity_years collection_type
    ## [1,] "3"            "continuous"

``` r
# Write to the combined file with all sites 
write.table(CN1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(CN1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/CN1_salinity.csv", row.names = FALSE)
```
