#!/bin/bash
# Entra app registration for Penode Faktury 365
# Run once by a Global Admin in penode.onmicrosoft.com tenant.
# Prerequisite: az login with admin account, then:
#   az account set --subscription <subscription-id>

set -e

TENANT_ID="${TENANT_ID:-$(az account show --query tenantId -o tsv)}"
echo "Tenant: $TENANT_ID"

# Create the app registration
APP_JSON=$(az ad app create \
  --display-name "Penode Faktury 365" \
  --sign-in-audience AzureADMultipleOrgs \
  --web-redirect-uris \
    "https://penode365.com/apps/faktury-365/auth/callback" \
    "https://token.botframework.com/.auth/web/redirect" \
  --identifier-uris "api://penode365.com/${APP_ID}" \
  --output json)

APP_ID=$(echo $APP_JSON | jq -r '.appId')
OBJECT_ID=$(echo $APP_JSON | jq -r '.id')
echo "App registered: client_id=$APP_ID"

# Add API scope for Teams SSO
az ad app update --id $OBJECT_ID --set api.oauth2PermissionScopes='[{"adminConsentDescription":"Allow Faktury 365 to act on behalf of user","adminConsentDisplayName":"Access Faktury 365 as user","id":"f8b1f57c-a77e-4c29-a14e-ab3b7a4d4e97","isEnabled":true,"type":"User","userConsentDescription":"Allow Faktury 365 to act on your behalf","userConsentDisplayName":"Access Faktury 365","value":"access_as_user"}]'

# Pre-authorize Teams clients
az ad app update --id $OBJECT_ID --set api.preAuthorizedApplications='[{"appId":"1fec8e78-bce4-4aaf-ab1b-5451cc387264","delegatedPermissionIds":["f8b1f57c-a77e-4c29-a14e-ab3b7a4d4e97"]},{"appId":"5e3ce6c0-2b1f-4285-8d4b-75ee78787346","delegatedPermissionIds":["f8b1f57c-a77e-4c29-a14e-ab3b7a4d4e97"]},{"appId":"4345a7b9-9a63-4910-a426-35363201d503","delegatedPermissionIds":["f8b1f57c-a77e-4c29-a14e-ab3b7a4d4e97"]}]'

# Grant admin consent for Sites.Selected (Application permission)
# This requires Global Admin and creates the service principal first
az ad sp create --id $APP_ID || true
az ad app permission grant --id $OBJECT_ID --api 00000003-0000-0000-c000-000000000000 || true
echo "Note: Grant Sites.Selected (role ID 883ea226-0bf2-4a8f-9f9d-92c9162a727d) manually in Entra portal: Enterprise apps -> Penode Faktury 365 -> Permissions -> Grant admin consent"

# Update manifest.json with APP_ID
sed -i "s/REPLACE_WITH_ENTRA_APP_ID/$APP_ID/g" manifest/manifest.json
echo "manifest.json updated with appId=$APP_ID"
echo ""
echo "=== DONE ==="
echo "App ID: $APP_ID"
echo "Object ID: $OBJECT_ID"
echo "Identifier URI: api://penode365.com/$APP_ID"
echo ""
echo "Next: copy APP_ID to PEN-76 comment and into penode-web SWA env vars."
