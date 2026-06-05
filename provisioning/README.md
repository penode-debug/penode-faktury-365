# Provisioning — Faktury 365

## Soubory

| Soubor | Popis |
|--------|-------|
| `faktury-list.site-script.json` | SharePoint Site Script pro vytvoření listu Faktury (sloupce, výchozí pohledy) |
| `setup-entra.sh` | az CLI skript pro registraci Entra aplikace (spustit jednou jako Global Admin) |

## Jak použít site script

### Přes Graph API (CTO agent / admin)

```bash
# Požadavek: tenant token s Sites.Selected write na cílový site
SITE_ID="<target-site-id>"
SCRIPT=$(cat faktury-list.site-script.json)

# Použij provisioning endpoint Teams tabu (PEN-76) nebo manuálně:
curl -X POST "https://graph.microsoft.com/v1.0/sites/$SITE_ID/lists" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d @faktury-list.site-script.json
```

### Přes SharePoint PnP CLI

```bash
m365 spo site script add --title "Faktury 365 List" --content @faktury-list.site-script.json
m365 spo site design add --title "Faktury 365" --webTemplate "68" --siteScripts [id-from-above]
```

## Entra app registration

Viz `setup-entra.sh`. Spustit jednou jako Global Admin:

```bash
TENANT_ID=<penode-tenant-id> bash setup-entra.sh
```
