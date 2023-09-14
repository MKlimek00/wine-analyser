#helper functions

remove_outliers <-function(dataframe)
{
  names <- head(names(dataframe), -1)
  for(n in names(dataframe))
  {
    quartiles <- quantile(dataframe[[n]], probs = c(0.25, 0.75))
    IQR <- IQR(dataframe[[n]])
    lower <- quartiles[1] - 1.5*IQR
    upper <- quartiles[2] + 1.5*IQR
    dataframe <- subset(dataframe, dataframe[[n]] > lower & dataframe[[n]] < upper)
  }
  return(dataframe)
}