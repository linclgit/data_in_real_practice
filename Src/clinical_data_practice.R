url <- "https://data.mendeley.com/datasets/hxyx3vdf3b/1/files/f5bbd2b8-d58a-4389-a636-59493aa095fe/Data%20file.xlsx?dl=1"

# Download data
download.file(url, 
              destfile = "../data/lipid.xlsx", 
              mode = "wb")

library (openxlsx)
library (tidyverse)

dat1 <- read.xlsx (url, sheet = 1, rows = 2:35) %>% 
  set_names (c ("id", "activeBefore_g", "activeAfter_g", "controlBefore_g", "controlAfter_g", "X6", "X7", "age", "gender", "bmi", "first_intervention", "activeIntake_kcal", "controlIntake_kcal"))

dat1 <- dat1 [, -(6:7)] # remove col 6:7

dat1 <- dat1 %>% 
  mutate_at (vars (-id, -gender, -first_intervention), as.numeric)
str(dat1)

write_csv (dat1, "../data/lipid_1.csv")

dat2 <- read.xlsx (url, sheet = 2, rows = 1:396, cols = 1:20) 

dat2 <- dat2 %>% 
  mutate (ID = paste0 ("LE", ID)) 
str(dat2)

write_csv (dat2, "../data/lipid_2.csv")