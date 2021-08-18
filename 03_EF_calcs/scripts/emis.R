# Make absolute emission estimates

# Merge in emission loss estimates by group and stage
crops <- c('corn', 'grass', 'legume', 'wmean')
emis <- concsw
names(emis)[names(emis) %in% crops] <- paste0('conc.', names(emis)[names(emis) %in% crops])
emis <- merge(emis, floss, by = 'group')

# Absolute emission losses (mg VOC/kg DM) by process
emis$emis.store <- emis$floss.store * emis$conc.wmean
emis$emis.mix <- emis$floss.mix * (1 - emis$floss.store) *emis$conc.wmean
emis$emis.feed <- emis$floss.feed * (1 - emis$floss.mix) * (1 - emis$floss.store) * emis$conc.wmean
emis$emis.total <- emis$emis.store + emis$emis.mix + emis$emis.feed

# Get total fractional loss for checking
emis$floss.tot <- 1 - ((1 - emis$floss.store) * (1 - emis$floss.mix) * (1 - emis$floss.feed))

# Calculate speciation 
emis$spec.pt <- 100 * emis$emis.total / sum(emis$emis.total)


