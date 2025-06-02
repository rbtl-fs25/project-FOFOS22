library(tidyverse)
library(dplyr)

#sub-dataset classified through sdata naming

data_raw <- read_csv("data/raw/drive_data.csv")


##############################General###########################################
#adding ID number 

data_raw <- data_raw |> 
  mutate(id = row_number()) |> 
  relocate(id)

#removing unwanted columns
data_clean <- data_raw |> 
  mutate(
    "Column 1" = NULL,
    "Column 2" = NULL,
    level = NULL
  )

#removing empty lines
data_clean <- data_clean |> 
  filter(!is.na(`Cup [SUC,MUC,OWN,CUP]`))


#renaming
data_clean <- data_clean |> 
  rename("loc" = "Location [Irchel/ETH]" ) |> 
  rename("sex" = "gender [male/femal/undefined]" ) |> 
  rename("prf" = "profession?") |> 
  rename("cup" = "Cup [SUC,MUC,OWN,CUP]") |> 
  rename("suc_reason" = "SUC reason [A,B,C,D]") |> 
  rename("muc_reason" = "MUC reason") |> 
  rename("dest" = "next destination")


#changing date to readable format

data_clean <- data_clean |> 
  mutate(time_hm = format(date, "%H:%M")) |> 
  relocate(time_hm) |> 
  select(-date) |> 
  relocate(id)

#writing csv
write_csv(data_clean,"data/processed/data_processed.csv")

###########################Distribution#########################################

# Data Cup Distribution

sdata_cup_distribution <- data_clean |> 
  count(cup) |> 
  mutate(percentage = round(n / sum(n) * 100)) |> 
  mutate(cup_label = recode(cup,
                            "CUP" = "Cafeteria Mug",
                            "OWN" = "Own Cup",
                            "SUC" = "Single-Use Cup"
  ))

write_csv(sdata_cup_distribution,"data/final/data_cups_distribution.csv")

###############################Reasoning########################################

sdata_cup_reason <- data_clean |> 
  select(id,cup, suc_reason,muc_reason)

### Data for SUC reasons 
sdata_cup_suc_reason <- sdata_cup_reason |> 
  filter(cup == "SUC") |> 
  count(suc_reason) |> 
  mutate(suc_reason = fct_reorder(suc_reason, n, .desc = TRUE)) |> 
  mutate(suc_reason = recode(suc_reason,
                            "A" = "No other cups available",
                            "B" = "Take Away",
                            "C" = "Preference",
                            "D" = "Convenience",
                            "E" = "No particular reason",
                            "F" = "Salience bias")) 

### Data for MUC reasons
sdata_cup_muc_reason <- sdata_cup_reason |> 
  filter(cup != "SUC") |> 
  count(muc_reason) |> 
  mutate(muc_reason = fct_reorder(muc_reason, n, .desc = TRUE)) |> 
  mutate(muc_reason = recode(muc_reason,
                             "A" = "No other cups available",
                             "B" = "wanted to consume on site",
                             "C" = "Preference",
                             "D" = "Price Reduction",
                             "E" = "Environmental Concerns"
                             )) 
  
#### Export to csv
write.csv(sdata_cup_suc_reason, "data/final/data_cup_suc_reason.csv",row.names = FALSE)
write.csv(sdata_cup_muc_reason, "data/final/data_cup_muc_reason.csv",row.names = FALSE)

############################## CUP vs. Gender ##################################

sdata_cup_gender <- data_clean |> 
  select(id,cup, sex)

write.csv(sdata_cup_gender, "data/final/data_cup_gender.csv",row.names = FALSE)


############################## CUP vs. time ####################################

sdata_cup_time <- data_clean |> 
  select(id,cup,time_hm) 
  

write.csv(sdata_cup_time, "data/final/data_cup_time.csv",row.names = FALSE)

############################### Table ##########################################

sdata_table <- data_clean |> 
  group_by(cup,suc_reason, muc_reason) |> 
  summarize("Amount" = n(),
            "Average age" = round(mean(age), digits = 1)
            
  ) |> 
  mutate(suc_reason = replace_na(suc_reason, "-")) |> 
  mutate(muc_reason = replace_na(muc_reason, "-"))  |> 
  mutate(muc_reason = recode(muc_reason,
                             "A" = "No other cups available",
                             "B" = "wanted to consume on site",
                             "C" = "Preference",
                             "D" = "Price Reduction",
                             "E" = "Environmental Concerns"
  )) |> 
  mutate(suc_reason = recode(suc_reason,
                             "A" = "No other cups available",
                             "B" = "Take Away",
                             "C" = "Preference",
                             "D" = "Convenience",
                             "E" = "No particular reason",
                             "F" = "Salience bias")) |> 
  rename("Reason SUC" = suc_reason,
         "Reason MUC" = muc_reason,
         "Type of Cup" = cup)
  
write.csv(sdata_table, "data/final/data_table.csv",row.names = FALSE)

