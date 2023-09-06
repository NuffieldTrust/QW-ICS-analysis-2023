/*** QualityWatch round-up 2023 ***/
/** Generation of hospital length of stay at ICS level using HES data **/
/* Numerator - number of patients with a length of stay >= 21 days who were discharged */
/* Denominator - number of patients who were discharged that had at least one overnight stay in hospital */

/* Inclusion: English postcodes, valid admission and discharge date */
/* Exclusion: Patient aged 120+ */

/* Input HES data */
libname HES22 "~/HESdata";

/* Filter data for 2022/23 */
data ip_22;
    set HES22.ip22m_temp (keep = admidate disdate spelend lsoa11 admiage); 
	where 0 <= admiage < 120 and spelend = "Y" and lsoa11 like "E%"
	and "01Apr2022."d <= admidate <= "31Mar2023."d
                        and disdate ne .
                            and admidate <= disdate;
los = disdate - admidate;
month=month(admidate);
year=year(admidate);
monthyear = put(admidate, MONYY.);
run;

/* Import and merge LSOA to ICS lookup */
proc import datafile = "~\LSOA_(2011)_to_ICB__Lookup.csv"
	out = LSOA_to_ICS
	DBMS = CSV replace;
run;

proc sql;
	create table los22_ics as
	select A.*,
		   B.*
	from ip_22 as A
	left join LSOA_to_ICS (keep = LSOA11CD ICB22CD ICB22CDH ICB22NM) as B
	on A.lsoa11=B.LSOA11CD
	;
quit;

/* Generate length of stay data for 2022/23 */
proc sql;
	create table los_data22_excl0 as
	select year, month, monthyear, ICB22CD, ICB22CDH, ICB22NM,
		sum(los>=21) as los21, 
		sum(1) as losdenom_excl0
	from los22_ics
	where los > 0
	group by year, month, monthyear, ICB22CD, ICB22CDH, ICB22NM
;
quit;

/* Keep data for December 2022 to February 2023 */
data length_of_stay_ics;
	set los_data22_excl0;
	where month in (12,1,2);
run;

/* Save SAS dataset */
libname out "~\Output";

data out.length_of_stay_ics;
	set length_of_stay_ics;
run;
