### R script to reproduce plot 1
library(lubridate)

# Read date column ONLY first to find subset of table to read
# ASSUMPTION: "household_power_consumption.txt exists in project home directory
datafile <- "household_power_consumption.txt"
data <- read.table(datafile, header = TRUE, sep = ";",
                   colClasses = c("factor", rep("NULL", 8)))
# Convert into date format and select dates to read
data <- dmy(data[, 1])
date_start <- ymd("2007-02-01")
date_end <- date_start + days(1)
sel_rows <- which(data >= date_start & data <= date_end)
# Read the selected row chunk
# ASSUMPTION: given data is sorted by date and time
colnames <- unlist(read.table(datafile, sep = ";", nrow = 1))
data <- read.table(datafile, header = FALSE, sep = ";",
                   na.strings = "?", col.names = colnames,
                   skip = min(sel_rows),
                   nrows = max(sel_rows) - min(sel_rows) + 1)

# Generate Plot 1 in a png file
png(filename = "plot1.png", width = 480, height = 480, bg = "transparent")
par(bg = NA)
hist(data$Global_active_power, col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()