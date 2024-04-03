 use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace

  replace education_level_bl=. if education_level_bl==-77
 
 ****HETEROGENEITY DEPENDING ON WEALTH - HOUSEHOLD ASSET INDEX - ALL INTERACTED*******
 
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

reg n_children_t  DOT_1  DOT_2 `asset_below' c.number_children_bl##i.asset_below_med i.married_couple##i.asset_below_med i.time##i.asset_below_med  i.WEDP_loan##i.asset_below_med i.education_level_bl##i.asset_below_med  c.Age_bl##c.Age_bl##i.asset_below_med    i.head_hh##i.asset_below_med c.bl_pi6##i.asset_below_med  plan_have_children##i.asset_below_med no_children_bl##i.asset_below_med if Age_bl<50, vce(cluster wedp_id) 
    lincom  _b[asset_below_med_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[asset_below_med_DOT_2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `asset_below' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addtext( Interaction term period 1, `beta_1' , p-value, `Pval_1' , interaction term period 2 , `beta_3' , p-value, `Pval_3' )   label replace



reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & asset_below_med==0, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==0
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset above the median") keep( DOT_1  DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean')    label replace

reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  plan_have_children no_children_bl if Age_bl<50 & asset_below_med==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset below the median") keep(  DOT_1 DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') label append

 reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==0
 est store reg1
reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2
			
			
			
 ****HETEROGENEITY DEPENDING ON DAYCARE - ALL INTERACTED*******
 
	
*	If we split the sample 
reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==1,  vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 & at_least_son==1
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("Free daycare") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean')  label replace


reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==0, vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 & at_least_son==1
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("No free daycare") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean') label append

reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==0
 est store reg1
reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2

regress n_children_t  DOT_1  DOT_2 `free_Daycare'  c.number_children_bl##i.free_daycare i.time##i.free_daycare i.married_couple##i.free_daycare i.WEDP_loan##i.free_daycare i.education_level_bl##i.free_daycare  c.Age_bl##c.Age_bl##i.free_daycare i.head_hh##i.free_daycare c.bl_pi6##i.free_daycare   if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
      lincom  _b[free_daycare_DOT1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[free_daycare_DOT2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("Number of children") keep(DOT_1  DOT_2  `free_Daycare'  number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean') addtext(interaction period 1,  `beta_1' , p-value, `Pval_1' , interaction period 2 , `beta_3' , p-value, `Pval_3' ) label replace



	
	
	
	
	
	
	 ****HETEROGENEITY DEPENDING ON SON - ALL INTERACTED*******
	 
	 
	 
local at_least_s = "at_least_son at_least_son_DOT_1 at_least_son_DOT_2"


**Sample splitted
reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple education_level_bl WEDP_loan   Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & at_least_son==0, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & at_least_son==0
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean')    label replace

reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple education_level_bl WEDP_loan  Age_bl Age_bl_square head_hh bl_pi6  plan_have_children no_children_bl if Age_bl<50 & at_least_son==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & at_least_son==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1 DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') label append

 reg n_children_t  DOT_1  DOT_2 time number_children_bl  married_couple education_level_bl WEDP_loan   Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & at_least_son==0
 est store reg1
reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple education_level_bl WEDP_loan   Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & at_least_son==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2


reg n_children_t  DOT_1  DOT_2 `at_least_s' i.time##i.at_least_son c.number_children_bl##i.at_least_son  i.married_couple##i.at_least_son i.WEDP_loan##i.at_least_son   c.Age_bl##c.Age_bl##i.at_least_son i.head_hh##i.at_least_son c.bl_pi6##i.at_least_son  no_children_bl##i.at_least_son i.education_level_bl##i.at_least_son  if Age_bl<50 , vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0
  local C_mean = r(mean)
 lincom  _b[at_least_son_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[ at_least_son_DOT_2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab5.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `at_least_s' number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean, `C_mean') addtext(interaction term 1, `beta_1' , p-value, `Pval_1' , interaction term 2 , `beta_3' , p-value, `Pval_3' )   label replace
			

			
			
***************TEST HET DAYCARE CONTROLLING FOR AT LEAST ONE SON********
			
			

			
			
	
regress n_children_t  DOT_1  DOT_2 `free_Daycare'  c.number_children_bl##i.free_daycare i.time##i.free_daycare i.married_couple##i.free_daycare i.WEDP_loan##i.free_daycare i.education_level_bl##i.free_daycare  c.Age_bl##c.Age_bl##i.free_daycare i.head_hh##i.free_daycare c.bl_pi6##i.free_daycare i.at_least_son##i.free_daycare  if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
      lincom  _b[free_daycare_DOT1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom  _b[free_daycare_DOT2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
outreg2  using Tab3.xls, excel dec(3) ctitle("Number of children") keep(DOT_1  DOT_2  `free_Daycare'  number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean') addtext(interaction period 1,  `beta_1' , p-value, `Pval_1' , interaction period 2 , `beta_3' , p-value, `Pval_3' ) label replace
		
			
			
			
	/*			
****We test heterogeneity depending on women working with children around 	
	
		If we split the sample 
reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & children_at_work==1,  vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 & children_at_work==1
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("Children around at work") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean')  label replace


reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & children_at_work==0, vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 & children_at_work==0
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("Not children around at work") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean') label append

reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & children_at_work==0
 est store reg1
reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & children_at_work==1
 est store reg2


	suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2

	
reg n_children_sd_1  DOT_1  DOT_2 `children_around_work'  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_sd_1 if treatment==0
  local C_mean = r(mean)
    lincom _b[DOT_1 ] 
	  local beta =   string( r(estimate) ,"%10.3f")
	  local  Pval=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom _b[DOT_1 ] + _b[mv_children_at_work_DOT_1] 
	  local beta_1 =   string( r(estimate) ,"%10.3f")
	  local  Pval_1=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
	        lincom _b[DOT_2 ] 
	  local beta_2 =   string( r(estimate) ,"%10.3f")
	  local  Pval_2=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 
    lincom _b[DOT_2 ] + _b[mv_children_at_work_DOT_2] 
	  local beta_3 =   string( r(estimate) ,"%10.3f")
	  local  Pval_3=  string(2 * (1-normal(abs(r(estimate) / r(se)))) ,"%10.3f" ) 

    
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 `children_around_work'  number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean') addtext(treatment , `beta' , p-value , `Pval' , treatment x older siblings , `beta_1' , p-value, `Pval_1' , treatment period 2 , `beta_2' , p-value , `Pval_2' , treatment period 2 x No daycare proxy , `beta_3' , p-value, `Pval_3' )  label replace



	
	
