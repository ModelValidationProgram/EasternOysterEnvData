SC2 - Processed Environmental Data
================
Madeline Eppley
7/6/2023

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
#Data was downloaded on 7/6/2023
#Source - http://bccmws.coastal.edu/volunteermonitoring/index.html
#The site was sampled three times per month in a set of 3 replicates. Thus, we have one true data point of salinity and temperature per month. Instead of downloading the raw file with triplicates, the averaged file was used.

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("07-06-2023")
source_description <- ("BCCWMS Coastal Volunteer Monitoring Data")
site_name <- ("SC2") #Use site code with site number based on lat position and state
collection_type <- ("intermittent_bimonthly")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Oyster Landing, South Carolina. The ID_Site for this site is OL_MI_SC. 
raw_SC2 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/SC2-raw.csv")
```

    ## Rows: 326 Columns: 9
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (2): lab_sample_id, site_name
    ## dbl  (5): site_id, latitude, longitude, salinity_ppt, temp_do
    ## date (1): collection_date
    ## time (1): collection_time
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_SC2)
```

    ## cols(
    ##   lab_sample_id = col_character(),
    ##   site_id = col_double(),
    ##   site_name = col_character(),
    ##   latitude = col_double(),
    ##   longitude = col_double(),
    ##   collection_date = col_date(format = ""),
    ##   collection_time = col_time(format = ""),
    ##   salinity_ppt = col_double(),
    ##   temp_do = col_double()
    ## )

``` r
View(raw_SC2)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
combined_datetime <- paste(raw_SC2$collection_date, raw_SC2$collection_time)

#Convert to POSIXct format. Store it into a column named datetime in the data frame. Use the year-month-day hours:minutes:seconds format. 
raw_SC2$datetime <- as.POSIXct(combined_datetime, format = "%Y-%m-%d %H:%M:%S")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
print(raw_SC2)
```

    ## # A tibble: 326 × 10
    ##    lab_sample_id site_id site_name            latitude longitude collection_date
    ##    <chr>           <dbl> <chr>                   <dbl>     <dbl> <date>         
    ##  1 VM_MI_08_0012       8 Oyster Landing Beach     33.5     -79.1 2008-06-10     
    ##  2 VM_MI_08_0020       8 Oyster Landing Beach     33.5     -79.1 2008-06-24     
    ##  3 VM_MI_08_0028       8 Oyster Landing Beach     33.5     -79.1 2008-07-08     
    ##  4 VM_MI_08_0036       8 Oyster Landing Beach     33.5     -79.1 2008-07-22     
    ##  5 VM_MI_08_0044       8 Oyster Landing Beach     33.5     -79.1 2008-08-12     
    ##  6 VM_MI_08_0052       8 Oyster Landing Beach     33.5     -79.1 2008-08-26     
    ##  7 VM_MI_08_0060       8 Oyster Landing Beach     33.5     -79.1 2008-09-09     
    ##  8 VM_MI_08_0068       8 Oyster Landing Beach     33.5     -79.1 2008-09-23     
    ##  9 VM_MI_08_0076       8 Oyster Landing Beach     33.5     -79.1 2008-10-14     
    ## 10 VM_MI_08_0084       8 Oyster Landing Beach     33.5     -79.1 2008-10-28     
    ## # ℹ 316 more rows
    ## # ℹ 4 more variables: collection_time <time>, salinity_ppt <dbl>,
    ## #   temp_do <dbl>, datetime <dttm>

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_SC2 <- raw_SC2 %>% rename("temp" = "temp_do", "salinity" = "salinity_ppt", "lat" = "latitude", "lon" = "longitude")

#Print the range (minimum and maximum) of dates of data collection. 
print(range(raw_SC2$datetime))
```

    ## [1] "2008-06-10 14:20:00 EDT" "2022-05-24 09:00:00 EDT"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(range(raw_SC2$salinity))
```

    ## [1] NA NA

``` r
#Print the range (minimum and maximum) of the temperature values.
print(range(raw_SC2$temp))
```

    ## [1] NA NA

``` r
#Print the range (minimum and maximum) of the latitude values. 
print(range(raw_SC2$lat))
```

    ## [1] 33.52401 33.52401

``` r
#Print the range (minimum and maximum) of the longitude values. 
print(range(raw_SC2$lon))
```

    ## [1] -79.06198 -79.06198

``` r
#Store variables that we will include in the final data frame
lat <- 33.52401
lon <- -79.06198
firstyear <- 2008
finalyear <- 2022
```

### We can see that some of the values make sense - the minimum and maximum latitude and longitude values are the same. However, there are values that we need to filter out of the temperature and salinity since we have -99999.00’s.

Filter any of the variables that have data points outside of normal
range. We will use 0-40 as the accepted range for salinity (ppt) and
temperature (C) values. Note, in the summer, salinity values can
sometimes exceed 40. Check to see if there are values above 40. In this
case, adjust the range or notify someone that the site has particularly
high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_SC2 <- raw_SC2 %>%
    filter(between(salinity, 0, 40) & between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_SC2$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   24.73   33.46   34.26   34.08   35.00   36.92

``` r
print(summary(filtered_SC2$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   4.233  13.817  20.300  19.982  26.700  30.167

``` r
#Store our data into a variable name with just the site name. 
SC2 <- filtered_SC2
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
envrplot <- ggplot(SC2, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Range of environmental variables", title = "Environmental Plot for SC2 - Oyster Landing") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue", "Temperature (C)" = "red")) +
    theme_minimal()


