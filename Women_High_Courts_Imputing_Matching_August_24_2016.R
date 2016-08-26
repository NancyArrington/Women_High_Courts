###August 24-25, 2016
#Arrington, Bass, Staton, Glynn: Women and High Courts
#Imputing missing variables and Generating matched pairs via CEM and then second stage genetic matching.
#Before imputing and matching, I cleaned, reshaped, and added control variables in state: Data file name: women_highcourts_august12_2016.csv the stata .do file is august_2016_RedCap_to_highcourts_cleaning_code.do

library("foreign")
highcourts2016<-read.csv("/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/stata/women_highcourts_august22_2016.csv")



##Now need to impute missing values. 
#install.packages("Amelia")
require(Amelia)
summary(highcourts2016)
#subsetting the data for the variables we need for matching 
#here using p_filled rather than percent women
highcourts2016clean<-highcourts2016[c("state", "year", "record_id", "treated", "REGIONCONCISE", "since_UNIVSFFRG", "v2x_partipdem",  
                                      "v2x_egaldem", "v2xcl_rol",	"v2x_gender",	"v2lgfemleg",	"v2jupack",	
                                      "v2csgender" ,	"v2mefemjrn",	"v2cldmovew",	"v2cldiscw",	"v2clslavef",	
                                      "v2clprptyw",	"v2clacjstw",	"v2pepwrgen" , "drop_from_match", "p_filled")]

#v2lgqugen is factor so not imputable. removed. Same Region. Do not want imputed values for nominators to match or selectors to match--- mising values there are meaningful: missing values correspond to rows prior to our having flowcharts/info
a.out<-amelia(highcourts2016clean,  m = 5, ts = "year", cs = "state", idvars=c("REGIONCONCISE", "record_id", "treated"))

#Diagnostics
plot(a.out, which.vars = c("v2x_gender","v2x_partipdem"))
missmap(a.out)
#to see where there was missingness
View(a.out$missMatrix)
View(a.out$mu)#this is for each variable with missing, it estimates the missing and tells me the mode for each chain.
View(a.out$imputations)



#Now to make them into one data frame 
#separating the list out into data frams
first_imp<-as.data.frame(a.out$imputations$imp1)
second_imp<-as.data.frame(a.out$imputations$imp2)
third_imp<-as.data.frame(a.out$imputations$imp3)
fourth_imp<-as.data.frame(a.out$imputations$imp4)
fifth_imp<-as.data.frame(a.out$imputations$imp5)

#Matching in two stages: first exact matching on year and pre-treatment institutions. 
#Then, within those subsets we will match using a differnt algorithm: 
#used "genetic" becasue it gives us 1:1 matches and the best balance
#install.packages("cem")
library(cem)
#install.packages("MatchIt")
library("MatchIt")

#highcourts2016clean name of full data set, going to subset to just the variables we need to exact match b/c cem does NOT like NAs
highcourts2016clean_cem_subset<-highcourts2016[, c("record_id", "nominators_to_match", "selectors_to_match", "year", "treated", "drop_from_match", "state")]
highcourts2016clean_cem_subset<-na.omit(highcourts2016clean_cem_subset) #dropped us from 7637 to 6426. But any rows with missingness in these vairables should be "bad" rows -- i.e. rows generated from time setting that correspond to years before we observed any events, etc

##treatment variable needs to be 0,1. Right now I have treated==2 for observation in which there was more than one treatment in the time period. We are looking at just the FIRST treatment, so will replace those with 0 
highcourts2016clean_cem_subset$treated[which(highcourts2016clean_cem_subset$treated==2)]<-0

#generating bin cutpoints
yearcut<-c(1969, 1970.1, 1971.1, 1972.1, 1973.1, 1974.1, 1975.1, 1976.1, 1977.1, 1978.1, 1979.1, 1980.1, 1981.1, 1982.1, 1983.1, 1984.1, 1985.1, 1986.1, 1987.1, 1988.1, 1989.1, 1990.1, 1991.1, 1992.1, 1993.1, 1994.1, 1995.1, 1996.1, 1997.1, 1998.1, 1999.1, 2000.1, 2001.1, 2002.1, 2003.1, 2004.1, 2005.1, 2006.1, 2007.1, 2008.1, 2009.1, 2010.1)
nominatorscut<- c(-.1, .9, 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1, 9.1) 
selectorscut<- c(-.1, .9, 1.1, 2.1, 3.1, 4.1, 5.1, 6.1)

