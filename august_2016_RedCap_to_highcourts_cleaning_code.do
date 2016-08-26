*August 2016
*Arrington, Bass, Staton, Glynn: women and high courts
*Cleaning, reshaping, and adding matching variables to RedCap Export


*starting with download from RedCap, raw .csv
insheet using "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/VDemRedcapExportAug2016.csv", comma

*subsetting general inforamtion
keep if redcap_event_name == "general_informatio_arm_1"
drop coder_name coder_name_other codeable type_coder peak_identified court_name process_type flowchart flowchart_conf actors rectangles diamonds event_notes did_you_translate translated_text translator_name other_tranlsator_name process_complete flowchart_change which_year_compared describe_change significant_change type_of_change significance_justification changes_is_this_a_new_constituti changes_is_this_a_new_institutio new_institution_explanation judges_selected_individually_or_ describe_selected_individually_o number_nominators number_selectors complication legislature_involved changes_notes changes_over_time_complete
save general_information, replace
clear

*subsetting appointment changes 
insheet using "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/VDemRedcapExportAug2016.csv", comma
keep if redcap_event_name== "appointment_change_arm_1"
drop constitutional_event constitutional_event_other state state_other year language language_other translation constitution_complete coder_name coder_name_other codeable type_coder peak_identified court_name process_type flowchart flowchart_conf actors rectangles diamonds event_notes did_you_translate translated_text translator_name other_tranlsator_name process_complete
save appointment_changes, replace
clear

*getting the "right" appointment information. About 10% of observations were double or triple coded. The double coded events are being reconciled. 
*Those that have been reconciled have an indicator variable for which coder was "right": process_complete==2
*These are where the secnd coder is "right"
insheet using "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/VDemRedcapExportAug2016.csv", comma
browse record_id if process_complete==2 & redcap_event_name=="appointment_2_arm_1"
*These are the observations that I need to delete from the Appointment 1 sheet --the version in Appoitnment 1 is incorrect. I copied down ids to drop from ap 1
*Keeping the "right" Ap2 rows:
keep if process_complete==2 & redcap_event_name=="appointment_2_arm_1" 
keep record_id coder_name coder_name_other codeable type_coder peak_identified court_name process_type flowchart flowchart_conf actors rectangles diamonds event_notes did_you_translate translated_text translator_name other_tranlsator_name process_complete redcap_event_name
save ap2_to_merge, replace
clear

insheet using "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/VDemRedcapExportAug2016.csv", comma
*these are where the third coder is "right" 
browse record_id if process_complete==2 & redcap_event_name=="appointment_3_arm_1"
*These are the observations that I need to delete from the Appointment 1 sheet --the version in Appoitnment 1 is incorrect.
*copy down ids to drop from ap
*Keeping the "right" Ap3 rows:
keep if process_complete==2 & redcap_event_name=="appointment_3_arm_1"
keep record_id coder_name coder_name_other codeable type_coder peak_identified court_name process_type flowchart flowchart_conf actors rectangles diamonds event_notes did_you_translate translated_text translator_name other_tranlsator_name process_complete redcap_event_name
save ap3_to_merge, replace
clear

*generating ap1
insheet using "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/VDemRedcapExportAug2016.csv", comma

*if coder 2 or coder three is not flagged as right, we assume 1 is right (most events only have one coder anyway)
keep if process_complete !=0 & redcap_event_name=="appointment_1_arm_1"

