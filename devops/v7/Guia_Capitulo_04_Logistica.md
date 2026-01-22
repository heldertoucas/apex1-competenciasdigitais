# Manual de Implementação - Capítulo 4: Planeamento e Logística (Detalhado)
**Aplicação:** Academia Digital  
**Versão do Guia:** 2.0 (Expandido)  
**Nível:** Principiante (Passo-a-Passo)

---

## 1. Preparação da Base de Dados
Antes de criar os ecrãs, precisamos de criar as tabelas no motor de base de dados.

1.  Aceda ao **SQL Workshop** e clique em **SQL Scripts**.
2.  Clique no botão verde **Upload** e carregue o ficheiro `04_Operacoes.sql` (que eu criei para si).
3.  *Em alternativa:* Clique em **Create**, dê o nome `04_Operacoes` e cole o código SQL manualmente.
4.  Clique em **Run** (botão "play" no lado direito da linha do script) e depois em **Run Now** para confirmar.
5.  **Verificação:** Deve ver uma mensagem verde a dizer "Statements Processed".

---

## 2. Interface de Planeamento (Turmas)

Vamos criar um relatório para listar as turmas e um formulário para criar/editar turmas.

### 2.1. Criar as Páginas (Report + Form)
1.  Aceda ao **App Builder** e clique na sua aplicação "Academia Digital".
2.  Clique no botão **Create Page**.
3.  Selecione **Report**.
4.  Escolha **Interactive Report**.
5.  **Definições do Relatório (Page X):**
    *   **Page Number:** Aceite o sugerido (ex: 10).
    *   **Page Name:** `Gestão de Turmas`.
    *   **Breadcrumb:** Selecione a opção "Breadcrumb" para criar navegação no topo.
6.  **Definições do Formulário (Page Y):**
    *   **Include Form Page:** ative este botão ("switch" para ON).
    *   **Page Name:** `Detalhe da Turma`.
    *   **Form Region Title:** `Dados da Turma`.
7.  **Fonte de Dados (Data Source):**
    *   **Table / View Name:** Escreva ou procure `TURMAS`.
8.  Clique em **Create**.

---

### 2.2. Organizar o Formulário "Detalhe da Turma"
O APEX cria os campos todos seguidos. Vamos organizá-los.

1.  No Page Designer da página "Detalhe da Turma" (ex: Pág 11).
2.  No painel da esquerda (**Rendering**), expanda `Content Body` > `Dados da Turma`.
3.  Veja os campos (Page Items) aí listados (ex: `P11_CODIGO_TURMA`, etc.).
4.  **Criar Sub-Regiões (Agrupadores Visuals):**
    *   Clique com o botão direito em `Dados da Turma` > **Create Sub Region**.
    *   No painel da direita (**Property Editor**), em **Identification** > **Title**, escreva: `Informação Geral`.
    *   Repita o processo e crie outra sub-região chamada `Planeamento`.
    *   Repita e crie uma terceira região chamada `Dados Administrativos`.
5.  **Arrumar os Campos:**
    *   Selecione e arraste para **Informação Geral**: `P11_ID_CURSO`, `P11_CODIGO_TURMA`, `P11_NOME_TURMA`.
    *   Selecione e arraste para **Planeamento**: `P11_DATA_INICIO`, `P11_DATA_FIM`, `P11_ID_LOCAL`, `P11_HORARIO_DESCRITIVO`, `P11_ID_COORDENADOR`, `P11_VAGAS`.
    *   Selecione e arraste para **Dados Administrativos**: `P11_NUM_INFORMACAO`, `P11_COD_ACAO_SIGO`, `P11_ID_TIPO_PLANO`, `P11_OBSERVACOES`.
6.  **Configurar os Select Lists (Listas de Escolha):**
    *   Campos como `ID_CURSO` aparecem como caixas de texto numérico. Vamos mudar isso.
    *   Clique em `P11_ID_CURSO`.
    *   Na direita, mude **Type** para `Select List`.
    *   Em **List of Values** > **Type**, escolha `SQL Query`.
    *   **SQL Query:** `SELECT Nome_Curso d, ID_Curso r FROM Cursos ORDER BY 1`.
    *   **Display Null Value:** Ative (`ON`) e escreva em **Null Display Value**: `- Selecione Curso -`.
    *   *Repita a lógica para:*
        *   `P11_ID_LOCAL` (Query: `SELECT Nome d, ID_Local r FROM Locais`)
        *   `P11_ID_COORDENADOR` (Query: `SELECT Nome_Completo d, ID_Entidade r FROM Entidades ORDER BY 1`)
        *   `P11_ID_TIPO_PLANO` (Query: `SELECT Descricao d, ID_Tipo_Plano r FROM Tipos_Plano_DDF ORDER BY 1`)

