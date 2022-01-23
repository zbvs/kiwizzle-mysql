#os.system(""" archResult.jobs.for """)



CREATE DATABASE IF NOT EXISTS `kiwizzle`;

CREATE USER IF NOT EXISTS 'kiwizzle'@'%' IDENTIFIED BY 'kiwizzle';
GRANT ALL PRIVILEGES ON kiwizzle.* TO 'kiwizzle'@'%';

############################################################################<<
#DROP EXISTING
DROP PROCEDURE IF EXISTS `kiwizzle`.`INIT_PROCEDURE`;

DELIMITER $$
CREATE PROCEDURE `kiwizzle`.`INIT_PROCEDURE`(OUT execute_result  VARCHAR(20))
BEGIN

    IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'kiwizzle') THEN
        SET FOREIGN_KEY_CHECKS = 0;
		SET @tables = NULL;
		SELECT GROUP_CONCAT('`', table_schema, '`.`', table_name, '`') INTO @tables
		FROM information_schema.tables
		WHERE table_schema = 'kiwizzle';
		SET @tables = CONCAT('DROP TABLE ', @tables);
        PREPARE    stmt FROM @tables;
		EXECUTE    stmt;
		SELECT * FROM information_schema.tables WHERE table_schema = 'kiwizzle';
		SET FOREIGN_KEY_CHECKS = 1;
        SET execute_result = "EXECUTED";
	ELSE
		SET execute_result = "NOT EXECUTED";
    END IF;
END$$
DELIMITER ;

CALL `kiwizzle`.`INIT_PROCEDURE`(@result);
SELECT @result;
############################################################################>>

CREATE TABLE IF NOT EXISTS `kiwizzle`.`company_category` (
    category_id BIGINT PRIMARY KEY,
    category_name VARCHAR(64) NOT NULL,
    parent_id BIGINT,
    is_group BOOLEAN,
    public_name_kor VARCHAR(64) NOT NULL,
    public_name_eng VARCHAR(64) NOT NULL,
    CONSTRAINT foreign_parent_category_key FOREIGN KEY(parent_id) REFERENCES `kiwizzle`.`company_category`(category_id) 
        ON DELETE RESTRICT
);



CREATE TABLE IF NOT EXISTS `kiwizzle`.`company` (
    company_id BIGINT PRIMARY KEY,
    company_name VARCHAR(64) NOT NULL,
    public_name_kor VARCHAR(64) NOT NULL,
    public_name_eng VARCHAR(64) NOT NULL,
    parent_id BIGINT,
    is_group BOOLEAN,
    category_id BIGINT,
    is_permitted  BOOLEAN,
    CONSTRAINT foreign_parent_company_key FOREIGN KEY(parent_id) REFERENCES `kiwizzle`.`company`(company_id) 
        ON DELETE RESTRICT ,
    CONSTRAINT foreign_category_key FOREIGN KEY(category_id) REFERENCES `kiwizzle`.`company_category`(category_id) 
        ON DELETE SET NULL 
        ON UPDATE SET NULL
);


CREATE TABLE IF NOT EXISTS `kiwizzle`.`position` (
    position_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    position_name VARCHAR(64) UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS `kiwizzle`.`language` (
    language_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(64) UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS `kiwizzle`.`job_description` (
    description_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    company_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    type VARCHAR(16) NOT NULL,
    content MEDIUMTEXT NOT NULL,
    text_content MEDIUMTEXT NOT NULL,
    experience INT,
    url VARCHAR(1024) NOT NULL,
    department VARCHAR(64) NOT NULL,
    start_date DATETIME NOT NULL,
    registration_date DATETIME NOT NULL,
    end_date DATETIME,
    expiry_date DATETIME,
    description_hash VARCHAR(64)  UNIQUE NOT NULL,
    is_expired BOOLEAN,
    
    KEY dao_query_index (is_expired, company_id, experience, registration_date, end_date),
    CONSTRAINT foreign_company_key FOREIGN KEY(company_id) REFERENCES `kiwizzle`.`company`(company_id) 
        ON UPDATE CASCADE
        ON DELETE RESTRICT    

);


# CREATE FULLTEXT index job_search_index_title ON `kiwizzle`.`job_description` (title) WITH parser ngram;
# CREATE FULLTEXT index job_search_index_text_content ON `kiwizzle`.`job_description` (text_content) WITH parser ngram;

