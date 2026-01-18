# Modelo de Dados Refatorado: SGUF (v5.0 - Final / PT)

Este modelo baseia-se na especificação **SGUF v5.0 (SmartDB, Entidades Unificadas, Tokens)** mas mantém a nomenclatura em **Português** e a granularidade/riqueza descritiva da versão 4.0 anterior.

---

## 2. Diagrama de Esquema (Especificação Técnica)

### A. Domínio: Configuração e Catálogo (CORE)

Responsável pela definição da oferta formativa e regras de negócio.

#### 1. `Programas` (LMS_PROGRAMS)

*Catálogo de topo (ex: "Passaporte Competências Digitais").*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Programa** | `NUMBER` | `PK, Identity` | Chave primária única para cada programa. | `ID` |
| **Codigo** | `VARCHAR2(50)` | `UK, Not Null` | **(Novo v5)** Código interno único (ex: 'PASSAPORTE', 'IA_TODOS'). | `CODE` |
| **Nome** | `VARCHAR2(200)` | `Not Null` | O nome oficial do programa. | `NAME` |
| **Descricao** | `VARCHAR2(4000)` | | Uma breve descrição dos objetivos e público-alvo do programa. | `DESCRIPTION` |
| **Ativo** | `CHAR(1)` | `Check ('S','N')` | **(Novo v5)** Se o programa está ativo. | `IS_ACTIVE` |

#### 2. `Cursos` (LMS_COURSES)

*A unidade de formação (ex: "Literacia Digital Nível 1").*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Curso** | `NUMBER` | `PK, Identity` | Chave primária única para cada curso. | `ID` |
| **ID_Programa** | `NUMBER` | `FK` | Relaciona com `Programas`. | `PROGRAM_ID` |
| **Codigo** | `VARCHAR2(50)` | `UK` | **(Novo v5)** Código do curso (ex: 'LIT_DIG_01'). | `CODE` |
| **Nome** | `VARCHAR2(255)` | `Not Null` | O nome oficial do curso. | `NAME` |
| **Nome_Curso_SIGO** | `VARCHAR2(100)` | | Designação oficial para exportação SIGO. | `SIGO_REF_CODE` |
| **Carga_Horaria** | `NUMBER` | | Carga horária total prevista. | `DURATION_HOURS` |
| **Modalidade** | `VARCHAR2(20)` | `Check` | 'ONLINE', 'PRESENCIAL', 'HIBRIDO'. (Substitui `Modalidade_Formacao`) | `MODE` |
| **Metadados_Info** | `CLOB` | `JSON` | **(Novo v5)** Armazena JSON com: Objetivos Gerais/Específicos, Conteúdos, Público-Alvo (campos longos da v4). | `METADATA` |
| **ID_Estado_Curso** | `NUMBER` | `FK` | Referência ao estado (Lookup). Mantido da v4 para compatibilidade. | |

#### 3. `Modulos` (LMS_MODULES)

*Subdivisão estrutural do curso. Um curso é composto por 1 ou mais módulos.*
**(Nova Tabela v5)** - Necessária para a hierarquia estrita.

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Modulo** | `NUMBER` | `PK, Identity` | Identificador único do módulo. | `ID` |
| **ID_Curso** | `NUMBER` | `FK` | Relaciona com `Cursos`. | `COURSE_ID` |
| **Nome** | `VARCHAR2(255)` | `Not Null` | Nome do módulo (ex: "Módulo 1: Segurança"). | `NAME` |
| **Ordem** | `NUMBER` | | Ordem de apresentação no curso, | `SEQ_ORDER` |
| **Carga_Horaria** | `NUMBER` | | Carga horária específica deste módulo. | `HOURS` |
| **Tipo_Avaliacao** | `VARCHAR2(20)` | `Check` | 'QUANTITATIVA', 'QUALITATIVA', 'NENHUMA'. Define como este módulo é pontuado. | `EVAL_TYPE` |

#### 4. `Competencias` (LMS_COMPETENCIES)

*Define a competência e a medalha digital associada (1:1).*
**Alteração v5:** Agora liga-se ao `Modulo`, não diretamente ao Curso (M:M anterior).

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Competencia** | `NUMBER` | `PK, Identity` | Identificador único. | `ID` |
| **ID_Modulo** | `NUMBER` | `FK` | **(Novo v5)** Relaciona com `Modulos`. A competência pertence a um módulo. | `MODULE_ID` |
| **Nome** | `VARCHAR2(255)` | `Not Null` | Nome da competência/medalha. | `NAME` |
| **Area_DigComp** | `VARCHAR2(50)` | | Área DigComp (Lookup). | `DIGCOMP_AREA` |
| **Nivel_DigComp** | `VARCHAR2(50)` | | Nível de proficiência. | `DIGCOMP_LEVEL` |
| **URL_Info_Badge** | `VARCHAR2(500)` | | Link para consulta/detalhes da medalha (Lisboa Cidade da Aprendizagem). | `BADGE_INFO_URL` |
| **URL_Claim_Badge** | `VARCHAR2(500)` | | **(Crítico v5)** Link direto para o formulário de obtenção desta medalha específica. | `BADGE_CLAIM_URL` |
| **URL_Imagem_Badge** | `VARCHAR2(500)` | | Link para o ícone/imagem da medalha. | `BADGE_IMAGE_URL` |

