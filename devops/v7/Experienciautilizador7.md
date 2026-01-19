# **Experiência de Utilizador (UX): Ecossistema de Gestão da Formação e Certificação Digital**

Versão: 7.0 (Alinhamento Total com Modelo de Dados v7)  
Data: 18 de Janeiro de 2026  
Contexto: Refatoração Analítica, Operacional e Estrutural de Dados

## **1\. Preâmbulo Estratégico**

Este documento consubstancia a narrativa da experiência de utilização da aplicação "Passaporte Competências Digitais", alinhada com a arquitetura de dados rigorosa definida na versão 7.0. A abordagem transcende a descrição funcional, focando-se na fluidez dos processos, na integridade dos dados e na maximização do valor pedagógico e administrativo. O sistema desenha-se não apenas como um repositório de informação, mas como um motor de eficiência operacional e de reconhecimento de competências.

## **2\. Perfis de Intervenção e Matriz de Motivações**

A eficácia do sistema reside na clarificação dos papéis e na resposta precisa às necessidades de cada ator no ecossistema formativo:

* **O Coordenador (O Arquiteto):** Focado na estratégia e monitorização. Exige ferramentas robustas para a definição paramétrica da oferta formativa e análise macroscópica dos indicadores de desempenho.  
* **O Técnico (O Gestor Operacional):** O garante da conformidade. A sua atuação centra-se na gestão granular do ciclo de vida dos formandos e turmas, assegurando a fiabilidade dos dados administrativos.  
* **O Formador (O Pedagogo):** O agente de terreno. Necessita de interfaces ágeis para a gestão letiva e validação de competências, minimizando a carga burocrática.  
* **O Formando (O Beneficiário):** O centro do processo. A sua experiência deve ser desprovida de atrito, culminando na "Cerimónia de Finalização", um momento de validação e reconhecimento tangível.

## **3\. Jornadas de Utilização e Mapeamento de Dados**

Este capítulo detalha as interações do utilizador com a interface e a consequente persistência ou manipulação de dados na arquitetura relacional.

### **A. A Jornada do Coordenador: Configuração e Estruturação**

O Coordenador estabelece os alicerces do sistema, garantindo que a taxonomia da formação reflete os objetivos estratégicos através de interfaces de *back-office*.

1. **Definição da Matriz Formativa (Programas e Cursos):**  
   O Coordenador acede ao menu de gestão de catálogos. Ao criar um novo Curso, preenche os campos descritivos base (objetivos, conteúdos) e define explicitamente os parâmetros pedagógicos: a **Metodologia de Formação** (ex: métodos ativos, demonstrativos) e os **Recursos Didáticos** necessários para a execução (ex: hardware específico, software). Através de uma lista de seleção múltipla (shuttle), associa as Competências (do catálogo DigComp) que o curso visa desenvolver e certifica-se de associar o curso ao Programa correto.  
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** LMS_PROGRAMS, LMS_COURSES, LMS_COMPETENCIES.  
   * **Ação de Dados:** INSERT/UPDATE em LMS_COURSES preenchendo `Metodologia_Formacao` e `Recursos_Didaticos`.  
   * **Campos Críticos:** `Competencias_Associadas` (Relação N:N).  

2. **Parametrização da Comunicação e Logística:**  
   O utilizador configura os Modelos de Comunicação em HTML, inserindo placeholders dinâmicos (ex: {Nome\_Formando}) para personalização em massa. Paralelamente, gere o inventário de Tipos de Equipamento e de Tipos de Documento, assegurando que o sistema sabe que documentos exigir no Dossier (ex: Questionários de Avaliação).  
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** LMS_COMM_TEMPLATES, LMS_EQUIPMENTS, LMS_DOCUMENT_TYPES.

### **B. A Jornada do Técnico: Gestão do Ciclo de Vida Formativo**

O Técnico operacionaliza a estratégia, interagindo com formulários complexos e *dashboards* de controlo para assegurar a integridade dos dados desde a entrada até à certificação externa.

1. **Triagem e Admissão (Funil de Entrada):**  
   O Técnico visualiza uma grelha interativa com as Pré-Inscrições pendentes, onde cada linha representa a pré-inscrição numa Ação específica (Data/Local) de um curso de formação. Ao selecionar um candidato, o sistema valida a unicidade pelo NIF. O Técnico completa a ficha do formando:  
   * Valida as **Habilitações** e a **Situação Profissional**.  
   * Preenche as informações em falta, se aplicável, como a **Profissão** (texto livre), a **Entidade Empregadora** e a **Morada Profissional** completa.  
   Após este enriquecimento converte o registo em "Inscrito", pronto para matrícula. Caso o participante já tenha realizado cursos anteriormente, os dados do inscrito são atualizados, caso tenham sido alterados, e os novos cursos nos quais se inscreve são registados. 
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** Pre_Inscricoes (Leitura), LMS_ENTITIES (Escrita), LMS_COURSE_INTERESTS (Registo de interesse).  
   * **Ação de Dados:** Transação que popula `LMS_ENTITIES` com `Profissao`, `Entidade_Empregadora`, `Morada_Prof`, `Codigo_Postal_Prof`, `Localidade_Prof` e `Telemovel_Prof`.  

