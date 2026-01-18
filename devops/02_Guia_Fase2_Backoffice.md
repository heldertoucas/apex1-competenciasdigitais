# Guia de Implementação: Fase 2 - Backoffice Técnico (Detalhado)
**Versão:** 2.0 (Passo-a-Passo)
**Perfil:** Técnico ("O Operador")
**Objetivo:** Criar a aplicação e as interfaces de gestão diária com detalhe absoluto.

---

## 1. Criação da Aplicação Base

Vamos começar por gerar a "caixa" onde tudo vai funcionar.

### 1.1. Iniciar o Wizard de Aplicação
1. **Aceda ao App Builder:** Na página inicial do seu Workspace, clique no ícone grande **App Builder**.
2. **Inicie uma nova app:** Clique no botão **Create** e de seguida selecione **New Application**.
3. **Defina o Nome:** No campo "Name", escreva: `Competências Digitais`.
4. **Escolha a Aparência:** Verifique se o "Appearance" diz "Redwood Light". Se não, clique no ícone ao lado para alterar.
5. **Defina o Ícone:** Clique no ícone da app para escolher um que goste (ex: um chapéu de graduado ou um livro) e defina a cor para um tom oficial (ex: Azul Escuro).

### 1.2. Adicionar Páginas Iniciais
Ainda no wizard, vamos pré-criar as páginas principais baseadas nas tabelas da Fase 1.

1. **Adicione a Página Turmas:**
   * Clique em **Add Page**.
   * Selecione **Interactive Grid**.
   * Page Name: `Turmas`.
   * Table: Selecione a tabela `TURMAS` (clique no ícone de lista para procurar).
   * Marque a opção "Allow Editing" (importante para editar datas e nomes).
   * Clique em **Add Page**.
2. **Adicione a Página Inscritos:**
   * Clique em **Add Page**.
   * Selecione **Interactive Grid**.
   * Page Name: `Inscritos`.
   * Table: Selecione a tabela `INSCRITOS`.
   * Marque "Allow Editing".
   * Clique em **Add Page**.
3. **Adicione a Página Cursos (Catálogo):**
   * Clique em **Add Page**.
   * Selecione **Interactive Grid**.
   * Page Name: `Cursos`.
   * Table: Selecione a tabela `CURSOS`.
   * Marque "Allow Editing".
   * Clique em **Add Page**.

### 1.3. Ativar Funcionalidades Extra
1. **Check All:** Em "Features", marque as opções:
   * **Install PWA** (Para funcionar como app no telemóvel).
   * **Access Control** (Para gerirmos permissões).
   * **Activity Reporting** (Para auditoria de acessos).
2. **Criar a Aplicação:** Clique no botão azul **Create Application** no fundo da página. O APEX vai demorar alguns segundos a gerar tudo.

---

## 2. Configuração de Utilizadores e Grupos (Segurança)

Antes de avançar, vamos garantir que temos os "atores" certos definidos no sistema.

### 2.1. Criar os Utilizadores da Aplicação

Primeiro, vamos criar as contas para os membros da sua equipa que irão usar a aplicação.

1. **Aceda ao seu Workspace APEX:** Faça login no seu workspace se ainda não estiver (ou clique no logo APEX no canto superior esquerdo para ir à àrea de administração).
2. **Navegue para a gestão de utilizadores:** No canto superior direito da página do Workspace (fora da App), clique no menu com o boneco/admin e selecione **Manage Users and Groups**.
3. **Crie os utilizadores:** Clique no botão **Create User** no lado direito.
4. **Preencha os dados:** Para cada membro da equipa, preencha o formulário:  
   * **Username:** O nome de utilizador para o login (ex: `coordenador.geral`, `tecnico.ana`, `formador.joao`).  
   * **Email Address:** O e-mail do utilizador.  
   * **Password:** Defina uma palavra-passe inicial robusta.  
   * **User is an administrator:** Deixe esta opção **desmarcada** para os utilizadores normais.  
   * **User is a developer:** Marque esta opção apenas se o utilizador também for desenvolver a aplicação. Para um Técnico ou Formador, **desmarque**.
