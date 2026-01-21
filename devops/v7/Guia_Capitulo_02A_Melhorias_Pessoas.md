# Manual de Melhoria - Capítulo 02A: Refinamento do Diretório de Pessoas
**Aplicação:** Academia Digital
**Dependência:** Ter completado o Capítulo 02 (Pessoas).
**Objetivo:** Melhorar a experiência de utilização do Diretório, introduzindo filtros rápidos e corrigindo o comportamento de edição.

---

## 1. Implementar Filtros Rápidos (Botões)

Vamos substituir a necessidade de usar a barra de pesquisa complexa por botões simples no topo da página.

### 1.1. Criar o Item de Filtro
1.  Aceda ao **Page Designer** da página **Diretório de Pessoas** (provavelmente Página 2).
2.  Na árvore **Rendering** (esquerda), clique com o botão direito na região **Breadcrumb Bar** (ou crie uma região nova acima do relatório chamada "Filtros") > **Create Page Item**.
3.  **Configuração do Item:**
    *   **Name:** `P2_FILTRO_TIPO` (Ajuste o P2 ao número da sua página).
    *   **Type:** `Radio Group`.
    *   **Label:** `Filtrar por:`.
    *   **List of Values:**
        *   **Type:** `Static Values`.
        *   **Static Values:** `STATIC:Todos;TODOS,Formandos;FORMANDO,Formadores & Staff;EQUIPA`
    *   **Display Null Value:** `No`.
    *   **Default Value:** `TODOS` (Static).
4.  **Aparência (Pill Buttons):**
    *   Na secção **Appearance** > **Template Options**:
        *   **Display as:** `Pill Button`.
        *   **Item Group Display:** `Display as Button Group`.
        *   Clique **OK**.
5.  **Comportamento (Submit):**
    *   Para simplificar (evitando Dynamic Actions complexas), vá à secção **Behavior** e defina:
    *   **Page Action on Selection:** `Submit Page`.
    *   Isto fará a página recarregar e filtrar quando clicar no botão.

### 1.2. Ligar o Filtro ao Relatório (SQL)
Agora temos de dizer ao relatório para obedecer ao botão.

1.  Selecione a região **Diretório de Pessoas** (Interactive Report).
2.  Altere o **Source Type** para `SQL Query` (se ainda estiver Table, o APEX converte automaticamente, mas valide).
3.  Adicione a cláusula `WHERE` para filtrar:
    ```sql
    SELECT * -- ou lista de colunas
    FROM ENTIDADES e
    WHERE 
        (
            :P2_FILTRO_TIPO = 'TODOS'
        )
        OR
        (
            :P2_FILTRO_TIPO = 'FORMANDO' 
            AND EXISTS (SELECT 1 FROM Papeis_Entidade p WHERE p.ID_Entidade = e.ID_Entidade AND p.Codigo_Papel = 'FORMANDO')
        )
        OR
        (
            :P2_FILTRO_TIPO = 'EQUIPA' 
            AND EXISTS (SELECT 1 FROM Papeis_Entidade p WHERE p.ID_Entidade = e.ID_Entidade AND p.Codigo_Papel IN ('FORMADOR', 'STAFF', 'COORDENADOR', 'ADMIN'))
        )
    ```
4.  **Page Items to Submit:** Escreva `P2_FILTRO_TIPO` (para o relatório saber o valor do botão).
5.  **Gravar e Executar.** Teste os botões.

---

## 2. Corrigir Edição (Painel Lateral / Drawer)

Se ao clicar no lápis o formulário aparece vazio, é porque o ID não está a ser passado corretamente.

### 2.1. Verificar o Link do Relatório
1.  No **Page Designer** da página **Diretório de Pessoas**.
2.  Vá a **Columns** no Interactive Report.
3.  **Habilitar Coluna de Link (Se não existir):**
    *   No painel **Rendering** (árvore à esquerda), clique em **Attributes** (logo abaixo da região "Diretório de Pessoas").
    *   No painel da direita (**Property Editor**), procure o grupo **Link Column**.
    *   **Link Column:** Mude de `Exclude Link Column` para `Link to Custom Target`.
    *   **Link Icon:** Escreva `fa-pencil` (ou escolha um ícone).
    *   **Target:** Clique em "No Link Defined".
        *   **Page:** Selecione a página do formulário (**Ficha de Entidade**).
        *   **Set Items:**
            *   **Name:** `P3_ID_ENTIDADE` (Este é o Item Primary Key da página de destino/formulário).
            *   **Value:** `#ID_ENTIDADE#` (ou `&ID_ENTIDADE.` - selecione a coluna ID da lista).
        *   **Clear Cache:** Escreva o número da página de destino (ex: `3`).
    *   Clique **OK**.
4.  *Alternativa:* Se preferir usar uma coluna existente (ex: Nome) como link:
    *   Na mesma secção **Link Column**, escolha `Link to Single Column`.
    *   **Link Column:** Selecione `NOME_COMPLETO`.
    *   Defina o **Target** da mesma forma.

### 2.2. Verificar a Inicialização do Formulário
Agora vamos à página de destino garantir que ela sabe ler o ID.

1.  Navegue para a página **Ficha de Entidade** (ex: page 3).
2.  No painel da esquerda (**Rendering**), verifique se existe um Processo (na aba **Processing** - ícone das setas giratórias) chamado **"Initialize form Ficha de Entidade"** (ou similar).
3.  Se não existir, crie um:
    *   **Type:** `Form - Initialization` (ou `Automated Row Fetch` em versões antigas).
    *   **Table:** `ENTIDADES`.
    *   **Primary Key Item:** `P3_ID_ENTIDADE`.
4.  **Verifique a Pre-Rendering (Before Header):**
    *   Garanta que este processo corre no ponto `Before Header` ou `Pre-Rendering`. O APEX normalmente cria isto automaticamente.

### 2.3. Teste Final
1.  Vá ao Diretório.
2.  Clique no lápis de uma pessoa existente (ex: "Joana Silva").
3.  O painel deve abrir e mostrar os dados da Joana.
4.  Altere algo e grave.
