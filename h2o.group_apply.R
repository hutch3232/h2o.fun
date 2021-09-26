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
    data[group_rows, colnames(temp)] <- temp
  }
  return(data)
}
