library(shiny)
library(fs)
library(data.table)
source("R/file_input_area.R")
source("R/lib_csv.R")
source("R/lib_utils.R")

ui <- fluidPage(
  titlePanel("CSV converter by JVM"),
  includeCSS(css_btn_area),
                
  fluidRow(
    column(
      12,
      fileInputArea(
        "input_files",
        label = "Drop your .csv text files here!",
        buttonLabel = "Only .csv files, max 100 MB each.",
        multiple = FALSE,
        accept = "text/plain"
      )
    ),
    column(12,
      radioButtons(inputId = "details", 
                   label = "Convert how?", 
                   choices = c("Auto", "EU->US", "US->EU"), 
                   inline = TRUE),
      actionButton(inputId = "btn_check",
                   label = "Check",
                   icon = icon("magnifying-glass")),
      actionButton(inputId = "btn_convert",
                   label = "Convert",
                   icon = icon("microchip"))
    ),
    column(12,
      tags$br(),
      textAreaInput(inputId = "text_log",
                    label = "Output",
                    rows = 6)
    ),
    column(12,
           downloadButton(outputId = "download",
                          label = "Download",
                          icon = icon("download"))
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  source("R/shiny_helpers.R", local = TRUE)
  
  output_csv = reactiveVal("")
  output_opts = reactiveValues()
  
  # notify user of new file upload
  observeEvent(input$input_files, {
    filename = input$input_files[1, "name"]
    size = round(as.numeric(input$input_files[1, "size"]) / 1024 / 1024, 2)
    log(paste0("New file uploaded: ", filename, " [", size,"MB]"))
  })
  
  # clicking the check button identifies the type of csv file
  observeEvent(input$btn_check, {
    check_file(filename = input$input_files[1, "name"], 
               datapath = input$input_files[1, "datapath"] )
  })
  
  # clicking the convert button converts the file and offers it for download
  observeEvent(input$btn_convert, {
    opts = get_opts(filename = input$input_files[1, "name"],
                    datapath = input$input_files[1, "datapath"])
    output_opts <<- opts
    
    output_csv(read_csv_to_memory(datapath = input$input_files[1, "datapath"],
                                  opts))

    log("File in memory ready for download!")
    
  })
  
  # clicking the download button provides the converted file
  output$download <- downloadHandler(
    # tell the browser what name to use when saving the file
    filename = function() {
      output_opts$out_filename[1]
    },
    # write data to output file
    content = function(file) {
      # Write to a file specified by the 'file' argument
      fwrite(x = output_csv(),
             file = file,
             sep = output_opts$to_sep,
             dec = output_opts$to_dec)
    }
  )
}

# Run the application 
options(shiny.maxRequestSize = 100 * 1024^2)
shinyApp(ui = ui, server = server)


