library(data.table)
library(h2o)
h2o.init()

mtcars <- as.h2o(mtcars)

source("~/R/h2o.fun/h2o.setnames.R")

# testthat skip_abset is a logical
testthat::expect_error(object = h2o.setnames(data = mtcars, old = "a", new = "b", skip_absent = "true"),
                       regexp = "is.logical(skip_absent) is not TRUE", fixed = TRUE)

# test that new is not missing
testthat::expect_error(h2o.setnames(data = mtcars, old = "a", skip_absent = FALSE),
                       regexp = "!missing(new) is not TRUE", fixed = TRUE)

# test that new is.character
testthat::expect_error(h2o.setnames(data = mtcars, old = "a", new = 3L, skip_absent = FALSE),
                       regexp = "is.character(new) is not TRUE", fixed = TRUE)

# test that old is missing or character
testthat::expect_error(h2o.setnames(data = mtcars, old = 3L, new = "b", skip_absent = FALSE),
                       regexp = "missing(old) || is.character(old) is not TRUE", fixed = TRUE)

# test that old is not missing or new will replace all columns of data
testthat::expect_error(h2o.setnames(data = mtcars, new = "a", skip_absent = FALSE),
                       regexp = "!missing(old) || length(data) == length(new) is not TRUE", fixed = TRUE)

# test that data is an h2o.frame or data.frame
testthat::expect_error(h2o.setnames(data = matrix(NA), old = "a", new = "b", skip_absent = FALSE),
                       regexp = "is.h2o(data) || is.data.frame(data) is not TRUE", fixed = TRUE)

# test that old is missing or new will replace all values of old
testthat::expect_error(h2o.setnames(data = mtcars, old = "a", new = c("b", "c"), skip_absent = FALSE),
                       regexp = "missing(old) || length(old) == length(new) is not TRUE", fixed = TRUE)

# test that if old is not missing and skip_absent is FALSE, all values of old exist in data
testthat::expect_error(h2o.setnames(data = mtcars, old = "a", new = "b", skip_absent = FALSE),
                       regexp = "missing(old) || skip_absent || all(old %in% colnames(data)) is not TRUE", fixed = TRUE)

# test that if skip_absent is TRUE, no error is thrown when old does not exist in data
testthat::expect_equal(object = h2o.setnames(data = mtcars, old = "a", new = "b", skip_absent = TRUE), expected = mtcars)

# test that if skip_absent is TRUE, valid values of old are replaced by new and invalid values ignored
test_mtcars <- mtcars
colnames(test_mtcars)[colnames(test_mtcars) == "mpg"] <- "new_mpg"
testthat::expect_equal(object = h2o.setnames(data = mtcars, old = c("a", "mpg"), new = c("b", "new_mpg"), skip_absent = TRUE), expected = test_mtcars)

# test that multiple values of new are accepted and they can be in a different column order than data
test_mtcars <- mtcars
colnames(test_mtcars)[colnames(test_mtcars) == "mpg"] <- "new_mpg"
colnames(test_mtcars)[colnames(test_mtcars) == "gear"] <- "new_gear"
testthat::expect_equal(h2o.setnames(data = mtcars, old = c("gear", "mpg"), new = c("new_gear", "new_mpg"), skip_absent = FALSE), expected = test_mtcars)

# subsetting mtcars to two columns to show that missing old is valid if new replaces all columns of data
test_mtcars <- mtcars[, c("wt", "qsec")]
colnames(test_mtcars) <- c("wt2", "qsec2")
testthat::expect_equal(h2o.setnames(data = mtcars[, c("wt", "qsec")], new = c("wt2", "qsec2"), skip_absent = FALSE), expected = test_mtcars)

h2o.shutdown(F)
