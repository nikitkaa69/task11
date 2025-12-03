-- Snowflake Infrastructure Setup for Airbyte

-- 1. Role & User Setup
USE ROLE ACCOUNTADMIN;

CREATE ROLE IF NOT EXISTS airbyte_role;

CREATE USER IF NOT EXISTS airbyte_user
PASSWORD = 'password_placeholder'
DEFAULT_ROLE = airbyte_role
DEFAULT_WAREHOUSE = compute_wh;

-- 2. Database Setup
-- A dedicated database for raw data ingestion
CREATE DATABASE IF NOT EXISTS airbyte_database;

-- 3. Warehouse Setup
CREATE WAREHOUSE IF NOT EXISTS airbyte_warehouse
WAREHOUSE_SIZE = xsmall
AUTO_SUSPEND = 60
AUTO_RESUME = true
INITIALLY_SUSPENDED = true;

-- 4. Granting Privileges
-- Allow Airbyte role to use the warehouses and database
GRANT USAGE ON WAREHOUSE airbyte_warehouse TO ROLE airbyte_role;
GRANT USAGE ON WAREHOUSE compute_wh TO ROLE airbyte_role; -- optional fallback

GRANT OWNERSHIP ON DATABASE airbyte_database TO ROLE airbyte_role;
GRANT ROLE airbyte_role TO USER airbyte_user;

-- Allow creating schemas (PAGILA, SAKILA) inside the DB
GRANT CREATE SCHEMA ON DATABASE airbyte_database TO ROLE airbyte_role;

-- Grant permissions on the PUBLIC schema
GRANT USAGE ON SCHEMA airbyte_database.PUBLIC TO ROLE airbyte_role;
GRANT CREATE TABLE ON SCHEMA airbyte_database.PUBLIC TO ROLE airbyte_role;
GRANT CREATE STAGE ON SCHEMA airbyte_database.PUBLIC TO ROLE airbyte_role;
GRANT CREATE FILE FORMAT ON SCHEMA airbyte_database.PUBLIC TO ROLE airbyte_role;

-- 5. Grant access to current user for verification
-- SET my_user = (SELECT CURRENT_USER());
-- GRANT ROLE airbyte_role TO USER IDENTIFIER($my_user);