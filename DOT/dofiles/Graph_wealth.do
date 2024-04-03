*********************************************************************************
******************************PLOT WEALTH AND FERTILITY *************************
*********************************************************************************


*Import
use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace

**We import hh asset index - which is a sum of dummies equal to one if the hh own the 
merge m:1 wedp_id using "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_MainIE_Fertility_07252019.dta", keepusing(HH_Asset_Index_bl)

drop if _merge ==2


*We plot the relation at baseline between fertility and wealth
set scheme rainbow		
preserve
collapse number_children_bl if time==0, by(HH_Asset_Index_bl)
scatter number_children_bl HH_Asset_Index_bl , connect(1) ytitle(Number of children at baseline) xtitle(Household asset index)
restore
	
***Percentage of women having at least one son by category of revenue 

preserve
collapse at_least_son if time==0, by(HH_Asset_Index_bl)
replace  at_least_son =  at_least_son*100
scatter at_least_son HH_Asset_Index_bl , connect(1) ytitle(% of women to have at least one son at baseline) 
restore
	
	