#coarsened exact matching
cem.1 <- matchit(treated ~ year + nominators_to_match + selectors_to_match, 
                 data = highcourts2016clean_cem_subset, method = "cem", 
                 cutpoints = list(year=yearcut, nominators_to_match=nominatorscut, selectors_to_match=selectorscut))
# 45 of 47 treated units matchd, 1491 control units matched.
cem.1$nn

#the cem.1 data is only the years and countries that matched. 
#when I merge the imputed data back in I need to make sure to keep all.x and all.y so that we have a full data set with all the necessary variables for merging in the DV later
cem.data2016 <- match.data(cem.1)
View(cem.data2016)
table(cem.data2016$subclass, cem.data2016$treated)
##So the subclass tells me which strata the treated and controlled units are in.
##But! I dont want in my subclasses any of the drop_from_match units becasue that would allow the second stage to use use treated countries as controls, whcih we dont want.

cem.data2016$subclass[which(cem.data2016$drop_from_match==1)]<-999
table(cem.data2016$subclass, cem.data2016$treated)



##Combing all the imputed data and all the cem matches back into a "full" data set.
#Im going to rename the imputed variables for each imputation, and then I am going to keep the variables from each imputation that I want to merge back into the full data set
library(plyr)
#First Imputation
first_imp <- rename(first_imp, c("since_UNIVSFFRG"="since_UNIVSFFRG_imp1",
                                "v2x_partipdem"="v2x_partipdem_imp1",  
                                 "v2x_egaldem"="v2x_egaldem_imp1", 
                                 "v2xcl_rol"="v2xcl_rol_imp1",
                                 "v2x_gender"="v2x_gender_imp1",	
                                 "v2lgfemleg"="v2lgfemleg_imp1",
                                 "v2jupack"="v2jupack_imp1",	
                                 "v2csgender"="v2csgender_imp1" ,
                                 "v2mefemjrn"="v2mefemjrn_imp1",	
                                 "v2cldmovew"="v2cldmovew_imp1",	
                                 "v2cldiscw"="v2cldiscw_imp1",	
                                 "v2clslavef"="v2clslavef_imp1",	
                                 "v2clprptyw"="v2clprptyw_imp1",	
                                 "v2clacjstw"="v2clacjstw_imp1",	
                                 "v2pepwrgen"="v2pepwrgen_imp1" , 
                                 "p_filled"="p_filled_imp1"))
first_imp_to_merge<-first_imp[, c( "record_id", 
                                   "since_UNIVSFFRG_imp1",
                                   "v2x_partipdem_imp1",  
                                   "v2x_egaldem_imp1", 
                                   "v2xcl_rol_imp1",
                                   "v2x_gender_imp1",	
                                   "v2lgfemleg_imp1",
                                   "v2jupack_imp1",	
                                   "v2csgender_imp1" ,
                                   "v2mefemjrn_imp1",	
                                   "v2cldmovew_imp1",	
                                   "v2cldiscw_imp1",	
                                   "v2clslavef_imp1",	
                                   "v2clprptyw_imp1",	
                                   "v2clacjstw_imp1",
                                   "v2pepwrgen_imp1" ,
                                   "p_filled_imp1")]


#Second Imputation
second_imp <- rename(second_imp, c( "since_UNIVSFFRG"="since_UNIVSFFRG_imp2",
                                    "v2x_partipdem"="v2x_partipdem_imp2",  
                                   "v2x_egaldem"="v2x_egaldem_imp2", 
                                   "v2xcl_rol"="v2xcl_rol_imp2",
                                   "v2x_gender"="v2x_gender_imp2",	
                                   "v2lgfemleg"="v2lgfemleg_imp2",
                                   "v2jupack"="v2jupack_imp2",	
                                   "v2csgender"="v2csgender_imp2" ,
                                   "v2mefemjrn"="v2mefemjrn_imp2",	
                                   "v2cldmovew"="v2cldmovew_imp2",	
                                   "v2cldiscw"="v2cldiscw_imp2",	
                                   "v2clslavef"="v2clslavef_imp2",	
                                   "v2clprptyw"="v2clprptyw_imp2",	
                                   "v2clacjstw"="v2clacjstw_imp2",	
                                   "v2pepwrgen"="v2pepwrgen_imp2" , 
                                   "p_filled"="p_filled_imp2"))
