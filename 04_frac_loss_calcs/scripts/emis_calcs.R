# Run mass transfer model

# Calculate k.h values
k.h <- exp(k.h.p[, 'int'] + k.h.p[, 'itemp']/temp.k)

# Create empty data frame for holding output
floss <- data.frame(rep = c('Acetic acid', 'Acetaldehyde', 'Propyl acetate', 'Ethanol'), 
                    group = c('Acid', 'Aldehyde', 'Ester', 'Alcohol'), 
                    store = NA, mix = NA, feed = NA, total = NA)


# Storage (feedout) losses
for (i in floss$rep) {
  out <- facd.mod(c.d = 1, d.a = d.a[i], dm = dm, e.d = 100, h.m = h.m.store, k.h = k.h[i],
                  l = thk.store, k.sg = k.sg.store, temp.c = temp.c, t.outs = t.out.store, 
                  rho.d = rho.d.store)
  floss[floss$rep == i, 'store'] <- out$ts$f.lost
}

# Feeding losses
for (i in floss$rep) {
  out <- facd.mod(c.d = 1, d.a = d.a[i], dm = dm, e.d = 100, h.m = h.m.feed, k.h = k.h[i],
                  l = thk.feed, k.sg = k.sg.feed, temp.c = temp.c, t.outs = t.out.feed, 
                  rho.d = rho.d.feed)
  floss[floss$rep == i, 'feed'] <- out$ts$f.lost
}

# Mixing loss
floss$mix <- f.mix.loss * floss$feed

# Total losses
floss$total <- 1 - (1 - floss$store) * (1 - floss$mix) * (1 - floss$feed)
