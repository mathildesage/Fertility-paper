use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace


***We need to import labour supply variables 


use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/data/WEDP_DOT_BL_ML_EL_noPII_19Apr2022.dta"

rename sec42_24 el_sec42_24

rename sec42_25 el_sec42_25

rename digitspan_score bl_digitspan_score


*ml_sec42_24 ml_sec42_25
 *bl_HOURSworkedweek bl_numEMPLOYEES
 
 keep if time==0 
save "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/data/WEDP_DOT_BL_ML_EL_noPII_19Apr2022_bl_ml.dta", replace


use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/data/WEDP_DOT_BL_ML_EL_noPII_19Apr2022.dta", replace

rename sec42_24 el_sec42_24

rename sec42_25 el_sec42_25

rename digitspan_score bl_digitspan_score


*ml_sec42_24 ml_sec42_25
 *bl_HOURSworkedweek bl_numEMPLOYEES
 
 keep if time==1
save "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/data/WEDP_DOT_BL_ML_EL_noPII_19Apr2022_el.dta", replace


use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace

**Controls used in the ppaer : Controls include: received WEDP loan at baseline, age of owner, education more than secondary, number of children, number of workers and digitspan score at baseline.
merge m:1  wedp_id using "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/data/WEDP_DOT_BL_ML_EL_noPII_19Apr2022_bl_ml.dta", keepusing( ml_sec42_24 ml_sec42_25 bl_HOURSworkedweek  bl_digitspan_score bl_numEMPLOYEES)


merge m:1  wedp_id using "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/data/WEDP_DOT_BL_ML_EL_noPII_19Apr2022_el.dta", keepusing(el_sec42_24 el_sec42_25) gen(_merge_el)

**outcomes seems to have been already winsorized 

replace el_sec42_24 = . if el_sec42_24== -77

replace ml_sec42_24 = . if ml_sec42_24== -77

**the baseline var has bot been winsorized, I keep it as it is 

 winsor2 bl_HOURSworkedweek if time==0, replace cuts(1 99)
 winsor2 bl_HOURSworkedweek if time==1, replace cuts(1 99)

 label var head_hh "Women is head of household"

label var DOT_1 "treatment period 1"
label var DOT_2 "treatment period 2"

*	Continuous outcome 


**We build the outcome 

gen hours_worked_weekly = ml_sec42_24 if time==0 
replace hours_worked_weekly = el_sec42_24  if time==1

reg  hours_worked_weekly  DOT_1 DOT_2 bl_HOURSworkedweek  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_digitspan_score if Age_bl<50, vce(cluster wedp_id) 
sum  bl_HOURSworkedweek if treatment==0 & time==0
local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("") keep( DOT_1 DOT_2 bl_HOURSworkedweek number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean')  label replace

test _b[DOT_1 ] =_b[DOT_2 ]

***We run the reg depending on son 

reg  hours_worked_weekly  DOT_1 DOT_2 bl_HOURSworkedweek  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_digitspan_score if Age_bl<50 & at_least_son==0, vce(cluster wedp_id) 
sum  bl_HOURSworkedweek if treatment==0 & time==0 & at_least_son==0
local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("No son") keep( DOT_1 DOT_2 bl_HOURSworkedweek number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean')  label replace

reg  hours_worked_weekly  DOT_1 DOT_2 bl_HOURSworkedweek  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_digitspan_score if Age_bl<50 & at_least_son==1, vce(cluster wedp_id) 
sum  bl_HOURSworkedweek if treatment==0 & time==0 & at_least_son==1
local C_mean = r(mean)
outreg2  using Tab4.xls, excel dec(3) ctitle("At least one son") keep( DOT_1 DOT_2 bl_HOURSworkedweek number_children_bl  married_couple education_level_bl bl_pi6 Age_bl Age_bl_square head_hh ) addstat(Control group mean -follow-up 1, `C_mean')  label append



 reg hours_worked_weekly  DOT_1 DOT_2 bl_HOURSworkedweek  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_digitspan_score if Age_bl<50 & at_least_son==0
 est store reg1
reg hours_worked_weekly  DOT_1 DOT_2 bl_HOURSworkedweek  number_children_bl time married_couple WEDP_loan education_level_bl  Age_bl Age_bl_square head_hh bl_digitspan_score if Age_bl<50 & at_least_son==1
 est store reg2

suest reg1 reg2, vce(cluster wedp_id)
			test [reg1_mean]DOT_1 =[reg2_mean]DOT_1 
			test [reg1_mean]DOT_2=[reg2_mean]DOT_2





