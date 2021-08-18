# Analytical model for VOC emission from finite thickness layer of silage, based on Crank (1989) p. 60.

# Author: S. Hafner

# Revision history
# Date             Name                              Description
# 2010 JULY 16  FD_mod_v1.R             Original code. Seems to work--matches infinite depth model for 25 cm thickness.
# 2010 JULY 16  FAConvDiffMod_v1.R      Setting up so it can be used as a simple two-parameter or full model
# 2010 JULY 22  FAConvDiffMod_v2.R      Continuing to improve roots finding function (previous version functional)
# 2010 AUG 05   FAConvDiffMod_v3.R      Implemented a much simpler, much faster root solver
# 2010 AUG 06   FAConvDiffMod_v4.R      Improved performance of root solver for high and low values of L (keep values of x in tan(x) between 
# 2010 AUG 18   FAConvDiffMod_v5.R      Adding aqueous-phase diffusion
# 2010 AUG 24   FAConvDiffMod_v6.R      Adding options for calculating h.m and k.sg internally
# 2010 AUG 25   FAConvDiffMod_v6.R      Adding in Millington-Quirck (1961) model as a minimum for k.sg where k.sg is calculated internally
# 2010 AUG 26   FAConvDiffMod_v6.R      Small corrections
# 2010 AUG 27   FAConvDiffMod_v6.R      Small corrections
# 2010 SEP 08   FAConvDiffMod_v6.R      Changing equation for k.sg
# 2010 SEP 20   FAConvDiffMod_v7.R      Adding argument solve. Set to F to just return parameters
# 2010 SEP 22   FAConvDiffMod_v7.R      Small changes--none affect calculations.
# 2010 SEP 23   FAConvDiffMod_v7.R      Re-ran data analysis for model parameters and added new expressions here.
# 2011 OCT 21   FAConvDiffMod_v8.R      Removing internal caclulation of h.m and k.sg   
# 2012 JAN 19   FAConvDiffMod_v8.R      Replaced constant d.a in MQ expression with d.a.

# Tangent root solver ---------------------------------------------------------------------------------------------
# Solves the roots of b*tan(b) = L
btan.roots<-function(L,n=1) {
   r<-NULL

# Start loop for calculating roots
   for (i in 1:n) {
      b<-pi/4
      ct<-0
      while (abs(log10((b + (i-1)*pi)*tan(b)/L))>1E-5){
         if(ct>100) stop('Stuck in btan.roots loop. . .')
         ct<-ct+1
         b<-ifelse(ct>1,(atan(L/(b + (i-1)*pi)) + b)/2,atan(L/(b + (i-1)*pi)))
      }
      r[i]<-b + (i-1)*pi
   }
   return(r)
}
#-------------------------------------------------------------------------------------------------------------------

