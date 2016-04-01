#' @export
dirdf <- function(paths, template=NULL, regexp=NULL, colnames=NULL, missing=NA_character_, recursive=TRUE, ...) {
  stopifnot(!is.null(template) != (!is.null(regexp) && !is.null(colnames)))

  if (!is.null(template)) {
    res <- templateToRegex(template)
    regexp <- res$pattern
    colnames <- res$names
  }

  pathnames <- lapply(paths, FUN=dir, recursive=recursive, ...)
  pathnames <- unlist(pathnames, use.names=FALSE)

  dirdf_parse(pathnames, colnames=colnames, regexp=regexp, missing=missing)
}