second_imp_to_merge<-second_imp[, c("record_id", 
                                    "since_UNIVSFFRG_imp2",
                                    "v2x_partipdem_imp2",  
                                    "v2x_egaldem_imp2", 
                                    "v2xcl_rol_imp2",
                                    "v2x_gender_imp2",	
                                    "v2lgfemleg_imp2",
                                    "v2jupack_imp2",	
                                    "v2csgender_imp2" ,
                                    "v2mefemjrn_imp2",	
                                    "v2cldmovew_imp2",	
                                    "v2cldiscw_imp2",	
                                    "v2clslavef_imp2",	
                                    "v2clprptyw_imp2",	
                                    "v2clacjstw_imp2",
                                    "v2pepwrgen_imp2" ,
                                    "p_filled_imp2")]


#Third_imputation
third_imp <- rename(third_imp, c("since_UNIVSFFRG"="since_UNIVSFFRG_imp3",
                                 "v2x_partipdem"="v2x_partipdem_imp3",  
                                 "v2x_egaldem"="v2x_egaldem_imp3", 
                                 "v2xcl_rol"="v2xcl_rol_imp3",
                                 "v2x_gender"="v2x_gender_imp3",	
                                 "v2lgfemleg"="v2lgfemleg_imp3",
                                 "v2jupack"="v2jupack_imp3",	
                                 "v2csgender"="v2csgender_imp3" ,
                                 "v2mefemjrn"="v2mefemjrn_imp3",	
                                 "v2cldmovew"="v2cldmovew_imp3",	
                                 "v2cldiscw"="v2cldiscw_imp3",	
                                 "v2clslavef"="v2clslavef_imp3",	
                                 "v2clprptyw"="v2clprptyw_imp3",	
                                 "v2clacjstw"="v2clacjstw_imp3",	
                                 "v2pepwrgen"="v2pepwrgen_imp3" , 
                                 "p_filled"="p_filled_imp3"))
third_imp_to_merge<-third_imp[, c("record_id", 
                                  "since_UNIVSFFRG_imp3",
                                  "v2x_partipdem_imp3",  
                                  "v2x_egaldem_imp3", 
                                  "v2xcl_rol_imp3",
                                  "v2x_gender_imp3",	
                                  "v2lgfemleg_imp3",
                                  "v2jupack_imp3",	
                                  "v2csgender_imp3" ,
                                  "v2mefemjrn_imp3",	
                                  "v2cldmovew_imp3",	
                                  "v2cldiscw_imp3",	
                                  "v2clslavef_imp3",	
                                  "v2clprptyw_imp3",	
                                  "v2clacjstw_imp3",
                                  "v2pepwrgen_imp3" ,
                                  "p_filled_imp3")]

#Fourth Imputaiton
fourth_imp <- rename(fourth_imp, c("since_UNIVSFFRG"="since_UNIVSFFRG_imp4",
                                    "v2x_partipdem"="v2x_partipdem_imp4",  
                                   "v2x_egaldem"="v2x_egaldem_imp4", 
                                   "v2xcl_rol"="v2xcl_rol_imp4",
                                   "v2x_gender"="v2x_gender_imp4",	
                                   "v2lgfemleg"="v2lgfemleg_imp4",
                                   "v2jupack"="v2jupack_imp4",	
                                   "v2csgender"="v2csgender_imp4" ,
                                   "v2mefemjrn"="v2mefemjrn_imp4",	
                                   "v2cldmovew"="v2cldmovew_imp4",	
                                   "v2cldiscw"="v2cldiscw_imp4",	
                                   "v2clslavef"="v2clslavef_imp4",	
                                   "v2clprptyw"="v2clprptyw_imp4",	
                                   "v2clacjstw"="v2clacjstw_imp4",	
                                   "v2pepwrgen"="v2pepwrgen_imp4" , 
                                   "p_filled"="p_filled_imp4"))
