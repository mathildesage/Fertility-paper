


local "DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl WEDP_loan educ_sec"




**ATE - Continuous outcome

reg   n_children_t DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) addstat(Control group mean, `C_mean')  label replace


reg   n_children_t DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean')  label append

reg   n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children  no_children_bl ) addstat(Control group mean, `C_mean')  label append

reg   n_children_t DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl  if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  no_children_bl  ) addstat(Control group mean, `C_mean')  label append

reg   n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean')  label append

**ATE - dummy outcome -LPM


reg child_post_d  DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
 sum child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) label replace


reg  child_post_d  DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean')  label append

reg  child_post_d  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean')  label append

reg  child_post_d  DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl  if Age_bl<50 , vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl   ) addstat(Control group mean, `C_mean')  label append

reg  child_post_d  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean')  label append


**Size effect version 

sum n_children_t if  treatment==0
gen n_children_sd = (n_children_t - r(mean))/r(sd)

**NB : 



reg n_children_sd DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
 sum n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) label replace


reg  n_children_sd DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean')  label append

reg  n_children_sd DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean')  label append

reg  n_children_sd DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl  if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl   ) addstat(Control group mean, `C_mean')  label append

reg  n_children_sd  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl  if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean')  label append




******************************************************Heterogeneity depending on daycare *********************************************************************************************


*bl_pi13 here we have who mainly look after your children. 

gen children_at_work = (bl_pi13==8)
replace children_at_work =. if bl_pi13==.
label var children_at_work "Women children stay with women at business"

**On a énormément de missing (300) pour la question "who take care of your children when u are at work). So we try to impute missing by mean and to control imputation in the reg (with the variable "have no children)



foreach var of varlist children_at_work  {
	gen mv_`var' = `var' 
	gen Missing_`var' = (missing(`var'))
	quiet: sum `var'
	replace mv_`var' = r(mean) if Missing_`var' == 1
	}


label var mv_children_at_work "Women children stay with women at business"

gen mv_children_at_work_DOT_1 =mv_children_at_work*DOT_1   
label var mv_children_at_work_DOT_1  "Women children stay with women at business X DOT_1"

gen mv_children_at_work_DOT_2 =mv_children_at_work*DOT_2
label var mv_children_at_work_DOT_2 "Women children stay with women at business X DOT_1"

**With this variable, I do not assign missing to women who do not have children, because I don't want to restrict the sample from 1500 obs to 1200
*and lose the randomization


**Issue : what to do with the missing (pb with command gen)

**We control for mean imputation with no_children_bl (parce que ce sont les femmes sans enfant qui n'ont pas rep)

reg   n_children_t DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 have_no_child_bl  if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2) addstat(Control group mean, `C_mean')  label replace


reg   n_children_t DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean')  label append

reg   n_children_t DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean')  label append

reg   n_children_t DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean')  label append

reg   n_children_t DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children  have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean')  label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[mv_children_at_work_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[mv_children_at_work_DOT_2]


**********************Outcome dummy 
  
*********************Linear probability model 

reg   child_post_d DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 have_no_child_bl  if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2) addstat(Control group mean, `C_mean')  label replace


reg   child_post_d DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean')  label append

reg   child_post_d DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean')  label append

reg   child_post_d  DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean')  label append

reg   child_post_d DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children  have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean')  label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[mv_children_at_work_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[mv_children_at_work_DOT_2]
	  
	  
	  ************Outcome SD
	  
	  
reg   n_children_sd DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 have_no_child_bl  if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2) addstat(Control group mean, `C_mean')  label replace


reg   n_children_sd DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean')  label append

reg   n_children_sd DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean')  label append

reg   n_children_sd DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean')  label append

reg   n_children_sd DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children  have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 mv_children_at_work mv_children_at_work_DOT_1 mv_children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean')  label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[mv_children_at_work_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[mv_children_at_work_DOT_2]
	  
	  
****************************************************************************************************************************************************************************************************
*****************************************************************At least one son *************************************************************************************************************************
****************************************************************************************************************************************************************************************************

local at_least_s = "at_least_son at_least_son_DOT_1 at_least_son_DOT_2"




****OLS 
	 
reg  n_children_t  DOT_1  DOT_2  `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg   n_children_t DOT_1  DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2    `at_least_s'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]









*********************Linear probability model 

	 
reg   child_post_d DOT_1  DOT_2  `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg   child_post_d DOT_1  DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   child_post_d DOT_1  DOT_2  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   child_post_d DOT_1  DOT_2    `at_least_s'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl  ) addstat(Control group mean, `C_mean') label append

reg   child_post_d DOT_1  DOT_2  `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]
	  

*******outcome standardized


reg   n_children_sd DOT_1  DOT_2  `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg    n_children_sd DOT_1  DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg    n_children_sd DOT_1  DOT_2  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg    n_children_sd DOT_1  DOT_2    `at_least_s'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean') label append

reg    n_children_sd DOT_1  DOT_2  `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]
	  
	  
	  

	  
	  
