/*** QualityWatch round-up 2023 ***/
/** Generation of delayed discharge data at ICS level using published data and mapping tool **/
/* The mapping tool applies weights and converts trust data to ICS level data */

/* Numerator = Patients remaining in hospital who no longer meet the criteria to reside */
/* Denominator = Patients who no longer meet the criteria to reside */

/* Create folder shortcut */
libname out '~\Output';

/* 1. Import discharge delay trust level dataset */
proc import out = trust_disch_data
			datafile = "~\Delayed discharges by trust.xlsx"
			DBMS = excel replace;
			range = "Delayed_discharges$";
			getnames = yes;
			mixed = no;
			scantext = yes;
			usedate = yes;
			scantime = yes;
run;

/* 2. Repeat from here for each month */

/***** December 2022 *****/
data dec22_trust_disch_data;
set trust_disch_data;
where date = '01DEC2022'd;
run;

/* 3. Join in trust to ICS weights */
proc sql;
	create table dec22_disch_data_ICBweights as
	select A.*,
		   B.*
	from dec22_trust_disch_data as A
	left join out.Trust_ics_v2_weights1 (keep = Provider_code ICS_code1 ICS_code2 ICS_name Provider_ICS_weighting) as B
	on A.Trust_code = B.Provider_code
;
quit;

/* 4. Checks - check that all trusts have an ICB mapping */
data dec22_disch_data_ICBweights_null;
set dec22_disch_data_ICBweights;
where ICS_code1 = ' ' ;
run;

/* Check to see if sum of all weights comes to 124 (the number of trusts in mapping file), or a whole number < 124 */
proc sql;
select sum(Provider_ICS_weighting)
from dec22_disch_data_ICBweights
;
quit;
/* sum of weights = 121. This tells us 121 trusts in discharge data, fewer than 124 in mapping, but all accounted for (disch data doesn't include 3 children's / children's + women's trusts. */

/* 5. Use weights to apportion trust data to individual ICBs */
data dec22_disch_data_ICBweights2;
set dec22_disch_data_ICBweights;

delayed_disch_ICB = Number_remaining_in_hosp*Provider_ICS_weighting;
not_meet_criteria_ICB = Number_not_meet_criteria*Provider_ICS_weighting;

where ICS_code1 ne ' ' ;
run;

/* 6. Sum the apportioned numerators and denominators separately by ICB, and calculate the % delayed by ICB */
proc sql;
	create table dec22_delayed_discharge_ICB as
	select Date, ICS_code1, ICS_code2, ICS_name
		,sum(delayed_disch_ICB) as delayed_disch_ICB
		,sum(not_meet_criteria_ICB) as not_meet_criteria_ICB
		,sum(delayed_disch_ICB)/sum(not_meet_criteria_ICB) as percent_delayed_ICB

				from  dec22_disch_data_ICBweights2
					group by  Date, ICS_code1, ICS_code2, ICS_name
	;
	quit;


/***** January 2023 *****/
data jan23_trust_disch_data;
set trust_disch_data;
where date = '01JAN2023'd;
run;

/* 3. Join in trust to ICS weights */
proc sql;
	create table jan23_disch_data_ICBweights as
	select A.*,
		   B.*
	from jan23_trust_disch_data as A
	left join out.Trust_ics_v2_weights1 (keep = Provider_code ICS_code1 ICS_code2 ICS_name Provider_ICS_weighting) as B
	on A.Trust_code = B.Provider_code
;
quit;

/* 4. Checks - check that all trusts have an ICB mapping */
data jan23_disch_data_ICBweights_null;
set jan23_disch_data_ICBweights;
where ICS_code1 = ' ' ;
run;

/* Check to see if sum of all weights comes to 124 (the number of trusts in mapping file), or a whole number < 124 */
proc sql;
select sum(Provider_ICS_weighting)
from jan23_disch_data_ICBweights
;
quit;
/* sum of weights = 121. This tells us 121 trusts in discharge data, fewer than 124 in mapping, but all accounted for (disch data doesn't include 3 children's / children's + women's trusts. */

