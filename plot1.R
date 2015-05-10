plot1 <- function() {
    source('init.R')
    data <- get.data.for.dates(as.Date(c('2007-2-1', '2007-2-2')))
    png('plot1.png', height = 504, width = 504)
    hist(data$Global_active_power,
         main="Global Active Power",
         xlab="Gloval Active Power (kilowatts)", 
         col="red"    
    )
    dev.off()
    message('plot1.png created')
}
plot1()