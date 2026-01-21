# Manual de Refatorização - Capítulo 03B: O Novo Catálogo de Cursos
**Objetivo:** Implementar uma interface hierárquica (Curso > Módulo > Competência) com gestão centralizada de competências e Medalhas (M:N).

> [!IMPORTANT]
> **Pré-requisitos:** Execute os scripts `01_Refactor_Competencias_MN.sql` e `02_Refactor_Medalhas_MN.sql` para atualizar o modelo de dados.

---

## 1. Gestão do Catálogo Global de Competências
Antes de criar cursos, vamos criar os "Bancos" onde as competências e medalhas vivem.

1.  **Create Page** > **Interactive Grid**.
2.  **Page Name:** `Banco Global de Competências`.
3.  **Table:** `CATALOGO_COMPETENCIAS`.
4.  **Edição:** Habilite `Editing` (Add, Update, Delete).
5.  **Navegação:** Adicione ao Menu (ex: Administração > Competências).
6.  **Configurar Colunas LOV (Dropdowns):**
    > [!IMPORTANT]
    > **Correção de Erro (ORA-00904):** Se criou esta página antes de correr o script de refatorização, o APEX ainda tem as colunas antigas em memória.
    > *   Vá a **Columns**.
    > *   Se existirem, APAGUE as colunas: `URL_MEDALHA_DIGITAL`, `URL_ICONE_BADGE`, `URL_CLAIM_BADGE`. Elas já não existem na base de dados.

    *   Expanda a pasta **Columns**.
    *   **ID_AREA_COMPETENCIA:**
        *   **Type:** `Select List` (ou Popup LOV).
        *   **LOV Type:** `Shared Component`.
        *   **Shared Component:** `LOV_AREAS_COMPETENCIA` (Ver *Guia Auxiliar 01*).
    *   **ID_NIVEL_PROFICIENCIA:**
        *   **Type:** `Select List`.
        *   **LOV Type:** `Shared Component`.
        *   **Shared Component:** `LOV_NIVEIS_PROFICIENCIA`.
7.  **Coluna Link (Associar Medalhas):**
    *   Crie uma coluna Virtual Link.
    *   **Heading:** `Badges`.
    *   **Source Type:** `None`.
    *   **Target:** (Vamos criar no passo 6).

---

## 2. Página Principal: Catálogo de Cursos (Grelha)
Vamos substituir a página antiga de Catálogo.

1.  **Create Page** > **Report** > **Interactive Report** (com "Include Form Page").
    *   **Page Name (Report):** `Catálogo de Cursos`.
    *   **Page Name (Form):** `Ficha de Curso`.
    *   **Form Page Mode:** `Drawer`.
    *   **Table:** `CURSOS`.
2.  **Configurar Grelha:**
    *   Mostre colunas relevantes: `Nome`, `Codigo`, `Modalidade`, `Carga_Horaria`.
    *   **Colunas LOV:** O APEX pode não detetar automaticamente.
        *   Vá a `Columns` > `ID_ESTADO_CURSO`.
        *   **Type:** `Plain Text (based on LOV)`.
        *   **Shared Component:** `LOV_ESTADOS_CURSO`.
    *   *Opcional:* Adicione filtros de topo (Botões) para Estado.

---

## 3. Ficha de Curso (Drawer)
Nesta página (o Drawer criado acima), vamos organizar tudo em Abas.

1.  **Template:** Altere a região do Form para o Template **Tabs Container**.
2.  **Abas (Sub-regiões):**
    *   **Dados Gerais:** (Arraste os campos `Nome`, `Codigo`, `Carga_Horaria` para aqui).
    *   **Pedagogia:** (Campos `Metodologia`, `Recursos`).
    *   **Conteúdos:** (Campos `Objetivos`, `Conteudos`).
    *   **Configuração de LOVs:**
        *   Selecione o item `P<N>_ID_ESTADO_CURSO`.
        *   **Type:** `Select List`.
        *   **LOV Type:** `Shared Component` > `LOV_ESTADOS_CURSO`.
        *   Faça o mesmo para `P<N>_ID_PROGRAMA` (`LOV_PROGRAMAS`).
    *   **Módulos:** (Região Vazia - vamos criar já).