envrplot
```

![](SC2-EnvrData_files/figure-gfm/environment-plot-1.png)<!-- -->

``` r
salplot <- ggplot(SC2, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for SC2 - Oyster Landing") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](SC2-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(SC2, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for SC2 - Oyster Landing") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](SC2-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
SC2_envrmonth <- SC2 %>%
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
print(SC2_envrmonth)
```

    ## # A tibble: 167 × 10
    ## # Groups:   year [15]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2008     6         34.7         34.9          34.8               2    28.1 
    ##  2  2008     7         34.7         35.5          35.1               2    28.2 
    ##  3  2008     8         33.7         36.1          34.9               2    28.0 
    ##  4  2008     9         33.3         35.1          34.2               2    21.7 
    ##  5  2008    10         34.5         34.5          34.5               2    15   
    ##  6  2008    11         34.3         34.8          34.5               2    13.8 
    ##  7  2008    12         34.2         34.5          34.3               2    11.9 
    ##  8  2009     1         33.7         33.7          33.7               2     9.27
    ##  9  2009     2         33.3         34.3          33.8               2     9.1 
    ## 10  2009     3         33.2         33.8          33.5               2    12.7 
    ## # ℹ 157 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
SC2_envryear <- SC2 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(SC2_envryear)
```

    ## # A tibble: 15 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2008         33.3         36.1          34.6    11.9      29.7      22.6
    ##  2  2009         32.9         36.3          34.5     9.1      29.0      20.1
    ##  3  2010         26.6         36.1          33.8     5.3      30.2      19.2
    ##  4  2011         32.6         36.4          34.8     4.23     28.9      19.9
    ##  5  2012         33.4         36.1          35.0     9.6      29.3      19.8
    ##  6  2013         32.4         35            34.1     9.6      28.5      18.9
    ##  7  2014         32.6         36            34.3     7.4      28.4      19.7
    ##  8  2015         28.9         36.2          33.6     5.7      29.9      20.3
    ##  9  2016         31.1         36.3          33.3     8.37     29.6      20.5
    ## 10  2017         33.1         36.9          34.7    12.7      29.2      21.4
    ## 11  2018         24.7         35.5          33.2     6.23     28.5      19.2
    ## 12  2019         31.0         35.7          33.4     9.4      29.9      20.7
    ## 13  2020         29.8         35.3          33.5    10.4      28.5      20.5
    ## 14  2021         30.0         35.9          34.0    10.1      29        20.0
    ## 15  2022         33.7         35.5          34.8     8.33     25.8      16.1

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(SC2_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for SC2 - Oyster Landing") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](SC2-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(SC2$temp)
Mean_max_temperature_C <- mean(SC2_envryear$max_temp)
Mean_min_temperature_C <- mean(SC2_envryear$min_temp)
Temperature_st_dev <- sd(SC2$temp)
Temperature_n <- nrow(SC2)
Temperature_years <- nrow(SC2_envryear)

#Create a data frame to store the temperature results
SC2_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(SC2_temp)
```

    ##      site_name download_date source_description                        
    ## [1,] "SC2"     "07-06-2023"  "BCCWMS Coastal Volunteer Monitoring Data"
    ##      lat        lon         firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "33.52401" "-79.06198" "2008"    "2022"    "19.9819453044376"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "28.9577777777778"     "8.55777777777778"     "6.82921337760818"
    ##      Temperature_n Temperature_years collection_type         
    ## [1,] "323"         "15"              "intermittent_bimonthly"

``` r
write.table(SC2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = TRUE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame
```

    ## Warning in write.table(SC2_temp,
    ## "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", :
    ## appending column names to file

``` r
# Write to a unique new CSV file
write.csv(SC2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/SC2_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(SC2$salinity)
Mean_max_Salinity_ppt <- mean(SC2_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(SC2_envryear$min_salinity)
Salinity_st_dev <- sd(SC2$salinity)
Salinity_n <- nrow(SC2)
Salinity_years <- nrow(SC2_envryear)


#Create a data frame to store the temperature results
SC2_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(SC2_salinity)
```

    ##      site_name download_date source_description                        
    ## [1,] "SC2"     "07-06-2023"  "BCCWMS Coastal Volunteer Monitoring Data"
    ##      lat        lon         firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "33.52401" "-79.06198" "2008"    "2022"    "34.07826625387"        
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "35.9655555555556"    "31.0724444444444"    "1.44934387143534" "323"     
    ##      Salinity_years collection_type         
    ## [1,] "15"           "intermittent_bimonthly"

``` r
write.table(SC2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = TRUE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame
```

    ## Warning in write.table(SC2_salinity,
    ## "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", :
    ## appending column names to file

``` r
# Write to a unique new CSV file
write.csv(SC2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/SC2_salinity.csv")
```