*dropping the rows from appointment1 that I know are "right" in the appointment 2 and appointment 3 sheets so that I can add those sheets in whithout duplicating
drop if record_id== "Afghanistan_1964" 
drop if record_id=="Albania_1914" |record_id== "Albania_1992"|record_id== "Algeria_1963"|record_id== "Argentina_1949"|record_id== "Austria_1920"|record_id== "Austria_1960"|record_id== "Austria_1961"|record_id== "Austria_1962"|record_id== "Austria_1963"|record_id== "Austria_1964"|record_id== "Austria_1968"|record_id== "Austria_1969"|record_id== "Austria_1972"|record_id== "Austria_1973"|record_id== "Austria_1974"|record_id== "Bangladesh_1972"
drop if record_id== "Bangladesh_1991"|record_id== "Belarus_1996"|record_id== "Belgium_1920"|record_id== "Belgium_1968"|record_id== "Belgium_1969"|record_id== "Belgium_1980"|record_id== "Belgium_1981"|record_id== "Belgium_1996"|record_id== "Belgium_1997"|record_id== "Belgium_1999"|record_id== "Belgium_2000"|record_id== "Belgium_2003"|record_id== "Belgium_2004"|record_id== "Benin_1960"|record_id== "Benin_1968"|record_id== "Benin_1984"|record_id== "Brazil_1946"
drop if record_id== "Bulgaria_1965"|record_id== "Burkina Faso_1970"|record_id== "Burkina Faso_1977"|record_id== "Burkina Faso_2000"|record_id== "Burundi_1970"|record_id== "Burundi_1996"|record_id== "Burundi_2004"|record_id== "Cambodia 1999"|record_id== "Cameroon_1961"|record_id== "Cameroon_1996"|record_id== "Central African Republic_1964"|record_id== "Central African Republic_1976"|record_id== "Central African Republic_1979"|record_id== "Central African Republic_2003"|record_id== "Central African Republic_2013"|record_id== "Chad_1965"|record_id== "Chad_1978"

drop if record_id== "Chad_2005"|record_id== "Comoros_1992"|record_id== "Congo_1992"|record_id== "Cuba_1901"|record_id== "Cuba_1992"|record_id== "Cyprus 2010"|record_id== "Czechoslovakia 1960"|record_id== "Czechoslovakia 1991"|record_id== "Democratic Republic of Congo_1960"|record_id== "Democratic Republic of Congo_1961"|record_id== "Democratic Republic of Congo_1965"|record_id== "Democratic Republic of Congo_1966"|record_id== "Democratic Republic of Congo_1967"|record_id== "Democratic Republic of Congo_1970"|record_id== "Democratic Republic of Congo_1971"
drop if record_id== "Democratic Republic of Congo_1972"|record_id== "Democratic Republic of Congo_1973"|record_id== "Democratic Republic of Congo_1980"|record_id== "Democratic Republic of Congo_1988"|record_id== "Democratic Republic of Congo_1990"|record_id== "Dominican Republic_1994"|record_id== "Dominican Republic_2002"|record_id== "Dominican Republic_2010"|record_id== "Ecuador_1967"|record_id== "Ecuador_1978"|record_id== "Ecuador_1997"|record_id== "Ethiopia 1955"|record_id== "Finland 2011"|record_id== "Gambia 1970"|record_id== "ghana_1960"
drop if record_id== "Greece_1945"|record_id== "Guatemala 1945"|record_id== "Haiti_1950"|record_id== "Haiti_1971"|record_id== "Honduras_2013"|record_id== "Hungary_1990"|record_id== "Italy 1947"|record_id== "Ivory Coast_1980"|record_id== "Ivory Coast_1985"|record_id== "Japan 1946"|record_id== "Kenya_1986"|record_id== "Liberia_1934"|record_id== "Libya_1951"|record_id== "Luxembourg 2004"|record_id== "Luxembourg 2008"|record_id== "Madagascar_1970"|record_id== "Madagascar_1975"|record_id== "Madagascar_1995a"|record_id== "Malawi_1964"|record_id== "Malawi_1966"
drop if record_id== "Malawi_1970"|record_id== "Malawi_1971"|record_id== "Malawi_1973"|record_id== "Malawi_1978"|record_id== "Malawi_1987"|record_id== "Mali_1988"|record_id== "Marshall Islands_1979"|record_id== "Mauritania_1991"|record_id== "Moldova 1994"|record_id== "Montenegro 2007"|record_id== "Mozambique_1990"|record_id== "Mozambique _2004"|record_id== "Mozambique_2007"|record_id== "Nicaragua_1911"|record_id== "Nicaragua_2005"|record_id== "Nicaragua_2010"|record_id== "Nigeria_1989"|record_id== "Pakistan_2010"|record_id== "Panama_1904"
drop if record_id== "Panama_1972"|record_id== "Panama_1983"|record_id== "Poland 1919"|record_id== "Poland 1944"|record_id== "Poland 1954"|record_id== "Poland 1980"|record_id== "Poland 1982"|record_id== "Poland 1983"|record_id== "Poland 1987"|record_id== "Poland 1991"|record_id== "Portugal 1989"|record_id== "Portugal 1992"|record_id== "Romania 1923"|record_id== "Romania 1953"|record_id== "Romania 1961"|record_id== "Romania 1968"|record_id== "Romania 1969"|record_id== "Romania 1971"|record_id== "Romania 1972"|record_id== "Romania 1974"
drop if record_id== "Romania 1979"|record_id== "Romania 1986"|record_id== "Russia 1961"|record_id== "Senegal_2008"|record_id== "Seychelles_1979"|record_id== "Seychelles_1996"|record_id== "Sierra Leone_1971"|record_id== "Slovakia_2001"|record_id== "Slovenia_2004"|record_id== "Somalia_1960"|record_id== "South Africa_1909"|record_id== "South Africa_1980"|record_id== "South Africa_1993"|record_id== "Spain 1936"|record_id== "Spain 1946a"|record_id== "Spain 2011"|record_id== "Suriname 1982"|record_id== "Tunisia 1959"|record_id== "Tunisia 2014"
drop if record_id== "United States of America_1789"|record_id== "Vatican City_1929"|record_id== "Vietnam_1956"|record_id== "Vietnam_1960"|record_id== "Vietnam_1967"|record_id== "Vietnam_2001"|record_id== "Vietnam_2013"|record_id== "Yugoslavia-Serbia 1992"|record_id== "Belgium_1970"|record_id== "Belgium_1983"|record_id== "Belgium_1984"|record_id== "Belgium_1985"|record_id== "Belgium_1989"|record_id== "Belgium_1991"|record_id== "Belgium_1993"|record_id== "Ghana_1957"|record_id== "Niger_2010"|record_id== "Romania 1975"|record_id== "Vietnam_1989"

