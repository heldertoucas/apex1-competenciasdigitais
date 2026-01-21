# Manual de Refatorização - Capítulo 02B: Recriar Gestão de Pessoas
**Aplicação:** Academia Digital
**Dependência:** Ter os dados de domínio carregados (Capítulo 01).
**Objetivo:** Recriar de raiz as páginas de "Diretório de Pessoas" e "Ficha de Entidade" usando o método mais robusto (Wizard "Report with Form"), corrigindo os erros de ligação anteriores.

---

> [!WARNING]
> Este guia assume que vai **apagar** as páginas anteriores de Pessoas (ex: 2 e 3) para começar "limpo".

## 1. Limpeza Inicial
1.  Aceda ao **App Builder**.
2.  Identifique as páginas criadas anteriormente para Pessoas (ex: Diretório e Ficha).
3.  Elimine-as (Botão direito > Delete).
4.  Identifique itens no **Navigation Menu** que tenham ficado "órfãos" (Shared Components > Navigation Menu) e apague-os também se necessário.

---

## 2. Criar "Report with Form" (O Método Seguro)

Vamos usar o Wizard que cria tudo ligado automaticamente.

1.  Aceda à App "Academia Digital".
2.  Clique em **Create Page**.
3.  Selecione **Report**.
4.  Escolha **Interactive Report**.
5.  **Page Attributes (Relatório):**
    *   **Page Number:** (O APEX sugere um, ex: 2).
    *   **Page Name:** `Diretório de Pessoas`.
    *   **Breadcrumb:** `Breadcrumb`.
6.  **Form Page (Fundamental):**
    *   Marque a caixa ☑️ **Include Form Page**.
    *   Isto expandirá novas opções.
    *   **Page Name (Form):** `Ficha de Entidade`.
    *   **Page Mode:** `Modal Dialog`.
7.  **Data Source:**
    *   **Source Type:** `Table`.
    *   **Table:** `ENTIDADES` (Selecione na lista/pop-up).
8.  **Navigation:**
    *   **Use Breadcrumb:** Sim.
    *   **Use Navigation:** Sim (Create a new navigation menu entry).
    *   **Parent Navigation Menu Entry:** Home (ou None).
9.  Clique **Next**.
10. **Primary Key:**
    *   Defina a Chave Primária para o formulário saber qual registo editar.
    *   **Primary Key Column(s):** `ID_ENTIDADE`.
    *   Clique **Create**.

> [!SUCCESS]
> **O que o APEX fez por si:**
> 1.  Criou o Relatório (Pág X).
> 2.  Criou o Formulário (Pág Y).
> 3.  **Ligação Automática:** Configurou a coluna de edição no Relatório para passar o `ID_ENTIDADE` para a Pág Y.
> 4.  **Processo Automático:** Criou o "Automated Row Fetch" na Pág Y para carregar os dados.

---

## 3. Configurar Campos do Formulário (Ficha de Entidade)

Agora vamos "limpar" o formulário, pois o wizard mete todos os campos de rajada.

1.  Aceda à página **Ficha de Entidade** (a nova página modal que foi criada).
2.  **Organizar Campos:**
    *   Selecione os itens no painel Rendering.
    *   Pode agrupar em sub-regiões (Dados Pessoais, Profissão, Configuração) se desejar.
3.  **Configurar LOVs (Dropdowns):**
    *   Para cada campo que é chave estrangeira (`ID_GENERO`, `ID_SITUACAO_PROF`, etc.), mude o tipo para **Select List**.
    *   **List of Values:**
        *   **Type:** `SQL Query`.
        *   **SQL (Exemplo para ID_GENERO):** `SELECT Descricao d, ID_Genero r FROM Tipos_Genero ORDER BY Descricao`
        *   **Display Null Value:** Yes (`- Selecione -`).
    *   *Repita este passo para todos os IDs, consultando o `modelodedados7.md` se tiver dúvidas nas tabelas.*

---

## 4. Re-implementar Filtros Rápidos (Opcional - Igual ao Guia 02A)

Se desejar os botões de filtro (Todos/Formando/Equipa):

1.  Volte à página **Diretório de Pessoas**.
2.  Crie o item `P2_FILTRO_TIPO` (Radio Group, Pill Button) na região **Breadcrumb** (ou numa região "Filtros" na posição `Body Before`).
    *   *Values:* `STATIC:Todos;TODOS,Formandos;FORMANDO,Equipa;EQUIPA`
    *   *Action:* Submit Page used.
