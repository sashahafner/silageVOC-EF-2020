# Calculates average temperature for contiguous US

sink('../output/log.txt')
  source('ave_temp.R', max.deparse.length = 100, echo = TRUE)
sink()
