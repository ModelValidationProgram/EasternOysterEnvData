RI2 - Processed Environmental Data
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
#Data was downloaded on 7/11/2023
#Source - https://cdmo.baruch.sc.edu//dges/- Selected Narragansett Bay, T-Wharf Bottom. The station code is NARTBWQ

#Create text strings with metadata information that we want to include in the final data frame. 
download_date <- ("07-11-2023")
source_description <- ("NERR Centralized Data. Narragansett Bay T-Wharf Bottom NARTBWQ")
site_name <- ("RI2") #Use site code with site number based on lat position and state
collection_type <- ("continuous")
```

### Use the file path name in your working directory or desktop, see example below. Or, import data set through the “Files” window in R studio. Store the file in a variable with the “raw_ID_Site” format. If salinity and temperature data are in separate files, read in both and store them with “\_sal” or “\_temp” in the variable names.

``` r
#The file we will be working with is from Narragansett Bay, Rhode Island. The ID_Site for this site is RI2. 
raw_RI2 <- read_csv("/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/RI2-raw.csv")
```

    ## Rows: 672302 Columns: 24
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (13): Station_Code, isSWMP, DateTimeStamp, F_Record, F_Temp, F_SpCond, F...
    ## dbl (11): Historical, ProvisionalPlus, Temp, SpCond, Sal, DO_pct, DO_mgl, De...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# View how the data is stored. Note the variable names and the format and units that the data are stored in.  
spec(raw_RI2)
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
View(raw_RI2)
```

### Start with the date and time of collection. We will use the lubridate package to standardize all values into the date-time format called POSIXct. This format stores the date and time in number of seconds since a past point (1/1/1970). This makes comparisons easy and helps to standardizes values.

``` r
# SKIP combining, date and time of collection is already in a column together 

# Use unclass to view the way that the time and date are stored 
# unclass(raw_RI2$DateTimeStamp)
# The data is stored in month-day-yearXX hours(12):minutes format

#Convert to POSIXct format. Store it into a column named datetime in the data frame.
raw_RI2$datetime <- as.POSIXct(raw_RI2$DateTimeStamp, "%m/%d/%y %H:%M", tz = "")

#Print the new data frame and examine to make sure the new datetime column is in the correct format. 
summary(raw_RI2)
```

    ##  Station_Code          isSWMP          DateTimeStamp        Historical    
    ##  Length:672302      Length:672302      Length:672302      Min.   :0.0000  
    ##  Class :character   Class :character   Class :character   1st Qu.:1.0000  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :1.0000  
    ##                                                           Mean   :0.9149  
    ##                                                           3rd Qu.:1.0000  
    ##                                                           Max.   :1.0000  
    ##                                                                           
    ##  ProvisionalPlus   F_Record              Temp          F_Temp         
    ##  Min.   :0       Length:672302      Min.   :-2.00   Length:672302     
    ##  1st Qu.:1       Class :character   1st Qu.: 5.90   Class :character  
    ##  Median :1       Mode  :character   Median :12.00   Mode  :character  
    ##  Mean   :1                          Mean   :12.25                     
    ##  3rd Qu.:1                          3rd Qu.:18.90                     
    ##  Max.   :1                          Max.   :26.00                     
    ##                                     NA's   :34151                     
    ##      SpCond        F_SpCond              Sal           F_Sal          
    ##  Min.   : 0.23   Length:672302      Min.   : 0.10   Length:672302     
    ##  1st Qu.:46.49   Class :character   1st Qu.:30.00   Class :character  
    ##  Median :47.39   Mode  :character   Median :30.60   Mode  :character  
    ##  Mean   :47.31                      Mean   :30.53                     
    ##  3rd Qu.:48.18                      3rd Qu.:31.20                     
    ##  Max.   :58.46                      Max.   :37.90                     
    ##  NA's   :42606                      NA's   :42606                     
    ##      DO_pct        F_DO_pct             DO_mgl        F_DO_mgl        
    ##  Min.   :  0.0   Length:672302      Min.   : 0.00   Length:672302     
    ##  1st Qu.: 86.1   Class :character   1st Qu.: 6.80   Class :character  
    ##  Median : 93.5   Mode  :character   Median : 8.40   Mode  :character  
    ##  Mean   : 91.5                      Mean   : 8.33                     
    ##  3rd Qu.: 98.5                      3rd Qu.: 9.80                     
    ##  Max.   :171.5                      Max.   :15.30                     
    ##  NA's   :47446                      NA's   :51165                     
    ##      Depth         F_Depth              cDepth         F_cDepth        
    ##  Min.   :0.13    Length:672302      Min.   :0.36     Length:672302     
    ##  1st Qu.:5.32    Class :character   1st Qu.:5.31     Class :character  
    ##  Median :5.65    Mode  :character   Median :5.62     Mode  :character  
    ##  Mean   :5.69                       Mean   :5.66                       
    ##  3rd Qu.:6.07                       3rd Qu.:6.02                       
    ##  Max.   :7.68                       Max.   :7.54                       
    ##  NA's   :37884                      NA's   :277216                     
    ##        pH            F_pH                Turb           F_Turb         
    ##  Min.   :6.30    Length:672302      Min.   : -4.00   Length:672302     
    ##  1st Qu.:7.90    Class :character   1st Qu.:  1.00   Class :character  
    ##  Median :8.00    Mode  :character   Median :  1.00   Mode  :character  
    ##  Mean   :7.99                       Mean   :  1.56                     
    ##  3rd Qu.:8.10                       3rd Qu.:  2.00                     
    ##  Max.   :9.30                       Max.   :973.00                     
    ##  NA's   :40096                      NA's   :40657                      
    ##     datetime                     
    ##  Min.   :2002-07-03 11:30:00.00  
    ##  1st Qu.:2008-04-02 15:33:45.00  
    ##  Median :2013-01-17 09:37:30.00  
    ##  Mean   :2013-01-08 16:10:16.08  
    ##  3rd Qu.:2017-11-03 04:41:15.00  
    ##  Max.   :2022-08-19 23:45:00.00  
    ##  NA's   :76