3.  Altere a Source do Report para **SQL Query** e insira a cláusula WHERE:
    ```sql
    SELECT * FROM ENTIDADES e
    WHERE 
        (:P2_FILTRO_TIPO = 'TODOS') OR
        (:P2_FILTRO_TIPO = 'FORMANDO' AND EXISTS (SELECT 1 FROM Papeis_Entidade p WHERE p.ID_Entidade = e.ID_Entidade AND p.Codigo_Papel = 'FORMANDO')) OR
        (:P2_FILTRO_TIPO = 'EQUIPA' AND EXISTS (SELECT 1 FROM Papeis_Entidade p WHERE p.ID_Entidade = e.ID_Entidade AND p.Codigo_Papel IN ('FORMADOR', 'STAFF', 'ADMIN')))
    ```
4.  Adicione `P2_FILTRO_TIPO` em **Page Items to Submit**.

---

## 5. Teste
1.  Execute a aplicação.
2.  Vá ao **Diretório de Pessoas**.
3.  Deverá ver os dados de teste que inserimos (Joana Silva, Manuel, etc.).
4.  Clique no ícone de **Lápis** na linha da "Joana Silva".
5.  **Verificação:** O formulário deve abrir **preenchido** com os dados da Joana.
    *   *Se abrir vazio:* É porque o passo 10 do Wizard (Primary Key) falhou ou foi alterado. Mas com o Wizard, é 99% garantido.

---

## 6. Gestão de Papéis (Criação e Edição)

Para gerir os papéis (Formando, Formador, etc.) de forma robusta tanto na criação como na edição:

### 6.1. Criar Item de Checkbox
1.  Na página **Ficha de Entidade**.
2.  Crie um novo item:
    *   **Name:** `P<N>_PAPEIS` (ex: `P3_PAPEIS`).
    *   **Type:** `Checkbox Group`.
    *   **Label:** `Papéis no Sistema`.
    *   **List of Values:**
        *   **Type:** `Static Values`.
        *   **Values:** `STATIC:Formando;FORMANDO,Formador;FORMADOR,Staff;STAFF,Coordenador;COORDENADOR,Administrador;ADMIN`
3.  **Default Value (Para Criação):**
    *   **Type:** `Static`.
    *   **Value:** `FORMANDO` (Assim quem cria novos é formando por defeito).
4.  **Source (Para Edição):**
    *   **Type:** `SQL Query` (return single value).
    *   **SQL Query:** 
        ```sql
        SELECT LISTAGG(Codigo_Papel, ':') WITHIN GROUP (ORDER BY Codigo_Papel) 
        FROM Papeis_Entidade 
        WHERE ID_Entidade = :P3_ID_ENTIDADE
        ```
    *   **Used:** `Only when current value in session state is null` (Isto é crucial: carrega da BD apenas na primeira vez; se der erro de validação, mantém o que o utilizador escolheu).

### 6.2. Processar a Gravação (PL/SQL)
Como os papéis vivem numa tabela separada (`Papeis_Entidade`), o form automático não os grava sozinho.

1.  Vá a aba **Processing** (setas giratórias à esquerda).
2.  Crie um novo Processo **APÓS** o processo "Process form Entidades".
    *   **Name:** `Gravar Papeis`.
    *   **Type:** `Execute Code`.
3.  **PL/SQL Code:** (Atenção para substituir `P3_` pelo prefixo da sua página)
    ```sql
    BEGIN
        -- 1. Limpar papéis existentes (estratégia simples: delete & insert)
        -- Delete apenas se tivermos um ID (Edição) ou após criação.
        -- Como este processo corre APÓS o "Process form Entidades", o P3_ID_ENTIDADE já deve ter valor, mesmo na criação.
        DELETE FROM Papeis_Entidade WHERE ID_Entidade = :P3_ID_ENTIDADE;

        -- 2. Inserir os selecionados
        -- O APEX guarda checkboxes como string separada por dois pontos (ex: 'FORMANDO:FORMADOR')
        -- Usamos APEX_STRING.SPLIT para converter em tabela e fazer loop
        IF :P3_PAPEIS IS NOT NULL THEN
            FOR i IN (
                SELECT column_value as Papel 
                FROM TABLE(APEX_STRING.SPLIT(:P3_PAPEIS, ':'))
            ) LOOP
                INSERT INTO Papeis_Entidade (ID_Entidade, Codigo_Papel)
                VALUES (:P3_ID_ENTIDADE, i.Papel);
            END LOOP;
        END IF;
    END;
    ```
4.  **Success Message:** `Pessoa e Papéis gravados com sucesso.`

Com isto, ao criar uma pessoa nova, pode logo marcar "Formando" e "Staff". O sistema cria a pessoa, gera o ID, e em seguida (no mesmo submit) grava os papéis na tabela `Papeis_Entidade`.
