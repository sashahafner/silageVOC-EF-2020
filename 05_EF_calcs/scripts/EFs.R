# Calculate emission factors from absolute losses and silage consumption

# Sum across compounds for EFs
tot <- colSums(emis[, c('emis.store', 'emis.mix', 'emis.feed')])
EFs <- data.frame(animal.type = rep(c('Dairy', 'Beef'), each = 3), 
                  stage = gsub('emis\\.', '', names(tot)), emis.sil = as.vector(tot))

# Add feeding rate (kg/head-year)
frate <- data.frame(animal.type = c('Dairy', 'Beef'), frate = c(frate.dairy, frate.beef))
EFs <- merge(EFs, frate, by = 'animal.type')

# Calculate final (per animal) EFs (kg VOC / animal - year)
EFs$EF.animal <- EFs$emis.sil * EFs$frate / 1E6
EFs$EF.animal.round <- round(EFs$EF.animal, 2)

# Get total emissions
emis.tot <- ddply(EFs, 'animal.type', summarise, EF.animal = sum(EF.animal))
pop <- data.frame(animal.type = c('Dairy', 'Beef'), pop = c(n.dairy, n.beef))
emis.tot <- merge(emis.tot, pop, by = 'animal.type')
emis.tot$emis <- emis.tot$EF.animal * emis.tot$pop
emis.tot <- rbind(emis.tot, 
                  data.frame(animal.type = 'Total', EF.animal = NA, 
                             pop = sum(emis.tot$pop), emis = sum(emis.tot$emis)))
