VA1 - Processed Environmental Data
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
#Data was downloaded by Missy Southworth and emailed to M.Eppley on 9/15/2023
#Source - Missy Southworth, VIMS Annual Summer Environmental Data Collection, https://www.vims.edu/research/units/labgroups/molluscan_ecology/publications/topic/annual_reports/
#The site was sampled intermittently

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("09-15-2023")
source_description <- ("VIMS Water Quality Data")
site_name <- ("VA1") #Use site code with site number based on lat position and state
collection_type <- ("intermittent")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Wreck Shoal, VA. The ID_Site for this site is VA1. 
raw_VA1 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/VA1-raw.csv")
```

    ## Rows: 220 Columns: 7
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): DateDeployed, DateRetrieved
    ## dbl (5): StationID, Year, AverageSpat, WaterTemperature, Salinity
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_VA1)
```

    ## cols(
    ##   StationID = col_double(),
    ##   Year = col_double(),
    ##   DateDeployed = col_character(),
    ##   DateRetrieved = col_character(),
    ##   AverageSpat = col_double(),
    ##   WaterTemperature = col_double(),
    ##   Salinity = col_double()
    ## )

``` r
#View(raw_VA1)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_VA1$datetime <- as.POSIXct(raw_VA1$DateRetrieved, "%d-%b-%y", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
head(raw_VA1)
```

    ## # A tibble: 6 × 8
    ##   StationID  Year DateDeployed DateRetrieved AverageSpat WaterTemperature
    ##       <dbl> <dbl> <chr>        <chr>               <dbl>            <dbl>
    ## 1       435  2023 01-Jun-23    01-Jun-23            NA               19.6
    ## 2       435  2023 01-Jun-23    15-Jun-23             0               23  
    ## 3       435  2023 15-Jun-23    22-Jun-23             1               23.1
    ## 4       435  2023 22-Jun-23    29-Jun-23             7.7             24.4
    ## 5       435  2023 29-Jun-23    06-Jul-23            14.2             28.1
    ## 6       435  2023 06-Jul-23    13-Jul-23            35.5             28.7
    ## # ℹ 2 more variables: Salinity <dbl>, datetime <dttm>

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_VA1 <- raw_VA1 %>% rename("salinity" = "Salinity")
raw_VA1 <- raw_VA1  %>% rename("temp" = "WaterTemperature")

#Store variables that we will include in the final data frame
lat <- 37.060283
lon <- -76.572217
firstyear <- 2010
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_VA1 <- raw_VA1 %>%
    filter(between(salinity, 0, 42)) 
           
filtered_VA1 <- raw_VA1 %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_VA1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    3.80   12.70   15.70   15.05   18.00   21.60

