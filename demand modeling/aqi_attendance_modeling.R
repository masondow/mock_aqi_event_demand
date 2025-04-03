# Exploratory modeling of AQI impact on event attendance
# script to simulate the kind of exploratory analysis a junior data scientist at a ticketing company might perform

library(tidyverse)
library(ggplot2)
library(broom)

# Load synthetic data
data <- read_csv("data/synthetic_event_attendance.csv")

# ---- Step 1: Basic exploration ----
ggplot(data, aes(x = aqi, y = realized_attendance)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "AQI vs Realized Attendance, Wa-Griz Football Home Games 2022-2024",
       x = "AQI",
       y = "Realized Attendance")

# ---- Step 2: Linear regression model ----
model <- lm(realized_attendance ~ aqi, data = data)
summary(model)

tidy(model)

# ---- Step 3: Residuals analysis ----
data$residuals <- resid(model)
data$fitted <- fitted(model)

# Plot residuals
ggplot(data, aes(x = aqi, y = residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(title = "Residuals vs AQI",
       y = "Residuals")

# ---- Step 4: Model Fit Metrics ----
model_summary <- summary(model)
r_squared <- model_summary$r.squared
adj_r_squared <- model_summary$adj.r.squared

cat("R-squared:", round(r_squared, 3), "\n")
cat("Adjusted R-squared:", round(adj_r_squared, 3), "\n")
