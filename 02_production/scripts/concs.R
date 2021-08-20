# Means etc. in concentration data

# Changes names in concs to those in names sheet
concs <- merge(concs, nms, by = 'cas')
concs$compound <- concs$name
concs$name <- NULL

# Assign an order to the groups
concs$group <- factor(concs$group, levels = c('Acid', 'Alcohol', 'Ketone', 'Ester', 'Aldehyde'))

# Set values listed as zero to 5 mg/kg (crude) 
concs$dl[concs$conc == 0] <- 'dl'
concs$conc[concs$dl %in% c('dl','z')] <- 5

# Find studies that only report min and max, and take midpoint
n.mns <- ddply(concs, 'study', summarise, n = sum(v.type %in% c('mean', 'median')))
stud.nm <- n.mns$study[n.mns$n == 0]
concs.nm <- concs[concs$study %in% stud.nm,]
# Use transform instead of summarise below because need all original rows to get dl info
concs.nm<-unique(
   ddply(concs.nm, c('study', 'crop', 'scale', 'o.type', 'compound', 'cas'), 
	 transform, conc = mean(conc), dl = dl[v.type=='minimum'], 
	 notes.concs = 'Midpoint calculated from min and max', v.type = 'midpoint'
   )
)

# Add midpoint data back to data frame
concs <- rbind(concs, concs.nm)

# Remove all data that are not means or midpoints or quantiles
concs <- subset(concs, v.type %in% c('mean', 'median', 'midpoint'))

# Eliminate all compounds with no values >= 10 mg/kg
concs.max <- ddply(concs, 'cas', summarise, max = max(conc))
cas.incld <- concs.max$cas[concs.max$max >= 10]
concs <- concs[concs$cas %in% cas.incld,]
concs$compound <- factor(concs$compound)
concs$cas <- factor(concs$cas)

# Summarize by study, regardless of treatment
summ.s <- ddply(concs, c('crop', 'group', 'compound', 'cas', 'study'), summarise,
   conc.mean = 10^mean(log10(conc)), conc.median = 10^median(log10(conc)), 
   conc.min = min(conc), conc.max = max(conc), 
   conc.sd = sd(conc), n.sil = sum(n.sil), n = length(conc), 
   n.study = length(unique(study))
)

# Then take weighted mean of the studies for each compound/crop
# Weight mean by the number of silages in each study
summ <- ddply(summ.s, c('crop', 'group', 'compound', 'cas'), summarise,
   conc.mean = 10^(sum(log10(conc.mean) * n.sil) / sum(n.sil)), 
   conc.median = 10^median(log10(conc.median)), 
   conc.max = max(conc.max), n.studies = length(cas),
   n.sil = sum(n.sil)
)

# Group sums
gsumm <- ddply(summ, c('crop', 'group'), summarise, conc.mean = sum(conc.mean)) 


