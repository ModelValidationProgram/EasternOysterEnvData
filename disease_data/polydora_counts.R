# M.G.E. polydora data status 5/12/2025 
# checking to see which individuals passed sequencing that we don't have polydora data for yet
library(readr)
library(dplyr)
library(stringr)

genetic_data1 <- read_tsv("/Users/madelineeppley/Desktop/NE_Marine_Science_OysterCVI200K_All_Plates_SampleTable.txt")
genetic_data2 <- read_tsv("/Users/madelineeppley/Desktop/NE_Marine_Science_OysterCVI200K_20240301_Sample_Table.txt")
polydora_data <- read_csv("/Users/madelineeppley/Desktop/SeascapeSamples\ -\ polydora.csv")
individual_data <- read_csv("/Users/madelineeppley/Desktop/SeascapeSamples\ -\ individual.csv")

# these are pops we don't have shells or genetic data for
excluded_pops <- c(
  "NR_JR_VA_2022-10-10", 
  "CS_DB_NJ_2022-9-21", 
  "HC_DB_NJ_2022-9-23", 
  "LakeFortuna_LA_2022-5-11", 
  "LM_TX_2022-7-10"
)

# combine those silly gal bay sites
galBay_sites <- c(
  "Galbay_TX_308&435_2022-6-2",
  "Galbay_TX_Grid169_2022-6-2", 
  "GalBay_TX_Grid312_2022-6-2"
)

# sex vs gender weird column issue - rename
colnames(genetic_data2)[8] <- "QC computed_sex"

# keep only samples that passed QC
genetic_combined <- rbind(genetic_data1, genetic_data2) %>%
  filter(`Pass/Fail` == "Pass")

# extract SG from sample filename col
extract_sg_number <- function(filename) {
  # extract SG part with number!!!!
  sg_match <- str_extract(filename, "SG[_-]([a-zA-Z0-9]+_)?\\d+")
  
  if (!is.na(sg_match)) {
    # replace SG-sharedLotterhosPuritz_ with SG_
    sg_clean <- str_replace(sg_match, "SG-sharedLotterhosPuritz_", "SG_")
    # replace any remaining SG- with SG_
    sg_clean <- str_replace(sg_clean, "SG-", "SG_")
    return(sg_clean)
  } else {
    return(NA)
  }
}

# combined dataframe
genetic_sg <- genetic_combined %>%
  mutate(SG_number = sapply(`Sample Filename`, extract_sg_number)) %>%
  filter(!is.na(SG_number)) %>%
  select(SG_number) %>%
  distinct() # remove any plate 9 dups


individual_data <- individual_data %>%
  mutate(Clean_Label = sapply(Label_ind, extract_sg_number))


# extract site pop information and label ind
pop_data <- individual_data %>%
  filter(!is.na(Clean_Label)) %>%
  filter(!ID_SiteDate %in% excluded_pops) %>% 
  mutate(ID_SiteDate = ifelse(ID_SiteDate %in% galBay_sites, "GalBay_TX", ID_SiteDate)) %>%
  select(Clean_Label, ID_SiteDate) %>%
  distinct()

# find SG numbers in polydora data 
polydora_sg <- polydora_data %>%
  select(polydora_Label) %>%
  mutate(SG_number = str_replace(polydora_Label, "_PD$", "")) %>%
  select(SG_number)

# find which SG numbers from genetic data are already in polydora data
already_polydora_data <- genetic_sg %>%
  inner_join(polydora_sg, by = "SG_number") %>%
  left_join(pop_data, by = c("SG_number" = "Clean_Label")) %>%
  filter(!is.na(ID_SiteDate)) # Remove samples from excluded populations

# find which SG numbers from genetic data are NOT in polydora data
need_polydora_data <- genetic_sg %>%
  anti_join(polydora_sg, by = "SG_number") %>%
  left_join(pop_data, by = c("SG_number" = "Clean_Label")) %>%
  filter(!is.na(ID_SiteDate)) # Remove samples from excluded populations

# population counts for samples with data already - include NAs for sites with no available shells
pop_already_polydora <- table(already_polydora_data$ID_SiteDate, useNA = "ifany")
print(pop_already_polydora)

# pop coutns for samples with no data yet - include NAs for sites with no available shells
pop_counts_need <- table(need_polydora_data$ID_SiteDate, useNA = "ifany")
print(pop_counts_need)

# export as data frames 
pop_already_polydora_df <- as.data.frame(pop_already_polydora)
names(pop_already_polydora_df) <- c("Population", "Already_Polydora_Data")

pop_counts_need_df <- as.data.frame(pop_counts_need)
names(pop_counts_need_df) <- c("Population", "Needs_Polydora_Data")

write_csv(pop_already_polydora_df, "SG_samples_already_polydora_data.csv")
write_csv(pop_counts_need_df, "SG_samples_need_polydora_data.csv")

# pop-level summary so we can see how many samples we have for each site done and to-do
pop_summary <- full_join(
  pop_already_polydora_df, 
  pop_counts_need_df, 
  by = "Population"
)
# replace any NAs with 0s
pop_summary$Count_Already_Checked[is.na(pop_summary$Already_Polydora_Data)] <- 0
pop_summary$Count_Need_Checking[is.na(pop_summary$Needs_Polydora_Data)] <- 0

write_csv(pop_summary, "population_summary.csv")
