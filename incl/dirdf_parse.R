path1 <- system.file(package = "dirdf", "examples", "dataset_1")
pathnames1 <- dir(path1)

template1 <- "Year-Month-Day_Assay_Plasmid-Type-Fraction_WellNumber?.extension"
regex1 <- paste0(
  "^(?P<Year>\\d{4})-(?P<Month>\\d{2})-(?P<Day>\\d{2})",
  "_(?P<Assay>[a-zA-Z0-9]+)_(?P<Plasmid>[a-zA-Z0-9]+)",
  "-(?P<Type>[a-zA-Z0-9]+)-(?P<Fraction>[a-zA-Z0-9\\-]+)",
  "(?:_(?P<WellNumber>\\w+))?\\.csv$"
)
regex1a <- paste0(
  "^(\\d{4})-(\\d{2})-(\\d{2})_([a-zA-Z0-9]+)_([a-zA-Z0-9]+)",
  "-([a-zA-Z0-9]+)-([a-zA-Z0-9\\-]+)(?:_(\\w+))?\\.csv$"
)
names_regex1a <- c("Year", "Month", "Day", "Assay", "Plasmid", "Type", "Fraction", "WellNumber")

dirdf_parse(pathnames1, template1)
dirdf_parse(pathnames1, regexp = regex1)
dirdf_parse(pathnames1, regexp = regex1a, colnames = names_regex1a)

path2 <- system.file(package = "dirdf", "examples", "dataset_2")
pathnames2 <- dir(path2)
template2 <- "Date_Assay_Experiment_WellNumber?.extension"
dirdf_parse(pathnames2, template2)
