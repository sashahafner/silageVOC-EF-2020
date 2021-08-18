# VOC production estimates

# Make wide data frame
concsw <- dcast(subset(concs, crop %in% c('corn', 'grass', 'legume')), 
                group + compound + cas ~ crop, value.var = 'conc.mean')

# Set missing values to corn or grass value
crops <- c('corn', 'grass', 'legume')
for (i in c('corn', 'grass')) {
  for (j in crops[!crops %in% i]) {
    concsw[is.na(concsw[, j]), j] <- concsw[is.na(concsw[, j]), i]
  }
}

# Compound concentrations weighted by silage production
concsw$wmean <- 0.75 * concsw$corn + 0.15 * concsw$grass + 0.10 * concsw$legume
# Sort
concsw <- concsw[order(concsw$group, -concsw$wmean), ]
