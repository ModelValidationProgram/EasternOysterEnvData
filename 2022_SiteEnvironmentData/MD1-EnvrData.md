MD1 - Processed Environmental Data
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
#Source - https://eyesonthebay.dnr.maryland.gov/bay_cond/bay_cond.cfm?station=RET24&param=sal
#The site was sampled in triplicate at a weekly to monthly basis. 

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("08-18-2023")
source_description <- ("Maryland DNR/Eyes on the Bay - Lower Potomac River, Morgantown Bridge")
site_name <- ("MD1") #Use site code with site number based on lat position and state
collection_type <- ("weekly_intermittent")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Lower Cedar Point, Maryland. The ID_Site for this site is MD1. 
raw_MD1_sal <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/MD1-raw_sal.csv")
```

    ## Rows: 8456 Columns: 30
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (15): MonitoringStation, Cruise, Program, Project, Agency, Source, Stat...
    ## dbl   (8): EventId, TotalDepth, UpperPycnocline, LowerPycnocline, Depth, Mea...
    ## lgl   (6): Qualifier, Lab, Problem, PrecisionPC, BiasPC, Details
    ## time  (1): SampleTime
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
raw_MD1_temp <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/MD1-raw_temp.csv")
```

    ## Rows: 8454 Columns: 30
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (15): MonitoringStation, Cruise, Program, Project, Agency, Source, Stat...
    ## dbl   (8): EventId, TotalDepth, UpperPycnocline, LowerPycnocline, Depth, Mea...
    ## lgl   (6): Qualifier, Lab, Problem, PrecisionPC, BiasPC, Details
    ## time  (1): SampleTime
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_MD1_sal)
```

    ## cols(
    ##   MonitoringStation = col_character(),
    ##   EventId = col_double(),
    ##   Cruise = col_character(),
    ##   Program = col_character(),
    ##   Project = col_character(),
    ##   Agency = col_character(),
    ##   Source = col_character(),
    ##   Station = col_character(),
    ##   SampleDate = col_character(),
    ##   SampleTime = col_time(format = ""),
    ##   TotalDepth = col_double(),
    ##   UpperPycnocline = col_double(),
    ##   LowerPycnocline = col_double(),
    ##   Depth = col_double(),
    ##   Layer = col_character(),
    ##   SampleType = col_character(),
    ##   SampleReplicateType = col_character(),
    ##   Parameter = col_character(),
    ##   Qualifier = col_logical(),
    ##   MeasureValue = col_double(),
    ##   Unit = col_character(),
    ##   Method = col_character(),
    ##   Lab = col_logical(),
    ##   Problem = col_logical(),
    ##   PrecisionPC = col_logical(),
    ##   BiasPC = col_logical(),
    ##   Details = col_logical(),
    ##   Latitude = col_double(),
    ##   Longitude = col_double(),
    ##   TierLevel = col_character()
    ## )

``` r
View(raw_MD1_sal)