5. **Crie pelo menos três utilizadores para teste:** Para já, sugiro criar um de cada tipo para podermos testar as permissões mais tarde:  
   * Um utilizador `coordenador_teste`
   * Um utilizador `tecnico_teste`
   * Um utilizador `formador_teste`

### 2.2. Criar os Grupos de Utilizadores

Agora, vamos criar os "chapéus" que cada utilizador pode usar: Coordenador, Técnico e Formador. Isto permite gerir acessos em massa.

1. **Aceda ao separador de Grupos:** Na mesma página "Manage Users and Groups", clique no separador **Groups**.
2. **Crie um novo grupo:** Clique no botão **Create Group**.
3. **Defina os grupos:** Crie, um a um, os três grupos seguintes. O nome é o mais importante (use maiúsculas para facilitar):  
   * `COORDENADORES`  
   * `TECNICOS`  
   * `FORMADORES`  
   (Pode adicionar uma descrição se desejar, mas não é obrigatório).

### 2.3. Associar Utilizadores aos Grupos

Com os utilizadores e os grupos criados, vamos atribuir cada utilizador ao seu respetivo grupo.

1. **Volte à lista de utilizadores:** Clique novamente no separador **Users**.
2. **Edite um utilizador:** Clique no ícone de lápis ou nome do utilizador `coordenador_teste`.
3. **Atribua o grupo:** Na secção "Group Assignments" (ou "User Groups"), selecione o grupo `COORDENADORES` na lista disponível e adicione-o à lista de grupos atribuídos.
4. **Guarde as alterações:** Clique em **Apply Changes**.
5. **Repita o processo:**  
   * Atribua o utilizador `tecnico_teste` ao grupo `TECNICOS`.  
   * Atribua o utilizador `formador_teste` ao grupo `FORMADORES`.

---

## 3. Configurar os Esquemas de Autorização na Aplicação

Agora que o Workspace conhece os grupos, a Aplicação precisa de saber como usá-los.

1. **Volte ao App Builder:** Entre na sua aplicação "Passaporte Competências".
2. **Shared Components:** Clique em **Shared Components**.
3. **Authorization Schemes:** Na secção "Security", clique em **Authorization Schemes**.
4. **Crie o Nível Técnico:**
   * Clique em **Create** > **From Scratch**.
   * **Name:** `Nivel: Tecnico`
   * **Scheme Type:** `PL/SQL Function Returning Boolean`
   * **PL/SQL Code:**
     ```sql
     -- Verifica se é Admin da App (Role APEX) OU se pertence aos Grupos do Workspace
     RETURN APEX_ACL.HAS_USER_ROLE(p_role_static_id => 'ADMINISTRATOR') 
         OR APEX_UTIL.CURRENT_USER_IN_GROUP(p_group_name => 'COORDENADORES')
         OR APEX_UTIL.CURRENT_USER_IN_GROUP(p_group_name => 'TECNICOS');
     ```
   * **Error Message:** `Acesso reservado a técnicos e coordenadores.`
   * Clique **Create Authorization Scheme**.
5. **Crie o Nível Formador:**
   * Repita o processo.
   * **Name:** `Nivel: Formador`
   * **PL/SQL Code:**
     ```sql
     RETURN APEX_ACL.HAS_USER_ROLE(p_role_static_id => 'ADMINISTRATOR') 
         OR APEX_UTIL.CURRENT_USER_IN_GROUP(p_group_name => 'FORMADORES');
     ```
   * Clique **Create**.

*Nota: Em APEX 24.2, a integração com Grupos APEX é automática através da feature "Access Control" que ativámos. Vamos depois configurar isso em Runtime ( Administration > Users & Roles ) para mapear os Grupos do Workspace aos Roles da App.*

---

## 4. Workflow de Importação (Excel)

Vamos criar a página mágica que permite carregar os dados.

