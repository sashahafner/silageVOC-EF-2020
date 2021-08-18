# Calculate emission factors from absolute losses and silage consumption

# Sum for EFs
tot <- colSums(emis[, c('emis.store', 'emis.mix', 'emis.feed')])
EFs <- data.frame(animal.type = rep(c('Dairy', 'Beef'), each = 3), stage = gsub('emis\\.', '', names(tot)), emis.sil = as.vector(tot))

# Add consumption (kg/head-year)
EFs <- merge(EFs, consump, by = 'animal.type')

# Calculate final (per animal) EFs (kg VOC / animal - year)
EFs$EF.animal <- EFs$emis.sil * EFs$sil.consump / 1E6
#EFs$EF.animal.round <- round(EFs$EF.animal, 1)
