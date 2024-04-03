
*********************************
*******Balance check - DOT*******
*********************************



 *b) Create a global list of the variables we want to see in the table
 
 **We need to import more variables 
 
 **We prepare the roster to import household head level of education 
use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets 3/Women Entrepreneurship Development Project_MainIERoster_Fertility_07252019.dta", replace

*Sampling

*we keep women who are either spouse or hh head
keep if (h3==1 | h3==2)

*We keep women
keep if h2==1

duplicates  drop  wedp_id , force
 
 label var h5 "Partner age"
 label var h6 "Partner level of education"


rename h5 partner_age
rename h6 partner_educ
rename h8 partner_occ


label var partner_occ "partner main activity"

 
 save "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets 3/temporary_head_base.dta", replace

 use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace

 merge  m:1 wedp_id using "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets 3/temporary_head_base.dta", keepusing(partner_age partner_educ partner_occ)
drop if  _merge==2
 
 **clean educ var 
 
 gen partner_no_educ = (partner_educ==1 | partner_educ==2 | partner_educ==3)
 replace partner_no_educ=. if partner_educ==.
 label var partner_no_educ "partner no education"
 
 gen partner_prim_educ = (partner_educ==4 |partner_educ==5)
 replace partner_prim_educ=. if partner_educ==.
 label var partner_prim_educ "partner primary education"

 gen partner_sec_educ = (partner_educ==6 |partner_educ==7)
 replace partner_sec_educ=. if partner_educ==.
 label var partner_sec_educ "partner secondary education"

  gen partner_high_s_educ = (partner_educ==8 |partner_educ==9 |partner_educ==10 |partner_educ==11 |partner_educ==12 |partner_educ==13 |partner_educ==14 |partner_educ==15|partner_educ==16| partner_educ==17 )
 replace partner_high_s_educ=. if partner_educ==.
 label var partner_high_s_educ "partner high school"
 
  gen partner_higher_educ = (partner_educ==18 |partner_educ==19 |partner_educ==20 |partner_educ==21 |partner_educ==22)
 replace partner_higher_educ=. if partner_educ==.
 label var partner_higher_educ "partner higher educ"

 
 **Women educ 
 
  
 
 gen woman_no_educ = (education_level_bl==1)
 replace woman_no_educ=. if education_level_bl==.
 label var woman_no_educ "woman no education"
 
 gen woman_prim_educ = (education_level_bl==2 |education_level_bl==3)
 replace woman_prim_educ=. if education_level_bl==.
 label var woman_prim_educ "woman primary education"

 gen woman_sec_educ = (education_level_bl==4 | education_level_bl==5 |education_level_bl==6)
 replace woman_sec_educ=. if education_level_bl==.
 label var woman_sec_educ "woman secondary education"

  gen woman_high_s_educ = (education_level_bl==7 | education_level_bl==8 |education_level_bl==9)
 replace woman_high_s_educ=. if partner_educ==.
 label var woman_high_s_educ "woman high school"
 
  gen woman_higher_educ = (education_level_bl==10| education_level_bl==11 |education_level_bl==12)
 replace woman_higher_educ=. if partner_educ==.
 label var woman_higher_educ "woman higher educ"

 **partner occupation 
 

 gen partner_self_employed = ( partner_occ ==2 |partner_occ ==3)
replace partner_self_employed =. if partner_occ ==.
label var partner_self_employed "partner self employed"

gen partner_employed = (partner_occ ==1)
replace partner_employed =. if partner_occ ==.
label var partner_employed "partner employed"

 gen partner_unemployed = ( partner_occ ==6 |partner_occ ==7 |partner_occ ==10 |partner_occ ==11 )
replace partner_unemployed =. if partner_occ ==.
label var partner_unemployed "partner unemployed"
 
  gen partner_other = ( partner_occ ==13 | partner_occ ==5)
replace partner_other =. if partner_occ ==.
label var partner_other "partner other"
 
 **Ici married = married or consensual union. No variable to distinguish married and consensual union (contrary to ghana and rwanda)
 
 **We import hh asset index - which is a sum of dummies equal to one if the hh own the 
merge m:1 wedp_id using "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_MainIE_Fertility_07252019.dta", keepusing(HH_Asset_Index_bl) gen(merge_3)

 label var HH_Asset_Index_bl "Household asset index"
 
 sum HH_Asset_Index_bl if  attrited_fu2_t==0 &  treatment==0   & Age_bl<50, det
 return list
 gen HH_Asset_Index_bl_sd = (HH_Asset_Index_bl - r(mean))/ r(sd)
 
