# Calculate average temperature in contiguous US

temp <- read.csv('../data/110-tavg.csv', skip = 3) 

# Convert temperature to C
temp$temp.c <- (temp$Value - 32) * 5 / 9

# Take 30 year subset 1991 - 2020
ntemp <- subset(temp, Date > 199012 & Date < 202101)

# Check dim, should have 360 rows
dim(ntemp)

# Get average
temp.c <- mean(ntemp$temp.c)
