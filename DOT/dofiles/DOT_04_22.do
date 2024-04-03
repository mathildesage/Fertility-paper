*******************DOT***********************************

. use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace

label var head_hh "Women is head of household"

label var DOT_1 "treatment period 1"
label var DOT_2 "treatment period 2"

**	Continuous outcome 

reg n_children_t  DOT_1 DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 , vce(cluster wedp_id) 
sum n_children_t  if treatment==0 
  local C_mean_1 = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep( DOT_1 DOT_2 number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean')  label replace

test _b[DOT_1 ] =_b[DOT_2 ]

****Importing household asset index variable 

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

*Sample splitted
reg n_children_t  DOT_1  DOT_2  number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==0, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & at_least_son==0 & Age_bl<50
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean')    label replace

reg n_children_t  DOT_1  DOT_2  number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  plan_have_children no_children_bl  if Age_bl<50 & at_least_son==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & at_least_son==1 & Age_bl<50
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1 DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') label append

 reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==0
 est store reg1
reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2
			
			


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

**********************************************Impact on daycare **********************************************************************************



gen free_daycare = (bl_pi13 ==1 | bl_pi13 ==2 | bl_pi13 ==4)
replace free_daycare = . if bl_pi13==.

gen free_daycare_DOT1 = free_daycare*DOT_1
label var free_daycare_DOT1 "free daycare X DOT_1"

gen free_daycare_DOT2 = free_daycare*DOT_2
label var free_daycare_DOT2 "free daycare X DOT_2"


**If we split the sample 
reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==1,  vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 & free_daycare==1
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("Free daycare") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean')  label replace


reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==0, vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 &  free_daycare==1
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("No free daycare") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean') label append

reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==0
 est store reg1
reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2

			
**********************************************Interaction with son and with number of children ******************************************************


 gen at_least_son_DOT_1 = at_least_son*DOT_1
	 label var at_least_son_DOT_1 "Women have at least one son X DOT_1"
	 
	  gen at_least_son_DOT_2= at_least_son*DOT_2
	 label var at_least_son_DOT_2 "Women have at least one son X DOT_2"
	 
local at_least_s = "at_least_son at_least_son_DOT_1 at_least_son_DOT_2"

gen  nbs_DOT_1 = DOT_1*number_children_bl
label var nbs_DOT_1 "Number of children X DOT_1"

gen  nbs_DOT_2 = DOT_2*number_children_bl
label var nbs_DOT_2 "Number of children X DOT_2"

local nbs_T =  "nbs_DOT_1 nbs_DOT_2"



reg n_children_t  DOT_1 DOT_2 at_least_son at_least_son_DOT_1 at_least_son_DOT_2 number_children_bl  nbs_DOT_1 nbs_DOT_2  time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 , vce(cluster wedp_id) 
sum n_children_t  if treatment==0 
local C_mean_1 = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep( DOT_1 DOT_2 at_least_son at_least_son_DOT_1 at_least_son_DOT_2 number_children_bl  nbs_DOT_1 nbs_DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh) addstat(Control group mean, `C_mean_1')  label replace



**********************************************Impact on girls not married yet******************************************************

reg n_children_t  DOT_1 DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & bl_pi3==1, vce(cluster wedp_id) 
sum n_children_t  if treatment==0 &  bl_pi3==1
  local C_mean_1 = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(DOT_1 DOT_2   number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean_1')  label replace




**30% des femmes single au baseline se déclarent mariées au endline
***38% des femmes qui n'étaient pas mariées au baseline (never married/single) on au moins un enfant au endline
**parmi les femmes qui se sont mariées entre le baseline et le endline (36) 70% ont eu des enfants 
**7% des femmes célibataires au baseline et non mariées au endline ont eu des enfants 


***Ce n'est pas du à un déséquilibre au baseline

reg number_children_bl DOT_1 DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & bl_pi3==1, vce(cluster wedp_id) 
sum n_children_t  if treatment==0 &  bl_pi3==1
  local C_mean_1 = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(treatment number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean_1')  label replace

**Peut être à un effet du traitement sur le mariage?


gen married_ml = (ml_sec3_8==2)
replace  married_ml=. if ml_sec3_8==. 
label var married_ml "Married at midline"


reg married_ml  DOT_1 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 , vce(cluster wedp_id) 
sum n_children_t  if treatment==0 
  local C_mean_1 = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(treatment number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean_1')  label replace





gen married_el  = (el_sec3_8==2)
replace married_el=. if el_sec3_8==.
label var married_el "Married at endline"


reg married_el  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 , vce(cluster wedp_id) 
sum n_children_t  if treatment==0 
  local C_mean_1 = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(treatment number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean_1')  label replace


********Maybe the question is misleading : What is your marital status? (Do not read the responses) 1 = Single/never married (Go directly to question 10)
*2 = Married/consensual union
*3 = Widowed ( )
*4 = Divorced/separated 
*so given the question, women not married but in a relationship may have answered single, or widow or divorced depending on the situation 


reg n_children_t  DOT_1  DOT_2  number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==0 &  bl_pi3==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & at_least_son==0 & Age_bl<50 &  bl_pi3==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean')    label replace

reg n_children_t  DOT_1  DOT_2  number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  plan_have_children no_children_bl  if Age_bl<50 & at_least_son==1 &  bl_pi3==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & at_least_son==1 & Age_bl<50 &  bl_pi3==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1 DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') label append

 reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==0 &  bl_pi3==1
 est store reg1
reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==1 &  bl_pi3==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2
			
			


**Sample splitted
reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & asset_below_med==0 &  bl_pi3==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==0 &  bl_pi3==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset above the median") keep( DOT_1  DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean')    label replace

reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  plan_have_children no_children_bl if Age_bl<50 & asset_below_med==1 &  bl_pi3==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==1 &  bl_pi3==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset below the median") keep(  DOT_1 DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') label append

 reg n_children_t  DOT_1  DOT_2 time  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==0 &  bl_pi3==1
 est store reg1
reg n_children_t  DOT_1  DOT_2  time number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==1 &  bl_pi3==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2




reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==1 &  bl_pi3==1,  vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 & free_daycare==1 &  bl_pi3==1
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("Free daycare") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean')  label replace


reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==0 &  bl_pi3==1, vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 &  free_daycare==1 &  bl_pi3==1
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("No free daycare") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean') label append

reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==0 &  bl_pi3==1
 est store reg1
reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==1 &  bl_pi3==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2



***********************************************************************************Effect on divorced/widows *************************************************************************************




reg n_children_t  DOT_1 DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 &  div_widow==1, vce(cluster wedp_id) 
sum n_children_t  if treatment==0 &   div_widow==1
  local C_mean_1 = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep(DOT_1 DOT_2   number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean_1')  label replace





reg n_children_t  DOT_1  DOT_2  number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==0 &  div_widow==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & at_least_son==0 & Age_bl<50 &  div_widow==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean')    label replace

reg n_children_t  DOT_1  DOT_2  number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  plan_have_children no_children_bl  if Age_bl<50 & at_least_son==1 &   div_widow==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & at_least_son==1 & Age_bl<50 &  div_widow==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1 DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') label append

 reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==0 &  div_widow==1
 est store reg1
reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & at_least_son==1 &  div_widow==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2
			
			


**Sample splitted
reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & asset_below_med==0 &  bl_pi3==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==0 &  div_widow==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset above the median") keep( DOT_1  DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean')    label replace

reg n_children_t  DOT_1  DOT_2  time number_children_bl  married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6  plan_have_children no_children_bl if Age_bl<50 & asset_below_med==1 &  bl_pi3==1, vce(cluster wedp_id) 
  sum  n_children_t if treatment==0 & time==0 & asset_below_med==1 &  div_widow==1
    local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("Household asset below the median") keep(  DOT_1 DOT_2  number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean , `C_mean') label append

 reg n_children_t  DOT_1  DOT_2 time  number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==0 &  div_widow==1
 est store reg1
reg n_children_t  DOT_1  DOT_2  time number_children_bl time married_couple  WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl if Age_bl<50 & asset_below_med==1 &  div_widow==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2




reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==1 &  div_widow==1,  vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 & free_daycare==1 &  div_widow==1
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("Free daycare") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean')  label replace


reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==0 &  bl_pi3==1, vce(cluster wedp_id)
  sum  n_children_t if treatment==0 & time==0 &  free_daycare==1 &  div_widow==1
    local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("No free daycare") keep(DOT_1  DOT_2   number_children_bl  married_couple education_level_bl  bl_pi6 Age_bl Age_bl_square head_hh )addstat(Control group mean, `C_mean') label append

reg n_children_t  DOT_1  DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==0 &  div_widow==1
 est store reg1
reg n_children_t  DOT_1  DOT_2   number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 & free_daycare==1 &  div_widow==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2
			
			



*************************************************************************Impact on number of children under 5****************************************************************

use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_MainIERoster_Fertility_07252019.dta", clear

 format wedp_id %10.0f
 keep if substr(string(wedp_id , "%10.0f") , 1, 2) == "64"
 
 save  "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_MainIERoster_Fertility_07252019_temp.dta"

 use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace
 gen sample=1
 
 
append using "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_MainIERoster_Fertility_07252019_temp.dta"

 
***Number of head children under 5 

gen head_child = (h3==3)
replace head_child=. if h3==.

gen head_child_under_5 = (head_child ==1 & h5<6)
replace head_child_under_5=. if h5==.

bysort wedp_id : egen children_under_5  = total(head_child_under_5), missing


**Issue: this is an outcome at MIDLINE




reg  children_under_5 treatment number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_pi6 plan_have_children no_children_bl  if Age_bl<50 , vce(cluster wedp_id) 
sum  children_under_5 if treatment==0 & Age_bl<50 & time==0
  local C_mean_1 = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep( treatment number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean_1')  label replace








** Numbber of adult man "other relative"

gen other_rel = (h3==7)
replace other_rel=. if h3==. 

gen other_rel_male_adult = (other_rel==1 & h5>18 & h2==1 )
replace other_rel_male_adult= . if h5==. 
replace other_rel_male_adult= . if h2==.
 bysort wedp_id : egen nbs_male_rel = total(other_rel_male_adult), missing
 
 gen at_least_other_rel = (nbs_male_rel>0)
 replace at_least_other_rel=. if nbs_male_rel==.
 
 ***12% des femmes mariées ont au moins un other relative male , 18.4% des femmes non mariées en ont un 
 
 