# Main emission model function --------------------------------------------------------------------------------------
facd.mod<-function(alpha=NA,        # Effective convection coefficient (alpha in Crank) (m/s) (will override calculation if given)
               c.aq =NA,            # Initial solute concentrations, constant with depth (g/kg water) (scalar)
               c.b.g=NA,            # Initial solute concentrations, constant with depth (g/kg silage) (scalar)
               c.b.v=NA,            # Initial solute concentrations, constant with depth (g/m3 silage) (scalar)
               c.d=NA,              # Initial solute concentrations, constant with depth (% of DM) (scalar)
               d.a=1E-5,            # Diffusivity of solutes in air (m2/s)
               D=NA,                # Effective diffusion coefficient (D in Crank) (m2/s) (will override calculation if given)
               d.w=1E-9,            # Diffusivity of solutes in pure water (m2/s)
               dm=NA,               # Silage dry matter content (kg/kg)
               e.d=10,              # Number of roots to include in calculation
               h.coef=NA,           # Henry's law constant coefficient vector c(a,b) where kh (mol/kg-atm) = exp(a + b/T)
               h.m=NA,              # Convection coefficient (will override calculation) (m/s)
               k.h=NA,              # Henry's law constant (will override coefficient vector) (mol/kg-atm)
               k.sg=NA,             # Dispersion coefficient (m2/s)
               l=1,                 # Total layer thickness (m)
               rho.d=rho.w*dm,      # Silage dry density (kg/m3)
               rho.w=rho.d/dm,      # Silage wet density (kg/m3)
               temp.c=NA,           # Temperature (degrees C)
               t.outs=0,            # Vector of times for which output should be given (s)
               solve=TRUE,          # Set to FALSE to just return parameters
               op='f',              # Output option, 'f' for full, 'e' for emission, 'j' for flux
               ...)   {

   # Model constants
   rho.p<-1600                      # Silage particle density, for calculating porosities (kg/m3) (Rees et al. 1983)
   R<-8.2057E-5                     # Universal gas constant (m3 atm/K-mol)
   temp.k<-temp.c + 273.15          # Absolute temperature (K)

   # Henry's law constant
   if(is.na(k.h))   k.h<-exp(h.coef[1] + h.coef[2]/temp.k)   # Henry's law constant (mol/kg-atm)
   h.i<-k.h*R*temp.k                                         # Henry's law constant (m3/kg)

   # Calculate porosities
   # Density of pure water (kg/m3) (regression with data from Lange's Handbook of Chemistry, 15th ed, 1999
   rho.h2o<-999.887 + 4.8915899E-2*temp.c - 7.40977565E-3*temp.c^2 + 3.998247E-05*temp.c^3 - 1.23288498E-7*temp.c^4   
   wc<-1-dm                                                  # Silage water content (kg/kg)
   por.t<-1 - rho.d/rho.p                                    # Total porosity (m3/m3)
   por.aq<-wc*rho.w/rho.h2o                                  # Aqueous porosity (m3/m3)
   por.g<-por.t - por.aq
   #if(por.aq>por.t) stop("Error: water content greater than total porosity")
   if(por.aq>por.t) print("Warning: water content greater than total porosity")
   wc<-ifelse(por.aq>por.t,por.aq/((rho.d/rho.h2o)+por.aq),wc)
   por.g<-ifelse(por.aq>por.t,1E-20,por.g)
   por.aq<-ifelse(por.aq>por.t,por.t-1E-20,por.aq)
   # Set k.sg to Millington-Quirk result if it would otherwise be lower
   k.sg<-max(k.sg,d.a*por.g^(10/3)/(por.t^2))

   # Calculate bulk volumetric concentration if it is not supplied
   if(is.na(c.b.v)) {
      if(!is.na(c.b.g)) c.b.v<-c.b.g*rho.w # This was originally c.b.v<-c.b.g/rho.h2o CHECK!!!
      if(!is.na(c.aq)) c.b.v<-c.aq*wc*rho.w
      if(!is.na(c.d)) c.b.v<-c.d/100*1000*rho.w*dm # CHECK
   }

   t<-t.outs

   # Calculate D and alpha if not supplied
   d.ss<-d.w*por.aq^(11/3)/(por.t^3.06667)                    # Diffusion coefficients in silage solution
   #if(is.na(D)) D<-d.ss*rho.h2o/(rho.w*wc + por.g/h.i) + k.sg/(h.i*rho.w*wc + por.g) # Big D in Crank
   if(is.na(D)) D<-k.sg/(h.i*rho.w*wc + por.g)                # Big D in Crank, ignores aqueous-phase diffusion
   if(is.na(alpha)) alpha<-h.m/(h.i*rho.w*wc + por.g)         # Alpha in Crank

   if(solve) {
      # L and betas
      L<-l*alpha/D                                            # Big L in Crank
      betas<-btan.roots(L=L,n=e.d)                            # Set of betas in Crank (roots)
   
      # Calculate surface concentration and flux
      svals<-outer(X=t,Y=betas,FUN = function(t,betas) 2*L*cos(betas*l/l)*exp(-betas^2 * D*t/l^2) /((betas^2 + L^2 + L)*cos(betas)))
      tsum<-apply(svals,1,sum)
      wig.j<-max(apply(svals,1,FUN = function(x) abs(sum(x[-e.d]) - sum(x))/sum(x)))
      c.b.v.s<-c.b.v - c.b.v*(1-tsum)                         # Surface concentration at all times
      j.surf<-alpha*c.b.v.s                                   # Surface flux (g/m2-s)
   
      # Calculate cumulative emission
      svals<-outer(X=t,Y=betas,FUN = function(t,betas) 2*L^2*exp(-betas^2 * D*t/l^2) /(betas^2*(betas^2 + L^2 + L)))
      tsum<-apply(svals,1,sum)
      wig.e<-max(apply(svals,1,FUN = function(x) abs(sum(x[-e.d]) - sum(x))/sum(x)))
      emis<-c.b.v*l*(1 - tsum)                                # Cumulative emission (c.b.v*l = max cumulative emission) (g/m2)
      f.lost<-(1 - tsum)                                      # Relative cumulative emission

   # Return the output
   if (op=='f') return(list(ts=data.frame(t=t,j.surf=j.surf,emis=emis,f.lost=f.lost,c.b.v.s=c.b.v.s),
               parms=list(c.b.v=c.b.v,dm=dm,por.g=por.g,por.aq=por.aq,por.t=por.t,k.h=k.h,h.i=h.i,k.sg=k.sg,
               h.m=h.m,alpha=alpha,D=D,rho.h2o=rho.h2o,rho.d=rho.d,rho.w=rho.w,temp.c=temp.c,wig.j=wig.j,wig.e=wig.e)))
   if (op=='e') return(emis)
   if (op=='r') return(f.lost)
   if (op=='j.surf') return(j.surf)
   } else return(list(c.b.v=c.b.v,dm=dm,por.g=por.g,por.aq=por.aq,por.t=por.t,k.h=k.h,h.i=h.i,k.sg=k.sg,
            h.m=h.m,alpha=alpha,D=D,rho.h2o=rho.h2o,rho.d=rho.d,rho.w=rho.w,temp.c=temp.c))
}
