TX2 - Processed Environmental Data
================
Madeline Eppley
7/7/2023

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
#Data was downloaded on 7/7/2023
#Source - https://cdmo.baruch.sc.edu//dges/ - Selected Mission Aransas, Copano Bay West. The station code is MARCWWQ.  

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("07-07-2023")
source_description <- ("NERR Centralized Data. Mission Aransas - Copano Bay West")
site_name <- ("TX2") #Use site code with site number based on lat position and state
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Copano Bay, Texas. The ID_Site for this site is TX2. 
raw_TX2 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/TX2-raw.csv")
```

    ## Rows: 523354 Columns: 30
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (16): Station_Code, isSWMP, DateTimeStamp, F_Record, F_Temp, F_SpCond, F...
    ## dbl (14): Historical, ProvisionalPlus, Temp, SpCond, Sal, DO_pct, DO_mgl, De...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_TX2)
```

    ## cols(
    ##   Station_Code = col_character(),
    ##   isSWMP = col_character(),
    ##   DateTimeStamp = col_character(),
    ##   Historical = col_double(),
    ##   ProvisionalPlus = col_double(),
    ##   F_Record = col_character(),
    ##   Temp = col_double(),
    ##   F_Temp = col_character(),
    ##   SpCond = col_double(),
    ##   F_SpCond = col_character(),
    ##   Sal = col_double(),
    ##   F_Sal = col_character(),
    ##   DO_pct = col_double(),
    ##   F_DO_pct = col_character(),
    ##   DO_mgl = col_double(),
    ##   F_DO_mgl = col_character(),
    ##   Depth = col_double(),
    ##   F_Depth = col_character(),
    ##   cDepth = col_double(),
    ##   F_cDepth = col_character(),
    ##   Level = col_double(),
    ##   F_Level = col_character(),
    ##   cLevel = col_double(),
    ##   F_cLevel = col_character(),
    ##   pH = col_double(),
    ##   F_pH = col_character(),
    ##   Turb = col_double(),
    ##   F_Turb = col_character(),
    ##   ChlFluor = col_double(),
    ##   F_ChlFluor = col_character()
    ## )

