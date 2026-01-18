### **Experiência de Utilizador (UX): Aplicação Passaporte Competências Digitais**

**Propósito do Documento:** Este documento descreve a aplicação "Academia Digital" não pela sua estrutura técnica, mas pela perspetiva das pessoas que a irão utilizar. O objetivo é mapear as jornadas dos diferentes tipos de utilizador para guiar o desenvolvimento de uma ferramenta coesa, centrada no ser humano e que responde eficazmente às necessidades de cada interveniente.

#### **1\. Os Nossos Utilizadores: Perfis e Motivações**

Identificamos quatro perfis de utilizador distintos, cada um com objetivos e necessidades específicas dentro do ecossistema do programa:

* **O Coordenador:** O estratega. A sua principal motivação é **configurar, supervisionar e medir o impacto** do programa. Precisa de uma visão macro, de ferramentas para definir os parâmetros da oferta formativa e de acesso a dados analíticos para a tomada de decisão.  
    
* **O Técnico:** O operador. É o pilar da gestão do dia a dia. A sua motivação é  
  **processar eficientemente o fluxo de cidadãos**, desde o interesse inicial até à conclusão da formação, garantindo a qualidade e a integridade dos dados operacionais.  
    
* **O Formador:** O facilitador. Está na linha da frente da formação. A sua motivação é  
  **gerir as suas turmas e registar o progresso dos formandos** de forma simples e rápida, para se poder focar no ensino.  
    
* **O Formando (Cidadão):** O beneficiário. É a razão de ser do programa. A sua motivação é **adquirir novas competências, ver o seu progresso reconhecido** e ter uma prova tangível das suas conquistas através do passaporte digital.

#### **2\. A Jornada do Utilizador: Fluxos e Interações Chave**

A aplicação materializa-se através das jornadas interligadas destes quatro perfis.

##### **A. A Jornada do Coordenador (A Visão Estratégica)**

O Coordenador utiliza a aplicação para construir e supervisionar o programa.

