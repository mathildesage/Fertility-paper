
use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace

label var head_hh "Women is head of household"

label var DOT_1 "treatment period 1"
label var DOT_2 "treatment period 2"

**	Continuous outcome 

reg n_children_t  DOT_1 DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 , vce(cluster wedp_id) 
sum n_children_t  if treatment==0 
  local C_mean_1 = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep( DOT_1 DOT_2 number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean')  label replace

test _b[DOT_1 ] =_b[DOT_2 ]


