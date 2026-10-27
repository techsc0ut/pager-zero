# ADR-001 · Overall architecture

- Status: Accepted
- Date: 2026-10-27

## Context

Build a portfolio AI on-call system that investigates real incidents on a live microservices shop, retrieves runbooks, and remediates only after human approval. Requirements from current AI-engineer postings: agents with tools, RAG, durable workflows, evaluation, MCP, Kubernetes/GitOps, and real databases.

## Decision

- Target system: OpenTelemetry Astronomy Shop in a local k3s cluster (Colima on Mac Studio).
- Agent platform: FastAPI + Temporal workflows + LangGraph investigator + Next.js dashboard.
- Models: all chat, embeddings, and reranking via cloud APIs (OpenAI / Anthropic / Gemini) through a LiteLLM gateway with cross-provider fallback. No local models.
- Data: PostgreSQL (+ pgvector) as system of record; Valkey for cache/rate limits/pub-sub.
- Delivery: two GitHub repos (`pager-zero` app, `pager-zero-gitops` manifests); Argo CD on the Mac; GitHub Pages for the public replay/eval site.
- Safety rule: the model only proposes remediations; the workflow executes with separate least-privilege credentials after human approval.
- Evaluation: fault injection with known ground truth; deterministic cassette tests in CI.

## Consequences

- Mac only needs a ~16 GB Kubernetes VM; no multi-GB model downloads.
- The system depends on internet and API spend (capped in the gateway and provider consoles).
- Nothing is publicly live by default; demos are local or via GitHub Pages / video.