*2745
*want to keep the relevant variables
keep record_id redcap_event_name coder_name coder_name_other codeable type_coder peak_identified court_name process_type flowchart flowchart_conf actors rectangles diamonds event_notes did_you_translate translated_text translator_name other_tranlsator_name process_complete
sort record_id
save appointment_right, replace
clear


use general_information.dta
sort record_id
save general_information, replace
clear
use appointment_changes.dta
sort record_id
save appointment_changes.dta, replace
clear
use appointment_right

append using ap2_to_merge
append using ap3_to_merge
sort record_id


merge 1:1 record_id using general_information.dta 
*29 drop out from general_information -- I checked a couple dropped observations in redcap and both were dropped for a reason (missing app and rem or all red)
drop if _merge==2
sort record_id

drop _merge
merge 1:1 record_id using appointment_changes.dta
drop if _merge==2 
*all matched from using

save vdem_wide, replace


*cleaning up duplicates to merge in new variables and then go to country_year

duplicates tag state year, gen(dublicate_state_year)
*mismatch between record and year for Burkina Faso
replace year=2000 if record_id=="Burkina Faso_2000"
	*if there are two events in a year, im only going to keep the event that has flowchart information
	*codeable 1=yes, 2= no language, 3=no there is no appointment or removal info

drop if dublicate_state_year>0 & (codeable==3|codeable==2)
*browse if dublicate_state_year>0
duplicates list state year
*France 1815 still duplicate; greece 1986; nambia 1998; taiwan 1994; taiwan 2005
*Taiwan 2005a is the original constitution that goes along with the ammendment. Both have same info. Dropping the second
drop if record_id=="Taiwan_2005a"
*Taiwan 1994 is the constitution that goes with the ammendments for 1994a. Dropping the constitution becasue the ammendemnts are the event. same info in both
drop if record_id=="Taiwan_1994"
*namibia 1998 and 1998b has same flowchart and no changes, 1998b has slightly more info. Keeping that one
drop if record_id=="Namibia_1998" 
*some inconsistencites in redcap because of need for reconciling events i coded and tranlsation. Will keeo greece 1986 becasue that is by the coder that coded the other appointment 1's
drop if record_id=="Greece_1986a"
*no appoitnment information on either of the french 1815 docs.
drop if record_id=="France_1815.2"
duplicates tag state year, gen(dup_double_check)
*ah mismatched year
replace year= 1963 if record_id=="Dominican Republic_1963"
*another one? albania has two 2008 but one ise empty
drop if record_id=="Albania_2008a"
*austira 2013 has too and the a has a flowchart
drop if record_id=="Austria_2013"
*estina 2003a not any info
drop if record_id=="Estonia 2003a"
*tunisia 1969 a has no info
drop if record_id=="Tunisia 1969a"


