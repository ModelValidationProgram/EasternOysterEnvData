NJ2 - Processed Environmental Data
================
Madeline Eppley
8/18/2023

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
#Data was downloaded on 8/18/2023
#Source - https://cema.udel.edu/applications/waterquality/
#The site was sampled once per month, on average, at random (not the same day every month). 

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("08-18-2023")
source_description <- ("Delaware Water Quality - CEMA at University of Delaware")
site_name <- ("NJ2") #Use site code with site number based on lat position and state
collection_type <- ("monthly")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Hope Creek, NJ. 
raw_NJ2 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/NJ2-raw.csv")
```

    ## Rows: 153 Columns: 38
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (28): station_id, tss_result_type, tss_detection_condition, tss_units, ...
    ## dbl   (9): tss_value, salinity_value, water_temp_value, enterococcus_value, ...
    ## dttm  (1): timestamp
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_NJ2)
```

    ## cols(
    ##   station_id = col_character(),
    ##   timestamp = col_datetime(format = ""),
    ##   tss_result_type = col_character(),
    ##   tss_detection_condition = col_character(),
    ##   tss_value = col_double(),
    ##   tss_units = col_character(),
    ##   salinity_result_type = col_character(),
    ##   salinity_detection_condition = col_character(),
    ##   salinity_value = col_double(),
    ##   salinity_units = col_character(),
    ##   water_temp_result_type = col_character(),
    ##   water_temp_detection_condition = col_character(),
    ##   water_temp_value = col_double(),
    ##   water_temp_units = col_character(),
    ##   enterococcus_result_type = col_character(),
    ##   enterococcus_detection_condition = col_character(),
    ##   enterococcus_value = col_double(),
    ##   enterococcus_units = col_character(),
    ##   chlora_result_type = col_character(),
    ##   chlora_detection_condition = col_character(),
    ##   chlora_value = col_double(),
    ##   chlora_units = col_character(),
    ##   phosphate_phosphorus_result_type = col_character(),
    ##   phosphate_phosphorus_detection_condition = col_character(),
    ##   phosphate_phosphorus_value = col_double(),
    ##   phosphate_phosphorus_units = col_character(),
    ##   ph_result_type = col_character(),
    ##   ph_detection_condition = col_character(),
    ##   ph_value = col_double(),
    ##   ph_units = col_character(),
    ##   nutrient_nitrogen_result_type = col_character(),
    ##   nutrient_nitrogen_detection_condition = col_character(),
    ##   nutrient_nitrogen_value = col_double(),
    ##   nutrient_nitrogen_units = col_character(),
    ##   do_result_type = col_character(),
    ##   do_detection_condition = col_character(),
    ##   do_value = col_double(),
    ##   do_units = col_character()
    ## )

``` r
View(raw_NJ2)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame. Use the year-month-day hours:minutes:seconds format. 
raw_NJ2$datetime <- as.POSIXct(raw_NJ2$timestamp, format = "%z-%m-%d %I:%M:%S")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
print(raw_NJ2)
```

    ## # A tibble: 153 × 39
    ##    station_id         timestamp           tss_result_type tss_detection_condit…¹
    ##    <chr>              <dttm>              <chr>           <chr>                 
    ##  1 31DELRBC_WQX-0910… 2010-04-20 08:37:00 Actual          Detected              
    ##  2 31DELRBC_WQX-0910… 2010-09-27 08:35:00 Actual          Detected              
    ##  3 31DELRBC_WQX-0910… 2010-08-30 08:36:00 Actual          Detected              
    ##  4 31DELRBC_WQX-0910… 2010-06-22 00:00:00 Actual          Detected              
    ##  5 31DELRBC_WQX-0910… 2010-10-25 08:30:00 Actual          Detected              
    ##  6 31DELRBC_WQX-0910… 2010-03-22 08:37:00 Actual          Detected              
    ##  7 31DELRBC_WQX-0910… 2010-05-25 08:33:00 Actual          Detected              
    ##  8 31DELRBC_WQX-0910… 2010-07-20 10:43:00 Actual          Detected              
    ##  9 31DELRBC_WQX-0910… 2011-06-21 08:39:00 Actual          Detected              
    ## 10 31DELRBC_WQX-0910… 2011-05-24 08:58:00 Actual          Detected              
    ## # ℹ 143 more rows
    ## # ℹ abbreviated name: ¹​tss_detection_condition
    ## # ℹ 35 more variables: tss_value <dbl>, tss_units <chr>,
    ## #   salinity_result_type <chr>, salinity_detection_condition <chr>,
    ## #   salinity_value <dbl>, salinity_units <chr>, water_temp_result_type <chr>,
    ## #   water_temp_detection_condition <chr>, water_temp_value <dbl>,
    ## #   water_temp_units <chr>, enterococcus_result_type <chr>, …

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_NJ2 <- raw_NJ2 %>% rename("temp" = "water_temp_value", "salinity" = "salinity_value")

#Remove some rows that have NA's
raw_NJ2 <- raw_NJ2[-c(117, 129, 130),]

#Print the range (minimum and maximum) of dates of data collection. 
print(range(raw_NJ2$datetime))
```

    ## [1] "2005-04-05 08:18:00 UTC" "2022-10-10 08:21:00 UTC"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(range(raw_NJ2$salinity))
```

    ## [1]  0.05 12.87

