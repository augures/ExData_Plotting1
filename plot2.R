plot2 <- function() {
    source('init.R')
    data <- get.data.for.dates(as.Date(c('2007-2-1', '2007-2-2')))
    png('plot2.png', height = 504, width = 504)
    plot(data$DateTime, data$Global_active_power,
         type="n", ylab="Gloval Active Power (kilowatts)", xlab="")
    lines(data$DateTime, data$Global_active_power)
    dev.off()
}
plot2()