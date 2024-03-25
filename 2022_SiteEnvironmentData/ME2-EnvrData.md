ME2 - Processed Environmental Data
================
Madeline Eppley
3/21/2024

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
#Data was downloaded on 3/21/2024 from UMaine Loboviz 
#Source - University of Maine http://maine.loboviz.com/ and http://maine.loboviz.com/cgi-lobo/lobo
#The site was sampled intermittently

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("03-21-2024")
source_description <- ("University of Maine")
site_name <- ("ME2") #Use site code with site number based on lat position and state
collection_type <- ("intermittent")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from the Upper Damariscotta Estuary. The ID_Site for this site is ME2. 
raw_ME2 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/ME2-raw.csv")
```

    ## Rows: 26314 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1): Timestamp
    ## dbl (2): salinity, temperature
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_ME2)
```

    ## cols(
    ##   Timestamp = col_character(),
    ##   salinity = col_double(),
    ##   temperature = col_double()
    ## )

``` r
#View(raw_ME2)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_ME2$datetime <- as.POSIXct(raw_ME2$Timestamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
head(raw_ME2)
```

    ## # A tibble: 6 × 4
    ##   Timestamp     salinity temperature datetime           
    ##   <chr>            <dbl>       <dbl> <dttm>             
    ## 1 9/25/15 16:00     31.4        19.1 2015-09-25 16:00:00
    ## 2 9/25/15 17:00     31.4        19.0 2015-09-25 17:00:00
    ## 3 9/25/15 18:00     31.5        18.7 2015-09-25 18:00:00
    ## 4 9/25/15 19:00     31.6        18.2 2015-09-25 19:00:00
    ## 5 9/25/15 20:00     31.6        18.0 2015-09-25 20:00:00
    ## 6 9/25/15 21:00     31.6        17.7 2015-09-25 21:00:00

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_ME2 <- raw_ME2 %>% rename("salinity" = "salinity")
raw_ME2 <- raw_ME2  %>% rename("temp" = "temperature")

#Store variables that we will include in the final data frame
lat <- 43.986
lon <- -69.55
firstyear <- 2015
finalyear <- 2023
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_ME2 <- raw_ME2 %>%
    filter(between(salinity, 0, 42)) 
           
filtered_ME2 <- raw_ME2 %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_ME2$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   28.61   30.19   29.48   30.92   32.39

``` r
print(summary(filtered_ME2$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.68   10.85   16.27   15.33   19.83   26.15

``` r
#Store our data into a variable name with just the site name. 
ME2 <- filtered_ME2

# check if we we have NAs in the our salinity data frame in the datetime column
count.nas_datetime <- is.na(ME2$datetime) # store our NAs in a variable
summary(count.nas_datetime) # no, we don't have any NAs, so we are good to go
```

    ##    Mode   FALSE 
    ## logical   26314

``` r
count.nas_temp <- is.na(ME2$temp)
summary(count.nas_temp) # no, we don't have any NAs, so we are good to go
```

    ##    Mode   FALSE 
    ## logical   26314

``` r
count.nas_sal <- is.na(ME2$salinity)
summary(count.nas_sal) # no, we don't have any NAs, so we are good to go
```

    ##    Mode   FALSE 
    ## logical   26314

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(ME2, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for ME2 - Damariscotta Estuary") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](ME2-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(ME2, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for ME2 - Damariscotta Estuary") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](ME2-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
ME2_envrmonth_sal <- ME2 %>%
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
ME2_envrmonth_temp <- ME2 %>%
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
print(ME2_envrmonth_sal)
```

    ## # A tibble: 46 × 6
    ## # Groups:   year [7]
    ##     year month min_salinity max_salinity mean_salinity length_salinity
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ##  1  2015     9        28.1          31.7          31.4             128
    ##  2  2015    10        25.5          31.4          29.5             724
    ##  3  2015    11        24.5          30.7          28.9             543
    ##  4  2016     4         0.02         29.0          28.0             275
    ##  5  2016     5        27.6          30.3          29.1             744
    ##  6  2016     6         0.15         30.8          29.9             720
    ##  7  2016     7         0.4          31.4          30.8             744
    ##  8  2016     8         0.35         31.7          31.4             744
    ##  9  2016     9         0.3          32.2          31.8             720
    ## 10  2016    10        31.5          32.3          32.1             744
    ## # ℹ 36 more rows