*redcap issue with one state being having with multiple numeric Sate IDs, 
*Going to replace values for countreis wil multiple codes with first code for that state
*albania
replace state=2 if state==3
*austria
replace state=11 if state==12
*Belgium
replace state=22 if state==23
*cuba
replace state=48 if state==49
*czechoslocakia
replace state=52 if state==53
*denmark
replace state=55 if state==56
*dominican republic
replace state=59 if state==60
*egypt
replace state=63 if state==64
*estonia
replace state=68 if state==69
*Ethiopia
replace state=70 if state==71
*France
replace state=75 if state==76
*Germany
replace state=82 if state==83
*Greece
replace state=85 if state==86
*haiti
replace state=92 if state==93
*Japan
replace state=109 if state==110
*Latvia
replace state=120 if state==121
*lithuania
replace state=127 if state==128
*luxemborg
replace state=129 if state==130
*morocco
replace state=148 if state==149
*Netherlands
replace state=155 if state==156
*Norway
replace state=162 if state==163
*Paraguay
replace state=170 if state==171
*Poland
replace state=175 if state==176
*syria
replace state=209 if state==210
*tunisia
replace state=218 if state==219
*yugoslavia
replace state=239 if state==240



save vdem_wide, replace

*now need to merge in character names for states so I can have country codes for merging in later
clear
use country_codes_master2016.dta
sort state
save country_codes_master2016, replace
clear

use vdem_wide
drop _merge
merge m:m state using country_codes_master2016
*browse if _merge==2
drop if _merge==2
drop _merge
save vdem_wide, replace
clear


*need to merge in the court_size data
insheet using "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/stata/court_size_june23.csv"
tostring(year), replace
gen state_name_year= state_name+year
duplicates tag state_name_year, gen(identifier_dup)
*browse if identifier_dup>0
sort state_name_year
destring(year), replace

replace state_name_year="Burkina Faso1991" if state_name_year=="Burkina Fasso1991"
replace state_name_year="Burkina Faso1997" if state_name_year=="Burkina Fasso1997"
replace state_name_year="Burkina Faso2009" if state_name_year=="Burkina Fasso2009"
replace state_name_year="Burkina Faso2012" if state_name_year=="Burkina Fasso2012"
replace state_name_year="Democratic Republic of the Congo2005" if state_name_year=="Dem Rep of congo2005"
replace state_name_year="German Federal Republic1972" if state_name_year=="German federal Republic1972"
replace state_name_year="Guinea-Bissau1984" if state_name_year=="Guinea Bissau1984"

save court_size_jue23, replace



clear
use vdem_wide
generate yearstring = string(year)
gen state_name_year=state_name+yearstring


*need to drop a couple more things *albania no peak court ID, austria no flowchart, estonia and tunisia no peak ID
duplicates tag state_name_year, gen(dupagain)
*browse if dupagain>0
drop if record_id=="Albania_2008a" |record_id=="Austria_2013" |record_id=="Estonia 2003a" |record_id=="Tunisia 1969a"
drop dupagain



merge 1:1 state_name_year using court_size_jue23.dta
*browse if _merge==2
drop if _merge==2
drop _merge


*filling in years
table year
*one year is listed at 1929.2: Dominican republic. In Redcap it looks like this is the different traslations of the same constitution. Differences in flowcharts appear superficial and coder one does the neighboring flowcharts. Going with his work. Dropping 1929.2
drop if year >1929 & year <1930
duplicates list state year
drop if state==. & record_id==""
duplicates list state year
save vdem_wide, replace



