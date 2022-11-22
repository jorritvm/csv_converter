server <- function(input, output) {
  
  source("R/server_helpers.R", local = TRUE)
  
  output_log = reactiveVal("Ready for csv conversion")
  output_data = reactiveVal()
  
  # notify user of new file (multi-)upload 
  observeEvent(input$input_files, {
    for (i in 1:nrow(input$input_files)) {
      filename = input$input_files[i, "name"]
      size = round(as.numeric(input$input_files[i, "size"]) / 1024, 2)
      log(paste0("New file uploaded: ", filename, " [", size,"kB]"))
    }
  })
  
  # clicking the check button identifies the type of csv file
  observeEvent(input$btn_check, {
    for (i in 1:nrow(input$input_files)) {
      check_file(filename = input$input_files[i, "name"], 
                 datapath = input$input_files[i, "datapath"] )
    }
  })
  
  # clicking the convert button converts the files and offers it for download
  observeEvent(input$btn_convert, {
    opts = get_opts(filenames = input$input_files[, "name"],
                    datapaths = input$input_files[, "datapath"],
                    sizes = input$input_files[, "size"])
    
    csvs = read_csv_to_memory(opts)
    
    output_data(merge_lists_by_key(opts, csvs))
    
    log("File in memory ready for download!")
    
  })
  
  # when the files are in memory show the user a table with info and dl buttons
  observeEvent(output_data(), {
    if (length(names(output_data())) > 0) {
      output$download_section <- renderUI({
        tags$table(
          style = "width:100%",
          tags$tr(
            tags$th("Filename"),
            tags$th("Size (kB)"),
            tags$th("From"),
            tags$th("To"),
            tags$th("DL"),
          ),
          lapply(output_data(), function(item) {
            # item = output_data()[[]]
            tags$tr(
              tags$td(item$filename),
              tags$td(item$size),
              tags$td(item$from),
              tags$td(item$to),
              tags$td(downloadButton(outputId = paste0("download_", item$filename), # define i
                                     label = "Download",
                                     icon = icon("download"))
              ),
            )
          })
        )
      })
    }
  })
  
  # clicking the download button provides the converted file
  observe({
    lapply(output_data(), function(item) {
      output[[paste0("download_", item$filename)]] <- 
        downloadHandler(
          # tell the browser what name to use when saving the file
          filename = function() {
            item$out_filename
          },
          # write data to output file
          content = function(file) {
            # Write to a file specified by the 'file' argument
            fwrite(x = item$csv,
                   file = file,
                   sep = item$to_sep,
                   dec = item$to_dec)
          })
    })
  })
  
}