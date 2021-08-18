# Export results

# Blank-filled concentration (production) data
write.csv(rounddf(concsw, 5, signif), '../output/concs.csv', row.names = FALSE)

# Absolute emission estimates with speciation info
write.csv(rounddf(emis, 4, signif), '../output/emis.csv', row.names = FALSE)

# Emission factors
write.csv(rounddf(EFs, 4, signif), '../output/EFs.csv', row.names = FALSE)


