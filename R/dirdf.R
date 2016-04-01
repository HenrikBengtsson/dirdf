#' Creates a data frame using information from paths and file names.
#' It searches through the directories in order to create the path names of the files.
#'
#' It accepts either a template or a regular expression and column names.
#'
#' @param paths character vector with zero or more paths that will be searched
#'
#' @param template character string containing the path that will be used to create the column names and the regular expression to parse the file names.
#' @param regexp regular expression used to parse the file names
#' @param colnames vector containing the names of the columns in the data frame
#' @param missing value for a missing variable value
#' @param recursive if TRUE, it will recursively search over directories
#' @param ...
#'
#' @example
#'
#' example_path <- system.file(package = "dirdf", "examples", "dataset_1")
#' example_template1 <- "Year-Month-Day_Assay_Plasmid-Type-Fraction_WellNumber.extension"
#' example_template2 <- "Date_Assay_Experiment_WellNumber.extension"
#'
#' dirdf(example_path1, template = example_template)
#'
#' @export
dirdf <- function(paths, template=NULL, regexp=NULL, colnames=NULL, missing=NA_character_, recursive=TRUE, ...) {
  if (!is.null(template)) {
    res <- templateToRegex(template)
    regexp <- res$pattern
    colnames <- res$names
  }

  pathnames <- lapply(paths, FUN=dir, recursive=recursive, ...)
  pathnames <- unlist(pathnames, use.names=FALSE)

  dirdf_parse(pathnames, colnames=colnames, regexp=regexp, missing=missing)
}
