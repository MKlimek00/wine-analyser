# helper functions

remove_outliers <- function(dataframe, name) {
  quartiles <- quantile(dataframe[[name]], probs = c(0.25, 0.75), na.rm = TRUE)
  IQR <- IQR(dataframe[[name]])
  lower <- quartiles[1] - 1.5 * IQR
  upper <- quartiles[2] + 1.5 * IQR
  dataframe <- subset(dataframe, dataframe[[name]] > lower & dataframe[[name]] < upper)

  return(dataframe)
}

log_transform <- function(dataframe, name) {
  dataframe[[name]] <- log(as.numeric(dataframe[[name]]) + 1)

  return(dataframe)
}

scale_standard <- function(dataframe, name) {
  stddev <- sd(dataframe[[name]])
  mean_ <- mean(dataframe[[name]])

  dataframe[[name]] <- (dataframe[[name]] - mean_) / stddev

  return(dataframe)
}

run_regression <- function(dataframe, names) {
  l2 <- str_split(names, " ")
  d2 <- dataframe[[unlist(l2)[[1]]]]

  regr_model <- lm(data = dataframe, quality ~ .) ## TODO: Dynamicznie po wybranych kolumnach
}
