# Make absolute emission estimates

# Merge in emission loss estimates by group and stage
names(floss)[names(floss) %in% c('store', 'mix', 'feed', 'total')] <- paste0('floss.', names(floss)[names(floss) %in% c('store', 'mix', 'feed', 'total')])
crops <- c('corn', 'grass', 'legume', 'wmean')
emis <- concsw
names(emis)[names(emis) %in% crops] <- paste0('conc.', names(emis)[names(emis) %in% crops])
emis <- merge(emis, floss, by = 'group')

# Absolute emission losses (mg VOC/kg DM) by process
emis$emis.store <- emis$floss.store * emis$conc.wmean
emis$emis.mix <- emis$floss.mix * (1 - emis$floss.store) *emis$conc.wmean
emis$emis.feed <- emis$floss.feed * (1 - emis$floss.mix) * (1 - emis$floss.store) * emis$conc.wmean
emis$emis.total <- emis$emis.store + emis$emis.mix + emis$emis.feed

# Calculate speciation 
emis$spec.pt <- 100 * emis$emis.total / sum(emis$emis.total)
