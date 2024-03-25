ME1 - Processed Environmental Data
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
#Data was downloaded on 3/25/2024 from UMaine Loboviz 
#Source - University of Maine http://maine.loboviz.com/ and http://maine.loboviz.com/cgi-lobo/lobo. Graphed data using the graph loboviz function and then exported all available data in the visualization.  
#The site was sampled intermittently

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("03-25-2024")
source_description <- ("University of Maine")
site_name <- ("ME1") #Use site code with site number based on lat position and state
collection_type <- ("intermittent")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from the Upper Damariscotta Estuary. The ID_Site for this site is ME1. 
raw_ME1 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/ME1-raw.csv")
```

    ## Rows: 13693 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1): date
    ## dbl (2): salinity, temp
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_ME1)
```

    ## cols(
    ##   date = col_character(),
    ##   salinity = col_double(),
    ##   temp = col_double()
    ## )

``` r
#View(raw_ME1)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_ME1$datetime <- as.POSIXct(raw_ME1$date, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
head(raw_ME1)
```

    ## # A tibble: 6 × 4
    ##   date          salinity  temp datetime           
    ##   <chr>            <dbl> <dbl> <dttm>             
    ## 1 9/25/15 15:00     31.7  17.5 2015-09-25 15:00:00
    ## 2 9/25/15 16:00     31.7  17.5 2015-09-25 16:00:00
    ## 3 9/25/15 17:00     31.7  17.4 2015-09-25 17:00:00
    ## 4 9/25/15 18:00     31.7  16.9 2015-09-25 18:00:00
    ## 5 9/25/15 19:00     31.8  16.6 2015-09-25 19:00:00
    ## 6 9/25/15 20:00     31.8  16.2 2015-09-25 20:00:00

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_ME1 <- raw_ME1 %>% rename("salinity" = "salinity")
raw_ME1 <- raw_ME1  %>% rename("temp" = "temp")

#Store variables that we will include in the final data frame
lat <- 43.86457
lon <- -69.89763
firstyear <- 2015
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_ME1 <- raw_ME1 %>%
    filter(between(salinity, 0, 42)) 
           
filtered_ME1 <- raw_ME1 %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_ME1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.01   30.93   31.37   31.24   31.70   71.69       2

``` r
print(summary(filtered_ME1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    5.40   11.59   15.87   14.82   18.19   38.15

``` r
#Store our data into a variable name with just the site name. 
ME1 <- filtered_ME1

# check if we we have NAs in the our salinity data frame in the datetime column
count.nas_datetime <- is.na(ME1$datetime) # store our NAs in a variable
summary(count.nas_datetime) # no, we don't have any NAs, so we are good to go
```

    ##    Mode   FALSE 
    ## logical   13690

``` r
count.nas_temp <- is.na(ME1$temp)
summary(count.nas_temp) # no, we don't have any NAs, so we are good to go
```

    ##    Mode   FALSE 
    ## logical   13690

``` r
count.nas_sal <- is.na(ME1$salinity)
summary(count.nas_sal) # we have 2 NA's, let's remove them
```

    ##    Mode   FALSE    TRUE 
    ## logical   13688       2

``` r
nrow(ME1) # figure out how many rows we have in the original df: 13690
```

    ## [1] 13690

``` r
which(count.nas_sal == TRUE) # find the number of NA rows that we need to remove: 2
```

    ## [1] 9943 9945

``` r
ME1 <- ME1[-c(9943, 9945), ] # remove the rows
nrow(ME1) # check the new number of rows in the dataframe with the NAs removed
```

    ## [1] 13688

``` r
check_sal <- 13690-13688 # the value of check should be 2
check_sal # cool, we removed the 2 NA rows!
```

    ## [1] 2

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(ME1, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for ME1 - Damariscotta Estuary") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](ME1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(ME1, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for ME1 - Damariscotta Estuary") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](ME1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
ME1_envrmonth_sal <- ME1 %>%
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
ME1_envrmonth_temp <- ME1 %>%
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
print(ME1_envrmonth_sal)
```

    ## # A tibble: 26 × 6
    ## # Groups:   year [4]
    ##     year month min_salinity max_salinity mean_salinity length_salinity
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ##  1  2015     9        30.2          31.8          31.6             110
    ##  2  2015    10        30.1          31.9          30.8             334
    ##  3  2015    11        29.7          31.8          31.1             575
    ##  4  2016     4         0.11         30.2          27.7             211
    ##  5  2016     5        29.4          31.1          30.4             742
    ##  6  2016     6        30.4          31.2          30.8             206
    ##  7  2016     7         0.48         31.6          31.4             564
    ##  8  2016     8        30.5          31.9          31.7             744
    ##  9  2016     9        31.8          32.2          32.0             720
    ## 10  2016    10        31.9          32.4          32.2             744
    ## # ℹ 16 more rows

