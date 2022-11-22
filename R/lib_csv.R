#' identifies the local csv type used in the provided file
#'
#' @param csv path to csv file
#' @param n_lines amount of lines to read to analyse type of file
#'
#' @return either "us" or "eu"
#' @export
check_csv_type <- function(csv, n_lines = 5) {
  # read top chunk
  con = file(csv)
  x = readLines(con, n = n_lines)
  close(con)
  
  # try EU
  eu_split = strsplit(x, split = ";", fixed = TRUE)
  eu_split_length = unlist(lapply(eu_split, length))
  eu_max = max(eu_split_length)
  eu_same = any(eu_split_length == eu_max)
  
  # try US
  us_split = strsplit(x, split = ",", fixed = TRUE)
  us_split_length = unlist(lapply(us_split, length))
  us_max = max(us_split_length)
  us_same = any(us_split_length == us_max)
  
  # decide
  if (us_same & eu_same) {
    if (us_max > eu_max) {
      return("us") 
    } else {
      return("eu")
    }
  } else if (us_same & !eu_same) {
    return("us") 
  } else {
    return("eu")
  }
}