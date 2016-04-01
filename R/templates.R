# Given a template, returns a list with "pattern" and "names" elements
#
#' @examples
#' templateToRegex("foo/bar/baz.csv")
#' templateToRegex("foo/bar?/baz_qux.csv")
templateToRegex <- function(template) {
  stopifnot(is.character(template))
  stopifnot(length(template) == 1)

  # Match on variable names, possibly with trailing '?'
  m <- gregexpr("[a-z]+\\??", template)

  # mstr holds the variable names
  mstr <- regmatches(template, m)[[1]]
  # sep holds the literal values that come between the variable
  # names (the separators), including the part of the string
  # before the first variable and the part of the string after
  # the last variable, even if they are empty. So basically the
  # template is:
  # sep[1] + mstr[1] + sep[2] + mstr[2] + ... + sep[n] + mstr[n] + sep[n+1]
  sep <- regmatches(template, m, invert = TRUE)[[1]]

  stopifnot(length(sep) == length(mstr) + 1)

  patterns <- mapply(mstr, head(sep, -1), tail(sep, -1), FUN = function(col, pre, post) {
    # col is the colname, possibly with a trailing '?'
    # pre is the separator that comes to the left
    # post is the separator that comes to the right
    #
    # The result of the callback function is a regex pattern that matches the
    # previous separator and the variable data. We need the next separator
    # just to help us form the regex for the variable data.

    colPattern <- if (nchar(post) == 1) {
      sprintf("([^%s]*)", escapeRegexBrackets(post))
    } else {
      "([^/]*?)"
    }

    isOptional <- grepl("\\?$", col)
    if (isOptional) {
      if (pre == "/" && post != "/") {
        # If the previous separator is "/" but next separator
        # is not "/", we've made the beginning of a path element
        # optional--that's not allowed.
        #
        # (But if both previous and post are "/", then it means
        # the entire level of hierarchy is optional, so that's
        # fine)
        pat <- paste0(escapeRegex(pre), optional(colPattern))
      } else {
        pat <- optional(paste0(escapeRegex(pre), colPattern))
      }
    } else {
      pat <- paste0(escapeRegex(pre), colPattern)
    }
    pat
  })

  pattern <- paste0(
    "^",  # Match the beginning of the string
    paste0(patterns, collapse = ""),  # The variables and separators
    escapeRegex(tail(sep, 1)),  # The trailing separator
    "$"   # Match the end of the string
  )

  list(
    pattern = pattern,
    names = sub("\\?", "", mstr)
  )
}

# Escape regex metacharacters
# Taken from the "Special Characters" section of:
# http://www.regular-expressions.info/characters.html
escapeRegex <- function(val) {
  gsub("([.?*+^$[\\\\({|-])", "\\\\\\1", val, perl = TRUE)
}

# Escape regex metacharacters for use inside regex [].
# Only ], \, ^, and - according to the "Metacharacters Inside
# Character Classes" section of:
# http://www.regular-expressions.info/charclass.html
escapeRegexBrackets <- function(val) {
  gsub("([\\]\\\\^-])", "\\\\\\1", val, perl = TRUE)
}

# Makes a regex optional
optional <- function(regex) {
  sprintf("(?:%s)?", regex)
}
