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
#' @example incl/dirdf_parse.R
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
