add_random_rows <- function(n, variance, df) {
  set.seed(123) # Ustawianie ziarna losowości dla powtarzalności wyników
  first_value <- df[1]
  new_values <- runif(n, min = first_value - variance, max = first_value + variance)
  df <- c(new_values, df)
  return(df)
}
