# Calculation of United States emission factors for silage feeding to dairy and beef cattle

# Overview
These files are for calculation of emission factors (EFs) for volatilization of volatile organic compounds (VOC) from silage (fermented animal feed) fed to dairy and beef cattle in the United States for use in the 2020 National Emissions Inventory (NEI). 

# General approach for calculation of emission factors
Emission factors (EFs) calculated here have the units kg VOC per head per year, and are the product of three estimates:
1. VOC production within silage
2. Fractional loss of VOC by volatilization
3. Silage feeding rates to cattle

Emission factors are calculated separately for three stages: silage storage, feed mixing, and feeding.
Estimates are made separately for beef and dairy cattle, which are assumed to differ only in silage feeding rates (3).
In total, 6 EFs are calculated for the entire US, and are meant to capture average conditions.

VOC production is based on average VOC measurements presented in a review paper (Hafner et al., 2013).
Fractional loss of VOC (2) is calculated by VOC group using a mass transfer model (Hafner et al., 2012) with average inputs, and these values are assumed to be constant for dairy and beef cattle and for all US locations.
VOC "speciation", or the separation of calculated total VOC emission into specific organic compounds for use in air quality models, is determined as the product of VOC production (1) and the total fraction VOC loss for all three stages (2).

# Software used
All calculations were carried out using R, which can be downloaded for free (https://www.r-project.org/).
All input data, calculation scripts, and custom functions are included, so the results given here are completely repeatable by running the script `run_all.R`.
Required add-on R packages are listed in the `scripts/packages.R` files.
They are all publicly available from CRAN (https://cran.r-project.org/).
Inputs for calculation of EFs are entered into spreadsheet that can be opened and edited using Microsoft Excel or the open-source program LibreOffice Calc.

# Files and calculation details
Files are organized into 3 subdirectories.
These are described below.

## `01_production`
These files are for determination of VOC production in silage, based on silage VOC concentrations reported in published papers. 
The data used here are explained in Hafner et al. (2013).
Here weighted mean concentrations are calculated by crop type.
Calculations can be carried out by running `scripts/main.R`.
Output is in `output`.

## `02_frac_loss`
Here the mass transfer model from Hafner et al. (2012) is used to predict fractional loss of VOC from silage storage and feeding.
Calculations are carried out for four groups of compounds: acids, alcohols, esters, and aldehydes.
For each group, a "representive" compound is used.
These compounds were selected because they tend to dominate production and emission of their group, but volatility is generally similar to other compounds in the group as well.
All R code is in a single R Markdown file in the `Rmd` directory, which can be compiled into a pdf with model results in `output` by running `main.R`.
Calculated output are not used directly for EF calculations.
Instead values are entered manually in the `03_EF_calcs/inputs` directory.
This is done to allow for some expert opinion in interpretation of values, along with estimation of mixing losses, which were simply taken as 10% of feeding losses.
(**NTS: Check and explain any differences! Consider using model predictions directly with mixing as 10% of feed losses.**)

## `03_EF_calcs`
EFs are calculated here based on the fractional VOC losses (by group) and silage consumption rates in the file `03_EF_calcs/inputs/EF_inputs.xlsx` and the production (concentration) data from `01_production`.

Resulting EFs and related results are given in `03_EF_calcs/output/EFs.csv`, including:
* `emis.sil`: total VOC emission on a silage mass basis in mg VOC per kg silage dry matter (DM) (= Gg VOC per Tg silage DM)
* `EF.animal`: the EF on an animal basis in kg VOC per animal per year

More detailed emission estimates on a silage mass basis, including speciation estimates, are given in `emis.csv`, including:
* `conc.wm`: production-weighted mean VOC concentration in silage (combined for corn, grass, and legume silage)
* `floss.tot`: fractional VOC loss for all stages
* `emis.total`: absolute VOC loss for all stages (mg VOC per kg silage DM)
* `spec.pt`: speciation estimates as a percentage of total VOC emission (%)

# Details on silage consumption rates
In these calculations, dairy and beef cattle differ only in the rates of silage consumption (feeding).
These values were estimated from NASS statistics for total silage production and dairy and beef cow populations.
Total national silage production was for corn, haylage, alfalfa, and sorghum silage production, which is reported in tons, and was assumed to be in fresh mass units at 35% dry matter (DM).
Cattle populations are available as the number of dairy or beef cows, excluding bulls, steers, heifers, and calves. 
Although these other animal groups consume silage, cow numbers are used for calculation of emissions in the NEI, and so these EFs should be based on them.
(**NTS: Abt/EPA needs to confirm this!**)
Furthermore, we assumed that dairy cattle consume 75% of US silage and beef 25% (C. Al Rotz, USDA-ARS, personal communication).
(**NTS: Link this to Al's 2 papers!**)
Based on this approach, silage feeding rates were about 10 kg DM per d for dairy cows and 0.9 kg DM per d for beef cows.

# References
Hafner, S.D., Montes, F., Rotz, C.A., 2012. A mass transfer model for VOC emission from silage. Atmospheric Environment 54, 134–140. https://doi.org/10.1016/j.atmosenv.2012.03.005

Hafner, S.D., Howard, C., Muck, R.E., Franco, R.B., Montes, F., Green, P.G., Mitloehner, F., Trabue, S.L., Rotz, C.A., 2013. Emission of volatile organic compounds from silage: Compounds, sources, and implications. Atmospheric Environment 77, 827–839. https://doi.org/10.1016/j.atmosenv.2013.04.076
