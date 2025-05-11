
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
        main = "Sentence Length (Days) by Sex",
        xlab = "Sex", ylab = "Sentence Length (Days)", col = c("lightblue", "pink"))



# Further analysts  -------------------------------------------------------

boxplot(sentence_days ~ sex, data = data,
        main = "Sentence Length by Gender (Outliers Hidden)",
        xlab = "Sex", ylab = "Sentence Length (Days)",
        col = c("lightpink", "lightblue"),
        outline = FALSE)  # <- hides the outliers
