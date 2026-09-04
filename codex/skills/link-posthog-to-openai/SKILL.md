---
name: link-posthog-to-openai
description: Configure and verify Codex OpenTelemetry export to a personal PostHog project using credentials stored in ap. Use when linking Codex usage telemetry to PostHog, diagnosing cross-machine Codex consumption, or repairing that connection.
---

# Link PostHog to OpenAI

Connect each local Codex client to the user's PostHog project so future API requests, token counts, models, conversations, errors, and tool activity can be investigated by machine.

## Required outcome

- Resolve the intended PostHog project explicitly and store its ingestion token as `POSTHOG_PERSONAL_PROJECT_TOKEN` in `ap`; a named bundle is optional.
- Export Codex OTLP logs to the literal URL `https://us.i.posthog.com/i/v1/logs` with `Authorization: Bearer ${POSTHOG_PERSONAL_PROJECT_TOKEN}`.
- Give every machine a distinct, stable `otel.environment` value.
- Keep `log_user_prompt = false` unless the user explicitly requests prompt-content logging after being told the privacy implications.
- Never print, echo, persist in chat, or insert the PostHog token directly into configuration. Reference only the token through an environment variable; keep the endpoint URL literal.

## Workflow

1. Read and follow the `ap` skill. Resolve the user-requested PostHog project by ID or exact name using the personal API credential. Verify that the selected ingestion token belongs to that project without revealing its value, and store it as `POSTHOG_PERSONAL_PROJECT_TOKEN`.
2. Read current official Codex OTel configuration documentation before editing because the exporter schema may change.
3. Verify PostHog ingestion with an authenticated empty OTLP request through `ap run`; report only the HTTP status. Stop if authentication or the endpoint fails.
4. Preserve all existing `~/.codex/config.toml` content and add or update this section:

```toml
[otel]
environment = "<stable-machine-label>"
exporter = { otlp-http = { endpoint = "https://us.i.posthog.com/i/v1/logs", protocol = "binary", headers = { "Authorization" = "Bearer ${POSTHOG_PERSONAL_PROJECT_TOKEN}" } } }
log_user_prompt = false
```

5. Load only `POSTHOG_PERSONAL_PROJECT_TOKEN` into the current macOS GUI launch environment using `ap run` and `launchctl setenv`, without exposing its value. Explain that newly launched apps inherit it and that the desktop app must be restarted.
6. Validate the config with a fresh Codex CLI process under `ap run`. Confirm the saved OTel section contains placeholders, not credential values.
7. After restart, produce one minimal Codex request and confirm a corresponding log arrives in PostHog before declaring end-to-end success. Do not generate repeated requests or loops for testing.

## Boundaries

- This setup is forward-looking and cannot attribute usage that occurred before OTel was enabled.
- Configure every machine separately with its own label to distinguish usage sources.
- Prefer the project ingestion token (`phc_`) over a personal API key (`phx_`).
- Do not modify unrelated PostHog projects, dashboards, retention, billing, or data-capture settings.
- Do not install a collector when direct PostHog OTLP ingestion succeeds.