fourth_imp_to_merge<-fourth_imp[, c("record_id", 
                                    "since_UNIVSFFRG_imp4",
                                    "v2x_partipdem_imp4",  
                                    "v2x_egaldem_imp4", 
                                    "v2xcl_rol_imp4",
                                    "v2x_gender_imp4",	
                                    "v2lgfemleg_imp4",
                                    "v2jupack_imp4",	
                                    "v2csgender_imp4" ,
                                    "v2mefemjrn_imp4",	
                                    "v2cldmovew_imp4",	
                                    "v2cldiscw_imp4",	
                                    "v2clslavef_imp4",	
                                    "v2clprptyw_imp4",	
                                    "v2clacjstw_imp4",
                                    "v2pepwrgen_imp4" ,
                                    "p_filled_imp4")]


#Fifth Imputation
fifth_imp <- rename(fifth_imp, c("since_UNIVSFFRG"="since_UNIVSFFRG_imp5",
                                "v2x_partipdem"="v2x_partipdem_imp5",  
                                 "v2x_egaldem"="v2x_egaldem_imp5", 
                                 "v2xcl_rol"="v2xcl_rol_imp5",
                                 "v2x_gender"="v2x_gender_imp5",	
                                 "v2lgfemleg"="v2lgfemleg_imp5",
                                 "v2jupack"="v2jupack_imp5",	
                                 "v2csgender"="v2csgender_imp5" ,
                                 "v2mefemjrn"="v2mefemjrn_imp5",	
                                 "v2cldmovew"="v2cldmovew_imp5",	
                                 "v2cldiscw"="v2cldiscw_imp5",	
                                 "v2clslavef"="v2clslavef_imp5",	
                                 "v2clprptyw"="v2clprptyw_imp5",	
                                 "v2clacjstw"="v2clacjstw_imp5",	
                                 "v2pepwrgen"="v2pepwrgen_imp5" , 
                                 "p_filled"="p_filled_imp5"))
fifth_imp_to_merge<-fifth_imp[, c( "record_id", 
                                   "since_UNIVSFFRG_imp5",
                                   "v2x_partipdem_imp5",  
                                   "v2x_egaldem_imp5", 
                                   "v2xcl_rol_imp5",
                                   "v2x_gender_imp5",	
                                   "v2lgfemleg_imp5",
                                   "v2jupack_imp5",	
                                   "v2csgender_imp5" ,
                                   "v2mefemjrn_imp5",	
                                   "v2cldmovew_imp5",	
                                   "v2cldiscw_imp5",	
                                   "v2clslavef_imp5",	
                                   "v2clprptyw_imp5",	
                                   "v2clacjstw_imp5",
                                   "v2pepwrgen_imp5" ,
                                   "p_filled_imp5")]


####Merging Imputations with cem data
#cem.data2016 has 10 variables. 
#I want a full data set that has 
  #(1) all of the country_year rows: highcourts2016[, c("record_id", "nominators_to_match", "selectors_to_match", "year", "treated", "drop_from_match", "state")]
  #(2) all of the imputed data: first_imp, second_imp...
  #(3) the cem.match data. cem.data
#First, to get all the rows (some rows dropped out early when I required only complete cases for cem matching
merge_back_in<-highcourts2016[, c("record_id", "nominators_to_match", "selectors_to_match", "year", "treated", "drop_from_match", "state")]

cem.data2016<-merge(cem.data2016, merge_back_in, by=c("record_id", "nominators_to_match", "selectors_to_match", "year", "treated", "drop_from_match", "state"), all.x=TRUE, all.y=TRUE)
cem.data2016<-merge(cem.data2016, first_imp_to_merge, by="record_id", all.x=TRUE, all.y=TRUE)
cem.data2016<-merge(cem.data2016, second_imp_to_merge, by="record_id", all.x=TRUE, all.y=TRUE)
cem.data2016<-merge(cem.data2016, third_imp_to_merge, by="record_id", all.x=TRUE, all.y=TRUE)
cem.data2016<-merge(cem.data2016, fourth_imp_to_merge, by="record_id", all.x=TRUE,all.y=TRUE)
cem.data2016<-merge(cem.data2016, fifth_imp_to_merge, by="record_id", all.x=TRUE, all.y=TRUE)
View(cem.data2016)

