
# Chapter 9 test ----------------------------------------------------------


# Step 1: Load the data
data <- read.csv("cox-violent-parsed_filt.csv")

# Step 2: Clean and standardize sex column
data$sex <- trimws(tolower(data$sex))  # Remove spaces and standardize to lowercase
data$sex[data$sex == "male"] <- "Male"
data$sex[data$sex == "female"] <- "Female"

# Step 3: Keep only Male and Female rows
data <- data[data$sex %in% c("Male", "Female"), ]

# Step 4: Parse datetime columns
data$jail_in <- as.POSIXct(data$c_jail_in, format="%m/%d/%Y %H:%M")
data$jail_out <- as.POSIXct(data$c_jail_out, format="%m/%d/%Y %H:%M")

# Step 5: Calculate sentence duration
data$sentence_days <- as.numeric(difftime(data$jail_out, data$jail_in, units = "days"))

# Step 6: Remove invalid sentence durations
data <- data[!is.na(data$sentence_days) & data$sentence_days >= 0, ]

# Step 7: Run the t-test
t_result <- t.test(sentence_days ~ sex, data = data)
print(t_result)

# Step 8: Boxplot for visualization
boxplot(sentence_days ~ sex, data = data,
        main = "Sentence Length by Gender (Outliers Hidden)",
        xlab = "Sex", ylab = "Sentence Length (Days)",
        col = c("lightpink", "lightblue"),
        outline = FALSE)  # <- hides the outliers


# Further analysts  -------------------------------------------------------
# Step 1: Fit model without 'sex'
model_no_sex <- lm(sentence_days ~ priors_count + c_charge_desc, data = data)
# Model with interaction between charge and sex
model_interaction <- lm(sentence_days ~ priors_count + c_charge_desc * sex, data = data)
data$predicted_interaction <- predict(model_interaction, newdata = data)


# Step 2: Predict sentence length
data$predicted_sentence <- predict(model_no_sex, newdata = data)

# Step 3: Summarize actual vs predicted sentence length by sex
summary_by_charge_sex <- data %>%
  group_by(c_charge_desc, sex) %>%
  summarise(
    avg_pred_sentence = mean(predicted_interaction, na.rm = TRUE),
    count = n()
  ) %>%
  filter(count >= 10)  #filters out rare charges
comparison <- data %>%
  group_by(sex) %>%
  summarise(
    actual_avg = mean(sentence_days, na.rm = TRUE),
    predicted_avg = mean(predicted_sentence, na.rm = TRUE),
    avg_diff = actual_avg - predicted_avg,
    .groups = "drop"
  )


print(comparison)


model_with_sex <- lm(sentence_days ~ priors_count + c_charge_desc + sex, data = data)

# Step 8: ANOVA test comparing the two models
anova_result <- anova(model_no_sex, model_with_sex)
print(anova_result)

# Step 1: Calculate average sentence length by charge and gender
sentence_summary <- data %>%
  group_by(charge_description = c_charge_desc, gender = sex) %>%
  summarise(
    avg_sentence_length = mean(sentence_days, na.rm = TRUE),
    case_count = n(),
    .groups = "drop"
  ) %>%
  filter(case_count >= 10)  # Optional: filter out infrequent charges

# Step 2: Plot side-by-side bar chart
ggplot(sentence_summary, aes(x = reorder(charge_description, -avg_sentence_length), 
                             y = avg_sentence_length, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(
    title = "Average Sentence Length by Charge and Gender",
    x = "Charge Description",
    y = "Average Sentence Length (Days)",
    fill = "Gender"
  ) +
  theme_minimal()

ggplot(summary_by_charge_sex, aes(x = reorder(c_charge_desc, -avg_pred_sentence), 
                                  y = avg_pred_sentence, fill = sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Predicted Sentence Length by Charge Type and Gender (with Interaction)",
       x = "Charge Description",
       y = "Predicted Sentence Length (days)",
       fill = "Sex") +
  theme_minimal()
ggplot(comparison_long, aes(x = sex, y = avg_sentence, fill = type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Actual vs Predicted Sentence Length by Gender",
    x = "Sex",
    y = "Average Sentence Length (days)",
    fill = "Sentence Type"
  ) +
  theme_minimal()

# Step 1: Create the comparison table
sentence_by_charge_sex <- data %>%
  group_by(c_charge_desc, sex) %>%
  summarise(
    avg_sentence = mean(sentence_days, na.rm = TRUE),
    count = n(),
    .groups = "drop"
  ) %>%
  filter(count >= 10)  # Optional: exclude rare charges

# Step 2: Keep only charges committed by BOTH genders
shared_charges <- sentence_by_charge_sex %>%
  group_by(c_charge_desc) %>%
  filter(n_distinct(sex) == 2) %>%
  ungroup()

# Step 3: Plot side-by-side bars
ggplot(shared_charges, aes(x = reorder(c_charge_desc, -avg_sentence), y = avg_sentence, fill = sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(
    title = "Average Sentence Length by Charge and Gender (Shared Crimes Only)",
    x = "Charge Description",
    y = "Average Sentence Length (days)",
    fill = "Sex"
  ) +
  theme_minimal()