spec(raw_MD1_temp)
```

    ## cols(
    ##   MonitoringStation = col_character(),
    ##   EventId = col_double(),
    ##   Cruise = col_character(),
    ##   Program = col_character(),
    ##   Project = col_character(),
    ##   Agency = col_character(),
    ##   Source = col_character(),
    ##   Station = col_character(),
    ##   SampleDate = col_character(),
    ##   SampleTime = col_time(format = ""),
    ##   TotalDepth = col_double(),
    ##   UpperPycnocline = col_double(),
    ##   LowerPycnocline = col_double(),
    ##   Depth = col_double(),
    ##   Layer = col_character(),
    ##   SampleType = col_character(),
    ##   SampleReplicateType = col_character(),
    ##   Parameter = col_character(),
    ##   Qualifier = col_logical(),
    ##   MeasureValue = col_double(),
    ##   Unit = col_character(),
    ##   Method = col_character(),
    ##   Lab = col_logical(),
    ##   Problem = col_logical(),
    ##   PrecisionPC = col_logical(),
    ##   BiasPC = col_logical(),
    ##   Details = col_logical(),
    ##   Latitude = col_double(),
    ##   Longitude = col_double(),
    ##   TierLevel = col_character()
    ## )

``` r
View(raw_MD1_temp)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Combine the date and time into one column
raw_MD1_sal$combined_datetime <- paste(raw_MD1_sal$SampleDate, raw_MD1_sal$SampleTime)
raw_MD1_temp$combined_datetime <- paste(raw_MD1_temp$SampleDate, raw_MD1_temp$SampleTime)

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_MD1_sal$datetime <- as.POSIXct(raw_MD1_sal$combined_datetime, "%m/%d/%y %H:%M:%S", tz = "")
raw_MD1_temp$datetime <- as.POSIXct(raw_MD1_temp$combined_datetime, "%m/%d/%y %H:%M:%S", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
head(raw_MD1_sal)
```

    ## # A tibble: 6 × 32
    ##   MonitoringStation EventId Cruise Program Project Agency Source Station
    ##   <chr>               <dbl> <chr>  <chr>   <chr>   <chr>  <chr>  <chr>  
    ## 1 RET2.4             103253 BAY298 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 2 RET2.4             103253 BAY298 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 3 RET2.4             103253 BAY298 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 4 RET2.4             103253 BAY298 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 5 RET2.4             103253 BAY298 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 6 RET2.4             122010 BAY272 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## # ℹ 24 more variables: SampleDate <chr>, SampleTime <time>, TotalDepth <dbl>,
    ## #   UpperPycnocline <dbl>, LowerPycnocline <dbl>, Depth <dbl>, Layer <chr>,
    ## #   SampleType <chr>, SampleReplicateType <chr>, Parameter <chr>,
    ## #   Qualifier <lgl>, MeasureValue <dbl>, Unit <chr>, Method <chr>, Lab <lgl>,
    ## #   Problem <lgl>, PrecisionPC <lgl>, BiasPC <lgl>, Details <lgl>,
    ## #   Latitude <dbl>, Longitude <dbl>, TierLevel <chr>, combined_datetime <chr>,
    ## #   datetime <dttm>

``` r
head(raw_MD1_temp)
```

    ## # A tibble: 6 × 32
    ##   MonitoringStation EventId Cruise Program Project Agency Source Station
    ##   <chr>               <dbl> <chr>  <chr>   <chr>   <chr>  <chr>  <chr>  
    ## 1 RET2.4             103422 BAY299 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 2 RET2.4             103422 BAY299 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 3 RET2.4             103422 BAY299 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 4 RET2.4             103422 BAY299 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 5 RET2.4             103253 BAY298 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## 6 RET2.4             103253 BAY298 TWQM    TRIB    MDDNR  MDDNR  RET2.4 
    ## # ℹ 24 more variables: SampleDate <chr>, SampleTime <time>, TotalDepth <dbl>,
    ## #   UpperPycnocline <dbl>, LowerPycnocline <dbl>, Depth <dbl>, Layer <chr>,
    ## #   SampleType <chr>, SampleReplicateType <chr>, Parameter <chr>,
    ## #   Qualifier <lgl>, MeasureValue <dbl>, Unit <chr>, Method <chr>, Lab <lgl>,
    ## #   Problem <lgl>, PrecisionPC <lgl>, BiasPC <lgl>, Details <lgl>,
    ## #   Latitude <dbl>, Longitude <dbl>, TierLevel <chr>, combined_datetime <chr>,
    ## #   datetime <dttm>

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_MD1_sal <- raw_MD1_sal %>% rename("salinity" = "MeasureValue", "lat" = "Latitude", "lon" = "Longitude")
raw_MD1_temp <- raw_MD1_temp  %>% rename("temp" = "MeasureValue", "lat" = "Latitude", "lon" = "Longitude")

na.omit(raw_MD1_sal)
```

    ## # A tibble: 0 × 32
    ## # ℹ 32 variables: MonitoringStation <chr>, EventId <dbl>, Cruise <chr>,
    ## #   Program <chr>, Project <chr>, Agency <chr>, Source <chr>, Station <chr>,
    ## #   SampleDate <chr>, SampleTime <time>, TotalDepth <dbl>,
    ## #   UpperPycnocline <dbl>, LowerPycnocline <dbl>, Depth <dbl>, Layer <chr>,
    ## #   SampleType <chr>, SampleReplicateType <chr>, Parameter <chr>,
    ## #   Qualifier <lgl>, salinity <dbl>, Unit <chr>, Method <chr>, Lab <lgl>,
    ## #   Problem <lgl>, PrecisionPC <lgl>, BiasPC <lgl>, Details <lgl>, lat <dbl>, …

``` r
na.omit(raw_MD1_temp)
```

    ## # A tibble: 0 × 32
    ## # ℹ 32 variables: MonitoringStation <chr>, EventId <dbl>, Cruise <chr>,
    ## #   Program <chr>, Project <chr>, Agency <chr>, Source <chr>, Station <chr>,
    ## #   SampleDate <chr>, SampleTime <time>, TotalDepth <dbl>,
    ## #   UpperPycnocline <dbl>, LowerPycnocline <dbl>, Depth <dbl>, Layer <chr>,
    ## #   SampleType <chr>, SampleReplicateType <chr>, Parameter <chr>,
    ## #   Qualifier <lgl>, temp <dbl>, Unit <chr>, Method <chr>, Lab <lgl>,
    ## #   Problem <lgl>, PrecisionPC <lgl>, BiasPC <lgl>, Details <lgl>, lat <dbl>, …

``` r
#Print the range (minimum and maximum) of dates of data collection. 
print(range(raw_MD1_sal$datetime))
```

    ## [1] "1986-01-06 09:00:00 EST" "2022-12-12 09:00:00 EST"

``` r
print(range(raw_MD1_temp$datetime))
```

    ## [1] "1986-01-06 09:00:00 EST" "2022-12-12 09:00:00 EST"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(range(raw_MD1_sal$salinity))
```

    ## [1]  0.00 16.09

``` r
#Print the range (minimum and maximum) of the temperature values.
print(range(raw_MD1_temp$temp))
```

    ## [1]  0.6 29.9

``` r
#Store variables that we will include in the final data frame
lat <- 38.3626
lon <- -76.9905
firstyear <- 1986
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_MD1_sal <- raw_MD1_sal %>%
    filter(between(salinity, 0, 40)) 
           
filtered_MD1_temp <- raw_MD1_temp %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_MD1_sal$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   5.190   8.060   7.706  10.240  16.090

``` r
print(summary(filtered_MD1_temp$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.60    9.10   17.80   16.86   24.80   29.90

``` r
#Store our data into a variable name with just the site name. 
MD1_temp <- filtered_MD1_temp
MD1_sal <- filtered_MD1_sal
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(MD1_sal, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for MD1 - Lower Cedar Point") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](MD1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(MD1_temp, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for MD1 - Lower Cedar Point") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](MD1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
MD1_envrmonth_sal <- MD1_sal %>%
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
MD1_envrmonth_temp <- MD1_temp %>%
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
print(MD1_envrmonth_sal)
```

    ## # A tibble: 435 × 6
    ## # Groups:   year [37]
    ##     year month min_salinity max_salinity mean_salinity length_salinity
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ##  1  1986     1         7.87         9.78          8.93               5
    ##  2  1986     3         6.31        11.3           9.09               5
    ##  3  1986     4         5.63         9.77          7.03              10
    ##  4  1986     5         7.43         9.4           8.49              10
    ##  5  1986     6         6           11.0           9.18              10
    ##  6  1986     7         9.4         12.7          11.0               10
    ##  7  1986     8         9.85        12.5          10.9                9
    ##  8  1986     9        10.4         13.3          11.6               10
    ##  9  1986    10        11.0         14.5          12.3               10
    ## 10  1986    11        10.5         13.5          12.3                5
    ## # ℹ 425 more rows

``` r
print(MD1_envrmonth_temp)
```

    ## # A tibble: 435 × 6
    ## # Groups:   year [37]
    ##     year month min_temp max_temp mean_temp length_temp
    ##    <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ##  1  1986     1      3        4        3.64           5
    ##  2  1986     3      2.5      2.6      2.54           5
    ##  3  1986     4      9.9     14.1     11.7           10
    ##  4  1986     5     15.4     20.1     17.8           10
    ##  5  1986     6     19.1     25.6     22.4           10
    ##  6  1986     7     25.2     28.5     27.2           10
    ##  7  1986     8     24.8     27.7     26.2            9
    ##  8  1986     9     22.5     23       22.8           10
    ##  9  1986    10     16.5     19.6     18.2           10
    ## 10  1986    11      9.2      9.7      9.58           5
    ## # ℹ 425 more rows

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
MD1_envryear_sal <- MD1_sal %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

MD1_envryear_temp <- MD1_temp %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(MD1_envryear_sal)
```

    ## # A tibble: 37 × 4
    ##     year min_salinity max_salinity mean_salinity
    ##    <dbl>        <dbl>        <dbl>         <dbl>
    ##  1  1986         5.63         14.5         10.2 
    ##  2  1987         0.27         15            8.97
    ##  3  1988         0            13.9          8.44
    ##  4  1989         0.41         14.4          7.53
    ##  5  1990         2.58         11.7          6.80
    ##  6  1991         1.38         14.0          8.55
    ##  7  1992         3.01         14.7          9.58
    ##  8  1993         0            12.7          6.60
    ##  9  1994         0            11.8          5.39
    ## 10  1995         3.48         15.7          9.45
    ## # ℹ 27 more rows

``` r
print(MD1_envryear_temp)
```

    ## # A tibble: 37 × 4
    ##     year min_temp max_temp mean_temp
    ##    <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  1986      2.5     28.5      17.5
    ##  2  1987      2.6     29.9      16.3
    ##  3  1988      2.6     29.3      18.9
    ##  4  1989      3.8     28.2      16.9
    ##  5  1990      1.8     27.6      15.8
    ##  6  1991      4.5     29.5      19.0
    ##  7  1992      2.8     27        16.5
    ##  8  1993      3.6     28.9      17.4
    ##  9  1994      3.2     28.2      18.1
    ## 10  1995      2.7     29.2      17.3
    ## # ℹ 27 more rows

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(MD1_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for MD1 - Lower Cedar Point") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](MD1-EnvrData_files/figure-gfm/timeplot%20-%20salinity-1.png)<!-- -->

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(MD1_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for MD1 - Lower Cedar Point") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](MD1-EnvrData_files/figure-gfm/timeplot%20-%20temperature-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(MD1_temp$temp)
Mean_max_temperature_C <- mean(MD1_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(MD1_envryear_temp$min_temp)
Temperature_st_dev <- sd(MD1_temp$temp)
Temperature_n <- nrow(MD1_temp)
Temperature_years <- nrow(MD1_envryear_temp)

#Create a data frame to store the temperature results
MD1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(MD1_temp)
```

    ##      site_name download_date
    ## [1,] "MD1"     "08-18-2023" 
    ##      source_description                                                     
    ## [1,] "Maryland DNR/Eyes on the Bay - Lower Potomac River, Morgantown Bridge"
    ##      lat       lon        firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "38.3626" "-76.9905" "1986"    "2022"    "16.8551573219778"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "28.2594594594595"     "2.85135135135135"     "8.37706720491886"
    ##      Temperature_n Temperature_years collection_type      
    ## [1,] "8454"        "37"              "weekly_intermittent"

``` r
# Write to the combined file with all sites 
write.table(MD1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(MD1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/MD1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(MD1_sal$salinity)
Mean_max_Salinity_ppt <- mean(MD1_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(MD1_envryear_sal$min_salinity)
Salinity_st_dev <- sd(MD1_sal$salinity)
Salinity_n <- nrow(MD1_sal)
Salinity_years <- nrow(MD1_envryear_sal)


#Create a data frame to store the temperature results
MD1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(MD1_salinity)
```

    ##      site_name download_date
    ## [1,] "MD1"     "08-18-2023" 
    ##      source_description                                                     
    ## [1,] "Maryland DNR/Eyes on the Bay - Lower Potomac River, Morgantown Bridge"
    ##      lat       lon        firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "38.3626" "-76.9905" "1986"    "2022"    "7.70623107852412"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "13.4945945945946"    "1.44972972972973"    "3.46292074083426" "8456"    
    ##      Salinity_years collection_type      
    ## [1,] "37"           "weekly_intermittent"

``` r
# Write to the combined file with all sites 
write.table(MD1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(MD1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/MD1_salinity.csv", row.names = FALSE)
```
