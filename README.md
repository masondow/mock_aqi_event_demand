# 📘 Project Overview

**Title:** *Mock Prototype: Exploring the Relationship Between AQI and Outdoor Event Demand*

This repository contains a mock prototype developed for the MSBA 680 course at the University of Montana. The goal is to explore whether air quality index (AQI) data can help predict consumer demand for outdoor events—particularly in wildfire-prone regions like Missoula, Montana. While real attendance and sales data were not available for this project, the prototype simulates how such data might be used in practice and outlines a reproducible workflow using publicly available AQI data.

---

## 🎯 Project Goals

- Assess whether AQI levels correlate with demand indicators like attendance or ticket prices at outdoor venues.
- Explore how real-time environmental data might support dynamic ticket pricing or operational decision-making.
- Demonstrate an ethical and innovative use of big data in a real-world setting (event management).
- Provide a proof-of-concept that could be folded into a larger demand forecasting model (e.g., predicting realized attendance or secondary market ticket pricing).

---

## ⚠️ Disclaimer

- **Mock Prototype:** This project is a simulation. Due to lack of access to actual event attendance or ticketing data, synthetic or proxy datasets are used to illustrate the concept.
- **AQI Data Representation:** AQI measurements are obtained from publicly available monitoring networks (e.g., EPA AQS via RAQSAPI, Montana DEQ, or PurpleAir through AirNow). These measurements may not represent air quality conditions directly at a specific venue and should be interpreted as regional indicators.

---

## 📁 Repository Structure

```
aqi-event-demand/
├── README.md                        # Project summary and usage
├── data/
│   ├── missoula_pm25_aqi_daily.csv # AQI data for Missoula County (2022–2024)
│   └── synthetic_event_attendance.csv # Synthetic realized attendance data
├── data_acquisition/
│   ├── aqi_data_acquisition.R      # Queries and processes AQI data from EPA
│   └── synthetic_event_data.R      # Creates synthetic event data with AQI impact
├── demand_modeling/
│   └── aqi_attendance_modeling.R   # Exploratory modeling of AQI-attendance relationship
```

---

## 🛠️ Tools and Environment

This project was developed in **R**, using packages such as:
- `tidyverse` (data manipulation and plotting)
- `lubridate` (date handling)
- `ggplot2` (visualization)
- `readr` (CSV I/O)
- `RAQSAPI` (EPA AQS API queries)
- `AirMonitor` (for AQI classification logic)

---

## 📈 How to Use

1. Clone the repository and set your working directory to the project root.
2. Run `aqi_data_acquisition.R` (in `data_acquisition/`) to download and process AQI data.
3. Run `synthetic_event_data.R` (also in `data_acquisition/`) to create the event and attendance dataset.
4. Run `aqi_attendance_modeling.R` (in `demand_modeling/`) to fit and evaluate the linear model relating AQI to attendance.
5. Outputs can be reviewed via printed summaries and plots; model diagnostics are part of the final script.

---

## 📚 Attribution and Acknowledgments

- AQI breakpoints and classification logic are adapted from a function authored by Ellen Considine.
- Football game schedules sourced from the University of Montana's athletics website.
- AQI data collected via the RAQSAPI package and processed to EPA AQI standards.

---

## 🔍 Next Steps

Future versions of this prototype could incorporate:
- Hourly NowCast AQI for day-of-event decision modeling
- Secondary market ticket pricing data
- Additional environmental variables (e.g., temperature, wind, humidity)
- Broader event types beyond collegiate football (concerts, festivals, etc.)
- Additional significant terms to predict event demand and associated ticket resale price

---

