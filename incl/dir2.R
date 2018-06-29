path <- system.file(package = "dirdf")
files <- dir2(path, include.dirs = TRUE)
print(files)

files <- dir2(path, recursive = 1L)
print(files)

files <- dir2(path, recursive = TRUE)
print(files)