****************************************************************************************************************************************************************************************************
*****************************************************************At least one daughter *************************************************************************************************************************
****************************************************************************************************************************************************************************************************

	 local at_least_d = "at_least_daughter at_least_daughter_DOT_1 at_least_daughter_DOT_2"




****OLS 
	 
reg  n_children_t  DOT_1  DOT_2  `at_least_d' if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_d' ) addstat(Control group mean, `C_mean') label replace


reg   n_children_t DOT_1  DOT_2  `at_least_d'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_d'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `at_least_d' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2    `at_least_d'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d'    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `at_least_d'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_d'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


 

  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]
	  








*********************Linear probability model 

	 
reg   child_post_d DOT_1  DOT_2  `at_least_d' if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_d' ) addstat(Control group mean, `C_mean') label replace


reg   child_post_d DOT_1  DOT_2  `at_least_d'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_d'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   child_post_d DOT_1  DOT_2  `at_least_d' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   child_post_d DOT_1  DOT_2    `at_least_d'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d'    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl  ) addstat(Control group mean, `C_mean') label append

reg   child_post_d DOT_1  DOT_2  `at_least_d'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_d'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]

*******outcome standardized


reg   n_children_sd DOT_1  DOT_2  `at_least_d' if Age_bl<50, vce(cluster wedp_id)
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_d' ) addstat(Control group mean, `C_mean') label replace


reg    n_children_sd DOT_1  DOT_2  `at_least_d'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_d'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg    n_children_sd DOT_1  DOT_2  `at_least_d' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg    n_children_sd DOT_1  DOT_2    `at_least_d'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d'    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean') label append

reg    n_children_sd DOT_1  DOT_2  `at_least_d'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_d'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append




  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]
	  

	  
	  
	  	  
	  
****************************************************************************************************************************************************************************************************
*****************************************************************At least one daughter and/or at least one son*************************************************************************************************************************
****************************************************************************************************************************************************************************************************

	  


****OLS 
	 
reg  n_children_t  DOT_1  DOT_2  `at_least_d' `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_d' `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg   n_children_t DOT_1  DOT_2  `at_least_d' `at_least_s' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_d' `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `at_least_d' `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d'  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2    `at_least_d' `at_least_s' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d' `at_least_s'   number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `at_least_d'  `at_least_s' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_d' `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


 

  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]
	  








*********************Linear probability model 

	 
reg   child_post_d DOT_1  DOT_2  `at_least_d' `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_d' `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg   child_post_d DOT_1  DOT_2  `at_least_d' `at_least_s' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_d' `at_least_s' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   child_post_d DOT_1  DOT_2  `at_least_d' `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d' `at_least_s'  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   child_post_d DOT_1  DOT_2    `at_least_d'  `at_least_s' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d'  `at_least_s'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl  ) addstat(Control group mean, `C_mean') label append

reg   child_post_d DOT_1  DOT_2  `at_least_d' `at_least_s' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_d' `at_least_s' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]

*******outcome standardized


reg   n_children_sd DOT_1  DOT_2  `at_least_d' `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_d' `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg    n_children_sd DOT_1  DOT_2  `at_least_d' `at_least_s' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_d' `at_least_s' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg    n_children_sd DOT_1  DOT_2  `at_least_d' `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d' `at_least_s'  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg    n_children_sd DOT_1  DOT_2    `at_least_d' `at_least_s' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_d' `at_least_s'   number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean') label append

reg    n_children_sd DOT_1  DOT_2  `at_least_d'  `at_least_s' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum   n_children_sd if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_d' `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append




  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]
	  

	  

  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]
	  
********************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************
*******************************************We try the reg with the delta ****************************************************************************************************************
************************************************************************************************************************************************************************************



**in this outcome, the outliers are replace as missing but we kept negative values 

