#' Path Metadata Parsing
#'
#' Creates a data frame using information from the paths and file names. It
#' accepts either a template or a regular expression and column names. Similar
#' to \code{\link{dirdf}}, but this takes a vector of pathnames and tries to
#' match them directly, rather than calling \code{list.files} on them and
#' matching those results. This is helpful if you want to filter or transform
#' the set of paths before matching, e.g. to remove any irrelevant filenames
#' like .gitignore, .DS_Store, desktop.ini.
#'
#' @seealso \code{\link{dirdf}}
#'
#' @param pathnames character vector of pathname(s), e.g. the result of calling
#'   \code{\link{list.files}}.
#'
#' @param template \link[=templates]{template} character string, e.g.
#'   \code{"Country/Province/City/StationID_Date.ext"}.
#' @param regexp regular expression used to parse the file names
#' @param colnames character vector containing the names of the columns in the
#'   data frame. Not required if using \code{template} or if \code{regexp} uses
#'   named capturing groups (see examples), but may still be used to override
#'   column names.
#' @param missing value to use for unmatched optional template elements or
#'   regexp capturing groups.
#' @param ignore.case,perl If \code{regexp} is used, these are passed to
#'   \code{\link{regexpr}}. Note that unlike \code{regexpr}, the default value
#'   for \code{perl} is \code{TRUE} (to make it more convenient to use named
#'   capture groups, which are only supported in Perl mode).
#'
#' @examples
#' example_pathnames <- dir(system.file(package = "dirdf", "examples", "dataset_1"))
#'
#' example_template1 <- "Year-Month-Day_Assay_Plasmid-Type-Fraction_WellNumber?.extension"
#' example_regex1 <- paste0(
#'   "^(?P<Year>\\d{4})-(?P<Month>\\d{2})-(?P<Day>\\d{2})",
#'   "_(?P<Assay>[a-zA-Z0-9]+)_(?P<Plasmid>[a-zA-Z0-9]+)",
#'   "-(?P<Type>[a-zA-Z0-9]+)-(?P<Fraction>[a-zA-Z0-9\\-]+)",
#'   "(?:_(?P<WellNumber>\\w+))?\\.csv$"
#' )
#' example_regex1a <- paste0(
#'   "^(\\d{4})-(\\d{2})-(\\d{2})_([a-zA-Z0-9]+)_([a-zA-Z0-9]+)",
#'   "-([a-zA-Z0-9]+)-([a-zA-Z0-9\\-]+)(?:_(\\w+))?\\.csv$"
#' )
#' names_regex1a <- c("Year", "Month", "Day", "Assay", "Plasmid", "Type", "Fraction", "WellNumber")
#'
#' dirdf_parse(example_pathnames, example_template1)
#' dirdf_parse(example_pathnames, regexp = example_regex1)
#' dirdf_parse(example_pathnames, regexp = example_regex1a, colnames = names_regex1a)
#'
#' example_pathnames2 <- dir(system.file(package = "dirdf", "examples", "dataset_2"))
#' example_template2 <- "Date_Assay_Experiment_WellNumber?.extension"
#' dirdf_parse(example_pathnames2, example_template2)
#'
#' @export
dirdf_parse <- function(pathnames, template=NULL, regexp=NULL, colnames=NULL,
  missing=NA_character_, ignore.case = FALSE, perl = TRUE) {
  stopifnot(xor(!is.null(template), !is.null(regexp)))
  stopifnot(length(missing) == 1L)

  if (!is.null(template)) {
    regexp <- templateToRegex(template)
    ignore.case <- FALSE
    perl <- TRUE
  }

  ## Parse
  m <- regexpr(regexp, pathnames, ignore.case = ignore.case, perl = perl)
  nonMatching <- pathnames[!is.na(match(m, -1))]
  if (length(nonMatching) > 0) {
    stop("Unexpected path(s) found:", paste0("\n", nonMatching))
  }

  df <- regexprMatchToDF(pathnames, m, colnames = colnames, missing = missing)

  ## Coerce to data.frame
  df <- cbind(pathname=pathnames, df, stringsAsFactors = FALSE)
  class(df) <- c("dirdf", class(df))

  df
}
