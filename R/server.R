# Define server logic required to draw a histogram
server <- function(input, output) {
  
  source("R/server_helpers.R", local = TRUE)
  
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