# Clean up the data 

# Select only some of react and henry columns
react <- react[, c('cas', 'mir', 'ebir', 'ebir.est')]
henry<-henry[,c('cas','kh','kh.type')]

# Drop out lactic acid because it is not volatile
concs <- subset(concs, compound != 'Lactic acid')




