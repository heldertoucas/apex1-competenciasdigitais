# Manual de Implementação - Bónus 02C: Listas de Mailing
**Aplicação:** Academia Digital  
**Objetivo:** Permitir associar uma pessoa a múltiplas listas de distribuição (ex: VIP, Newsletter) usando um grupo de checkboxes.

---

## 1. Preparação da Base de Dados
1.  Execute o script `02C_Mailing_Lists.sql` no **SQL Workshop**.

---

## 2. Implementação na Interface (Ficha de Entidade)

### 2.1. Adicionar o Checkbox Group
1.  Aceda à página **Ficha de Entidade** (ex: Pág 3).
2.  Crie um novo item na região **Dados da Pessoa** (ou numa nova sub-região "Marketing").
3.  **Configuração do Item:**
    *   **Name:** `P3_LISTAS_MAILING` (ajuste P3 ao seu nº de página)
    *   **Type:** `Checkbox Group`
    *   **Label:** `Listas de Distribuição`
    *   **List of Values:**
        *   **Type:** `SQL Query`
        *   **Query:** `SELECT Nome_Lista d, ID_Lista r FROM Listas_Mailing WHERE Ativo='S' ORDER BY 1`
    *   **Source:**
        *   **Type:** `Null` (Deixe vazio ou selecione 'Null')
        *   **Used:** `Only when current value in session state is null` (Default)

### 2.2. Preencher valores (Load)
Para garantir que os itens vêm preenchidos, vamos usar uma Computação em vez do "Source".

1.  No painel da esquerda, acima de **Regions**, clique com o botão direito em **Rendering** > **Pre-Rendering** > **Before Header** > **Computations**.
2.  Clique **Create Computation**.
3.  **Item Name:** `P3_LISTAS_MAILING`.
4.  **Type:** `SQL Query (return colon separated value)`.
5.  **SQL Query:**
    ```sql
    SELECT LISTAGG(ID_Lista, ':') WITHIN GROUP (ORDER BY ID_Lista)
    FROM Entidade_Listas
    WHERE ID_Entidade = :P3_ID_ENTIDADE
    ```


### 2.3. Criar Processo de Gravação (PL/SQL)
Como este campo não mapeia diretamente para a tabela `Entidades`, precisamos de um "Code Processor" manual para salvar as escolhas.

1.  Aceda à aba **Processing** (ícone de setas giratórias na esquerda).
2.  Expanda **Processing**. Verifique onde está o processo padrão **"Process Row of Entidades"** (ou "Automatic Row Processing").
3.  Clique com o botão direito em **Processing** > **Create Process**.
4.  **Name:** `Save Mailing Lists`.
5.  **Type:** `Execute Code`.
6.  **Sequence:** Defina um número **MAIOR** que o processo "Process Row" (ex: se o Row é 10, ponha 20). **Isto é CRÍTICO para novos registos.**
7.  **Point:** `After Submit`.
8.  **PL/SQL Code:**
    ```sql
    DECLARE
        l_list_ids APEX_T_VARCHAR2;
    BEGIN
        -- 1. Limpeza: Remover todas as associações atuais desta pessoa
        --    (Importante: só corre se já tivermos um ID_Entidade válido)
        DELETE FROM Entidade_Listas WHERE ID_Entidade = :P3_ID_ENTIDADE;

        -- 2. Inserção: Só processar se o utilizador selecionou alguma coisa
        IF :P3_LISTAS_MAILING IS NOT NULL THEN
            -- Converter string "1:3" em array
            l_list_ids := APEX_STRING.SPLIT(:P3_LISTAS_MAILING, ':');
            
            -- Iterar e inserir
            FOR i IN 1 .. l_list_ids.COUNT LOOP
                INSERT INTO Entidade_Listas (ID_Entidade, ID_Lista)
                VALUES (:P3_ID_ENTIDADE, TO_NUMBER(l_list_ids(i)));
            END LOOP;
        END IF;
    END;
    ```
9.  **Server-side Condition:**
    *   **Type:** `Item is NOT NULL`
    *   **Item:** `P3_ID_ENTIDADE`

---
**Resultado:** Ao entrar na ficha de uma pessoa, verá checkboxes. Ao marcar/desmarcar e gravar, a tabela `Entidade_Listas` será atualizada automaticamente.
