# add to log file
log = function(txt) {
  output_log(paste0(output_log(), "\n", txt))
}
observe({
  updateTextAreaInput(inputId = "text_log", value = output_log())
})

# validate input file
check_file = function(filename, datapath) {
  if (is.null(filename)) {
    log("Upload a file first!")
    return()      
  }
  
  if (path_ext(filename) != "csv") {
    log("Uploaded file is not a csv file!")
    return()
  }
  
  csv_type = check_csv_type(datapath)
  log(paste0(filename, ": detected csv type = ", csv_type))
  return(csv_type)
}

# analyse file data
get_opts = function(filenames, datapaths, sizes) {
  result = list()
  for (i in 1:length(filenames)) {
    filename = filenames[i]
    datapath = datapaths[i]
    size = round(as.numeric(sizes[i]) / 1024 , 2)
  
    if (input$details == "EU->US") {
      type = "eu"
    } else if (input$details == "US->EU") {
      type = "us"
    } else {
      type = check_file(filename, datapath)
    }
    
    if (is.null(type)) return()# not a decent csv file
    
    if (type == "eu") {
      from = "eu"
      to = "us"
      from_sep = ";"
      from_dec = ","
      to_sep = ","
      to_dec = "."
      suffix = "_us"
    } else if (type == "us") {
      from = "us"
      to = "eu"
      from_sep = ","
      from_dec = "."
      to_sep = ";"
      to_dec = ","
      suffix = "_eu"
    }
    out_filename = paste0(path_ext_remove(filename), suffix, ".csv")
    result[[filename]] = named_list(filename, 
                                    datapath,
                                    from,
                                    to,
                                    from_sep, 
                                    to_sep,
                                    from_dec,
                                    to_dec,
                                    suffix,
                                    out_filename,
                                    size)
  }

  return(result)
}

# read files into server memory
read_csv_to_memory = function(opts) {
  out = list()
  for (input_file in names(opts)) {
    out[[input_file]] <- tryCatch({
      opt = opts[[input_file]]
      list("csv"= fread(opt$datapath, 
                        sep = opt$from_sep, 
                        dec = opt$from_dec))
      },
      error=function(cond) {
        log("Conversion failed")
        list("csv" = NULL)
      }
    )
  }
  return(out)
}