``` r
print(summary(filtered_VA1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   17.40   25.15   26.55   26.21   27.80   29.90

``` r
#Store our data into a variable name with just the site name. 
VA1 <- filtered_VA1
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(VA1, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for VA1 - Wreck Shoal James River") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

![](VA1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(VA1, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for VA1 - Wreck Shoal James River") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

![](VA1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
VA1_envrmonth_sal <- VA1 %>%
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
VA1_envrmonth_temp <- VA1 %>%
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
print(VA1_envrmonth_sal)
```

    ## # A tibble: 69 × 6
    ## # Groups:   year [14]
    ##     year month min_salinity max_salinity mean_salinity length_salinity
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ##  1  2010     6          9.9         16.8          13.7               3
    ##  2  2010     7         16           20.6          18.0               5
    ##  3  2010     8         18.6         21.1          19.6               4
    ##  4  2010     9         18           19.9          19.2               3
    ##  5  2011     6          9.8         14.6          11.8               5
    ##  6  2011     7         12.4         15.9          13.7               3
    ##  7  2011     8         15.6         18.9          17.2               4
    ##  8  2011     9          9           15.8          12.5               5
    ##  9  2012     5         13.3         13.3          13.3               1
    ## 10  2012     6         11           17.4          13.7               4
    ## # ℹ 59 more rows

``` r
print(VA1_envrmonth_temp)
```

    ## # A tibble: 69 × 6
    ## # Groups:   year [14]
    ##     year month min_temp max_temp mean_temp length_temp
    ##    <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ##  1  2010     6     25.6     29.1      27.3           3
    ##  2  2010     7     27       28.4      27.9           5
    ##  3  2010     8     26.6     29.1      27.7           4
    ##  4  2010     9     24.3     27.9      25.9           3
    ##  5  2011     6     24.8     26.6      26             5
    ##  6  2011     7     27.4     28.4      27.9           3
    ##  7  2011     8     26.1     29        27.7           4
    ##  8  2011     9     23.2     26.3      24.8           5
    ##  9  2012     5     24       24        24             1
    ## 10  2012     6     22.6     25.8      24.6           4
    ## # ℹ 59 more rows

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
VA1_envryear_sal <- VA1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

VA1_envryear_temp <- VA1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(VA1_envryear_sal)
```

    ## # A tibble: 14 × 4
    ##     year min_salinity max_salinity mean_salinity
    ##    <dbl>        <dbl>        <dbl>         <dbl>
    ##  1  2010          9.9         21.1          17.8
    ##  2  2011          9           18.9          13.6
    ##  3  2012         11           21.6          16.2
    ##  4  2013          6.4         20.3          15.0
    ##  5  2014          9.8         18.2          14.2
    ##  6  2015         10.6         19.2          14.9
    ##  7  2016          6.2         18.9          14.5
    ##  8  2017          5.2         21.4          16.9
    ##  9  2018          3.8         15.8          10.5
    ## 10  2019          8.1         19.4          16.2
    ## 11  2020          6.1         19.4          13.4
    ## 12  2021         11.6         21.4          16.3
    ## 13  2022          7.2         21            16.4
    ## 14  2023         12.7         19.4          16.0

``` r
print(VA1_envryear_temp)
```

    ## # A tibble: 14 × 4
    ##     year min_temp max_temp mean_temp
    ##    <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2010     24.3     29.1      27.3
    ##  2  2011     23.2     29        26.4
    ##  3  2012     22.3     29.1      26.0
    ##  4  2013     21.6     27.3      25  
    ##  5  2014     22.6     27.6      25.8
    ##  6  2015     23.4     28.8      26.8
    ##  7  2016     20.4     29.5      26.2
    ##  8  2017     22.3     29        25.7
    ##  9  2018     24.2     29.5      27.0
    ## 10  2019     23       28.6      26.3
    ## 11  2020     20.5     29.9      26.4
    ## 12  2021     20.3     29        25.9
    ## 13  2022     17.4     28.7      26.1
    ## 14  2023     19.6     28.8      26.0

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(VA1_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for VA1 - Deep Water Shoal") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](VA1-EnvrData_files/figure-gfm/timeplot%20-%20salinity-1.png)<!-- -->

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(VA1_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for VA1 - Deep Water Shoal") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

![](VA1-EnvrData_files/figure-gfm/timeplot%20-%20temperature-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(VA1$temp)
Mean_max_temperature_C <- mean(VA1_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(VA1_envryear_temp$min_temp)
Temperature_st_dev <- sd(VA1$temp)
Temperature_n <- nrow(VA1)
Temperature_years <- nrow(VA1_envryear_temp)

#Create a data frame to store the temperature results
VA1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(VA1_temp)
```

    ##      site_name download_date source_description        lat         lon         
    ## [1,] "VA1"     "09-15-2023"  "VIMS Water Quality Data" "37.060283" "-76.572217"
    ##      firstyear finalyear Mean_Annual_Temperature_C Mean_max_temperature_C
    ## [1,] "2010"    "2022"    "26.2118181818182"        "28.85"               
    ##      Mean_min_temperature_C Temperature_st_dev Temperature_n Temperature_years
    ## [1,] "21.7928571428571"     "2.14347184841899" "220"         "14"             
    ##      collection_type
    ## [1,] "intermittent"

``` r
# Write to the combined file with all sites 
write.table(VA1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(VA1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/VA1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(VA1$salinity)
Mean_max_Salinity_ppt <- mean(VA1_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(VA1_envryear_sal$min_salinity)
Salinity_st_dev <- sd(VA1$salinity)
Salinity_n <- nrow(VA1)
Salinity_years <- nrow(VA1_envryear_sal)


#Create a data frame to store the temperature results
VA1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(VA1_salinity)
```

    ##      site_name download_date source_description        lat         lon         
    ## [1,] "VA1"     "09-15-2023"  "VIMS Water Quality Data" "37.060283" "-76.572217"
    ##      firstyear finalyear Mean_Annual_Salinity_ppt Mean_max_Salinity_ppt
    ## [1,] "2010"    "2022"    "15.0545454545455"       "19.7142857142857"   
    ##      Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n Salinity_years
    ## [1,] "8.4"                 "3.75603347478132" "220"      "14"          
    ##      collection_type
    ## [1,] "intermittent"

``` r
# Write to the combined file with all sites 
write.table(VA1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(VA1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/VA1_salinity.csv", row.names = FALSE)
```