``` r
View(raw_TX2)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 
# combined_datetime <- paste(raw_SC2$collection_date, raw_SC2$collection_time) 

# Use unclass to view the way that the time and date are stored 
# unclass(raw_TX2$DateTimeStamp)
# The data is stored in month-day-yearXX hours(12):minutes format

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_TX2$datetime <- as.POSIXct(raw_TX2$DateTimeStamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_TX2)
```

    ##  Station_Code          isSWMP          DateTimeStamp        Historical    
    ##  Length:523354      Length:523354      Length:523354      Min.   :0.0000  
    ##  Class :character   Class :character   Class :character   1st Qu.:1.0000  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :1.0000  
    ##                                                           Mean   :0.8024  
    ##                                                           3rd Qu.:1.0000  
    ##                                                           Max.   :1.0000  
    ##                                                                           
    ##  ProvisionalPlus   F_Record              Temp          F_Temp         
    ##  Min.   :1       Length:523354      Min.   : 2.60   Length:523354     
    ##  1st Qu.:1       Class :character   1st Qu.:18.10   Class :character  
    ##  Median :1       Mode  :character   Median :24.10   Mode  :character  
    ##  Mean   :1                          Mean   :23.15                     
    ##  3rd Qu.:1                          3rd Qu.:29.10                     
    ##  Max.   :1                          Max.   :33.90                     
    ##                                     NA's   :26863                     
    ##      SpCond        F_SpCond              Sal           F_Sal          
    ##  Min.   : 0.13   Length:523354      Min.   : 0.10   Length:523354     
    ##  1st Qu.:17.64   Class :character   1st Qu.:10.40   Class :character  
    ##  Median :30.79   Mode  :character   Median :19.10   Mode  :character  
    ##  Mean   :32.73                      Mean   :20.86                     
    ##  3rd Qu.:48.97                      3rd Qu.:32.00                     
    ##  Max.   :64.92                      Max.   :43.80                     
    ##  NA's   :33247                      NA's   :33247                     
    ##      DO_pct         F_DO_pct             DO_mgl        F_DO_mgl        
    ##  Min.   :  4.60   Length:523354      Min.   : 0.40   Length:523354     
    ##  1st Qu.: 93.40   Class :character   1st Qu.: 6.60   Class :character  
    ##  Median : 97.50   Mode  :character   Median : 7.30   Mode  :character  
    ##  Mean   : 97.68                      Mean   : 7.54                     
    ##  3rd Qu.:102.20                      3rd Qu.: 8.40                     
    ##  Max.   :173.90                      Max.   :13.60                     
    ##  NA's   :39376                       NA's   :43965                     
    ##      Depth          F_Depth              cDepth         F_cDepth        
    ##  Min.   :0.4      Length:523354      Min.   :0.3      Length:523354     
    ##  1st Qu.:1.1      Class :character   1st Qu.:1.0      Class :character  
    ##  Median :1.4      Mode  :character   Median :1.1      Mode  :character  
    ##  Mean   :1.3                         Mean   :1.2                        
    ##  3rd Qu.:1.5                         3rd Qu.:1.4                        
    ##  Max.   :2.2                         Max.   :2.2                        
    ##  NA's   :322098                      NA's   :426464                     
    ##      Level          F_Level              cLevel         F_cLevel        
    ##  Min.   :-1.15    Length:523354      Min.   :-0.61    Length:523354     
    ##  1st Qu.: 0.31    Class :character   1st Qu.: 0.26    Class :character  
    ##  Median : 0.45    Mode  :character   Median : 0.42    Mode  :character  
    ##  Mean   : 0.42                       Mean   : 0.39                      
    ##  3rd Qu.: 0.58                       3rd Qu.: 0.56                      
    ##  Max.   : 1.15                       Max.   : 1.12                      
    ##  NA's   :238905                      NA's   :266391                     
    ##        pH            F_pH                Turb           F_Turb         
    ##  Min.   :7.00    Length:523354      Min.   :  -6.0   Length:523354     
    ##  1st Qu.:8.10    Class :character   1st Qu.:  10.0   Class :character  
    ##  Median :8.20    Mode  :character   Median :  21.0   Mode  :character  
    ##  Mean   :8.17                       Mean   :  33.9                     
    ##  3rd Qu.:8.30                       3rd Qu.:  42.0                     
    ##  Max.   :9.20                       Max.   :1331.0                     
    ##  NA's   :49308                      NA's   :36650                      
    ##     ChlFluor       F_ChlFluor           datetime                     
    ##  Min.   : -0.20   Length:523354      Min.   :2007-07-11 09:30:00.00  
    ##  1st Qu.:  4.40   Class :character   1st Qu.:2011-04-04 07:18:45.00  
    ##  Median :  6.90   Mode  :character   Median :2014-12-27 04:07:30.00  
    ##  Mean   :  8.26                      Mean   :2014-12-27 03:46:17.44  
    ##  3rd Qu.: 10.60                      3rd Qu.:2018-09-20 01:56:15.00  
    ##  Max.   :153.20                      Max.   :2022-06-13 23:45:00.00  
    ##  NA's   :77264                       NA's   :60

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_TX2 <- raw_TX2 %>% rename("temp" = "Temp", "salinity" = "Sal") #No lat and long data in this file - check metadata files