``` r
print(ME1_envrmonth_temp)
```

    ## # A tibble: 26 × 6
    ## # Groups:   year [4]
    ##     year month min_temp max_temp mean_temp length_temp
    ##    <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ##  1  2015     9    15.9      17.5     16.6          110
    ##  2  2015    10    10.7      16.6     14.1          334
    ##  3  2015    11     7.31     11.0      9.20         575
    ##  4  2016     4     6.92     17.8      8.55         211
    ##  5  2016     5     7.77     14.7     10.2          742
    ##  6  2016     6    12.9      15.3     14.2          206
    ##  7  2016     7    15.3      20.3     18.0          564
    ##  8  2016     8    17.1      20.6     19.1          744
    ##  9  2016     9    15        19.6     17.6          720
    ## 10  2016    10    11.2      16.1     14.0          744
    ## # ℹ 16 more rows

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
ME1_envryear_sal <- ME1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

ME1_envryear_temp <- ME1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(ME1_envryear_sal)
```

    ## # A tibble: 4 × 4
    ##    year min_salinity max_salinity mean_salinity
    ##   <dbl>        <dbl>        <dbl>         <dbl>
    ## 1  2015        29.7          31.9          31.0
    ## 2  2016         0.11         32.6          31.4
    ## 3  2021         0.01         71.7          31.0
    ## 4  2022         0.01         32.1          31.5

``` r
print(ME1_envryear_temp)
```

    ## # A tibble: 4 × 4
    ##    year min_temp max_temp mean_temp
    ##   <dbl>    <dbl>    <dbl>     <dbl>
    ## 1  2015     7.31     17.5      11.6
    ## 2  2016     6.92     20.6      14.7
    ## 3  2021     5.4      38.2      14.0
    ## 4  2022    13.4      24.4      17.2

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(ME1_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for ME1 - Damariscotta Estuary") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](ME1-EnvrData_files/figure-gfm/timeplot%20-%20salinity-1.png)<!-- -->

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(ME1_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for ME1 - Damariscotta Estuary") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](ME1-EnvrData_files/figure-gfm/timeplot%20-%20temperature-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(ME1$temp)
Mean_max_temperature_C <- mean(ME1_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(ME1_envryear_temp$min_temp)
Temperature_st_dev <- sd(ME1$temp)
Temperature_n <- nrow(ME1)
Temperature_years <- nrow(ME1_envryear_temp)

#Create a data frame to store the temperature results
ME1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(ME1_temp)
```

    ##      site_name download_date source_description    lat        lon        
    ## [1,] "ME1"     "03-25-2024"  "University of Maine" "43.86457" "-69.89763"
    ##      firstyear finalyear Mean_Annual_Temperature_C Mean_max_temperature_C
    ## [1,] "2015"    "2022"    "14.8171683226184"        "25.175"              
    ##      Mean_min_temperature_C Temperature_st_dev Temperature_n Temperature_years
    ## [1,] "8.255"                "4.0170116249868"  "13688"       "4"              
    ##      collection_type
    ## [1,] "intermittent"

``` r
# Write to the combined file with all sites 
write.table(ME1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(ME1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/ME1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(ME1$salinity)
Mean_max_Salinity_ppt <- mean(ME1_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(ME1_envryear_sal$min_salinity)
Salinity_st_dev <- sd(ME1$salinity)
Salinity_n <- nrow(ME1)
Salinity_years <- nrow(ME1_envryear_sal)


#Create a data frame to store the temperature results
ME1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(ME1_salinity)
```

    ##      site_name download_date source_description    lat        lon        
    ## [1,] "ME1"     "03-25-2024"  "University of Maine" "43.86457" "-69.89763"
    ##      firstyear finalyear Mean_Annual_Salinity_ppt Mean_max_Salinity_ppt
    ## [1,] "2015"    "2022"    "31.2404997077732"       "42.055"             
    ##      Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n Salinity_years
    ## [1,] "7.4475"              "1.59619422033805" "13688"    "4"           
    ##      collection_type
    ## [1,] "intermittent"

``` r
# Write to the combined file with all sites 
write.table(ME1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(ME1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/ME1_salinity.csv", row.names = FALSE)
```
