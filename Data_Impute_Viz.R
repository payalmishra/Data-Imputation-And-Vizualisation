################################################################
################################################################
################################################################
############# DATA MUNGING/IMPUTATION ##########################
################################################################
################################################################
################################################################


# Missing values in R datasets are shows as 'NA's
# NA is different from a 0...! Why?? E.g. height of a person cannot be zero...! 

# Reasons why data might be missing:
# 1. Randomness: If the probability of missingness is same for all records
#                In such cases, it is OK to remove the records as no bias will be introduced,
#                BUT, be aware of losing good data... information....!!!

# 2. Missing because of upstream source system issues, or just poor data collection techniques

require(mice)
require(VIM)
require(Hmisc)
require(ggplot2)
require(dplyr)
require(magrittr)
require(forecast)
require(tidyr)

# Simple example
age_students = c(25, 27, 28, 29, 25, 24, 28, 29, 30, 23, 25, 28)
height_students = c(160, 162, 162, 170, 180, 166, NA, 171, 145, 159, 163, 164)
marks_exam1 = c(0, 87, 56, 99, 100, NA, 22, 67, 88, 86, 96, 54)

students = as.data.frame(cbind(age_students, height_students, marks_exam1))

hist(students$height_students)
mean(students$height_students, na.rm = T)
students$height_students = impute(students$height_students, mean)

hist(students$marks_exam1)
median(students$marks_exam1, na.rm = TRUE)
mean(students$marks_exam1, na.rm = TRUE)
students$marks_exam1 = impute(students$marks_exam1, median)

# Understanding time series data and imputing
mumbai = read.csv("mumbai_na_class.csv", header = T)
View(mumbai)
summary(mumbai)

hist(mumbai$RS_SALES)
median(mumbai$RS_SALES, na.rm = T)
mean(mumbai$RS_SALES, na.rm = T)

mumbai$RS_SALES = impute(mumbai$RS_SALES, median)
View(mumbai)
plot(mumbai$RS_SALES, type = 'l')

mumbai_sales = mumbai %>% select_("PK", "RS_SALES_TS")

mumbai_ts = mumbai_sales$RS_SALES_TS[mumbai_sales$PK[1:104]]
mumbai_ts_obj = ts(mumbai_ts, start = min(mumbai_sales$PK), frequency = 52)

plot(mumbai_ts_obj, ylab="Sales in Rs", xlab = "Year Week")

# Holts-Winter model
mumbai_ts_components = decompose(mumbai_ts_obj) 
plot(mumbai_ts_components)

forecast_period = 52
mumbai_HW = HoltWinters(mumbai_ts_obj, seasonal = "multiplicative")
plot(mumbai_HW) 

mumbai_forecast_HW = forecast(mumbai_HW, h=forecast_period)
plot(mumbai_forecast_HW)

forecast_values = as.data.frame(mumbai_forecast_HW$mean)
forecast_values$week = 105:156


# kNN imputation for both numerical as well as categorical variables
mumbai_knn = kNN(mumbai, variable = c("RS_SALES", "UNIT_SALES", "RS_SALES_TS", 
                                      "CITY", "STATE", "FORMAT", "REGION", 
                                      "WEEK_MAX_TEMP", "WEEK_MIN_TEMP", "RAIN_MM", 
                                      "SHORTAGE", "POPULATION"), k= 5) 
summary(mumbai_knn)
View(mumbai_knn)


### SUMMARY OF IMPUTATION TECHNIQUES

# +--------+--------------+-------------+-----------+------------+------------+
# +  WEEK  + ACTUAL SALES + TIME SERIES +  MEDIAN   +    MEAN    +    KNN     + 
# +--------+--------------+-------------+-----------+------------+------------+
# +   107  +  618579.7    +  626947.3   +  619832.6 +  643683.4  +  647404.5  +
# +--------+--------------+-------------+-----------+------------+------------+
# +   108  +  597566.0    +  619849.2   +  619832.6 +  643683.4  +  595628.5  +
# +--------+--------------+-------------+-----------+------------+------------+
# +   153  +  769738.2    +  800185.6   +  619832.6 +  643683.4  +  667891.8  +
# +--------+--------------+-------------+-----------+------------+------------+
# +   154  +  868242.7    +  954722.1   +  619832.6 +  643683.4  +  673658.9  +
# +--------+--------------+-------------+-----------+------------+------------+
# +   155  +  991819.5    +  1143778.7  +  619832.6 +  643683.4  +  673658.9  +
# +--------+--------------+-------------+-----------+------------+------------+
# +   156  +  1457181.9   +  1196601.7  +  619832.6 +  643683.4  +  1075563.8 +
# +--------+--------------+-------------+-----------+------------+------------+



#################### MODULE SUMMARY ###########################

### Now let us take a step back and see what all we learnt:
# 1. Why data imputation is critical - you dont want to lose important data!
# 2. Mean vs. Median vs. Time Series vs. KNN imputation : when to do what
# 3. Understand your data first and last...! There is nothing more important than knowing the business context
# 4. Last but not the least, IMPORTANCE OF VISUALIZATION! 

#################### SUMMARY #################################
