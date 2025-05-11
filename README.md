# **Gender, Sentencing, and Recidivism: A Statistical Analysis**

## Overview

This project explores whether gender independently influences sentencing length and recidivism rates among parolees. Using a cleaned and filtered version of a real-world dataset, we apply statistical modeling and hypothesis testing to assess whether observed disparities are due to bias or can be explained by other factors such as charge type and prior offenses.

---

## Objectives

- Determine whether there is a **statistically significant difference** in average sentence length between male and female parolees.
- Analyze **recidivism rates** by gender to assess whether men and women differ meaningfully in likelihood of reoffending.
- Examine whether the **types of charges** men and women are convicted of explain the differences in sentencing outcomes.
- Evaluate whether simplistic classification systems (e.g., labeling individuals as “aggressive”) provide meaningful predictive value for violent recidivism.

---

## Methods

- A **Welch two-sample t-test** was conducted to assess whether mean sentence lengths differ significantly between men and women.
- **Linear regression models** were fitted to predict sentence length using charge type and prior counts — both with and without gender as a predictor.
- An **ANOVA model comparison** tested whether adding gender significantly improves prediction accuracy.
- **Grouped bar charts and residual plots** were created to visualize sentence differences by gender and charge type.
- **Reconviction rates** were calculated by gender and visualized to assess risk-based outcome differences.

---

## Key Findings

- There is a **statistically significant difference** in average sentence length between men and women; however, the difference is relatively small in practice.
- **Adding gender to the regression model** does not significantly improve prediction of sentence length once charge type and prior convictions are included (p ≈ 0.057).
- **Charge type distribution** differs between genders and largely explains the sentencing differences.
- **Men have significantly higher reconviction rates** than women, suggesting that observed outcome differences may reflect **recidivism risk** rather than sentencing bias.
- Broad **classification labels** (e.g., “aggressive”) do not effectively predict violent recidivism and may lead to **unfair treatment**.

---

## Tools & Technologies

- **R** programming language
- Packages: `ggplot2`, `dplyr`, `tidyr`

---

## Data Source

- Dataset: `cox-violent-parsed_filt.csv`  
  (filtered version of a real-world parolee dataset including charges, sentence dates, and reconviction status)




