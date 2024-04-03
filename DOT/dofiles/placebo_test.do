
use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/Togo/data/TGO_2013_2016_FSCPIT_v01_M_Stata8/household_under_study.dta"

  
  reg Nbs_children_under_5_FU3 PI  Trad_training  Nbs_children_under_5_BL female_educ female_age age_square  women_hh_head   nbs_hh_members    hh_asset_index if female_age<50 & female_respondent==1 & married_or_couple==1, a(strata)
    sum Nbs_children_under_5_FU3  if female_age<50 & female_respondent==1 & married_or_couple==1
   local C_mean = r(mean)
  outreg2 _1 using Tab3.xls, excel dec(3) ctitle() keep(PI Trad_training  Nbs_children_under_5_BL  married_or_couple female_educ female_age age_square  women_hh_head nbs_hh_members     ) addstat(Control group mean, `C_mean') label replace 

  test PI =Trad_training
