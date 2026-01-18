# Relatório de Análise e Sugestões de Alteração ao Modelo de Dados

Este relatório detalha as discrepâncias encontradas entre os requisitos documentais (`documentos.md`) e o modelo de dados atual (`modelodedados6.md`), com propostas de alteração para aprovação.

## 1. Entidades (Pessoas)
O documento de requisitos lista vários campos detalhados para a "Inscrição" e "Situação Profissional" que não estão presentes explicitamente na tabela `LMS_ENTITIES`.

**Campos em Falta Detetados:**
*   **Profissão:** (Ex: "Carpinteiro", campo de texto livre separado da Situação Profissional)
*   **Entidade Empregadora:** Nome da empresa/organização.
*   **Morada Profissional:** Morada do local de trabalho.
*   **Código Postal Profissional**
*   **Localidade Profissional**
*   **Contacto Profissional**
*   **URL para CV:** Necessário para formadores (Seção 7 do documento).

**Sugestão de Alteração em `LMS_ENTITIES`:**
Adicionar as seguintes colunas:
```sql
Profissao            VARCHAR2(100)
Entidade_Empregadora VARCHAR2(200)
Morada_Prof          VARCHAR2(255)
Codigo_Postal_Prof   VARCHAR2(20)
Localidade_Prof      VARCHAR2(100)
Telemovel_Prof       VARCHAR2(50)
URL_CV               VARCHAR2(500)  -- Para formadores
```

## 2. Pré-Inscrição e Diagnóstico
Confirmado que a pré-inscrição se refere a pedidos de inscrição em **Turmas/Ações** específicas e não apenas interesses genéricos, pelo que a tabela `LMS_ENROLLMENTS` (Matrículas) suporta esta relação (com estado 'Pré-inscrito' ou similar).

No entanto, o campo "Diagnóstico de competências Digitais (pode ser mais de uma resposta)" requer armazenamento. Dado que um utilizador pode fazer múltiplas inscrições num único formulário, mas o diagnóstico é tipicamente sobre o utilizador naquele momento:

**Sugestão de Alteração em `LMS_ENTITIES` (ou `LMS_ENROLLMENTS`):**
Adicionar coluna para guardar as respostas do diagnóstico (JSON ou Texto) para não perder a informação original para além do nível apurado.
```sql
Diagnostico_Respostas CLOB -- Em LMS_ENROLLMENTS (para histórico por inscrição) ou LMS_ENTITIES.
```
*Recomendação:* Adicionar a `LMS_ENROLLMENTS` para manter o contexto daquela candidatura específica.

## 3. Cursos (Definição Pedagógica)
Na secção "4. Informação", existem campos descritivos pedagógicos que não constam em `LMS_COURSES`.

**Campos em Falta Detetados:**
*   **Metodologia de Formação:** O modelo tem `Metodologia_Avaliacao`, mas falta a metodologia de ensino (ex: "Método ativo, demonstrativo...").
*   **Atividades e Recursos:** Descrição das atividades e equipamentos/recursos didáticos.

**Sugestão de Alteração em `LMS_COURSES`:**
Adicionar colunas:
```sql
Metodologia_Formacao CLOB
Recursos_Didaticos   CLOB
```

## 4. Faturação
Na secção "11. Controlo da Faturação", são pedidos detalhes de datas que o modelo atual simplifica.

**Campos em Falta Detetados:**
*   Data Contabilística
*   Data de Pagamento

**Sugestão de Alteração em `LMS_INVOICES`:**
Adicionar colunas:
```sql
Data_Contabilistica DATE
Data_Pagamento      DATE
Num_Fatura          VARCHAR2(50)
```

## 5. Dossier Técnico-Pedagógico e Outros
*   **URLs de Avaliação:** Garantir que a tabela `Tipos_Documento_Dossier` inclua tipos para "Questionário Avaliação Satisfação", etc., usados em `LMS_DOSSIER_CHECKLIST`.
*   **Organizador:** Se a entidade organizadora variar, adicionar `Entidade_Organizadora` a `LMS_CLASSES`.

---
**Aprovação:**
Confirma este conjunto atualizado de alterações (Foco em novas colunas para `LMS_ENTITIES`, `LMS_COURSES`, `LMS_INVOICES`, `LMS_ENROLLMENTS`)?
