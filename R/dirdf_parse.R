#' @export
dirdf_parse <- function(pathnames, regexp, colnames, missing=NA_character_) {
  stopifnot(length(missing) == 1L)

  # Parse
  m <- regexec(regexp, pathnames)
  df <- regmatches(pathnames, m=m)

  # Coerce to matrix
  df <- Reduce(rbind, df)
  rownames(df) <- NULL

  # Tweak
  if (nzchar(missing)) {
      str(missing)
    df[!nzchar(df)] <- as.character(missing)
  }

  # Coerce to data.frame
  df <- as.data.frame(df, stringsAsFactors=FALSE)
  colnames(df) <- c("pathname", colnames)
  class(df) <- c("dirdf", class(df))

  df
}
