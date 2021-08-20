# Calculation of VOC emission factors for silage feeding to cattle

# 1. Overview
These files are for calculation of emission factors (EFs) for volatilization of volatile organic compounds (VOC) from silage (fermented animal feed) fed to dairy and beef cattle in the United States.
The EFs were developed for use in the 2020 National Emissions Inventory (NEI). 
This document describes the contents of the repository and explains how the EFs are calculated.

# 2. General approach for calculation of emission factors
The emission factors (EFs) proposed here, expressed in units of kg VOC per animal per year, are the product of three estimated quantities:
1. VOC production within silage
2. Fractional loss of VOC by volatilization
3. Silage feeding rates to cattle

Written as an equation:
EF (kg VOC / animal - year) = 
  production (kg VOC produced [or available] / kg silage DM) * 
  loss (kg VOC volatilized / kg VOC produced) *
  feeding rate (kg silage DM fed / animal - year)

where DM = dry matter.
Emission factors are calculated for three stages: silage storage, feed mixing, and feeding.
Estimates are made for beef and dairy cattle, which are assumed to differ only in silage feeding rates (3).
In total, 6 EFs are calculated for the entire US, and are meant to capture average conditions.
This approach does not capture differences due to local climate or management.

Silage VOC production is based on the extensive compilation of VOC measurements presented in a review paper (Hafner et al., 2013).
Fractional loss of VOC (2) is calculated by chemical group using the mass transfer model described by Hafner et al. (2012).
The inputs for the mass transfer model are average values that are assumed to be constant for dairy and beef cattle for all US locations.
VOC "speciation", the separation of calculated total VOC emission into specific organic compounds for use as inputs in air quality (atmospheric reaction-transport) models, is determined as the product of VOC production (1) and the total fraction VOC loss for all three stages (2).

For more details on calculations, see Section 4.

