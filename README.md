# NHANES-Cardiometabolic-Profiling in R
Analysis of NHANES data examining demographic, body measure, blood pressure, diabetes, and lipid variables to profile cardiometabolic health.


## Data Sources
- **NHANES Public Datasets:**
  - Demographics (`P_DEMO.xpt`)
  - Body Measures (`P_BMX.xpt`)
  - Blood Pressure – Oscillometric (`P_BPXO.xpt`)
  - Diabetes (`P_DIQ.xpt`)
  - Cholesterol / Triglycerides (`P_TRIGLY.xpt`)

All datasets were merged by the participant identifier `SEQN`.  
A **left join** was used with `bmx` (body measures) as the base dataset to ensure that all participants with BMI data were included.

## Methods & Requirements Addressed
- Created merged dataset of participants with at least one observation in body measures.  
- Derived **average systolic and diastolic blood pressure** from three BP measurements.  
- Converted categorical variables (gender, race, marital status, education, insulin use) into **factors with descriptive labels**.  
- Produced **Table 1** with:
  - Mean (SD) for continuous variables by gender.  
  - Frequency and percentage for categorical variables by gender.  
- Reported answers to key questions:
  1. Proportion of participants who are male vs. female.  
  2. Number of observations in the final dataset.  
  3. Average age for males who were never married.  
  4. Average BMI for males.
- Created **two plots** comparing BMI and systolic BP across demographic groups.


## How to Run
1. Place all `.xpt` files in the `data/` folder.  
2. Open `.Rproj` or `.R` files in RStudio.  
3. Run the script.  
   - Outputs (tables, figures) will be saved in `outputs/`.  
   - Table 1 is exported as `outputs/table1.csv`.


## Outputs
- `outputs/table1.csv` — Summary statistics by gender  
- `outputs/summary_by_gender.csv` — Continuous variables mean (SD)  
- `outputs/crosstabs.txt` — Categorical frequencies and percentages  
- `outputs/bmi_by_marital_gender.png`  
- `outputs/sysbp_by_race_gender.png`



## Notes
- Left join with **BMX** ensures inclusion of all participants with BMI data.  
- Percentages in `Table 1` are computed within each gender group.  
- Figures use consistent scaling and 300 dpi resolution for readability.  
