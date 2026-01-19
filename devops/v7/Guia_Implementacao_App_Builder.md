# Guia Mestre de Implementação: Academia Digital (SGUF v7.0)

**Versão:** 1.0  
**Data:** 18 de Janeiro de 2026  
**Contexto:** Construção de raiz da aplicação central de gestão formativa usando Oracle APEX.  
**Público-Alvo:** Desenvolvedores e Implementadores (Nível Júnior a Sénior).  
**Modelo de Dados:** v7.0 (Unified & Expanded).

---

## 1. Introdução e Metodologia
Este documento serve como o índice mestre para a construção da aplicação "Academia Digital". 
**Importante:** Este guia define a *estrutura* e o *que* deve ser feito. Cada Capítulo, Etapa e Tarefa listada abaixo terá o seu próprio "Guia Passo-a-Passo" individual detalhado posteriormente.

O desenvolvimento segue uma lógica **"Data-First"**: primeiro constrói-se a estrutura de dados sólida, depois as interfaces de gestão (Backoffice) e finalmente os fluxos de utilizador (Frontoffice).

---

## Capítulo 1: Fundação do Sistema
**Objetivo:** Preparar o ambiente no Oracle APEX, criar a aplicação esqueleto e implementar o domínio de dados estáticos (Lookups).

### Etapa 1.1: Inicialização do Ambiente
*   **Tarefa 1.1.1:** Aceder e configurar o Workspace APEX (Timezone, Language).
*   **Tarefa 1.1.2:** Criar a Aplicação "Academia Digital" (App ID sugerido: 100).
    *   *Definições:* Tema "Vita" (ou Redwood Light), Navegação Lateral, Autenticação APEX.
*   **Tarefa 1.1.3:** Configurar "Shared Components" iniciais (Lists of Values globais).

### Etapa 1.2: Implementação do Modelo de Dados (Domínio F - Lookups)
*   **Tarefa 1.2.1:** Criar e executar script SQL `01_Dominios.sql` para as tabelas de domínio (19 a 33 do Modelo v7).
    *   *Exemplos:* `Tipos_Genero`, `Tipos_Area_Competencia`, `Tipos_Estado_Matricula`.
*   **Tarefa 1.2.2:** Popular as tabelas de domínio com dados estáticos (Seed Data).
    *   *Ex:* Inserir 'M','F' em `Tipos_Genero`; 'Confirmada','Planeada' em `Tipos_Estado_Turma`.

---

## Capítulo 2: Gestão de Pessoas (Entidades)
**Objetivo:** Criar o repositório único de atores (Formandos, Formadores, Staff) que suportará todo o sistema.

### Etapa 2.1: Estrutura de Dados de Entidades
*   **Tarefa 2.1.1:** Criar e executar script SQL `02_Entidades.sql`.
*   **Tarefa 2.1.2:** Criar tabela `Entidades` com os novos campos v7 (`Profissao`, `Entidade_Empregadora`, `URL_CV`, etc.).
*   **Tarefa 2.1.3:** Criar tabela `Papeis_Entidade` para gestão de perfis múltiplos.

### Etapa 2.2: Módulo de Gestão de Entidades (UI)
*   **Tarefa 2.2.1:** Criar Página de Relatório Interativo "Diretório de Pessoas".
*   **Tarefa 2.2.2:** Criar Página de Formulário "Ficha de Entidade".
    *   *Requisito:* Organizar campos em regiões lógicas (Pessoal, Profissional, Contactos).
    *   *Requisito:* Implementar validação de NIF e Email únicos.
*   **Tarefa 2.2.3:** Criar Grid de "Papéis" dentro da Ficha de Entidade (Master-Detail).

---

## Capítulo 3: Catálogo Formativo
**Objetivo:** Implementar a estrutura hierárquica da oferta formativa (Programa > Curso > Módulo).

### Etapa 3.1: Estrutura de Dados do Catálogo
*   **Tarefa 3.1.1:** Criar e executar script SQL `03_Catalogo.sql`.
*   **Tarefa 3.1.2:** Tabelas: `Programas`, `Cursos`, `Modulos`, `Competencias`.

### Etapa 3.2: Backoffice do Catálogo
*   **Tarefa 3.2.1:** Criar Interface de Gestão de Programas (CRUD Simples).
*   **Tarefa 3.2.2:** Criar Interface de Gestão de Cursos (Master-Detail com Módulos).
    *   *Requisito:* Campos `Metodologia_Formacao` e `Recursos_Didaticos` devem usar Rich Text Editor.
*   **Tarefa 3.2.3:** Criar Interface de Associação de Competências.
    *   *Funcionalidade:* Shuttle ou Popup LOV para associar Competências do catálogo DigComp aos Módulos/Cursos.

---

## Capítulo 4: Planeamento e Logística (Ops)
**Objetivo:** Transformar cursos abstratos em turmas concretas no tempo e espaço.

### Etapa 4.1: Estrutura de Operações
*   **Tarefa 4.1.1:** Criar e executar script SQL `04_Operacoes.sql`.
*   **Tarefa 4.1.2:** Tabelas: `Locais` (Locais), `Turmas` (Turmas), `Equipa_Formativa` (Equipa), `Sessoes` (Cronograma).

### Etapa 4.2: Gestão de Planeamento
*   **Tarefa 4.2.1:** Criar Formulário "Planeamento de Turma".
    *   *Funcionalidade:* Definição de datas, horário descritivo e coordenador.
*   **Tarefa 4.2.2:** Criar Funcionalidade "Gerar Cronograma".
    *   *Lógica:* Processo (PL/SQL) que gera automaticamente registos na tabela `Sessoes` com base nas datas de início/fim e dias da semana da turma.
