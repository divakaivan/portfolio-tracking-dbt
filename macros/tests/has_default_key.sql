{% test has_default_key ( model, column_name
  , default_key_value = '-1'
  , record_source_field_name = 'RECORD_SOURCE'
  , default_key_record_source = 'Missing'
) -%}
{{ config(severity = 'error') }}
WITH
default_key_rows as (
    SELECT {{column_name}}, {{record_source_field_name}}
    FROM {{ model }}
    WHERE {{column_name}} = '{{default_key_value}}'
      and {{record_source_field_name}} = '{{default_key_record_source}}'
),
validation_errors as (
    SELECT '{{default_key_value}}' as {{column_name}}, '{{default_key_record_source}}' as {{record_source_field_name}}
    EXCEPT
    SELECT {{column_name}}, {{record_source_field_name}}
    FROM default_key_rows
)
-- Fail the test only if the default record is missing
SELECT * FROM validation_errors
{%- endtest %}