1. **Fase de Configuração:** O Coordenador acede a um "back-office" de gestão de catálogos para "mobilar" a aplicação. É aqui que ele define:  
     
   * Os **Programas** de formação (ex: "Passaporte Competências Digitais", "Futuro Digital" e "IA para Todos).  
       
   * O catálogo mestre de **Competências** alinhadas com o modelo DigComp, incluindo os ícones e medalhas digitais associadas.  
       
   * A lista completa de **Cursos** disponíveis, com os seus conteúdos, carga horária e objetivos.  
       
   * Os **Utilizadores** do sistema e as suas funções (Técnicos, Formadores).  
       
   * Os **Modelos de Comunicação** para automatizar emails e outras notificações.

   

2. **Fase de Supervisão (Futuro):** O Coordenador acede a um dashboard principal com métricas e gráficos que lhe dão o pulso do programa em tempo real: número de inscritos, turmas ativas, taxa de conclusão, etc.  
     
3. **Fase de Análise (Futuro):** O Coordenador gera relatórios detalhados para analisar o impacto do programa, cruzar dados demográficos com o sucesso na formação e preparar reportes para entidades superiores.

##### **B. A Jornada do Técnico (O Fluxo Operacional)**

O Técnico é o utilizador mais frequente da aplicação, garantindo que a "máquina" do programa funciona sem percalços.

1. **Fase 1: Funil de Entrada (Onboarding do Cidadão):**  
     
   * O Técnico inicia o seu dia na página  
     **"Novas Pré-Inscrições"**, que funciona como a sua caixa de entrada de trabalho. As pré-inscrições incluem informação sobre quais os cursos nos quais os interessados pretendem inscrever-se, data e local de realização do curso e informações de diagnóstico sobre as suas competências digitais.  
       
   * No painel de consulta das pré-inscrições, a aplicação **verifica automaticamente se o cidadão já existe** na base de dados (pelo NIF) e se já realizou algum dos cursos nos quais se inscreve.
       
   * Se o cidadão for novo, a aplicação propõe inserir os dados do pré-inscrito na tabela Inscritos, incluindo a informação sobre os cursos nos quais se inscreve. Se já existir, os dados de contacto e os cursos nos quais o participante se inscreve são atualizados, evitando duplicados. A pré-inscrição incluir informação sobre o curso, local e data de realização no curso no qual o inscrito está interessado.  
       
   * Com um clique, o Técnico conclui o perfil do Inscrito, que passa a estar "Ativo" no sistema, e a pré-inscrição original é arquivada. A informação sobre os cursos, locais e datas de realização nos quais o cidadão se inscreve - que corresponde a uma turma da lista de turmas, é atualizada e passa a estar disponível.

   

2. **Fase 2: Gestão Académica:**  
     
   * O Técnico acede à área de **"Gestão de Turmas"** para planear novas ações de formação.  
       
   * Ele cria uma nova Turma, associa-a a um Curso do catálogo e para garantir a rastreabilidade, o Técnico preenche também os dados oficiais da formação:
     * **Nº Informação:** (ex: INF/255/DDF/DMRH/CML/25 de 04-08-2025) e a respetiva Informação Mãe.
     * **Código da Ação (BD Formação):** (ex: IOU/PE_ID:AUCT/05).
     * **Tipo de Plano DDF:** Seleciona se se trata de Formação Interna, Externa ou para o Exterior.
   * Define o local, as datas, as vagas e atribui os Formadores e o Coordenador responsáveis.

   

3. **Fase 3: Matrícula de Formandos:**  
     
   * Dentro da página de detalhe de uma turma, o Técnico clica em "Matricular Novos Inscritos".  
       
   * A aplicação apresenta todos os formandos "Ativos" inscritos para esse curso que **ainda não estão nessa turma**, prevenindo erros de matrícula. A lista inclui todos os inscritos para essa turma (data e local de realização do curso correspondem à inscrição) e ainda, claramente identificados, todos os inscritos nesse curso, embora noutras datas e locais, para poder incluí-los na turma, se necessário. 
       
   * O Técnico seleciona os formandos e confirma a matrícula, que fica imediatamente registada.

   

4. **Fase 4: Gestão Global de Matrículas:**  
     
   * O Técnico acede à área de **"Gestão de Matrículas"** para gerir todas as matrículas nos cursos do programa.  
       
   * A aplicação apresenta um quadro muito completo, que resulta da consulta de dados em várias tabelas diferentes. O quadro inclui o nome, email, idade, habilitação e observações de todos os inscritos; inclui ainda uma coluna para cada um dos cursos do programa (se o programa tiver 10 cursos, o quadro apresentará 10 colunas); na coluna de cada curso aparece a informação mais recente sobre dado inscrito relativa ao curso, por exemplo “concluiu a ação X”, “a frequentar a ação Y”, falta justificada à ação Z”, “aguarda matrícula”, “inscrição suspensa”, etc.  
       
   * O Técnico tem uma visão 360 de todos os inscritos e pode, neste quadro, alterar o estado dos que “aguarda matrícula” e inscrevê-los, através de uma lista de valores, nas ações ainda por realizar de um dado curso. Ao carregar em “guardar”, um resumo das alterações são apresentadas ao técnico numa mensagem, que confirma e ordena a aplicação que inscreve os cidadãos nas turmas.  
       
5. **Fase 5: Gestão Global de Formandos:**  
     
   * O Técnico acede à área de "Gestão de Formandos" e a aplicação apresenta um quadro com dois filtros de seleção, curso e turma. Abaixo dos filtros é apresentado dinamicamente a lista dos cidadãos matriculados no curso/ação. O quadro inclui o nome, email, telemóvel e observações dos cidadãos matriculados e ainda dados sobre o Curso/ação: curso, ação, data de Início, data de Conclusão, Local e formadores.  
   * O quadro permite selecionar um ou mais cidadãos matriculados. Com base na selecção de cidadãos, esta página permitirá criar: registo de presenças, lista simples de participantes, envio de emails aos participantes, como o email de convocatória, suspensão da inscrição, pedido de adiamento de frequência do curso, etc.

6. **Fase 6: Gestão Administrativa e Financeira (Dossier e Faturação):**
     
     
   * **Controlo de Dossier Técnico-Pedagógico (Checklist de Conformidade):**
     * Para cada turma, existe agora um **Dashboard de Conformidade**. O Técnico verifica rapidamente o estado do dossier através de uma **Checklist Digital**.
     * **Validação por Referência:** A aplicação não guarda os ficheiros pesados (PDFs). Em vez disso, o Técnico verifica se o documento existe no arquivo digital da organização (SharePoint/Drive) e marca o item como "Conforme" na aplicação, colando opcionalmente o **link direto para o ficheiro**.
     * **Automação Inteligente:** Alguns itens da checklist são marcados automaticamente pelo sistema (ex: "Questionários Enviados"), enquanto outros requerem validação manual do Técnico (ex: "Relatório de Avaliação Assinado").
     * O sistema apresenta uma barra de progresso visual (ex: "80% Conforme") para cada turma.
     
   * **Gestão de Faturação de Formadores:**
     * O Técnico acede a uma vista dedicada de **"Gestão de Faturas"**, onde o sistema pré-calcula os valores com base nas horas lecionadas.
     * O Técnico valida ou ajusta os valores, define a data de emissão e o mês de processamento.
     * O estado de cada fatura é gerido visualmente ("Emitida", "Em Processamento", "Paga"), permitindo um controlo financeiro rigoroso por formador e por turma, sem necessidade de excels paralelos.

7. **Fase 7: Integração SIGO (Exportação Manual):**
   * O Técnico acede a uma vista dedicada onde os dados necessários para a plataforma SIGO estão tabelados e pré-validados.
   * O sistema verifica automaticamente se os campos obrigatórios introduzidos na gestão de turmas (**Nº Informação, Código da Ação, Datas Oficiais**) estão preenchidos e coerentes.
   * Valida também se os formandos têm as classificações e assiduidade mínimas lançadas.
   * O Técnico clica em **"Exportar Dados SIGO (Excel/CSV)"**. O ficheiro resultante segue a estrutura necessária para ser importado manualmente ou servir de guia rigoroso para o preenchimento na plataforma externa.

**C. A Jornada do Formador (A Interação em Sala e Fora Dela)**

O Formador interage com a aplicação de forma focada e pragmática. A ferramenta deve ser um aliado que simplifica a burocracia para que ele se possa concentrar no que faz de melhor: provocar aprendizagens.

* **Fase de Preparação:** O Formador acede ao seu portal, "As Minhas Turmas". Para cada turma, a aplicação funciona como o seu "cockpit", apresentando:  
    
  * **A Lista de Formandos:** Com contactos e notas relevantes.  
  * **O Calendário de Sessões:** Com acesso rápido a cada sessão.


* **Fase de Execução (Registo da Sessão):** No final de cada sessão, o momento crítico. A aplicação oferece flexibilidade máxima:  
    
  * O Formador acede à página de registo de presenças através do seu portal, de um **link direto** ou de um **QRCode**, permitindo um acesso instantâneo nos seus dispositivos.  
  * A interface é uma grelha limpa e rápida. Com poucos cliques, marca **Presentes, Ausentes ou Faltas Justificadas**.  
  * Na mesma página, preenche o **Sumário** da sessão, descrevendo as atividades e competências abordadas, e adiciona observações pertinentes. Um clique em "Guardar" submete tudo de uma só vez.


* **Fase de Encerramento e Administração:**  
    
  * **O Momento da Verdade (Última Sessão):** É o Formador quem orquestra o início da fase final. Ele acede à sua área da turma, ativa ou desativa as competências associadas ao curso que foram efetivamente concretizadas na ação de formação que realizou e a aplicação gera em seguida um **link único e exclusivo para o "Desafio Digital Final" daquela turma específica**. Este link é o "código" que ele fornece aos formandos para iniciarem a sua avaliação.  
  * **Conclusão da Turma:** No seu portal, o Formador pode garantir que todos os sumários e presenças estão preenchidos. Com um clique em "Concluir Turma", ele acede ao link do formulário no qual submete o seu relatório de satisfação e o sistema sinaliza ao Técnico que o dosser técnico-pedagógico está pronto para ser verificado pelo técnico e marcado como "Concluído".
Durante o curso, a secção Gestão do Dossier Técnico-Pedagógico está disponível a técnicos, coordenadores e formadores e permite consultar e imprimir documentos essenciais para o dossier:

* Lista de Participantes atualizada.  
  * Folha de Presenças consolidada com todas as sessões.  
    * Relatório de Sumários completo.

**D. A Jornada do Formando (A Experiência Central e de Reconhecimento)**

Esta é a jornada mais importante, a experiência do cidadão. Deve ser fluida, encorajadora e culminar num sentimento de conquista.

* **Fase de Descoberta:** O cidadão encontra o programa online ou num balcão de atendimento e manifesta o seu interesse ao preencher um formulário de Pre\_Inscricoes.  
    
* **Fase de Onboarding:** O cidadão é contactado pela equipa, os seus dados são validados e é formalmente criado como Inscrito na plataforma. Recebe uma comunicação de boas-vindas e a convocatória para a sua primeira turma.  
    
* **Fase de Participação:** O cidadão frequenta as sessões de formação. O seu progresso (presenças) é registado pelo Formador na aplicação.  
    
* **Fase de Avaliação e Conquista (Página Desafio Digital Final):** Esta fase não é uma simples avaliação; é uma **experiência integrada e interativa**, desenhada para ser o clímax do curso. Na última sessão, o Formador partilha o link mágico. Ao clicar, o formando não entra num formulário frio, mas sim numa **página de aterragem personalizada e acolhedora, a página Desafio Digital Final**.  
    
  * **Passo 1: O Desafio Final.** A página apresenta um botão claro e apelativo: **"Iniciar Desafio Final"**. Ao clicar, o formando é levado para o questionário de avaliação (ex: Google Forms). A tecnologia funciona nos bastidores: um token único já foi associado a ele, garantindo que as suas respostas serão corretamente identificadas. Ele preenche o desafio e submete.  
      
  * **Passo 2: A Validação e a Recompensa Imediata.** Após realizar o desafio digital final, o formando regressa à página da cerimónia. Agora, o próximo passo está disponível. Ele clica em **"Verificar Respostas e Obter Medalha 1"**.
      
1. A página exibe uma mensagem de processamento: *"A procurar as suas respostas..."*.
    2. Segundos depois, uma notificação visual confirma: **"Sucesso! Respostas validadas."** (Sem necessidade de animações complexas que possam falhar em browsers antigos). As respostas são copiadas para a memória clipboard do formando.
    3. A própria página atualiza-se para exibir as suas respostas, permitindo-lhe revê-las.
    4. Finalmente, os botões de ação são desbloqueados: links para as medalhas digitais da **plataforma de medalhas digitais**. O formando clica e conquista, um a um, colando as suas respostas no formulário de atribuição de medalhas. 
    5. O formando regressa à página da cerimónia após a conquista de cada medalha digital, até terminar a conquista de todas as medalhas digitais disponíveis.

  * **Passo 3: A Avaliação da Experiência.** De volta à página Desafio Digital Final, um último botão aguarda: **"Avaliar o Curso"**. Um clique leva-o diretamente ao formulário de satisfação (ex: Microsoft Forms), também ele pré-preenchido com dados do curso para facilitar o processo.

  Toda esta sequência transforma o que poderia ser uma tarefa administrativa complexa numa jornada recompensadora, guiada e sem atritos, que reforça o sentimento de realização.


* **Fase de Reconhecimento:** Ao concluir um curso com sucesso, e executar todas as etapas da "Cerimónia de Finalização", o sistema regista esta conquista.  
    
* **Fase de Autonomia (Futuro):** O formando acede a um Portal Pessoal online. Nesta área reservada, ele pode:  
    
  * Visualizar o seu "Passaporte Competências Digitais": uma galeria visual com todos os badges que já conquistou.  
  * Clicar num badge para ver os detalhes da competência e aceder ao link do Open Badge (`linkBadgeLCA`).  
  * Consultar o seu percurso e o histórico de formações.  
  * Descarregar os seus certificados de participação em formato PDF, através de um link de acesso ao repositório onde estão guardados (funcionalidade a desenvolver no futuro).

