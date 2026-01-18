# Guia de Implementação: Fase 6 - Automação (Power Automate)
**Versão:** 1.0
**Foco:** Integração e Emails.

---

## 1. Configuração Microsoft Power Automate
1.  Crie um "Instant Cloud Flow" (When an HTTP request is received).
2.  **Schema JSON:**
    ```json
    {
        "type": "object",
        "properties": {
            "to": { "type": "string" },
            "subject": { "type": "string" },
            "body": { "type": "string" }
        }
    }
    ```
3.  Adicione ação "Office 365 Outlook - Send an email (V2)".
4.  Copie o **HTTP POST URL** gerado.

---

## 2. Configuração Oracle APEX (Web Credentials)
*Objetivo: Não deixar URLs hardcoded.*

1.  **Shared Components** > **Web Credentials**.
2.  **Create New:**
    *   **Name:** `POWER_AUTOMATE_EMAIL`
    *   **Static ID:** `PA_EMAIL_KEY`
    *   **Secret:** (O URL do Power Automate ou parte dele se usar Auth Key). *Nota: Normalmente o URL contem o Sig na Query String, pode guardar o URL inteiro numa Substitution String ou Tabela de Parametros.*

---

## 3. Package PL/SQL de Integração
Crie um pacote `PKG_NOTIFICATIONS` para centralizar o envio.

```sql
create or replace package body pkg_notifications as

    procedure enviar_email(
        p_to      in varchar2,
        p_subject in varchar2,
        p_body    in varchar2
    ) is
        l_body clob;
    begin
        l_body := json_object(
            'to'      value p_to,
            'subject' value p_subject,
            'body'    value p_body
        );

        apex_web_service.make_rest_request(
            p_url         => 'https://seu-endpoint-power-automate...',
            p_http_method => 'POST',
            p_body        => l_body
        );
    end;

end pkg_notifications;
```

---

## 4. Ligar aos Botões (Grid)
Nos botões "Enviar Convite" (Fase 2):
1.  Substitua o código antigo por:
    ```sql
    pkg_notifications.enviar_email(
        p_to => '...',
        p_subject => '...',
        p_body => '...'
    );
    ```

---

## Checklist Validação Fase 6
*   [ ] Disparar o fluxo envia um email real para a sua inbox Outlook.
*   [ ] O log do Power Automate mostra "Succeeded".