**cleaning up unnecesary variables at this point
drop coder_name_other type_coder process_type other_tranlsator_name translator_name constitutional_event constitutional_event_other state_other translation constitution_complete dublicate_state_year dup_double_check identifier_dup

*changing from country_event to country_year

xtset state year, y
tsfill
save vdem_wide, replace



**cleaning and filling in


**filling in state_name
bysort state (year): replace state_name = state_name[_n-1] if state_name == "" & state==state[_n-1]

**year_string and state_name_year need to be re-don e to fill in
drop yearstring
gen year_string = string(year)
replace state_name_year= state_name+year_string if state_name_year==""

**filling in blanks from "first" so I dont have to worry about saving over 1=yes, 2=no, 3=first
replace which_year_compared="0000" if flowchart_change==3


**filling in nominators
*first want to fill in the blanks for when there was no change
gen number_nominators_filled= number_nominators 
bysort state (year): replace number_nominators_filled = number_nominators_filled[_n-1] if number_nominators_filled == . & state==state[_n-1]


*filling in selectors
gen number_selectors_filled= number_selectors 
bysort state (year): replace number_selectors_filled = number_selectors_filled[_n-1] if number_selectors_filled == . & state==state[_n-1]


**filling in how complicated is the process
gen complication_filled=complication 
bysort state (year): replace complication_filled = complication_filled[_n-1] if complication_filled == . & state==state[_n-1]


*filling in is the legislative branch involved
gen legislature_involved_filled=legislature_involved
bysort state (year): replace legislature_involved_filled = legislature_involved_filled[_n-1] if legislature_involved_filled == . & state==state[_n-1]


**filling in courtname
gen court_name_filled = court_name
bysort state (year): replace court_name_filled = court_name_filled[_n-1] if court_name_filled == "" & state==state[_n-1]


**filling in how many actors (from appoitnment sheet not changes)
gen actors_filled = actors
bysort state (year): replace actors_filled = actors_filled[_n-1] if actors_filled == . & state==state[_n-1]

**filling in rectangles
gen rectangles_filled = rectangles
bysort state (year): replace rectangles_filled = rectangles_filled[_n-1] if rectangles_filled == . & state==state[_n-1]

**filling in diamonds
gen diamonds_filled = diamonds
bysort state (year): replace diamonds_filled = diamonds_filled[_n-1] if diamonds_filled == . & state==state[_n-1]


*brian and julie peak court name
**filling in peakcourtname
gen peakcourt_brian = peakcourtname
bysort state (year): replace peakcourt_brian = peakcourt_brian[_n-1] if peakcourt_brian == "" & state==state[_n-1]



****filling in court_size
gen court_size = howmanyjudgesjustices
bysort state (year): replace court_size = court_size[_n-1] if court_size == "" & state==state[_n-1]

**court size notes
gen court_size_notes = notes
bysort state (year): replace court_size_notes = court_size_notes[_n-1] if court_size_notes == "" & state==state[_n-1]

**filling in  othersources
gen court_size_other_source = othersources
bysort state (year): replace court_size_other_source = court_size_other_source[_n-1] if court_size_other_source == "" & state==state[_n-1]


*ok things looking right, going to delete the non filled variables
drop othersources notes howmanyjudgesjustices peakcourtname diamonds actors rectangles court_name number_nominators number_selectors complication legislature_involved
*not all the year strings filled in
drop year_string
gen year_string=string(year)
replace record_id = state_name+"_"+year_string

**need to carry down the other country ID codes
*need to copy down StateAbb, CCode, UNID COWcode
bysort state (year): replace StateAbb = StateAbb[_n-1] if StateAbb == "" & state==state[_n-1]
bysort state (year): replace UNID = UNID[_n-1] if UNID == . & state==state[_n-1]
bysort state (year): replace COWcode = COWcode[_n-1] if COWcode == . & state==state[_n-1]



save vdem_wide, replace
clear

**merge in precent women two stages: (1) 1945-2003 from ICPSR  Women_parliament_Dta.dta

