MA1 - Processed Environmental Data
================
Madeline Eppley
3/20/2024

``` r
setwd("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData")
```

### Load required packages.

``` r
library("dplyr") #Used for working with data frames
library("lubridate") #Used for time-date conversions
library("readr") #Used to read the CSV file
library("ggplot2") 
```

### Note the date of data download and source. All available data should be used for each site regardless of year. Note from the CSV file how often the site was sampled, and if there are replicates in the data. Also describe if the sampling occurred at only low tide, only high tide, or continuously.

``` r
#Data was downloaded on 03/21/2024
#Source - https://portal.edirepository.org/nis/home.jsp 
#The site was sampled continuously and seasonally

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("03-21-2024")
source_description <- ("PIELTER Long-Term Montitoring Data")
site_name <- ("MA1") #Use site code with site number based on lat position and state
collection_type <- ("continuous_seasonal")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Lower Cedar Point, Maryland. The ID_Site for this site is MA1. 
raw_MA1<- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/MA1-raw.csv")
```

    ## Rows: 15257 Columns: 4
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Timestamp, Station
    ## dbl (2): Temp, Salinity
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
raw_MA1_2014 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/MA1-raw_2014.csv")
```

    ## Rows: 13342 Columns: 4
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Timestamp, Station
    ## dbl (2): Temp, Salinity
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
raw_MA1_2015 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/MA1-raw_2015.csv")
```

    ## Rows: 9672 Columns: 4
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Timestamp, Station
    ## dbl (2): Temp, Salinity
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
raw_MA1_2016 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/MA1-raw_2016.csv")
```

    ## Rows: 18119 Columns: 4
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Timestamp, Station
    ## dbl (2): Temp, Salinity
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
raw_MA1_2017 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/MA1-raw_2017.csv")
```

    ## Rows: 17367 Columns: 4
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Timestamp, Station
    ## dbl (2): Temp, Salinity
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
raw_MA1_2018 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/MA1-raw_2018.csv")
```

    ## Rows: 20810 Columns: 4
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Timestamp, Station
    ## dbl (2): Temp, Salinity
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_MA1)
```

    ## cols(
    ##   Timestamp = col_character(),
    ##   Station = col_character(),
    ##   Temp = col_double(),
    ##   Salinity = col_double()
    ## )

``` r
#View(raw_MA1_sal)

spec(raw_MA1_2014)
```

    ## cols(
    ##   Timestamp = col_character(),
    ##   Station = col_character(),
    ##   Temp = col_double(),
    ##   Salinity = col_double()
    ## )

``` r
#View(raw_MA1_temp)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_MA1_2014$datetime <- as.POSIXct(raw_MA1_2014$Timestamp, "%m/%d/%y %H:%M", tz = "")
raw_MA1_2015$datetime <- as.POSIXct(raw_MA1_2015$Timestamp, "%m/%d/%y %H:%M", tz = "")
raw_MA1_2016$datetime <- as.POSIXct(raw_MA1_2016$Timestamp, "%m/%d/%y %H:%M", tz = "")
raw_MA1_2017$datetime <- as.POSIXct(raw_MA1_2017$Timestamp, "%m/%d/%y %H:%M", tz = "")
raw_MA1_2018$datetime <- as.POSIXct(raw_MA1_2018$Timestamp, "%m/%d/%y %H:%M", tz = "")
raw_MA1$datetime <- as.POSIXct(raw_MA1$Timestamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
head(raw_MA1)
```

    ## # A tibble: 6 × 5
    ##   Timestamp     Station  Temp Salinity datetime           
    ##   <chr>         <chr>   <dbl>    <dbl> <dttm>             
    ## 1 5/12/22 15:00 RR       16.2    10.8  2022-05-12 15:00:00
    ## 2 5/12/22 15:15 RR       16.2    10.3  2022-05-12 15:15:00
    ## 3 5/12/22 15:30 RR       16.3     9.93 2022-05-12 15:30:00
    ## 4 5/12/22 15:45 RR       16.4     9.56 2022-05-12 15:45:00
    ## 5 5/12/22 16:00 RR       16.4     9.59 2022-05-12 16:00:00
    ## 6 5/12/22 16:15 RR       16.5    10.6  2022-05-12 16:15:00

