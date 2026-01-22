-- 99_Diagnostico_Schema_Total.sql
-- Diagnostico Unificado (Corrigido para correr num único comando)

SELECT 
    t.table_name, 
    o.object_type,
    o.status,
    t.column_id,
    t.column_name, 
    t.data_type, 
    t.data_length
FROM user_tab_columns t
JOIN user_objects o ON t.table_name = o.object_name
WHERE t.table_name IN (
    'TIPOS_GENERO',
    'TIPOS_DOC_IDENTIFICACAO',
    'TIPOS_ESTADO_TURMA',
    'LOCAIS',
    'ENTIDADES',
    'PROGRAMAS',
    'CURSOS',
    'TURMAS',
    'EQUIPA_FORMATIVA',
    'TIPOS_PLANO_DDF'
)
AND o.object_type IN ('TABLE', 'VIEW')
ORDER BY t.table_name, t.column_id;
