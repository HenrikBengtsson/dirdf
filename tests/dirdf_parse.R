library("dirdf")

pathnames <- c(
  "2013-06-26,BRAFWTNEGASSAY,Plasmid-Cellline-100,A01.csv",
  "2013-06-26,BRAFWTNEGASSAY,Plasmid-Cellline-100,A02.csv",
  "2014-02-26,BRAFWTNEGASSAY,FFPEDNA-CRC-1-41,D08.csv",
  "2014-03-05,BRAFWTNEGASSAY,FFPEDNA-CRC-REPEAT,platefile.csv",
  "2016-04-01,BRAFWTNEGASSAY,FFPEDNA-CRC-1-41.csv"
)

df <- dirdf_parse(
  pathnames,
  regexp="([^,]+)(?:,([^,]+))?(?:,([^,]+))?(?:,([^,]+))?[.]([^,]+)$",
  colnames=c("date", "assay", "experiment", "well", "ext"),
  missing="-"
)

print(df)
