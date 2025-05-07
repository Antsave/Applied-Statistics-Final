# Drop NA or negative sentence lengths
data <- data[!is.na(data$sentence_days) & data$sentence_days >= 0, ]

# Ensure is_recid is numeric (if it's not already, this won't do anything harmful)
data$is_recid <- as.numeric(as.character(data$is_recid))

# Safely convert is_recid to a factor with labeled levels
data$is_recid <- factor(data$is_recid, levels = c(0, 1),
                        labels = c("Not_Reconvicted", "Reconvicted"))

# Confirm the unique values in is_recid
print(unique(data$is_recid))

# Calculate total count by gender
gender_counts <- table(data$sex)

# Calculate proportions (percent of each gender)
gender_proportions <- prop.table(gender_counts)
percentages <- round(100 * gender_proportions, 2)
print(percentages)

# Create recidivism table by gender
recid_table <- table(data$sex, data$is_recid)
print(recid_table)

# Total number of people
total_people <- sum(recid_table)
cat("Total number of people:", total_people, "\n")

# Total by gender
total_by_gender <- rowSums(recid_table)
cat("Total women:", total_by_gender["Female"], "\n")
cat("Total men:", total_by_gender["Male"], "\n")