global bc_var "Age_bl woman_no_educ woman_prim_educ woman_sec_educ woman_high_s_educ woman_higher_educ bl_pi6   number_children_bl married_couple  women_hh_head partner_age partner_no_educ partner_prim_educ partner_sec_educ partner_high_s_educ partner_higher_educ partner_self_employed partner_employed partner_unemployed partner_other HH_Asset_Index_bl_sd" 
		
label var HH_Asset_Index_bl_sd "Household asset index"		
		
label var DOT_1 "Treated follow-up 1"		
label var DOT_2 "Treated follow-up 2"

 
global bc_var_num : word count $bc_var
des $bc_var, fullname
 

#delimit ;
 
*Create the table’s columns:;
*Column containing the list of baseline covariates;
gen str32 var="";                                                         
 
*Columns for sample description (n, mean, sd);
for any end: gen X_n=. ;
for any end: gen X_mean=. ;
for any end: gen X_sd=. ;
 
*Columns for balancing tests;
for any treatment : gen X_mean=. \ gen X_pv=. \ gen X_sig="" \ gen X_se=.;
 
***1/ATTRITION;
replace var="Attrition" if _n==1;
 
sum attrited_fu2_t if Age_bl<50 & time==1 &  treatment==0, detail; 
 
            replace end_mean=r(mean) if _n==1;
            replace end_sd=r(sd) if _n==1;
            replace end_n=r(N) if _n==1;
 
xi: reg attrited_fu2_t  treatment if Age_bl<50 & time==1, vce(cluster wedp_id) ;
           
     replace treatment_mean=_b[DOT_2] if _n==1;
            replace treatment_se=_se[DOT_2] if _n==1;
            test DOT_2;
            replace treatment_pv=r(p) if _n==1;
           
***2/OTHER CHARACTERISTICS;
local vars $bc_var_num ;
 
for any $bc_var \ num 1/`vars':
 
replace var="X" if _n==(Y+1) \
 
sum X if attrited_fu2_t==0 &  treatment==0   & Age_bl<50, detail \
 
            replace end_mean=r(mean) if _n==(Y+1) \
            replace end_sd=r(sd) if _n==(Y+1) \
			
sum X if attrited_fu2_t==0 & Age_bl<50 & time==0, detail \
            replace end_n=r(N) if _n==(Y+1) \
 
xi: reg X DOT_2  if Age_bl<50 & attrited_fu2_t==0 & time==1, vce(cluster wedp_id)  \
             
     replace treatment_mean=_b[DOT_2] if _n==(Y+1) \    
             replace treatment_se=_se[DOT_2] if _n==(Y+1) \     
             test DOT_2\
            replace treatment_pv=r(p) if _n==(Y+1) ;
    

	
	   
		   
*ROUNDING UP;
for var *_mean *_pv *_se: replace X=round(X, 0.0001);
 

*SIGNIFICANCE LEVEL;
for any treatment : replace X_sig=" " if (X_pv>0.1);
for any treatment: replace X_sig="*" if (X_pv>0.05&X_pv<=0.1);
for any treatment: replace X_sig="**" if (X_pv>0.01&X_pv<=0.05);
for any treatment : replace X_sig="***" if (X_pv<=0.01);
 
*REPLACING VARIABLE NAMES BY THEIR LABEL;
foreach var in $bc_var {;
 
            replace var=`"`:var label `var''"' if var=="`var'";
 
};

gen ordering_var = _n ;




#delimit cr




gen Pval_H_Unadj = treatment_pv 

		sort Pval_H_Unadj 
		gen Pval_H_Unadj_order = _n if Pval_H_Unadj != . 
		egen m= max(Pval_H_Unadj_order) if Pval_H_Unadj != . 
		gen Pval_Adj = . 
		replace Pval_Adj = min(Pval_H_Unadj * m / Pval_H_Unadj_order,1) if Pval_H_Unadj_order != . 
		
		drop Pval_H_Unadj 
	for var Pval_Adj : replace X=round(X, 0.0001)
 
 sort ordering_var
*SAVING TABLE;
export excel var end_n end_mean end_sd treatment_mean  treatment_se treatment_pv Pval_Adj treatment_sig   using"/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Fertility paper/DOT/outputs/Sample description and balance checks -DOT.xlsx" ,  keepcellfmt replace  firstrow(var)

drop var var end_n end_mean end_sd treatment_mean treatment_pv treatment_sig treatment_se

 