---

### B. Domínio: Entidades e Atores (PEOPLE)

Centraliza todos os dados de pessoas numa única tabela, eliminando duplicações.

#### 5. `Entidades` (LMS_ENTITIES)

*Substitui as tabelas antigas `Inscritos`, `Formadores`, `Coordenadores`.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Entidade** | `NUMBER` | `PK, Identity` | Identificador interno único de qualquer pessoa no sistema. | `ID` |
| **NIF** | `VARCHAR2(20)` | `UK` | Número de Contribuinte (Chave de Deduplicação). | `NIF` |
| **Email** | `VARCHAR2(255)` | `UK, Not Null` | Email principal (Chave de Contacto e Login). | `EMAIL` |
| **Nome_Completo** | `VARCHAR2(255)` | `Not Null` | Nome completo oficial. | `FULL_NAME` |
| **Telemovel** | `VARCHAR2(50)` | | Contacto telefónico. | `MOBILE` |
| **Data_Nascimento** | `DATE` | | Data de nascimento. | `BIRTH_DATE` |
| **Consentimento_RGPD**| `CHAR(1)` | `Check ('S','N')` | Consentimento para tratamento de dados. | `GDPR_CONSENT` |
| **Perfil_JSON** | `CLOB` | `JSON` | **(Flexível)** Armazena campos variáveis da v4: `Habilitacoes`, `Morada`, `Situacao_Profissional`, `Naturalidade`, etc. | `PROFILE_DATA` |
| **Ativo** | `CHAR(1)` | | Estado geral da entidade no sistema. | `IS_ACTIVE` |

#### 6. `Papeis_Entidade` (LMS_ENTITY_ROLES)

*Define o que a pessoa "é" no sistema (se tem permissões de formador, etc).*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Papel** | `NUMBER` | `PK` | Chave única. | `ID` |
| **ID_Entidade** | `NUMBER` | `FK` | Relaciona com `Entidades`. | `ENTITY_ID` |
| **Codigo_Papel** | `VARCHAR2(20)` | `Check` | 'ADMIN', 'FORMADOR', 'FORMANDO', 'COORDENADOR'. | `ROLE_CODE` |

---

### C. Domínio: Operação e Execução (OPS)

Gere as turmas, inscrições e execução da formação.

#### 7. `Turmas` (LMS_CLASSES)

*Instância de execução de um curso.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Turma** | `NUMBER` | `PK, Identity` | Identificador da turma. | `ID` |
| **ID_Curso** | `NUMBER` | `FK` | Curso associado. | `COURSE_ID` |
| **Codigo_Turma** | `VARCHAR2(100)` | `UK` | Código único da oferta (ex: "LIS_T1_2025"). | `COHORT_CODE` |
| **Estado** | `VARCHAR2(20)` | `Check` | 'PLANEADA', 'ABERTA', 'EM_CURSO', 'FECHADA'. | `STATUS` |
| **Data_Inicio** | `DATE` | | Data de início prevista/real. | `START_DATE` |
| **Data_Fim** | `DATE` | | Data de fim prevista/real. | `END_DATE` |
| **ID_Local** | `NUMBER` | `FK` | Local de formação (Lookup `Locais`). | `LOCATION_ID` |
| **Descricao_Horario** | `VARCHAR2(500)` | | Descrição textual do horário (simplificado). | `SCHEDULE_DESC` |
| **ID_Coordenador** | `NUMBER` | `FK` | Relaciona com `Entidades` (que tenha papel Coordenador). | `COORDINATOR_ID` |
| **Num_Informacao_SIGO**| `VARCHAR2(100)` | | Nº Informação Autorização (SIGO). | `SIGO_INFO_NUM` |
| **Cod_Acao_SIGO** | `VARCHAR2(100)` | | Código da Ação (SIGO). | `SIGO_ACTION_COD` |
| **Avaliacao_Ativa** | `CHAR(1)` | `Default 'N'` | **(Magic Switch v5)** Controla se os links de avaliação/desafio estão visíveis para os alunos desta turma. | `IS_EVAL_ACTIVE` |
| **Estado_Dossier** | `VARCHAR2(20)` | | Estado macro do Dossier Técnico ('PENDENTE', 'COMPLETO'). | `DOSSIER_STATUS` |

