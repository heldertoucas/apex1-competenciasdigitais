# Guia de Implementação: Fase 5 - Operações Avançadas
**Versão:** 1.0
**Foco:** Compliance, Logística e Reporte.

---

## 1. Gestão de Equipamentos
*Objetivo: Controlar Tablets e PCs.*

1.  **Criação de Tabelas (Adicional):**
    *   `EQUIPAMENTOS` (ID, Tipo, Serial, Estado).
    *   `ALOCACOES` (ID_Turma, ID_Equipamento, Data_Entrega, Data_Devolucao).
2.  **Interface Gráfica:**
    *   **Inventário:** Interactive Grid.
    *   **Alocar a Turma:** Master-Detail na página de Turmas.
3.  **Lógica:** Validar se o equipamento já está alocado ("Em Uso") antes de permitir nova alocação.

---

## 2. Dossier Técnico-Pedagógico (Evidências)
*Objetivo: Checklist automática baseada em ficheiros.*

1.  **Tabela de Arquivos:** `ARQUIVOS_ANEXOS` (Blob, MimeType, Nome, ID_Turma, Categoria).
    *   *Categoria Ex:* 'SUMARIOS_ASSINADOS', 'RELATORIO_AVALIACAO'.
2.  **Dashboard de Compliance (Page):**
    *   **Classic Report** sobre a tabela Turmas.
    *   **Colunas Virtuais (SQL Case):**
        ```sql
        CASE WHEN EXISTS (SELECT 1 FROM arquivos_anexos WHERE id_turma = t.id AND categoria = 'RELATORIO') 
             THEN 'green-check.png' 
             ELSE 'red-cross.png' 
        END as status_relatorio
        ```
    *   **Upload:** Botão para carregar ficheiro numa categoria específica.

---

## 3. Exportações (Financeiras e SIGO)
*Objetivo: Gerar Excel/XML para sistemas externos.*

### 3.1. Faturação (Excel)
1.  **Processo:** Interactive Report com agregados (`SUM(horas)` por Formador).
2.  **Botão "Exportar Faturação":**
    *   Use a funcionalidade nativa **Actions > Download > Excel**.
    *   Para formatos rígidos, usar `APEX_DATA_EXPORT` em PL/SQL para gerar um BLOB e servir como download.

### 3.2. SIGO (XML/CSV)
1.  **Report Dedicado:** "Pré-Exportação SIGO".
2.  **Validar Dados:** Colunas com highlights a vermelho se faltar NIF ou Habilitações.
3.  **Botão Exportar:**
    *   PL/SQL Process que gera o CLOB/BLOB no formato exato do SIGO.
    *   `apex_data_export.export(...)`.

---

## Checklist Validação Fase 5
*   [ ] Consigo alocar um tablet a uma turma.
*   [ ] O dashboard mostra "Verde" quando carrego o PDF do Relatório.
*   [ ] O Excel de Faturação sai com os totais por formador.