### 3.1. Aba Módulos (IG Mestre-Detalhe)
Dentro da Aba "Módulos":
1.  Crie uma região **Interactive Grid**.
2.  **Table:** `MODULOS`.
    > [!WARNING]
    > **Muito Importante:** Selecione a tabela `MODULOS`. **NÃO** selecione `MODULO_COMPETENCIAS`!
3.  **Parent Region:** Selecione a região do Form do Curso (Isto liga a FK automaticamente).
4.  **Master Column:** `ID_CURSO`.
5.  **Page Items to Submit:** `P<N>_ID_CURSO` (CRÍTICO: Impede que as linhas desapareçam ao gravar).

**Configurar Edição:**
1.  Vá a **Attributes** > **Edit** > **Enabled**: `On`.
2.  **Allowed Operations:** Marque `Add Row`, `Update Row`, `Delete Row`.

**Configurar Colunas:**
1.  **ID_MODULO:** `Hidden`, `Primary Key`.
2.  **ID_CURSO:** (O Elo de Ligação)
    *   **Type:** `Hidden`.
    *   **Default:** (Se selecionou "Parent Region" acima, o APEX faz isto sozinho. Se não, defina Default Value = Item do Mestre).
3.  **NOME:** `Text Field`.
4.  **CARGA_HORARIA:** `Number Field`.
5.  **ORDEM:** `Number Field`.

6.  **Coluna Link (Competências):**
    *   No painel à esquerda (Columns), clique com botão direito > **Create Column**.
    *   **Heading:** `Gerir Competências` (ou ícone).
    *   **Source:**
        *   **Type:** `None` (CRÍTICO: Define que não vem da BD).
    *   **Identification:**
        *   **Type:** `Link`.
    *   **Link:**
        *   **Target:** Página `Competências do Módulo` (Modal que criaremos no Passo 4).
        *   **Link Text:** `Competências` (ou use um ícone `<span class="fa fa-list"></span>`).
        *   **Set Items:** `P<N>_ID_MODULO` = `&ID_MODULO.` (Passar ID da linha).

---

## 4. Modal de Associação (Módulo <-> Competências) [NOVO MODELO]
Tal como nas Medalhas, vamos usar uma **Grelha CRUD Standard** para gerir as competências deste módulo.

> **Nota:** Se já tinha esta página feita (método antigo das checkboxes), pode apagar a Região e o Processo PL/SQL e recomeçar do Passo 4.3.

### 4.1. Criar a Página Modal
1.  **Create Page** > **Blank Page**.
2.  **Page Name:** `Competências do Módulo`.
3.  **Page Mode:** `Modal Dialog`.

### 4.2. Criar o Item para o ID do Módulo
1.  No Page Designer, **Create Page Item** na região Content Body.
2.  **Name:** `P<N>_ID_MODULO` (ex: `P20_ID_MODULO`).
3.  **Type:** `Hidden`.
4.  **Value Protected:** `Off`.

### 4.3. Criar a Grelha de Associação (Table-Based)
1.  Create Region > **Interactive Grid**.
2.  **Title:** `Competências Associadas`.
3.  **Source:**
    *   **Type:** `Table / View`.
    *   **Table Name:** `MODULO_COMPETENCIAS`.
    *   **Where Clause:** `ID_MODULO = :P20_ID_MODULO` (Substitua pelo seu Item).
4.  **Layout:**
    *   **Page Item to Submit:** `P20_ID_MODULO` (Crucial para o filtro funcionar).

### 4.4. Configurar Edição (Standard)
1.  Selecione a região Interactive Grid.
2.  **Attributes** > **Edit**: `Enabled`.
3.  **Allowed Operations:** Marque `Add Row`, `Update Row` (opcional, para mudar o "Obrigatório"), `Delete Row`.

### 4.5. Configurar as Colunas
Vá à pasta **Columns** da Grid:

1.  **ID_ASSOCIACAO:** `Hidden` (Primary Key).

2.  **ID_MODULO:** (Chave Estrangeira para o Pai)
    *   **Type:** `Hidden`.
    *   **Default (Secção Default):**
        *   **Type:** `Item`.
        *   **Item:** `P20_ID_MODULO`.
    *   *Nota:* O APEX preenche isto automaticamente ao criar linha.

