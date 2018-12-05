context("templates")

verifyTemplate <- function(template, path, expected, ...) {
  results <- dirdf_parse(path, template, ...)[,,drop=TRUE]
  expect_equivalent(results, c(expected, list(pathname=path)))
}

describe("Templates", {
  it("handles leading and trailing vars, or lack thereof", {
    verifyTemplate("/a/", "/foo/", list(a="foo"))
    verifyTemplate("a/", "foo/", list(a="foo"))
    verifyTemplate("/a", "/foo", list(a="foo"))
    verifyTemplate("a", "foo", list(a="foo"))
  })

  it("uses non-greedy, atomic matching", {
    verifyTemplate(
      "c-d-e",
      "foo--bar-baz",
      list(c="foo", d="", e="bar-baz")
    )
    verifyTemplate(
      "c--d--e",
      "foo---bar--baz",
      list(c="foo", d="-bar", e="baz")
    )
  })

  it("deals properly with multi-char delimiters", {
    verifyTemplate(
      "a--b/c--d",
      "foo-bar--baz/qux--quux",
      list(a="foo-bar", b="baz", c="qux", d="quux")
    )
  })

  it("doesn't ever treat / as part of a var", {
    expect_error(
      dirdf_parse("foo/bar", "a")
    )
    expect_error(
      dirdf_parse("foo--bar/baz--qux", "a--b--c")
    )
    expect_error(
      dirdf_parse("foo/bar_baz", "foo_bar")
    )
  })

  it("allows numbers in var names", {
    verifyTemplate(
      "var1_var2.var3(var4)*var5[var6]",
      "one_two.three(four)*five[six]",
      list(var1="one", var2="two", var3="three", var4="four",
        var5="five", var6="six"
      )
    )
  })

  it("allows upper case var names", {
    verifyTemplate(
      "One_tWo",
      "a_b",
      list(One="a", tWo="b")
    )
  })
})

describe("Optional vars", {
  it("basically functions", {
    verifyTemplate(
      "a/b?/c",
      "foo/bar",
      list(a="foo", b=NA_character_, c="bar")
    )
    verifyTemplate(
      "a/b?/c",
      "foo/bar/baz",
      list(a="foo", b="bar", c="baz")
    )
  })
  it("remove the preceding delimiter", {
    verifyTemplate(
      "year-month?/city",
      "2015/SanFrancisco",
      list(year="2015", month=NA_character_, city="SanFrancisco")
    )
    verifyTemplate(
      "year-month?/city",
      "2015-05/SanFrancisco",
      list(year="2015", month="05", city="SanFrancisco")
    )
  })
  it("(very rarely) will also remove the succeeding delimiter", {
    verifyTemplate(
      "subdir?/name.ext",
      "image.png",
      list(subdir=NA_character_, name="image", ext="png")
    )
    verifyTemplate(
      "subdir?/name.ext",
      "backups/image.png",
      list(subdir="backups", name="image", ext="png")
    )
  })
  it("supports weird case where first part of a path el is optional", {
    # It would be great if we could make the following separator optional,
    # rather than leaving it hanging there like we do today.

    expect_error(dirdf_parse("foo/bar", "dir/prefix?-name"))

    # It was tricky and hacky to get this to work correctly (prefix being NA
    # instead of ""). See the weird sub() trick in the template parsing code.
    # Still doesn't fix the "following separator should be optional" problem
    # though.
    verifyTemplate(
      "dir/prefix?-name",
      "foo/-bar",
      list(dir="foo", prefix=NA_character_, name="bar")
    )
  })
})


describe("Dropping vars", {
  it("basically functions", {
    verifyTemplate(
      "package/~libs~/~arch~/package2.ext",
      c("class/libs/i386/class.dll", "foreign/libs/i386/foreign.dll"),
      list(package=c("class", "foreign"), package2=c("class", "foreign"), ext=c("dll", "dll"))
    )
  })
  
  it("detects invalid syntax", {
    expect_error(dirdf_parse("", template = "name,~key~?=file"))
  })
})
