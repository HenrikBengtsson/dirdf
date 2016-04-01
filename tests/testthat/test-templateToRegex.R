context("templateToRegex")

n_ <- function(){
  paste0(sample(c(letters, 0:9), 10), collapse = "")
}

make_path <- function(){
  dirs <- list()
  for(i in 1:6){
    dirs[[i]] <- n_()
  }

  date <- as.character(Sys.Date())

  file_name <- paste0(date, "_", dirs[[1]], ",",  dirs[[2]],
                      "-", dirs[[3]], ".", dirs[[4]])

  # `path` is the path that will be parsed
  path <- file.path(dirs[[5]], dirs[[6]], file_name, fsep = "/")

  # `vec` is the corresponding row of the data frame
  vec <- c(path, dirs[[5]], dirs[[6]], date, dirs[[1]],
           dirs[[2]], dirs[[3]], dirs[[4]])
  list(path = path, vec = vec)
}

template <- "f1/f2/date_id1,id2-id3.ext"

set.seed(04-01-2016)
df_parse <- dirdf_parse(replicate(10, make_path()$path),
                        template = template)

set.seed(04-01-2016)
df <- data.frame(matrix(nrow = 10, ncol = 8),
                 stringsAsFactors = FALSE)
for(i in 1:10){
  df[i,] <- make_path()$vec
}
colnames(df) <- c("pathname", "f1", "f2", "date", "id1",
                  "id2", "id3", "ext")

test_that("Randomly generated paths match with dirdf_parse().", {
  expect_equal(df, df_parse, check.attributes = FALSE)
})
