library(tidyverse)

#1:Load the data
#2: load tidyverse- at top of script. 
#3: load the data set and assign to the variable df; confirm SUBJECT is first. 

df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
#head(df)


# Create SUBJECT column and reorder columns
df <- df %>%
  mutate(SUBJECT = str_extract(SAMPID, "[^-]+-[^-]+"), .before = 1) %>%
  select(SUBJECT, everything())
#head(df)  # Confirms the SUBJECT column is first


#4: Find the two SUBJECTs with the most and least samples
#2 samples with most: K-562 and GTEX-NPJ8; samples with least: GTEX-1JMI6 and GTEX-1PAR6, K-562 having the most makes sense as it is an immortalized cell line so lots is available and it is easy to get. 
subject_summary <- df %>%
  group_by(SUBJECT) %>%
  summarize(sample_count = n(), .groups = "drop") %>%
  arrange(desc(sample_count))

top_two_subjects <- head(subject_summary, 2)
bottom_two_subjects <- tail(subject_summary, 2)

#print(top_two_subjects)
#print(bottom_two_subjects)

#5: Find the two SMTSDs with the most and least samples
#Two SMTSD tissue types with the most samples: whole blood and muscle-skeletal; two with the least: Fallopian tube and Kidney-Medulla.Blood has the most because it is easy to aquire and there is lots of it, similar for muscle. Fallopian tube is lower as only women will have that and it is more invasive. Kidney medulla is also more invasive and much less tissue is available. 
tissue_summary <- df %>%
  group_by(SMTSD) %>%
  summarize(sample_count = n(), .groups = "drop") %>%
  arrange(desc(sample_count))

top_two_tissues <- head(tissue_summary, 2)
bottom_two_tissues <- tail(tissue_summary, 2)

#print(top_two_tissues)
#print(bottom_two_tissues)

#6: Filter for Subject GTEX-NPJ8 and save as a new object; find tissue with most sample, and it is whole blood
df_npj8 <- df %>%
  filter(SUBJECT == "GTEX-NPJ8")

# Find the tissue with the most samples for GTEX-NPJ8
tissue_summary_npj8 <- df_npj8 %>%
  group_by(SMTSD) %>%
  summarize(sample_count = n(), .groups = "drop") %>%
  arrange(desc(sample_count))

#print(tissue_summary_npj8)

# Explore columns 15 to 20 for the most common tissue in GTEX-NPJ8
most_common_tissue <- tissue_summary_npj8$SMTSD[1]

#6 what is different between these different samples is how they were analyzed. 
df_npj8 %>%
  filter(SMTSD == most_common_tissue) %>%
  select(15:20) %>%
  head() %>%
  print()
summary(most_common_tissue)


#7 Filter out NA values in SMATSSCR
df_filtered <- df %>%
  filter(!is.na(SMATSSCR))

# Check if df_filtered is empty or not
if (nrow(df_filtered) == 0) {
  stop("Filtered dataframe is empty. Check your data.")
}

# Count how many SUBJECTs have a mean SMATSSCR score of 0
subject_smatsscr <- df_filtered %>%
  group_by(SUBJECT) %>%
  summarize(mean_smatsscr = mean(SMATSSCR, na.rm = TRUE), .groups = "drop") %>%
  #print() #mean SMATSSCR


# Check if subject_smatsscr is empty
if (nrow(subject_smatsscr) == 0) {
  stop("No SUBJECTs found in the summarized data. Check your data.")
}

count_zero_scores <- sum(subject_smatsscr$mean_smatsscr == 0)

#print(count_zero_scores) #6 there are 15 subjects with a SMATSSCR of 0

# Describe the distribution of mean SMATSSCR scores
summary(subject_smatsscr$mean_smatsscr) %>%
  print() #7 a possible way to present this data would be in a histogram to visualize the SMATSSCR distribution. 

