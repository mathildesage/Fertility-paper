

. use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace


 gen at_least_son_DOT_1 = at_least_son*DOT_1
	 label var at_least_son_DOT_1 "Women have at least one son X DOT_1"
	 
	  gen at_least_son_DOT_2= at_least_son*DOT_2
	 label var at_least_son_DOT_2 "Women have at least one son X DOT_2"
	 
local at_least_s = "at_least_son at_least_son_DOT_1 at_least_son_DOT_2"




merge m:1 wedp_id using "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_MainIE_Fertility_07252019.dta", keepusing(HH_Asset_Index_bl)

drop if _merge ==2

**We compute the median 
sum HH_Asset_Index_bl if time==0, det
return list

gen asset_below_med = (HH_Asset_Index_bl<r(p50))
replace asset_below_med = . if HH_Asset_Index_bl==.

gen asset_below_med_DOT_1 = asset_below_med*DOT_1
label var  asset_below_med_DOT_1 "Assets below median X DOT_1"

gen asset_below_med_DOT_2 = asset_below_med*DOT_2
label var  asset_below_med_DOT_2 "Assets below median X DOT_2"

local asset_below = "asset_below_med asset_below_med_DOT_1 asset_below_med_DOT_2"




gen free_daycare = (bl_pi13 ==1 | bl_pi13 ==2 | bl_pi13 ==4)
replace free_daycare = . if bl_pi13==.





reg n_children_t  DOT_1  DOT_2  `at_least_s' time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==0, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & free_daycare==0
    local C_mean = r(mean)
	  lincom  _b[at_least_son_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	    lincom  _b[at_least_son_DOT_2] 
	  local beta_2 =   string( r(estimate) ,"%10.3f")
	  local  Pval_2=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("No free daycare") keep( DOT_1  DOT_2 `at_least_s'  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label replace

  lincom  _b[DOT_1] + _b[at_least_son_DOT_1] 
			lincom  _b[DOT_2] + _b[at_least_son_DOT_2] 
			
		
	

reg n_children_t  DOT_1  DOT_2  `at_least_s' time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & free_daycare==1
    local C_mean = r(mean)
	  lincom  _b[at_least_son_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	    lincom  _b[at_least_son_DOT_2] 
	  local beta_2 =   string( r(estimate) ,"%10.3f")
	  local  Pval_2=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("Free daycare") keep( DOT_1  DOT_2 `at_least_s'  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label append

  lincom  _b[DOT_1] + _b[at_least_son_DOT_1] 
			lincom  _b[DOT_2] + _b[at_least_son_DOT_2] 


 reg n_children_t  DOT_1  DOT_2 time `at_least_s'  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & free_daycare==0
 est store reg1
reg n_children_t  DOT_1  DOT_2  time `at_least_s' number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & free_daycare==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]at_least_son_DOT_1 =[reg2_mean]at_least_son_DOT_1
			test [reg1_mean]at_least_son_DOT_2=[reg2_mean]at_least_son_DOT_2

			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2

			 lincom  _b[DOT_1] + _b[at_least_son_DOT_1] 
			lincom  _b[DOT_2] + _b[at_least_son_DOT_2] 
			
			
			
			***Do women who have no son react to low cost of children ? 
			
gen free_daycare_DOT1 = free_daycare*DOT_1
label var free_daycare_DOT1 "free daycare X DOT_1"

gen free_daycare_DOT2 = free_daycare*DOT_2
label var free_daycare_DOT2 "free daycare X DOT_2"

local free_Daycare = " free_daycare free_daycare_DOT1 free_daycare_DOT2"



reg n_children_t  DOT_1  DOT_2  `free_Daycare' time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==0, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & at_least_son==0
    local C_mean = r(mean)
	
outreg2  using Tab3.xls, excel dec(3) ctitle("No son") keep( DOT_1  DOT_2 `free_Daycare'  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label replace

  lincom  _b[DOT_1] + _b[free_daycare_DOT1] 
			lincom  _b[DOT_2] + _b[free_daycare_DOT2] 
			
		
	

reg n_children_t  DOT_1  DOT_2  `free_Daycare' time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & at_least_son==1
    local C_mean = r(mean)
	 outreg2  using Tab3.xls, excel dec(3) ctitle("At least one son") keep( DOT_1  DOT_2 `free_Daycare'  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label append

  lincom  _b[DOT_1] + _b[free_daycare_DOT1] 
			lincom  _b[DOT_2] + _b[free_daycare_DOT2] 


 reg n_children_t  DOT_1  DOT_2 time `free_Daycare'  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & at_least_son==0
 est store reg1
reg n_children_t  DOT_1  DOT_2  time `free_Daycare' number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & at_least_son==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)

			test [reg1_mean]free_daycare_DOT1 =[reg2_mean]free_daycare_DOT1
			test [reg1_mean]free_daycare_DOT2=[reg2_mean]free_daycare_DOT2

			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2

			
