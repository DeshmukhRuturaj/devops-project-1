-- Database schema for Resume Analysis Application
-- Use database: devprojdb

USE devprojdb;

-- Create user_data table for storing resume analysis results
CREATE TABLE IF NOT EXISTS user_data (
    ID int NOT NULL AUTO_INCREMENT,
    sec_token varchar(20) NOT NULL,
    ip_add varchar(50) NOT NULL,
    host_name varchar(50) NOT NULL,
    dev_user varchar(50) NOT NULL,
    os_name_ver varchar(50) NOT NULL,
    latlong varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    state varchar(50) NOT NULL,
    country varchar(50) NOT NULL,
    act_name varchar(50) NOT NULL,
    act_mail varchar(50) NOT NULL,
    act_mob varchar(20) NOT NULL,
    name varchar(500) NOT NULL,
    email varchar(500) NOT NULL,
    res_score varchar(10) NOT NULL,
    timestamp varchar(50) NOT NULL,
    no_of_pages varchar(5) NOT NULL,
    reco_field varchar(500) NOT NULL,
    cand_level varchar(500) NOT NULL,
    skills varchar(2000) NOT NULL,
    recommended_skills varchar(2000) NOT NULL,
    courses varchar(2000) NOT NULL,
    pdf_name varchar(500) NOT NULL,
    PRIMARY KEY (ID)
);

-- Create user_feedback table for storing user feedback
CREATE TABLE IF NOT EXISTS user_feedback (
    ID int NOT NULL AUTO_INCREMENT,
    feed_name varchar(500) NOT NULL,
    feed_email varchar(500) NOT NULL,
    feed_score varchar(5) NOT NULL,
    comments varchar(2000) NOT NULL,
    Timestamp varchar(50) NOT NULL,
    PRIMARY KEY (ID)
);

-- Create company_profiles table for company job matching
CREATE TABLE IF NOT EXISTS company_profiles (
    ID int NOT NULL AUTO_INCREMENT,
    company_name varchar(500) NOT NULL,
    job_description text NOT NULL,
    culture_requirements text NOT NULL,
    required_skills text NOT NULL,
    job_role varchar(500) NOT NULL,
    PRIMARY KEY (ID)
);

-- Display created tables
SHOW TABLES;