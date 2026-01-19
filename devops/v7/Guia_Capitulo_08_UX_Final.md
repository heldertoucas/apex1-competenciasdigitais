# Manual de Implementação - Capítulo 8: UX e Polimento Final
**Aplicação:** Academia Digital  
**Versão do Guia:** 1.0  
**Objetivo:** Tornar a aplicação bonita, intuitiva e fácil de navegar.

---

## 1. Navegação e Menus

### 1.1. Reorganizar o Menu Lateral (Navigation Bar)
O APEX adicionou as páginas ao menu pela ordem de criação. Vamos organizar.
1.  **Shared Components** > **Navigation Menu**.
2.  Crie as entradas "Pai" (sem target ou link para `#`):
    *   `Pedagógico` (Ícone: `fa-users`)
    *   `Catálogo` (Ícone: `fa-book`)
    *   `Administrativo` (Ícone: `fa-briefcase`)
    *   `Configuração` (Ícone: `fa-cogs`)
3.  Arraste as páginas existentes para dentro dos grupos corretos:
    *   *Pedagógico:* Turmas, Minhas Turmas, Diário de Aulas.
    *   *Catálogo:* Cursos, Programas, Módulos.
    *   *Administrativo:* Entidades, Faturas, Equipamentos.
    *   *Configuração:* Tabelas de Domínio (Lookups).

---

## 2. Dashboards (Página Inicial)

### 2.1. KPI Cards na Home
1.  Vá à Página 1 (Home).
2.  Crie uma região do tipo **Cards**.
3.  **Source SQL:**
    ```sql
    SELECT 'Turmas a Decorrer' as Label, 
           COUNT(*) as Value, 
           'fa-graduation-cap' as Icon, 
           'u-color-1' as Color 
    FROM Turmas WHERE ID_Estado_Turma = (Select ID from Tipos_Estado_Turma where Codigo='DECORRER')
    UNION ALL
    SELECT 'Alunos Ativos', COUNT(*), 'fa-user', 'u-color-2' FROM Entidades WHERE Ativo='S'
    UNION ALL
    SELECT 'Faturas Pendentes', COUNT(*), 'fa-euro', 'u-color-9' FROM Faturas_Formadores WHERE Estado='EMITIDA'
    ```
4.  Configure o template dos Cards para mostrar o `Value` em grande destaque.

### 2.2. Gráficos de Evolução
1.  Crie uma região **Chart**.
2.  **Type:** Bar Chart.
3.  **SQL:** Contagem de matrículas por mês.
    ```sql
    SELECT TO_CHAR(Data_Inscricao, 'YYYY-MM') as Mes, COUNT(*) as Qtd
    FROM Matriculas
    GROUP BY TO_CHAR(Data_Inscricao, 'YYYY-MM')
    ORDER BY 1
    ```

---

## 3. Polimento Visual

### 3.1. Theme Roller
1.  Execute a aplicação.
2.  Na barra de developer (fundo), clique em **Theme Roller**.
3.  Experimente alterar o **Global Colors** para a paleta da sua organização (ex: mudar o azul padrão para um tom mais institucional).
4.  Clique **Save As** e defina como o estilo atual.

### 3.2. Feedback e Mensagens de Sucesso
1.  Garanta que todos os processos (Gravar, Apagar) têm a mensagem de sucesso configurada ("Process success message").
    *   Ex: "Entidade gravada com sucesso." em vez de "Row processed."

---
**Conclusão Final:**
Parabéns! Criou uma aplicação completa de gestão formativa ("Academia Digital") do zero.
O sistema abrange desde a definição do curso, passando pela matrícula, aula, avaliação até à faturação e arquivo.
