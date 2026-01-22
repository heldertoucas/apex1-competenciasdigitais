-- 04_DummyData_Logistica.sql
-- Objetivo: Popular a base de dados com dados de teste para o Capítulo 4
-- Data: 22-Jan-2026 (v3 - PL/SQL Robust)

BEGIN
    -- 1. Tabelas de Lookup (Tipos)
    -- Generos
    BEGIN INSERT INTO Tipos_Genero (Codigo, Descricao) VALUES ('M', 'Masculino'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Genero (Codigo, Descricao) VALUES ('F', 'Feminino'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- Tipos Documento
    BEGIN INSERT INTO Tipos_Doc_Identificacao (Codigo, Descricao) VALUES ('CC', 'Cartão Cidadão'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- Estado Turma
    BEGIN INSERT INTO Tipos_Estado_Turma (Codigo, Descricao) VALUES ('PLANEADA', 'Planeada'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Turma (Codigo, Descricao) VALUES ('CONFIRMADA', 'Confirmada'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Turma (Codigo, Descricao) VALUES ('DECORRER', 'Em Curso'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Tipos_Estado_Turma (Codigo, Descricao) VALUES ('TERMINADA', 'Terminada'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- Locais (Nota: Codigo assume-se UK. Se nao for, pode nao disparar exception, mas mal nao faz duplicar neste contexto de teste)
    BEGIN INSERT INTO Locais (Nome, Morada, Capacidade, Codigo) VALUES ('Sala Lisboa Digital', 'Campo Grande 25', 20, 'SALA_LIS_DIG'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;
    BEGIN INSERT INTO Locais (Nome, Morada, Capacidade, Codigo) VALUES ('Auditório Central', 'Praça do Município', 100, 'AUDITORIO_MAIN'); EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; END;

    -- 2. Entidades (Pessoas)
    -- As Entidades tem UK no Email e NIF, por isso DUP_VAL_ON_INDEX funciona bem
    
    -- Coordenador
    BEGIN
        INSERT INTO Entidades (Nome_Completo, Email, ID_Genero, ID_Tipo_Doc, Num_Doc_Identificacao)
        VALUES (
            'Ana Coordenadora', 'ana.coord@exemplo.com', 
            (SELECT ID_Genero FROM Tipos_Genero WHERE Codigo='F'),
            (SELECT ID_Tipo_Doc FROM Tipos_Doc_Identificacao WHERE Codigo='CC'), '12345678'
        );
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    -- Formador 1
    BEGIN
        INSERT INTO Entidades (Nome_Completo, Email, ID_Genero, ID_Tipo_Doc, Num_Doc_Identificacao, Profissao)
        VALUES (
            'João Formador', 'joao.formador@exemplo.com', 
            (SELECT ID_Genero FROM Tipos_Genero WHERE Codigo='M'),
            (SELECT ID_Tipo_Doc FROM Tipos_Doc_Identificacao WHERE Codigo='CC'), '87654321', 'Engenheiro Informático'
        );
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    -- Formador 2
    BEGIN
        INSERT INTO Entidades (Nome_Completo, Email, ID_Genero, ID_Tipo_Doc, Num_Doc_Identificacao)
        VALUES (
            'Maria Instrutora', 'maria.instr@exemplo.com', 
            (SELECT ID_Genero FROM Tipos_Genero WHERE Codigo='F'),
            (SELECT ID_Tipo_Doc FROM Tipos_Doc_Identificacao WHERE Codigo='CC'), '11223344'
        );
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    -- 3. Catálogo (Programas e Cursos)
    -- Programa
    BEGIN
        INSERT INTO Programas (Codigo, Nome, Descricao, Ativo)
        VALUES ('LIT_DIG', 'Literacia Digital', 'Programa de inclusão digital.', 'S');
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    -- Curso
    BEGIN
        INSERT INTO Cursos (ID_Programa, Codigo, Nome, Carga_Horaria)
        VALUES (
            (SELECT ID_Programa FROM Programas WHERE Codigo='LIT_DIG'), 
            'EXCEL_BASICO', 'Curso de Excel Básico', 20
        );
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    -- 4. Operações (Turmas)
    -- Turma 1
    BEGIN
        INSERT INTO Turmas (ID_Curso, Codigo_Turma, Nome_Turma, ID_Estado_Turma, Data_Inicio, Data_Fim, ID_Local, ID_Coordenador, ID_Tipo_Plano, Vagas)
        VALUES (
            (SELECT ID_Curso FROM Cursos WHERE Codigo='EXCEL_BASICO'),
            'TURMA_EXCEL_01_2026', 'Excel Iniciantes Jan/26',
            (SELECT ID_Estado_Turma FROM Tipos_Estado_Turma WHERE Codigo='PLANEADA'),
            TRUNC(SYSDATE + 5), TRUNC(SYSDATE + 20),
            (SELECT ID_Local FROM Locais WHERE Codigo='SALA_LIS_DIG'),
            (SELECT ID_Entidade FROM Entidades WHERE Email='ana.coord@exemplo.com'),
            (SELECT ID_Tipo_Plano FROM Tipos_Plano_DDF WHERE Codigo='INTERNA'),
            15
        );
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    -- 5. Equipa da Turma
    -- Equipa (PK composta ID_Turma + ID_Formador)
    BEGIN
        INSERT INTO Equipa_Formativa (ID_Turma, ID_Formador, Principal)
        VALUES (
            (SELECT ID_Turma FROM Turmas WHERE Codigo_Turma='TURMA_EXCEL_01_2026'),
            (SELECT ID_Entidade FROM Entidades WHERE Email='joao.formador@exemplo.com'),
            'S'
        );
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    COMMIT;
END;
/
