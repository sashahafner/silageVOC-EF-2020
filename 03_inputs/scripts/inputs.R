# Silage production, weather, and other inputs for calculation of emission factors

# US dairy cows in 2007
# Source: NASS
n.dairy <- 9.207E6

# US beef cows in 2010
# Source: NASS
n.beef <- 31.767E6

# Fraction of silage consumed by dairy
# Source: Al Rotz, personal communication
f.sil.dairy <- 0.75
f.sil.beef <- 0.25

# Silage production, fresh mass (FM) basis
# Units: kg
# Source: NASS
prod.sil.FM <- 121E9

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
# Source: ????
thk.store <- 0.15

# Time between stored silage removal
# Units: sec
# Source: ????
t.out.store <- 12 * 3600

# Effective feed thickness
# Units: m
# Source: ????
thk.feed <- 0.15

# Effective feed exposure duration
# Units: sec
# Source: ????
t.out.feed <- 6 * 3600

# Mass transfer model convection coefficient
# m/s
# Source: Hafner et al. 2012
h.m <- 0.01

# Mass transfer model dispersion coefficient for feedout (storage)
# Units: m2/s
# Source: Hafner et al. 2012, Fig. 1
k.sg.store <- 2E-5

# Mass transfer model dispersion coefficient for feeding (feed lanes)
# Units: m2/s
# Source: Hafner et al. 2012, p 139
k.sg.feed <- 2E-5

# Mass transfer model gas-phase diffusivity
# Units: m2/s
# Source: ???
d.a <- c(`Acetic acid` = 1.2E-5, Acetaldehyde = 1.3E-5, `Propyl acetate` = 1.3E-5, Ethanol = 1.2E-5) 

# Mass transfer model Henry's law constant parameters
# Units: mol/kg-atm
# Source: NIST
k.h.p <- matrix(c(-12.6,  6300,
                  -17.31, 5920,
                  -17.6,  5700,
                  -15.78, 6248),
              ncol = 2, byrow = TRUE, 
              dimnames = list(c('Acetic acid', 'Acetaldehyde', 'Propyl acetate', 'Ethanol'), 
                              c('int', 'itemp')))

# Relative loss of VOC from mixing stage
# Units: Fraction of mixing loss
# Source: Hafner et al. 2010
f.mix.loss <- 0.1


# Silage and air temperature for mass transfer model
# Units: degrees C
# Source: Calculated from 1991-2020 contiguous US monthly averages from NOAA
temp.c <- 11.8
temp.k <- temp.c + 273.15
