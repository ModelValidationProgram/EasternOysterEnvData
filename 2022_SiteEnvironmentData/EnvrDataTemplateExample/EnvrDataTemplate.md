Environmental Data Extraction Template
================
Madeline Eppley
5/30/2023

``` r
setwd("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/EnvrDataTemplateExample")
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
#Data was downloaded on 2/7/2023
#Source - http://bccmws.coastal.edu/volunteermonitoring/index.html
#The site was sampled three times per month in a set of 3 replicates. Thus, we have one true data point of salinity and temperature per month. 

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("02-07-2023")
source_description <- ("BCCWMS Coastal Volunteer Monitoring Data")
site_name <- ("SC1") #Use site code with site number based on lat position and state
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Oyster Landing, South Carolina. The ID_Site for this site is OL_MI_SC. 
raw_OL_MI_SC <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/EnvrDataTemplateExample/OL_MI_SC.csv")
```

    ## Rows: 690 Columns: 9
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
spec(raw_OL_MI_SC)
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
View(raw_OL_MI_SC)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
combined_datetime <- paste(raw_OL_MI_SC$collection_date, raw_OL_MI_SC$collection_time)

#Convert to POSIXct format. Store it into a column named datetime in the data frame. Use the year-month-day hours:minutes:seconds format. 
raw_OL_MI_SC$datetime <- as.POSIXct(combined_datetime, format = "%Y-%m-%d %H:%M:%S")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
print(raw_OL_MI_SC)
```

    ## # A tibble: 690 × 10
    ##    lab_sample_id   site_id site_name          latitude longitude collection_date
    ##    <chr>             <dbl> <chr>                 <dbl>     <dbl> <date>         
    ##  1 VM_MI_13_0022_0       8 Oyster Landing Be…     33.5     -79.1 2013-01-22     
    ##  2 VM_MI_13_0022_1       8 Oyster Landing Be…     33.5     -79.1 2013-01-22     
    ##  3 VM_MI_13_0022_2       8 Oyster Landing Be…     33.5     -79.1 2013-01-22     
    ##  4 VM_MI_13_0034_0       8 Oyster Landing Be…     33.5     -79.1 2013-02-12     
    ##  5 VM_MI_13_0034_1       8 Oyster Landing Be…     33.5     -79.1 2013-02-12     
    ##  6 VM_MI_13_0034_2       8 Oyster Landing Be…     33.5     -79.1 2013-02-12     
    ##  7 VM_MI_13_0042_0       8 Oyster Landing Be…     33.5     -79.1 2013-02-27     
    ##  8 VM_MI_13_0042_1       8 Oyster Landing Be…     33.5     -79.1 2013-02-27     
    ##  9 VM_MI_13_0042_2       8 Oyster Landing Be…     33.5     -79.1 2013-02-27     
    ## 10 VM_MI_13_0049_0       8 Oyster Landing Be…     33.5     -79.1 2013-03-12     
    ## # ℹ 680 more rows
    ## # ℹ 4 more variables: collection_time <time>, salinity_ppt <dbl>,
    ## #   temp_do <dbl>, datetime <dttm>

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_OL_MI_SC <- raw_OL_MI_SC %>% rename("temp" = "temp_do", "salinity" = "salinity_ppt", "lat" = "latitude", "lon" = "longitude")

#Print the range (minimum and maximum) of dates of data collection. 
print(range(raw_OL_MI_SC$datetime))
```

    ## [1] "2013-01-22 10:10:00 EST" "2023-01-10 07:50:00 EST"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(range(raw_OL_MI_SC$salinity))
```

    ## [1] -99999.00     36.92

``` r
#Print the range (minimum and maximum) of the temperature values.
print(range(raw_OL_MI_SC$temp))
```

    ## [1] -99999.0     30.1

``` r
#Print the range (minimum and maximum) of the latitude values. 
print(range(raw_OL_MI_SC$lat))
```

    ## [1] 33.52401 33.52401

``` r
#Print the range (minimum and maximum) of the longitude values. 
print(range(raw_OL_MI_SC$lon))
```

    ## [1] -79.06198 -79.06198

``` r
#Store variables that we will include in the final data frame
lat <- 33.52401
lon <- -79.06198
firstyear <- 2013
finalyear <- 2023
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
filtered_OL_MI_SC <- raw_OL_MI_SC %>%
    filter(between(salinity, 0, 40) & between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_OL_MI_SC$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   24.73   33.28   34.10   33.92   34.90   36.92

``` r
print(summary(filtered_OL_MI_SC$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    5.70   13.90   20.90   20.19   26.70   30.10

``` r
#Store our data into a variable name with just the site name. 
OL_MI_SC <- filtered_OL_MI_SC
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
envrplot <- ggplot(OL_MI_SC, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Range of environmental variables") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue", "Temperature (C)" = "red")) +
    theme_minimal()