use "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/stata/Women_parliament_Dta.dta"
*need to reshape wide to long
reshape long P, i(COUNTRYN) j(PYear)
rename PYear year
rename P percent_women
tostring(UNID), gen(UNID_string)
save percent_women_to_merge, replace
	*will merge in on UNID (also POLITYID would work)
clear

*(2) 2003 and on from IPU *see stata_vdem_long for some manipulation of this data
use IPU_to_merge.dta

reshape long P, i(COUNTRYN) j(year)
rename CountryCode StateAbb
rename P percent_women
save IPU_Long.dta, replace
	*will merge in on StateAbb
	
	
clear
use vdem_wide
duplicates list UNID year
tostring(UNID), gen(UNID_string)
merge m:m UNID year using percent_women_to_merge 
*Lots didnt match even though UNID is the same for unmatched countries.... I think becasue of year issues and missingness


drop if _merge==2
drop _merge


merge m:m StateAbb year using IPU_Long.dta
drop if _merge==2
drop _merge


*changing  year of universal suffrage (UNIVSFRG) to years *since* UNIVSFRG
gen since_UNIVSFFRG= year-UNIVSFFRG
replace since_UNIVSFFRG=0 if since_UNIVSFFRG<0



save vdem_wide, replace

*some negative codes for percent women for coups and such. going to change to missing so negatives dont affect imputation later
replace percent_women=. if percent_women<0

*ok, dropping a couple more unneeded variables
drop coder_name translated_text language_other year_string
save vdem_wide, replace

***Merging in variables to match on

***Varieties of Democracy for indicies to match on:
**Version 6.2
	*findit use13
	*use13 "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/stata/V-Dem-DS-CY-v6.2.dta"
*too many variables to read into stata. Used R:
	 		*#library(foreign)
		*#install.packages("readstata13")
		*#library(readstata13)
		*#vdem<-read.dta13(file.choose())
		*#vdem_small_2016<-vdem[,c("country_text_id",
        *#            "country_name",
          *#          "country_id",
            *#        "year",
              *#      "COWcode",
        *#            "v2x_partipdem",
         *#           "v2x_egaldem",
          *#          "v2xcl_rol",
           *#         "v2x_gender",
            *#        "v2elrstrct",
             *#       "v2lgqugen",
            *#        "v2lgfemleg",
           *#         "v2jupack",
          *#          "v2clacjstw",
          *#          "v2pepwrgen",
          *#          "v2csgender",
          *#          "v2mefemjrn",
          *#          "v2cldmovew",
          *#          "v2cldiscw",
          *#          "v2clslavef",
          *#          "v2clprptyw")]

		*write.dta(vdem_small_2016, "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/stata/vdem_small_2016.dta")


*Variables I want:
*country_text_id 
*country_name 
*country_id 
*COWcode
*v2x_partipdem : participatiry democracy index
*v2x_egaldem : egalitarian democracy index
*v2xcl_rol : equality before the law and individual liberty index
*v2x_gender : women political empowerement index
*v2elrstrct : candidte restriction by ethnicity, race, religion, or language
*v2lgqugen :Lower chamber gender quota
*v2lgfemleg :lower chamber female legislators
*v2jupack : court packing
*v2clacjstw : access to justice for women
*v2pepwrgen : power distributed by gender
*v2csgender : CSo (civil society) women's participations
*v2mefemjrn : female journalists
*v2cldmovew : freedom of domestic movement for women
*v2cldiscw : freedom of discusison for women
*v2clslavef : freedom from forced labor for women
*v2clprptyw : proprty rights for women

clear
use "/Users/nancyarrington/Dropbox/VDem_Nancy_shared/Women_and_High_Courts_Project/data_files/August_2016_high_courts_recreation/stata/vdem_small_2016.dta"
duplicates tag year COWcode, gen(dup)
*a coupl countries without COW codes. these are not in our data set so dropping
drop if COWcode==.
drop dup
save vdem_small_2016, replace

clear
use vdem_wide

duplicates tag year COWcode, gen(year_COW_dup)
browse if year_COW_dup>0
drop if state_name=="Other" 
drop year_COW_dup

duplicates tag year COWcode, gen(year_COW_dup)
browse if year_COW_dup>0

