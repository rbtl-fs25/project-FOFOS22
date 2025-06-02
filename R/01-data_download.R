library(googlesheets4)

survey <- read_sheet("https://docs.google.com/spreadsheets/d/1e_OOivGXbnwfwtukzDZ2l0gD6UCx9UlVKVNU8ln78vw/edit?usp=sharing")

write_csv(survey,"data/raw/drive_data.csv")
write_rds(survey,"data/raw/drive_data.rds")

######################## Dictionary ############################################

dictionary_general <- read_sheet("https://docs.google.com/spreadsheets/d/1x_LwqLpbfielbSzK2X-JCwquSdG-x44O1ZzQkwNniUY/edit?usp=sharing", sheet = 1)
dictionary_prf <- read_sheet("https://docs.google.com/spreadsheets/d/1x_LwqLpbfielbSzK2X-JCwquSdG-x44O1ZzQkwNniUY/edit?usp=sharing", sheet = 2)
dictionary_suc_reason <- read_sheet("https://docs.google.com/spreadsheets/d/1x_LwqLpbfielbSzK2X-JCwquSdG-x44O1ZzQkwNniUY/edit?usp=sharing", sheet = 3)
dictionary_muc_reason <- read_sheet("https://docs.google.com/spreadsheets/d/1x_LwqLpbfielbSzK2X-JCwquSdG-x44O1ZzQkwNniUY/edit?usp=sharing", sheet = 4)
dictionary_dest <- read_sheet("https://docs.google.com/spreadsheets/d/1x_LwqLpbfielbSzK2X-JCwquSdG-x44O1ZzQkwNniUY/edit?usp=sharing", sheet = 5)

write_csv(dictionary_general,"data/processed/dictionary.csv")
write_csv(dictionary_prf,"data/processed/dictionary_prf.csv")
write_csv(dictionary_suc_reason,"data/processed/dictionary_suc_reason.csv")
write_csv(dictionary_muc_reason,"data/processed/dictionary_muc_reason.csv")
write_csv(dictionary_dest,"data/processed/dictionary_dest.csv")