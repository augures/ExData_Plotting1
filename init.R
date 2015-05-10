get.data.for.dates <- function(dates) {
    # Function takes a vector of Date objects,
    # and returns a data.frame of data from "Electric power consumption" dataset
    # filtered by those dates on a first column of this dataset (Date).
    # 'Date' column is converted into Date objects, using as.Date function.
    # 'Time' column is converted into POSIXlt/POSIXt objects using strptime function.
    # Additional column 'DateTime' is added as  POSIXlt/POSIXt objects 
    # obtained by applying strptime function on concatenation of 'Date' and 'Time' columns.
    
    prepare.dataset()
    message('Retrieving data from dataset...')
    dataset.file.path <- file.path('data', 'household_power_consumption.txt')
    dates.str <- sapply(dates, function(d) {
        paste("'", gsub('0(\\d/)', '\\1', format(d, "%d/%m/%Y"), perl=TRUE), "'", sep="")
    })
    # SQL for this case ended up being kind of involved  and verbose -  
    #   to deal with missing values encoded as "?"
    # I think just using read.csv or fread, and further subsetting  would be cleaner and faster,
    #   but this was my first time playing with sqldf, 
    #   and I wanted to see how a task can be solved  using it.
    file.sql <- paste("select
                        case
                            when Date = '?' then null
                            else Date
                        end as Date,
                        case
                            when Time = '?' then null
                            else Time
                        end as Time,
                        case
                            when Global_active_power = '?' then null
                            else Global_active_power
                        end as Global_active_power,
                        case
                            when Global_reactive_power = '?' then null
                            else Global_reactive_power
                        end as Global_reactive_power,
                        case
                            when Voltage = '?' then null
                            else Voltage
                        end as Voltage,
                        case
                            when Global_intensity = '?' then null
                            else Global_intensity
                        end as Global_intensity,
                        case
                            when Sub_metering_1 = '?' then null
                            else Sub_metering_1
                        end as Sub_metering_1,
                        case
                            when Sub_metering_2 = '?' then null
                            else Sub_metering_2
                        end as Sub_metering_2,
                        case
                            when Sub_metering_3 = '?' then null
                            else Sub_metering_3
                        end as Sub_metering_3
                      from file where Date in (", paste(dates.str, collapse=", "), ")")
    data <- read.csv.sql(dataset.file.path, sql = file.sql, header=TRUE, sep=";")
    message('Data retrieved')
    ensure.column.types(data)
}

prepare.dataset <- function() {
    # Fucntion checks if "Electric power consumption" dataset is available in 'data' folder.
    # 'data' folder is created if absent.
    # Dataset izp archive is retrieved if absent.
    # Dataset unziped text file is extracted if absent.
    
    if (!file.exists('data')) {
        dir.create('data')
    }
    dataset.file.path <- file.path('data', 'household_power_consumption.txt')
    if (!file.exists(dataset.file.path)) {
        dataset.zip.path <- file.path('data', 'household_power_consumption.zip')
        if (!file.exists(dataset.zip.path )) {
            message('Downloading dataset zip file...')
            download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip',
                          dataset.zip.path,
                          method = 'curl')
            message('Dataset zip file downloaded.')
        }
        else {
            message('Dataset archive exists.')
        }
        unzip(dataset.zip.path, exdir = 'data')
        message('Dataset file is extracted.')
    }
    else {
        message('Dataset file exists.')
    }
}

ensure.libraries <- function() {
    # Function checks if all required packages are installed.
    # If not all required packages are installed, it prompts if it's OK to install to install them,
    # installs those packages (if allowed by user),
    # and loads them as libraries.
    
    missing.packages <- setdiff(c("sqldf"), installed.packages()[,1])
    if (length(missing.packages) > 0) {
        prompt <- paste("The following packages are missing, yet required to run this code: ",
                        "\n",
                        paste(missing.packages, collapse = ", "),
                        "\n Would you like to install them now?(y/n)")
        answer <- ''
        while (!(answer %in% c('y', 'n'))) {
            answer <- readline(prompt = prompt)
            if (answer == 'n') {
                stop('Cannot proceed without those packages.')
            }
        }
        install.packages(missing.packages)
        message("Installed all missing packages.")
    }
    library("sqldf")
}
# Let's check for required packages on script load
ensure.libraries()

ensure.column.types <- function(data) {
    # Function takes data.frame representing "Electric power consumption" dataset  (or it's subset),
    # and converts 'Date' column to Date objects,
    # 'Time' column to POSIXlt/POSIXt objects,
    # and adds 'DateTime' column as POSIXlt/POSIXt objects.
    
    data$DateTime <- strptime(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S")
    data$Time <- strptime(data$Time, format="%H:%M:%S")
    data$Date <- sapply(data$Date, as.Date, format="%d/%m/%Y")
    data
}