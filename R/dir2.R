#' List files and directories recursively to a certain depth
#'
#' @param path a character vector of paths.
#' 
#' @param pattern (optional) an optional regular expression.
#'        Full path names (including path and file names) that match the
#'        regular expression will be returned.
#' 
#' @param all.files If `FALSE`, non-visible files (prefixed with a `.`) are
#'        not returned.  If `TRUE`, all files are returned.
#' 
#' @param full.names  If `TRUE` or `recursive = TRUE` (or a positive number),
#'        full path names are returned, otherwise only the file names.
#' 
#' @param recursive If `FALSE` or `0`, content of sub-directories is not
#'        included. if `TRUE` or `+Inf`, content of all sub-directories are
#'        recursively included.  If a positive number `depth`, then
#'        sub-directories to that depth is recursively included.
#' 
#' @param ignore.case If `TRUE`, pattern matching is case-insensitive,
#'        othewise not.
#' 
#' @param include.dirs If `TRUE`, also directories are returned, otherwise not.
#'
#' @param absolute If `TRUE` or `length(path) > 1`, absolute path names are
#'        returned and used in the file pattern matching.
#'
#' @return Character vector of identified files and directories.
#'
#' @details
#' Files \file{.} and \file{..} (the current and parent directories) are never
#' returned.
#'
#' @example incl/dir2.R
#' 
#' @seealso
#' [base::dir()]
#' 
#' @importFrom utils file_test
#'
#' @export
dir2 <- function(path = ".", pattern = NULL, all.files = FALSE, full.names = TRUE, recursive = FALSE, ignore.case = FALSE, include.dirs = FALSE, absolute = FALSE) {
  path <- path[file_test("-d", path)]
  if (length(path) == 0) return(character(0))
  if (length(path) > 1) {
    files <- lapply(path, FUN = dir2, pattern = pattern, all.files = all.files, full.names = TRUE, recursive = recursive, ignore.case = ignore.case, include.dirs = include.dirs, absolute = absolute)
    files <- unlist(files, use.names = FALSE)
    return(files)
  }

  if (absolute) {
    path <- normalizePath(path, mustWork = TRUE)
  } else {
    ## Drop all trailing folder separators
    path <- sub("[/\\]+$", "", path)
    ## Drop any replicated folder separators
    path <- sub("/[/]+", "/", path)
    path <- sub("\\[\\]+", "\\", path)
  }

  depth <- as.numeric(recursive)
  if (is.logical(recursive) && recursive) depth <- +Inf

  files <- dir(path = path, pattern = NULL, all.files = all.files,
               full.names = FALSE, recursive = FALSE,
               ignore.case = ignore.case, no.. = TRUE)
  if (length(files) == 0) return(character(0))

  if (path != ".") files <- file.path(path, files)

  is_dir <- utils::file_test("-d", files)
  dirs <- files[is_dir]

  if (depth > 0 && length(dirs) > 0) {
    files_depth <- lapply(dirs, FUN = dir2, pattern = NULL, all.files = all.files, full.names = TRUE, recursive = depth - 1L, ignore.case = FALSE, include.dirs = include.dirs)
    files_depth <- unlist(files_depth, use.names = FALSE)
    files <- c(files, files_depth)
  }

  if (!include.dirs) {
    is_dir <- utils::file_test("-d", files)
    files <- files[!is_dir]
  }

  if (!absolute && !full.names) {
    prefix <- file.path(path, "")
    files <- gsub(sprintf("^%s", prefix), "", files)
  }

  if (!is.null(pattern)) {
    files_norm <- gsub("\\\\", "/", files)
    idxs <- grep(pattern, files_norm, ignore.case = ignore.case)
    files <- files[idxs]
  }

  files
}