### 4.1. Criar a Definição de Carga (Shared Components)
*Nota: Na versão atual do APEX, o wizard exige um ficheiro de exemplo para "aprender" a estrutura.*

**Pré-requisito:** Crie um pequeno ficheiro Excel (`exemplo.xlsx`) no seu computador apenas com o cabeçalho e uma linha de dados fictícios:
```csv
NOME_COMPLETO | EMAIL           | NIF       | TELEMOVEL | CURSO_INTERESSE
Joao Teste    | joao@teste.com  | 123456789 | 910000000 | Excel Basico
```

1. **Vá a Shared Components > Data Load Definitions > Create.**
2. **Passo 1 (Source):**
   * **Name:** `DL_Inscricoes`
   * **Upload Data From:** `File` (Upload a File).
   * **Sample File:** Carregue o ficheiro `exemplo.xlsx` que criou.
   * Clique **Next**.
3. **Passo 2 (Target Table):**
   * **Table Owner:** (O seu Schema).
   * **Table Name:** `PRE_INSCRICOES`.
   * **Error Table Name:** (Deixe vazio ou aceite o sugerido `PRE_INSCRICOES_ERR$`).
   * **Unique Constant:** (Deixe vazio).
   * Clique **Next**.
4. **Passo 3 (Column Mapping):**
   * O APEX faz o match automático pelos nomes. Verifique:
     * `NOME_COMPLETO` -> `NOME_COMPLETO`
     * `EMAIL` -> `EMAIL`
     * (etc.)
   * As colunas de sistema da tabela (`ID_PRE_INSCRICAO`, `ESTADO`, etc.) ficam sem mapeamento (correto).
   * Clique **Create Data Load Definition**.

### 4.2. Criar a Página de Importação
Agora sim, o wizard da página vai funcionar porque já temos a definição.

1. **Create Page:** No topo da App, clique **Create Page**.
2. **Select Component:** Selecione **Data Loading**.
3. **Page Definition:**
   * **Page Number:** (Aceite o sugerido, ex: 5)
   * **Name:** `Importar Inscrições`
   * **Page Mode:** `Normal`
4. **Data Load Attributes:**
   * **Data Load:** Selecione `DL_Inscricoes` (que acabou de criar). O erro "must have some value" desaparecerá.
   * **Upload Data From:** `File` (Upload de ficheiro Excel/CSV).
5. **Concluir:** Clique **Create Page**. O APEX irá criar 4 páginas interligadas (Dashboard, Mapping, Review, Result).

### 4.3. Criar o Dashboard de Processamento (Nova Página)
A página que acabou de criar (Data Loading) serve apenas para *carregar* o Excel para a tabela de Staging (`PRE_INSCRICOES`). Agora precisamos de um ecrã para ver esses dados e clicar no botão "Processar".

1. **Create Page:** No topo do App Builder, clique **Create Page**.
2. **Tipo:** Selecione **Interactive Report**.
3. **Definições:**
   * **Page Name:** `Dashboard Importação`
   * **Table:** `PRE_INSCRICOES`
   * Clique **Create**.
4. **Adicionar a Lógica "Processar":**
   * Já no Page Designer desta nova página:
   * **Crie uma Região Nova:** Posição `Before Report`. Chame-lhe `Ações`.
   * **Adicionar Botão:**
     * Clique direito na região `Ações` > Create Button.
     * **Name:** `BTN_PROCESSAR`
     * **Label:** `Processar Validados`
     * **Hot:** Sim (Template Option).
5. **Adicionar o Processo (PL/SQL):**
   * No separador **Processing** (ícone setas à esquerda), clique direito > **Create Process**.
   * **Name:** `Executar Importação`
   * **PL/SQL Code:**
     ```sql
     BEGIN
         -- Chama a procedure (agora sem parâmetros porque não matricula direto)
         processar_importacao;
     END;
     ```
   * **Success Message:** `Candidatos atualizados na base de dados (Pool de Inscritos).`
   * **Server-side Condition (When Button Pressed):** `BTN_PROCESSAR`.

