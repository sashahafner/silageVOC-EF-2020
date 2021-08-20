# Runs all scripts to update results when inputs or measurement data change

rm(list = ls())

setwd('01_ave_temp/scripts')
source('main.R')

setwd('../../02_production/scripts')
source('main.R')

setwd('../../03_inputs/scripts')
source('main.R')

setwd('../../04_frac_loss_calcs/scripts')
source('main.R')

setwd('../../05_EF_calcs/scripts')
source('main.R')

setwd('../..')