3.  **ID_COMPETENCIA:** (A que queremos selecionar)
    *   **Type:** `Popup LOV`.
    *   **Heading:** `Competência`.
    *   **List of Values:**
        *   **Type:** `SQL Query`.
        *   **SQL Query:** `SELECT Nome as d, ID_Competencia as r FROM Catalogo_Competencias WHERE Ativo = 'S' ORDER BY Nome`
    *   **Display Extra Values:** `No`.
    *   **Null Display Value:** `- Selecione Competência -` (Isto garante o texto inicial).

4.  **OBRIGATORIO:**
    *   **Type:** `Switch` (ou Checkbox).
    *   **Heading:** `Obrigatório?`.
    *   **On Value:** `S`.
    *   **Off Value:** `N`.
    *   **Default (Secção Default):**
        *   **Type:** `Static Value`.
        *   **Static Value:** `S` (Vem preenchido como Sim).

### 4.6. Botão de Gravar
Garanta que existe um botão **Save** (na Toolbar da Grid ou na Página).

### 4.7. Ligar ao Catálogo
Volte à página "Ficha do Curso" (Drawer). Na Grelha de Módulos:
1.  **Coluna Link (Competências):**
    *   **Target:** Página Modal que acabou de criar (ex: 20).
    *   **Set Items:**
        *   `P20_ID_MODULO` = `&ID_MODULO.`
    *   **Clear Cache:** `20`.
    *   **Link Text:** `Competências` ou ícone.

