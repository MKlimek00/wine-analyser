#helper functions

remove_outliers <-function(dataframe, name)
{
    quartiles <- quantile(dataframe[[name]], probs = c(0.25, 0.75))
    IQR <- IQR(dataframe[[name]])
    lower <- quartiles[1] - 1.5*IQR
    upper <- quartiles[2] + 1.5*IQR
    dataframe <- subset(dataframe, dataframe[[name]] > lower & dataframe[[name]] < upper)
    
  return(dataframe)
}