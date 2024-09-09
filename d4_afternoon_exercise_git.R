library(tidyverse)
library(broom)
library(dplyr)
library(ggplot2)

dnm <- read_csv(file = "/Users/cmdb/qbb2024-answers/aau1043_dnm.csv")
head(dnm)

ages <- read_csv(file = "/Users/cmdb/qbb2024-answers/aau1043_parental_age.csv")
#head(ages)


dnm_summary <- dnm %>% 
  group_by(Proband_id) %>% 
  summarize(n_paternal_dnm = sum (Phase_combined == "father", na.rm = TRUE),
            n_maternal_dnm = sum (Phase_combined == "mother", na.rm = TRUE))

dnm_summary


dnm_by_parental_age <- left_join(dnm_summary, ages, by ="Proband_id")

#2.1
#1. the count of maternal de novo mutations vs. maternal age

lm(data = dnm_by_parental_age, 
   formula = n_maternal_dnm ~ 1 + Mother_age) %>%
  summary()

ggplot(data = dnm_by_parental_age, 
        mapping = aes(x = Mother_age, y = n_maternal_dnm)) +
   geom_point() 

#2. the count of paternal de novo mutations vs. paternal age
lm(data = dnm_by_parental_age, 
   formula = n_paternal_dnm ~ 1 + Father_age) %>%
  summary()

ggplot(data = dnm_by_parental_age, 
       mapping = aes(x = Father_age, y = n_paternal_dnm)) +
  geom_point() 

#2.2 Now that you’ve visualized these relationships, you’re curious whether they’re statistically significant. Fit a linear regression model to the data using the lm() function.
#1. What is the “size” of this relationship? In your own words, what does this mean? Does this match what you observed in your plots in step 2.1?
#Mother relationship between age and denovo mutations is highly significant and women accrue ~2.5 per year, compared to men who accrue ~10; this matches the plots. For father it was also very significant which matched the plot.
#2. The relationship is highly significant as determined by p values much less than 0.05, at <2e-16. 


lm(data = dnm_by_parental_age, 
   formula = n_paternal_dnm ~ 1 + Father_age) %>%
  summary()

ggplot(data = dnm_by_parental_age, 
       mapping = aes(x = Father_age, y = n_paternal_dnm)) +
  geom_point() 

#2.3 As before, fit a linear regression model, but this time to test for an association between paternal age and paternally inherited de novo mutations.
#1. What is the “size” of this relationship? In your own words, what does this mean? Does this match what you observed in your plots in step 6? The relationship between paternal age and denovo mutation is highly significant and clearly trend in correlation with one another. 
#2. Is this relationship significant? How do you know? In your own words, what does this mean? The relationship is highly significant as determined by p values much less than 0.05, at <2e-16. 

#Step 2.4
#Using your results from step 2.3, predict the number of paternal DNMs for a proband with a father who was 50.5 years old at the proband’s time of birth. Record your answer and your work (i.e. how you got to that answer).
#521.4792 dnm

lm(data = dnm_by_parental_age, 
   formula = n_paternal_dnm ~ 1 + Father_age) %>%
  summary()

ggplot(data = dnm_by_parental_age, 
       mapping = aes(x = Father_age, y = n_paternal_dnm)) +
  geom_point() 


Father_age <- 50.5
Pathernal_dnm_per_year <- 10.32632
Pred_Paternal_dnm_per_year_50.5yrs <- Father_age * Pathernal_dnm_per_year
cat(Pred_Paternal_dnm_per_year_50.5yrs)

#2.5

dnm_summary <- dnm %>% 
  group_by(Proband_id) %>% 
  summarize(n_paternal_dnm = sum (Phase_combined == "father", na.rm = TRUE),
            n_maternal_dnm = sum (Phase_combined == "mother", na.rm = TRUE))

dnm_all <- dnm_summary %>% 
  pivot_longer(cols = c(n_paternal_dnm, n_maternal_dnm), 
                names_to = "Type", 
                values_to = "Count")

ggplot(dnm_all) + 
         geom_histogram(aes(x = Count, fill = Type), 
                        alpha = 0.5, binwidth = 1, position = 'identity') +
        labs(title = "Distribution of Maternal and Paternal DNMs per Proband", 
             x = "Number of DNMs", y = "Frequency") + 
         scale_fill_manual(name = "Type of DNMs", 
                           values = c("n_paternal_dnm" = 'blue', "n_maternal_dnm" = 'red'))
theme_minimal()
                           
 #2.6 
#What statistical test did you choose? 
#1. Why? A T-Test makes sense here since we are comparing 2 things, since the paternal and maternal data came from the same proband in each case, a paried T-Test makes the most sense.

dnm_summary <- dnm %>%
  group_by(Proband_id) %>%
  summarize(n_paternal_dnm = sum(Phase_combined == "father", na.rm = TRUE), 
            n_maternal_dnm = sum(Phase_combined == "mother", na.rm = TRUE))

t_test_result <- t.test(dnm_summary$n_paternal_dnm, 
                        dnm_summary$n_maternal_dnm, 
                        paired = TRUE)       
print(t_test_result)

#2. There is a significant difference of maternally vs paternally inherited dnms per proband as indicated by the p-value of < 2.2e-16. The mean difffernce indicated that men provide 39.2 more dnms than women. 


       
      