``` r
print(ME2_envrmonth_temp)
```

    ## # A tibble: 46 × 6
    ## # Groups:   year [7]
    ##     year month min_temp max_temp mean_temp length_temp
    ##    <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ##  1  2015     9    16.9      19.1     17.8          128
    ##  2  2015    10     9.13     17.3     13.0          724
    ##  3  2015    11     6.5      11.6      9.46         543
    ##  4  2016     4     7.55     17.0      9.51         275
    ##  5  2016     5     8.93     18.4     12.5          744
    ##  6  2016     6    13.2      22.0     17.6          720
    ##  7  2016     7    17.6      24.3     21.2          744
    ##  8  2016     8    20.3      24.3     22.0          744
    ##  9  2016     9    16.0      22.9     19.3          720
    ## 10  2016    10     9.8      16.7     14.1          744
    ## # ℹ 36 more rows

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
ME2_envryear_sal <- ME2 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

ME2_envryear_temp <- ME2 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(ME2_envryear_sal)
```

    ## # A tibble: 7 × 4
    ##    year min_salinity max_salinity mean_salinity
    ##   <dbl>        <dbl>        <dbl>         <dbl>
    ## 1  2015        24.5          31.7          29.4
    ## 2  2016         0.02         32.4          30.8
    ## 3  2017         0.01         31.7          30.6
    ## 4  2018         0            31.4          29.0
    ## 5  2019        22.0          31.4          29.5
    ## 6  2021        14.6          31.1          28.9
    ## 7  2022         0.01         30.8          27.2

``` r
print(ME2_envryear_temp)
```

    ## # A tibble: 7 × 4
    ##    year min_temp max_temp mean_temp
    ##   <dbl>    <dbl>    <dbl>     <dbl>
    ## 1  2015     6.5      19.1      12.1
    ## 2  2016     7.55     24.3      16.6
    ## 3  2017     4.47     23.7      16.9
    ## 4  2018     2.08     26.2      15.6
    ## 5  2019     4        24.2      16.6
    ## 6  2021     1.68     23.8      14.1
    ## 7  2022     1.87     22.9      12.0

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(ME2_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for ME2 - Damariscotta Estuary") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](ME2-EnvrData_files/figure-gfm/timeplot%20-%20salinity-1.png)<!-- -->

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(ME2_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for ME2 - Damariscotta Estuary") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](ME2-EnvrData_files/figure-gfm/timeplot%20-%20temperature-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(ME2$temp)
Mean_max_temperature_C <- mean(ME2_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(ME2_envryear_temp$min_temp)
Temperature_st_dev <- sd(ME2$temp)
Temperature_n <- nrow(ME2)
Temperature_years <- nrow(ME2_envryear_temp)

#Create a data frame to store the temperature results
ME2_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(ME2_temp)
```

    ##      site_name download_date source_description    lat      lon      firstyear
    ## [1,] "ME2"     "03-21-2024"  "University of Maine" "43.986" "-69.55" "2015"   
    ##      finalyear Mean_Annual_Temperature_C Mean_max_temperature_C
    ## [1,] "2023"    "15.3288717032758"        "23.46"               
    ##      Mean_min_temperature_C Temperature_st_dev Temperature_n Temperature_years
    ## [1,] "4.02142857142857"     "5.22149721972098" "26314"       "7"              
    ##      collection_type
    ## [1,] "intermittent"

``` r
# Write to the combined file with all sites 
write.table(ME2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(ME2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/ME2_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(ME2$salinity)
Mean_max_Salinity_ppt <- mean(ME2_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(ME2_envryear_sal$min_salinity)
Salinity_st_dev <- sd(ME2$salinity)
Salinity_n <- nrow(ME2)
Salinity_years <- nrow(ME2_envryear_sal)


#Create a data frame to store the temperature results
ME2_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(ME2_salinity)
```

    ##      site_name download_date source_description    lat      lon      firstyear
    ## [1,] "ME2"     "03-21-2024"  "University of Maine" "43.986" "-69.55" "2015"   
    ##      finalyear Mean_Annual_Salinity_ppt Mean_max_Salinity_ppt
    ## [1,] "2023"    "29.4782830432469"       "31.5042857142857"   
    ##      Mean_min_Salinity_ppt Salinity_st_dev   Salinity_n Salinity_years
    ## [1,] "8.74142857142857"    "2.2778779612237" "26314"    "7"           
    ##      collection_type
    ## [1,] "intermittent"

``` r
# Write to the combined file with all sites 
write.table(ME2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(ME2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/ME2_salinity.csv", row.names = FALSE)
```
