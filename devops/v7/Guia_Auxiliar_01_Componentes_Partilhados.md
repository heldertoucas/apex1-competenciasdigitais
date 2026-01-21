# Guia Auxiliar 01: Componentes Partilhados (Listas de Valores)

**Objetivo:** Centralizar a criação de Listas de Valores (LOVs) para serem reutilizadas em várias páginas, garantindo consistência e facilitando a manutenção.

---

## 1. Como Criar uma LOV Partilhada
1.  No APEX, vá a **Shared Components** > **List of Values**.
2.  Clique em **Create**.
3.  **Source:** `From Scratch`.
4.  **Name:** Use o nome indicado abaixo (ex: `LOV_GENEROS`).
5.  **Type:** `Dynamic`.
6.  **Data Source:** `Local Database`.
7.  **SQL Query:** Copie o código SQL fornecido.
8.  **Return/Display:** O APEX deteta automaticamente (Display = `d`, Return = `r`).

---

## 2. Listas de Configuração (Domínio Catálogo)

### LOV_ESTADOS_CURSO
Usado para definir se um curso é Rascunho, Ativo ou Arquivado.
```sql
SELECT Descricao as d,
       ID_Estado_Curso as r
  FROM Tipos_Estado_Curso
 ORDER BY Descricao
```

### LOV_PROGRAMAS
Usado para associar um curso a um programa pai.
```sql
SELECT Nome as d,
       ID_Programa as r
  FROM Programas
 WHERE Ativo = 'S'
 ORDER BY Nome
```

### LOV_AREAS_COMPETENCIA
Usado na definição de Competências.
```sql
SELECT Descricao as d,
       ID_Area_Competencia as r
  FROM Tipos_Area_Competencia
 ORDER BY Descricao
```

### LOV_NIVEIS_PROFICIENCIA
Usado na definição de Competências.
```sql
SELECT Descricao as d,
       ID_Nivel_Proficiencia as r
  FROM Tipos_Nivel_Proficiencia
 ORDER BY Descricao
```

---

## 3. Listas de Pessoas (Domínio Entidades)

### LOV_GENEROS
```sql
SELECT Descricao as d,
       ID_Genero as r
  FROM Tipos_Genero
 ORDER BY Descricao
```

### LOV_TIPOS_DOC
Documentos de identificação (CC, Passaporte, etc).
```sql
SELECT Descricao as d,
       ID_Tipo_Doc as r
  FROM Tipos_Doc_Identificacao
 ORDER BY Descricao
```

### LOV_SITUACOES_PROF
Situação profissional (Empregado, Desempregado, Estudante).
```sql
SELECT Descricao as d,
       ID_Situacao_Prof as r
  FROM Tipos_Situacao_Profissional
 ORDER BY Descricao
```

### LOV_QUALIFICACOES
Níveis de qualificação (Licenciatura, 12º Ano, etc).
```sql
SELECT Descricao as d,
       ID_Qualificacao as r
  FROM Tipos_De_Qualificacao
 ORDER BY Descricao
```

---

## 4. Listas de Sistema (Hardcoded/Static)

### LOV_SIM_NAO
Para campos booleanos manuais ou filtros.
*   **Type:** `Static`.
*   **Values:**
    *   Display: `Sim`, Return: `S`
    *   Display: `Não`, Return: `N`
