
# Information about the data

- [old repo, previous analysis done by Erin](https://github.com/MarineEvoEcoLab/OysterGenomeProject/tree/master/popstructureOutliers/data/environment)
- some issues with data used; some issues with not filtering out bad data

- [Google drive for environmental data](https://drive.google.com/drive/folders/1DPGnsGSdGTwVbHA_YD-h6j0ddkx7jg1w)

- [List of populations and data source for each population](https://docs.google.com/spreadsheets/d/1UPv-Lo2Ak2PhheqoyhA-HvnRhvn80Mdw85bakwYTvFU/edit?pli=1#gid=488191574) Ultimately this is the table we want to fill in. See this table for potential data sources for each population.
  - Skip the selection line populations - populations whose name ends in an "S"

- [List of datasources and what filters were applied, data cleaning](https://docs.google.com/spreadsheets/d/1ySYfxii6Z8q7BmNCyhmOYNfLbcpDIpsFER24YW5m08M/edit#gid=1467712745)

# What we want to calculate for each dataset

### Apply filters

NERR data: 

### Temperature
* Mean_Annual_Temperature_C	: average of all available data
* Mean_max_temperature_C	: average of (maximums for each year)
* Mean_min_temperature_C	: average of (minimums for each year)
* Temperature_st_dev: SD of all available data (if only daily averages are reported separately from mean/max daily this SD could be biased)
* Temperature_n: number of datapoints
* Temperature_years: number of years
*	dd_0: number of days where temp fell below 0
* dd_15: number of days where temp above 15C
* dd_30: number of days where temp above 30C

### Salinity
* Mean_Annual_Salinity_ppt	: average of all available data
* Salinity_st_dev	: SD of all available data (if only daily averages are reported separately from mean/max daily this SD could be biased)
* Mean_min_Salinity_ppt	: average of (minimums for each year)
* Mean_max_Salinity_ppt : average of (maximums for each year)
* Salinity_n: number of datapoints
* Salinity_years: number of years



## 2020_10_28

Things left to do:

Map for each locations and/or a single map with all locations
* some locations have their map with populations and datasources

Email Dina with questions

In tables, check
* N_all...
* Should calculate stdDev for other parameters (mean_yearly_max, dd_15, etc)?
* Include data range and resolution for all tables (some already have, some are missing)

Add datafile names to each notebook

Make a big table with all data

Talk with Katie about pros/cons about considering whole years