reg  dif  DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
  sum  dif if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) addstat(Control group mean, `C_mean') label replace


reg   dif DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum  dif if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg  dif  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum dif  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg dif  DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean') label append

reg dif   DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id)
  sum  dif if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append





************dif_zero

reg  dif_zero  DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) addstat(Control group mean, `C_mean') label replace


reg   dif_zero DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg  dif_zero n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum dif_zero  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg dif_zero  n_children_t DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean') label append

reg dif_zero  n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id)
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

*************dif_mis 



reg  dif_mis  DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) addstat(Control group mean, `C_mean') label replace


reg   dif_mis DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg  dif_mis  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum dif_mis  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg dif_mis DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean') label append

reg dif_mis  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id)
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append




****Standardized outcome 

*We standardize both delta, with missing and delta 

sum dif_zero if treatment==0 
gen dif_zero_Z = ( dif_zero - r(mean))/r(sd)


sum dif_mis if treatment==0 
gen dif_mis_Z = ( dif_mis - r(mean))/r(sd)



reg  dif_zero_Z  DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
  sum  dif_zero_Z if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) addstat(Control group mean, `C_mean') label replace


reg   dif_zero_Z DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum  dif_zero_Z if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg  dif_zero_Z n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum dif_zero_Z  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg dif_zero_Z  n_children_t DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif_zero_Z if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean') label append

reg dif_zero_Z  n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id)
  sum  dif_zero_Z if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

*************dif_mis 



reg  dif_mis_Z  DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) addstat(Control group mean, `C_mean') label replace


reg   dif_mis_Z DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum  dif_mis_Z if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg  dif_mis_Z  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum dif_mis_Z  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg dif_mis_Z DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif_mis_Z if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean') label append

reg dif_mis_Z  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id)
  sum  dif_mis_Z if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append



*******************************************************************************heterogeneity depending on whether women had at least one son ********************************************************



reg  dif_mis  DOT_1  DOT_2  `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg   dif_mis  DOT_1  DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  dif_mis  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   dif_mis DOT_1  DOT_2  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  dif_mis  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   dif_mis  DOT_1  DOT_2    `at_least_s'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum dif_mis   if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean') label append

reg  dif_mis   DOT_1  DOT_2  `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum dif_mis   if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]
	  
	  
	  




reg  dif_mis_Z  DOT_1  DOT_2  `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum  dif_mis_Z if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg   dif_mis_Z  DOT_1  DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  dif_mis_Z  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   dif_mis_Z  DOT_1  DOT_2  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  dif_mis_Z  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   dif_mis_Z  DOT_1  DOT_2    `at_least_s'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum dif_mis_Z   if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean') label append

reg  dif_mis_Z  DOT_1  DOT_2  `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum dif_mis_Z  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]




*******************************************************************************heterogeneity depending on whether women had at least one son or/and at least one daughter********************************************************



reg  dif_mis  DOT_1  DOT_2  `at_least_s' `at_least_d' if Age_bl<50, vce(cluster wedp_id)
 sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_s' `at_least_d') addstat(Control group mean, `C_mean') label replace


reg   dif_mis  DOT_1  DOT_2  `at_least_s' `at_least_d' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  dif_mis  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_s' `at_least_d' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   dif_mis DOT_1  DOT_2  `at_least_s' `at_least_d' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  dif_mis  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'  `at_least_d' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   dif_mis  DOT_1  DOT_2    `at_least_s' `at_least_d' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum dif_mis   if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s' `at_least_d'   number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean') label append

reg  dif_mis   DOT_1  DOT_2  `at_least_s' `at_least_d' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum dif_mis   if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_s' `at_least_d' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]
	  
	  
	  




reg  dif_mis_Z  DOT_1  DOT_2  `at_least_s' `at_least_d' if Age_bl<50, vce(cluster wedp_id)
 sum  dif_mis_Z if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_s' `at_least_d') addstat(Control group mean, `C_mean') label replace


reg   dif_mis_Z  DOT_1  DOT_2  `at_least_s' `at_least_d' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  dif_mis_Z  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2  `at_least_s' `at_least_d' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   dif_mis_Z  DOT_1  DOT_2  `at_least_s' `at_least_d' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  dif_mis_Z  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'  `at_least_d' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append

reg   dif_mis_Z  DOT_1  DOT_2    `at_least_s' `at_least_d' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum dif_mis_Z   if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  `at_least_s'  `at_least_d'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children have_no_child_bl ) addstat(Control group mean, `C_mean') label append

reg  dif_mis_Z  DOT_1  DOT_2  `at_least_s' `at_least_d' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl if Age_bl<50, vce(cluster wedp_id)
 sum dif_mis_Z  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_s' `at_least_d' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children have_no_child_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]