#ok, now I have one data set with the exact match strata and all the imputationed data.
#but now there are missing vlaues in subclass for countries that were not cem matched and should not be matched in the second stage
#999 is already the DONT USE THESE subclass, so I will use that
cem.data2016$subclass[is.na(cem.data2016$subclass)]<-999
table(cem.data2016$subclass) #yeep, lots of 999s

#saving becasue becasue
#save(cem.data2016, file="/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/cem_data_August2016.RData")

#What I need to do now:
#For each value of subclass -- each exact match goruping-- I need to:
#(1) execute the second stage of matching on 
    #(2)each of the five imputed data sets. 
#(3) then generate a new indicator variable for whether a row got matched in the second round.
#Going to make a monster data set.

#what are my subclasses:
table(cem.data2016$subclass)
##strata 130, 264, 462, 493 have only two observations in them
# the others 12 28 42 52 62 72 95 129 154 159 167 172 180 194 195 208 213 221 222 235 241 273 279 470 481 493
#have multiple


#install.packages("Matching")
library("Matching")
#install.packages("rgenoud")
library("rgenoud")


####Second stage matching, imputation 1####
#Code help from QuanTM##
##will need to do this for each of the five imputed data sets##
classes = sort(unique(cem.data2016$subclass))
fname <- function(x) paste("genetic_imp", x, sep="") 
new_col_names = as.vector(sapply(classes, fname))

for (i in 1:length(classes)){
  class = classes[i] # the class for this iteration 
  new_col_name = new_col_names[i] # the coresponding new_colnames
  
  genetic_imp <- matchit(treated ~ since_UNIVSFFRG_imp1+v2x_partipdem_imp1  +v2x_egaldem_imp1 
                         +v2xcl_rol_imp1+v2x_gender_imp1+v2lgfemleg_imp1+v2jupack_imp1+
                           v2csgender_imp1+v2mefemjrn_imp1+v2cldmovew_imp1+v2cldiscw_imp1+	
                           v2clslavef_imp1+v2clprptyw_imp1+v2clacjstw_imp1+v2pepwrgen_imp1+p_filled_imp1, 
                         data=cem.data2016[cem.data2016$subclass==class,], method="genetic")
  
  matrix_rows = as.integer(rownames(genetic_imp$match.matrix))
  matrix_values = as.integer(as.vector(genetic_imp$match.matrix))
  rows = c(matrix_rows, matrix_values)
  rows = rows[!is.na(rows)]
  rows = unique(rows)
  cem.data2016[, new_col_name] <- 0
  cem.data2016[rows, new_col_name] <- 1
}

##So that created a new column for each subclass that is filled with ones for each treated and matched-control unit
##need to combine the columns so that I have a variable for whether this observation was matched at all
#row sum across all the genetic matching dummies to create "genetic_two_stage_matched_imp1", an indicator for whether a country was matched in the second stage for the first imputed data set.
cem.data2016$genetic_two_stage_matched_imp1 <- rowSums(subset(cem.data2016, select=genetic_imp12:genetic_imp493))

table(cem.data2016$genetic_two_stage_matched_imp1)
table(cem.data2016$genetic_two_stage_matched_imp1, cem.data2016$treated)
table(cem.data2016$genetic_two_stage_matched_imp1, cem.data2016$subclass)
#subclass 167 has seven units that were matched... maybe two treated units matched to the same control?
table(cem.data2016$treated[which(cem.data2016$subclass==167 & cem.data2016$genetic_two_stage_matched_imp1==1)], cem.data2016$subclass[which(cem.data2016$subclass==167 & cem.data2016$genetic_two_stage_matched_imp1==1)])
#yep, 4 treated units and three control units. this must be 1991
table(cem.data2016$year[which(cem.data2016$subclass==167 & cem.data2016$genetic_two_stage_matched_imp1==1)], cem.data2016$subclass[which(cem.data2016$subclass==167 & cem.data2016$genetic_two_stage_matched_imp1==1)])
  #1992!


###For each imputation there may be differnet matches. Repeating the steps above for each imputed data set


#### 2nd stage matching for second imputed data set#### 
#imputation 2. To do this I need to re do the loop telling r to estimate using the imp2 data
#just going to save over the genetic_imp12:genetic imp_493 columns

