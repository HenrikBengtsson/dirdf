#' @export
dirdf_parse <- function(pathnames, template=NULL, regexp=NULL, colnames=NULL, missing=NA_character_) {
  stopifnot(!is.null(template) != (!is.null(regexp) && !is.null(colnames)))
  stopifnot(length(missing) == 1L)

  if (!is.null(template)) {
    templateResult <- templateToRegex(template)
    regexp <- templateResult$pattern
    colnames <- templateResult$names
  }

  ## Parse
  m <- regexec(regexp, pathnames)
  nonMatching <- pathnames[!is.na(match(m, -1))]
  if (length(nonMatching) > 0) {
    stop("Unexpected path(s) found:", paste0("\n", nonMatching))
  }
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
  df <- cbind(pathname=pathnames, df, stringsAsFactors = FALSE)
  class(df) <- c("dirdf", class(df))

  df
}