#Print the range (minimum and maximum) of dates of data collection. 
print(range(raw_TX2$DateTimeStamp))
```

    ## [1] "1/1/08 0:00" "9/9/21 9:45"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_TX2$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.10   10.40   19.10   20.86   32.00   43.80   33247

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_TX2$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    2.60   18.10   24.10   23.15   29.10   33.90   26863

``` r
#Store variables that we will include in the final data frame
lat <- 28.08410
lon <- -97.20090
firstyear <- 2008
finalyear <- 2021
```

### We can see that some of the values make sense - the minimum and maximum latitude and longitude values are the same.

Filter any of the variables that have data points outside of normal
range. We will use 0-40 as the accepted range for salinity (ppt) and
temperature (C) values. Note, in the summer, salinity values can
sometimes exceed 40. Check to see if there are values above 40. In this
case, adjust the range or notify someone that the site has particularly
high salinity values.

``` r
#Filter the data between the values of 0 and 40 for both salinity and temperature. 
filtered_TX2 <- raw_TX2 %>%
    filter(between(salinity, 0, 44) & between(temp, 0, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_TX2$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.10   10.40   19.10   20.86   32.00   43.80

``` r
print(summary(filtered_TX2$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    2.60   18.10   24.00   23.11   29.10   33.90

``` r
#Store our data into a variable name with just the site name. 
TX2 <- filtered_TX2
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(TX2, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for TX2 - Copano Bay") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

    ## Warning: Removed 60 rows containing missing values (`geom_line()`).

![](TX2-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(TX2, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for TX2 - Copano Bay") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

    ## Warning: Removed 60 rows containing missing values (`geom_line()`).

![](TX2-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
TX2_envrmonth <- TX2 %>%
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
print(TX2_envrmonth)
```

    ## # A tibble: 181 × 10
    ## # Groups:   year [17]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2007     7          0.1          2.7          1.08            1978     24.9
    ##  2  2007     8          0.2          3            1.49            2975     28.5
    ##  3  2007     9          1.3          3.5          2.49            2710     27.7
    ##  4  2007    10          2.8          3.8          3.16            2841     17.9
    ##  5  2007    11          3.6          6.3          4.40            2879     11.6
    ##  6  2007    12          5.3          6.7          6.06            2975     13  
    ##  7  2008     1          6.5          9.6          8.37            2975      9  
    ##  8  2008     2          8.5         10.2          9.39            2784     12.9
    ##  9  2008     3          9.6         12.4         10.8             2972     12.9
    ## 10  2008     4          9.9         14.6         12.9             2879     20.1
    ## # ℹ 171 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
TX2_envryear <- TX2 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(TX2_envryear)
```

    ## # A tibble: 17 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2007          0.1          6.7          3.24     11.6     33.2      24.8
    ##  2  2008          6.5         29.5         18.2       9       32.2      22.6
    ##  3  2009          4.9         43.8         32.8       8.9     32.3      22.9
    ##  4  2010          0.1         14.8          7.92      4.8     33.9      22.7
    ##  5  2011          7           39.6         24.3       4.7     32.6      23.1
    ##  6  2012          5.9         39.8         32.2      10.5     32.4      23.9
    ##  7  2013         27.9         42.1         36.3       8.4     31.8      22.6
    ##  8  2014         20.9         42.2         36.4       6.9     31.9      22.0
    ##  9  2015          0.1         37.5         14.5       6.6     32.7      23.4
    ## 10  2016          2.2         18.6         13.5       9.5     33.1      24.0
    ## 11  2017          0.1         23.5         15.3       7.1     32.5      24.3
    ## 12  2018          0.5         27.1         14.4       5.5     32.6      22.8
    ## 13  2019          2.9         25.1         17.0      10       32.4      22.9
    ## 14  2020         13.4         31.5         26.2      11.8     33.1      23.4
    ## 15  2021          0.1         30.8         13.7       2.6     33.9      23.4
    ## 16  2022          8.9         25.9         16.7       6.5     31.3      20.2
    ## 17    NA          6.7         35.3         21.7      11.4     22.4      17.9

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(TX2_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for TX2 - Copano Bay") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

    ## Warning: Removed 1 rows containing missing values (`geom_point()`).

![](TX2-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(TX2$temp)
Mean_max_temperature_C <- mean(TX2_envryear$max_temp)
Mean_min_temperature_C <- mean(TX2_envryear$min_temp)
Temperature_st_dev <- sd(TX2$temp)
Temperature_n <- nrow(TX2)
Temperature_years <- nrow(TX2_envryear)

#Create a data frame to store the temperature results
TX2_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years)
print(TX2_temp)
```

    ##      site_name download_date
    ## [1,] "TX2"     "07-07-2023" 
    ##      source_description                                         lat      
    ## [1,] "NERR Centralized Data. Mission Aransas - Copano Bay West" "28.0841"
    ##      lon        firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "-97.2009" "2008"    "2021"    "23.1054088188906"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "32.0176470588235"     "7.98823529411765"     "6.38546821611257"
    ##      Temperature_n Temperature_years
    ## [1,] "490107"      "17"

``` r
# Write to the combined file with all sites 
write.table(TX2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(TX2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/TX2_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(TX2$salinity)
Mean_max_Salinity_ppt <- mean(TX2_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(TX2_envryear$min_salinity)
Salinity_st_dev <- sd(TX2$salinity)
Salinity_n <- nrow(TX2)
Salinity_years <- nrow(TX2_envryear)


#Create a data frame to store the temperature results
TX2_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years)
print(TX2_salinity)
```

    ##      site_name download_date
    ## [1,] "TX2"     "07-07-2023" 
    ##      source_description                                         lat      
    ## [1,] "NERR Centralized Data. Mission Aransas - Copano Bay West" "28.0841"
    ##      lon        firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "-97.2009" "2008"    "2021"    "20.8578965409594"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "30.2235294117647"    "6.36470588235294"    "11.6639351083855" "490107"  
    ##      Salinity_years
    ## [1,] "17"

``` r
# Write to the combined file with all sites 
write.table(TX2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(TX2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/TX2_salinity.csv")
```
