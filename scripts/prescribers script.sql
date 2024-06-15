-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
-- Select npi, sum(total_claim_count)as number_of_claims
-- From prescription 
-- Group by npi
-- Order by number_of_claims DESC


    
-- --     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.
-- Select 
-- 	p2.nppes_provider_first_name, 
-- 	p2.nppes_provider_last_org_name,  
-- 	p2.specialty_description, 
-- 	sum(p1.total_claim_count)as number_of_claims 
-- From prescription as p1
-- Left Join prescriber as p2
-- on p1.npi = p2.npi
-- Group by 
-- 	p2.nppes_provider_first_name, 
-- 	p2.nppes_provider_last_org_name,  
-- 	p2.specialty_description
-- Order by number_of_claims DESC
-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?

-- Select 
-- p2.specialty_description, 
-- sum(p1.total_claim_count)as number_of_claims 
-- From prescription as p1
-- Left Join prescriber as p2
-- on p1.npi = p2.npi
-- Group by p2.specialty_description
-- Order by number_of_claims DESC

--     b. Which specialty had the most total number of claims for opioids?



--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?

-- Select 
-- 	d.generic_name,
-- 	sum(p.total_drug_cost)as total_drug_cost
-- From drug as d
-- Inner join prescription as p
-- On d.drug_name = p.drug_name
-- Group by d.generic_name
-- Order by total_drug_cost DESC

--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. **Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/ 

-- Select 
-- 	drug_name,
--  Case 
--  		when opioid_drug_flag = 'Y' then 'opiod'
-- 		when antibiotic_drug_flag = 'Y' then 'antibiotic'
-- 		else 'neither'  
-- 		end as drug_type
	
--   From drug
--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEYfor easier comparision.
-- Select  
--  	Sum(prescription.total_drug_cost),
--   Case 
--   		when opioid_drug_flag = 'Y' then 'opiod'
--   		when antibiotic_drug_flag = 'Y' then 'antibiotic'
--   		else 'neither'  
--  		end as drug_type	
--  from drug 
--  join prescription 
--  using (drug_name)
-- Group by 
-- 	drug_type
-- Order by Sum(prescription.total_drug_cost) DESC
-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.





--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
-- Select c.cbsaname,
-- 	max(p.population) as largest_population
-- From 
-- 	population as p
-- join 
-- 	cbsa as c
-- on c.fipscounty= p.fipscounty
-- Group by 1
-- Order by 2 desc

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
-- Select c.cbsaname,
-- max(p.population) as largest_population
-- From 
-- 	population as p
--  join 
--  	cbsa as c
-- 	on c.fipscounty= p.fipscounty
-- Group by 1
-- Order by 2 desc

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

-- Select drug_name, total_claim_count
-- from prescription
-- where total_claim_count > 3000 or total_claim_count = 3000


--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
-- Select 
-- 	drug_name,
-- 	p.total_claim_count,
-- 	Case 
--   		when opioid_drug_flag = 'Y' then 'opiod'
-- 		else 'neither'    		
-- 		end as drug_type	
-- 	from prescription as p
-- 	Inner Join drug as d
-- 	using (drug_name)
-- 	where p.total_claim_count > 3000 or p.total_claim_count = 3000

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
-- Select 
-- 	drug_name,
-- 	p.total_claim_count,
--  	Case 
--    		when opioid_drug_flag = 'Y' then 'opiod'
-- 		else 'neither'    		
--  		end as drug_type	
--  	from prescription as p
-- 	Inner Join drug as d
--  	using (drug_name)
--  	where p.total_claim_count > 3000 or p.total_claim_count = 3000

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.
-- Select 
-- 	prescriber.npi,
-- 	drug.drug_name
-- from prescriber 	
-- Cross join drug
-- Where
-- 	opioid_drug_flag = 'Y'
-- 	and
-- 	nppes_provider_city = 'NASHVILLE'
-- 	and
-- 	specialty_description = 'Pain Management';

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.