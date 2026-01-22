-- 04_Automacao_Cronograma.sql
-- Objetivo: PL/SQL para gerar sessões automaticamente na página "Detalhe de Turma"
-- Uso: Copiar este código para um Processo "Execute Code" no APEX

DECLARE
    -- Mapeie os itens da sua página para estas variáveis
    l_data_inicio DATE := :P10_DATA_INICIO; 
    l_data_fim    DATE := :P10_DATA_FIM;
    l_id_turma    NUMBER := :P10_ID_TURMA;
    
    -- Variável de iteração
    l_data_atual  DATE;
    l_dia_semana  NUMBER; -- 1 (Domingo) a 7 (Sábado) dependendo do NLS
BEGIN
    l_data_atual := l_data_inicio;

    -- Loop da data inicio à data fim
    WHILE l_data_atual <= l_data_fim LOOP
        -- Verificar dia da semana (Formato numérico 'D')
        l_dia_semana := TO_NUMBER(TO_CHAR(l_data_atual, 'D'));
        
        -- EXCLUIR Fim de Semana (Assumindo NLS_TERRITORY=AMERICA onde 1=DOM, 7=SAB ou similar)
        -- Ajuste: verificar a nomenclatura do seu servidor. 
        -- Regra Segura: Usar 'DY' e verificar 'SAT'/'SUN' ou 'SÁB'/'DOM' se souber a língua.
        -- Regra Genérica Numérica: Normalmente Sábado e Domingo são extremos.
        
        -- Versão simplificada: Segunda a Sexta
        -- Nota: O utilizador deve ajustar esta lógica se as aulas forem aos Sábados.
        IF TO_CHAR(l_data_atual, 'DY', 'nls_date_language=ENGLISH') NOT IN ('SAT', 'SUN') THEN 
            
            INSERT INTO Sessoes (
                ID_Turma, 
                Nome, 
                Data_Sessao, 
                Hora_Inicio, 
                Hora_Fim
            )
            VALUES (
                l_id_turma, 
                'Sessão Regular', 
                l_data_atual, 
                '18:00', 
                '20:00'
            );
            
        END IF;

        l_data_atual := l_data_atual + 1;
    END LOOP;
END;
