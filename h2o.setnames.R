# h2o.setnames
# data: h2o.frame
# old: character vector
# new: character vector
# skip_absent: logical Defaulted to FALSE
h2o.setnames <- function(data, old, new, skip_absent=FALSE){
  stopifnot(is.logical(skip_absent),
            !missing(new),
            is.h2o(data) || is.data.frame(data),
            missing(old) || length(old) == length(new),
            !missing(old) || length(data) == length(new),
            missing(old) || all(old %in% colnames(data)))
  
  frame_names <- colnames(data)
  
  if(missing(old)){
    colnames(data) <- new
  } else {
    name_positions <- match(x = old, table = frame_names, nomatch = NA)
    colnames(data)[name_positions] <- new
  }
  
  # assign(x = deparse(substitute(data)), value = data, pos = parent.frame())
  # return(invisible(NULL))
  return(data)
}

h2o.setnames(data = mtcars, old = "a", new = "b", skip_absent = "HI")
h2o.setnames(data = mtcars, old = "a", skip_absent = F)
h2o.setnames(data = mtcars, new = "a", skip_absent = F)
h2o.setnames(data = matrix(NA), old = "a", new = "b", skip_absent = F)
h2o.setnames(data = mtcars, old = "a", new = c("b", "c"), skip_absent = FALSE)
h2o.setnames(data = mtcars, old = "a", new = "b", skip_absent = FALSE)
h2o.setnames(data = mtcars, old = "mpg", new = c("a"), skip_absent = FALSE)
