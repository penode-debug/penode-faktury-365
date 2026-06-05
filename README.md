# Faktury 365 — Penode Process App

> **Automatizujte fakturaci v Microsoft 365**

Faktury 365 je open-source krabicová aplikace pro Microsoft Teams + SharePoint Online, určená pro malé a střední firmy (SMB). Nainstalujete ji sideloadem do svého M365 tenantu za ~3 minuty — bez externího backendu, vaše data zůstávají ve vašem SharePointu.

## Funkce

- 📊 Dashboard přehled faktur přímo v Microsoft Teams (Personal app)
- 📋 Strukturovaný SharePoint list s evidencí faktur (číslo, zákazník, částka, splatnost, stav)
- ⚡ One-click provisioning listu do zákaznického SharePoint Online
- 🔒 Žádný external backend — data výhradně ve vašem M365 tenantu
- 🆓 Zdarma ke stažení a použití

## Rychlý start

1. Stáhněte `penode-faktury-365.zip` z [penode365.com/products/faktury-365](https://penode365.com/products/faktury-365)
2. V Teams admin centru → Teams apps → Manage apps → **Upload new app** → vyberte .zip
3. Spusťte Faktury 365 v Teams → klikněte **Provision SharePoint list** → udělte souhlas

Detailní návod: [penode365.com/products/faktury-365/download](https://penode365.com/products/faktury-365/download)

## Struktura repozitáře

```
manifest/          Teams app manifest (schema v1.17) + ikony
provisioning/      SharePoint list site script JSON + az CLI setup
listing/           Store assets (screenshoty, copy) — WIP
.github/workflows/ CI: manifest validation
```

## Lokální vývoj

```bash
# Balení manifest.zip pro sideload
cd manifest && zip -r ../penode-faktury-365.zip . && cd ..
```

## Entra app registration

Pro Teams SSO a provisioning je potřeba registrace Entra aplikace. Viz [`provisioning/setup-entra.sh`](provisioning/setup-entra.sh) — spustit jednou jako Global Admin v tenantu `penode.onmicrosoft.com`.

Po registraci nahradit `REPLACE_WITH_ENTRA_APP_ID` v `manifest/manifest.json` získaným App ID.

## Podpora vývoje

Pokud vám Faktury 365 pomáhá, podpořte prosím vývoj — odkaz na stránce [penode365.com/products/faktury-365](https://penode365.com/products/faktury-365).

## Licence

MIT © Penode

## Přispívání

Pull requesty vítány. Otevřete issue pro návrhy nebo bug reporty.