---

### 2.3. Adicionar a Equipa Formativa
Queremos listar quem são os formadores desta turma dentro da mesma página.

1.  No painel esquerdo, clique com o botão direito em `Content Body` (ou numa área vazia abaixo do form) > **Create Region**.
2.  **Configuração da Região:**
    *   **Title:** `Equipa Formativa`.
    *   **Type:** `Interactive Grid`.
    *   **Source** > **Table:** `EQUIPA_FORMATIVA`.
3.  **Ligar à Tabela Pai (Master-Detail):**
    *   *Importante:* Isto garante que só vemos formadores *desta* turma.
    *   Na Source, em **Where Clause**, escreva: `ID_TURMA = :P11_ID_TURMA` (Substitua P11 pelo seu nº de página atual).
    *   Em **Page Items to Submit**, escreva: `P11_ID_TURMA`.
4.  **Configurar Colunas da Grid:**
    *   Expanda a pasta **Columns** dentro da região `Equipa Formativa`.
    *   Clique em `ID_TURMA`. Na direita, mude **Default** > **Type** para `Item` e selecione `P11_ID_TURMA`. Depois mude **Identification** > **Type** para `Hidden` (escondido).
    *   Clique em `ID_FORMADOR`. Mude **Type** para `Select List`.
        *   **LOV Type:** `SQL Query`.
        *   **Query:** `SELECT Nome_Completo d, ID_Entidade r FROM Entidades WHERE Ativo='S'`.

---

### 2.4. Calendário de Sessões
Vamos ver as aulas num calendário visual.

1.  Crie uma nova região (**Create Region**).
2.  **Title:** `Calendário de Aulas`.
3.  **Type:** `Calendar`.
4.  **Source** > **Type:** `SQL Query`.
5.  **SQL Query:**
    ```sql
    SELECT 
        ID_Sessao,
        Nome,
        Data_Sessao,
        -- Truque para o calendário saber a hora de inicio e fim
        TO_DATE(TO_CHAR(Data_Sessao, 'YYYY-MM-DD') || ' ' || Hora_Inicio, 'YYYY-MM-DD HH24:MI') as Data_Inicio_Cal,
        TO_DATE(TO_CHAR(Data_Sessao, 'YYYY-MM-DD') || ' ' || Hora_Fim, 'YYYY-MM-DD HH24:MI') as Data_Fim_Cal
    FROM Sessoes
    WHERE ID_Turma = :P11_ID_TURMA
    ```
6.  **Page Items to Submit:** `P11_ID_TURMA`.
7.  **Attributes (Separador no topo do painel direito):**
    *   **Display Column:** `NOME`.
    *   **Start Date Column:** `DATA_INICIO_CAL`.
    *   **End Date Column:** `DATA_FIM_CAL`.

---

### 2.5. O "Botão Mágico" (Automação)
Para não ter de criar 20 sessões à mão.

1.  **Criar o Botão:**
    *   No painel esquerdo, expanda a região onde quer o botão (ex: no topo da página, na Breadcrumb Bar, ou ao lado do Save).
    *   Clique direito > **Create Button**.
    *   **Button Name:** `BTN_GERAR_CRONOGRAMA`.
    *   **Label:** `Gerar Cronograma`.
    *   **Behavior** > **Action:** `Submit Page`.
2.  **Criar o Processo (A lógica):**
    *   Vá à aba **Processing** (ícone de setas circulares, na barra esquerda vertical).
    *   Clique direito em **Processing** > **Create Process**.
    *   **Name:** `Gerar Sessoes Auto`.
    *   **Type:** `Execute Code`.
    *   **PL/SQL Code:**
        *   Abra o ficheiro `04_Automacao_Cronograma.sql`.
        *   Copie o código todo.
        *   Cole aqui.
        *   *Atenção:* No código colado, procure onde diz `:P10_...` e **substitua pelo número da sua página real** (ex: se está na pág 11, mude para `:P11_DATA_INICIO`, `:P11_ID_TURMA`, etc.).
3.  **Condição de Disparo:**
    *   Ainda no processo, vá a **Server-side Condition**.
    *   **When Button Pressed:** Escolha `BTN_GERAR_CRONOGRAMA`.

**Conclusão:** Agora, ao criar uma turma, preencha Data Inicio/Fim e clique em "Gerar Cronograma". O calendário em baixo deve encher-se de aulas automaticamente!
