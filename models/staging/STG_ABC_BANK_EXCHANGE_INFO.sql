{{ config(materialized='ephemeral') }}

WITH
src_data as (
    SELECT
        Name as NAME
         , ID as ID
         , Country as COUNTRY
         , City as CITY
         , Zone as ZONE
         , Delta as DELTA
         , DST_period as DST_PERIOD 
         , Open as OPEN
         , Close as CLOSE
         , Lunch as LUNCH
         , Open_UTC as OPEN_UTC
         , Close_UTC as CLOSE_UTC
         , Lunch_UTC as LUNCH_UTC
         , LOAD_TS as LOAD_TS
         , 'SEED.ABC_Bank_EXCHANGE_INFO' as RECORD_SOURCE

    FROM {{ source('seeds', 'ABC_Bank_EXCHANGE_INFO') }}
 ),

default_record as (
    SELECT
        'Missing' AS NAME
        , 'Missing' AS ID
        , 'Missing' AS COUNTRY
        , 'Missing' AS CITY
        , 'Missing' AS ZONE
        , 99999 AS DELTA
        , '-1'      AS DST_PERIOD
        , '00:00'   AS OPEN
        , '00:00'   AS CLOSE
        , 'Missing' AS LUNCH
        , 'Missing'   AS OPEN_UTC
        , 'Missing'   AS CLOSE_UTC
        , 'Missing' AS LUNCH_UTC
        , '2020-01-01 00:00:00' AS LOAD_TS
        , 'Missing' as RECORD_SOURCE
),

with_default_record as(
    SELECT * FROM src_data
    UNION ALL
    SELECT * FROM default_record
),

hashed as (
    SELECT
        concat_ws('|', ID) as EXCHANGE_HKEY
        , concat_ws('|', NAME, COUNTRY, CITY, ZONE, DELTA, DST_PERIOD, OPEN, CLOSE, LUNCH, OPEN_UTC, CLOSE_UTC, LUNCH_UTC) as EXCHANGE_HDIFF
        , * EXCLUDE LOAD_TS
        , LOAD_TS as LOAD_TS_UTC
    FROM with_default_record
)
SELECT * FROM hashed