**Resumo do Fluxo:**
1. O Técnico carrega o Excel na pag **Importar Inscrições**.
2. Vai ao **Dashboard**, revê os dados e clica **Processar**.
3. Os dados atualizam a tabela `INSCRITOS`.
4. (Posteriormente) O Técnico vai à página da Turma e associa os Inscritos manualmente.

---

## 5. Gestão Avançada de Turmas (Master-Detail)

Vamos transformar a grelha simples de Turmas numa consola de gestão.

### 5.1. Configurar a Grelha de Turmas (Mestre)
1. **Edite a Página Turmas.**
2. **Selecione a Região Interactive Grid 'Turmas'.**
3. **Ajuste as Colunas:**
   * Vá a **Columns** na árvore à esquerda.
   * Selecione `ID_CURSO`.
   * Na direita (Properties), mude **Type** para `Select List`.
   * **List of Values > SQL Query:** `SELECT nome d, id_curso r FROM cursos WHERE ativo = 'TRUE'ORDER BY nome`.
   * Selecione `ID_ESTADO`.
   * **Type:** `Select List`.
   * **List of Values:** `Shared Component > TIPOS_ESTADO_TURMA` (se criou LOV partilhada) ou SQL Query à tabela de tipos.

### 5.2. Adicionar os Alunos da Turma (Detalhe)
Queremos que, ao clicar numa turma, apareçam os alunos em baixo.

1. **Criar Região Filha:**
   * Clique direito na região "Turmas" > **Create Region Below**.
   * **Title:** `Alunos Matriculados`.
   * **Type:** `Interactive Grid`.
   * **Source Table:** `MATRICULAS`.
2. **Ligar Mestre-Detalhe (O Passo Crítico):**
   * Com a nova região selecionada, vá a properties **Master Detail**.
   * **Master Region:** Selecione `Turmas`.
   * **Join Columns:** O APEX tenta detetar `ID_TURMA`. Se não, defina-o manualmente.
3. **Configurar Colunas dos Alunos:**
   * Expanda a região `Alunos Matriculados` > Columns.
   * `ID_INSCRITO`: Mude para **Select List** (LOV: `SELECT nome_completo d, id_inscrito r FROM inscritos`).
   * `TOKEN_ACESSO`: Tipo **Text Field**. Defina **Read Only** > **Always** (Não queremos que o técnico edite o token à mão).
   * `EMAIL_ENVIADO`: Tipo **Switch** (On Value: `Y`/`TRUE`, Off Value: `N`/`FALSE`).

### 5.3. Adicionar Botão "Enviar Convites"
1. **Adicione Botão na Grelha de Alunos:**
   * Clique no topo da região Alunos, onde diz "Toolbar" (se não aparecer, adicione um botão normal na região).
   * Vamos adicionar um botão manual na região (posição "Right of Title").
   * **Label:** `Enviar Convites Pendentes`.
2. **Adicione Comportamento:**
   * **Behavior:** `Defined by Dynamic Action`.
3. **Crie a Dynamic Action:**
   * Clique direito no botão > **Create Dynamic Action**.
   * **Action:** `Execute Server-side Code`.
   * **PL/SQL Code:** (Aqui chamaremos o package da Fase 6).
     ```sql
     -- Placeholder para Fase 6
     pkg_notifications.enviar_convites_pendentes( :P_ID_TURMA_SELECIONADA_DA_LISTA_MESTRE );
     ```
   * **Items to Submit:** O ID da turma mestre.

---

## checklist de Validação Fase 2
No final desta fase, deve ter:
*   [ ] Aplicação "Passaporte Competências" criada e a correr.
*   [ ] 3 Utilizadores (Teste) criados e atribuídos aos grupos corretos.
*   [ ] Página de Importação a aceitar Excel e a mostrar dados na tabela `PRE_INSCRICOES`.
*   [ ] Página de Turmas a mostrar lista e, ao selecionar uma, mostrar os alunos em baixo.
