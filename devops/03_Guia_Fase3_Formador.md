# Guia de Implementação: Fase 3 - Portal do Formador
**Versão:** 1.0
**Perfil:** Formador ("O Facilitador")
**UX:** Mobile-First, Rápido, Simples.

---

## 1. Segurança & Acesso
1.  **Authorization Scheme:** Garanta que todas as páginas deste módulo têm o Scheme `Nivel: Formador` (criado na Fase 2).
2.  **Navigation Bar:** Crie um menu condicional. O Formador só deve ver "Minhas Turmas", não o Backoffice completo.

---

## 2. Dashboard "Minhas Turmas" (Cockpit)
*UX: Cartões grandes e fáceis de tocar num tablet.*

1.  **Create Page** > **Cards**.
2.  **Source SQL:**
    ```sql
    SELECT t.id_turma, t.nome, c.nome as curso, t.data_inicio, t.data_fim,
           (select count(*) from matriculas m where m.id_turma = t.id_turma) as qtd_alunos
    FROM turmas t
    JOIN cursos c ON c.id_curso = t.id_curso
    -- Assumindo que o formador é o user logado (precisa tabela de ligacao ou campo formador)
    -- WHERE t.formador_email = :APP_USER  <-- Implementar lógica de atribuição
    ```
3.  **Card Layout:**
    *   **Title:** `&NOME.`
    *   **Subtitle:** `&CURSO.`
    *   **Body:** `Alunos: &QTD_ALUNOS.`
4.  **Action:** Full Card Click -> Redirecionar para a página "Cockpit da Turma".

---

## 3. Cockpit da Turma (Gestão de Aula)
*Página de detalhe (Drill-down).*

1.  **Create Page** > **Blank Page** (Chame-lhe `Aula Atual`).
2.  **Região 1: Sumário (Text Area)**
    *   Formulário ligado a uma tabela `SESSOES` (se existir) ou campo `OBSERVACOES` da Turma.
3.  **Região 2: Alunos (Interactive Grid ou ListView)**
    *   **Source:** `MATRICULAS` (Filtrado pelo ID da Turma).
    *   **Colunas:** Nome do Inscrito.
    *   **Ação Rápida (Switch/Checkbox):** `PRESENTE` (Booleano).
    *   *Nota:* Num telemóvel, o ListView com um plugin de "Swipe" é ideal. Num Tablet (iPad da CML), o Interactive Grid funciona bem se tiver poucas colunas.

---

## 4. Botão "Lançar Desafio" (Fim de Curso)
*UX: O momento da verdade.*

1.  Adicione um botão **"Abrir Desafio Final"**.
2.  **Condition:** Mostrar apenas se a Turma estiver na reta final.
3.  **Action:**
    *   Execute PL/SQL Code.
    *   Gera/Ativa os Tokens de acesso dos alunos.
    *   Mostra um **Alert** com o link encurtado ou QR Code para a turma:
    `Link para os alunos: apex.oracle.com/.../f?p=APP:10`

---

## checklist de Validação Fase 3
*   [ ] Login como Formador mostra apenas o menu "Minhas Turmas".
*   [ ] Consigo ver os cartões das minhas turmas.
*   [ ] No telemóvel/tablet, consigo marcar presenças facilmente.
*   [ ] O botão de "Abrir Desafio" gera os links.