#### 8. `Equipa_Formativa` (LMS_CLASS_TRAINERS)

*Tabela de ligação que permite N formadores por turma.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Turma** | `NUMBER` | `FK` | Turma. | `CLASS_ID` |
| **ID_Formador** | `NUMBER` | `FK` | Formador (`Entidades`). | `TRAINER_ID` |
| **Principal** | `CHAR(1)` | | Indica se é o formador responsável/coordenador pedagógico da turma. | `IS_MAIN` |

#### 9. `Matriculas` (LMS_ENROLLMENTS)

*A relação entre um aluno (Entidade) e uma Turma.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Matricula** | `NUMBER` | `PK, Identity` | Identificador da matrícula. | `ID` |
| **ID_Turma** | `NUMBER` | `FK` | Turma. | `CLASS_ID` |
| **ID_Aluno** | `NUMBER` | `FK` | Aluno (`Entidades`). | `STUDENT_ID` |
| **Token_Acesso** | `VARCHAR2(20)` | `UK, Not Null` | **(Magic Token v5)** O código curto (ex: "IA230T") único por aluno/turma usado para acesso simplificado sem login. | `AUTH_TOKEN` |
| **Estado** | `VARCHAR2(20)` | `Check` | 'INSCRITO', 'DESISTENTE', 'CONCLUIDO', 'REPROVADO'. | `STATUS` |
| **Classificacao_Final** | `VARCHAR2(50)` | | Nota final ou Menção Qualitativa consolidada (ex: "Apto"). | `FINAL_GRADE` |
| **Obs_SIGO** | `VARCHAR2(4000)` | | Observações para certificação SIGO ("Tem direito módulo X..."). | `SIGO_OBS` |
| **Data_Criacao** | `DATE` | | Data da matrícula. | `CREATED_AT` |

#### 10. `Sessoes` (LMS_SESSIONS)

*Registo diário (aulas) para presenças e sumários.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Sessao** | `NUMBER` | `PK` | Identificador único. | `ID` |
| **ID_Turma** | `NUMBER` | `FK` | Turma a que pertence. | `CLASS_ID` |
| **Data_Sessao** | `DATE` | | Data da aula. | `SESSION_DATE` |
| **Duracao_Horas** | `NUMBER` | | Duração em horas. | `DURATION` |
| **Sumario** | `CLOB` | | Texto do sumário da sessão. | `SUMMARY` |
| **ID_Formador** | `NUMBER` | `FK` | Formador que efetivamente lecionou esta sessão (pode ser diferente do titular). | `TRAINER_ID` |
| **URL_Recursos** | `VARCHAR2(500)` | | Link para recursos pedagógicos desta sessão (v4). | |

#### 11. `Presencas` (LMS_ATTENDANCE)

*Tabela transacional de assiduidade.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Sessao** | `NUMBER` | `FK` | Sessão. | `SESSION_ID` |
| **ID_Matricula** | `NUMBER` | `FK` | Matrícula do aluno. | `ENROLLMENT_ID` |
| **Estado** | `VARCHAR2(10)` | `Check` | 'P' (Presente), 'F' (Falta), 'FJ' (Falta Justificada). | `STATUS` |
| **Horas_Assistidas**| `NUMBER` | | Horas contabilizadas para o aluno nesta sessão. | `HOURS_ATTENDED` |

---

### D. Domínio: Avaliação e Certificação (EVAL)

Gere os resultados granulares e a ligação às medalhas digitais.

#### 12. `Avaliacoes_Modulo` (LMS_ASSESSMENTS)

*Resultados granulares por módulo. Substitui campos soltos.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Avaliacao** | `NUMBER` | `PK` | Identificador. | `ID` |
| **ID_Matricula** | `NUMBER` | `FK` | Aluno/Turma. | `ENROLLMENT_ID` |
| **ID_Modulo** | `NUMBER` | `FK` | Módulo que está a ser avaliado. | `MODULE_ID` |
| **Nota_Quantitativa** | `NUMBER` | | Nota numérica (ex: importada do Google Forms ou Excel). | `SCORE_NUM` |
| **Feedback_Texto** | `CLOB` | | Avaliação qualitativa do formador ou observações. | `FEEDBACK_TEXT` |
| **Aprovado** | `CHAR(1)` | | Se o aluno obteve aproveitamento neste módulo. | `IS_APPROVED` |

#### 13. `Badges_Conquistados` (LMS_STUDENT_BADGES)

*Registo de que a medalha foi atribuída ou "conquistada".*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Badge_Aluno** | `NUMBER` | `PK` | Identificador. | `ID` |
| **ID_Matricula** | `NUMBER` | `FK` | Aluno/Turma. | `ENROLLMENT_ID` |
| **ID_Competencia** | `NUMBER` | `FK` | Competência/Badge associado. | `COMPETENCY_ID` |
| **Data_Conquista** | `DATE` | | Data em que o badge foi obtido. | `AWARDED_DATE` |
| **URL_Evidencia** | `VARCHAR2(500)` | | URL da "Badge Assertion" (evidência externa). | `EXTERNAL_URL` |

