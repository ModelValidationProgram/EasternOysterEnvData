VA2 - Processed Environmental Data
================
Madeline Eppley
9/13/2023

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
#Data was downloaded on 9/13/2023
#Source - https://irma.nps.gov/AQWebPortal/Data/Location/Summary/Location/COLO/Interval/Latest and https://cmc.vims.edu/#/home
#The site was sampled intermittently

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("09-13-2023")
source_description <- ("National Parks Service Continuous Water Data - Jamestown Island and Chesapeake Monitoring Coop/NERR/VIMS")
site_name <- ("VA2") #Use site code with site number based on lat position and state
collection_type <- ("intermittent")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Lower Cedar Point, Maryland. The ID_Site for this site is VA2. 
#raw_VA2_sal <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/VA2-raw_sal.csv")
raw_VA2_temp <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/VA2-raw_temp.csv")
```

    ## Rows: 2029 Columns: 2
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1): Timestamp
    ## dbl (1): Temp
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
#spec(raw_VA2_sal)
#View(raw_VA2_sal)

spec(raw_VA2_temp)
```

    ## cols(
    ##   Timestamp = col_character(),
    ##   Temp = col_double()
    ## )

``` r
View(raw_VA2_temp)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
#raw_VA2_sal$datetime <- as.POSIXct(raw_VA2_sal$Timestamp, "%m/%d/%y %H:%M", tz = "")
raw_VA2_temp$datetime <- as.POSIXct(raw_VA2_temp$Timestamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
#head(raw_VA2_sal)
head(raw_VA2_temp)
```

    ## # A tibble: 6 × 3
    ##   Timestamp      Temp datetime           
    ##   <chr>         <dbl> <dttm>             
    ## 1 7/29/20 11:00  19.7 2020-07-29 11:00:00
    ## 2 8/5/20 11:45   28.8 2020-08-05 11:45:00
    ## 3 8/5/20 12:00   28.8 2020-08-05 12:00:00
    ## 4 8/5/20 12:15   29.1 2020-08-05 12:15:00
    ## 5 8/5/20 12:30   29.4 2020-08-05 12:30:00
    ## 6 8/5/20 12:45   29.5 2020-08-05 12:45:00

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
#raw_VA2_sal <- raw_VA2_sal %>% rename("salinity" = "PSU")
raw_VA2_temp <- raw_VA2_temp  %>% rename("temp" = "Temp")

#Print the range (minimum and maximum) of dates of data collection. 
#print(range(raw_VA2_sal$datetime))
print(range(raw_VA2_temp$datetime))
```

    ## [1] NA NA

``` r
#Print the range (minimum and maximum) of the salinity values. 
#print(range(raw_VA2_sal$salinity))

#Print the range (minimum and maximum) of the temperature values.
print(range(raw_VA2_temp$temp))
```

    ## [1] 19.660 32.932

``` r
#Store variables that we will include in the final data frame
lat <- 37.21462
lon <- -76.4483
firstyear <- 2018
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
#filtered_VA2_sal <- raw_VA2_sal %>%
    #filter(between(salinity, 0, 42)) 
           
filtered_VA2_temp <- raw_VA2_temp %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
#print(summary(filtered_VA2_sal$salinity))
print(summary(filtered_VA2_temp$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   19.66   28.03   29.02   29.04   30.02   32.93

``` r
#Store our data into a variable name with just the site name. 
VA2_temp <- filtered_VA2_temp
#VA2_sal <- filtered_VA2_sal
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
#salplot <- ggplot(VA2_sal, aes(x = datetime)) +
    #geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    #ylim(0,40) +
    #labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for VA2 - Kingsley Plantation") +
    #scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    #theme_minimal()

#salplot
```

``` r
tempplot <- ggplot(VA2_temp, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for VA2 - Deep Water Shoal") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

    ## Warning: Removed 13 rows containing missing values (`geom_line()`).

![](VA2-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
#VA2_envrmonth_sal <- VA2_sal %>%
   # mutate(year = year(datetime), month = month(datetime)) %>%
    #group_by(year, month) %>%
    #summarise(
     # min_salinity = min(salinity),
     # max_salinity = max(salinity),
      #mean_salinity = mean(salinity),
      #length_salinity = length(salinity))
      
VA2_envrmonth_temp <- VA2_temp %>%
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
#print(VA2_envrmonth_sal)
print(VA2_envrmonth_temp)
```

    ## # A tibble: 3 × 6
    ## # Groups:   year [2]
    ##    year month min_temp max_temp mean_temp length_temp
    ##   <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ## 1  2020     7     19.7     19.7      19.7           1
    ## 2  2020     8     24.9     32.9      29.1        2015
    ## 3    NA    NA     21.5     29.5      27.2          13

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
#VA2_envryear_sal <- VA2_sal %>%
    #mutate(year = year(datetime)) %>%
    #group_by(year) %>%
    #summarise(
     # min_salinity = min(salinity),
     # max_salinity = max(salinity),
     # mean_salinity = mean(salinity))

VA2_envryear_temp <- VA2_temp %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

#print(VA2_envryear_sal)
print(VA2_envryear_temp)
```

    ## # A tibble: 2 × 4
    ##    year min_temp max_temp mean_temp
    ##   <dbl>    <dbl>    <dbl>     <dbl>
    ## 1  2020     19.7     32.9      29.0
    ## 2    NA     21.5     29.5      27.2

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
#timeplot <- ggplot(VA2_envrmonth_sal, aes(x = year)) +
   # geom_point(aes(y = month, color = length_salinity), size = 4) +
    #labs(x = "Time", y = "Month", title = "Salinity Timeplot for VA2 - Kinglsey Plantation") +
    #ylim(1,12) +
    #theme_minimal()

#timeplot
```

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(VA2_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for VA2 - Kingsley Plantation") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

    ## Warning: Removed 1 rows containing missing values (`geom_point()`).

![](VA2-EnvrData_files/figure-gfm/timeplot%20-%20temperature-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(VA2_temp$temp)
Mean_max_temperature_C <- mean(VA2_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(VA2_envryear_temp$min_temp)
Temperature_st_dev <- sd(VA2_temp$temp)
Temperature_n <- nrow(VA2_temp)
Temperature_years <- nrow(VA2_envryear_temp)

#Create a data frame to store the temperature results
VA2_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(VA2_temp)
```

    ##      site_name download_date
    ## [1,] "VA2"     "09-13-2023" 
    ##      source_description                                                                                        
    ## [1,] "National Parks Service Continuous Water Data - Jamestown Island and Chesapeake Monitoring Coop/NERR/VIMS"
    ##      lat        lon        firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "37.21462" "-76.4483" "2018"    "2022"    "29.0370808279941"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "31.216"               "20.58"                "1.57329640697276"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "2029"        "2"               "intermittent"

``` r
# Write to the combined file with all sites 
write.table(VA2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(VA2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/VA2_temperature.csv")
```

``` r
#Calculate the salinity variables
#Mean_Annual_Salinity_ppt <- mean(VA2_sal$salinity)
#Mean_max_Salinity_ppt <- mean(VA2_envryear_sal$max_salinity)
#Mean_min_Salinity_ppt <- mean(VA2_envryear_sal$min_salinity)
#Salinity_st_dev <- sd(VA2_sal$salinity)
#Salinity_n <- nrow(VA2_sal)
#Salinity_years <- nrow(VA2_envryear_sal)


#Create a data frame to store the temperature results
#VA2_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
#print(VA2_salinity)

# Write to the combined file with all sites 
#write.table(VA2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
#write.csv(VA2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/VA2_salinity.csv", row.names = FALSE)
```
