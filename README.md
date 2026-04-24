Dhivashi: Maldives’ First AI Marketplace



1\. Vision

Dhivashi is envisioned as the sovereign agentic-first unified commerce and logistics operating system for the Maldives. It is not just an app, but a full AI-powered organization that autonomously manages commerce, delivery, and vendor relations across islands. The platform integrates customers, vendors, riders, and administrators into a single ecosystem, optimized for Maldives-specific constraints such as inter-island connectivity, tourism flows, and emerging digital payments.



Core principles:

\- Autonomous agents: Analysis, decision-making, execution, and self-optimization.

\- Auditability: Every agent decision logged with inputs, outputs, confidence, and HITL checkpoints.

\- Resilience: Offline-first support, inter-atoll logistics, multilingual flows.

\- Metrics-driven governance: Adoption speed, efficiency gains, error rates.



2\. Key Features

Customer App: Natural-language ordering (Dhivehi/English), live inventory, smart recommendations, order tracking.

Vendor Terminal: Inventory management, CSV/POS sync, analytics, storefront customization, financial ledger.

Delivery Network: Three-tier routing (shop staff, Dhivashi fleet, external partners like Avas/Gaadiya), GPS tracking, gig onboarding.

Admin Portal: Vendor onboarding, compliance checks, delivery partner management, audit logs, analytics.

Payments: Hybrid COD + digital payments (Swipe, PayMV QR, Favara, UPI linkage).

Predictive Agents: Demand forecasting, inventory optimization, dynamic pricing.

Tourism Mode: Multi-currency support, QR-first payments, tourist-friendly onboarding.



3\. Tech Stack (2026)

Mobile Apps: Flutter 4.x (offline-first, Hive/Isar storage).

Web/Admin: Next.js 15+, Tailwind, shadcn/ui.

Backend \& AI Layer: FastAPI + LangGraph (agent orchestration), Supabase/Neon hybrid.

Database: PostgreSQL + PostGIS + pgvector.

Auth: Clerk/WorkOS with +960 phone/WhatsApp + digital ID support.

Maps \& Routing: Mapbox/Google Maps + Valhalla/OSRM.

Payments: Swipe, PayMV QR, Favara, UPI linkage.

Observability: LangSmith + OpenTelemetry.



4\. Database Schema Foundations

Core tables: profiles, shops, products, orders, delivery\_requests, earnings.

Additions: agent\_workflows, audit\_logs, vector embeddings, enhanced RLS.



5\. Timeline \& Roadmap

Phase 0 — Constitution Setup (April 2026)

Configure Jack (AI builder) with agentic-first mandate.

Payments prototype: Swipe + PayMV QR + COD fallback.

Database schema finalized with audit + vector search.

Phase 1 — MVP Launch (3 months: July 2026)

...

\[Full phases as in your query]



6\. Implementation Mandate

Jack (AI builder) must: Generate code, tests, migrations, deployment scripts, and monitoring iteratively.

Enforce auditability and resilience in every module.

Prioritize revenue-generating loops first.

Defer non-essential costs until platform achieves sustainable revenue.



Dhivashi is not just an app — it is the Maldives’ first AI marketplace, a sovereign agentic operating system for commerce and logistics.

