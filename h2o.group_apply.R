# h2o.group_apply
# data: h2o.frame
# by: string
# fun: function name
# ...: additional arguments to be passed to fun
h2o.group_apply <- function(data, by, fun, ...){
  unique_values <- as.vector(h2o.unique(data[[by]]))
  for(group in unique_values){
    group_rows <- as.vector(h2o.which(data[[by]] == group))
    temp <- data[group_rows, ]
    temp <- fun(temp, ...)
    # for the first group of by, define temp_names and initialize any new columns
    if(group == unique_values[1]){
      temp_names <- colnames(temp)
      data_names <- colnames(data)
      new_cols <- setdiff(temp_names, data_names)
      if(length(new_cols) > 0){
        for(column in new_cols){
          data[, column] <- NA
        }
      }
    }
    data[group_rows, temp_names] <- temp
  }
  return(data)
}
