context("dirdf_parse")

pathnames <- c(
  "2013-06-26,BRAFWTNEGASSAY,Plasmid-Cellline-100,A01.csv",
  "2013-06-26,BRAFWTNEGASSAY,Plasmid-Cellline-100,A02.csv",
  "2014-02-26,BRAFWTNEGASSAY,FFPEDNA-CRC-1-41,D08.csv",
  "2014-03-05,BRAFWTNEGASSAY,FFPEDNA-CRC-REPEAT,platefile.csv",
  "2016-04-01,BRAFWTNEGASSAY,FFPEDNA-CRC-1-41.csv"
)

df <- data.frame(pathnames = pathnames,
                 date = c("2013-06-26", "2013-06-26",
                          "2014-02-26", "2014-03-05",
                          "2016-04-01"),
                 assay = rep("BRAFWTNEGASSAY", 5),
                 experiment = c(rep("Plasmid-Cellline-100", 2),
                                "FFPEDNA-CRC-1-41",
                                "FFPEDNA-CRC-REPEAT",
                                "FFPEDNA-CRC-1-41"),
                 well = c("A01", "A02", "D08", "platefile", "-"),
                 ext = rep("csv", 5), stringsAsFactors = FALSE)

df_parse <- dirdf_parse(
  pathnames,
  regexp="([^,]+)(?:,([^,]+))?(?:,([^,]+))?(?:,([^,]+))?[.]([^,]+)$",
  colnames=c("date", "assay", "experiment", "well", "ext"),
  missing="-"
)

test_that("Two data frames match with a regex and dirdf_parse().", {
  expect_equal(df, df_parse, check.attributes = FALSE)
})
