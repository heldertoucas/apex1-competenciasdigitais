-- SCRIPT DE DADOS DE TESTE (DUMMY DATA - V2)
-- Aplicação: Academia Digital (Refatorado para M:N)
-- Objetivo: Preencher tabelas centrais para testes de UI
-- NOTA: Este script limpa dados antes de inserir para evitar erros de unique constraint.

-- Limpeza de Dados (Executada instrução a instrução para evitar bloqueio total)
-- Se uma tabela não existir, o erro é ignorado e o script continua.

DELETE FROM Turma_Medalhas_Elegiveis;
DELETE FROM Modulo_Competencias;
DELETE FROM Competencia_Medalhas;
DELETE FROM Catalogo_Medalhas;
DELETE FROM Catalogo_Competencias;
DELETE FROM Modulos;
DELETE FROM Cursos;
DELETE FROM Programas;
DELETE FROM Papeis_Entidade;
DELETE FROM Entidades;

-- Limpeza de Lookups (Opcional)
DELETE FROM Tipos_Area_Competencia;
DELETE FROM Tipos_Nivel_Proficiencia;

COMMIT;

-- 0. Lookups Essenciais (Que estavam vazios)
INSERT INTO Tipos_Area_Competencia (Codigo, Descricao) VALUES ('DIGITAL', 'Competências Digitais');
INSERT INTO Tipos_Area_Competencia (Codigo, Descricao) VALUES ('SOFT', 'Soft Skills');

INSERT INTO Tipos_Nivel_Proficiencia (Codigo, Descricao, Ordem) VALUES ('BAS', 'Básico', 1);
INSERT INTO Tipos_Nivel_Proficiencia (Codigo, Descricao, Ordem) VALUES ('INT', 'Intermédio', 2);
INSERT INTO Tipos_Nivel_Proficiencia (Codigo, Descricao, Ordem) VALUES ('ADV', 'Avançado', 3);


-- 1. Programas (Catalogo)
INSERT INTO Programas (Codigo, Nome, Descricao, Ativo) 
VALUES ('PASSAPORTE', 'Passaporte Competências Digitais', 'Programa nacional de literacia digital.', 'S');

-- 2. Cursos
INSERT INTO Cursos (ID_Programa, Codigo, Nome, Carga_Horaria, Modalidade, ID_Estado_Curso, Objetivos_Gerais)
VALUES (
    (SELECT ID_Programa FROM Programas WHERE Codigo='PASSAPORTE'),
    'LIT_DIG_01', 
    'Literacia Digital Básica', 
    25, 
    'Presencial', 
    (SELECT ID_Estado_Curso FROM Tipos_Estado_Curso WHERE Codigo='ATIVO'),
    'Desenvolver competências básicas de navegação e segurança na internet.'
);

INSERT INTO Cursos (ID_Programa, Codigo, Nome, Carga_Horaria, Modalidade, ID_Estado_Curso)
VALUES (
    (SELECT ID_Programa FROM Programas WHERE Codigo='PASSAPORTE'),
    'EXCEL_AV', 
    'Excel Avançado para Gestão', 
    40, 
    'Online', 
    (SELECT ID_Estado_Curso FROM Tipos_Estado_Curso WHERE Codigo='RASCUNHO')
);

-- 3. Módulos
INSERT INTO Modulos (ID_Curso, Nome, Ordem, Carga_Horaria)
VALUES ((SELECT ID_Curso FROM Cursos WHERE Codigo='LIT_DIG_01'), 'Introdução ao PC', 1, 4);

INSERT INTO Modulos (ID_Curso, Nome, Ordem, Carga_Horaria)
VALUES ((SELECT ID_Curso FROM Cursos WHERE Codigo='LIT_DIG_01'), 'Navegação Segura', 2, 8);

-- 3b. Catálogo de Competências (M:N)
-- Agora com Area e Nivel preenchidos
INSERT INTO Catalogo_Competencias (Nome, Descricao, ID_Area_Competencia, ID_Nivel_Proficiencia)
VALUES (
    'Literacia Digital Básica', 
    'Capacidade de usar o computador e internet.',
    (SELECT ID_Area_Competencia FROM Tipos_Area_Competencia WHERE Codigo='DIGITAL'),
    (SELECT ID_Nivel_Proficiencia FROM Tipos_Nivel_Proficiencia WHERE Codigo='BAS')
);

INSERT INTO Catalogo_Competencias (Nome, Descricao, ID_Area_Competencia, ID_Nivel_Proficiencia)
VALUES (
    'Segurança Online', 
    'Identificar ameaças e navegar com segurança.',
    (SELECT ID_Area_Competencia FROM Tipos_Area_Competencia WHERE Codigo='DIGITAL'),
    (SELECT ID_Nivel_Proficiencia FROM Tipos_Nivel_Proficiencia WHERE Codigo='BAS')
);

INSERT INTO Catalogo_Competencias (Nome, Descricao, ID_Area_Competencia, ID_Nivel_Proficiencia)
VALUES (
    'Excel - Fórmulas', 
    'Criar fórmulas matemáticas e lógicas.',
    (SELECT ID_Area_Competencia FROM Tipos_Area_Competencia WHERE Codigo='DIGITAL'),
    (SELECT ID_Nivel_Proficiencia FROM Tipos_Nivel_Proficiencia WHERE Codigo='INT')
);

-- 3c. Catálogo de Medalhas
-- Agora incluindo URL_Claim_Badge
INSERT INTO Catalogo_Medalhas (Nome, URL_Medalha_Digital, URL_Claim_Badge) 
VALUES ('Badge Literacia', 'https://badges.examplo.com/lit-dig-basic', 'https://forms.claim/lit-dig');

