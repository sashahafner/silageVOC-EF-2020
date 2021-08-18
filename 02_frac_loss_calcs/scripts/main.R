# Runs code and creates report

library(rmarkdown)
render('emis_calcs.Rmd', output_dir = '../output')
