regexprMatchToDF <- function(values, m, colnames = NULL, missing = NA_character_) {
  cstart <- attr(m, "capture.start", exact = TRUE)
  clength <- attr(m, "capture.length", exact = TRUE)
  cnames <- attr(m, "capture.names", exact = TRUE)

  if (is.null(cstart) || is.null(clength) || is.null(cnames)) {
    stop("Unexpected match format; please use regexpr or gregexpr")
  }

  if (length(cnames) == 0) {
    stop("Nothing captured")
  }

  success <- m >= 0
  colstr <- ifelse(cstart >= 1,
    substring(values, cstart, cstart + clength - 1),
    missing
  )
  df <- as.data.frame(colstr,
    stringsAsFactors=FALSE,
    check.names=FALSE
  )
  if (!is.null(colnames)) {
    names(df) <- colnames
  }

  #cbind(success = success, df)
  df
}

# values <- c("not a match", "foo bar baz", "foo bar ")
# m <- regexpr("foo (.*?) (?P<third>.+)?", values, perl = TRUE)
# m
# regexprMatchToDF(values, m, colnames = c("a", "b"))
