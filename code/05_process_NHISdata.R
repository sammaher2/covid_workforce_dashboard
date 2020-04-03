library(expss)

#if(!file.exists("cache/cps_co.Rdata")){
 # special.locations <- ind_refs_nhis %>% select(-dplyr::starts_with("ind")) %>% names()

  
  
#makes variables binary for conidtion. 1 = yes, 0 = no
#deletes original columns
   nhis_recorded <- nhis_data %>%
               mutate(
               over60=ifelse(age>=60,1,0),
               over50 = ifelse(age>=50,1,0),
               over40 = ifelse(age>=40,1,0),
               heart_cond = ifelse(heartconev == 2,1,0),
               coronary_dis = ifelse(cheartdiyr == 2,1,0),
               hypertension = ifelse(hypertenyr == 2,1,0),
               diabetes = ifelse(diabeticev == 2 | diabeticev ==3,1,0), #check this one
               cancer = ifelse(cancerev == 2,1,0),
               male = ifelse(sex == 1,1,0),
               hepatic_dis = ifelse(liverconyr == 2,1,0),
               kidney_dis = ifelse(kidneywkyr == 2,1,0),
               smoker = ifelse(smokfreqnow == 2| smokfreqnow == 3,1,0),
               immunodef = ifelse(imspstl == 2,1,0),
               hepatitus = ifelse(hepatev == 2,1,0),
               asthma = ifelse(asthmastil == 2,1,0),
               high_cholesterol = ifelse(cholhighyr == 2,1,0),
               insurance = ifelse(hinotcove == 2,1,0 ),
               care_afford = ifelse(ybarcare == 2,1,0),
               delay_cost = ifelse(delaycost ==2,1,0),
               bmi = ifelse(bmi > 25.5,1, 0),
               ever_smoked =ifelse(smokev == 2,1,0),
               child_0_9 = ifelse(yngch <= 9 | eldch <=9,1,0),
               child_0_9 =ifelse(is.na(child_0_9) == TRUE, 0, child_0_9),
               employed = ifelse(empstat == 10 | empstat == 11 | empstat == 20 | empstat == 21,1,0)
                         ) %>%
     #select(-c(ind,occ)) %>%
          select(-c(heartconev,cheartdiyr,hypertenyr,
            diabeticev,cancerev,sex,liverconyr,
            kidneywkyr,smokfreqnow,imspstl,hepatev,
            asthmastil, cholhighyr, hinotcove,
            ybarcare, occ, ind, delaycost, imspstl,
            imspmed, imspchc, hyp2time, smokfreqx, 
            smokfreqnow, cigslongfs,bmicalc,smokev,
            eldch, yngch,smoker, smokev,empstat)
          ) %>%
               apply_labels(
                 over60 = "age 60 years or more",
                 over50 = "age 50 years or more",
                 over40 = "age 50 years or more",
                 heart_cond = "ever diagnosed with heart condition",
                 coronary_dis = "ever diagnosed as having coronary heart disease",
                 hypertension = "had hypertension, past 12 months",
                 diabetes = "ever had diabetes", #check this one
                 cancer = "ever had cancer",
                 hepatic_dis = "ever had liver condition",
                 kidney_dis = "ever had kidney disease",
                # smoker = "smokes currently",
                 immunodef = "has weakened immune system",
                 hepatitus = "ever had hepatitus",
                 asthma = "currently has asthma",
                 high_cholesterol = "has high cholesterol, last 12 months",
                 insurance = "is covered by health insurance, any type",
                 care_afford = "needed, but couldn't afford medical care, last 12 months",
                 delay_cost = "delayed medical care due to cost, last 12 months",
                 child_0_9 = "has a child below 9 in household",
                 ever_smoked = "has smoked more than 100 cigs in life",
                 bmi = "body mass index over 25.5"
                 #smoke_ever = "ever smoked more than 100 cigs in life"
           ) %>%
              mutate(essential = ifelse(is.na(essential) == TRUE,0,1),
                          critical_sub = ifelse(is.na(critical_sub) == TRUE,0,1),
                          essential = ifelse(is.na(essential) == TRUE,0,1),
                          hospital = ifelse(is.na(hospital) == TRUE,0,1),
                          hospitals_plus = ifelse(is.na(hospitals_plus) == TRUE,0,1),
                          nursing_facilities = ifelse(is.na(nursing_facilities) == TRUE,0,1)
                          ) %>%
               rename(ind = indstrn104, occ = occupn104) #%>%
               # mutate(risk_sum = sum(heart_cond, coronary_dis, hypertension, diabetes,
               #                       cancer, hepatic_dis, immunodef, hepatitus, asthma,
               #                       high_cholesterol, ever_smoked, bmi)) %>%
               # mutate(over60_plus_risk = ifelse(risk_sum >= 1, 1, 0)) %>%
               # select(-risk_sum)
               # 
               # 
               
               
               
               
               
               
               
              
      # mutate(over60_plus_risk = if_else(over60 == 1 & any(heart_cond ==1,
      #                                                         coronary_dis ==1,
      #                                                         hypertension ==1,
      #                                                         diabetes ==1,
      #                                                         cancer ==1,
      #                                                         hepatic_dis==1,
      #                                                         kidney_dis ==1,
      #                                                         #smoker ==1,
      #                                                         immunodef ==1,
      #                                                         hepatitus ==1,
      #                                                         asthma ==1,
      #                                                         high_cholesterol ==1,
      #                                                         ever_smoked ==1,
      #                                                         bmi ==1), 1, 0)) %>%
      #           mutate(test = if_else(over60 == 1 & any(heart_cond ==1,
      #                                                   coronary_dis ==1), 1, 0))
          
   
   
   
   #add new variables for over 60 AND risk factor
               
          
   
   
