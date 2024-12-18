WITH
    final as (
        SELECT 
            * 
        FROM {{ ref('STG_ABC_BANK_COUNTRY_ISO') }}
    )
SELECT *
FROM final