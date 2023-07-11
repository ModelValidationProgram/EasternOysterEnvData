AL1 - Processed Environmental Data
================
Madeline Eppley
7/11/2023

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
#Source - https://cdmo.baruch.sc.edu//dges/ - Selected Grand Bay, Point Aux Chenes Bay. The station code is GNDPCWQ.  

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("07-11-2023")
source_description <- ("NERR Centralized Data. Grand Bay - Point Aux Chenes Bay GNDPCWQ")
site_name <- ("AL1") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Copano Bay, Texas. The ID_Site for this site is TX2. 
raw_AL1 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/AL1-raw.csv")
```

    ## Rows: 582279 Columns: 24
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (13): Station_Code, isSWMP, DateTimeStamp, F_Record, F_Temp, F_SpCond, F...
    ## dbl (11): Historical, ProvisionalPlus, Temp, SpCond, Sal, DO_pct, DO_mgl, De...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_AL1)
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
    ##   pH = col_double(),
    ##   F_pH = col_character(),
    ##   Turb = col_double(),
    ##   F_Turb = col_character()
    ## )

``` r
View(raw_AL1)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 

# Use unclass to view the way that the time and date are stored 
# unclass(raw_AL1$DateTimeStamp)
# The data is stored in month-day-yearXX hours(12):minutes format

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_AL1$datetime <- as.POSIXct(raw_AL1$DateTimeStamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_AL1)
```

    ##  Station_Code          isSWMP          DateTimeStamp        Historical    
    ##  Length:582279      Length:582279      Length:582279      Min.   :0.0000  
    ##  Class :character   Class :character   Class :character   1st Qu.:1.0000  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :1.0000  
    ##                                                           Mean   :0.9611  
    ##                                                           3rd Qu.:1.0000  
    ##                                                           Max.   :1.0000  
    ##                                                                           
    ##  ProvisionalPlus    F_Record              Temp          F_Temp         
    ##  Min.   :0.0000   Length:582279      Min.   : 1.80   Length:582279     
    ##  1st Qu.:1.0000   Class :character   1st Qu.:16.90   Class :character  
    ##  Median :1.0000   Mode  :character   Median :23.60   Mode  :character  
    ##  Mean   :0.9882                      Mean   :22.67                     
    ##  3rd Qu.:1.0000                      3rd Qu.:28.90                     
    ##  Max.   :1.0000                      Max.   :41.20                     
    ##                                      NA's   :63020                     
    ##      SpCond         F_SpCond              Sal            F_Sal          
    ##  Min.   : 1.88    Length:582279      Min.   : 1.00    Length:582279     
    ##  1st Qu.:29.34    Class :character   1st Qu.:18.10    Class :character  
    ##  Median :36.09    Mode  :character   Median :22.80    Mode  :character  
    ##  Mean   :34.77                       Mean   :21.93                      
    ##  3rd Qu.:41.53                       3rd Qu.:26.60                      
    ##  Max.   :59.03                       Max.   :39.40                      
    ##  NA's   :113542                      NA's   :113542                     
    ##      DO_pct        F_DO_pct             DO_mgl         F_DO_mgl        
    ##  Min.   :  0.8   Length:582279      Min.   : 0.10    Length:582279     
    ##  1st Qu.: 89.1   Class :character   1st Qu.: 6.40    Class :character  
    ##  Median : 97.7   Mode  :character   Median : 7.50    Mode  :character  
    ##  Mean   : 96.7                      Mean   : 7.59                      
    ##  3rd Qu.:106.2                      3rd Qu.: 8.80                      
    ##  Max.   :225.3                      Max.   :19.60                      
    ##  NA's   :98710                      NA's   :147053                     
    ##      Depth          F_Depth              cDepth         F_cDepth        
    ##  Min.   :-0.01    Length:582279      Min.   :0.15     Length:582279     
    ##  1st Qu.: 0.99    Class :character   1st Qu.:1.04     Class :character  
    ##  Median : 1.18    Mode  :character   Median :1.21     Mode  :character  
    ##  Mean   : 1.17                       Mean   :1.20                       
    ##  3rd Qu.: 1.35                       3rd Qu.:1.38                       
    ##  Max.   : 5.19                       Max.   :2.89                       
    ##  NA's   :122634                      NA's   :296510                     
    ##        pH            F_pH                Turb            F_Turb         
    ##  Min.   :6.40    Length:582279      Min.   :  -4.00   Length:582279     
    ##  1st Qu.:7.90    Class :character   1st Qu.:   6.00   Class :character  
    ##  Median :8.10    Mode  :character   Median :  13.00   Mode  :character  
    ##  Mean   :8.04                       Mean   :  33.98                     
    ##  3rd Qu.:8.20                       3rd Qu.:  25.00                     
    ##  Max.   :9.00                       Max.   :3539.00                     
    ##  NA's   :94556                      NA's   :105859                      
    ##     datetime                     
    ##  Min.   :2005-08-11 10:30:00.00  
    ##  1st Qu.:2010-03-11 22:00:00.00  
    ##  Median :2014-05-06 07:15:00.00  
    ##  Mean   :2014-05-04 06:23:15.50  
    ##  3rd Qu.:2018-06-30 15:30:00.00  
    ##  Max.   :2022-08-24 23:45:00.00  
    ##  NA's   :66

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_AL1 <- raw_AL1 %>% rename("temp" = "Temp", "salinity" = "Sal") #No lat and long data in this file - check metadata files

#Print the range (minimum and maximum) of dates of data collection. 
print(summary(raw_AL1$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2005-08-11 10:30:00.0000" "2010-03-11 22:00:00.0000" 
    ##                     Median                       Mean 
    ## "2014-05-06 07:15:00.0000" "2014-05-04 06:23:15.5067" 
    ##                    3rd Qu.                       Max. 
    ## "2018-06-30 15:30:00.0000" "2022-08-24 23:45:00.0000" 
    ##                       NA's 
    ##                       "66"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_AL1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    1.00   18.10   22.80   21.93   26.60   39.40  113542

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_AL1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    1.80   16.90   23.60   22.67   28.90   41.20   63020

``` r
#Store variables that we will include in the final data frame. Pull metadata from metadata file in download .zip file. 
lat <- 30.34860
lon <- -88.41850
firstyear <- 2005
finalyear <- 2022
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
filtered_AL1 <- raw_AL1 %>%
    filter(between(salinity, 0, 40) & between(temp, 0, 42))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_AL1$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00   18.10   22.80   21.93   26.60   39.40

