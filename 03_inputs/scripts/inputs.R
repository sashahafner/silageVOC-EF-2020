# Silage production, weather, and other inputs for calculation of emission factors

# US dairy cows in 2017
# Source: Abt (Jonathan Dorn, personal communication)
n.dairy <- 18.651325E6

# US beef cows in 2017
# Source: Abt (Jonathan Dorn, personal communication)
n.beef <- 81.413215E6

# Fraction of silage consumed by dairy
# Source: Al Rotz, personal communication, based on simulations described in Rotz et al. 2019, 2021
f.sil.dairy <- 0.75
f.sil.beef <- 0.25

# Silage production, fresh mass (FM) basis
# Units: kg
# Source: NASS
prod.sil.FM <- 148.1E9

# Fraction of silage produced that is corn, grass (haylage), or legume 
# Source: NASS
f.corn <- 0.75
f.grass <- 0.15
f.legume <- 0.10

# Silage dry matter (DM) content
# Units: kg DM / kg FM
# Source: Muck and Holmes 2000
dm <- 0.34

# Silage feeding rate for dairy and beef cows
# Units: kg DM / animal - yr
# Source: Calculated
frate.dairy <- f.sil.dairy * dm * prod.sil.FM / n.dairy
frate.beef <- f.sil.beef * dm * prod.sil.FM / n.beef
frate.dairy
frate.beef

# Stored silage dry density
# Units: kg DM / m3
# Source: Muck and Holmes 2000 Table 1 approximate average
rho.d.store <- 232

# Mixed feed (fed silage) dry density
# Units: kg DM / m3
# Source: Hafner et al. 2012
rho.d.feed <- 75

# Removal thickness stored silage
# Units: m
# Source: General recommendation from Himba 2011 and Saxe 2007 (12 inches per day) divided by 2 for 2 x daily removal
thk.store <- 0.15

# Time between stored silage removal events
# Units: sec
# Source: Guess, assuming 2 removals per day
t.out.store <- 12 * 3600

# Effective feed thickness
# Units: m
# Source: Guess
thk.feed <- 0.15

# Effective feed exposure duration
# Units: sec
# Source: Guess, assuming feeding twice per day
t.out.feed <- 8 * 3600

# Mass transfer model convection coefficient for feedout (storage)
# Units: m/s
# Source: Hafner et al. 2012, Fig. 1 (around 2 m/s wind)
h.m.store <- 0.02

# Mass transfer model convection coefficient for feeding (feed lanes)
# Units: m/s
# Source: Hafner et al. 2012, Fig. 1 (around 1 m/s wind) and p 139
h.m.feed <- 0.01

# Mass transfer model dispersion coefficient for feedout (storage)
# Units: m2/s
# Source: Hafner et al. 2012, Fig. 1 (around 2 m/s wind) reduced based on p 139
k.sg.store <- 2E-5

# Mass transfer model dispersion coefficient for feeding (feed lanes)
# Units: m2/s
# Source: Hafner et al. 2012, Fig. 1 (around 1 m/s wind) reduced based on p 139
k.sg.feed <- 6E-5

# Mass transfer model gas-phase diffusivity
# Units: m2/s
# Source: EPA 2012
d.a <- c(`Acetic acid` = 1.2E-5, Acetaldehyde = 1.3E-5, `Propyl acetate` = 8.0-6, Ethanol = 1.4E-5) 

# Mass transfer model Henry's law constant parameters for log10(kh) = a + b/T where T is in K
# Units on kh: mol/kg-atm
# Source: Hafner et al. 2012, Table 1 or Sander 2017 (acetic acid and propyl acetate)
# Note increase by factor of 2 for acetic acid based on pKa = 4.8 and pH 4.0 - 5.0
k.h.p <- matrix(c(-5.44 + 0.30, 2736,
                  -7.52,        2573,
                  -7.64,        2475,
                  -6.85,        2713),
              ncol = 2, byrow = TRUE, 
              dimnames = list(c('Acetic acid', 'Acetaldehyde', 'Propyl acetate', 'Ethanol'), 
                              c('a', 'b')))

# Relative loss of VOC from mixing stage
# Units: Fraction of mixing loss
# Source: Approximation based on Hafner et al. 2010, poorly understood
f.mix.loss <- 0.1

# Silage and air temperature for mass transfer model
# Units: degrees C
# Source: Calculated from 1991-2020 contiguous US monthly averages from NOAA
temp.c <- 11.8
temp.k <- temp.c + 273.15
