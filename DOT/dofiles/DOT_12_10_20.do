**NB : maybe what I should do for missing values (for controls), is putting zero but a dummy to control for the missing 

*La variable had_child_post est à recoder 

replace nbs_children_ml = 0 if have_children_ml==2
gen attrited_fu1 =(nbs_children_ml==. & time==0) 


replace number_children_el =0 if have_children_el==2
gen attrited_fu2 =(number_children_el==. & time==1) 
 egen attrited_fu2_t = total(attrited_fu2),  by(wedp_id)


**We are going to create a dummy indicating observations attrited 

gen attrited_fu1 = (nbs_children_ml==.) 
 egen attrited_fu1_t = total(attrited_fu1),  by(wedp_id)

  egen n_children_ml = total(nbas_children_ml) if attrited_fu1_t==0, by(wedp_id)

   
   
   egen n_children_el = total(number_children_el) if attrited_fu2_t==0, by(wedp_id)
   
   gen n_children_t = n_children_ml if time==0
   replace n_children_t = n_children_el if time==1
   
   gen  had_child_post_treat  = (number_children_bl < max(n_children_ml, n_children_el))
replace had_child_post_treat =. if attrited_fu1_t ==1  & attrited_fu2_t==1
label var had_child_post_treat   "Had a child post treatment"  


***En fait on va pas pooler pour la première dummy outcome  :

gen child_post_d = (number_children_bl<n_children_ml) 
replace child_post_d =. if attrited_fu1==1
replace child_post_d =1 if number_children_bl<n_children_el & time==1
replace child_post_d =. if attrited_fu2==1



***On a enfin les bons outcomes...

**Si on veut refaire les reg du papier, on doit avoir deux variables traitemennt DOT_1 DOT_2 qui signifie que l'unité a été associée à un groupe de traitement à un moment
*donné, et qui permet de dissocier les effets dans le temps sans pooler

**nous on va aussi proposer une spécification poolée

**on fabrique d'abord les variables DOT_1 DOT_2

gen DOT_1 = (treatment==1 & time==0) 
label var DOT_1 "Treated follow-up 1"

gen DOT_2 = (treatment==1 & time==1) 
label var DOT_2 "Treated follow-up 2"

************************************************************ OLS AND ANCOVA, DOT NOT POOLED ************************************************************************************************************************
save "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace

*controls include : received WEDP loan at baseline, age of owner, marital status, education, household size, number of children and digitspan score at baseline.

education_level_bl

 gen Age_bl_square = Age_bl^2

label var  Age_bl_square "Age square"

label var head_hh "Women household head"

**on a un problème avec la variable "do you plan to have more children" il faut la recoder 


. replace plan_have_children=0 if plan_have_children==2


. label define yesno 1 "yes" 0 "No"

. label values plan_have_children yesno

*************************************OLS 

**********************Outcome continuous 

reg   n_children_t DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) label replace


reg   n_children_t DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg   n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


**********************Outcome dummy 
********************probit model 
quietly probit child_post_d DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label replace
  
  quietly probit child_post_d DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append

    
  quietly probit child_post_d DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
  
    
  quietly probit child_post_d DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  

    
  quietly probit child_post_d DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
*********************Linear probability model 


reg child_post_d  DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) label replace


reg  child_post_d  DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg  child_post_d  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg  child_post_d  DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg  child_post_d  DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


************************************ANCOVAn (??)
**For continuous variable, we need to notify with c. they are continuous variables 
*The use of ancova and dif and dif, is justified by an highly correlated outcome (cf Mckenzie 2012)


anova  n_children_t  DOT_1  DOT_2  if Age_bl<50
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) label replace


anova n_children_t  DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 c.Age_bl head_hh plan_have_children if Age_bl<50
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

anova  n_children_t   DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 c.Age_bl c.Age_bl_square head_hh plan_have_children if Age_bl<50
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

anova   n_children_t  DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 c.Age_bl head_hh plan_have_children if Age_bl<50 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

anova n_children_t   DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 c.Age_bl c.Age_bl_square head_hh plan_have_children if Age_bl<50
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


save "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace

****************************************************Maybe we should try to pool the treatment to have an average treatmeznt effect overt the 2 years period ****************************************************************************************************************************************************************




**********************Outcome continuous 

reg   n_children_t treatment  if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(treatment ) label replace