``` r
print(summary(filtered_AL1$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.80   16.60   23.30   22.45   28.90   41.20

``` r
#Store our data into a variable name with just the site name. 
AL1 <- filtered_AL1
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(AL1, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for AL1 - Cedar Point Reef") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

    ## Warning: Removed 58 rows containing missing values (`geom_line()`).

![](AL1-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(AL1, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(0, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for AL1 - Cedar Point Reef") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

    ## Warning: Removed 58 rows containing missing values (`geom_line()`).

![](AL1-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
AL1_envrmonth <- AL1 %>%
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
print(AL1_envrmonth)
```

    ## # A tibble: 191 × 10
    ## # Groups:   year [19]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2005     8         17.2         23            20.1             987     26  
    ##  2  2005     9         20           26.9          23.0             609     27.2
    ##  3  2005    10         21.2         30.2          26.3            1488     14.5
    ##  4  2005    11         27.8         32.1          29.5            1440     10.8
    ##  5  2005    12         27.1         31            29.3            1487      7.7
    ##  6  2006     1         19.5         31.2          27.7            1488      9.9
    ##  7  2006     2         11.5         27.5          21.1            1344      8.2
    ##  8  2006     3          9.6         27.1          19.1            1467     11.8
    ##  9  2006     4         15.3         23.5          20.0            1438     19.5
    ## 10  2006     5         16.7         30.6          22.3            1488     21.8
    ## # ℹ 181 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
AL1_envryear <- AL1 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(AL1_envryear)
```

    ## # A tibble: 19 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2005         17.2         32.1          26.5      7.7     33.7      21.1
    ##  2  2006          9.6         31.2          25.6      6       41.2      23.1
    ##  3  2007         14           31.9          26.4      5.6     34.3      22.4
    ##  4  2008         12.3         39.4          23.1      4.7     32.8      21.4
    ##  5  2009          5.6         30.9          19.4      6.8     33.7      23.6
    ##  6  2010          1           32.4          22.0      3.2     34.1      21.7
    ##  7  2011          6.1         32.6          23.2      4       33.8      22.1
    ##  8  2012          4.3         31.7          23.4      8.9     33.5      22.9
    ##  9  2013          6.1         29.7          20.2      8.8     32.9      22.2
    ## 10  2014          4.5         33.2          22.0      3.5     33.3      22.4
    ## 11  2015          8.5         31.9          23.1      6.4     33.8      22.9
    ## 12  2016          9.1         31.9          22.3      7.1     33.9      21.8
    ## 13  2017          5.3         29.2          19.7      4.8     33.6      21.8
    ## 14  2018          5.7         31.7          22.1      1.8     34.4      22.3
    ## 15  2019          3.3         27.5          18.3      9.2     33.9      22.7
    ## 16  2020          3.9         30.5          17.2      9.9     34.4      24.0
    ## 17  2021         15.7         28.3          23.1     11.9     28.8      20.4
    ## 18  2022          7.1         27.5          18.8      5.5     33.9      23.2
    ## 19    NA         10.4         26.9          19.7     12       23.9      16.8

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(AL1_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for AL1 - Cedar Point Reef") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

    ## Warning: Removed 1 rows containing missing values (`geom_point()`).

![](AL1-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(AL1$temp)
Mean_max_temperature_C <- mean(AL1_envryear$max_temp)
Mean_min_temperature_C <- mean(AL1_envryear$min_temp)
Temperature_st_dev <- sd(AL1$temp)
Temperature_n <- nrow(AL1)
Temperature_years <- nrow(AL1_envryear)

#Create a data frame to store the temperature results
AL1_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(AL1_temp)
```

    ##      site_name download_date
    ## [1,] "AL1"     "07-11-2023" 
    ##      source_description                                               
    ## [1,] "NERR Centralized Data. Grand Bay - Point Aux Chenes Bay GNDPCWQ"
    ##      lat       lon        firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "30.3486" "-88.4185" "2005"    "2022"    "22.4536938624431"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "33.3631578947368"     "6.72631578947368"     "6.89561189615538"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "468737"      "19"              "continuous"

``` r
# Write to the combined file with all sites 
write.table(AL1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(AL1_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/AL1_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(AL1$salinity)
Mean_max_Salinity_ppt <- mean(AL1_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(AL1_envryear$min_salinity)
Salinity_st_dev <- sd(AL1$salinity)
Salinity_n <- nrow(AL1)
Salinity_years <- nrow(AL1_envryear)


#Create a data frame to store the temperature results
AL1_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(AL1_salinity)
```

    ##      site_name download_date
    ## [1,] "AL1"     "07-11-2023" 
    ##      source_description                                               
    ## [1,] "NERR Centralized Data. Grand Bay - Point Aux Chenes Bay GNDPCWQ"
    ##      lat       lon        firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "30.3486" "-88.4185" "2005"    "2022"    "21.934934302178"       
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev    Salinity_n
    ## [1,] "31.0789473684211"    "7.87894736842105"    "5.75666706161516" "468737"  
    ##      Salinity_years collection_type
    ## [1,] "19"           "continuous"

``` r
# Write to the combined file with all sites 
write.table(AL1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(AL1_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/AL1_salinity.csv")
```
