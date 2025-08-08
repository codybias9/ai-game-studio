# Service Spec Map

This maps each service to the relevant section of your Detailed Agent-Ready Outline.

- trend-scout → I.1 Trend-Scout Agent
- knowledge-graph → I.2 Knowledge-Graph Agent (builder worker; Neo4j dependency)
- ledger-agent → I.3 Immutable Ledger & AuditAgent (ClickHouse + immudb)
- vault-iam → I.4 Vault & IAM-Agent
- moon-pool-seed → II.1 Moon-Pool Library
- gene-sampler → II.2 Gene-Sampler Agent (Rust in spec; stubbed as HTTP svc)
- idea-forge → II.3 Idea-Forge Agent (LLM + RAG)
- mech-plot-mix → II.4 Mechanic-Mixer / Plot-Splicer
- ai-reco → II.5 AI-Recommendation Agent
- pool-mixer → II.6 PoolMixer Agent
- proto-orchestrator → IV Prototype Orchestrator + workers
- persona-swarm → V.1 Persona-Swarm Agent (RL interface; stub)
- rl-auditor → V.2 RL-Auditor Agent (Ray RLlib; stub)
- fun-score → V.3 Fun-Score Agent (RLHF/RLAIF; stub)
- narrative-coherence → V.4 Narrative Coherence Agent (stub)
- evo-optimizer → VI.1 Evo-Agent (GA; stub)
- meta-learner → VI.2 Meta-Learner Agent (weights tuner; stub)
- replay-ingestor → VI.3 Experience-Replay Agent (embeddings; stub)

> Each stub includes a health endpoint and can be replaced incrementally with the full logic.
