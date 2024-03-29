# Export results

# Blank-filled concentration (production) data
write.csv(rounddf(concsw, 5, signif), '../output/concs.csv', row.names = FALSE)

# Absolute emission estimates with speciation info
write.csv(rounddf(emis, 4, signif), '../output/emis.csv', row.names = FALSE)

# Speciation data selected from emis
spec <- emis[, c('group', 'compound', 'cas', 'spec.pt')]
spec <- spec[order(spec$spec.pt), ]
write.csv(rounddf(spec, 4, signif), '../output/speciation.csv', row.names = FALSE)

# Emission factors
write.csv(rounddf(EFs, 4, signif), '../output/EFs.csv', row.names = FALSE)

# Total US emissions estimates
write.csv(rounddf(emis.tot, 4, signif), '../output/emis_tot.csv', row.names = FALSE)


