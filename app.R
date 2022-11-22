library(shiny)
library(fs)
library(data.table)

source("R/lib_file_input_area.R")
source("R/lib_csv.R")
source("R/lib_utils.R")

source("R/ui.R")
source("R/server.R")


# Run the application 
options(shiny.maxRequestSize = 100 * 1024^2) # 1OOMB
options = list(host = "0.0.0.0", port = 8000)
shinyApp(ui = ui, server = server, options = options)


