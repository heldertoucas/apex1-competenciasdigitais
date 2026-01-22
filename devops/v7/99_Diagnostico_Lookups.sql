SELECT table_name, column_name, data_type 
FROM user_tab_columns 
WHERE table_name IN ('TIPOS_GENERO', 'TIPOS_DOC_IDENTIFICACAO')
ORDER BY table_name, column_id;