# 3. Software used
All calculations are carried out using the R software environment, which can be downloaded for free (https://www.r-project.org/).
All input data, calculation scripts, and functions are included in this repository.
Therefore the results given here are reproducible, and can be re-calculated by running the script `run_all.R`.
Required add-on R packages are listed in the `scripts/packages.R` files.
They are all publicly available from CRAN (https://cran.r-project.org/), the R software archive.
Output files are comma-spearated text files, and can be opened with any text editor or spreadsheet program.
Some files combine text, code, and output in a pdf format, and these can be opened with one of several free pdf viewers.
Literature data on VOC production in silage are stored in a Microsoft Excel file, which can be opened with Excel, LibreOffice Calc, or other spreadsheet programs.

# 4. Files and calculation details
Files are organized into 3 subdirectories.

## 4.1. `01_functions`
This subdirectory contains scripts that define functions used in the calculations.
The file `FACOnvDiffMod_v8.R` defines the model from Hafner et al. (2012).

## 4.3. `02_production`
These files are for determination of VOC production in silage, based on silage VOC concentrations reported in published papers. 
The data used here are based on Hafner et al. (2013), supplemented with measurements from haylage (grass silage) and legume silage.
These literature data can be found in `data/Silage_VOC.xlsx`.
Weighted mean concentrations (by numer of silages in each study) are calculated by crop type, following the approach described in Hafner et al. (2013, Section 2).
These calculations are carried out by running `scripts/main.R`.
The output of the calculations is stored in the `output` directory.
The file `compound_concs.csv` has the weighted mean (by number of silages in each study) concentration in the column `conc.mean` in mg VOC per kg silage DM.

## 4.4. `03_inputs`
Inputs for calculations are set in `scripts/inputs.R`.
These include silage production, cattle populations, silage properties, temperature, and mass transfer model parameters. 
Some of these values are calculated in the script, and the file `log/log.txt` provides a record of all values.

## 4.5. `04_frac_loss_calcs`
Here the mass transfer model from Hafner et al. (2012) is used to predict fractional loss of VOC (kg VOC lost per kg VOC produced or available) from silage storage and feeding.
This model includes parameters for transport through silage and loss from an exposed surface, with parameter values based on wind tunnel (Montes et al., 2010; Hafner et al., 2010) and mass balance emission measurements made using silage representative of storage or feeding conditions (Hafner et al., 2012).
Model parameters are set in `03_inputs`.
Calculations are carried out for four chemical groups of compounds: acids, alcohols, esters, and aldehydes, which cover nearly all groups of VOC found in silage, according to the 2013 review (Hafner et al., 2013).
Ketones is the only other chemical group that contributes significantly to VOC emissions from silage. 
Ketones are excluded from the calculations here because their contribution to the overall silage VOC emission is not significant, an estimation made based on only two studies with silage ketones data (Hafner et al., 2013).

In each chemical group, a "representive" compound is used.
These representative compounds were selected because they tend to dominate production and emission of their group, and their volatility is representative of other compounds in the group as well.
The temperature used for mass transfer model was the average for the contiguous US for 1991-2020, which is 11.8 degrees C.
Calculated fractional losses (kg VOC volatilized per kg VOC produced or available) are given in `output/frac_loss.csv`.

## 4.6. `05_EF_calcs`
EFs are calculated here based on the fractional VOC losses described in Section 4.5 (by group), silage feeding rates calculated in `03_inputs/scripts/inputs.R`, and the production (concentration) data from `02_production` as described in Section 4.3.
Silage production-based weighting was based on National Agricultural Statistics Service (NASS) results which show that corn silage makes up about 75% of the total, grass 15%, and legume silage 10%.

Resulting EFs and related results are given in the file `output/EFs.csv`, including:
* `emis.sil`: total VOC emission on a silage mass basis (mg VOC per kg silage DM = Gg VOC per Tg silage DM)
* `EF.animal`: the EF on an animal basis (kg VOC per animal per year)

More detailed emission estimates for individual compounds on a silage mass basis, including speciation estimates, are given in `emis.csv`, including:
* `conc.wm`: production-weighted mean VOC concentration in silage (combined for corn, grass, and legume silage) (mg VOC per kg silage DM)
* `floss.total`: fractional VOC loss for all stages (kg VOC per kg VOC produced or available)
* `emis.total`: VOC loss for all stages (mg VOC per kg silage DM)
* `spec.pt`: speciation estimates as a percentage of total VOC emission (% VOC mass)

And the file `emis_tot.csv` has national emissions estimates by animal type and in total:
* `emis`: VOC emissions (kg VOC / yr)

# 5. Silage feeding rates
Emission factors are fundamentally linked to silage production (see Section 2) but for EFs per-animal values are required.
To ensure consistency between the two approaches, effective silage feeding rates are based on national silage production and the same cattle population statistics used for inventory calculations.
These feeding rates are effective average rates, and apart from dairy and beef, there is no distinction between animal types.
All silage produced in the US is assumed to be fed to dairy or beef cattle.
Rates were estimated from NASS statistics for total silage production and estimated cattle populations from Abt for 2017.
Total national silage production was for corn, haylage, alfalfa, and sorghum silage production, and is reported in tons.
Reported mass was assumed to be in fresh mass, and dry mass was calculated by assuming a dry matter (DM) content of 34%.
Total silage production for 2017 was 50 Tg DM per year.
Based on the Integrated Farm System Model (IFSM) simulation results described in recent national assessments of dairy and beef cattle (Rotz et al., 2019, 2021), we assumed that dairy cattle consume 75% of US silage and beef 25% (C. Al Rotz, USDA-ARS, personal communication).
Based on this approach, effective average silage feeding rates were about 2025 kg DM per yr for dairy cows and 155 kg DM per yr for beef cows (5.5 and 0.4 kg DM per d, respectively).

# References
Hafner, S.D., Montes, F., Rotz, C.A., 2012. A mass transfer model for VOC emission from silage. Atmospheric Environment 54, 134–140. https://doi.org/10.1016/j.atmosenv.2012.03.005

Hafner, S.D., Howard, C., Muck, R.E., Franco, R.B., Montes, F., Green, P.G., Mitloehner, F., Trabue, S.L., Rotz, C.A., 2013. Emission of volatile organic compounds from silage: Compounds, sources, and implications. Atmospheric Environment 77, 827–839. https://doi.org/10.1016/j.atmosenv.2013.04.076

Hafner, S.D., Montes, F., Rotz, C.A., Mitloehner, F.M., 2010. Ethanol emission from loose corn silage and exposed silage particles. Atmospheric Environment 44, 4172–4180. https://doi.org/10.1016/j.atmosenv.2010.07.029

Hibma, J., 2011. Saving face: Silage pile management [WWW Document]. Progressive Dairy. URL https://www.progressivedairy.com/topics/feed-nutrition/saving-face-silage-pile-management (accessed 8.20.21).

Montes, F., Hafner, S.D., Rotz, C.A., Mitloehner, F.M., 2010. Temperature and air velocity effects on ethanol emission from corn silage with the characteristics of an exposed silo face. Atmospheric Environment 44, 1987–1995. https://doi.org/10.1016/j.atmosenv.2010.02.037

Muck, R.E., Holmes, B.J., 2000. Factors Affecting Bunker Silo Densities. Applied Engineering in Agriculture 16, 613–620.

NASS. 2021. Pre-Defined Queries. URL: `https://www.nass.usda.gov/Data_and_Statistics/Pre-Defined_Queries/index.php` Entries used: "Beef Cow Inventory - All States", "Milk Cow Inventory - All States". (accessed 19 August 2021).

NASS. 2021. Quick Stats. URL: `https://quickstats.nass.usda.gov/`. Selections: "SURVEY, CROPS, FIELD CROPS, CORN, PRODUCTION, CORN, SILAGE - PRODUCTION, MEASURED IN TONS","SURVEY, CROPS, FIELD CROPS, HAYLAGE, PRODUCTION, HAYLAGE, (EXCL ALFALFA)", "SURVEY, CROPS, FIELD CROPS, HAYLAGE, PRODUCTION, HAYLAGE, ALFALFA - PRODUCTION, MEASURED IN TONS", "SURVEY, CROPS, FIELD CROPS, SORGHUM, PRODUCTION, SORGHUM, SILAGE - PRODUCTION, MEASURED IN TONS". (accessed 19 August 2021).

NOAA. 2021. Climate at a Glance. URL https://www.ncdc.noaa.gov/cag/national/mapping (page) https://www.ncdc.noaa.gov/cag/national/mapping/110-tavg.csv (data file) (accessed 18 August 2021)

Rotz, A., Stout, R., Leytem, A., Feyereisen, G., Waldrip, H., Thoma, G., Holly, M., Bjorneberg, D., Baker, J., Vadas, P., Kleinman, P., 2021. Environmental assessment of United States dairy farms. Journal of Cleaner Production 315, 128153. https://doi.org/10.1016/j.jclepro.2021.128153

Rotz, C.A., Asem-Hiablie, S., Place, S., Thoma, G., 2019. Environmental footprints of beef cattle production in the United States. Agricultural Systems 169, 1–13. https://doi.org/10.1016/j.agsy.2018.11.005

Sander, R., 2017. Henry’s Law Constants, in: Linstrom, P.G., Mallard, W.G. (Eds.), NIST Chemistry WebBook, NIST Standard Reference Database Number 69. National Institute of Standards and Technology, Gaithersburg, MD. URL https://webbook.nist.gov/cgi/cbook.cgi?ID=C64197&Units=SI&Mask=10#Solubility (acetic acid) https://webbook.nist.gov/cgi/cbook.cgi?ID=C109604&Units=SI&Mask=10#Solubility (propyl acetate) 

Saxe, C., 2007. Managing Forage in Bunker Silos. Focus on Forage 3(6). URL https://fyi.extension.wisc.edu/forage/managing-forage-in-bunker-silos/ (accessed 20 August 2021)
