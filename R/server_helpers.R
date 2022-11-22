# add to log file
log = function(txt) {
  previous = input$text_log
  if (previous != "") previous = paste0(previous, "\n")
  updateTextAreaInput(inputId = "text_log", value = paste0(previous, txt))
}

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
  log(paste("Detected csv type:", csv_type))
  return(csv_type)
}

# convert file to other type
get_opts = function(filename, datapath) {

  if (input$details == "EU->US") {
    type = "eu"
  } else if (input$details == "US->EU") {
    type = "us"
  } else {
    type = check_file(filename, datapath)
  }
  
  if (is.null(type)) return()# not a decent csv file
  
  if (type == "eu") {
    log("Converting EU csv into US csv")
    from_sep = ";"
    from_dec = ","
    to_sep = ","
    to_dec = "."
    suffix = "_us"
  } else if (type == "us") {
    log("Converting US csv into EU csv")
    from_sep = ","
    from_dec = "."
    to_sep = ";"
    to_dec = ","
    suffix = "_eu"
  }

  out_filename = paste0(path_ext_remove(filename), suffix, ".csv")
  
  return(named_list(from_sep, 
                    to_sep,
                    from_dec,
                    to_dec,
                    suffix,
                    out_filename))
}

read_csv_to_memory = function(datapath, opts) {
  out <- tryCatch(
    fread(datapath, sep = opts$from_sep, dec = opts$from_dec), 
    error=function(cond) {
      log("Conversion failed")
      return()
    }
  )
  return(out)
}
  
