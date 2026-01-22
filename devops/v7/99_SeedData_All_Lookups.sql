-- 99_SeedData_All_Lookups.sql
-- Objetivo: Popular TODAS as tabelas de Lookup (Tipos_*) com dados iniciais
-- Metodo: PL/SQL Blocks robustos (Idempotente)
-- Data: 22-Jan-2026

BEGIN
    -- 1. Tipos_Area_Competencia (#19)
    BEGIN INSERT INTO Tipos_Area_Competencia (Codigo, Descricao, Ordem, Ativo) VALUES ('SEGURANCA', 'Segurança', 1, 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Area_Competencia (Codigo, Descricao, Ordem, Ativo) VALUES ('INFORMACAO', 'Informação e Dados', 2, 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Area_Competencia (Codigo, Descricao, Ordem, Ativo) VALUES ('COMUNICACAO', 'Comunicação e Colaboração', 3, 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Area_Competencia (Codigo, Descricao, Ordem, Ativo) VALUES ('CRIACAO_CONTEUDO', 'Criação de Conteúdo', 4, 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Area_Competencia (Codigo, Descricao, Ordem, Ativo) VALUES ('RESOLUCAO_PROBLEMAS', 'Resolução de Problemas', 5, 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 2. Tipos_Nivel_Proficiencia (#20)
    BEGIN INSERT INTO Tipos_Nivel_Proficiencia (Codigo, Descricao, Ordem) VALUES ('BASICO', 'Básico (Iniciação)', 1); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Nivel_Proficiencia (Codigo, Descricao, Ordem) VALUES ('INTERMEDIO', 'Intermédio (Autonomia)', 2); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Nivel_Proficiencia (Codigo, Descricao, Ordem) VALUES ('AVANCADO', 'Avançado (Especialização)', 3); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 3. Tipos_Estado_Curso (#21)
    BEGIN INSERT INTO Tipos_Estado_Curso (Codigo, Descricao) VALUES ('RASCUNHO', 'Em Rascunho'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Curso (Codigo, Descricao) VALUES ('ATIVO', 'Ativo'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Curso (Codigo, Descricao) VALUES ('ARQUIVADO', 'Arquivado/Inativo'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 4. Tipos_Genero (#22) - (Ja existia mas reforcamos)
    BEGIN INSERT INTO Tipos_Genero (Codigo, Descricao) VALUES ('M', 'Masculino'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Genero (Codigo, Descricao) VALUES ('F', 'Feminino'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Genero (Codigo, Descricao) VALUES ('O', 'Outro / Prefiro não dizer'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 5. Tipos_Doc_Identificacao (#23)
    BEGIN INSERT INTO Tipos_Doc_Identificacao (Codigo, Descricao) VALUES ('CC', 'Cartão de Cidadão'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Doc_Identificacao (Codigo, Descricao) VALUES ('PASSAPORTE', 'Passaporte'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Doc_Identificacao (Codigo, Descricao) VALUES ('AR', 'Autorização de Residência'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 6. Tipos_Situacao_Profissional (#24)
    BEGIN INSERT INTO Tipos_Situacao_Profissional (Codigo, Descricao) VALUES ('EMPREGADO', 'Empregado (Conta de Outrem)'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Situacao_Profissional (Codigo, Descricao) VALUES ('INDEPENDENTE', 'Trabalhador Independente'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Situacao_Profissional (Codigo, Descricao) VALUES ('DESEMPREGADO', 'Desempregado'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Situacao_Profissional (Codigo, Descricao) VALUES ('ESTUDANTE', 'Estudante'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Situacao_Profissional (Codigo, Descricao) VALUES ('REFORMADO', 'Reformado'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 7. Tipos_De_Qualificacao (#25)
    BEGIN INSERT INTO Tipos_De_Qualificacao (Codigo, Descricao, Ordem) VALUES ('BASICO_1', '1º Ciclo (4º Ano)', 10); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_De_Qualificacao (Codigo, Descricao, Ordem) VALUES ('BASICO_2', '2º Ciclo (6º Ano)', 20); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_De_Qualificacao (Codigo, Descricao, Ordem) VALUES ('BASICO_3', '3º Ciclo (9º Ano)', 30); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_De_Qualificacao (Codigo, Descricao, Ordem) VALUES ('12ANO', 'Ensino Secundário (12º Ano)', 40); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_De_Qualificacao (Codigo, Descricao, Ordem) VALUES ('TESP', 'Curso Técnico Superior Profissional', 50); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_De_Qualificacao (Codigo, Descricao, Ordem) VALUES ('LICENCIATURA', 'Licenciatura', 60); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_De_Qualificacao (Codigo, Descricao, Ordem) VALUES ('MESTRADO', 'Mestrado', 70); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_De_Qualificacao (Codigo, Descricao, Ordem) VALUES ('DOUTORAMENTO', 'Doutoramento', 80); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 8. Tipos_Estado_Turma (#26)
    BEGIN INSERT INTO Tipos_Estado_Turma (Codigo, Descricao) VALUES ('PLANEADA', 'Planeada / Agendada'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Turma (Codigo, Descricao) VALUES ('CONFIRMADA', 'Confirmada'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Turma (Codigo, Descricao) VALUES ('DECORRER', 'Em Curso'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Turma (Codigo, Descricao) VALUES ('TERMINADA', 'Terminada'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Turma (Codigo, Descricao) VALUES ('CANCELADA', 'Cancelada'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 9. Tipos_Estado_Matricula (#27)
    BEGIN INSERT INTO Tipos_Estado_Matricula (Codigo, Descricao) VALUES ('INSCRITO', 'Inscrito / Pendente Seleção'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Matricula (Codigo, Descricao) VALUES ('SELECIONADO', 'Selecionado'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Matricula (Codigo, Descricao) VALUES ('FREQUENTAR', 'A Frequentar'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Matricula (Codigo, Descricao) VALUES ('CONCLUIDO', 'Concluído com Sucesso'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Matricula (Codigo, Descricao) VALUES ('NAO_CONCLUIDO', 'Não Concluído / Reprovado'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Matricula (Codigo, Descricao) VALUES ('DESISTIU', 'Desistiu'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 10. Tipos_Estado_Presenca (#28)
    BEGIN INSERT INTO Tipos_Estado_Presenca (Codigo, Descricao, Considera_Presenca) VALUES ('P', 'Presente', 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Presenca (Codigo, Descricao, Considera_Presenca) VALUES ('F', 'Falta Injustificada', 'N'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Presenca (Codigo, Descricao, Considera_Presenca) VALUES ('FJ', 'Falta Justificada', 'N'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Presenca (Codigo, Descricao, Considera_Presenca) VALUES ('O', 'Online / Remoto', 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 11. Tipos_Nivel_Experiencia (#29)
    BEGIN INSERT INTO Tipos_Nivel_Experiencia (Codigo, Descricao) VALUES ('INICIANTE', 'Iniciante - Nunca usou'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Nivel_Experiencia (Codigo, Descricao) VALUES ('BASICO', 'Básico - Uso esporádico'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Nivel_Experiencia (Codigo, Descricao) VALUES ('AUTONOMO', 'Autónomo - Uso regular'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Nivel_Experiencia (Codigo, Descricao) VALUES ('AVANCADO', 'Avançado - Uso profissional intensivo'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 12. Tipos_Equipamento (#30)
    BEGIN INSERT INTO Tipos_Equipamento (Codigo, Descricao) VALUES ('PC_PORTATIL', 'PC Portátil'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Equipamento (Codigo, Descricao) VALUES ('TABLET', 'Tablet'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Equipamento (Codigo, Descricao) VALUES ('ROUTER', 'Router 4G/5G'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Equipamento (Codigo, Descricao) VALUES ('PROJECTOR', 'Projetor de Vídeo'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Equipamento (Codigo, Descricao) VALUES ('KIT_ROBOTICA', 'Kit de Robótica'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 13. Tipos_Plano_DDF (#31)
    BEGIN INSERT INTO Tipos_Plano_DDF (Codigo, Descricao) VALUES ('INTERNA', 'Formação Interna'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Plano_DDF (Codigo, Descricao) VALUES ('EXTERNA', 'Formação Externa'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 14. Tipos_Documento_Dossier (#32)
    BEGIN INSERT INTO Tipos_Documento_Dossier (Codigo, Descricao, Obrigatorio) VALUES ('SUMARIOS', 'Sumários Assinados', 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Documento_Dossier (Codigo, Descricao, Obrigatorio) VALUES ('PAUTA', 'Pauta de Avaliação', 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Documento_Dossier (Codigo, Descricao, Obrigatorio) VALUES ('PRESENCAS', 'Folha de Presenças', 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Documento_Dossier (Codigo, Descricao, Obrigatorio) VALUES ('CRONOGRAMA', 'Cronograma Final', 'N'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Documento_Dossier (Codigo, Descricao, Obrigatorio) VALUES ('QUEST_SAT', 'Questionários de Satisfação (Resumo)', 'S'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 15. Tipos_Notificacao (#33)
    BEGIN INSERT INTO Tipos_Notificacao (Codigo, Descricao) VALUES ('EMAIL', 'Email'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Notificacao (Codigo, Descricao) VALUES ('SMS', 'SMS'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Notificacao (Codigo, Descricao) VALUES ('PLATAFORMA', 'Notificação Interna (App)'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    COMMIT;
END;
/
