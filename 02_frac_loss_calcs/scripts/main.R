# Runs code and creates report

source('packages.R')
source('ave_temp.R')
render('emis_calcs.Rmd', output_dir = '../output')
source('export.R')
