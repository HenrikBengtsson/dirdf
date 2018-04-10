#' Path Templates
#'
#' A friendly, focused alternative to using regular expressions for path
#' parsing.
#'
#' The purpose of the \pkg{dirdf} package is to let you, the user, write a path
#' specification that we can apply to file paths, extracting out relevant chunks
#' into data frame columns. The most obvious mechanism for doing so is a regular
#' expression, and indeed, \pkg{dirdf} lets you provide a regex argument.
#'
#' But for most reasonable directory/file naming conventions, regex is overkill;
#' its power is wasted on something like `YYYY-MM/DD/LocationId/SubjectId.csv`,
#' yet you still have to pay the price of regexes being difficult to write and
#' to read, and easy to get subtly wrong.
#'
#' Path templates are a friendlier alternative. A path template is a string that
#' consists of variable names and delimiters. A variable name is any contiguous
#' run of alphanumeric characters (optionally, with a trailing `?` character);
#' delimiters are everything else.
#'
#' For example:
#'
#' `Year-Month/Day/FirstName_MiddleInitial?_LastName.ext`
#'
#' In this example, `Year`, `Month`, `Day`, `FirstName`,
#' `MiddleInitial`, `LastName`, and `ext` are variable names. All
#' of the dash, slash, underscore, and period characters between them are
#' considered delimiters.
#'
#' When parsed, this template will match each variable to any number of
#' non-slash characters, up until the next delimiter. (Slash will never be
#' considered part of a variable match, as we consider it the path separator.)
#'
#' The trailing question mark makes `MiddleInitial?` optional; both its
#' value and its preceding delimiter (`_` in this case) can be omitted from
#' target paths, in which case the resulting value for that variable will be
#' `NA` (or in some edge cases, `""`).
#'
#' @examples
#' template <- "Year-Month/Day/FirstName_MiddleInitial?_LastName.ext"
#' paths <- c(
#'   "1860-02/01/Abel_Magwitch.csv",
#'   "1847-10/13/Bertha_A_Mason.csv"
#' )
#' dirdf_parse(paths, template)
#'
#' @rdname templates
#' @name templates
NULL

# Given a template, returns a list with "pattern" and "names" elements
#
# @examples
# templateToRegex("foo/bar/baz.csv")
# templateToRegex("foo/bar?/baz_qux.csv")
# templateToRegex("foo1/bar?/baz_qux.csv")

#' @importFrom utils head tail
templateToRegex <- function(template) {
  stop_if_not(is.character(template))
  stop_if_not(length(template) == 1)

  # Match on variable names, possibly with trailing '?'
  m <- gregexpr("[a-z0-9]+\\??", template, ignore.case = TRUE)

  # mstr holds the variable names
  mstr <- regmatches(template, m)[[1]]
  # sep holds the literal values that come between the variable
  # names (the separators), including the part of the string
  # before the first variable and the part of the string after
  # the last variable, even if they are empty. So basically the
  # template is:
  # sep[1] + mstr[1] + sep[2] + mstr[2] + ... + sep[n] + mstr[n] + sep[n+1]
  sep <- regmatches(template, m, invert = TRUE)[[1]]

  stop_if_not(length(sep) == length(mstr) + 1)

  # col names minus trailing ?
  bareNames <- sub("\\?", "", mstr)

  # Intentionally not using mapply because in one particular case we may
  # need to mutate sep during iteration.
  patterns <- vapply(1:length(mstr), FUN.VALUE = character(1), function(i) {
    col <- mstr[i]
    colBare <- bareNames[i]
    pre <- sep[i]
    post <- sep[i+1]

    # col is the colname, possibly with a trailing '?'
    # pre is the separator that comes to the left
    # post is the separator that comes to the right
    #
    # The result of the callback function is a regex pattern that matches the
    # previous separator and the variable data. We need the next separator
    # just to help us form the regex for the variable data.

    colPattern <- if (nchar(post) == 1) {
      sprintf("(?P<%s>[^/%s]*?)", colBare, escapeRegexBrackets(post))
    } else {
      sprintf("(?P<%s>[^/]*?)", colBare)
    }
    # See weird sub call below
    stop_if_not(grepl("\\*\\?\\)$", colPattern))

    isOptional <- grepl("\\?$", col)
    if (isOptional) {
      if (i == 1 && pre == "" && grepl("^/", post)) {
        # Special case: the leading path element is an optional
        # var. In this case, we want to steal the "/" from the
        # next element.
        sep[[2]] <<- substring(sep[[2]], 2)
        pat <- optional(paste0(colPattern, escapeRegex("/")))
      } else if (pre == "/" && post != "/") {
        # If the previous separator is "/" but next separator
        # is not "/", we've made the beginning of a path element
        # optional--we won't remove the preceding separator, lest
        # we combine two variables that are at different levels
        # of the directory hierarchy. For example:
        # "one/two?_three" must not interpret "foo_bar" as
        # c(one = "foo", two = NA, three = "bar"), but rather it
        # shouldn't match at all.
        #
        # (But if both previous and post are "/", then it means
        # the entire level of hierarchy is optional, so that's
        # fine, e.g. "one/two?/three" can match on "foo/bar")
        #
        # The weird subbing of + for * is to avoid an annoying
        # edge case:
        #
        # template: "dir/prefix?-name",
        # path:     "foo/-bar",
        #
        # Without replacing * with +, prefix matches on an empty
        # string instead of not matching at all (NA); the latter
        # is what we want.
        pat <- paste0(escapeRegex(pre),
          optional(sub("\\*\\?\\)", "+?)", colPattern))
        )
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

  pattern
}

# Escape regex metacharacters
# Taken from the "Special Characters" section of:
# http://www.regular-expressions.info/characters.html
#
# Also found that PCRE complains if closing paren,
# closing brace, closing bracket are not escaped.
escapeRegex <- function(val) {
  gsub("([.?*+^$[\\\\(){}|\\-\\]])", "\\\\\\1", val, perl = TRUE)
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