2. **Planeamento de Turmas:**  
   O utilizador cria uma nova Turma num formulário mestre-detalhe. Define os parâmetros temporais (Datas, Horário) e administrativos (Nº Informação, Código da Ação). Regista os módulos que compõem a turma. Identifica as competências que a turma vai desenvolver.  
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** LMS_CLASSES, LMS_MODULES, LMS_COMPETENCIES.  

3. **Matrícula e Gestão de Fluxo (Visão 360º):**  
   * **Matrícula em Lote:** A partir da lista de inscritos elegíveis, o Técnico executa a matrícula.  
   * **Visão 360º:** O Técnico acede à **"Gestão Global de Matrículas"**. O sistema apresenta um quadro consolidado (Pivot) onde, para cada formando, visualiza o estado atual em cada um dos cursos do programa (ex: "Concluído" no Curso A, "A Frequentar" no Curso B). Esta visão permite desbloquear inscrições sequenciais e gerir percursos completos sem navegar entre turmas isoladas.  
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** LMS_ENROLLMENTS.  
   * **Ação de Dados:** INSERT em `LMS_ENROLLMENTS` incluindo `Diagnostico_Respostas` e estado inicial. Leitura agregada para a view 360.  

4. **Controlo Administrativo e Financeiro (Dossier e Faturas):**  
   * **Dossier de Conformidade:** O Técnico acede ao Dashboard da Turma. Verifica a checklist `LMS_DOSSIER_CHECKLIST`. Para os itens críticos de avaliação, insere/valida os links obrigatórios: **URL do Questionário de Conhecimentos**, **URL das Respostas (Relatório)**, **URL do Questionário de Satisfação** e **URL das Respostas de Satisfação**, garantindo a rastreabilidade total da qualidade.  
   * **Gestão de Faturação:** Na aba financeira, gere o ciclo de vida das faturas dos formadores. Para cada fatura, regista não só o valor, mas os marcos temporais críticos: **Data de Emissão**, **Data Contabilística** (entrada nas finanças) e a final **Data de Pagamento**. Associa também o **Número da Fatura** para reconciliação externa.  Quando necessário, estes dados são exportados para informar a equipa de contabilidade.
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** LMS_DOSSIER_CHECKLIST, LMS_INVOICES.  
   * **Ação de Dados:** UPDATE em `LMS_INVOICES` preenchendo `Num_Fatura`, `Data_Contabilistica` e `Data_Pagamento`.  

5. **Interoperabilidade e Exportação (SIGO):**  
   O Técnico aciona a funcionalidade de exportação. O sistema executa uma pré-validação de consistência agregando dados da Turma, do Formando (incluindo Situação Profissional e Habilitações) e da Matrícula.  
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** LMS_CLASSES, LMS_ENROLLMENTS, LMS_ENTITIES.

### **C. A Jornada do Formador: Execução Pedagógica e Avaliação**

O Formador utiliza uma interface simplificada e adaptada a dispositivos móveis para a gestão do quotidiano letivo e validação de competências.

1. **Gestão da Sessão Letiva e Assiduidade:**  
   No final da aula, o Formador acede ao registo da Sessão. Introduz o sumário e preenche a grelha de presenças. O Formador garante também que o seu CV está atualizado. 
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** LMS_SESSIONS, LMS_ATTENDANCE, LMS_ENTITIES (`URL_CV`).  

2. **Validação de Competências:**  
   Num momento chave, o Formador valida na matriz quais as competências efetivamente adquiridas na turma, desbloqueando a emissão de badges.  
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** Turma_Competencias (Lógica de negócio).  

3. **Encerramento e o "Link Mágico":**  
   Num momento solene da última sessão, o Formador clica num botão **"Gerar Acesso ao Desafio"**. O sistema cria instantaneamente um **Token Único** para cada aluno da turma. O Formador projeta ou partilha estes códigos com os alunos. É esta chave que permite aos alunos, nos seus dispositivos, entrarem em "Desafio Digital Final" e iniciarem o processo de concluir o desafio digital final (avaliação de conhecimentos), conquistarem as medalhas digital que o formador acabou de desbloquear e realizarem a avaliação de satisfação.   
   **⚙️ Implicações no Modelo de Dados:**  
   * **Tabelas:** LMS_CLASSES (`Token_Acesso` ou tabela auxiliar de tokens).

### **D. A Jornada do Formando (O Beneficiário)**

1. **Pré-Inscrição:**  
   O formando preenche um formulário indicando os seus dados e selecionando as ações (Turmas) onde se quer inscrever, respondendo a um diagnóstico de competências.  

2. **Frequência e Conquista:**  
   Participa nas sessões e, no final, utiliza o token fornecido pelo formador para aceder à "Cerimónia de Finalização", onde valida as suas competências e reclama os seus badges digitais.  

3. **Futuro:**  
   Acede ao seu portal para consultar histórico e certificados.