Agora tem um sistema de gestão consistente e moderno para ambas as associações!
                    -- Se desmarcou, apaga
                    DELETE FROM Modulo_Competencias
                     WHERE ID_Modulo = :P_ITEM_ID_MODULO
                       AND ID_Competencia = :ID_COMPETENCIA;
                END IF;
            END;
            ```
        *   **Success Message:** `Competências Atualizadas!`.

### 4.1. Ligar Drawer ao Modal
1.  Volte à **Ficha de Curso (Drawer)**.
2.  Vá à Grid de **Módulos** > Coluna `Gerir Competências`.
3.  **Link:**
    *   **Target:** `Page in this application`.
    *   **Page:** (Selecione a página `Competências do Módulo`).
    *   **Set Items:**
        *   **Name:** `P<N>_ID_MODULO` (Ex: `P20_ID_MODULO`).
        *   **Value:** `&ID_MODULO.` (Item da Grid atual).

---

## 5. Banco Global de Medalhas
Vamos criar uma página simples para criar e gerir os "Open Badges" (imagem, link, nome).

1.  **Create Page** > **Interactive Grid**.
2.  **Page Name:** `Catálogo de Medalhas`.
3.  **Table:** `CATALOGO_MEDALHAS`.
4.  **Editing:** Certifique-se que "Include Form Page" está **DESLIGADO** (queremos editar na própria grelha).
5.  **Menu:** Adicione uma nova entrada no menu (ex: Parent: Administração, Nome: Medalhas).
6.  **Validar Colunas:**
    *   No Page Designer, vá a **Columns**.
    *   Garanta que `ID_MEDALHA` é `Hidden` e `Primary Key`.
    *   Garanta que `NOME`, `URL_IMAGEM` e `URL_CLAIM_BADGE` são `Text Field` (ou `Display Image` para a imagem).
    *   *Nota:* O `URL_CLAIM_BADGE` é o link para o formulário externo de quem ganha a medalha.

---

## 6. Modal de Associação (Competência <-> Medalhas)
## 6. Modal de Associação (Competência <-> Medalhas) [NOVO MODELO]
Vamos criar uma grelha standard onde pode adicionar e remover medalhas associadas (CRUD).

> **Ponto de Partida:** Se já tinha criado esta página (Passo 6 anterior), apague a Região "Interactive Grid" antiga e comece do **Passo 6.3** abaixo (assumindo que já tem a página e o Item Oculto criados).
> Se está a começar do zero, siga desde o 6.1.

### 6.1. Criar a Página Modal
1.  Clique no botão **(+) Create Page** no topo do APEX.
2.  Selecione **Blank Page**.
3.  **Name:** `Associar Medalhas`.
4.  **Page Mode:** `Modal Dialog`.
5.  Clique **Create Page**.

### 6.2. Criar o Item para o ID da Competência
1.  No Page Designer, **Create Page Item** na região Content Body.
2.  **Name:** `P<N>_ID_COMPETENCIA` (ex: `P25_ID_COMPETENCIA`).
3.  **Type:** `Hidden`.
4.  **Value Protected:** `Off`.

### 6.3. Criar a Grelha de Associação (Table-Based)
1.  Create Region > **Interactive Grid**.
2.  **Title:** `Medalhas Associadas`.
3.  **Source:**
    *   **Type:** `Table / View`.
    *   **Table Name:** `COMPETENCIA_MEDALHAS`.
    *   **Where Clause:** `ID_COMPETENCIA = :P25_ID_COMPETENCIA` (Substitua pelo seu Item).
4.  **Layout:**
    *   **Page Item to Submit:** `P25_ID_COMPETENCIA` (Isto garante que o valor está disponível para o filtro).

### 6.4. Configurar Edição (Standard)
1.  Selecione a região Interactive Grid.
2.  Vá a **Attributes** (tab no topo direito).
3.  **Edit:** `Enabled`.
4.  **Allowed Operations:** Marque `Add Row` e `Delete Row`. (Pode desmarcar Update, pois só queremos ligar ou desligar).

### 6.5. Configurar as Colunas
Vá à pasta **Columns** da Grid:

1.  **ID_ASSOCIACAO:**
    *   **Type:** `Hidden`.
    *   **Primary Key:** `On`.
    
2.  **ID_COMPETENCIA:** (A Chave Estrangeira para o Pai)
    *   **Type:** `Hidden`.
    *   **Default (Secção Default):**
        *   **Type:** `Item`.
        *   **Item:** `P25_ID_COMPETENCIA`.
    *   *Nota:* Isto é o segredo! Quando clica em "Add Row", o APEX preenche esta coluna automaticamente com o ID da competência atual.

3.  **ID_MEDALHA:** (A Medalha que queremos escolher)
    *   **Type:** `Popup LOV` (ou Select List).
    *   **Heading:** `Medalha`.
    *   **List of Values:**
        *   **Type:** `SQL Query`.
        *   **SQL Query:** `SELECT Nome as d, ID_Medalha as r FROM Catalogo_Medalhas WHERE Ativo = 'S' ORDER BY Nome`
    *   **Display Extra Values:** `No`.
    *   **Null Display Value:** `- Selecione Medalha -`.

4.  **DETALHE_IMAGEM:** (Coluna Virtual para mostrar a bonecada)
    *   Clique direito em Columns > **Create Column**.
    *   **Name:** `DETALHE_IMAGEM`.
    *   **Type:** `Display Image`.
    *   **Heading:** `Icone`.
    *   **Source:**
        *   **Type:** `SQL Expression`.
        *   **SQL Expression:** `(SELECT URL_IMAGEM FROM Catalogo_Medalhas WHERE ID_MEDALHA = :ID_MEDALHA)`
        *   **Data Type:** `VARCHAR2`.
    *   **Settings:**
        *   **Based On:** `Image URL stored in Page Item Value`. -- *Nota: Na verdade, como é SQL Expression, o valor da coluna É o URL.*
    *   **Layout:** Coloque antes ou depois do Nome.

5.  **DETALHE_CLAIM:** (Opção para ver o link)
    *   Create Column.
    *   **Name:** `DETALHE_CLAIM`.
    *   **Type:** `Text Field` (Read Only) ou `Link`.
    *   **Heading:** `Link de Claim`.
    *   **Source:**
        *   **Type:** `SQL Expression`.
        *   **SQL Expression:** `(SELECT URL_CLAIM_BADGE FROM Catalogo_Medalhas WHERE ID_MEDALHA = :ID_MEDALHA)`

### 6.6. Botão de Gravar
1.  Certifique-se que existe um botão **Save** na barra de ferramentas da Grid (Toolbar) ou um botão "Save" na página.
    *   *Dica:* Em Interactive Grids editáveis, o botão "Save" na toolbar vem ativado por defeito em Attributes > Toolbar.

### 6.7. Ligar (Mesmo processo de antes)
Volte à página "Banco Global de Competências" e configure o Link (Coluna Badges) para abrir esta página (25), passando o item `P25_ID_COMPETENCIA` com o valor `&ID_COMPETENCIA.`.

**Como usar agora:**
1.  Abre a modal. Vê apenas as medalhas que a competência *já tem*.
2.  Quer dar mais uma? Clica **Add Row**. Escolhe a medalha da lista. Clica **Save**.
3.  Quer tirar? Seleciona a linha, clica **Delete** (ou Row Actions > Delete), clica **Save**.