### Analyze the ranges of all of our variables of interest - time, salinity, and temperature. Make sure that the latitude and longitude values are consistent for a static collection site. This is a quick check so we can determine how to conduct the next filtering step.

``` r
#Standardize column and variable names. We will use "temp" for temperature in degrees C, "salinity" for salinity in parts per thousand (ppt), "lat" for latitude in degrees, and "lon" for longitude in degrees. 
#Use the dyplr format to rename multiple columns in the format "dataframe %>% rename("new name 1" = "old name 1", "new name 2", "old name 2")
raw_RI2 <- raw_RI2 %>% rename("temp" = "Temp", "salinity" = "Sal") #No lat and long data in this file - check metadata files

#Print the range (minimum and maximum) of dates of data collection. 
print(summary(raw_RI2$datetime))
```

    ##                       Min.                    1st Qu. 
    ## "2002-07-03 11:30:00.0000" "2008-04-02 15:33:45.0000" 
    ##                     Median                       Mean 
    ## "2013-01-17 09:37:30.0000" "2013-01-08 16:10:16.0852" 
    ##                    3rd Qu.                       Max. 
    ## "2017-11-03 04:41:15.0000" "2022-08-19 23:45:00.0000" 
    ##                       NA's 
    ##                       "76"

``` r
#Print the range (minimum and maximum) of the salinity values. 
print(summary(raw_RI2$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.10   30.00   30.60   30.53   31.20   37.90   42606

``` r
#Print the range (minimum and maximum) of the temperature values.
print(summary(raw_RI2$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   -2.00    5.90   12.00   12.25   18.90   26.00   34151

``` r
#Store variables that we will include in the final data frame. Pull metadata from metadata file in download .zip file. 
lat <- 41.57836
lon <- -71.32112
firstyear <- 2002
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
filtered_RI2<- raw_RI2 %>%
    filter(between(salinity, 0, 40) & between(temp, -3, 40))

# Sanity check - print the ranges to ensure values are filtered properly. We can see that the ranges for both are now in the appropriate range.  
print(summary(filtered_RI2$salinity))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.10   30.00   30.60   30.53   31.20   37.90

``` r
print(summary(filtered_RI2$temp))
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   -2.00    5.90   11.80   12.18   18.80   26.00

``` r
#Store our data into a variable name with just the site name. 
RI2 <- filtered_RI2
```

### Visualize the salinity, temperature, and date ranges over time. This can help us see if there are any anomalies or gaps in the data and make sure the filtering was done correctly. Sanity check - do the temperature and salinity ranges look appropriate for the geography of the site (ex. near full ocean salinity for coastal sites, lower salinity for estuaries or near rivers)?

``` r
salplot <- ggplot(RI2, aes(x = datetime)) +
    geom_line(aes(y = salinity, color = "Salinity (ppt)")) +
    ylim(0,45) +
    labs(x = "Time", y = "Salinity ppt", title = "Salinity Plot for RI2 - Duck Cove Narragansett Bay") +
    scale_color_manual(values = c("Salinity (ppt)" = "blue")) +
    theme_minimal()


salplot
```

    ## Warning: Removed 72 rows containing missing values (`geom_line()`).

![](RI2-EnvrData_files/figure-gfm/salinity-plot-1.png)<!-- -->

``` r
tempplot <- ggplot(RI2, aes(x = datetime)) +
    geom_line(aes(y = temp, color = "Temperature (C)")) +
    ylim(-10, 45) +
    labs(x = "Time", y = "Temperature C", title = "Temperature Plot for RI2 - Duck Cove Narragansett Bay") +
    scale_color_manual(values = c( "Temperature (C)" = "red")) +
    theme_minimal()


tempplot
```

    ## Warning: Removed 72 rows containing missing values (`geom_line()`).

![](RI2-EnvrData_files/figure-gfm/temperature-plot-1.png)<!-- -->

### We need to calculate the mean, maximum, and minimum values for salinity and temperature per month and year. First make two data frames to contain each of the annual and monthly averages.

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each month. 
RI2_envrmonth <- RI2 %>%
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
print(RI2_envrmonth)
```

    ## # A tibble: 242 × 10
    ## # Groups:   year [22]
    ##     year month min_salinity max_salinity mean_salinity length_salinity min_temp
    ##    <dbl> <dbl>        <dbl>        <dbl>         <dbl>           <int>    <dbl>
    ##  1  2002     7         24.2         32.2          31.4            1368     16.7
    ##  2  2002     8         29.2         32.3          31.4            1488     19.6
    ##  3  2002     9         29.8         32.4          31.9            1440     19.2
    ##  4  2002    10         31           32.2          31.6            1487     12.6
    ##  5  2002    11         29.8         32.2          30.9             576      7.3
    ##  6  2002    12         29           32.2          30.8            1487      4.3
    ##  7  2003     1         29.1         33.3          30.8            1487     -0.6
    ##  8  2003     2         29.8         33.5          31.8             892     -0.4
    ##  9  2003     3         27.6         32.4          30.7            1487      0.5
    ## 10  2003     4         27.7         32.3          30.3            1437      3.3
    ## # ℹ 232 more rows
    ## # ℹ 3 more variables: max_temp <dbl>, mean_temp <dbl>, length_temp <int>

``` r
#Calculate the mean, maximum, and minimum values for salinity and temperature for each year. 
RI2_envryear <- RI2 %>%
    mutate(year = year(datetime)) %>%
    group_by(year) %>%
    summarise(
      min_salinity = min(salinity),
      max_salinity = max(salinity),
      mean_salinity = mean(salinity),
      min_temp = min(temp),
      max_temp = max(temp),
      mean_temp = mean(temp))

print(RI2_envryear)
```

    ## # A tibble: 22 × 7
    ##     year min_salinity max_salinity mean_salinity min_temp max_temp mean_temp
    ##    <dbl>        <dbl>        <dbl>         <dbl>    <dbl>    <dbl>     <dbl>
    ##  1  2002         24.2         32.4          31.3      4.3     24.7      16.4
    ##  2  2003         27           33.5          30.7     -0.6     25.1      10.3
    ##  3  2004         25.5         32.7          30.8     -1       23.3      13.6
    ##  4  2005         25.3         32.6          30.0      0.4     24.8      11.5
    ##  5  2006         21.9         31.9          30.0      2.3     25.1      12.8
    ##  6  2007          0.1         32.6          30.4      0.7     24.4      12.5
    ##  7  2008         25           33            29.7      2       24.8      12.2
    ##  8  2009         19.1         33.3          30.2      1.2     23.9      11.3
    ##  9  2010         20.2         34.7          30.9      0.8     24.3      12.0
    ## 10  2011         24.8         36.2          30.0      0.7     24.4      11.7
    ## # ℹ 12 more rows

### Plot the months and years of data collection to check if there are any collection gaps in the data.

``` r
timeplot <- ggplot(RI2_envrmonth, aes(x = year)) +
    geom_point(aes(y = month, color = length_salinity), size = 4) +
    labs(x = "Time", y = "Month", title = "Timeplot for RI2 - Duck Cove Narragansett Bay") +
    ylim(1,12) +
    theme_minimal()

timeplot
```

    ## Warning: Removed 1 rows containing missing values (`geom_point()`).

![](RI2-EnvrData_files/figure-gfm/timeplot-1.png)<!-- -->

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
Mean_Annual_Temperature_C <- mean(RI2$temp)
Mean_max_temperature_C <- mean(RI2_envryear$max_temp)
Mean_min_temperature_C <- mean(RI2_envryear$min_temp)
Temperature_st_dev <- sd(RI2$temp)
Temperature_n <- nrow(RI2)
Temperature_years <- nrow(RI2_envryear)

#Create a data frame to store the temperature results
RI2_temp <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Temperature_C, Mean_max_temperature_C, Mean_min_temperature_C, Temperature_st_dev, Temperature_n, Temperature_years, collection_type)
print(RI2_temp)
```

    ##      site_name download_date
    ## [1,] "RI2"     "07-11-2023" 
    ##      source_description                                              
    ## [1,] "NERR Centralized Data. Narragansett Bay T-Wharf Bottom NARTBWQ"
    ##      lat        lon         firstyear finalyear Mean_Annual_Temperature_C
    ## [1,] "41.57836" "-71.32112" "2002"    "2022"    "12.1831196323305"       
    ##      Mean_max_temperature_C Mean_min_temperature_C Temperature_st_dev
    ## [1,] "23.8727272727273"     "1.18636363636364"     "6.70828115047553"
    ##      Temperature_n Temperature_years collection_type
    ## [1,] "629696"      "22"              "continuous"

``` r
# Write to the combined file with all sites 
write.table(RI2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_temperature.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(RI2_temp, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/RI2_temperature.csv")
```

``` r
#Calculate the salinity variables
Mean_Annual_Salinity_ppt <- mean(RI2$salinity)
Mean_max_Salinity_ppt <- mean(RI2_envryear$max_salinity)
Mean_min_Salinity_ppt <- mean(RI2_envryear$min_salinity)
Salinity_st_dev <- sd(RI2$salinity)
Salinity_n <- nrow(RI2)
Salinity_years <- nrow(RI2_envryear)


#Create a data frame to store the temperature results
RI2_salinity <- cbind(site_name, download_date, source_description, lat, lon, firstyear, finalyear, Mean_Annual_Salinity_ppt, Mean_max_Salinity_ppt, Mean_min_Salinity_ppt, Salinity_st_dev, Salinity_n, Salinity_years, collection_type)
print(RI2_salinity)
```

    ##      site_name download_date
    ## [1,] "RI2"     "07-11-2023" 
    ##      source_description                                              
    ## [1,] "NERR Centralized Data. Narragansett Bay T-Wharf Bottom NARTBWQ"
    ##      lat        lon         firstyear finalyear Mean_Annual_Salinity_ppt
    ## [1,] "41.57836" "-71.32112" "2002"    "2022"    "30.5272990458888"      
    ##      Mean_max_Salinity_ppt Mean_min_Salinity_ppt Salinity_st_dev   Salinity_n
    ## [1,] "33.4181818181818"    "19.4545454545455"    "1.0821118984992" "629696"  
    ##      Salinity_years collection_type
    ## [1,] "22"           "continuous"

``` r
# Write to the combined file with all sites 
write.table(RI2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/seascape_salinity.csv", sep = ",", append = TRUE, col.names = FALSE, row.names = FALSE) # The column names should be changed to FALSE after 1st row is added to the data frame

# Write to a unique new CSV file
write.csv(RI2_salinity, "/Users/madelineeppley/GitHub/EasternOysterEnvData/2022_SiteEnvironmentData/Seascape_Processed/RI2_salinity.csv")
```
