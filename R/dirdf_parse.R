#' @export
dirdf_parse <- function(pathnames, regexp, colnames, missing=NA_character_) {
  stopifnot(length(missing) == 1L)

  ## Parse
  df <- regmatches(pathnames, m=m)
  ncol <- length(m[[1]])

  ## Coerce to matrix
  df <- matrix(unlist(df), ncol=ncol, byrow=TRUE)
  ## Remove the first column; it's the complete regex match
  df <- df[,-1,drop=FALSE]


  ## Default is that missing parts become empty strings
  if (nzchar(missing)) {
    ## Otherwise, set to requested missing value
    m <- matrix(unlist(m), ncol=ncol, byrow=TRUE)
    m <- m[,-1,drop=FALSE]
    df[m == 0] <- as.character(missing)
  }

  ## Coerce to data.frame
  df <- as.data.frame(df, stringsAsFactors=FALSE)
  colnames(df) <- c(colnames)
  df <- cbind(pathname=pathnames, df)
  class(df) <- c("dirdf", class(df))

  df
}
