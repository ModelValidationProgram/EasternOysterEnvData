
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

Is it useful to see data availability per year/month? I included this for some populations but not all.


## 2020_10_29 KEL & TB Meeting notes

## KEL thoughts on initial analysis
- it would be nice to have separate files for each site/population in the notebook entry title. We should talk about making edits to individual posts (which I'm fine with) vs. making new chronological posts. **DONE. I made notes based on our meeting on top of each YYYY_MM_DD_TB post to reflect/summarize what was decided in our meeting; those notes start with 'YYYY_MM_DD Thais's notes following meeting'. Then I made one new post per population named as each POP ID with the 'final' data for each population and some plots. So, the 'YYYY_MM_DD_TB posts' have all the 'history' of environmental data selection for each population, some of these posts have more than one pop; and the 'POP ID posts' have only what was selected as good environmental data for each POP plus some plots for easy/quick visualization of these data; all POP ID posts have a single POP per post.(TB)**

- let's make sure to put NA's in any calculation that is clearly bad or biased (e.g. calculating degree days when less than 365 days in data) **We decided to drop these measurements altogether**
  - degree days in general seems biased in most places. should we drop it? it seems very few have measured dd below 0. I'm wondering if we should increase it to ddb5 to make it a more meaningful metric. **We decided to drop these measurements altogether**
  - we discussed this and decided to drop this **DONE (TB)**

- in each report table it would be good to add :
  - the frequency of observations (e.g. hourly, daily) in addition to the number of years **DONE (TB)**
  - maybe we should add a column for whether the data is missing winter? **DONE but this is not super straightforward - for some datasets we are missing some winter data but not all - this has been noted in the "Summary table" based on "Summary notes" for each population (TB)**
- in some cases we should pool all the data together. **DONE; populations for which more than one environmental datasource is available and good, I pooled the data. Data pooling is indicated in the heading of "Summary table" - there is one summary table per population (TB)***



## 2020_11_16

**Notebook entries labelled chronologically have info regarding the following populations:**

2020_09_25 VA_CB_HC_Med_W

2020_09_29 TX_PM_LM_High_W

2020_10_01 LA_GI_CL_High_W

2020_10_06 LA_CL_SL_Low_W

2020_10_07 MD_CB_CP_Low_W

2020_10_13 NJ_DB_CS_Med_W

2020_10_16 NJ_DB_HC_Low_W

2020_10_20 ME_DR_HI_High_W & ME_SR_SM_Low_W

2020_10_26 NC_WI_HC_High_W & NC_PC_CH_Low_W

2020_10_27 NY_LI_L_High_W & NY_LI_CM_High_W
