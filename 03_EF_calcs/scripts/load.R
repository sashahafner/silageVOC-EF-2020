

concs <- read.csv('../../01_production/output/compound_concs.csv')
floss <- as.data.frame(read_excel('../inputs/EF_inputs.xlsx', sheet = 1, skip = 2))
consump <- as.data.frame(read_excel('../inputs/EF_inputs.xlsx', sheet = 2, skip = 1))