---

### E. Domínio: Gestão Administrativa e Staging (ADMIN)

#### 14. `Itens_Dossier` (LMS_DOSSIER_CHECKLIST)

*Substitui as colunas fixas `Check_...` da v4 por uma lista flexível.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Item** | `NUMBER` | `PK` | Identificador. | `ID` |
| **ID_Turma** | `NUMBER` | `FK` | Turma. | `CLASS_ID` |
| **Tipo_Documento** | `VARCHAR2(50)` | | Ex: 'SUMARIOS', 'PRESENCAS', 'RELATORIO_AVALIACAO'. | `DOC_TYPE` |
| **Presente** | `CHAR(1)` | | 'S' se o documento existe/foi validado. | `IS_PRESENT` |
| **Link_Ficheiro** | `VARCHAR2(500)` | | Link para SharePoint/Drive (opcional). | `FILE_LINK` |
| **Validado_Por** | `VARCHAR2(255)` | | Nome do utilizador que validou a conformidade. | `VALIDATED_BY` |

#### 15. `Faturas_Formadores` (LMS_INVOICES)

*Gestão simplificada de pagamentos (trazida e adaptada da v4).*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- | :--- |
| **ID_Fatura** | `NUMBER` | `PK` | Identificador. | `ID` |
| **ID_Turma** | `NUMBER` | `FK` | Turma. | `CLASS_ID` |
| **ID_Formador** | `NUMBER` | `FK` | Formador. | `TRAINER_ID` |
| **Valor** | `NUMBER` | | Valor total a faturar. | `AMOUNT` |
| **Mes_Referencia** | `VARCHAR2(7)` | | Ex: '2025-10'. | `MONTH_REF` |
| **Estado** | `VARCHAR2(20)` | | 'EMITIDA', 'PAGA'. | `STATUS` |

#### 16. `Staging_Importacao` (STG_IMPORT_DATA)

*Tabela de interface para uploads de Excel (Pré-inscrições, Notas, etc).*
**(Novo v5)** Permite ingestão assíncrona.

| Nome do Campo | Tipo (Oracle) | Descrição / Propósito | (Mapeamento V5) |
| :--- | :--- | :--- | :--- |
| **ID_Staging** | `PK` | Identificador. | `ID` |
| **ID_Lote** | `VARCHAR2(50)` | Identificador do upload (Batch ID). | `BATCH_ID` |
| **Dados_Brutos_JSON** | `CLOB (JSON)` | Guarda a linha completa do Excel em formato JSON. | `RAW_DATA_JSON` |
| **Estado** | `VARCHAR2(20)` | 'PENDENTE', 'PROCESSADO', 'ERRO'. | `STATUS` |
| **Mensagem_Erro** | `VARCHAR2(4000)` | Detalhe do erro de validação (se houver). | `ERROR_MSG` |
| **Data_Importacao** | `TIMESTAMP` | Data do upload. | `IMPORTED_AT` |

---

### F. Tabelas de Lookup (Listas de Valores)

Mantendo a estrutura da v4 para as listas de suporte.

*   `Locais` (LMS_LOCATIONS)
*   `Slots_Horario` (LMS_SCHEDULE_SLOTS)
*   `Qualificacoes` (LMS_QUALIFICATIONS) - v4: `Tipos_De_Qualificacao`
*   `Situacoes_Profissionais` (LMS_PROFESSIONAL_SITUATIONS) - v4: `Tipos_Situacao_Profissional`
*   `Tipos_Equipamento` - Mantido da v4.
*   `Equipamentos_Alocados` - Mantido da v4 (pode ser ligado a Turma ID).

---

## 3. Notas de Implementação (Português)

1.  **Lógica do Link Mágico (Desafio Digital):**
    *   Não criar tabela de links. Usar a lógica: URL = `.../f?p=APP:STUDENT_AREA:::::P_TOKEN:IA230T`.
    *   Validar se o campo `Token_Acesso` em `Matriculas` corresponde.
    *   Validar se `Turmas.Avaliacao_Ativa = 'S'`.

2.  **Upsert de Pré-Inscrições (Via Excel):**
    *   Carregar Excel para `Staging_Importacao`.
    *   Processo PL/SQL lê o JSON.
    *   `MERGE` na tabela `Entidades` usando o NIF ou Email como chave.
    *   Insere em `Matriculas` apenas se o par (Aluno, Turma) não existir.

3.  **Dossier Flexível:**
    *   A tabela `Itens_Dossier` permite que a checklist mude sem alterar colunas da base de dados.
