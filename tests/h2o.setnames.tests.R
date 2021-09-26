library(data.table)
library(h2o)
h2o.init()

mtcars <- as.h2o(mtcars)

source("~/R/h2o.fun/h2o.setnames.R")

testthat::expect_error(object = h2o.setnames(data = mtcars, old = "a", new = "b", skip_absent = "HI"),
                       regexp = "is.logical(skip_absent) is not TRUE", fixed = TRUE)

testthat::expect_error(h2o.setnames(data = mtcars, old = "a", skip_absent = F),
                       regexp = "!missing(new) is not TRUE", fixed = TRUE)

testthat::expect_error(h2o.setnames(data = mtcars, new = "a", skip_absent = F),
                       regexp = "!missing(old) || length(data) == length(new) is not TRUE", fixed = TRUE)

testthat::expect_error(h2o.setnames(data = matrix(NA), old = "a", new = "b", skip_absent = F),
                       regexp = "is.h2o(data) || is.data.frame(data) is not TRUE", fixed = TRUE)

testthat::expect_error(h2o.setnames(data = mtcars, old = "a", new = c("b", "c"), skip_absent = FALSE),
                       regexp = "missing(old) || length(old) == length(new) is not TRUE", fixed = TRUE)

testthat::expect_error(h2o.setnames(data = mtcars, old = "a", new = "b", skip_absent = FALSE),
                       regexp = "missing(old) || skip_absent || all(old %in% colnames(data)) is not TRUE", fixed = TRUE)

testthat::expect_equal(object = h2o.setnames(data = mtcars, old = "a", new = "b", skip_absent = TRUE), expected = mtcars)

test_mtcars <- mtcars
colnames(test_mtcars)[colnames(test_mtcars) == "mpg"] <- "new_mpg"
testthat::expect_equal(object = h2o.setnames(data = mtcars, old = c("a", "mpg"), new = c("b", "new_mpg"), skip_absent = TRUE), expected = test_mtcars)

test_mtcars <- mtcars
colnames(test_mtcars)[colnames(test_mtcars) == "mpg"] <- "new_mpg"
colnames(test_mtcars)[colnames(test_mtcars) == "gear"] <- "new_gear"
testthat::expect_equal(h2o.setnames(data = mtcars, old = c("mpg", "gear"), new = c("new_mpg", "new_gear"), skip_absent = FALSE), expected = test_mtcars)

test_mtcars <- mtcars[, c("wt", "qsec")]
colnames(test_mtcars) <- c("wt2", "qsec2")
testthat::expect_equal(h2o.setnames(data = mtcars[, c("wt", "qsec")], new = c("wt2", "qsec2"), skip_absent = FALSE), expected = test_mtcars)
