



. use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace


 gen at_least_son_DOT_1 = at_least_son*DOT_1
	 label var at_least_son_DOT_1 "Women have at least one son X DOT_1"
	 
	  gen at_least_son_DOT_2= at_least_son*DOT_2
	 label var at_least_son_DOT_2 "Women have at least one son X DOT_2"
	 
local at_least_s = "at_least_son at_least_son_DOT_1 at_least_son_DOT_2"



**If we split by being married at bl or not 

***heterogeneity by being married at baseline

reg n_children_t  DOT_1  DOT_2 `at_least_s' number_children_bl time  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50  & married_couple==1, vce(cluster wedp_id) 
    lincom  _b[at_least_son_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[ at_least_son_DOT_2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `at_least_s' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh)  addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_3' , p-value, `Pval_3' )   label replace

reg n_children_t  DOT_1  DOT_2 `at_least_s' number_children_bl time  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50  & married_couple==0, vce(cluster wedp_id) 
    lincom  _b[at_least_son_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[ at_least_son_DOT_2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `at_least_s' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction 3, `beta_3' , p-value, `Pval_3' )   label append



 local sib = "sibling_relative sibling_relative_DOT_1 sibling_relative_DOT_2"
 
 

  
	  gen sibling_relative= (bl_pi13==1 | bl_pi13==2)
	  replace sibling_relative=0 if have_children_bl==0
	  label var sibling_relative "Siblings can look after children"
	  
	  gen sibling_relative_DOT_1 = sibling_relative*DOT_1
	  label var sibling_relative_DOT_1 "Siblings can look after children X DOT_1"
	  
	  
	    gen sibling_relative_DOT_2= sibling_relative*DOT_2
	  label var sibling_relative_DOT_2 "Siblings can look after children X DOT_2"
	  
	  local sib = "sibling_relative sibling_relative_DOT_1 sibling_relative_DOT_2"
	  
	  

	
reg n_children_t  DOT_1  DOT_2 `sib' number_children_bl time  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50  & married_couple==1, vce(cluster wedp_id) 
    lincom  _b[sibling_relative_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[sibling_relative_DOT_2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `sib' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh)  addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_3' , p-value, `Pval_3' )   label replace

reg n_children_t  DOT_1  DOT_2 `sib' number_children_bl time  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50  & married_couple==0, vce(cluster wedp_id) 
    lincom  _b[sibling_relative_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[sibling_relative_DOT_2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `sib' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_3' , p-value, `Pval_3' )   label append



****We want to test heterogeneity depending on wealth at baseline - we expect a higher effect on poor women 


**We need to import variable form revenue at baseline. The only wealth index I have at baseline is "hh asset index" built just with a sum of dummy
**equal to one if the hh own a TV, a mobile phone, etc.

*We need to import it 

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

reg n_children_t  DOT_1  DOT_2 `asset_below' number_children_bl time  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id) 
    lincom  _b[asset_below_med_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[asset_below_med_DOT_2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `asset_below' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction 3, `beta_3' , p-value, `Pval_3' )   label replace



**Sample splitted
reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & asset_below_med==0, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==0
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset above the median") keep( DOT_1  DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean')    label replace

reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  plan_have_children no_children_bl if Age_bl<50 & asset_below_med==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset below the median") keep(  DOT_1 DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') label append

 reg n_children_t  DOT_1  DOT_2 time  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==0
 est store reg1
reg n_children_t  DOT_1  DOT_2  time number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2

	
	
		
******************************HOW WEALTH AND SON EFFECT INTERACT *************************
	

reg n_children_t  DOT_1  DOT_2  `at_least_s' time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & asset_below_med==0, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==0
    local C_mean = r(mean)
	  lincom  _b[at_least_son_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	    lincom  _b[at_least_son_DOT_2] 
	  local beta_2 =   string( r(estimate) ,"%10.3f")
	  local  Pval_2=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset above the median") keep( DOT_1  DOT_2 `at_least_s'  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label replace

  lincom  _b[DOT_1] + _b[at_least_son_DOT_1] 
			lincom  _b[DOT_2] + _b[at_least_son_DOT_2] 
			
		
	

reg n_children_t  DOT_1  DOT_2  `at_least_s' time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & asset_below_med==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==0
    local C_mean = r(mean)
	  lincom  _b[at_least_son_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	    lincom  _b[at_least_son_DOT_2] 
	  local beta_2 =   string( r(estimate) ,"%10.3f")
	  local  Pval_2=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset above the median") keep( DOT_1  DOT_2 `at_least_s'  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label replace

  lincom  _b[DOT_1] + _b[at_least_son_DOT_1] 
			lincom  _b[DOT_2] + _b[at_least_son_DOT_2] 


 reg n_children_t  DOT_1  DOT_2 time `at_least_s'  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==0
 est store reg1
reg n_children_t  DOT_1  DOT_2  time `at_least_s' number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]at_least_son_DOT_1 =[reg2_mean]at_least_son_DOT_1
			test [reg1_mean]at_least_son_DOT_2=[reg2_mean]at_least_son_DOT_2

			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2

			 lincom  _b[DOT_1] + _b[at_least_son_DOT_1] 
			lincom  _b[DOT_2] + _b[at_least_son_DOT_2] 
			
			
			
*******************************************Same table BUT with test of the equality of the coefficient between the 2 columns*********************************************
	
		replace education_level_bl=. if education_level_bl<0
	

reg n_children_t  DOT_1  DOT_2  `at_least_s' time number_children_bl  married_couple WEDP_loan i.education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  if Age_bl<50 & asset_below_med==0, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==0 & Age_bl<50
    local C_mean = r(mean)
	  lincom  _b[at_least_son_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	    lincom  _b[at_least_son_DOT_2] 
	  local beta_2 =   string( r(estimate) ,"%10.3f")
	  local  Pval_2=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset above the median") keep( DOT_1  DOT_2 `at_least_s'  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label replace
		

	

reg n_children_t  DOT_1  DOT_2  `at_least_s' time number_children_bl  married_couple WEDP_loan i.education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  if Age_bl<50 & asset_below_med==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==1 & Age_bl<50
    local C_mean = r(mean)
	  lincom  _b[at_least_son_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	    lincom  _b[at_least_son_DOT_2] 
	  local beta_2 =   string( r(estimate) ,"%10.3f")
	  local  Pval_2=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset below the median") keep( DOT_1  DOT_2 `at_least_s'  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label append

  lincom  _b[DOT_1] + _b[at_least_son_DOT_1] 
			lincom  _b[DOT_2] + _b[at_least_son_DOT_2] 

 reg n_children_t  DOT_1  DOT_2 time `at_least_s'  number_children_bl time married_couple  WEDP_loan i.education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 if Age_bl<50 & asset_below_med==0
 est store reg1
reg n_children_t  DOT_1  DOT_2  time `at_least_s' number_children_bl time married_couple  WEDP_loan i.education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  if Age_bl<50 & asset_below_med==1
 est store reg2

 
 suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2
			test [reg1_mean]at_least_son_DOT_1 =[reg2_mean]at_least_son_DOT_1
			test [reg1_mean]at_least_son_DOT_2=[reg2_mean]at_least_son_DOT_2

			


	

reg n_children_t  DOT_1  DOT_2  `asset_below' time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & at_least_son==1
    local C_mean = r(mean)
	  lincom  _b[ asset_below_med_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	    lincom  _b[ asset_below_med_DOT_1] 
	  local beta_2 =   string( r(estimate) ,"%10.3f")
	  local  Pval_2=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("At least one son ") keep( DOT_1  DOT_2 `asset_below' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label replace

  lincom  _b[DOT_1] + _b[ asset_below_med_DOT_1] 
			lincom  _b[DOT_2] + _b[ asset_below_med_DOT_1] 
			

reg n_children_t  DOT_1  DOT_2  `asset_below' time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==0, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & at_least_son==0
    local C_mean = r(mean)
	  lincom  _b[ asset_below_med_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	    lincom  _b[ asset_below_med_DOT_1] 
	  local beta_2 =   string( r(estimate) ,"%10.3f")
	  local  Pval_2=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("Not at least one son ") keep( DOT_1  DOT_2 `asset_below' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2, `beta_2' , p-value, `Pval_2' )   label append

  lincom  _b[DOT_1] + _b[ asset_below_med_DOT_1] 
			lincom  _b[DOT_2] + _b[ asset_below_med_DOT_1] 

 reg n_children_t  DOT_1  DOT_2 time `asset_below'  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & at_least_son==0
 est store reg1
reg n_children_t  DOT_1  DOT_2  time `asset_below' number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & at_least_son==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean] asset_below_med_DOT_1=[reg2_mean] asset_below_med_DOT_1
			test [reg1_mean] asset_below_med_DOT_2=[reg2_mean] asset_below_med_DOT_2

			 lincom  _b[DOT_1] + _b[at_least_son_DOT_1] 
			lincom  _b[DOT_2] + _b[at_least_son_DOT_2] 
			

	
******************************WEALTH AND FERTILITY *************************

*We plot the relation at baseline between fertility and wealth


 summarize number_children_bl if time==0
local m=string(`r(mean)',"%10.2f")
  summarize number_children_bl if Age_bl<50 & time==0, d
local med=string(`r(p50)',"%10.2f")
  
  
  
 graph bar  number_children_bl, over( HH_Asset_Index_bl) if time==0, graphregion(fcolor(white)) bfc(ltblue) blcolor(white) scheme(plotplain) note("mean=`m' median=`med'")||  kdensity number_children_bl if Age_bl<50 & time==0 
graph export  "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/Descriptives stat/Number of children at baseline/DOT.png", replace as (png)

	
		
preserve
 collapse number_children_bl if time==0, by(HH_Asset_Index_bl)
	scatter number_children_bl HH_Asset_Index_bl , connect(1) ytitle(Number of children at baseline)
	restore
	
***Percentage of women having at least one son by category of revenue 

	preserve
	
	collapse at_least_son if time==0, by(HH_Asset_Index_bl)
	replace  at_least_son =  at_least_son*100
	scatter at_least_son HH_Asset_Index_bl , connect(1) ytitle(% of women to have at least one son at baseline) 
	restore
	
	
	******************************effects depending on the bs of children distribution *************************
	*preserve
	*keep if time==1
	*set scheme s2color
	*graph bar if treatment==0 , over(n_children_t) ytitle(percent)    asyvar  cw  
	*restore


*contract n_children_t treatment if !missing( n_children_t, treatment)
*egen _percent = pc(_freq), by(treatment)

 *graph twoway (scatter _percent n_children_t   if treatment==0 ,connect(1) ytitle(percent) xtile(number of children at midline)) || (scatter _percent n_children_t   if treatment==1 ,connect(1) )
* graph save "Graph" "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/Graphs/twoway_children_midline.gph



 
 *preserve 
* keep if time==1 & Age_bl <50 
* gen less_children =(number_children_bl > n_children_t)
 *drop if less_children ==1
* collapse  n_children_t  if !missing( n_children_t, number_children_bl), by(number_children_bl treatment) 
* graph twoway (scatter   n_children_t number_children_bl  if treatment==0 ,connect(1) ) || (scatter   n_children_t  number_children_bl if treatment==1 ,connect(1) )

 
  preserve 
 keep if time==0 & Age_bl <50 
contract n_children_t  treatment if !missing( n_children_t, treatment)
egen _percent = pc(_freq), by(treatment)
label define treat 1 "Treatment group" 0 "Control group"
label values treatment treat
restore
 graph bar _percent  ,  over(treatment) over(n_children_t) ytitle(percent)   graphregion(color(white)) asyvar  cw  
  graph save "Graph" "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/Graphs/Graph_bar_children_by_treat.gph"


  preserve 
 keep if time==1 & Age_bl <50 
contract n_children_t  treatment if !missing( n_children_t, treatment)
egen _percent = pc(_freq), by(treatment)
label define treat 1 "Treatment group" 0 "Control group"
label values treatment treat
restore
*set scheme gg_hue

*set scheme white_w3d

*set scheme white_jet
*set scheme s2color
graph bar _percent  ,  over(treatment) over(n_children_t) ytitle(percent)   graphregion(color(white)) asyvar  cw  
graph save "Graph" "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/Graphs/Graph_bar_children_by_treat.gph"

  ***
  
 
  
  gen  n_children_t_0 =  (n_children_t==0) 
  replace n_children_t_0=. if time!=1 
   replace n_children_t_0=. if Age_bl>50
   replace n_children_t_0=. n_children_t==.
  
   ttest   n_children_t_0  , by(treatment)
   

  
  gen  n_children_t_1 =  (n_children_t==1) 
  replace n_children_t_1=. if time!=1 
   replace n_children_t_1=. if Age_bl>50
   replace n_children_t_1=. if n_children_t==.
  
   ttest   n_children_t_1  , by(treatment)
   
     gen  n_children_t_2 =  (n_children_t==2) 
  replace n_children_t_2=. if time!=1 
   replace n_children_t_2=. if Age_bl>50
   replace n_children_t_2=. if n_children_t==.
  
   ttest   n_children_t_2  , by(treatment)
   
   
   
        gen  n_children_t_3 =  (n_children_t==3) 
  replace n_children_t_3=. if time!=1 
   replace n_children_t_3=. if Age_bl>50
   replace n_children_t_3=. if n_children_t==.
   ttest   n_children_t_3  , by(treatment)
   
   
        gen  n_children_t_4 =  (n_children_t==4) 
  replace n_children_t_4=. if time!=1 
   replace n_children_t_4=. if Age_bl>50
   replace n_children_t_4=. if n_children_t==.
   ttest   n_children_t_4  , by(treatment)
   
       gen  n_children_t_5 =  (n_children_t==5) 
  replace n_children_t_5=. if time!=1 
   replace n_children_t_5=. if Age_bl>50
   replace n_children_t_5=. if n_children_t==.
   ttest   n_children_t_5  , by(treatment)
  
   
   

  
  gen  n_children_t_6 =  (n_children_t==6) 
  replace n_children_t_6=. if time!=1 
   replace n_children_t_6=. if Age_bl>50
   replace n_children_t_6=. if n_children_t==.
   ttest   n_children_t_6  , by(treatment)
  
  
  gen  n_children_t_7 =  (n_children_t==7) 
  replace n_children_t_7=. if time!=1 
   replace n_children_t_7=. if Age_bl>50
   replace n_children_t_7=. if n_children_t==.
   ttest   n_children_t_7  , by(treatment)
   
   ***************************************************************************************************************************************************************
   ********************************************************************Unconditional quantile regression**********************************************************
   ***************************************************************************************************************************************************************
   

reg n_children_t  DOT_1 DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if  Age_bl<50, vce(cluster wedp_id)  
outreg2 using Tab3.xls, replace excel dec(3) addtext(Quantile, mean, Cluster SE,Strate) keep( DOT_1  ) label

	foreach q in 10 20 30 40 50 60 70  80 90 {
	rifhdreg n_children_t  DOT_1 DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50, rif(q(`q')) vce(cluster wedp_id)
	outreg2 using Tab3.xls, append excel dec(3) addtext(Quantile, Q`q', Cluster SE,Strate) keep( DOT_1  )  label
	}
	
	
  

reg n_children_t  DOT_1 DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if  Age_bl<50, vce(cluster wedp_id)  
outreg2 using Tab3.xls, replace excel dec(3) addtext(Quantile, mean, Cluster SE,Strate) keep( DOT_1  ) label

		foreach q in  20 30 40 50 60 70  80 90 {
	rifhdreg n_children_t  DOT_1 DOT_2 time  number_children_bl married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50, rif(q(`q')) vce(cluster wedp_id)
	 lincom  _b[DOT_1] 
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	outreg2 using Tab3.xls, append excel dec(3) addtext(Quantile, Q`q', Cluster SE,Strate) keep( DOT_1  ) addstat(p-value, `Pval_1') label
	}
	
	
	

reg n_children_t  DOT_1 DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if  Age_bl<50, vce(cluster wedp_id)  
outreg2 using Tab3.xls, replace excel dec(3) addtext(Quantile, mean, Cluster SE,Strate) keep( DOT_2  ) label

		foreach q in  20 30 40 50 60 70  80 90 {
	rifhdreg n_children_t  DOT_1 DOT_2 time  number_children_bl married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50, rif(q(`q')) vce(cluster wedp_id)
	 lincom  _b[DOT_2] 
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	outreg2 using Tab3.xls, append excel dec(3) addtext(Quantile, Q`q', Cluster SE,Strate) keep( DOT_2  ) addstat(p-value, `Pval_1') label
	}


		***heterogeneity depending on women age =no heterogeneity 
	 
	sum Age_bl , det 
	local p_75 =  r(p75)
	
	

reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<`p_75' , vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & Age_bl<`p_75'
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset above the median") keep( DOT_1  DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean')    label replace

reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  plan_have_children no_children_bl if Age_bl>=`p_75' , vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & Age_bl >=`p_75'
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset below the median") keep(  DOT_1 DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') label append

 reg n_children_t  DOT_1  DOT_2 time  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<`p_75'
 est store reg1
reg n_children_t  DOT_1  DOT_2  time number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if  Age_bl >=`p_75'
 est store reg2 

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2


	
	
	
	
	
	
	
	
	
	*foreach q in 10 20 30 40 50 60 70  80 90 {
*	rifhdreg n_children_t  DOT_2  number_children_bl if time==1 & Age_bl<50, rif(q(`q')) vce(cluster wedp_id)
*	outreg2 using Tab3.xls, append excel dec(3) addtext(Quantile, Q`q', Cluster SE,Strate) label
*	}

*		foreach q in 10 20 30 40 50 60 70  80 90 {
*	rifhdreg n_children_t  DOT_2  number_children_bl married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if time==1 & Age_bl<50, rif(q(`q')) vce(cluster wedp_id)
*	outreg2 using Tab3.xls, append excel dec(3) addtext(Quantile, Q`q', Cluster SE,Strate) label
*	}

   
*	contract n_children_t  treatment if !missing( n_children_t, treatment)
*egen _percent = pc(_freq), by(treatment)
*	graph bar n_children_t , over(treatment)
	
	
*	gen children_time1_T = n_children_t if time==1 & treatment==1
	*replace children_time1_T=. if time==.
*	replace children_time1_T=. if treatment==.
	
	
*	gen children_time1_C = n_children_t if time==1 & treatment==0
*	replace children_time1_C=. if time==.
*	replace children_time1_C=. if treatment==.


*
*separate _percent, by(treatment)

*	gen children_time1_T = n_children_t if treatment==1
*gen children_time1_C = n_children_t if  treatment==0

	
*	twoway (bar  _percent1 children_time1_T , barw(0.4) color(red*1)) (bar _percent0 children_time1_C, barw(0.4) color(red*1.75)),  ytitle("Percent", size(small)) xtitle("Number of children at midline", size(small))  xlabel(, labsize(small))  ylabel(0(10)40, labsize(small))  xla(, tlc(none)) legend(order(1 2) label(1 "Control (C100)") label(2 "Treatment (T100)") col(2) position(6) size(small)) 
	
	
	
*	 xtic(13.5/35.5)
	 
	 
	* graph bar 
	
**If we build the varibale with inferior or equal to median 
sum HH_Asset_Index_bl if time==0, det
return list


gen asset_below_med_2 = (HH_Asset_Index_bl<=r(p50))
replace asset_below_med = . if HH_Asset_Index_bl==.

gen asset_below_med_2_DOT_1 = asset_below_med_2*DOT_1
label var  asset_below_med_2_DOT_1 "Assets below median X DOT_1"

gen asset_below_med_2_DOT_2 = asset_below_med_2*DOT_2
label var  asset_below_med_2_DOT_2 "Assets below median X DOT_2"

local asset_below_2 = "asset_below_med_2 asset_below_med_2_DOT_1 asset_below_med_2_DOT_2"


 reg n_children_t  DOT_1  DOT_2 `asset_below_2' number_children_bl time  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id) 
    lincom  _b[asset_below_med_2_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[asset_below_med_2_DOT_2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `asset_below_2' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addtext( Interaction term 1, `beta_1' , p-value, `Pval_1' , interaction 3, `beta_3' , p-value, `Pval_3' )   label replace






