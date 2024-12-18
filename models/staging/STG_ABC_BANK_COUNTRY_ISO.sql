WITH
src_data as (
    SELECT
        country_name as COUNTRY_NAME
         , country_code_2_letter as COUNTRY_CODE_2_LETTER
         , country_code_3_letter as COUNTRY_CODE_3_LETTER
         , country_code_numeric as COUNTRY_CODE_NUMERIC
         , iso_3166_2 as ISO_3166_2
         , region as REGION
         , sub_region as SUB_REGION 
         , intermediate_region as INTERMEDIATE_REGION
         , region_code as REGION_CODE
         , sub_region_code as SUB_REGION_CODE
         , intermediate_region_code as INTERMEDIATE_REGION_CODE
         , LOAD_TS as LOAD_TS
         , 'SEED.ABC_Bank_COUNTRY_ISO' as RECORD_SOURCE

    FROM {{ source('seeds', 'ABC_Bank_COUNTRY_ISO') }}
 ),

final as (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['COUNTRY_NAME', 'COUNTRY_CODE_2_LETTER', 'COUNTRY_CODE_3_LETTER']) }} as EXCHANGE_HKEY
        , * EXCLUDE LOAD_TS
        , LOAD_TS as LOAD_TS_UTC
    FROM src_data
)
SELECT * FROM final