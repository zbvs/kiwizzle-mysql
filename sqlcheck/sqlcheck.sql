
#TEST OMMITED COMPANY
select * from job_description;
select * from company
where is_group=false and company_id not in (
select company_id from job_description
);

#TEST IF EXISTS JOB_DESCRIPTION WITHOUT LANGUAGE
SELECT * FROM job_description WHERE description_id NOT IN 
(SELECT JD.description_id FROM job_description AS JD JOIN job_description_LANGUAGE AS JDL 
ON JD.description_id=JDL.job_description_description_id
GROUP BY JD.description_id);

#TEST JOB_DESCRIPTION WITHOUT POSITION
SELECT * FROM job_description WHERE description_id NOT IN 
(SELECT JD.description_id FROM job_description AS JD JOIN job_description_POSITION AS JDP
ON JD.description_id=JDP.job_description_description_id
GROUP BY JD.description_id);





