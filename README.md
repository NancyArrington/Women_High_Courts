# Women_High_Courts
Arrington, Bass, Staton, Glynn: Women and High Courts
August 2016

The attached files show steps taken to generate matches for the difference-in-differences analysis for Arrington et al Women and High Courts Project.

For the past several years, a research team has summarized the constitutionally outlined  appointment processes of peak courts. Constitutions were accessed through the Comparative Constitutions Project. Research assistants were tasked with identifying the sections of a constitution that described the selection and removal processes, then they were asked to depict these processes visually via flowcharts. These visual representations of selection processes help us to more comprehensively understand the actors, relationships, and strategic tensions involved in the selection of high court justices. Research Assistants uploaded their work into a RedCap database. The cleaning processes of this database is still ongoing. 

The RedCap data export for August 2016 is “VDemRedcapExportAug2016.csv”.


The exported data was reshaped, time-set, and expanded in Stata. The code for this is located in “august_2016_RedCap_to_highcourts_cleaning_code”.

Multiple Imputation for filling in missing values of matching variables and the procedures used for matching are located in the R file “Women_High_Courts_Imputing_Matching_August_24_2016.R”.

We implemented a two-stage matching protocol in which treated countries were first exact matched to potential control countries on the year and the pre-treatment institutions of interest. Then, for each of the five imputed data sets and within the exact matching groupings, each treated unit was matched to one control unit based on several relevant indices from the Varieties of Democracy project via the genetic matching algorithm in the package “matchit”.

A n excel file of the countries matched is “matched_countries_august_2016.xlsx”. The columns “genetic_two_stage_matched_imp1” through “genetic_two_stage_matched_imp5” are indicator variables for whether a row was matched for each of the five imputed data sets. Treated countries — as expected— were matched in each imputed data set.  Some control unites were matched in all imputed data sets, others were only matched in one or a few of the imputed data sets, suggesting that the matching algorithm is sensitive to changes in the values of the matching variables. 

At the time of this matching and GitHub upload, neither Nancy Arrington, Jeff Staton, nor Adam Glynn has seen any of the dependent variables (the proportion of women on a court and whether there was at least one woman on the court).

Leeann Bass and a small team of research assistants have been collecting data on the gender composition of peak courts. Leeann has not seen or discussed the research design, what constitutes a treatment, which countries have been treated, or how countries were matched. Leeann was given a list of countries and year ranges that included both treated countries and likely matched countries based off of a preliminary matching analysis conducted in fall of 2015.  Leeann and her team will continue to collect the dependent variables for the matched countries for the ten years prior and ten years after the institutional change.

Matching may change over time if — through the review and revision process — it becomes necessary to add additional control and matching variables. Moreover, for the analysis of whether at least one woman is on the court, we will need to re-match countries based on whether there was a woman on the court pre-treatment. 

To analyze the effects of institutional change on the proportion of women on the court and on the likelihood at least one woman will be on the court, we will follow recommendations outlined in chapter 5 of  Angriest and Pischke (2009) “Mostly Harmless Econometrics.”

Questions can be directed to Nancy Arrington at nbarrin@emory.edu.










