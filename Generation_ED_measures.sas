/*** QualityWatch round-up 2023 ***/
/** Generation of A&E measures at ICS level using ECDS data - 4 hour waits in A&E and trolley waits **/

/* Inclusion: Type 1, 2 & 3 emergency departments, English postcodes, valid arrival and departure date, valid arrival and departure time */
/* Exclusion: Patient aged 120+, planned attendances, patient dead on arrival */

/* Input ECDS data */
libname ecds22 '~/ECDSdata';

/* Filter data for 2022/23 */
data work.ecds_22;
	set ecds22.ec22m_temp (keep = attendance_category age_at_arrival arrival_date arrival_time departure_time department_type departure_date decided_to_admit_date decided_to_admit_time lsoa_2011);
	where 0 <= age_at_arrival < 120 and lsoa_2011 like "E%"
	and department_type in ('01','02','03') and (departure_date >= arrival_date) and (departure_date ~=.) and (departure_time ~=.) and (arrival_date ~=.) and (arrival_time ~=.) and attendance_category in ('1','2','3');
	quarter=qtr(arrival_date); month=month(arrival_date); year=year(arrival_date); monthyear = put(arrival_date, MONYY.);/* nb. annual year quarter not financial year quarter */
	arrival_dttm=input(put(arrival_date, date7.)||':'||put(arrival_time, time8.), datetime16.); format arrival_dttm datetime16.;
	depart_dttm=input(put(departure_date, date7.)||':'||put(departure_time, time8.), datetime16.); format depart_dttm datetime16.;
	if decided_to_admit_date~=. and decided_to_admit_time~=.
	then admit_dttm=input(put(decided_to_admit_date, date7.)||':'||put(decided_to_admit_time, time8.), datetime16.); format admit_dttm datetime16.;
run;

/* Generate waiting time variables */
data ecds_waits22;
	set work.ecds_22;
time_diff=intck('minute',arrival_dttm,depart_dttm);
if time_diff <=240 then under_4 = 1;
else under_4=0;
if admit_dttm ~=. then do;
	time_admit=intck('minute',admit_dttm,depart_dttm);
	if time_admit>240 then trolleywait4 = 1;
	else trolleywait4 = 0;
	if time_admit>720 then trolleywait12 = 1;
	else trolleywait12 = 0;
end;

if time_diff lt 0 then delete;
if time_admit lt 0 and time_admit ne . then delete;

run;

/* Import and merge LSOA to ICS lookup */
proc import datafile = "~\LSOA_(2011)_to_ICB__Lookup.csv"
	out = LSOA_to_ICS
	DBMS = CSV replace;
run;

proc sql;
	create table ecds_waits22_ics as
	select A.*,
		   B.*
	from ecds_waits22 as A
	left join LSOA_to_ICS (keep = LSOA11CD ICB22CD ICB22CDH ICB22NM) as B
	on A.lsoa_2011=B.LSOA11CD
;
quit;

/* Generate monthly data for 2022/23 */
proc sql;
	create table AE_data22 as
	select year, month, monthyear, ICB22CD, ICB22CDH, ICB22NM,
		sum(under_4=1) as AEunder4hour,
		sum(1) as AEdenom,
		sum(trolleywait4=1) as trolleywait4,
		sum(trolleywait4 ne . ) as trolleywaitdenom,
		sum(trolleywait12=1) as trolleywait12
	from ecds_waits22_ics
	group by year, month, monthyear, ICB22CD, ICB22CDH, ICB22NM
;
quit;

/* Keep data for December 2022 to February 2023 */
data AE_data_winter;
set AE_data22 (where=(month in (12, 1, 2)));
run;

/* Save SAS dataset */
libname out "~\Output";

data out.AE_data_winter;
	set AE_data_winter;
run;
