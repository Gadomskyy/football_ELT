{% macro generate_season_code(col_start, col_end) -%}

CONCAT(LEFT({{ col_start }}, 4), "/", LEFT({{ col_end }}, 4))

{%- endmacro %}