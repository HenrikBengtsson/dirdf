#' @export
dirdf <- function(paths, colnames, template, missing=NA_character_, recursive=TRUE, ...) {
  pathnames <- lapply(paths, FUN=dir, recursive=recursive, ...)
  pathnames <- unlist(pathnames, use.names=FALSE)
  dirdf_parse(pathnames, colnames=colnames, template=template, missing=missing)
}
