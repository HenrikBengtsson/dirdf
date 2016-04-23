path1 <- system.file(package = "dirdf", "examples", "dataset_1")
template1 <- "Year-Month-Day_Assay_Plasmid-Type-Fraction_WellNumber?.extension"
files1 <- dirdf(path1, template = template1)
print(files1)

path2 <- system.file(package = "dirdf", "examples", "dataset_2")
template2 <- "Date_Assay_Experiment_WellNumber?.extension"
files2 <- dirdf(path2, template = template2)
print(files2)