reg   n_children_t treatment  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( treatment  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg   n_children_t treatment  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(treatment  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg   n_children_t treatment  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(treatment  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg   n_children_t treatment  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( treatment  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

*QUESTION : est-ce que cette spécification est correcte ? 
**Est-ce qu'il faudrait pas mieux la formaliser avec un panel ? 


**********************Outcome dummy 
********************probit model 
quietly probit child_post_d treatment   if Age_bl<50, vce(cluster wedp_id
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label replace
  
  quietly probit child_post_d treatment  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append

    
  quietly probit child_post_d treatment  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
  
    
  quietly probit child_post_d treatment  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  

    
  quietly probit child_post_d treatment  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
*********************Linear probability model 


reg child_post_d  treatment   if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(treatment  ) label replace


reg  child_post_d  treatment  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( treatment  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg  child_post_d  treatment  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(treatment  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg  child_post_d  treatment  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(treatment  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg  child_post_d  treatment  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( treatment  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append



 label var treatment "DOT treatment"





*******************************************************Heterogeneous treatment effect **************************************************************************
**********************************************************************************We want to test heterogeneity depending on daycare  ************************************************************************************************************************
**What information do we have ? 

**We have the question : who take care of your children whil u are working and not in school ? bl_pi13

**We have a database . 

use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets 2/Women Entrepreneurship Development Project_MainIERoster_Fertility_07252019.dta"
by wedp_id: gen dup2 = _n
count if dup2==1


*about household roster. With 2139 households. Is there among them households from DOT we are interested in ? Probably not... because for the PI/BS ==> 2001 female entrepreneurs
**Good news : in an old mail, we find "The Household Roster for the DOT study sample is contained in the main IE roster, but no hh roster collected for PI"
**En fait les 2,139  hh refering to 2,139  firms, sont les firmes étudiées dans le papier "Better Loans or Better Borrowers? Impact of Meso-Credit on Female-Owned Enterprises in Ethiopia"

 use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", clear
**On merje avec les données roster, apparement ces données datent du midline du projet WEDP. donc de 2017, donc de après le midline. De fait utiliser ces données comme contrôle, source d'hétéorogénéité, implique
*de faire l'hypothèse que ces informations sont restées inchangées sur la période, enfin depuis le baseline.
**Le hh roster date de December 2016 and February 2017, donc du endline de DOT ..  utiliser le nombre de femmes dans le ménage en 2017, revient à faire l'hypothèse qu'il y avait
*cette même composition du ménafe au baseline en octobre 2014, or la composition du ménage a pu évolué en raison du traitement.


*** To compute heterogeneity depending on daycare, we have number_daughters_bl. pb : We don't know how old are those daughters, and therefore if they are able to take care of children/

*bl_pi13 here we have who mainly look after your children. 

gen children_at_work = (bl_pi13==8)
label var children_at_work "Women children stay with women at business"

gen children_at_work_DOT_1 =children_at_work*DOT_1   
label var children_at_work_DOT_1  "Women children stay with women at business X DOT_1"

gen children_at_work_DOT_2 =children_at_work*DOT_2
label var children_at_work_DOT_2 "Women children stay with women at business X DOT_1"

**With this variable, I do not assign missing to women who do not have children, because I don't want to restrict the sample from 1500 obs to 1200
*and lose the randomization


**Issue : what to do with the missing (pb with command gen)

reg   n_children_t DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2) label replace


reg   n_children_t DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg   n_children_t DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[children_at_work_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[children_at_work_DOT_2]


**********************Outcome dummy 
********************probit model 
quietly probit child_post_d DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label replace
  
  quietly probit child_post_d DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append

    
  quietly probit child_post_d DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
  
    
  quietly probit child_post_d DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  

    
  quietly probit child_post_d DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
    lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[children_at_work_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[children_at_work_DOT_2]
	  
	  
*********************Linear probability model 


reg child_post_d  DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) label replace


reg  child_post_d  DOT_1  DOT_2  children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg  child_post_d  DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg  child_post_d  DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg  child_post_d  DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 children_at_work children_at_work_DOT_1 children_at_work_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[children_at_work_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[children_at_work_DOT_2]

**************NO DAYCARE : "they look after themsevlves" (different from "older siblings") ** 

gen no_daycare =(bl_pi13==1)
label var no_daycare "No daycare- Children look after themselves"

gen no_daycare_DOT_1 = no_daycare*DOT_1
label var no_daycare_DOT_1 "No daycare X DOT_1"

gen no_daycare_DOT_2 = no_daycare*DOT_2
label var no_daycare_DOT_2 "No daycare X DOT_2"

no_daycare no_daycare_DOT_1 no_daycare_DOT_2

reg   n_children_t DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2) label replace


reg   n_children_t DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl no_daycare no_daycare_DOT_1 no_daycare_DOT_2 time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg   n_children_t DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append



  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[no_daycare_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[no_daycare_DOT_2]




**********************Outcome dummy 
********************probit model 
quietly probit child_post_d DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 if Age_bl<50, vce(cluster wedp_id
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label replace
  
  quietly probit child_post_d DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append

    
  quietly probit child_post_d DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
  
    
  quietly probit child_post_d DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  

    
  quietly probit child_post_d DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  `
  
  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[no_daycare_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[no_daycare_DOT_2]
  
*********************Linear probability model 


reg child_post_d  DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2  if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) label replace


reg  child_post_d  DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg  child_post_d  DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg  child_post_d  DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg  child_post_d  DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 no_daycare no_daycare_DOT_1 no_daycare_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


 
  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[no_daycare_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[no_daycare_DOT_2]
	  

	  ********************Maybe we can test heterogeneity depending on whether women do have a stable daycare solution ("the baby sitter or live in servant look after them"**********We expect that those women who 
	  *already have a babysitter it will be easier to have an other baby. But we must control for wealth as well. 
	  
	  gen have_baby_sitter = (bl_pi13==6)
	  label var have_baby_sitter "Have a baby sitter or servant to look after children"
	  
	  gen have_baby_sitter_DOT_1 = have_baby_sitter*DOT_1
	  label var have_baby_sitter_DOT_1 "Have a baby sitter or servant to look after children X DOT 1"
	  
	  
	   gen have_baby_sitter_DOT_2 = have_baby_sitter*DOT_2
	  label var have_baby_sitter_DOT_2 "Have a baby sitter or servant to look after children X DOT 2"
	  
	  
	 
	  
	  
reg   n_children_t DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2) label replace


reg   n_children_t DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append



reg   n_children_t DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[have_baby_sitter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[have_baby_sitter_DOT_2]
	  
	  
	  
	  quietly probit child_post_d DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label replace
  
  quietly probit child_post_d DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append

    
  quietly probit child_post_d DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
  
    
  quietly probit child_post_d DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  

    
  quietly probit child_post_d DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
  
  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[have_baby_sitter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[have_baby_sitter_DOT_2]
*********************Linear probability model 


reg child_post_d  DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2) label replace


reg  child_post_d  DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg  child_post_d  DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg  child_post_d  DOT_1 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg  child_post_d  DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 have_baby_sitter have_baby_sitter_DOT_1 have_baby_sitter_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

	  
  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[have_baby_sitter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[have_baby_sitter_DOT_2]
	  
	  *****************We want to test heterogeneity depending on whether women do have free daycare at home (siblings, older children)
	  
	  
	  
	  
	  
	  
	  gen free_daycare_home = (bl_pi13 ==1 | bl_pi13 ==2 | bl_pi13==3) 
	  label var free_daycare_home "Women have free daycare at home (older children/spouses)"
	  
	  gen free_daycare_home_DOT_1 = free_daycare_home*DOT_1 
	  label var free_daycare_home_DOT_1 "Women have free daycare at home (older children/spouses) X DOT_1"
	  
	  	  gen free_daycare_home_DOT_2 = free_daycare_home*DOT_2 
	  label var free_daycare_home_DOT_2 "Women have free daycare at home (older children/spouses) X DOT_2"
	  
	 DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2

reg   n_children_t DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 ) label replace


reg   n_children_t DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg   n_children_t DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[free_daycare_home_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[free_daycare_home_DOT_2]
	  

	

quietly probit child_post_d DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2  if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label replace
  
  quietly probit child_post_d DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append

    
  quietly probit child_post_d DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
  
    
  quietly probit child_post_d DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  

    
  quietly probit child_post_d DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
    lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[free_daycare_home_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[free_daycare_home_DOT_2]
	  
*********************Linear probability model 


reg child_post_d  DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2   if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2  ) label replace


reg  child_post_d  DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg  child_post_d  DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg  child_post_d  DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg  child_post_d  DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2  free_daycare_home free_daycare_home_DOT_1 free_daycare_home_DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[free_daycare_home_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[free_daycare_home_DOT_2]
	  
	  save "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace

	  
	  
	  
	  
	  ***************************************************************regarding daycare, we want to distinguish the effect of siblings + relative or friend from  the effect of husband at home *******************
	  
	  **NB : in free daycare we include : they look after themselves/ elder siblings. Because we suppose that when women say "they look after themselves, it means they are old enough to take 
	  *care of a potential baby
	  
	  
	
	  
	  gen sibling_relative= (bl_pi13==1 | bl_pi13==2)
	  replace sibling_relative=0 if have_children_bl==0
	  label var sibling_relative "Siblings can look after children"
	  
	  gen sibling_relative_DOT_1 = sibling_relative*DOT_1
	  label var sibling_relative_DOT_1 "Siblings can look after children X DOT_1"
	  
	  
	    gen sibling_relative_DOT_2= sibling_relative*DOT_2
	  label var sibling_relative_DOT_2 "Siblings can look after children X DOT_2"
	  
	  local sib = "sibling_relative sibling_relative_DOT_1 sibling_relative_DOT_2"
	  
	  

	  
	  ******OLS
reg   n_children_t DOT_1  DOT_2 `sib'  if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2  `sib') label replace


reg   n_children_t DOT_1  DOT_2 free_daycare_home `sib' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 `sib' number_children_bl  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 `sib' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 `sib' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg   n_children_t DOT_1  DOT_2 free_daycare_home `sib' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 `sib'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg   n_children_t DOT_1  DOT_2  `sib' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 `sib' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[sibling_relative_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[sibling_relative_DOT_2]
	  

	*******PROBIT 

quietly probit child_post_d DOT_1  DOT_2  `sib' if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label replace
  
  quietly probit child_post_d DOT_1  DOT_2  `sib' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append

    
  quietly probit child_post_d DOT_1  DOT_2  `sib' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  
  
    
  quietly probit child_post_d DOT_1  DOT_2  `sib' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append
  

    
  quietly probit child_post_d DOT_1  DOT_2  `sib'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") label append


    lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[sibling_relative_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[sibling_relative_DOT_2]
	  
	  
	  
	  
	  ****LPM 
	  	  
reg  child_post_d DOT_1  DOT_2 `sib'  if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2  `sib') label replace


reg  child_post_d DOT_1  DOT_2 free_daycare_home `sib' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 `sib' number_children_bl f number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) label append

reg   child_post_d DOT_1  DOT_2 `sib' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 `sib' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append

reg   child_post_d DOT_1  DOT_2 free_daycare_home `sib' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 `sib'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) label append

reg  child_post_d DOT_1  DOT_2  `sib' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 `sib' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[sibling_relative_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[sibling_relative_DOT_2]
	  

	  
	  
	  
	  
	  
	  
	  *********************** Test the effect on the variable "Do you plan to have more children ?" as an outcome and as source of heterogeneity*******
	  
	 *At baseline we have :  plan_have_children 
	 *At mid and end ? It seems we don't have this variable at midline and endline
	 **So we cannot use this variable as an outcome because we don't have this variable at midline, neither at endline
	 
	 **We have "how many son" "How many daughters" do you have, to test whether the fertility response vary depending on women gender composiiton of childbirth 
	 
	 ***************************************************************Heterogeneity depending on whether women have at least one son    *****************************************************************************************

	 **On doit recleaner les variable son daughters du baseline  DOT_1 DOT_2
	 
	 replace number_sons_bl =0 if have_children_bl==0
	 
	 replace number_daughters_bl=0 if have_children_bl==0
	 
	 gen at_least_son = (number_sons_bl>0)
	 replace at_least_son=. if number_sons_bl==.
	 label var at_least_son "Women have at least one son"
	 
	 gen at_least_daughter = (number_daughters_bl>0)
	 replace at_least_daughter=. if number_daughters_bl==.
	 label var at_least_daughter "Women have at least one daughter"
	 
	 gen at_least_son_DOT_1 = at_least_son*DOT_1
	 label var at_least_son_DOT_1 "Women have at least one son X DOT_1"
	 
	  gen at_least_son_DOT_2= at_least_son*DOT_2
	 label var at_least_son_DOT_2 "Women have at least one son X DOT_2"
	 
	 
	 gen at_least_daughter_DOT_1 = at_least_daughter*DOT_1
	 label var at_least_daughter_DOT_1 "Women have at least one daughter X DOT_1"
	 
	  gen at_least_daughter_DOT_2= at_least_daughter*DOT_2
	 label var at_least_daughter_DOT_2 "Women have at least one daughter X DOT_2"
	 
	 
	 local at_least_d = "at_least_daughter at_least_daughter_DOT_1 at_least_daughter_DOT_2"
local at_least_s = "at_least_son at_least_son_DOT_1 at_least_son_DOT_2"
	 
reg   n_children_t DOT_1  DOT_2   at_least_daughter  at_least_daughter_DOT_1  at_least_daughter_DOT_2 if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   at_least_daughter  	at_least_daughter_DOT_1    at_least_daughter_DOT_2  ) addstat(Control group mean, `C_mean') label replace


reg   n_children_t DOT_1  DOT_2  at_least_daughter   at_least_daughter_DOT_1   at_least_daughter_DOT_2   number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2   at_least_daughter_1  at_least_daughter_DOT_1   at_least_daughter_DOT_2   number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2   at_least_daughter	   at_least_daughter_DOT_1   at_least_daughter_DOT_2   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  at_least_daughter 	 at_least_daughter_DOT_1     at_least_daughter_DOT_2   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2    at_least_daughter   	at_least_daughter_DOT_1   at_least_daughter_DOT_2   number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2  at_least_daughter    	  at_least_daughter_DOT_1    at_least_daughter_DOT_2    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  at_least_daughter 	at_least_daughter_DOT_1   at_least_daughter_DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   at_least_daughter at_least_daughter_DOT_1  at_least_daughter_DOT_2  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]
	  

	

quietly probit child_post_d DOT_1  DOT_2  at_least_daughter	 at_least_daughter_DOT_1  at_least_daughter_DOT_2 if Age_bl<50, vce(cluster wedp_id)
  sum  child_post_d if treatment==0
  local C_mean = r(mean)
 margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label replace
  
  quietly probit child_post_d DOT_1  DOT_2  at_least_daughter at_least_daughter_DOT_1 at_least_daughter_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append

    
  quietly probit child_post_d DOT_1  DOT_2  at_least_daughter	     at_least_daughter_DOT_1 at_least_daughter_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append
  
  
    
  quietly probit child_post_d DOT_1  DOT_2  at_least_daughter	     at_least_daughter_DOT_1    at_least_daughter_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append
  

    
  quietly probit child_post_d DOT_1  DOT_2 at_least_daughter            at_least_daughter_DOT_1        at_least_daughter_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append
  
     lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]
	  

*********************Linear probability model 


reg child_post_d  DOT_1  DOT_2  at_least_daughter	  at_least_daughter_DOT_1 at_least_daughter_DOT_2 if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 at_least_daughter	  at_least_daughter_DOT_1 at_least_daughter_DOT_2 ) addstat(Control group mean, `C_mean') label replace


reg  child_post_d  DOT_1  DOT_2  at_least_daughter	  at_least_daughter_DOT_1 at_least_daughter_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2  at_least_daughter  	at_least_daughter_DOT_1 at_least_daughter_DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg  child_post_d  DOT_1  DOT_2   at_least_daughter  	at_least_daughter_DOT_1 at_least_daughter_DOT_2  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2  at_least_daughter    	at_least_daughter_DOT_1 at_least_daughter_DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg  child_post_d  DOT_1  DOT_2   at_least_daughter            	at_least_daughter_DOT_1 at_least_daughter_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 at_least_daughter	  at_least_daughter_DOT_1 at_least_daughter_DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) addstat(Control group mean, `C_mean') label append

reg  child_post_d  DOT_1  DOT_2  at_least_daughter	            at_least_daughter_DOT_1 at_least_daughter_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2  at_least_daughter	     at_least_daughter_DOT_1 at_least_daughter_DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_1 ] + _b[at_least_daughter_DOT_2]
	  
	  
	  save "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta", replace
	  
	  
use "/Users/mathildesage/Library/Mobile Documents/com~apple~CloudDocs/Memory thesis/Data/RE__request_for_data_from_a_few_variables_in_the_Ethiopia_WEDP_studies/WEDP Fertility Datasets/Women Entrepreneurship Development Project_DOT_clean.dta"
	  
****************************************************************** We test only son / only daughters ******************************************************************************************************
	  
	  
	  gen only_daughters = (number_daughters_bl>0 &number_sons_bl==0)
	  replace only_daughters=. if have_children_bl==.
	  label var only_daughters "Has only daughters"
	  
	   gen only_son = (number_sons_bl>0 & number_daughters_bl==0)
	  replace only_son=. if have_children_bl==.
	  label var only_son "Has only son"
	  
gen only_daughters_DOT_1=only_daughters*DOT_1
 label var only_daughters_DOT_1 "Has only daughters X DOT_1"
 
 gen only_daughters_DOT_2=only_daughters*DOT_2
 label var only_daughters_DOT_2 "Has only daughters X DOT_2"
 
 gen only_son_DOT_1=only_son*DOT_1
 label var only_son_DOT_1 "Has only son X DOT_1"
 
 gen only_son_DOT_2=only_son*DOT_2
 label var only_son_DOT_2 "Has only son X DOT_2"
 
 
 local var_reg_daughter "only_daughters only_daughters_DOT_1  only_daughters_DOT_2"
 local var_reg_son  "only_son only_son_DOT_1  only_son_DOT_2"
 
 
 **************************************************************** ONLY SON       ************************************************************************************************************
 
	 
reg   n_children_t DOT_1  DOT_2   `var_reg_son' if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `var_reg_son' ) addstat(Control group mean, `C_mean') label replace


reg   n_children_t DOT_1  DOT_2  `var_reg_son'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2   `var_reg_son'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2   `var_reg_son'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2     `var_reg_son'  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2   `var_reg_son'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `var_reg_son'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `var_reg_son' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `var_reg_son'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[only_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[only_son_DOT_2]
	  
	  
	*****PROBIT*******

 

quietly probit child_post_d DOT_1  DOT_2    `var_reg_son' if Age_bl<50, vce(cluster wedp_id)
  sum  child_post_d if treatment==0
  local C_mean = r(mean)
 margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label replace
  
  quietly probit child_post_d DOT_1  DOT_2    `var_reg_son' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append

    
  quietly probit child_post_d DOT_1  DOT_2   `var_reg_son'  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append
  
  
    
  quietly probit child_post_d DOT_1  DOT_2    `var_reg_son' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append
  

    
  quietly probit child_post_d DOT_1  DOT_2   `var_reg_son' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append
  

  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[only_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[only_son_DOT_2]
*********************Linear probability model 


reg child_post_d  DOT_1  DOT_2    `var_reg_son' if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2   `var_reg_son' ) addstat(Control group mean, `C_mean') label replace


reg  child_post_d  DOT_1  DOT_2    `var_reg_son' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `var_reg_son' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg  child_post_d  DOT_1  DOT_2     `var_reg_son' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2   `var_reg_son' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append
 
reg  child_post_d  DOT_1  DOT_2     `var_reg_son' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2   `var_reg_son'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) addstat(Control group mean, `C_mean') label append

reg  child_post_d  DOT_1  DOT_2    `var_reg_son'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2    `var_reg_son'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[only_son_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[only_son_DOT_2]
	  
 
 **************************************************************************ONLY DAUGHTERS***********************************************************
	 
reg   n_children_t DOT_1  DOT_2   `var_reg_daughter' if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `var_reg_daughter' ) addstat(Control group mean, `C_mean') label replace


reg   n_children_t DOT_1  DOT_2  `var_reg_daughter'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2   `var_reg_daughter'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2   `var_reg_daughter'   number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2     `var_reg_daughter'  number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2   `var_reg_daughter'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `var_reg_daughter'   number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `var_reg_daughter'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `var_reg_daughter'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[only_daughters_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[only_daughters_DOT_2]
	  
	  
	*****PROBIT*******

 

quietly probit child_post_d DOT_1  DOT_2    `var_reg_daughter' if Age_bl<50, vce(cluster wedp_id)
  sum  child_post_d if treatment==0
  local C_mean = r(mean)
 margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label replace
  
  quietly probit child_post_d DOT_1  DOT_2    `var_reg_daughter'     number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append

    
  quietly probit child_post_d DOT_1  DOT_2    `var_reg_daughter'    number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append
  
  
    
  quietly probit child_post_d DOT_1  DOT_2    `var_reg_daughter'    number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append
  

    
  quietly probit child_post_d DOT_1  DOT_2   `var_reg_daughter'        number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
   sum  child_post_d if treatment==0
  local C_mean = r(mean)
  margins, dydx(*) post
  outreg2 _1 using Tab2.xls, excel dec(3) ctitle("") addstat(Control group mean, `C_mean') label append
  

  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[only_daughters_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[only_daughters_DOT_2]
*********************Linear probability model 


reg child_post_d  DOT_1  DOT_2    `var_reg_daughter' if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2   `var_reg_daughter' ) addstat(Control group mean, `C_mean') label replace


reg  child_post_d  DOT_1  DOT_2    `var_reg_daughter'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `var_reg_daughter' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg  child_post_d  DOT_1  DOT_2     `var_reg_daughter' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2    `var_reg_daughter' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append
 
reg  child_post_d  DOT_1  DOT_2     `var_reg_daughter' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2   `var_reg_daughter'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) addstat(Control group mean, `C_mean') label append

reg  child_post_d  DOT_1  DOT_2    `var_reg_daughter'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
 sum  child_post_d if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2    `var_reg_daughter'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[only_daughters_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[only_daughters_DOT_2]
	  
	  
	  
	  *********************************************************** With the two interactions at least at least in the same reg   *******************************************************************************************
	  	 local at_least_d = "at_least_daughter at_least_daughter_DOT_1 at_least_daughter_DOT_2"
local at_least_s = "at_least_son at_least_son_DOT_1 at_least_son_DOT_2"
	   
reg   n_children_t DOT_1  DOT_2   `at_least_d'  `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_d'  `at_least_s') addstat(Control group mean, `C_mean') label replace


reg   n_children_t DOT_1  DOT_2  `at_least_d'  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2   `at_least_d'  `at_least_s' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2   `at_least_d'  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2    `at_least_d'  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2   `at_least_d'  `at_least_s'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `at_least_d'  `at_least_s' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children  ) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `at_least_d'  `at_least_s' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_d'  `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
     lincom _b[DOT_2] 
   lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]
   
   
    lincom _b[DOT_1] 
      lincom _b[DOT_1] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]
	  

	 
. gen no_children_bl = (have_children_bl==0)

. label var no_children_bl "have no children at baseline"


	   
reg   n_children_t DOT_1  DOT_2   `at_least_d'  `at_least_s' if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1   DOT_2   `at_least_d'  `at_least_s') addstat(Control group mean, `C_mean') label replace


reg   n_children_t DOT_1  DOT_2  `at_least_d'  `at_least_s'  number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1   DOT_2   `at_least_d'  `at_least_s' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2   `at_least_d'  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2    `at_least_d'  `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2   `at_least_d'  `at_least_s'  number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50 , vce(cluster wedp_id) 
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(  DOT_1  DOT_2 `at_least_d'  `at_least_s' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl  ) addstat(Control group mean, `C_mean') label append

reg   n_children_t DOT_1  DOT_2  `at_least_d'  `at_least_s' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id)
 sum  n_children_t if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2   `at_least_d'  `at_least_s'  number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
     lincom _b[DOT_2] 
   lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]
   
   
    lincom _b[DOT_1] 
      lincom _b[DOT_1] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]
	  

	  ************************************ Outliers ? ********
	  
	  
	  **a certain amount of women declare less children at fu1 and fu2 
	   count if  n_children_t < number_children_bl

	   *We can try to replace them with missing ? 
	   **On a 4,6% de valeurs négatives. 
	   
	   
	   ****Maybe I should try to use as an outcome le delta (children at t - children at bl), and replacing the negative value by zero or missing. 
	   
	  . gen dif =   n_children_t - number_children_bl 
(142 missing values generated)

**We need to remove outliers : 
*it is not credible to have had (FU1=> environ un an après le training, FU2=> environ 2 ans après) Donc il ne semble pas très crédible d'avoir eu plus de deux enfants entre le baseline et les FU.

***Donc on remove les outliers de dif 

replace dif=. if dif >2 
replace dif =. if dif < -2 
**48 to missing
**Negative values : 

**One outcome for which we replace negative values by zero : 

gen dif_zero = dif
replace dif_zero =0 if dif<0

gen dif_mis = dif 
replace dif_mis = . if dif<0



*******************************************We try the reg with the delta ****************************************************************

**in this outcome, the outliers are replace as missing but we kept negative values 

reg  dif  DOT_1  DOT_2  if Age_bl<50, vce(cluster wedp_id)
  sum  dif if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 ) addstat(Control group mean, `C_mean') label replace


reg   dif DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum  dif if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg  dif n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id) 
  sum dif  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl) addstat(Control group mean, `C_mean') label append

reg dif  n_children_t DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children no_children_bl ) addstat(Control group mean, `C_mean') label append

reg dif  n_children_t DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children no_children_bl if Age_bl<50, vce(cluster wedp_id)
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








***************We are going to test heterogeneity, if there is a son effect ? 

reg  dif_zero  DOT_1  DOT_2 `at_least_s' if Age_bl<50, vce(cluster wedp_id)
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg   dif_zero DOT_1  DOT_2 `at_least_s' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children `at_least_s') addstat(Control group mean, `C_mean') label append

reg  dif_zero n_children_t DOT_1  DOT_2 `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  sum dif_zero  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children `at_least_s') addstat(Control group mean, `C_mean') label append

reg dif_zero  n_children_t DOT_1  DOT_2 `at_least_s' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children `at_least_s' ) addstat(Control group mean, `C_mean') label append

reg dif_zero  n_children_t DOT_1  DOT_2 `at_least_s' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children `at_least_s') addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
     lincom _b[DOT_2] 
   lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]