classes = sort(unique(cem.data2016$subclass))
fname <- function(x) paste("genetic_imp", x, sep="") 
new_col_names = as.vector(sapply(classes, fname))

for (i in 1:length(classes)){
  class = classes[i] # the class for this iteration 
  new_col_name = new_col_names[i] # the coresponding new_colnames
  
  genetic_imp <- matchit(treated ~ since_UNIVSFFRG_imp2+v2x_partipdem_imp2+v2x_egaldem_imp2 
                         +v2xcl_rol_imp2+v2x_gender_imp2+v2lgfemleg_imp2+v2jupack_imp2+
                           v2csgender_imp2+v2mefemjrn_imp2+v2cldmovew_imp2+v2cldiscw_imp2+	
                           v2clslavef_imp2+v2clprptyw_imp2+v2clacjstw_imp2+v2pepwrgen_imp2+p_filled_imp2, 
                         data=cem.data2016[cem.data2016$subclass==class,], method="genetic")
  
  matrix_rows = as.integer(rownames(genetic_imp$match.matrix))
  matrix_values = as.integer(as.vector(genetic_imp$match.matrix))
  rows = c(matrix_rows, matrix_values)
  rows = rows[!is.na(rows)]
  rows = unique(rows)
  cem.data2016[, new_col_name] <- 0
  cem.data2016[rows, new_col_name] <- 1
}


##So that created a new column for each subclass that is filled with ones for each treated and matched contro unit
##need to combine the columns
cem.data2016$genetic_two_stage_matched_imp2 <- rowSums(subset(cem.data2016, select=genetic_imp12:genetic_imp493))


table(cem.data2016$genetic_two_stage_matched_imp2)
table(cem.data2016$genetic_two_stage_matched_imp2, cem.data2016$subclass)
table(cem.data2016$genetic_two_stage_matched_imp2, cem.data2016$treated)



####Second stage matching, Third Imputation####
classes = sort(unique(cem.data2016$subclass))
fname <- function(x) paste("genetic_imp", x, sep="") 
new_col_names = as.vector(sapply(classes, fname))

for (i in 1:length(classes)){
  class = classes[i] # the class for this iteration 
  new_col_name = new_col_names[i] # the coresponding new_colnames
  
  genetic_imp <- matchit(treated ~ since_UNIVSFFRG_imp3+v2x_partipdem_imp3+v2x_egaldem_imp3 
                         +v2xcl_rol_imp3+v2x_gender_imp3+v2lgfemleg_imp3+v2jupack_imp3+
                           v2csgender_imp3+v2mefemjrn_imp3+v2cldmovew_imp3+v2cldiscw_imp3+	
                           v2clslavef_imp3+v2clprptyw_imp3+v2clacjstw_imp3+v2pepwrgen_imp3+p_filled_imp3, 
                         data=cem.data2016[cem.data2016$subclass==class,], method="genetic")
  
  matrix_rows = as.integer(rownames(genetic_imp$match.matrix))
  matrix_values = as.integer(as.vector(genetic_imp$match.matrix))
  rows = c(matrix_rows, matrix_values)
  rows = rows[!is.na(rows)]
  rows = unique(rows)
  cem.data2016[, new_col_name] <- 0
  cem.data2016[rows, new_col_name] <- 1
}


##So that created a new column for each subclass that is filled with ones for each treated and matched contro unit
##need to combine the columns
cem.data2016$genetic_two_stage_matched_imp3 <- rowSums(subset(cem.data2016, select=genetic_imp12:genetic_imp493))


table(cem.data2016$genetic_two_stage_matched_imp3)
table(cem.data2016$genetic_two_stage_matched_imp3, cem.data2016$subclass)
table(cem.data2016$genetic_two_stage_matched_imp3, cem.data2016$treated)



####Second stage matching, Fourth Imputation####
classes = sort(unique(cem.data2016$subclass))
fname <- function(x) paste("genetic_imp", x, sep="") 
new_col_names = as.vector(sapply(classes, fname))

