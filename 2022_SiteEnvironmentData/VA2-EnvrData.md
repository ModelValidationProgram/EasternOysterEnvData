VA2 - Processed Environmental Data
================
Madeline Eppley
3/20/2024

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
#Data was downloaded on 9/22/2023
#Source - https://irma.nps.gov/AQWebPortal/Data/Location/Summary/Location/COLO/Interval/Latest and https://cmc.vims.edu/#/home
#The site was sampled intermittently

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("09-22-2023")
source_description <- ("National Parks Service Continuous Water Data - Jamestown Island and Chesapeake Monitoring Coop/NERR/VIMS")
site_name <- ("VA2") #Use site code with site number based on lat position and state
collection_type <- ("intermittent")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Lower Cedar Point, Maryland. The ID_Site for this site is VA2. 
raw_VA2_sal <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/VA2-raw_sal.csv")
```

    ## Rows: 218 Columns: 6
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): DateRetrieved, Comments
    ## dbl (4): StationID, AverageSpat, Salinity, TotalSpat
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
raw_VA2_temp <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/VA2-raw_temp.csv")
```

    ## Rows: 2453 Columns: 2
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1): Timestamp
    ## dbl (1): Temp
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_VA2_sal)
```

    ## cols(
    ##   StationID = col_double(),
    ##   DateRetrieved = col_character(),
    ##   AverageSpat = col_double(),
    ##   Salinity = col_double(),
    ##   Comments = col_character(),
    ##   TotalSpat = col_double()
    ## )

``` r
#View(raw_VA2_sal)

