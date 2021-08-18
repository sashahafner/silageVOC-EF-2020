# Runs all scripts to update results when inputs or measurement data change

setwd('01_production/scripts')
source('main.R')

setwd('../../02_frac_loss_calcs/scripts')
source('main.R')

setwd('../../03_EF_calcs/scripts')
source('main.R')

setwd('../..')
