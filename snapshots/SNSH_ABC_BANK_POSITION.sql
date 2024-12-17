{% snapshot SNSH_ABC_BANK_POSITION %}
{{
    config(
      unique_key= 'POSITION_HKEY',
      strategy='check',
      check_cols=['POSITION_HDIFF'],
      hard_deletes='invalidate',
    )
}}
select * from {{ ref('STG_ABC_BANK_POSITION') }}
{% endsnapshot %}