salplot <- ggplot(OL_MI_SC, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

tempplot <- ggplot(OL_MI_SC, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


envrplot
```

![](EnvrDataTemplate_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
salplot
```

![](EnvrDataTemplate_files/figure-gfm/unnamed-chunk-8-2.png)<!-- -->

``` r
tempplot
```

![](EnvrDataTemplate_files/figure-gfm/unnamed-chunk-8-3.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
OL_MI_SC_envrmonth <- OL_MI_SC %>%
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
print(OL_MI_SC_envrmonth)
```

    ## # A tibble: 119 × 10
    ## # Groups:   year [10]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2013     1         34.2         34.3          34.2               3      9.7
    ##  2  2013     2         33.9         34.2          34.0               6     10.8
    ##  3  2013     3         32.4         33.9          33.2               6     10.1
    ##  4  2013     4         33.4         33.6          33.5               6     15.4
    ##  5  2013     5         34.9         35            35.0               6     18.5
    ##  6  2013     6         33.1         34.4          33.8               6     26.3
    ##  7  2013     7         33.6         34.1          33.8               6     26.1
    ##  8  2013     8         34.3         35            34.6               6     25.3
    ##  9  2013     9         34           34.1          34.0               6     23.1
    ## 10  2013    10         34.1         34.7          34.2               6     21.1
    ## # ℹ 109 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
OL_MI_SC_envryear <- OL_MI_SC %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(OL_MI_SC_envryear)
```

    ## # A tibble: 10 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2013         32.4         35            34.1      9.7     28.5      19.3
    ##  2  2014         32.6         36.1          34.3      7.4     28.5      19.7
    ##  3  2015         28.9         36.2          33.6      5.7     30.1      20.3
    ##  4  2016         31.0         36.3          33.3      8.3     29.6      20.5
    ##  5  2017         33.1         36.9          34.7     12.7     29.2      21.4
    ##  6  2018         24.7         35.5          33.2      6.1     28.5      19.2
    ##  7  2019         31.0         35.8          33.4      9.4     29.9      20.7
    ##  8  2020         29.8         35.5          33.5     10.4     28.5      20.5
    ##  9  2021         30.0         36.0          34.0     10.1     29        20.0
    ## 10  2022         33.7         36            35.0      8.3     28.7      20.3

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(OL_MI_SC_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](EnvrDataTemplate_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(OL_MI_SC$temp)
Mean_max_temperature_C <- mean(OL_MI_SC_envryear$max_temp)
Mean_min_temperature_C <- mean(OL_MI_SC_envryear$min_temp)
Temperature_st_dev <- sd(OL_MI_SC$temp)
Temperature_n <- nrow(OL_MI_SC)
Temperature_years <- nrow(OL_MI_SC_envryear)

#Create a data frame to store the temperature results
OL_MI_SC_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years)
print(OL_MI_SC_temp)
```

    ##      site_name download_date source_description                        
    ## [1,] "SC1"     "02-07-2023"  "BCCWMS Coastal Volunteer Monitoring Data"
    ##      lat        lon         firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "33.52401" "-79.06198" "2013"    "2023"    "20.1869128508124"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "29.05"                "8.81"                 "6.67241513542399"
    ##      Temperature_n Temperature_years
    ## [1,] "677"         "10"

``` r
write.table(OL_MI_SC_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = TRUE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame
```

    ## Warning in write.table(OL_MI_SC_temp,
    ## "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", :
    ## appending column names to file

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(OL_MI_SC$salinity)
Mean_max_Salinity_ppt <- mean(OL_MI_SC_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(OL_MI_SC_envryear$min_salinity)
Salinity_st_dev <- sd(OL_MI_SC$salinity)
Salinity_n <- nrow(OL_MI_SC)
Salinity_years <- nrow(OL_MI_SC_envryear)


#Create a data frame to store the temperature results
OL_MI_SC_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years)
print(OL_MI_SC_salinity)
```

    ##      site_name download_date source_description                        
    ## [1,] "SC1"     "02-07-2023"  "BCCWMS Coastal Volunteer Monitoring Data"
    ##      lat        lon         firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "33.52401" "-79.06198" "2013"    "2023"    "33.9187592319055"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "35.924"              "30.731"              "1.47126870228107" "677"     
    ##      Salinity_years
    ## [1,] "10"

``` r
write.table(OL_MI_SC_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = TRUE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame
```

    ## Warning in write.table(OL_MI_SC_salinity,
    ## "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", :
    ## appending column names to file