``` r
#Print the range (minimum and maximum) of the temperature values.
print(range(raw_NJ2$temp))
```

    ## [1]  3.07 28.30

``` r
#Store variables that we will include in the final data frame
lat <- 39.455
lon <- -75.560
firstyear <- 2005
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_NJ2 <- raw_NJ2 %>%
    filter(between(salinity, 0, 40) & between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_NJ2$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.050   3.248   6.060   5.850   8.370  12.870

``` r
print(summary(filtered_NJ2$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    3.07   14.73   20.95   18.91   24.53   28.30

``` r
#Store our data into a variable name with just the site name. 
NJ2 <- filtered_NJ2
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(NJ2, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for NJ2 - Hope Creek") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](NJ2-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(NJ2, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for NJ2 - Hope Creek") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](NJ2-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
NJ2_envrmonth <- NJ2 %>%
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
print(NJ2_envrmonth)
```

    ## # A tibble: 136 × 10
    ## # Groups:   year [18]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2005     4         0.12         3.27          1.70               2     7.81
    ##  2  2005     5         3.44         6.1           4.77               2    15.0 
    ##  3  2005     6         6.6          9.36          7.98               2    24.5 
    ##  4  2005     7         7.74         7.74          7.74               1    25.3 
    ##  5  2005     8         7.72         8.01          7.86               2    27.0 
    ##  6  2005     9         9.36         9.78          9.57               2    22.4 
    ##  7  2005    10         7.55         7.55          7.55               1    12.6 
    ##  8  2006     3         9.67         9.67          9.67               1     6.39
    ##  9  2006     4         9.63        11.6          10.6                2    10.5 
    ## 10  2006     5         6.44         9.75          8.10               2    17.2 
    ## # ℹ 126 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
NJ2_envryear <- NJ2 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(NJ2_envryear)
```

    ## # A tibble: 18 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2005         0.12         9.78          6.59     7.81     27.1      20.0
    ##  2  2006         1.83        11.6           7.84     6.39     28.3      19.2
    ##  3  2007         0.17        10.7           6.10     9.21     27.1      20.4
    ##  4  2008         1.72        12.3           7.20     6.86     27.7      18.5
    ##  5  2009         2.05        10.1           5.34     8.15     26.8      18.0
    ##  6  2010         1.48        11.4           6.80    10.8      27.4      20.1
    ##  7  2011         0.05         5.67          2.05    14.7      27.3      21.5
    ##  8  2012         2.74         8.73          7.04    12.9      26.1      20.7
    ##  9  2013         1.86        12.9           6.52    12.0      27.8      20.0
    ## 10  2014         1.87        10.3           5.30    10.3      26.6      19.9
    ## 11  2015         1.45         9.35          4.97    13.4      25.9      21.6
    ## 12  2016         3.57        12.4           7.58    12.3      27.8      21.2
    ## 13  2017         0.4         10.6           5.70     3.24     25.1      14.7
    ## 14  2018         0.26         6.64          3.20     4.63     27.0      17.8
    ## 15  2019         0.23        12.1           4.68     3.07     27.0      15.6
    ## 16  2020         2.2          7.51          5.30     5.13     27.1      16.4
    ## 17  2021         1.32         7.77          5.21     5.91     26.6      19.7
    ## 18  2022        10.1         10.9          10.5     15.1      23.8      19.5

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(NJ2_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for NJ2 - Hope Creek") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](NJ2-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(NJ2$temp)
Mean_max_temperature_C <- mean(NJ2_envryear$max_temp)
Mean_min_temperature_C <- mean(NJ2_envryear$min_temp)
Temperature_st_dev <- sd(NJ2$temp)
Temperature_n <- nrow(NJ2)
Temperature_years <- nrow(NJ2_envryear)

#Create a data frame to store the temperature results
NJ2_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(NJ2_temp)
```

    ##      site_name download_date
    ## [1,] "NJ2"     "08-18-2023" 
    ##      source_description                                        lat     
    ## [1,] "Delaware Water Quality - CEMA at University of Delaware" "39.455"
    ##      lon      firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "-75.56" "2005"    "2022"    "18.911"                 
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "26.8133333333333"     "8.99666666666667"     "6.8274642526201" 
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "150"         "18"              "monthly"

``` r
write.table(NJ2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE)

# Write to a unique new CSV file
write.csv(NJ2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/NJ2_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(NJ2$salinity)
Mean_max_Salinity_ppt <- mean(NJ2_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(NJ2_envryear$min_salinity)
Salinity_st_dev <- sd(NJ2$salinity)
Salinity_n <- nrow(NJ2)
Salinity_years <- nrow(NJ2_envryear)


#Create a data frame to store the temperature results
NJ2_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(NJ2_salinity)
```

    ##      site_name download_date
    ## [1,] "NJ2"     "08-18-2023" 
    ##      source_description                                        lat     
    ## [1,] "Delaware Water Quality - CEMA at University of Delaware" "39.455"
    ##      lon      firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "-75.56" "2005"    "2022"    "5.84973333333333"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "10.04"               "1.85777777777778"    "3.29123178154031" "150"     
    ##      Salinity_years collection_type
    ## [1,] "18"           "monthly"

``` r
write.table(NJ2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) 

# Write to a unique new CSV file
write.csv(NJ2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/NJ2_salinity.csv")
```
