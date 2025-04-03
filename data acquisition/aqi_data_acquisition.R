# Load required packages
library(RAQSAPI)      # For querying EPA AQS data
library(AirMonitor)   # For AQI conversion
library(lubridate)    # For handling dates
library(dplyr)        # For data manipulation
library(readr)        # For reading/writing CSVs

RAQSAPI::aqs_credentials("mason.dow@mt.gov", "saffronmallard82")

# AQI conversion function from Ellen Considine
aqi_equation <- function(pollutant, concentration){
  PM25.Class <- c("Good", "Moderate", "Unhealthy for Sensitive Groups",
                  "Unhealthy", "Very Unhealthy", "Hazardous")
  PM25.Color <- c("Green", "Yellow", "Orange", "Red", "Purple", "Maroon")
  PM25.Conc_low <- c(0, 12.1, 35.5, 55.5, 150.5, 250.5)
  PM25.Conc_high <- c(12.099999, 35.499999, 55.499999,
                      150.499999, 250.499999, 5000)
  PM25.AQI_low <- c(0, 51, 101, 151, 201, 301)
  PM25.AQI_high <- c(50, 100, 150, 200, 300, 500)
  PM25.AQI_table <- data.frame(PM25.Color, PM25.Class,
                               PM25.Conc_low, PM25.Conc_high,
                               PM25.AQI_low, PM25.AQI_high)
  
  if(!is.numeric(concentration)){
    print("Please use numeric value for concentration")
    return(NULL)
  } else {
    y <- round(concentration, 4)
    df <- PM25.AQI_table
    result_list <- lapply(y, function(x){
      n_r <- which((df[,3] <= x)&(df[,4] >= x))[1]
      if(is.na(n_r)) return(data.frame(Concentration = x, AQI = NA, Class = NA, Color = NA))
      Class <- df[n_r, 2]
      Color <- df[n_r, 1]
      AQI <- round((df[n_r,6]-df[n_r,5])/(df[n_r,4]-df[n_r,3])*(x-df[n_r,3])+df[n_r,5])
      Concentration <- x
      return(data.frame(Concentration, AQI, Class, Color))
    })
    return(do.call(rbind, result_list))
  }
}

# Set parameters for the query
state_fips <- "30"         # Montana
county_fips <- "063"       # Missoula County
site_number <- "0024"      # Boyd Park site (Missoula)
parameter_code <- "88101"  # PM2.5 (FRM & FEM)
bdate <- as.Date("2022-01-01")  # Start date
edate <- as.Date("2024-12-31")  # End date

# Query daily summary data (24-hour average) from AQS by site
# Source: EPA AQS Data Mart API via RAQSAPI (using Boyd Park site in Missoula)
daily_summary <- aqs_dailysummary_by_site(
  parameter = parameter_code,
  bdate = bdate,
  edate = edate,
  stateFIPS = state_fips,
  countycode = county_fips,
  sitenum = site_number
)

# View structure of the data
str(daily_summary)

# Clean and reduce to one row per day (prioritize highest observation_percent, or average if needed)
aqi_input <- daily_summary %>%
  filter(sample_duration == "24-HR BLK AVG") %>%
  group_by(date_local) %>%
  slice_max(order_by = observation_percent, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  select(datetime = date_local,
         pm25 = arithmetic_mean,
         site = site_number) %>%
  mutate(datetime = as.Date(datetime),
         site = paste0(state_fips, county_fips, site),
         site = as.character(site))

# Convert PM2.5 to AQI using Ellen Considine's function
aqi_conversion <- aqi_equation("pm2.5", aqi_input$pm25)
aqi_input$aqi <- as.numeric(aqi_conversion[, "AQI"])

# Save cleaned and converted AQI data to CSV
write_csv(aqi_input, "data/missoula_pm25_aqi_daily.csv")

# Preview output
print(head(aqi_input))