INSERT INTO Catalogo_Medalhas (Nome, URL_Medalha_Digital, URL_Claim_Badge) 
VALUES ('Badge CyberSecurity', 'https://badges.examplo.com/security', 'https://forms.claim/sec');

INSERT INTO Catalogo_Medalhas (Nome, URL_Medalha_Digital, URL_Claim_Badge) 
VALUES ('Badge Excel Master', 'https://badges.examplo.com/excel-formulas', 'https://forms.claim/excel');

-- 3d. Associação Competência <-> Medalha
INSERT INTO Competencia_Medalhas (ID_Competencia, ID_Medalha)
VALUES (
    (SELECT ID_Competencia FROM Catalogo_Competencias WHERE Nome='Literacia Digital Básica'),
    (SELECT ID_Medalha FROM Catalogo_Medalhas WHERE Nome='Badge Literacia')
);

INSERT INTO Competencia_Medalhas (ID_Competencia, ID_Medalha)
VALUES (
    (SELECT ID_Competencia FROM Catalogo_Competencias WHERE Nome='Segurança Online'),
    (SELECT ID_Medalha FROM Catalogo_Medalhas WHERE Nome='Badge CyberSecurity')
);

INSERT INTO Competencia_Medalhas (ID_Competencia, ID_Medalha)
VALUES (
    (SELECT ID_Competencia FROM Catalogo_Competencias WHERE Nome='Excel - Fórmulas'),
    (SELECT ID_Medalha FROM Catalogo_Medalhas WHERE Nome='Badge Excel Master')
);

-- 3e. Associação Módulos <-> Competências
-- Associar "Literacia Digital" ao módulo "Introdução ao PC"
INSERT INTO Modulo_Competencias (ID_Modulo, ID_Competencia)
VALUES (
    (SELECT ID_Modulo FROM Modulos WHERE Nome='Introdução ao PC'),
    (SELECT ID_Competencia FROM Catalogo_Competencias WHERE Nome='Literacia Digital Básica')
);

-- Associar "Segurança Online" ao módulo "Navegação Segura"
INSERT INTO Modulo_Competencias (ID_Modulo, ID_Competencia)
VALUES (
    (SELECT ID_Modulo FROM Modulos WHERE Nome='Navegação Segura'),
    (SELECT ID_Competencia FROM Catalogo_Competencias WHERE Nome='Segurança Online')
);

-- 4. Pessoas (Entidades)
-- Admin
INSERT INTO Entidades (Nome_Completo, Email, ID_Genero, ID_Situacao_Prof, ID_Qualificacao, Consentimento_RGPD)
VALUES ('Admin Sistema', 'admin@academia.pt', 
    (SELECT ID_Genero FROM Tipos_Genero WHERE Codigo='M'),
    (SELECT ID_Situacao_Prof FROM Tipos_Situacao_Profissional WHERE Codigo='EMP_CONTRA'),
    (SELECT ID_Qualificacao FROM Tipos_De_Qualificacao WHERE Codigo='LIC'),
    'S'
);

-- Formador
INSERT INTO Entidades (Nome_Completo, Email, ID_Genero, ID_Situacao_Prof, Profissao, Consentimento_RGPD)
VALUES ('Joana Silva (Formadora)', 'joana.silva@teste.pt', 
    (SELECT ID_Genero FROM Tipos_Genero WHERE Codigo='F'),
    (SELECT ID_Situacao_Prof FROM Tipos_Situacao_Profissional WHERE Codigo='EMP_PROPRIA'),
    'Engenheira Informática',
    'S'
);

-- Aluno 1
INSERT INTO Entidades (Nome_Completo, Email, ID_Genero, ID_Situacao_Prof, Consentimento_RGPD)
VALUES ('Manuel Ocupado', 'manuel.aluno@teste.pt', 
    (SELECT ID_Genero FROM Tipos_Genero WHERE Codigo='M'),
    (SELECT ID_Situacao_Prof FROM Tipos_Situacao_Profissional WHERE Codigo='DESEMP'),
    'S'
);

-- Aluno 2
INSERT INTO Entidades (Nome_Completo, Email, ID_Genero, ID_Situacao_Prof, Consentimento_RGPD)
VALUES ('Maria Estudante', 'maria.estudante@teste.pt', 
    (SELECT ID_Genero FROM Tipos_Genero WHERE Codigo='F'),
    (SELECT ID_Situacao_Prof FROM Tipos_Situacao_Profissional WHERE Codigo='ESTUDANTE'),
    'S'
);

-- 5. Papéis (Roles)
-- Admin
INSERT INTO Papeis_Entidade (ID_Entidade, Codigo_Papel)
VALUES ((SELECT ID_Entidade FROM Entidades WHERE Email='admin@academia.pt'), 'ADMIN');

-- Formador
INSERT INTO Papeis_Entidade (ID_Entidade, Codigo_Papel)
VALUES ((SELECT ID_Entidade FROM Entidades WHERE Email='joana.silva@teste.pt'), 'FORMADOR');

-- Aluno 1 e 2
INSERT INTO Papeis_Entidade (ID_Entidade, Codigo_Papel)
VALUES ((SELECT ID_Entidade FROM Entidades WHERE Email='manuel.aluno@teste.pt'), 'FORMANDO');

INSERT INTO Papeis_Entidade (ID_Entidade, Codigo_Papel)
VALUES ((SELECT ID_Entidade FROM Entidades WHERE Email='maria.estudante@teste.pt'), 'FORMANDO');

COMMIT;
