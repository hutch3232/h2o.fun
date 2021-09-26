# h2o.setnames
# data: h2o.frame
# old: character vector
# new: character vector
# skip_absent: logical Defaulted to FALSE
h2o.setnames <- function(data, old, new, skip_absent=FALSE){
  stopifnot(is.logical(skip_absent),
            !missing(new),
            is.character(new),
            is.h2o(data) || is.data.frame(data),
            missing(old) || is.character(old),
            missing(old) || length(old) == length(new),
            !missing(old) || length(data) == length(new),
            missing(old) || skip_absent || all(old %in% colnames(data)))
  
  if(missing(old)){
    colnames(data) <- new
  } else {
    name_positions <- match(x = old, table = colnames(data), nomatch = NA)
    if(anyNA(name_positions)){ # won't be TRUE unless skip_absent == TRUE due to earlier test
      na_pos <- which(is.na(name_positions))
      name_positions <- name_positions[-na_pos]
      new <- new[-na_pos]
    }
    colnames(data)[name_positions] <- new
  }
  return(data)
}
