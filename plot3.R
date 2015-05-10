plot3 <- function() {
    # Instructions say
    # "Your code file should include code for reading the data so that the plot can be fully reproduced".
    # and "There should be four PNG files and four R code files, a total of eight files".
    # But a code retrieving dataset, and subsetting a dataset for analysis
    # is common for all four plots, so it's extracted in a separate file 'init.R'.
    source('init.R')
    # get.data.for.dates function is defined in init.R
    data <- get.data.for.dates(as.Date(c('2007-2-1', '2007-2-2')))
    
    png('plot3.png', height = 504, width = 504)
    plot(data$DateTime, data$Global_active_power,
         type="n", ylab="Energy sub metering", xlab="", ylim=c(0, 38))
    lines(data$DateTime, data$Sub_metering_1)
    lines(data$DateTime, data$Sub_metering_2, col="red")
    lines(data$DateTime, data$Sub_metering_3, col="blue")
    legend('topright', c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
           col=c('black', 'red', 'blue'),
           lwd=1)
    dev.off()
    message('plot3.png created')
}
plot3()