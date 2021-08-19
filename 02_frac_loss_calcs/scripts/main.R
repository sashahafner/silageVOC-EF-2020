# Runs code and creates report

source('packages.R')
render('emis_calcs.Rmd', output_dir = '../output')
source('export.R')