spec(raw_VA2_temp)
```

    ## cols(
    ##   Timestamp = col_character(),
    ##   Temp = col_double()
    ## )

``` r
#View(raw_VA2_temp)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_VA2_sal$datetime <- as.POSIXct(raw_VA2_sal$DateRetrieved, "%d-%b-%y", tz = "")
raw_VA2_temp$datetime <- as.POSIXct(raw_VA2_temp$Timestamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
head(raw_VA2_sal)
```

    ## # A tibble: 6 × 7
    ##   StationID DateRetrieved AverageSpat Salinity Comments           TotalSpat
    ##       <dbl> <chr>               <dbl>    <dbl> <chr>                  <dbl>
    ## 1       431 1-Jun-23             NA        7.8 First deployment          NA
    ## 2       431 15-Jun-23             0        6.8 <NA>                       0
    ## 3       431 22-Jun-23             0.1     11.8 <NA>                       1
    ## 4       431 29-Jun-23             0.5      6.7 Light barnacle set         5
    ## 5       431 6-Jul-23              1.2      7.4 <NA>                      12
    ## 6       431 13-Jul-23             5.9      7.5 <NA>                      59
    ## # ℹ 1 more variable: datetime <dttm>

``` r
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
raw_VA2_sal <- raw_VA2_sal %>% rename("salinity" = "Salinity")
raw_VA2_temp <- raw_VA2_temp  %>% rename("temp" = "Temp")

#Store variables that we will include in the final data frame
lat <- 37.21462
lon <- -76.4483
firstyear <- 2010
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_VA2_sal <- raw_VA2_sal %>%
    filter(between(salinity, 0, 42)) 
           
filtered_VA2_temp <- raw_VA2_temp %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_VA2_sal$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.200   5.150   7.800   7.757  10.675  14.900

``` r
print(summary(filtered_VA2_temp$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   17.50   27.74   28.80   28.66   29.80   32.93

``` r
#Store our data into a variable name with just the site name. 
VA2_temp <- filtered_VA2_temp
VA2_sal <- filtered_VA2_sal
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(VA2_sal, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for VA2 - Deep Water Shoal") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](VA2-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(VA2_temp, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for VA2 - Deep Water Shoal") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](VA2-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
VA2_envrmonth_sal <- VA2_sal %>%
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
print(VA2_envrmonth_sal)
```

    ## # A tibble: 69 × 6
    ## # Groups:   year [14]
    ##     year month min_salinity max_salinity mean_salinity length_salinity
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ##  1  2010     6          4.7          8.8          7.3                4
    ##  2  2010     7         10.1         12           10.9                5
    ##  3  2010     8         12.4         14.6         13.3                4
    ##  4  2010     9         13.3         14.2         13.7                3
    ##  5  2011     6          2.4          7.5          5.56               5
    ##  6  2011     7          6.4          7.3          6.93               3
    ##  7  2011     8          9.8         11           10.6                4
    ##  8  2011     9          4.3         10            6.96               5
    ##  9  2012     5          3.9          3.9          3.9                1
    ## 10  2012     6          6            7.1          6.45               4
    ## # ℹ 59 more rows

``` r
print(VA2_envrmonth_temp)
```

    ## # A tibble: 70 × 6
    ## # Groups:   year [14]
    ##     year month min_temp max_temp mean_temp length_temp
    ##    <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ##  1  2010     6     25.4     29.6      27.2           8
    ##  2  2010     7     27.9     29.2      28.6          10
    ##  3  2010     8     27.2     29.5      28.2           8
    ##  4  2010     9     24.7     28.1      26.1           6
    ##  5  2011     6     26.5     27.2      26.9          10
    ##  6  2011     7     27       28.9      28.2           6
    ##  7  2011     8     27.2     29.8      28.4           8
    ##  8  2011     9     23.7     26.4      25.1          10
    ##  9  2012     5     25.1     25.1      25.1           2
    ## 10  2012     6     23.3     26.4      25.2           8
    ## # ℹ 60 more rows

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
VA2_envryear_sal <- VA2_sal %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

VA2_envryear_temp <- VA2_temp %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(VA2_envryear_sal)
```

    ## # A tibble: 14 × 4
    ##     year min_salinity max_salinity mean_salinity
    ##    <dbl>        <dbl>        <dbl>         <dbl>
    ##  1  2010          4.7         14.6         11.1 
    ##  2  2011          2.4         11            7.39
    ##  3  2012          3.9         14.8          9.02
    ##  4  2013          0.5         10.7          5.45
    ##  5  2014          3.4         11.1          7.55
    ##  6  2015          3           12.7          7.93
    ##  7  2016          0.6         11.8          6.7 
    ##  8  2017          0.7         13.6          9.81
    ##  9  2018          0.2          6.7          3.32
    ## 10  2019          2.4         13.2          8.74
    ## 11  2020          1.5          9            5.59
    ## 12  2021          5.3         13.1          8.53
    ## 13  2022          3.1         14.9          9.67
    ## 14  2023          5.3         12.9          8.42

``` r
print(VA2_envryear_temp)
```

    ## # A tibble: 14 × 4
    ##     year min_temp max_temp mean_temp
    ##    <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2010     24.7     29.6      27.7
    ##  2  2011     23.7     29.8      26.9
    ##  3  2012     22.5     29.8      26.5
    ##  4  2013     22.5     29.4      26.0
    ##  5  2014     22.9     28.2      26.4
    ##  6  2015     23.9     29.4      27.1
    ##  7  2016     20.9     31        27.1
    ##  8  2017     22.6     29.7      26.4
    ##  9  2018     25.1     30.2      27.5
    ## 10  2019     23.4     29.4      27.3
    ## 11  2020     19.7     32.9      29.0
    ## 12  2021     20.9     29.7      26.5
    ## 13  2022     17.5     29.5      26.9
    ## 14  2023     22       29.4      26.9

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(VA2_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for VA2 - Deep Water Shoal") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](VA2-EnvrData_files/figure-gfm/timeplot%20-%20salinity-1.png)<!-- -->

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(VA2_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for VA2 - Deep Water Shoal") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

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
    ## [1,] "VA2"     "09-22-2023" 
    ##      source_description                                                                                        
    ## [1,] "National Parks Service Continuous Water Data - Jamestown Island and Chesapeake Monitoring Coop/NERR/VIMS"
    ##      lat        lon        firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "37.21462" "-76.4483" "2010"    "2022"    "28.6608385650224"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "29.8594285714286"     "22.3042857142857"     "1.87937098763513"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "2453"        "14"              "intermittent"

``` r
# Write to the combined file with all sites 
write.table(VA2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(VA2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/VA2_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(VA2_sal$salinity)
Mean_max_Salinity_ppt <- mean(VA2_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(VA2_envryear_sal$min_salinity)
Salinity_st_dev <- sd(VA2_sal$salinity)
Salinity_n <- nrow(VA2_sal)
Salinity_years <- nrow(VA2_envryear_sal)


#Create a data frame to store the temperature results
VA2_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(VA2_salinity)
```

    ##      site_name download_date
    ## [1,] "VA2"     "09-22-2023" 
    ##      source_description                                                                                        
    ## [1,] "National Parks Service Continuous Water Data - Jamestown Island and Chesapeake Monitoring Coop/NERR/VIMS"
    ##      lat        lon        firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "37.21462" "-76.4483" "2010"    "2022"    "7.75733944954128"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "12.15"               "2.64285714285714"    "3.47940170242294" "218"     
    ##      Salinity_years collection_type
    ## [1,] "14"           "intermittent"

``` r
# Write to the combined file with all sites 
write.table(VA2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(VA2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/VA2_salinity.csv", row.names = FALSE)
```