*************dif_mis 



reg  dif_mis  DOT_1  DOT_2 `at_least_s' if Age_bl<50, vce(cluster wedp_id)
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 `at_least_s' ) addstat(Control group mean, `C_mean') label replace


reg   dif_mis DOT_1  DOT_2 number_children_bl `at_least_s' time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children `at_least_s') addstat(Control group mean, `C_mean') label append

reg  dif_mis  DOT_1  DOT_2 `at_least_s' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  sum dif_mis  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children `at_least_s') addstat(Control group mean, `C_mean') label append

reg dif_mis DOT_1  DOT_2 `at_least_s' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children `at_least_s' ) addstat(Control group mean, `C_mean') label append

reg dif_mis  DOT_1  DOT_2 `at_least_s' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children `at_least_s') addstat(Control group mean, `C_mean') label append


  lincom _b[DOT_1] 
   lincom _b[DOT_1 ] + _b[at_least_son_DOT_1]
   
     lincom _b[DOT_2] 
   lincom _b[DOT_2 ] + _b[at_least_son_DOT_2]

**************At least one daughter ? 




***************We are going to test heterogeneity, if there is a son effect ? 

reg  dif_zero  DOT_1  DOT_2 `at_least_d' if Age_bl<50, vce(cluster wedp_id)
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 `at_least_d' ) addstat(Control group mean, `C_mean') label replace