*Macedonia, Yugoslavia, Kosovo misisng COWcode. From COW website, 343, 345, 347.
	*check to make sure dont already ahave those
	table COWcode
*now we have duplicates of macednia with former yugolsav republic of macedonia. Maybe a merge problem earlier becasue former doesnt have a state id from redcap
replace COWcode=345 if state_name=="Yugoslavia"
replace COWcode=347 if state_name=="Kosovo"




merge 1:1 year COWcode using vdem_small_2016.dta
 
drop if _merge==2
drop _merge

save vdem_wide, replace




**fixing things to match on
*right now "no nominators, only selectors" is set to 10
replace number_nominators_filled=0 if number_nominators_filled==10


gen treated=0
sort state year
replace treated =1 if year > 1969 & year< 2001 & flowchart_change == 1 & number_selectors_filled>number_selectors_filled[_n-1] & number_selectors_filled != . & number_selectors_filled[_n-1] !=. &state==state[_n-1]
replace treated =1 if year > 1969 & year< 2001 & flowchart_change == 1 & number_nominators_filled>number_nominators_filled[_n-1] & number_nominators_filled !=. & number_nominators_filled[_n-1] !=. &state==state[_n-1]
*great lots of treatments, but many countries have several "treatments" and we only want the first.

**need to match on pre change institutions. So for treated countries those are the institutions of the previous year
sort state year
gen nominators_to_match=number_nominators if treated==0
replace nominators_to_match=number_nominators[_n-1] if treated==1 & state[_n-1]==state

gen selectors_to_match= number_selectors_filled if treated==0
replace selectors_to_match= number_selectors_filled[_n-1] if treated==1 & state[_n-1]==state

*we are only looking at treatments between 1970 and 2000 so that we collect data between 1960 and 2010. Truncate at 1960 because very few women on peak courts before then and we need some variation.
drop if year<1960
browse if treated==1
*a few countries with multiple treatments in our year range. We only want the FIRST treatment. Secondary treatments can be thought of as outcomes of the first treatment.
table treated state if treated==1
*multiple treatements state==2, 4, 35, 62, 
*want to tag secondary "treatments" becasue we only want the first one
browse if treated==1 & (state==4 |state==2| state==35| state==62)

**so these are treatments that are after the first treatment in the period, which we DONT WANT. But, dropping these rows from the data is messing me up later in the r portion, 
*so going to change the value of treated=2
replace treated=2 if record == "Albania_1992"| record_id=="Albania_1998"| record_id=="Algeria_1996" 
replace treated=2 if record_id=="Cambodia_1989"| record_id=="Cambodia_1993"
replace treated=2 if record_id=="Ecuador_1984"| record_id=="Ecuador_1992"| record_id=="Ecuador_1997"

*now creating an indicator varibale for observations that we DO NOT WANT TO BE CONTROL UNITS
*in particular, we do not want any trated units to be control units for other countries, either beofre or after their treatment 
gen drop_from_match=0

table state if treated>0

*so removing from control any observation of a treated state:
replace drop_from_match=1 if inlist(state, 2,4,6,21,25,32,33,35,38,39,40,41,43,45,62,65,66,70,73,79,84,88,92,97,112,127,132,136,139,146,148,158,159,160,175,177,180,181,185,189,196,214,215,220,230,233,241) 
**but we still want our treated years to be able to match
replace drop_from_match=0 if treated==1   


save women_highcourts_august12_2016, replace

outsheet using women_highcourts_august12_2016.csv, comma replace


