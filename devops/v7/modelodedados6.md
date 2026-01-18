# Modelo de Dados Refatorado: SGUF (v6.0 - High Fidelity)

**Versão:** 6.0 (Unified & Explicit)
**Data:** 18 de Janeiro de 2026
**Base:** Estrutura v5 (SmartDB/Entidades Unificadas) + Riqueza de Dados v4 (Colunas Explícitas).

---

## 1. Princípios desta Versão

1.  **Estrutura Base v5:** Mantém-se a tabela única de Entidades (`LMS_ENTITIES`), a hierarquia `Programa > Curso > Módulo` e as tabelas de Staging.
2.  **Dados Explícitos (No JSON):** Todos os campos de metadados ("Objetivos", "Morada", "Habilitações") voltam a ser colunas dedicadas para facilitar validação e reporting, abandonando a abordagem JSON da v5.
3.  **Lookups Restaurados:** Todas as tabelas de domínio (Tipos, Categorias) da v4 foram reincorporadas.

---

## 2. Diagrama de Esquema

### A. Domínio: Configuração e Catálogo (CORE)

#### 1. `Programas` (LMS_PROGRAMS)
*Catálogo de topo.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Programa** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK, Not Null` | Ex: 'PASSAPORTE'. |
| **Nome** | `VARCHAR2(200)` | `Not Null` | Nome do programa. |
| **Descricao** | `VARCHAR2(4000)` | | Descrição pública. |
| **Ativo** | `CHAR(1)` | `Check ('S','N')` | Se o programa está ativo. |

#### 2. `Cursos` (LMS_COURSES)
*Unidade de formação. Campos detalhados restaurados.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Curso** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Programa** | `NUMBER` | `FK` | Programa associado. |
| **Codigo** | `VARCHAR2(50)` | `UK` | Código único (ex: 'LIT_DIG_01'). |
| **Nome** | `VARCHAR2(255)` | `Not Null` | Nome oficial. |
| **Nome_Curso_SIGO** | `VARCHAR2(100)` | | Referência SIGO. |
| **Carga_Horaria** | `NUMBER` | | Carga horária total. |
| **Modalidade** | `VARCHAR2(50)` | | Online, Presencial, Híbrido. |
| **Forma_Organizacao** | `VARCHAR2(50)` | | Formato de entrega. |
| **Publico_Alvo** | `VARCHAR2(4000)` | | Destinatários. |
| **Objetivos_Gerais** | `CLOB` | | Objetivos gerais de aprendizagem. |
| **Objetivos_Especificos** | `CLOB` | | Objetivos específicos. |
| **Conteudos_Programaticos**| `CLOB` | | Programa detalhado. |
| **Metodologia_Avaliacao** | `CLOB` | | Métodos de avaliação. |
| **URL_Manual_Digital** | `VARCHAR2(500)` | | Link para manual/recursos base. |
| **ID_Estado_Curso** | `NUMBER` | `FK` | Lookup: `Tipos_Estado_Curso`. |

#### 3. `Modulos` (LMS_MODULES)
*Estrutura hierárquica (V5).*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Modulo** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Curso** | `NUMBER` | `FK` | Curso associado. |
| **Nome** | `VARCHAR2(255)` | `Not Null` | Nome do módulo. |
| **Ordem** | `NUMBER` | | Sequência no curso. |
| **Carga_Horaria** | `NUMBER` | | Horas do módulo. |
| **Tipo_Avaliacao** | `VARCHAR2(20)` | `Check` | 'QUANTITATIVA', 'QUALITATIVA', 'NENHUMA'. |

#### 4. `Competencias` (LMS_COMPETENCIES)
*Catálogo de competências e badges.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Competencia** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Modulo** | `NUMBER` | `FK` | Módulo associado. |
| **Nome** | `VARCHAR2(255)` | `Not Null` | Nome da competência. |
| **Descricao** | `VARCHAR2(4000)` | | Detalhe da competência. |
| **ID_Area_Competencia** | `NUMBER` | `FK` | Lookup: `Tipos_Area_Competencia`. |
| **ID_Nivel_Proficiencia** | `NUMBER` | `FK` | Lookup: `Tipos_Nivel_Proficiencia`. |
| **URL_Medalha_Digital** | `VARCHAR2(500)` | | Link para badge info. |
| **URL_Icone_Badge** | `VARCHAR2(500)` | | Imagem do badge. |
| **URL_Claim_Badge** | `VARCHAR2(500)` | | Link para formulário de claim (V5). |

---

### B. Domínio: Pessoas e Entidades (PEOPLE)

#### 5. `Entidades` (LMS_ENTITIES)
*Tabela única para todos os intervenientes (Inscritos, Formadores, Staff, Coordenadores). Campos explícitos restaurados.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Entidade** | `NUMBER` | `PK, Identity` | Identificador único. |
| **NIF** | `VARCHAR2(20)` | `UK` | Identificador Fiscal (Deduplicação). |
| **Email** | `VARCHAR2(255)` | `UK` | Contacto principal. |
| **Nome_Completo** | `VARCHAR2(255)` | `Not Null` | Nome oficial. |
| **Telemovel** | `VARCHAR2(50)` | | Contacto telefónico. |
| **Data_Nascimento** | `DATE` | | Data de nascimento. |
| **ID_Genero** | `NUMBER` | `FK` | Lookup: `Tipos_Genero`. |
| **Naturalidade** | `VARCHAR2(100)` | | Local de nascimento. |
| **Nacionalidade** | `VARCHAR2(100)` | | País de nacionalidade. |
| **ID_Tipo_Doc** | `NUMBER` | `FK` | Lookup: `Tipos_Doc_Identificacao`. |
| **Num_Doc_Identificacao** | `VARCHAR2(50)` | | Nº CC/BI/Passaporte. |
| **Validade_Doc** | `DATE` | | Validade do documento. |
| **Morada** | `VARCHAR2(255)` | | Rua, Nº, Andar. |
| **Codigo_Postal** | `VARCHAR2(20)` | | Código postal. |
| **Localidade** | `VARCHAR2(100)` | | Localidade. |
| **ID_Situacao_Prof** | `NUMBER` | `FK` | Lookup: `Tipos_Situacao_Profissional`. |
| **ID_Qualificacao** | `NUMBER` | `FK` | Lookup: `Tipos_De_Qualificacao`. |
| **Consentimento_RGPD**| `CHAR(1)` | | 'S'/'N'. |
| **Observacoes** | `CLOB` | | Notas gerais. |
| **Data_Criacao** | `DATE` | | Data de registo no sistema. |
| **Ativo** | `CHAR(1)` | | Estado da entidade. |
| **Origem_Registo** | `VARCHAR2(50)` | | 'EXCEL', 'FORM', 'MANUAL'. |

#### 6. `Papeis_Entidade` (LMS_ENTITY_ROLES)
*Define os papéis (Roles) de cada entidade.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Papel** | `NUMBER` | `PK` | Chave primária. |
| **ID_Entidade** | `NUMBER` | `FK` | Relaciona com `Entidades`. |
| **Codigo_Papel** | `VARCHAR2(20)` | `Check` | 'ADMIN', 'FORMADOR', 'FORMANDO', 'COORDENADOR'. |

---

### C. Domínio: Operação Formativa (OPS)

#### 7. `Turmas` (LMS_CLASSES)
*Instância de um curso.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Turma** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Curso** | `NUMBER` | `FK` | Curso base. |
| **Codigo_Turma** | `VARCHAR2(100)` | `UK` | Ex: "LIS_T1_2025". |
| **Nome_Turma** | `VARCHAR2(200)` | | Designação amigável. |
| **ID_Estado_Turma** | `NUMBER` | `FK` | Lookup: `Tipos_Estado_Turma`. |
| **Data_Inicio** | `DATE` | | Início da turma. |
| **Data_Fim** | `DATE` | | Fim da turma. |
| **ID_Local** | `NUMBER` | `FK` | Lookup: `Locais`. |
| **Horario_Descritivo** | `VARCHAR2(500)` | | Texto do horário (ex: "2ª e 3ª, 19h"). |
| **ID_Coordenador** | `NUMBER` | `FK` | Coordenador pedagógico (`Entidades`). |
| **Vagas** | `NUMBER` | | Capacidade da turma. |
| **Num_Informacao** | `VARCHAR2(100)` | | Nº Informação Interna/SIGO. |
| **Num_Informacao_Mae**| `VARCHAR2(100)` | | Nº Informação Agrupadora (se houver). |
| **Cod_Acao_SIGO** | `VARCHAR2(100)` | | Código Ação SIGO. |
| **ID_Tipo_Plano** | `NUMBER` | `FK` | Lookup: `Tipos_Plano_DDF`. |
| **Avaliacao_Ativa** | `CHAR(1)` | | 'S'/'N' (Magic Switch). |
| **Observacoes** | `CLOB` | | Notas internas sobre a turma. |

#### 8. `Equipa_Formativa` (LMS_CLASS_TRAINERS)
*Associação N:N Formadores-Turma.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Formador** | `NUMBER` | `FK` | Formador. |
| **Principal** | `CHAR(1)` | | Formador responsável? |

#### 9. `Matriculas` (LMS_ENROLLMENTS)
*Inscrição do aluno na turma.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Matricula** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Aluno** | `NUMBER` | `FK` | Aluno. |
| **Token_Acesso** | `VARCHAR2(20)` | `UK` | Token estático para acesso (Magic Link). |
| **ID_Estado_Matricula**| `NUMBER` | `FK` | Lookup: `Tipos_Estado_Matricula`. |
| **Data_Inscricao** | `DATE` | | Data de criação da matrícula. |
| **Data_Conclusao** | `DATE` | | Data de fecho. |
| **Classificacao_Final**| `VARCHAR2(50)` | | Nota final. |
| **Total_Horas** | `NUMBER` | | Horas assistidas (Cache). |
| **Avaliacao_Curso** | `NUMBER` | | (1-5) Satisfação do aluno. |
| **Comentario_Aluno** | `CLOB` | | Feedback qualitativo do aluno. |
| **Obs_SIGO** | `VARCHAR2(4000)` | | Notas para certificação. |
| **ID_Nivel_Experiencia**| `NUMBER` | `FK` | Lookup: `Tipos_Nivel_Experiencia`. |

#### 10. `Sessoes` (LMS_SESSIONS)
*Aulas.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Sessao** | `NUMBER` | `PK` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **Nome** | `VARCHAR2(200)` | | Título da sessão. |
| **Data_Sessao** | `DATE` | | Dia da aula. |
| **Hora_Inicio** | `VARCHAR2(5)` | | Hora HH:MM. |
| **Hora_Fim** | `VARCHAR2(5)` | | Hora HH:MM. |
| **Duracao_Horas** | `NUMBER` | | Duração decimal. |
| **Sumario** | `CLOB` | | Conteúdo lecionado. |
| **ID_Formador** | `NUMBER` | `FK` | Formador desta sessão. |
| **URL_Recursos** | `VARCHAR2(1000)` | | Link para materiais. |

#### 11. `Presencas` (LMS_ATTENDANCE)
*Assiduidade.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Presenca** | `NUMBER` | `PK` | Chave primária. |
| **ID_Sessao** | `NUMBER` | `FK` | Sessão. |
| **ID_Matricula** | `NUMBER` | `FK` | Aluno. |
| **ID_Estado_Presenca**| `NUMBER` | `FK` | Lookup: `Tipos_Estado_Presenca`. |
| **Horas_Assistidas** | `NUMBER` | | Horas creditadas. |
| **Data_Registo** | `TIMESTAMP` | | Auditoria de registo. |

---

### D. Domínio: Avaliação (EVAL)

#### 12. `Avaliacoes_Modulo` (LMS_ASSESSMENTS)
*Notas granulares por módulo.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Avaliacao** | `NUMBER` | `PK` | Chave primária. |
| **ID_Matricula** | `NUMBER` | `FK` | Aluno. |
| **ID_Modulo** | `NUMBER` | `FK` | Módulo. |
| **Nota_Valor** | `NUMBER` | | Nota quantitativa. |
| **Feedback_Texto** | `CLOB` | | Feedback qualitativo. |
| **Aprovado** | `CHAR(1)` | | 'S'/'N'. |

#### 13. `Badges_Conquistados` (LMS_STUDENT_BADGES)
*Passaporte de competências.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Badge_Aluno** | `NUMBER` | `PK` | Chave primária. |
| **ID_Matricula** | `NUMBER` | `FK` | Aluno/Turma. |
| **ID_Competencia** | `NUMBER` | `FK` | Badge/Competência. |
| **Data_Conquista** | `DATE` | | Data de emissão. |
| **URL_Evidencia** | `VARCHAR2(500)` | | Link para badge externo. |

---

### E. Domínio: Administrativo (ADMIN)

#### 14. `Itens_Dossier_Turma` (LMS_DOSSIER_CHECKLIST)
*Checklist de documentos.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Item_Dossier** | `NUMBER` | `PK` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Tipo_Doc** | `NUMBER` | `FK` | Lookup: `Tipos_Documento_Dossier`. |
| **Presente** | `CHAR(1)` | | 'S'/'N'. |
| **URL_Ficheiro** | `VARCHAR2(500)` | | Link para arquivo. |
| **Validado_Por** | `VARCHAR2(255)` | | Utilizador que validou. |
| **Data_Validacao** | `DATE` | | Data. |

#### 15. `Faturas_Formadores` (LMS_INVOICES)
*Processamento de pagamentos.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Fatura** | `NUMBER` | `PK` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Formador** | `NUMBER` | `FK` | Formador. |
| **Valor** | `NUMBER` | | Montante. |
| **Mes_Ref** | `VARCHAR2(7)` | | 'YYYY-MM'. |
| **Estado** | `VARCHAR2(20)` | | 'EMITIDA', 'PAGA'. |
| **Data_Emissao** | `DATE` | | Data emissão. |

#### 16. `Equipamentos_Alocados` (LMS_EQUIPMENTS)
*Gestão de hardware.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Alocacao** | `NUMBER` | `PK` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Tipo_Equipamento**| `NUMBER` | `FK` | Lookup: `Tipos_Equipamento`. |
| **Quantidade** | `NUMBER` | | Qtd alocada. |
| **Data_Entrega** | `DATE` | | Entrega ao formador. |
| **Data_Devolucao** | `DATE` | | Devolução. |
| **Estado_Conservacao** | `VARCHAR2(200)` | | Obs estado. |

#### 17. `Modelos_Comunicacao` (LMS_COMM_TEMPLATES)
*Templates de emails.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Modelo** | `NUMBER` | `PK` | Chave primária. |
| **Codigo_Ref** | `VARCHAR2(50)` | `UK` | Código sistema (ex: 'WELCOME_EMAIL'). |
| **Assunto** | `VARCHAR2(200)` | | Assunto email. |
| **Corpo_HTML** | `CLOB` | | Body HTML. |
| **ID_Tipo_Notificacao**| `NUMBER` | `FK` | Lookup. |

#### 18. `Staging_Importacao` (STG_IMPORT_DATA)
*Tabela de ingestão de dados (Excel).*

| Nome do Campo | Tipo (Oracle) | Descrição |
| :--- | :--- | :--- |
| **ID_Staging** | `PK` | Identificador. |
| **Lote_ID** | `VARCHAR2(50)` | Batch ID. |
| **Dados_JSON** | `CLOB` | Linha completa do Excel em JSON. |
| **Estado** | `VARCHAR2(20)` | 'PENDENTE', 'ERRO', 'PROCESSADO'. |
| **Erro_Log** | `VARCHAR2(4000)` | Mensagem de erro. |
| **Data_Importacao** | `TIMESTAMP` | Timestamp. |

---

### F. Tabelas de Lookup (Domínios)

Lista completa de tabelas auxiliares para garantir a integridade referencial.

1.  **Tipos_Area_Competencia** (DigComp: Segurança, Informação...)
2.  **Tipos_Nivel_Proficiencia** (Básico, Intermédio...)
3.  **Tipos_Estado_Curso** (Ativo, Arquivado...)
4.  **Tipos_Genero** (Feminino, Masculino...)
5.  **Tipos_Doc_Identificacao** (CC, Passaporte...)
6.  **Tipos_Situacao_Profissional** (Empregado, Desempregado...)
7.  **Tipos_De_Qualificacao** (9º Ano, 12º Ano, Licenciatura...)
8.  **Tipos_Estado_Turma** (Planeada, Confirmada, Em Curso, Terminada)
9.  **Tipos_Estado_Matricula** (Inscrito, A frequentar, Concluído, Desistiu)
10. **Tipos_Estado_Presenca** (Presente, Falta, Falta Justificada)
11. **Tipos_Nivel_Experiencia** (Iniciante, Avançado...)
12. **Tipos_Equipamento** (Webcam, Router, Portátil...)
13. **Tipos_Plano_DDF** (Formação Interna, Externa)
14. **Tipos_Documento_Dossier** (Sumários, Pautas, Contratos)
15. **Tipos_Notificacao** (Email, SMS)
16. **Locais** (Salas e Centros de Formação)

---

## 3. Notas Finais

*   **Audit Trail:** Recomenda-se o uso de *Flashback Data Archive (FDA)* do Oracle para histórico de alterações em vez duma tabela `Registos_De_Acoes` manual, para maior performance e simplicidade no APEX.
*   **Campos JSON:** Foram totalmente removidos. Todos os dados são agora colunas de primeira classe.
*   **Unificação:** A tabela `Entidades` suporta todos os atores, permitindo que a mesma pessoa (NIF/Email) evolua de Formando para Formador sem duplicar registos.
