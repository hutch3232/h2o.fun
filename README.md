# h2o.fun
This repo focuses on creating helper functions and wrappers to make working with h2o easier


### Function Usage
#### `h2o.group_apply`
The purpose of this function is to `apply` a function individually to each level of a `group` variable. For example, to calculate the value relative to the group-mean, one approach would be to calculate the mean by-group, then merge that onto the original table, then calculate the relative value, then delete the mean column. To simplify things, this function instead subsets to each of the relevant rows by-group. The desired function is applied to only those rows, then those rows have their values replaced in the main dataset, thus avoiding a merge.

#### Example Usage
```
library(data.table)
library(h2o)
h2o.init()

mtcars <- as.h2o(mtcars)

# define or choose a function to apply by group
# the input data is assumed to be the first argument in `h2o.group_apply`
# here the relative value to the mean is calculated
relativity <- function(data, variable){
  mean_val <- h2o.mean(data[[variable]])
  return(data[[variable]]/mean_val)
}

# without consideration of groups
relativity(data = mtcars, variable = "mpg")
        mpg
1 1.0452636
2 1.0452636
3 1.1348577
4 1.0651734
5 0.9307824
6 0.9009177

# calculate the mpg by group, where group is "cyl"
mt_adj <- h2o.group_apply(data = mtcars,
                          by = "cyl",
                          fun = relativity,
                          variable = "mpg")
                          
mt_adj
        mpg cyl disp  hp drat    wt  qsec vs am gear carb
1 1.0636758   6  160 110 3.90 2.620 16.46  0  1    4    4
2 1.0636758   6  160 110 3.90 2.875 17.02  0  1    4    4
3 0.8550972   4  108  93 3.85 2.320 18.61  1  1    4    1
4 1.0839363   6  258 110 3.08 3.215 19.44  1  0    3    1
5 1.2384106   8  360 175 3.15 3.440 17.02  0  0    3    2
6 0.9167873   6  225 105 2.76 3.460 20.22  1  0    3    1

# confirm the function worked as desired
h2o.group_by(mt_adj,
             by = "cyl",
             mean("mpg"))
  cyl mean_mpg
1   4        1
2   6        1
3   8        1
```