``` r
head(raw_MA1_2014)
```

    ## # A tibble: 6 × 5
    ##   Timestamp           Station  Temp Salinity datetime
    ##   <chr>               <chr>   <dbl>    <dbl> <dttm>  
    ## 1 17-06-2014 11:45:00 RR       20.8     15.7 NA      
    ## 2 17-06-2014 12:00:00 RR       20.9     16.4 NA      
    ## 3 17-06-2014 12:15:00 RR       20.8     17.3 NA      
    ## 4 17-06-2014 12:30:00 RR       20.9     18.5 NA      
    ## 5 17-06-2014 12:45:00 RR       20.9     19.4 NA      
    ## 6 17-06-2014 13:00:00 RR       20.8     20.0 NA

### Merge all separate .CSV files together

``` r
raw_MA1 <- rbind(raw_MA1, raw_MA1_2014, raw_MA1_2015, raw_MA1_2016, raw_MA1_2017, raw_MA1_2018)
```

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_MA1 <- raw_MA1 %>% rename("salinity" = "Salinity")
raw_MA1 <- raw_MA1  %>% rename("temp" = "Temp")

#Store variables that we will include in the final data frame
lat <- 42.762543
lon <- -70.857724
firstyear <- 2014
finalyear <- 2022
```

### Filter any of the variables that have data points outside of normal range. We will use 0-40 as the accepted range for salinity (ppt) and temperature (C) values. Note, in the summer, salinity values can sometimes exceed 40. Check to see if there are values above 40. In this case, adjust the range or notify someone that the site has particularly high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_MA1 <- raw_MA1 %>%
    filter(between(salinity, 0, 42)) 
           
filtered_MA1 <- raw_MA1 %>%
    filter(between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_MA1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.60   17.75   23.90   22.37   28.18   32.86

``` r
print(summary(filtered_MA1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    3.68   15.35   19.92   18.94   23.12   28.86

``` r
#Store our data into a variable name with just the site name. 
MA1 <- filtered_MA1
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(MA1, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,40) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for MA1 - Plum Island") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()

salplot
```

    ## Warning: Removed 35431 rows containing missing values or values outside the scale range
    ## (`geom_line()`).

![](MA1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(MA1, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for MA1 - Plum Island") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

    ## Warning: Removed 35431 rows containing missing values or values outside the scale range
    ## (`geom_line()`).

![](MA1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
MA1_envrmonth_sal <- MA1 %>%
    mutate(year = year(datetime), month = month(datetime)) %>%
    group_by(year, month) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      length_salinity = length(salinity))
```

    ## `summarise()` has grouped output by 'year'. You can override using the `.groups` argument.

``` r
MA1_envrmonth_temp <- MA1 %>%
    mutate(year = year(datetime), month = month(datetime)) %>%
    group_by(year, month) %>%
    summarise(      
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp),
      length_temp = length(temp))
```

    ## `summarise()` has grouped output by 'year'. You can override using the `.groups` argument.

``` r
print(MA1_envrmonth_sal)
```

    ## # A tibble: 67 × 6
    ## # Groups:   year [7]
    ##     year month min_salinity max_salinity mean_salinity length_salinity
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>
    ##  1  2014     1         9.22         29.8          22.6             364
    ##  2  2014     2        10.2          28.4          22.1             358
    ##  3  2014     3         9.4          27.9          23.2             308
    ##  4  2014     4        16.3          26.6          23.6             214
    ##  5  2014     5        14.5          24.8          21.6             173
    ##  6  2014     6        11.4          24.7          20.5             187
    ##  7  2014     7        13.0          25.1          20.7             141
    ##  8  2014     8        16.9          26.7          22.4             123
    ##  9  2014     9        13.6          27.5          21.2             177
    ## 10  2014    10        14.1          28.0          22.3             164
    ## # ℹ 57 more rows

``` r
print(MA1_envrmonth_temp)
```

    ## # A tibble: 67 × 6
    ## # Groups:   year [7]
    ##     year month min_temp max_temp mean_temp length_temp
    ##    <dbl> <dbl>    <dbl>    <dbl>     <dbl>       <int>
    ##  1  2014     1     9.4      24.9      18.4         364
    ##  2  2014     2     6.99     26.1      17.7         358
    ##  3  2014     3     5.46     26.5      19.4         308
    ##  4  2014     4    14.3      26.1      20.2         214
    ##  5  2014     5    14.8      24.9      19.1         173
    ##  6  2014     6    14.2      24.4      18.9         187
    ##  7  2014     7    14.6      23.8      17.7         141
    ##  8  2014     8    15.6      25.9      18.5         123
    ##  9  2014     9    15.4      26.1      20.7         177
    ## 10  2014    10    14.6      25.9      19.7         164
    ## # ℹ 57 more rows

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
MA1_envryear_sal <- MA1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity))

MA1_envryear_temp <- MA1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(MA1_envryear_sal)
```

    ## # A tibble: 7 × 4
    ##    year min_salinity max_salinity mean_salinity
    ##   <dbl>        <dbl>        <dbl>         <dbl>
    ## 1  2014         9.22         29.8          22.2
    ## 2  2015         8.1          29.9          22.4
    ## 3  2016         8.18         32.4          25.2
    ## 4  2017         0.73         29.8          18.9
    ## 5  2018         0.6          30.2          17.4
    ## 6  2022         9.34         32.9          27.8
    ## 7    NA         0.82         32.7          21.0

``` r
print(MA1_envryear_temp)
```

    ## # A tibble: 7 × 4
    ##    year min_temp max_temp mean_temp
    ##   <dbl>    <dbl>    <dbl>     <dbl>
    ## 1  2014     5.46     26.5      18.8
    ## 2  2015    11.5      25.5      19.7
    ## 3  2016     8.78     27.3      18.5
    ## 4  2017    10.4      25.0      17.5
    ## 5  2018     3.74     28.1      17.1
    ## 6  2022    12.2      28.9      21.2
    ## 7    NA     3.68     27.4      18.6

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(MA1_envrmonth_sal, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Salinity Timeplot for MA1 - Plum Island") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

    ## Warning: Removed 1 row containing missing values or values outside the scale range (`geom_point()`).

![](MA1-EnvrData_files/figure-gfm/timeplot%20-%20salinity-1.png)<!-- -->

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(MA1_envrmonth_temp, aes(x = year)) +
    geom_point(aes(y = month, color = length_temp), size = 4) +
    labs(x = "Time", y = "Month", title = "Temperature Timeplot for MA1 - Plum Island") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

    ## Warning: Removed 1 row containing missing values or values outside the scale range (`geom_point()`).

![](MA1-EnvrData_files/figure-gfm/timeplot%20-%20temperature-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(MA1$temp)
Mean_max_temperature_C <- mean(MA1_envryear_temp$max_temp)
Mean_min_temperature_C <- mean(MA1_envryear_temp$min_temp)
Temperature_st_dev <- sd(MA1$temp)
Temperature_n <- nrow(MA1)
Temperature_years <- nrow(MA1_envryear_temp)

#Create a data frame to store the temperature results
MA1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(MA1_temp)
```

    ##      site_name download_date source_description                   lat         lon          firstyear
    ## [1,] "MA1"     "03-21-2024"  "PIELTER Long-Term Montitoring Data" "42.762543" "-70.857724" "2014"   
    ##      finalyear Mean_Annual_Temperature_C Mean_max_temperature_C Mean_min_temperature_C
    ## [1,] "2022"    "18.9376238662831"        "26.9554285714286"     "7.96671428571429"    
    ##      Temperature_st_dev Temperature_n Temperature_years collection_type      
    ## [1,] "5.1213203634221"  "72990"       "7"               "continuous_seasonal"

``` r
# Write to the combined file with all sites 
write.table(MA1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(MA1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/MA1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(MA1$salinity)
Mean_max_Salinity_ppt <- mean(MA1_envryear_sal$max_salinity)
Mean_min_Salinity_ppt <- mean(MA1_envryear_sal$min_salinity)
Salinity_st_dev <- sd(MA1$salinity)
Salinity_n <- nrow(MA1)
Salinity_years <- nrow(MA1_envryear_sal)


#Create a data frame to store the temperature results
MA1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(MA1_salinity)
```

    ##      site_name download_date source_description                   lat         lon          firstyear
    ## [1,] "MA1"     "03-21-2024"  "PIELTER Long-Term Montitoring Data" "42.762543" "-70.857724" "2014"   
    ##      finalyear Mean_Annual_Salinity_ppt Mean_max_Salinity_ppt Mean_min_Salinity_ppt
    ## [1,] "2022"    "22.3683140156186"       "31.0942857142857"    "5.28428571428571"   
    ##      Salinity_st_dev    Salinity_n Salinity_years collection_type      
    ## [1,] "7.34753323475334" "72990"    "7"            "continuous_seasonal"

``` r
# Write to the combined file with all sites 
write.table(MA1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(MA1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/MA1_salinity.csv", row.names = FALSE)
```
