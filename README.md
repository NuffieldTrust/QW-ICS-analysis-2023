# QW-ICS-analysis-2023

<b>Chain reaction? How clear are the causes of backlogs through urgent and emergency care?</b>

# Project description
This QualityWatch briefing explored backlogs and bottlenecks in urgent and emergency care at an Integrated Care System (ICS) level during the winter of 2022-23. Looking across five quality measures along a simplified patient pathway, the piece examines whether there is a correlation between different measures at an ICS level. Would reducing the number of delayed discharges from hospital lead to a chain reaction of improvements, enabling patients to move from emergency departments to wards, and reducing ambulance handover delays?

# The published briefing can be found [here](insert hyperlink in these brackets).

# The five measures were defined as follows:
<b>Ambulance handover delays</b> – the proportion of ambulance arrivals that had a handover delay of >30 minutes. 
Source: Nuffield Trust analysis of NHS England, Urgent and Emergency Care Daily Situation Reports 2022-23  

<b>A&E waiting times</b> – the proportion of people attending Type 1, 2 or 3 emergency departments that left the department more than 4 hours after arriving.
Source: Emergency Care Data Set (December 2022 to February 2023) Copyright © 2023, re-used with the permission of NHS Digital. All rights reserved.

<b>Trolley waits</b> – the proportion of patients with a decision to admit who waited >4 hours to be admitted to hospital
Source: Emergency Care Data Set (December 2022 to February 2023) Copyright © 2023, re-used with the permission of NHS Digital. All rights reserved.

<b>Long lengths of stay</b> – the proportion of discharged patients (who had at least one overnight stay in hospital) who had a length of stay ≥21 days
Source: Hospital Episode Statistics (December 2022 to February 2023) Copyright © 2023, re-used with the permission of NHS Digital. All rights reserved.

<b>Delayed discharges</b> – the proportion of patients that were not discharged who no longer met the criteria to reside in hospital
Source: Nuffield Trust analysis of NHS England, Urgent and Emergency Care Daily Situation Reports 2022-23 

All of the charts display data for the most recent winter, December 2022 to February 2023 inclusive.

# What methodology was used to generate the measures at an ICS level?
For the <b>A&E waiting times, trolley waits</b> and <b>length of stay</b> measures we used SAS software to generate ICS level data using the Emergency Care Data Set (ECDS) and Hospital Episode Statistics (HES) Admitted Patient Care dataset. We were able to allocate activity to a particular ICS based on the Lower Layer Super Output Area (LSOA)  in which a patient lives , based on mapping published by the Office for National Statistics.

The process used to generate the <b>ambulance handover delay</b> and <b>delayed discharge</b> data at an ICS level was slightly different. This is because we needed to convert publicly available data that is presented at trust level, to ICS-level. While there are already crude mapping tools available, we generated our own trust to ICS map based on type 1 emergency department activity as recorded in ECDS. This mapping apportioned each trust’s activity to one or more ICSs, and allowed us to regroup by ICS. 
Once we produced the trust to ICS mapping, we were then able to import the trust level data in SAS and convert it to ICS-level data.

The SAS code used to generate the five measures is uploaded on GitHub together with the trust to ICS mapping tool has been uploaded to GitHub.

# License
This project is licensed under the [MIT License](https://github.com/NuffieldTrust/QW-ICS-analysis-2023/LICENSE)