/* 5. Use weights to apportion trust data to individual ICBs */
data jan23_disch_data_ICBweights2;
set jan23_disch_data_ICBweights;

delayed_disch_ICB = Number_remaining_in_hosp*Provider_ICS_weighting;
not_meet_criteria_ICB = Number_not_meet_criteria*Provider_ICS_weighting;

where ICS_code1 ne ' ' ;
run;

/* 6. Sum the apportioned numerators and denominators separately by ICB, and calculate the % delayed by ICB */
proc sql;
	create table jan23_delayed_discharge_ICB as
	select Date, ICS_code1, ICS_code2, ICS_name
		,sum(delayed_disch_ICB) as delayed_disch_ICB
		,sum(not_meet_criteria_ICB) as not_meet_criteria_ICB
		,sum(delayed_disch_ICB)/sum(not_meet_criteria_ICB) as percent_delayed_ICB

				from  jan23_disch_data_ICBweights2
					group by  Date, ICS_code1, ICS_code2, ICS_name
	;
	quit;


/***** February 2023 *****/
data feb23_trust_disch_data;
set trust_disch_data;
where date = '01FEB2023'd;
run;

/* 3. Join in trust to ICB weights */
proc sql;
	create table feb23_disch_data_ICBweights as
	select A.*,
		   B.*
	from feb23_trust_disch_data as A
	left join out.Trust_ics_v2_weights1 (keep = Provider_code ICS_code1 ICS_code2 ICS_name Provider_ICS_weighting) as B
	on A.Trust_code = B.Provider_code
;
quit;

/* 4. Checks - check that all trusts have an ICB mapping */
data feb23_disch_data_ICBweights_null;
set feb23_disch_data_ICBweights;
where ICS_code1 = ' ' ;
run;

/* Check to see if sum of all weights comes to 124 (the number of trusts in mapping file), or a whole number < 124 */
proc sql;
select sum(Provider_ICS_weighting)
from feb23_disch_data_ICBweights
;
quit;
/* sum of weights = 121. This tells us 121 trusts in discharge data, fewer than 124 in mapping, but all accounted for (disch data doesn't include 3 children's / children's + women's trusts. */

/* 5. Use weights to apportion trust data to individual ICBs */
data feb23_disch_data_ICBweights2;
set feb23_disch_data_ICBweights;

delayed_disch_ICB = Number_remaining_in_hosp*Provider_ICS_weighting;
not_meet_criteria_ICB = Number_not_meet_criteria*Provider_ICS_weighting;

where ICS_code1 ne ' ' ;
run;

/* 6. Sum the apportioned numerators and denominators separately by ICB, and calculate the % delayed by ICB */
proc sql;
	create table feb23_delayed_discharge_ICB as
	select Date, ICS_code1, ICS_code2, ICS_name
		,sum(delayed_disch_ICB) as delayed_disch_ICB
		,sum(not_meet_criteria_ICB) as not_meet_criteria_ICB
		,sum(delayed_disch_ICB)/sum(not_meet_criteria_ICB) as percent_delayed_ICB

				from  feb23_disch_data_ICBweights2
					group by  Date, ICS_code1, ICS_code2, ICS_name
	;
	quit;


/*** ICS-level data for all months created, append them all into one file ***/

data delayed_discharge_ICB;
set dec22_delayed_discharge_ICB jan23_delayed_discharge_ICB feb23_delayed_discharge_ICB;
run;

/* Change date format to match LoS etc */
data delayed_discharge_ICB;
set delayed_discharge_ICB;
monthyear = put(Date, MONYY.);
run;

/* place Date and monthyear as first variables */
data delayed_discharge_ICB;
retain Date monthyear;
set delayed_discharge_ICB;
run;

/* Save SAS dataset */
data out.delayed_discharge_ICB;
	set delayed_discharge_ICB;
run;
