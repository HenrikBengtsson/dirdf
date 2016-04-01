#' Create a data frame from a vector of paths
#'
#' @param paths A vector of strings representing file and
#' directory paths.
#' @param template A string that represents the general pattern
#' of a path. This behaves like a glob. This argument is
#' optional, though you must provide either \code{template}
#' or \code{pattern}.
#' @param pattern A regular expression for parsing metadata in
#' the path. This argument is optional, though you must
#' provide either \code{template} or \code{pattern}.
#' @param column_names A vector of strings specifying the column
#' names of the resulting data frame. This argument is optional.
#' @examples
#' \dontrun{
#'
#' }
pdir <- function(paths, template = NULL, pattern = NULL,
                 column_names = NULL){
  # Check inputs
  if(is.null(template) && is.null(pattern)){
    stop("Please provide an argument for either 'template'
         or 'pattern.'")
  }
}
