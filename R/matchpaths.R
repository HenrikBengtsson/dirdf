# Given regex, colnames (that correspond to capturing groups
# in the regex), and a list of string values, return a data
# frame of the captured values.
#
# @examples
# paths <- c(
#   "2015-12-01/New_York/Smith-John.csv",
#   "2015-12-02/Boston/Smith-Jane.csv"
# )
#
# r <- templateToRegex("date/site/lastname-firstname.ext")
# matchPaths(r$pattern, r$names, paths)
matchPaths <- function(pattern, colnames, paths) {
  # Stop on zero rows. TODO: Return a nice default value
  stopifnot(length(paths) > 0)
  # Stop on zero cols. TODO: Return... something?
  stopifnot(length(colnames) > 0)

  m <- regexec(pattern, paths)
  vals <- regmatches(paths, m)

  colcount <- length(m[[1]])

    # Stop on inconsistent columns
  stopifnot(colcount == length(colnames) + 1)

  matrixValue <- matrix(unlist(vals), ncol = colcount, byrow = TRUE)
  # Remove the first column; it's the complete regex match
  matrixValue <- matrixValue[,-1,drop=FALSE]

  df <- as.data.frame(matrixValue, stringsAsFactors = FALSE)
  names(df) <- colnames
  df
}
