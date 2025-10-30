library(haven)
library(dplyr)
library(ggplot2)

demo <- read_xpt("data/P_DEMO.xpt")
bp   <- read_xpt("data/P_BPXO.xpt")
bmx  <- read_xpt("data/P_BMX.xpt")
diq  <- read_xpt("data/P_DIQ.xpt")
trig <- read_xpt("data/P_TRIGLY.xpt")

analysis <- bmx %>%
  left_join(demo, by = "SEQN") %>%
  left_join(bp,   by = "SEQN") %>%
  left_join(diq,  by = "SEQN") %>%
  left_join(trig, by = "SEQN")

analysis <- analysis %>%
  mutate(
    avg_sys = rowMeans(select(., BPXOSY1, BPXOSY2, BPXOSY3), na.rm = TRUE),
    avg_dia = rowMeans(select(., BPXODI1, BPXODI2, BPXODI3), na.rm = TRUE)
  )

analysis <- analysis %>%
  mutate(
    # Gender
    gender = factor(RIAGENDR,
                    levels = c(1, 2),
                    labels = c("Male", "Female")),
    
    # Race using RIDRETH3
    race = factor(RIDRETH3,
                  levels = c(1, 2, 3, 4, 6, 7),
                  labels = c("Mexican American",
                             "Other Hispanic",
                             "Non-Hispanic White",
                             "Non-Hispanic Black",
                             "Non-Hispanic Asian",
                             "Other Race - Including Multi-Racial")),
    
    # Marital Status
    marital_status = factor(case_when(
      DMDMARTZ == 1 ~ "Married/Living with Partner",
      DMDMARTZ == 2 ~ "Widowed/Divorced/Separated",
      DMDMARTZ == 3 ~ "Never Married",
      DMDMARTZ %in% c(77, 99) ~ "Refused/Don't Know",
      TRUE ~ NA_character_
    ), levels = c("Married/Living with Partner",
                  "Widowed/Divorced/Separated",
                  "Never Married",
                  "Refused/Don't Know")),
    
    # Education
    education = factor(case_when(
      DMDEDUC2 == 1 ~ "Less than 9th grade",
      DMDEDUC2 == 2 ~ "9–11th grade (no diploma)",
      DMDEDUC2 == 3 ~ "High school/GED",
      DMDEDUC2 == 4 ~ "Some college or AA degree",
      DMDEDUC2 == 5 ~ "College graduate or above",
      DMDEDUC2 %in% c(7, 9) ~ "Refused/Don't Know",
      TRUE ~ NA_character_
    ), levels = c("Less than 9th grade",
                  "9–11th grade (no diploma)",
                  "High school/GED",
                  "Some college or AA degree",
                  "College graduate or above",
                  "Refused/Don't Know"))
  )

analysis <- analysis %>%
  mutate(
    insulin = factor(case_when(
      DIQ050 == 1 ~ "Yes",
      DIQ050 == 2 ~ "No",
      DIQ050 %in% c(7, 9) ~ "Refused/Don't Know",
      TRUE ~ NA_character_
    ), levels = c("Yes", "No", "Refused/Don't Know"))
  )

analysis %>%
  group_by(gender) %>%
  summarise(
    Age = paste0(round(mean(RIDAGEYR, na.rm = TRUE), 2), " (", round(sd(RIDAGEYR, na.rm = TRUE), 2), ")"),
    BMI = paste0(round(mean(BMXBMI, na.rm = TRUE), 2), " (", round(sd(BMXBMI, na.rm = TRUE), 2), ")"),
    Systolic_BP = paste0(round(mean(avg_sys, na.rm = TRUE), 2), " (", round(sd(avg_sys, na.rm = TRUE), 2), ")"),
    Diastolic_BP = paste0(round(mean(avg_dia, na.rm = TRUE), 2), " (", round(sd(avg_dia, na.rm = TRUE), 2), ")"),
    Age_at_Diabetes = paste0(round(mean(DID040, na.rm = TRUE), 2), " (", round(sd(DID040, na.rm = TRUE), 2), ")"),
    Triglycerides = paste0(round(mean(LBXTR, na.rm = TRUE), 2), " (", round(sd(LBXTR, na.rm = TRUE), 2), ")")
  )



table(analysis$gender, analysis$race)


table(analysis$gender, analysis$marital_status)


table(analysis$gender, analysis$education)


table(analysis$insulin, analysis$gender)


# 1. Proportion male/female
prop.table(table(analysis$gender))

# 2. Number of observations in final dataset
nrow(analysis)

# 3. Average age for males who were never married
analysis %>%
  filter(gender == "Male", marital_status == "Never Married") %>%
  summarise(avg_age = mean(RIDAGEYR, na.rm = TRUE))

# 4. Average BMI for males
analysis %>%
  filter(gender == "Male") %>%
  summarise(avg_bmi = mean(BMXBMI, na.rm = TRUE))


ggplot(analysis, aes(x = marital_status, y = BMXBMI, fill = gender)) +
  geom_boxplot() +
  labs(title = "BMI by Marital Status and Gender", y = "BMI") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))


ggplot(analysis, aes(x = race, y = avg_sys, fill = gender)) +
  geom_boxplot() +
  labs(title = "Systolic BP by Race and Gender", y = "Avg Systolic BP") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
