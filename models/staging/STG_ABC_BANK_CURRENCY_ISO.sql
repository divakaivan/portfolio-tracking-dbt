{{ config(materialized='ephemeral') }}

WITH
src_data as (
    SELECT
        AlphabeticCode as ALPHABETIC_CODE
         , NumericCode as NUMERIC_CODE
         , DecimalDigits as DECIMAL_DIGITS
         , CurrencyName as CURRENCY_NAME
         , Locations as LOCATIONS
         , LOAD_TS as LOAD_TS
         , 'SEED.ABC_Bank_CURRENCY_ISO' as RECORD_SOURCE

    FROM {{ source('seeds', 'ABC_Bank_CURRENCY_ISO') }}
 ),

default_record as (
    SELECT
        'Missing' as ALPHABETIC_CODE
         , -1 as NUMERIC_CODE
         , -1 as DECIMAL_DIGITS
         , 'Missing' as CURRENCY_NAME
         , 'Missing' as LOCATIONS
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
        {{ dbt_utils.generate_surrogate_key(['ALPHABETIC_CODE', 'NUMERIC_CODE']) }} as CURRENCY_HKEY
        , {{ dbt_utils.generate_surrogate_key(['DECIMAL_DIGITS', 'CURRENCY_NAME', 'LOCATIONS', 'RECORD_SOURCE']) }} as CURRENCY_HDIFF
        , * EXCLUDE LOAD_TS
        , LOAD_TS as LOAD_TS_UTC
    FROM with_default_record
)
SELECT * FROM hashed