**Percent women from IPU women/parliamentd some data have data where VDem doesnt and vice versa
gen p_filled=percent_women
replace p_filled=v2lgfemleg if p_filled==.
*and going to manually impute some of the p_filled becasue lots of missingness and much of that missingness in early years is likley 0s
*going to replace missing with 0 if the next year is also 0
forvalues i = 1/25 {
   bysort state (year): replace p_filled=0 if p_filled==. & percent_women[_n+`i']==0 
}


**some record ids with out states
drop if inlist(record_id, "_1990","_1991", "_1992" ,"_1993" ,"_1994" ,"_1995", "_1996", "_1997")
drop if inlist(record_id, "_2001", "_2002", "_2003", "_2004", "_2005", "_2006", "_2007")
drop if inlist(record_id, "_2011", "_2012", "_2013", "_2014","_2015", "_1998", "_1999", "_2000" )
drop if inlist(record_id, "_2008","_2009","_2010")

save women_high_courts_aug_22_2016, replace

outsheet using women_highcourts_august22_2016.csv, comma replace
 







************************************************************************************************************************************************
************************************************************************************************************************************************
************************************************************************************************************************************************




**country codes master alteration
**redcap has a state id numeric idntifier that I think may be useful because not all of the record_id country names have been identified acurately


*state refers to the numeric code from vdem
*state_names.dta is the spreadsheet of redcap state numbers and state names.

*going to merge with country_codes_master to try to fill in gaps 


*state_names has "state" (numeric) and "state_name" country code master also has state_name
use country_codes_master.dta
replace state_name= "Antigua & Barbuda" if state== "Antigua and Barbuda"
replace state_name="Ivory Coast" if state=="Cote d'Ivoire"
replace state_name="Brunei" if state_name=="Brunei Darussalam"
replace state_name="Iran" if state_name=="Iran (Islamic Republic of)"
replace state_name="Laos" if state_name=="Lao People's Democratic Republic"
replace state_name="Libya" if state_name=="Libyan Arab Jamahiriya"
replace state_name="South Korea" if state_name=="Republic of Korea"
replace state_name="Moldova" if state_name=="Republic of Moldova"
replace state_name="Russia" if state_name=="Russian Federation"
replace state_name="St. Kitts and Nevis" if state_name=="Saint Kitts and Nevis"
replace state_name="St. Lucia" if state_name=="Saint Lucia"
replace state_name="St. Vincent and the Grenadines" if state_name=="Saint Vincent and the Grenadines"
replace state_name="Syria" if state_name=="Syrian Arab Republic"
replace state_name="United Kingdom" if state_name=="United Kingdom of Great Britain and Northern Irela"
replace state_name="Vietnam" if state_name=="Viet Nam"
replace state_name="Federated States of Micronesia" if state_name=="Micronesia (Federated States of)"
replace state_name="German Federal Republic" if state_name=="Federal Republic of Germany"

save country_codes_master2016.dta, replace
clear

use state_names.dta
duplicates tag state_name, gen(state_name_dup)
***ohhhh, lots of duplicate state names with different state codes. Weird. In the drop down menu in redcap there are seeral states with two options that appear the same to me?
*browse if state_name_dup>0
*just going to replace values for countreis wil multiple codes
*albania
replace state=2 if state==3
*austria
replace state=11 if state==12
*Belgium
replace state=22 if state==23
*cuba
replace state=48 if state==49
*czechoslocakia
replace state=52 if state==53
*denmark
replace state=55 if state==56
*dominican republic
replace state=59 if state==60
*egypt
replace state=63 if state==64
*estonia
replace state=68 if state==69
*Ethiopia
replace state=70 if state==71
*France
replace state=75 if state==76
*Germany
replace state=82 if state==83
*Greece
replace state=85 if state==86
*haiti
replace state=92 if state==93
*Japan
replace state=109 if state==110
*Latvia
replace state=120 if state==121
*lithuania
replace state=127 if state==128
*luxemborg
replace state=129 if state==130
*morocco
replace state=148 if state==149
*Netherlands
replace state=155 if state==156
*Norway
replace state=162 if state==163
*Paraguay
replace state=170 if state==171
*Poland
replace state=175 if state==176
*syria
replace state=209 if state==210
*tunisia
replace state=218 if state==219
*yugoslavia
replace state=239 if state==240



duplicates drop state_name state, force
drop state_name_dup

merge 1:1 state_name using country_codes_master2016.dta

save country_codes_master2016.dta, replace
**also Macednia and former Yugoslav Rep of Mac. Redcap is just macedonia, state= 131
replace state_name="Macedonia" if state_name=="The former Yugoslav Republic of Macedonia"
replace state=131 if state_name=="Macedonia" & state==.
 drop if state==131 &UNID==.

save country_codes_master2016.dta, replace
