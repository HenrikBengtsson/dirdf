parse_key_value_pairs <- function(x, template = "name=value", split = ",", fixed = TRUE, as = c("data.frame", "spread", "gather")) {
  as <- match.arg(as)
  
  pairs <- strsplit(x, split = split, fixed = fixed)
  pairs <- lapply(pairs, FUN = function(x) {
    x <- dirdf::dirdf_parse(x, template = template)
    x <- x[-ncol(x)]
  })
  names(pairs) <- x
  
  if (as == "spread") {
    pairs <- lapply(pairs, FUN = function(x) {
      values <- as.list(x$value)
      names(values) <- x$name
      as.data.frame(values, check.names = FALSE,
          fix.empty.names = FALSE, stringsAsFactors = FALSE)
    })
  } else if (as == "data.frame") {
    names <- lapply(pairs, FUN = .subset2, "name")
    unames <- unique(unlist(lapply(names, FUN = na.omit), use.names = FALSE))
#    idxs <- lapply(names, FUN = match, unames)

    pairs <- lapply(pairs, FUN = function(x) {
      values <- x$value
      names(values) <- x$name
      values
    })
    
    pairs <- lapply(pairs, FUN = function(values) {
      values <- as.list(values[unames])
      names(values) <- unames
      as.data.frame(values, check.names = FALSE,
          fix.empty.names = FALSE, stringsAsFactors = FALSE)
    })
    pairs <- do.call(rbind, pairs)
  }
  pairs
}