reg   dif_zero DOT_1  DOT_2 `at_least_d' number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children `at_least_d') addstat(Control group mean, `C_mean') label append

reg  dif_zero n_children_t DOT_1  DOT_2 `at_least_d' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  sum dif_zero  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children `at_least_d') addstat(Control group mean, `C_mean') label append

reg dif_zero  n_children_t DOT_1  DOT_2 `at_least_d' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children `at_least_d' ) addstat(Control group mean, `C_mean') label append

reg dif_zero  n_children_t DOT_1  DOT_2 `at_least_d' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  sum  dif_zero if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children `at_least_d') addstat(Control group mean, `C_mean') label append


    lincom _b[DOT_1] 
      lincom _b[DOT_1] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]




*************dif_mis 



reg  dif_mis  DOT_1  DOT_2 `at_least_d' if Age_bl<50, vce(cluster wedp_id)
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 `at_least_d') addstat(Control group mean, `C_mean') label replace


reg   dif_mis DOT_1  DOT_2 number_children_bl `at_least_d' time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan educ_sec bl_pi6 Age_bl head_hh plan_have_children `at_least_d') addstat(Control group mean, `C_mean') label append

reg  dif_mis  DOT_1  DOT_2  `at_least_d' number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id) 
  sum dif_mis  if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan educ_sec bl_pi6 Age_bl Age_bl_square head_hh plan_have_children `at_least_d') addstat(Control group mean, `C_mean') label append

reg dif_mis DOT_1  DOT_2 `at_least_d' number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children if Age_bl<50 , vce(cluster wedp_id) 
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep(DOT_1  DOT_2 number_children_bl time  married_couple WEDP_loan education_level_bl bl_pi6 Age_bl head_hh plan_have_children `at_least_d' ) addstat(Control group mean, `C_mean') label append

reg dif_mis  DOT_1  DOT_2 `at_least_d' number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children if Age_bl<50, vce(cluster wedp_id)
  sum  dif_mis if treatment==0
  local C_mean = r(mean)
outreg2  using Tab3.xls, excel dec(3) ctitle("") keep( DOT_1  DOT_2 number_children_bl time married_couple WEDP_loan education_level_bl bl_pi6 Age_bl Age_bl_square head_hh plan_have_children `at_least_d') addstat(Control group mean, `C_mean') label append

    lincom _b[DOT_1] 
      lincom _b[DOT_1] + _b[at_least_daughter_DOT_1]
   
    lincom _b[DOT_2] 
      lincom _b[DOT_2 ] + _b[at_least_daughter_DOT_2]
	  
	  
	  
	  
	  

