# Guia de Implementação: Fase 4 - Jornada do Formando
**Versão:** 1.0
**Perfil:** Formando ("O Beneficiário")
**UX:** Pública, Engaging, Sem Password.

---

## 1. Página Pública "Dossier Digital"
*UX: O formando recebe o link e aterra aqui diretamente.*

1.  **Create Page** > **Blank Page** (ex: Page 10).
2.  **Security:** :warning: **Page is Public** (Essencial).
3.  **Item Oculto:** `P10_TOKEN` (Passado no URL).

### 1.1. Validação do Token (Pre-Rendering)
No **Pre-Rendering** > **Before Header**:
```sql
BEGIN
    -- Validar se o token existe e buscar dados
    SELECT id_matricula, id_inscrito 
    INTO :P10_ID_MATRICULA, :P10_ID_INSCRITO
    FROM matriculas 
    WHERE token_acesso = :P10_TOKEN;
    
EXCEPTION WHEN NO_DATA_FOUND THEN
    -- Redirecionar para página de erro ou login
    APEX_UTIL.REDIRECT_URL('f?p=&APP_ID.:LOGIN');
END;
```

---

## 2. Interface do Formando
*Must-Haves: Nome, Estado, Badges.*

1.  **Região Hero (Static Content):**
    *   HTML: `<h1>Olá, &P10_NOME_FORMANDO.!</h1>` (Preencher itens no pre-rendering).
2.  **Região Estado do Curso (Cards/Badge List):**
    *   Visualizar se está "Em Curso" ou "Concluído".
3.  **Botão de Ação Principal:**
    *   **Label:** "Iniciar Desafio Digital"
    *   **Link:** URL do Microsoft Forms / Google Forms.
    *   **Parâmetros URL:** Passar o `ID_INSCRITO` para o Form externo (ex: `...viewform?entry.123=&P10_ID_INSCRITO.`).

---

## 3. Galeria de Badges (Gamification)
1.  **Região:** Cards (Style B).
2.  **Source:**
    ```sql
    SELECT c.nome, c.imagem_badge_url (BLOB ou URL), b.data_emissao
    FROM badges_atribuidos b
    JOIN competencias c ON c.id = b.id_competencia
    WHERE b.id_matricula = :P10_ID_MATRICULA
    ```
3.  **Empty State:** Se não tiver badges, mostrar mensagem encorajadora: *"Conclua o desafio para ganhar as suas medalhas!"*

---

## 4. Segurança Crítica
*   Como a página é pública, o `TOKEN` é a única chave.
*   Garanta que o token tem entropia suficiente (32 chars random) - Já garantido no Trigger da Fase 1.
*   **Checksum:** Para maior segurança, utilize `APEX_UTIL.PREPARE_URL` com checksum `SESSION` ao gerar os links no Power Automate.

---

## Checklist Validação Fase 4
*   [ ] Aceder à Pag 10 sem login redireciona para Login (Erro).
*   [ ] Aceder à Pag 10 com `?P10_TOKEN=valido` mostra o nome do aluno correto.
*   [ ] O botão do Desafio abre o Form externo.
