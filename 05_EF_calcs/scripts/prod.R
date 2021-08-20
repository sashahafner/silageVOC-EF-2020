# VOC production estimates

# Make wide data frame
concsw <- dcast(subset(concs, crop %in% c('corn', 'grass', 'legume')), 
                group + compound + cas ~ crop, value.var = 'conc.mean')

# Set missing values to corn (1st choice) or grass (2nd choice) value
crops <- c('corn', 'grass', 'legume')
for (i in c('corn', 'grass')) {
  for (j in crops[!crops %in% i]) {
    concsw[is.na(concsw[, j]), j] <- concsw[is.na(concsw[, j]), i]
  }
}

# Compound concentrations weighted by silage production from NASS
concsw$wmean <- f.corn * concsw$corn + f.grass * concsw$grass + f.legume * concsw$legume

# Sort
concsw <- concsw[order(concsw$group, -concsw$wmean), ]
