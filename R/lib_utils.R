#' create a list where for each element the name of the variable is the key and the content is the variable content
#'
#' @param ... comma seperated list of variables
#'
#' @return named list
#' @export
#'
#' @examples
#' a <- b <- c <- 1
#' named_list(a,b,c)
named_list <- function(...) {
  L <- list(...)
  snm <- sapply(substitute(list(...)),deparse)[-1]
  if (is.null(nm <- names(L))) nm <- snm
  if (any(nonames <- nm=="")) nm[nonames] <- snm[nonames]
  setNames(L,nm)
}


# utility function
merge_lists_by_key = function(list1, list2) {
  common_keys = intersect(names(list1), names(list2))  
  new_list = list()
  for (key in common_keys) {
    new_list[[key]] = c(list1[[key]], list2[[key]])
  }
  return(new_list)
}