*   **Tarefa 4.2.3:** Criar Calendário Visual (Calendar Region) para visualização de ocupação de salas.

---

## Capítulo 5: Fluxo de Inscrição e Matrícula
**Objetivo:** Gerir a entrada de alunos, pré-inscrições e a matrícuça efetiva em turmas.

### Etapa 5.1: Estrutura de Matrículas
*   **Tarefa 5.1.1:** Criar e executar script SQL `05_Matriculas.sql`.
*   **Tarefa 5.1.2:** Tabela `Matriculas` (Matrículas).
    *   *Nota:* Incluir campo CLOB `Diagnostico_Respostas` para armazenar o JSON do diagnóstico inicial.

### Etapa 5.2: Gestão de Matrículas em Massa (Bulk Enrollment)
**Contexto:** O utilizador (Técnico) precisa de "povoar" uma turma rapidamente selecionando candidatos de uma bolsa de interessados.

*   **Tarefa 5.2.1:** Criar Página "Gestão de Inscritos na Turma".
    *   *Input:* Select List para escolher a Turma (Ação de Formação) e Curso.
*   **Tarefa 5.2.2:** Criar Região 1: "Alunos Matriculados".
    *   *Display:* Interactive Grid/Report mostrando quem já está na turma (`Matriculas` onde `ID_Turma = :P_TURMA`).
*   **Tarefa 5.2.3:** Criar Região 2: "Candidatos Disponíveis".
    *   *Display:* Interactive Report com Checkboxes de seleção.
    *   *Query:* Selecionar Entidades que mostraram interesse no Curso (Pré-inscrição) mas **NÃO** estão matriculados nesta Turma específica.
*   **Tarefa 5.2.4:** Criar Processo "Matricular Selecionados".
    *   *Lógica:* Ao submeter, iterar pelos IDs selecionados na Região 2 e inserir registos em `Matriculas` para a Turma atual.

---

## Capítulo 6: Execução Pedagógica (Sala de Aula)
**Objetivo:** Ferramentas para o dia-a-dia do Formador e avaliação.

### Etapa 6.1: Estrutura Pedagógica
*   **Tarefa 6.1.1:** Criar e executar script SQL `06_Pedagogia.sql`.
*   **Tarefa 6.1.2:** Tabelas: `Presencas` (Assiduidade), `Avaliacoes_Modulo` (Notas), `Badges_Conquistados` (Badges).

### Etapa 6.2: O Portal do Formador
*   **Tarefa 6.2.1:** Criar Dashboard simples "Minhas Turmas" (filtrado pelo utilizador logado).
*   **Tarefa 6.2.2:** Criar Página "Diário de Aulas".
    *   *Funcionalidade:* Registar Sumário da Sessão.
    *   *Funcionalidade:* Marcar Presenças (Grid com Checkbox "Presente/Falta" pré-populada com os alunos da turma).
*   **Tarefa 6.2.3:** Criar Página "Avaliação e Badges".
    *   *Funcionalidade:* Lançar notas por módulo e atribuir badges de competência.

---

## Capítulo 7: Administração e Conformidade
**Objetivo:** Garantir os requisitos documentais, financeiros e de reporte (SIGO).

### Etapa 7.1: Estrutura Administrativa
*   **Tarefa 7.1.1:** Criar e executar script SQL `07_Admin.sql`.
*   **Tarefa 7.1.2:** Tabelas: `Faturas_Formadores` (Faturas), `Itens_Dossier_Turma` (Documentos), `Equipamentos_Alocados` (Inventário).

### Etapa 7.2: Gestão Financeira e Documental
*   **Tarefa 7.2.1:** Criar Página "Controlo de Faturação".
    *   *Requisito:* Permitir registo de Nº Fatura, Data Emissão, Data Contabilística e Data Pagamento.
*   **Tarefa 7.2.1:** Criar Página "Controlo de Faturação".
*   **Tarefa 7.2.2:** Criar Página "Dossier Técnico-Pedagógico".
    *   *Visual:* Lista de verificação com semáforos (Verde=Entregue, Vermelho=Em Falta) para os documentos obrigatórios da turma (Sumários, Pautas, Inquéritos).

### Etapa 7.3: Exportação SIGO
*   **Tarefa 7.3.1:** Criar Relatório de Exportação.
    *   *Query:* Construir query complexa que junte dados da Turma, Formando e Matrícula no formato exigido pelo SIGO (conforme `documentos.md`).
    *   *Output:* Botão de Download CSV/Excel.

---

## Capítulo 8: UX, Dashboards e Polimento Final
**Objetivo:** Tornar a aplicação profissional, intuitiva e visualmente apelativa.

### Etapa 8.1: Estrutura de Navegação
*   **Tarefa 8.1.1:** Reorganizar Menu e Breadcrumbs.
*   **Tarefa 8.1.2:** Implementar ícones consistentes para cada módulo.

### Etapa 8.2: Dashboard 360º (Landing Page)
*   **Tarefa 8.2.1:** Implementar Cards de KPI (Turmas Ativas, Alunos Inscritos, Faturas Pendentes).
*   **Tarefa 8.2.2:** Implementar Gráficos de Evolução (Inscrições por Mês).

### Etapa 8.3: Segurança e Acessos
*   **Tarefa 8.3.1:** Configurar Esquemas de Autorização (Admin vs Formador vs Técnico).
*   **Tarefa 8.3.2:** Aplicar restrições de menu e página baseadas nos papéis.