for (i in 1:length(classes)){
  class = classes[i] # the class for this iteration 
  new_col_name = new_col_names[i] # the coresponding new_colnames
  
  genetic_imp <- matchit(treated ~ since_UNIVSFFRG_imp4+v2x_partipdem_imp4+v2x_egaldem_imp4 
                         +v2xcl_rol_imp4+v2x_gender_imp4+v2lgfemleg_imp4+v2jupack_imp4+
                           v2csgender_imp4+v2mefemjrn_imp4+v2cldmovew_imp4+v2cldiscw_imp4+	
                           v2clslavef_imp4+v2clprptyw_imp4+v2clacjstw_imp4+v2pepwrgen_imp4+p_filled_imp4, 
                         data=cem.data2016[cem.data2016$subclass==class,], method="genetic")
  
  matrix_rows = as.integer(rownames(genetic_imp$match.matrix))
  matrix_values = as.integer(as.vector(genetic_imp$match.matrix))
  rows = c(matrix_rows, matrix_values)
  rows = rows[!is.na(rows)]
  rows = unique(rows)
  cem.data2016[, new_col_name] <- 0
  cem.data2016[rows, new_col_name] <- 1
}


##So that created a new column for each subclass that is filled with ones for each treated and matched contro unit
##need to combine the columns
cem.data2016$genetic_two_stage_matched_imp4 <- rowSums(subset(cem.data2016, select=genetic_imp12:genetic_imp493))


table(cem.data2016$genetic_two_stage_matched_imp4)
table(cem.data2016$genetic_two_stage_matched_imp4, cem.data2016$subclass)
table(cem.data2016$genetic_two_stage_matched_imp4, cem.data2016$treated)



####second stage matching, Fifth Imputation####
classes = sort(unique(cem.data20162016$subclass))
fname <- function(x) paste("genetic_imp", x, sep="") 
new_col_names = as.vector(sapply(classes, fname))

for (i in 1:length(classes)){
  class = classes[i] # the class for this iteration 
  new_col_name = new_col_names[i] # the coresponding new_colnames
  
  genetic_imp <- matchit(treated ~ since_UNIVSFFRG_imp5+v2x_partipdem_imp5+v2x_egaldem_imp5 
                         +v2xcl_rol_imp5+v2x_gender_imp5+v2lgfemleg_imp5+v2jupack_imp5+
                           v2csgender_imp5+v2mefemjrn_imp5+v2cldmovew_imp5+v2cldiscw_imp5+	
                           v2clslavef_imp5+v2clprptyw_imp5+v2clacjstw_imp5+v2pepwrgen_imp5+p_filled_imp5, 
                         data=cem.data2016[cem.data2016$subclass==class,], method="genetic")
  
  matrix_rows = as.integer(rownames(genetic_imp$match.matrix))
  matrix_values = as.integer(as.vector(genetic_imp$match.matrix))
  rows = c(matrix_rows, matrix_values)
  rows = rows[!is.na(rows)]
  rows = unique(rows)
  cem.data2016[, new_col_name] <- 0
  cem.data2016[rows, new_col_name] <- 1
}


##So that created a new column for each subclass that is filled with ones for each treated and matched contro unit
##need to combine the columns

cem.data2016$genetic_two_stage_matched_imp5 <- rowSums(subset(cem.data2016, select=genetic_imp12:genetic_imp493))


table(cem.data2016$genetic_two_stage_matched_imp5)
table(cem.data2016$genetic_two_stage_matched_imp5, cem.data2016$subclass)
table(cem.data2016$genetic_two_stage_matched_imp5, cem.data2016$treated)

####Matched Countries, export####
cem.data2016$need_DV<-rowSums(subset(cem.data2016, select=genetic_two_stage_matched_imp1:genetic_two_stage_matched_imp5))


matched_countries_august25_2016<-cem.data2016[, c("record_id","year", "treated", "subclass","genetic_two_stage_matched_imp1",
                                             "genetic_two_stage_matched_imp2" ,"genetic_two_stage_matched_imp3", 
                                              "genetic_two_stage_matched_imp4", "genetic_two_stage_matched_imp5","need_DV")]

matched_countries_august25_2016<-subset(matched_countries_august25_2016, need_DV>0 )

####Spreadsheet, matched countries need DV####
write.csv(matched_countries_august25_2016, file="/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/matched_countries_august25_2016.csv")


####Women and High Courts, August 25 data####
write.dta(cem.data2016, file="/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/women_high_courts_aug_25_2016.dta")

