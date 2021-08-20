# Set inputs

sink('../log/log.txt')
  source('inputs.R', max.deparse.length = 1000, echo = TRUE)
sink()
