/*** QualityWatch round-up 2023 ***/
/** Generation of ambulance handover delay data at ICS level using published data and mapping tool **/
/* The mapping tool applies weights and converts trust data to ICS level data */

/* Create folder shortcut */
libname out '~\Output';

/* 1. Import ambulance handover delay trust level dataset */
proc import out = trust_ambho_data
			datafile = "~\Ambulance handover delays by trust.xlsx"
			DBMS = excel replace;
			range = "Ambulance_handovers$";
			getnames = yes;
			mixed = no;
			scantext = yes;
			usedate = yes;
			scantime = yes;
run;

/***** December 2022 *****/
/* 2. Select the data for that month */
data dec22_trust_ambho_data;
set trust_ambho_data;
	where date = '01DEC2022'd;
run;

/* 3. Join in trust to ICS weights */
proc sql;
	create table dec22_ambho_data_ICBweights as
	select A.*,
		   B.*
	from dec22_trust_ambho_data as A
	left join out.Trust_ics_v2_weights1 (keep = Provider_code ICS_code1 ICS_code2 ICS_name Provider_ICS_weighting) as B
	on A.Trust_code = B.Provider_code
;
quit;

/* 4. Checks - check that all trusts have an ICB mapping */
data dec22_ambho_data_ICBweights_null;
set dec22_ambho_data_ICBweights;
where ICS_code1 = ' ' ;
run;

/* Check to see if sum of all weights comes to 124 (the number of trusts in mapping file), or a whole number < 124 */
proc sql;
select sum(Provider_ICS_weighting)
from dec22_ambho_data_ICBweights
;
quit;
	/* sum of weights = 123. This tells us 123 trusts in ambulance data. Due to missing R1F Isle Of Wight Trust */

/* 5. Use weights to apportion trust data to individual ICBs */
data dec22_ambho_data_ICBweights2;
set dec22_ambho_data_ICBweights;

delayed_ICB = delayed*Provider_ICS_weighting;
arrivals_ICB = arrivals*Provider_ICS_weighting;

where ICS_code1 ne ' ' ;
run;

/* 6. Sum the apportioned numerators and denominators separately by ICB, and calculate the % delayed by ICB */
proc sql;
	create table dec22_ambulancehandover_ICB as
	select Date, ICS_code1, ICS_code2, ICS_name
		,sum(delayed_ICB) as delayed_ICB
		,sum(arrivals_ICB) as arrivals_ICB
		,sum(delayed_ICB)/sum(arrivals_ICB) as percent_amb_delayed_ICB

				from  dec22_ambho_data_ICBweights2
					group by  Date, ICS_code1, ICS_code2, ICS_name
	;
	quit;

/***** January 2023 *****/
/* 2. Select the data for that month */
data jan23_trust_ambho_data;
set trust_ambho_data;
	where date = '01JAN2023'd;
run;

/* 3. Join in trust to ICB weights */
proc sql;
	create table jan23_ambho_data_ICBweights as
	select A.*,
		   B.*
	from jan23_trust_ambho_data as A
	left join out.Trust_ics_v2_weights1 (keep = Provider_code ICS_code1 ICS_code2 ICS_name Provider_ICS_weighting) as B
	on A.Trust_code = B.Provider_code
;
quit;

/* 4. Checks - check that all trusts have an ICB mapping */
data jan23_ambho_data_ICBweights_null;
set jan23_ambho_data_ICBweights;
where ICS_code1 = ' ' ;
run;

/* Check to see if sum of all weights comes to 124 (the number of trusts in mapping file), or a whole number < 124 */
proc sql;
select sum(Provider_ICS_weighting)
from jan23_ambho_data_ICBweights
;
quit;
	/* sum of weights = 123. This tells us 123 trusts in ambulance data. Due to missing R1F Isle Of Wight Trust */

/* 5. Use weights to apportion trust data to individual ICBs */
data jan23_ambho_data_ICBweights2;
set jan23_ambho_data_ICBweights;

delayed_ICB = delayed*Provider_ICS_weighting;
arrivals_ICB = arrivals*Provider_ICS_weighting;

where ICS_code1 ne ' ' ;
run;

/* 6. Sum the apportioned numerators and denominators separately by ICB, and calculate the % delayed by ICB */
proc sql;
	create table jan23_ambulancehandover_ICB as
	select Date, ICS_code1, ICS_code2, ICS_name
		,sum(delayed_ICB) as delayed_ICB
		,sum(arrivals_ICB) as arrivals_ICB
		,sum(delayed_ICB)/sum(arrivals_ICB) as percent_amb_delayed_ICB

				from  jan23_ambho_data_ICBweights2
					group by  Date, ICS_code1, ICS_code2, ICS_name
	;
	quit;

/***** Feb 23 *****/
/* 2. Select the data for that month */
data feb23_trust_ambho_data;
set trust_ambho_data;
	where date = '01FEB2023'd;
run;

/* 3. Join in trust to ICB weights */
proc sql;
	create table feb23_ambho_data_ICBweights as
	select A.*,
		   B.*
	from feb23_trust_ambho_data as A
	left join out.Trust_ics_v2_weights1 (keep = Provider_code ICS_code1 ICS_code2 ICS_name Provider_ICS_weighting) as B
	on A.Trust_code = B.Provider_code
;
quit;

/* 4. Checks - check that all trusts have an ICB mapping */
data feb23_ambho_data_ICBweights_null;
set feb23_ambho_data_ICBweights;
where ICS_code1 = ' ' ;
run;

/* Check to see if sum of all weights comes to 124 (the number of trusts in mapping file), or a whole number < 124 */
proc sql;
select sum(Provider_ICS_weighting)
from feb23_ambho_data_ICBweights
;
quit;
	/* sum of weights = 123. This tells us 123 trusts in ambulance data. Due to missing R1F Isle Of Wight Trust */

/* 5. Use weights to apportion trust data to individual ICBs */
data feb23_ambho_data_ICBweights2;
set feb23_ambho_data_ICBweights;

delayed_ICB = delayed*Provider_ICS_weighting;
arrivals_ICB = arrivals*Provider_ICS_weighting;

where ICS_code1 ne ' ' ;
run;

/* 6. Sum the apportioned numerators and denominators separately by ICB, and calculate the % delayed by ICB */
proc sql;
	create table feb23_ambulancehandover_ICB as
	select Date, ICS_code1, ICS_code2, ICS_name
		,sum(delayed_ICB) as delayed_ICB
		,sum(arrivals_ICB) as arrivals_ICB
		,sum(delayed_ICB)/sum(arrivals_ICB) as percent_amb_delayed_ICB

				from  feb23_ambho_data_ICBweights2
					group by  Date, ICS_code1, ICS_code2, ICS_name
	;
	quit;

/*** ICS-level data for all months created, append them all into one file ***/
data ambulancehandover_ICB;
set dec22_ambulancehandover_ICB jan23_ambulancehandover_ICB feb23_ambulancehandover_ICB;
run;

/* Change date format to match other measures */
data ambulancehandover_ICB;
set ambulancehandover_ICB;
monthyear = put(Date, MONYY.);
run;

/* Place date and monthyear as first variables */
data ambulancehandover_ICB;
retain Date monthyear;
set ambulancehandover_ICB;
run;

/* Save SAS dataset */
data out.ambulancehandover_ICB;
	set ambulancehandover_ICB;
run;
