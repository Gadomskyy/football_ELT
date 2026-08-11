{% macro player_position(col) -%}

    CASE
        WHEN {{ col }} = 'Goalkeeper' THEN 'Goalkeeper'
        WHEN {{ col }} IN ('Defence', 'Centre-Back', 'Right-Back', 'Left-Back') THEN 'Defender'
        WHEN {{ col }} IN ('Midfield', 'Defensive Midfield', 'Central Midfield', 'Right Midfield', 'Left Midfield', 'Attacking Midfield') THEN 'Midfielder'
        WHEN {{ col }} IN ('Offence', 'Right Winger', 'Centre-Forward', 'Left Winger') THEN 'Attacker'
        ELSE 'N/A' END

{%- endmacro %}