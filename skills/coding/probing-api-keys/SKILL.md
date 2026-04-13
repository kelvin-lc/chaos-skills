---
name: probing-api-keys
description: Use when the user provides an LLM API key, endpoint, or credentials, and wants to know which models are accessible, or when debugging API access issues
---

# Probing API Keys

## Overview

Discovers which models an API key can access. Supports Azure OpenAI, OpenAI-compatible providers (resellers, proxies, self-hosted), and Anthropic.

**Core principle:** Probe the API systematically — list models first, then verify deployments if applicable.

## When to Use

- User provides an API key and wants to know what models it can access
- Debugging whether a key has access to a specific model
- Inventorying available deployments on an Azure OpenAI resource
- Checking what a reseller/proxy key actually provides

## Collect Inputs

Before probing, collect these from the user:

- **API key** (required)
- **Endpoint URL** (required for Azure and resellers; has sensible defaults for OpenAI and Anthropic)

Set them as shell variables for the commands below:

```bash
ENDPOINT="<endpoint-url>"   # strip trailing slash
API_KEY="<api-key>"
```

## Provider Detection

Determine provider type from the endpoint URL or key format:

| Signal | Provider Type |
|--------|--------------|
| `*.openai.azure.com` | Azure OpenAI |
| `api.openai.com` | OpenAI official |
| `api.anthropic.com` or key starts with `sk-ant-` | Anthropic |
| Anything else (custom domain, IP, etc.) | OpenAI-compatible / reseller |

## Azure OpenAI

Azure has two relevant endpoints. **Always try both** — `models` shows what the region supports, `deployments` shows what's actually deployed and usable.

### 1. List Available Models (region-level)

```bash
curl -s "${ENDPOINT}/openai/models?api-version=2024-10-21" \
  -H "api-key: ${API_KEY}" | python3 parse_azure_models.py
```

### 2. List Deployments (what's actually deployed)

The deployments endpoint requires a **management-plane API version**:

```bash
curl -s "${ENDPOINT}/openai/deployments?api-version=2024-10-01-preview" \
  -H "api-key: ${API_KEY}" | python3 parse_azure_deployments.py
```

**If deployments returns 404:** The API key is a data-plane key (inference only). It can call models but can't list deployments. In this case, the `models` endpoint is the primary source of truth for what's available in the region.

### 3. Test a Specific Deployment

If you need to confirm a specific deployment works:

```bash
curl -s "${ENDPOINT}/openai/deployments/${DEPLOYMENT_NAME}/chat/completions?api-version=2024-10-21" \
  -H "api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"hi"}],"max_tokens":5}'
```

## Anthropic

### List Models

```bash
curl -s "https://api.anthropic.com/v1/models" \
  -H "x-api-key: ${API_KEY}" \
  -H "anthropic-version: 2023-06-01" | python3 parse_anthropic_models.py
```

For resellers or proxies that expose the Anthropic API format:

```bash
curl -s "${ENDPOINT}/v1/models" \
  -H "x-api-key: ${API_KEY}" \
  -H "anthropic-version: 2023-06-01" | python3 parse_anthropic_models.py
```

### Test a Specific Model

```bash
curl -s "https://api.anthropic.com/v1/messages" \
  -H "x-api-key: ${API_KEY}" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d '{"model":"MODEL_NAME","max_tokens":5,"messages":[{"role":"user","content":"hi"}]}'
```

## OpenAI Official / Compatible APIs

### List Models

```bash
# OpenAI official
curl -s "https://api.openai.com/v1/models" \
  -H "Authorization: Bearer ${API_KEY}" | python3 parse_models.py

# OpenAI-compatible (reseller/proxy) — same format, different base URL
curl -s "${BASE_URL}/v1/models" \
  -H "Authorization: Bearer ${API_KEY}" | python3 parse_models.py
```

### Test a Specific Model

```bash
curl -s "${BASE_URL}/v1/chat/completions" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"model":"MODEL_NAME","messages":[{"role":"user","content":"hi"}],"max_tokens":5}'
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Wrong `api-version` for Azure | Use `2024-10-21` for data-plane, `2024-10-01-preview` for management |
| Using `Authorization: Bearer` for Azure | Azure uses `api-key:` header, not Bearer token |
| Assuming models list = deployed models (Azure) | Models list shows region availability; deployments show what's actually usable |
| Forgetting trailing `/` in endpoint URL | Normalize: strip trailing slash before appending paths |
| Using OpenAI SDK format for Azure | Azure SDK needs `azure_endpoint`, `api_key`, and `api_version` params |
| Using `Authorization: Bearer` for Anthropic | Anthropic uses `x-api-key:` header, not Bearer token |
| Missing `anthropic-version` header | Required on all Anthropic API calls; use `2023-06-01` |

## Quick Reference

| Provider | Auth Header | Models Endpoint | Deployment Check |
|----------|------------|-----------------|------------------|
| Azure OpenAI | `api-key: KEY` | `/openai/models?api-version=2024-10-21` | `/openai/deployments?api-version=2024-10-01-preview` |
| OpenAI | `Authorization: Bearer KEY` | `/v1/models` | N/A (all listed models usable) |
| Anthropic | `x-api-key: KEY` + `anthropic-version: 2023-06-01` | `/v1/models` | N/A (all listed models usable) |
| Compatible/Reseller | Varies (try Bearer or x-api-key) | `BASE_URL/v1/models` | N/A (try chat completion) |
