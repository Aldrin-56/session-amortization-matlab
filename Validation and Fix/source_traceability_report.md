# Source-to-Paper Traceability Report
## Full Map: What Source File → What Content → Which Paper Folder File

**Date:** 2026-03-03 | **Scope:** All 9 Paper folder files (excluding main.tex)
**Working directory scanned:** All folders confirmed — Draft/, Backup/, Validation and Fix/, simulation/, simulation/results/

---

## PART 1 — ALL SOURCE FILES IN WORKING DIRECTORY

### Category A — Draft/ (Primary Specification Documents)

| File | Size | Role |
|---|---|---|
| `Draft/master_draft_COMPLETE.md` | 59,775 bytes | Primary base paper reference — all algorithms, tables, timing, security proofs, parameters |
| `Draft/session amortization draft.md` | 8,031 bytes | Complete SAKE-IoT protocol specification (4-phase algorithm, v3 corrections) |
| `Draft/novelty-security proof draft.md` | 7,027 bytes | Security proof requirements and expected simulation results |
| `Draft/cryptographic_proof_review.md` | 11,138 bytes | Publication-readiness review — 3 mandatory fixes for Scopus submission |
| `Draft/A post-quantum lattice based...pdf` | 3,327,532 bytes | Original base paper PDF (source of all timing and hardware values) |

### Category B — simulation/ (Implementation)

| File | Size | Role |
|---|---|---|
| `simulation/sim_latency.m` | 9,495 bytes | M1: empirical per-packet latency measurement (tic/toc, 10K iterations) |
| `simulation/sim_bandwidth.m` | 5,725 bytes | M2: bandwidth overhead arithmetic (deterministic constants) |
| `simulation/sim_energy.m` | 5,387 bytes | M3: clock cycle comparison (Intel AES-NI vs base paper Fig. 7) |
| `simulation/proof1_ind_cca2.m` | 19,309 bytes | P1: IND-CCA2 game (500K oracle queries, real HMAC-SHA256) |
| `simulation/proof2_replay.m` | 6,269 bytes | P2: replay resistance (10K trials, 4 scenarios) |
| `simulation/proof3_forward_secrecy.m` | 11,071 bytes | P3: epoch-bounded forward secrecy (10×10 full cross-epoch) |
| `simulation/run_all_proofs.m` | 2,371 bytes | Sequential runner for all 6 scripts |

### Category C — simulation/results/ (Output Record)

| File | Size | Role |
|---|---|---|
| `simulation/results/novelty_proof_and_results.md` | 20,844 bytes | Complete MATLAB output: all metric values, proof results, TLS/DTLS comparison |
| `simulation/results/proof_results.txt` | 10,713 bytes | Raw terminal output from run_all_proofs.m |
| `simulation/results/sim_latency.png` | 74,745 bytes | Figure 1 source image |
| `simulation/results/sim_bandwidth_bar.png` | 54,640 bytes | Figure 2 source image (bar chart) |
| `simulation/results/sim_bandwidth_cumulative.png` | 57,827 bytes | Figure 2 source image (cumulative) |
| `simulation/results/sim_energy.png` | 67,861 bytes | Figure 3 source image |

### Category D — Validation and Fix/ (Validation Records)

| File | Size | Role |
|---|---|---|
| `Validation and Fix/final_forensic_revalidation.md` | 9,235 bytes | Final verdict: 8 original + 5 new issues all resolved |
| `Validation and Fix/novelty_and_scopus_evaluation.md` | 13,950 bytes | Scopus readiness assessment: 14/14 algo, 18/18 proof, 0 invalidities |
| `Validation and Fix/metric1_latency_logical_validation.md` | 10,976 bytes | Deep logical validation of M1: flaws, objections, evidence |
| `Validation and Fix/metric2_bandwidth_logical_validation.md` | 12,584 bytes | Deep logical validation of M2 |
| `Validation and Fix/metric3_energy_logical_validation.md` | 15,088 bytes | Deep logical validation of M3 |
| `Validation and Fix/novelty_sufficiency_validation.md` | 16,565 bytes | Confirms 3 metrics collectively sufficient; no additional metrics needed |
| `Validation and Fix/proof 1 limitation fix.md` | 4,982 bytes | IND-CCA2 proof fix details |
| `Validation and Fix/proof 3 limitation fix.md` | 4,670 bytes | EB-FS proof fix details |
| `Validation and Fix/gap_resolution_proposals.md` | 16,319 bytes | Gap resolution proposals for Paper folder |

### Category E — Backup/ (Analysis and Design Notes)

| File | Size | Role |
|---|---|---|
| `Backup/metric1_fix_gemini.md` | 4,884 bytes | Methodology fix rationale for M1 (tic/toc empirical fix) |
| `Backup/metric2_fix_gemini.md` | 4,901 bytes | Methodology fix rationale for M2 (conservative baseline) |
| `Backup/metric3_fix_gemini.md` | 4,199 bytes | Methodology fix rationale for M3 (Flaw 3: cosmetic split) |
| `Backup/master_draft_part1.md` | 13,761 bytes | Earlier draft partitions (superseded by master_draft_COMPLETE.md) |
| `Backup/master_draft_part2.md` | 21,675 bytes | Earlier draft partitions (superseded) |
| `Backup/master_draft_part3.md` | 20,412 bytes | Earlier draft partitions (superseded) |
| `Backup/gemini_vs_committed_comparison.md` | 18,333 bytes | Comparison report between code versions |
| `Backup/gap_fixes_complete_report.md.resolved` | 31,051 bytes | Resolved gap fixes archive |

### Category F — Root Level

| File | Size | Role |
|---|---|---|
| `session amortization draft.md` (root) | 8,036 bytes | Root-level copy of amortization draft (same content as Draft/ version) |
| `pdf_output.txt` / `pdf_output_utf8.txt` | 240K / 123K bytes | PDF text extraction of base paper (used as backup reference) |

---

## PART 2 — SOURCE-TO-PAPER TRACEABILITY MAP

### Paper File 1: `paper_master_reference_draft.md` (43,918 bytes)

**Role:** Master paper draft covering all sections §1–§10, appendices, and mandatory statements.

| Section in Paper File | Source File(s) Used | What Was Derived |
|---|---|---|
| §1 Title | `Draft/master_draft_COMPLETE.md` §1 | Paper context — extends Kumari et al. framework |
| §1 Abstract | `simulation/results/novelty_proof_and_results.md` §conclusions + `Draft/novelty-security proof draft.md` §Part 3 | All 6 metric values in abstract: 99.1%, 184 bits, 33×, IND-CCA2, Pr=0, EB-FS |
| §1 Keywords | `Draft/session amortization draft.md` + `Draft/master_draft_COMPLETE.md` | Post-quantum, IoT, SAKE, amortization, forward secrecy, Ring-LWE |
| §2 Introduction | `Draft/master_draft_COMPLETE.md` §1–§3 (motivation), `Draft/novelty-security proof draft.md` (problem statement) | IoT constraints motivation, base paper gap identification |
| §2.1 Problem Statement | `Draft/novelty-security proof draft.md` (opening), `simulation/results/novelty_proof_and_results.md` §1 | "7.3728 ms per packet is prohibitive for IoT" claim |
| §2.2 Proposed Solution | `Draft/session amortization draft.md` (overview), `simulation/results/novelty_proof_and_results.md` §2 | Tier 1 / Tier 2 architecture description |
| §2.3 Contributions list | `Validation and Fix/novelty_and_scopus_evaluation.md` §2.7, `simulation/results/novelty_proof_and_results.md` §conclusions | 4 numbered contributions (99.1%, 45.1%, 33×, 3 proofs) |
| §3 Related Work | `Draft/master_draft_COMPLETE.md` §4 (base paper related work §4.1–§4.3) | All IoT authentication, code-based, Ring-LWE references |
| §3.4 TLS/DTLS differentiation | `simulation/results/novelty_proof_and_results.md` §3.4, `Draft/cryptographic_proof_review.md` Fix 3 | 9-row TLS 1.3 / DTLS 1.3 / SAKE comparison table |
| §4 Mathematical Preliminaries | `Draft/master_draft_COMPLETE.md` §5 (Ring-LWE def), §7 (QC-LDPC), §10 (parameters) | All formal definitions: Ring-LWE, QC-LDPC, notation table |
| §4 All parameter values | `Draft/master_draft_COMPLETE.md` §5 (n=512, σ=43, q=2²⁹−3, N=3) | All Ring-LWE system parameters |
| §5 System & Adversary Model | `Draft/master_draft_COMPLETE.md` §11.1–§11.2, `Draft/novelty-security proof draft.md` §Part 2 | ROM model, A1/A2/A3 adversary types, threat model |
| §6 Protocol Description | `Draft/session amortization draft.md` (complete 4-phase) | All 4 phases with timing, all step numbers |
| §6 Phase 1 timing | `Draft/master_draft_COMPLETE.md` §12 (Table 6 = Δ_SG 13.299ms, Δ_KG 0.288ms; Table 7 = Δ_Dec 5.843ms) | All Phase 1 timing constants |
| §6 Phase 2 AD binding | `Draft/novelty-security proof draft.md` §Proof 1 architecture table | AD = DeviceID ∥ EpochID ∥ Nonce_i |
| §7 Security Analysis (ROM) | `Draft/novelty-security proof draft.md` (all 3 proofs), `Draft/cryptographic_proof_review.md` (3 fixes) | Full formal security section |
| §7.2 IND-CCA2 (Theorem 1) | `Draft/novelty-security proof draft.md` §Proof 1, `Draft/cryptographic_proof_review.md` Fix 1+3 | Theorem statement, formal bound, proof sketch, MATLAB disclaimer |
| §7.2 IND-CCA2 simulation | `simulation/results/novelty_proof_and_results.md` §5 | ε=0.0037, 99.96% ⊥ rate, 500K oracle queries |
| §7.3 Replay (Theorem 2) | `Draft/novelty-security proof draft.md` §Proof 2 | Pr=0 monotonic counter theorem, desync corollary |
| §7.3 Replay simulation | `simulation/results/novelty_proof_and_results.md` §6 | 10K trials, 4 scenarios |
| §7.4 EB-FS (Theorem 3) | `Draft/novelty-security proof draft.md` §Proof 3, `Draft/cryptographic_proof_review.md` Fix 2 | Ring-LWE reduction, past+future secrecy, memset_s note |
| §7.4 EB-FS simulation | `simulation/results/novelty_proof_and_results.md` §7 | 0/100 past, 0/100 future, 5×10×10=2000 pairs |
| §8 Simulation Setup | `simulation/results/novelty_proof_and_results.md` §1 (header) | MATLAB R2023b, Intel Core i5, 8 GB RAM |
| §8.1 Latency results | `simulation/results/novelty_proof_and_results.md` §2 M1, `simulation/sim_latency.m` | 0.068ms, 99.1%, break-even N=4 |
| §8.2 Bandwidth results | `simulation/results/novelty_proof_and_results.md` §3 M2, `simulation/sim_bandwidth.m` | 224 vs 408 bits, 184 bits, 45.1% |
| §8.3 Clock cycle results | `simulation/results/novelty_proof_and_results.md` §4 M3, `simulation/sim_energy.m`, `Draft/master_draft_COMPLETE.md` Fig. 7 | 74K vs 2.45M cycles, 33.1× |
| §9 Conclusion | `Validation and Fix/novelty_and_scopus_evaluation.md` §2.6, `simulation/results/novelty_proof_and_results.md` §conclusions | Core novelty claim statement |
| §9 Future Work (4 items) | `Validation and Fix/gap_resolution_proposals.md` Gap 6 | FPGA, PFS rotation, Kyber, OSCORE — SAKE-specific |
| §10 References | `Draft/master_draft_COMPLETE.md` §4 related work + RFC/NIST standards | [1]–[15] base list |
| Appendix A Values Concordance | `Draft/master_draft_COMPLETE.md` (all base paper values), `simulation/results/novelty_proof_and_results.md` | All 12 non-metric structural values with source trace |
| Appendix B Forensic Status | `Validation and Fix/final_forensic_revalidation.md`, `Validation and Fix/novelty_and_scopus_evaluation.md` | 14/14, 18/18 compliance table |
| Appendix C Cover Letter | `simulation/results/novelty_proof_and_results.md` §conclusions, `Validation and Fix/novelty_and_scopus_evaluation.md` | Novelty claim paragraph |
| Data Availability Statement | `Validation and Fix/gap_resolution_proposals.md` Gap 2 (template), all 7 simulation script filenames | Elsevier-format script listing + DOI |
| Author Contributions (CRediT) | `Validation and Fix/gap_resolution_proposals.md` Gap 3 | CRediT template |
| COI + Ethics | `Validation and Fix/gap_resolution_proposals.md` Gap 4 | Elsevier standard declarations |

---

### Paper File 2: `master_metrics_presentation_draft.md` (27,531 bytes)

**Role:** Exact wording, claims, disclaimers, and reviewer objection tables for all 6 metrics.

| Metric Section | Source File(s) Used | What Was Derived |
|---|---|---|
| M1 result table (0.068ms, 99.1%) | `simulation/results/novelty_proof_and_results.md` §M1 | All specific values |
| M1 "How to Interpret" | `Draft/session amortization draft.md` (Phase 2 design rationale), `Validation and Fix/metric1_latency_logical_validation.md` §4 | Causal interpretation — "removing amortization restores 7.37ms" |
| M1 exact paper claim | `simulation/results/novelty_proof_and_results.md` §M1, `Draft/master_draft_COMPLETE.md` Table 7 | 10,000 iteration tic/toc measurement wording |
| M1 Footnote 1 (HKDF RFC) | `Backup/metric1_fix_gemini.md` (methodology fix), RFC 5869 | HKDF 1-call justification, ×1.20 GHASH factor |
| M1 Reviewer objections | `Validation and Fix/metric1_latency_logical_validation.md` §5, `Backup/metric1_fix_gemini.md` | All 5 objection-response rows |
| M2 result table (408→224, 184 bits) | `simulation/results/novelty_proof_and_results.md` §M2, `Draft/master_draft_COMPLETE.md` §10.2 | Exact bit values |
| M2 "How to Interpret" | `Backup/metric2_fix_gemini.md` §1-2 | "N-independent deterministic saving" — conservative 45.1% framing |
| M2 exact paper claim | `simulation/results/novelty_proof_and_results.md` §M2, `Draft/master_draft_COMPLETE.md` §10.2, §12.1 | N=1000 → 22.5KB saving calculation |
| M2 Note (45.1% scoping) | `Backup/metric2_fix_gemini.md` Fix 3 | "applies to Tier 2 overhead only" disclaimer |
| M2 Reviewer objections | `Validation and Fix/metric2_bandwidth_logical_validation.md`, `Backup/metric2_fix_gemini.md` | 3 objection-response rows |
| M3 result table (74K vs 2.45M, 33.1×) | `simulation/results/novelty_proof_and_results.md` §M3, `Draft/master_draft_COMPLETE.md` Fig. 7 | Full comparison table with all 5 methods |
| M3 cycle decomposition (6K+68K) | `Backup/metric3_fix_gemini.md` Flaw 3, `simulation/sim_energy.m` | HKDF=6K, AES-GCM=68K — functional decomposition |
| M3 "How to Interpret" | `Validation and Fix/metric3_energy_logical_validation.md` §4, `Backup/metric3_fix_gemini.md` | "CPU duty cycle → sleep fraction → battery" chain |
| M3 exact paper claim | `simulation/results/novelty_proof_and_results.md` §M3, `Draft/master_draft_COMPLETE.md` Fig. 7 | "24×–33× conservative range" + Intel AES-NI citation |
| M3 platform note | `Backup/metric3_fix_gemini.md` Flaw 2 | Cross-platform Xilinx vs Intel caveat |
| M3 battery scope note | `Backup/metric3_fix_gemini.md` Flaw 1 | CPU-dominated IoT scope |
| M3 Reviewer objections | `Validation and Fix/metric3_energy_logical_validation.md` §5, `Backup/metric3_fix_gemini.md` | 4 objection-response rows |
| P1 result table (ε=0.0037) | `simulation/results/novelty_proof_and_results.md` §5 | All 4 test results |
| P1 "How to Interpret" | `Draft/novelty-security proof draft.md` §Proof 1, game description | IND-CCA2 conceptual explanation |
| P1 exact paper claim (Theorem) | `Draft/novelty-security proof draft.md` §Proof 1 game, `Draft/cryptographic_proof_review.md` Fix 1+3 | Full theorem + formal bound + proof sketch + MATLAB disclaimer |
| P1 simulation disclaimer | `Draft/cryptographic_proof_review.md` Fix 1 (verbatim) | "MATLAB validates architecture, not formal bound" |
| P1 Reviewer objections | `Validation and Fix/proof 1 limitation fix.md`, `Draft/cryptographic_proof_review.md` | 4 objection-response rows |
| P2 result table (Pr=0) | `simulation/results/novelty_proof_and_results.md` §6 | All 4 scenario results |
| P2 "How to Interpret" | `Draft/novelty-security proof draft.md` §Proof 2 | Deterministic vs probabilistic distinction |
| P2 exact paper claim (Theorem) | `Draft/novelty-security proof draft.md` §Proof 2 | Theorem + desync corollary wording |
| P2 Reviewer objections | `Draft/novelty-security proof draft.md` §Proof 2, `Validation and Fix/final_forensic_revalidation.md` | 3 objection-response rows |
| P3 result table | `simulation/results/novelty_proof_and_results.md` §7 | TEST 1–4 results including 10×10 fix |
| P3 "How to Interpret" | `Draft/novelty-security proof draft.md` §Proof 3, `Draft/cryptographic_proof_review.md` | Past vs future secrecy distinction |
| P3 exact paper claim (Theorem 3) | `Draft/novelty-security proof draft.md` §Proof 3, `Draft/master_draft_COMPLETE.md` §11.3 Theorem 2 Eq.23 | Full EB-FS theorem with Ring-LWE reduction |
| P3 implementation note | `Draft/cryptographic_proof_review.md` Fix 2 | memset_s / NIST SP 800-88 |
| P3 novelty statement | `Draft/master_draft_COMPLETE.md` §11 (confirms no FS in base paper) | "base paper [1] does not provide forward secrecy" |
| P3 Reviewer objections | `Validation and Fix/proof 3 limitation fix.md`, `Draft/cryptographic_proof_review.md` | 4 objection-response rows |
| Summary table (all 6 metrics) | All of the above | 6-row paper-ready claim table |

---

### Paper File 3: `base_paper_complete_reference.md` (18,351 bytes)

**Role:** Complete extraction of base paper content (algorithms, tables, FPGA values).

| Section | Source File(s) Used | What Was Derived |
|---|---|---|
| All 6 Algorithms (1–6) pseudocode | `Draft/master_draft_COMPLETE.md` §6.1–§8.3 | KG, SG, BernsMul, SV, QC-LDPC KeyGen, SLDSPA |
| LR-IoTA timing table | `Draft/master_draft_COMPLETE.md` Table 6 | Δ_KG=0.288, Δ_SG=13.299, Δ_V=0.735 ms |
| QC-LDPC timing | `Draft/master_draft_COMPLETE.md` Table 7 | Δ_KeyGen=0.8549, Δ_Enc=1.5298, Δ_Dec=5.8430 ms |
| FPGA hardware (Table 8) | `Draft/master_draft_COMPLETE.md` Table 8 | Slices, DSP blocks, Xilinx Virtex-6 |
| Fig. 7 clock cycle data | `Draft/master_draft_COMPLETE.md` Fig. 7 (text extraction) | Lizard=5.5M, RLizard=8.05M, LEDAkem=2.85M, HE=2.45M |
| Ring-LWE parameters | `Draft/master_draft_COMPLETE.md` §5 | n=512, σ=43, q=2²⁹−3, N=3 |
| QC-LDPC parameters | `Draft/master_draft_COMPLETE.md` §7, §10.2 | X=102, Y=204, CT₀=408 bits |
| Auth overhead (26,368 bits) | `Draft/master_draft_COMPLETE.md` §12.1 | pk_sig=14848, sig=11264, pk_HE=1224, CT₀=408 |
| Theorem 2 + Eq. 23 | `Draft/master_draft_COMPLETE.md` §11.3 | Ring-LWE hardness (EB-FS reduction anchor) |
| Attack models (§11.4) | `Draft/master_draft_COMPLETE.md` §11.4 | Replay, MITM, KCI, ESL — all preserved |
| Base paper DOI | `Draft/master_draft_COMPLETE.md` §cover | 10.1016/j.comnet.2022.109327 |

---

### Paper File 4: `sake_algorithm_full_specification.md` (18,986 bytes)

**Role:** Complete 4-phase SAKE protocol specification + formal Algorithm 7/8 pseudocode.

| Section | Source File(s) Used | What Was Derived |
|---|---|---|
| Overview (4-phase structure) | `Draft/session amortization draft.md` §Overview | Tier 1 / Tier 2 architecture, phase naming |
| Phase 1 Step 1.1 (LR-IoTA) | `Draft/session amortization draft.md` §Phase 1.1, `Draft/master_draft_COMPLETE.md` Algorithms 1–4 | Authentication steps, timing |
| Phase 1 Step 1.2 (QC-LDPC KEP) | `Draft/session amortization draft.md` §Phase 1.2 v3 | RECEIVER generates keys (v3 correction), ẽ generation, CT₀, MS=HMAC-SHA256(ẽ) |
| Phase 1 timing values | `Draft/master_draft_COMPLETE.md` Tables 6 and 7 | Δ_KG, Δ_SG, Δ_V, Δ_Enc, Δ_Dec exact ms values |
| Step 1.3 State Init (T_max, N_max) | `Draft/session amortization draft.md` §Phase 1.3 | T_max=86400, N_max=2²⁰, Ctr_Tx=Ctr_Rx=0, AD format |
| Phase 2 Steps 2.1–2.5 | `Draft/session amortization draft.md` §Phase 2 | Full Sender loop: epoch check, nonce, HKDF, AES-GCM, transmit |
| Phase 2 nonce format | `Draft/novelty-security proof draft.md` §Proof 1 architecture | 96-bit nonce: [32-bit zero ∣ 64-bit Ctr_Tx] |
| Phase 2 AD binding | `Draft/novelty-security proof draft.md` §Proof 1 | AD = DeviceID ∥ EpochID ∥ Nonce_i — cross-session binding |
| Phase 3 Steps 3.1–3.4 | `Draft/session amortization draft.md` §Phase 3 | Receiver loop: replay check, HKDF, MAC-before-decrypt, state update |
| Phase 4 zeroization | `Draft/session amortization draft.md` §Phase 4 | zeros(1,32,'uint8'); clear MS, Ctr_Tx, Ctr_Rx |
| Phase 4 hardware note | `Draft/cryptographic_proof_review.md` Fix 2 | memset_s / NIST SP 800-88 |
| Break-even analysis table | `simulation/results/novelty_proof_and_results.md` §break-even | N=1,2,3,4,50,100 cost comparison |
| v3 Corrections log | `Draft/session amortization draft.md` (v3 header notes) | All 4 role/function/format corrections |
| Algorithm 7 pseudocode | `Validation and Fix/gap_resolution_proposals.md` Gap 7 + `Draft/session amortization draft.md` | Sender 9-line algorithm box |
| Algorithm 8 pseudocode | `Validation and Fix/gap_resolution_proposals.md` Gap 7 + `Draft/session amortization draft.md` | Receiver 10-line algorithm box |
| ZeroizeAndRenew | `Validation and Fix/gap_resolution_proposals.md` Gap 7 + `Draft/session amortization draft.md` §Phase 4 | 3-line Phase 4 procedure |

---

### Paper File 5: `security_proof_requirements_and_review.md` (18,976 bytes)

**Role:** Complete proof game specifications, theorems, proof sketches, mandatory fixes, publication checklist.

| Section | Source File(s) Used | What Was Derived |
|---|---|---|
| Proof architecture table | `Draft/novelty-security proof draft.md` §Part 1, §Part 2 | 7-row architecture → security property mapping |
| IND-CCA2 game (Part 2) | `Draft/novelty-security proof draft.md` §Proof 1 | Full adversary oracle game (Setup, Challenge Phase, Win condition) |
| IND-CCA2 Theorem 1 + bound | `Draft/novelty-security proof draft.md` §Proof 1, `Draft/cryptographic_proof_review.md` Fix 3 | Adv_IND-CCA2 ≤ Adv_PRF + Adv_PRP + (N_max×q_D)/2¹²⁸ |
| IND-CCA2 proof sketch | `Draft/cryptographic_proof_review.md` Fix 3 (full reduction text) | PPT simulator B construction |
| IND-CCA2 MATLAB disclaimer | `Draft/cryptographic_proof_review.md` Fix 1 (verbatim) | "MATLAB validates architecture..." |
| IND-CCA2 MATLAB test descriptions | `simulation/results/novelty_proof_and_results.md` §5 | TEST 1a/2/3 exact output |
| Replay proof game (Part 3) | `Draft/novelty-security proof draft.md` §Proof 2 | Adversary records+replays, win condition |
| Replay Theorem 2 | `Draft/novelty-security proof draft.md` §Proof 2 | Pr=0 deterministic proof — no PPT needed |
| Replay novelty vs base | `Draft/master_draft_COMPLETE.md` §11.4 (Y_n random ref) | Base probabilistic vs SAKE deterministic |
| Replay MATLAB tests | `simulation/results/novelty_proof_and_results.md` §6 | 4 scenarios with exact counts |
| EB-FS game (Part 4) | `Draft/novelty-security proof draft.md` §Proof 3 | Physical compromise game, past+future secrecy |
| EB-FS Theorem 3 | `Draft/novelty-security proof draft.md` §Proof 3, `Draft/master_draft_COMPLETE.md` Theorem 2 Eq.23 | Full theorem with Ring-LWE reduction paths |
| EB-FS hardware scope note | `Draft/cryptographic_proof_review.md` Fix 2 | memset_s / NIST SP 800-88 |
| EB-FS novelty vs base | `Draft/master_draft_COMPLETE.md` §11 | "base paper provides no FS" |
| EB-FS fix applied (10×10) | `Validation and Fix/final_forensic_revalidation.md` NEW ISSUE A | Full cross-epoch comparison code |
| Proof review Fix 1, 2, 3 | `Draft/cryptographic_proof_review.md` (all 3 fixes verbatim) | 3 mandatory publication fixes |
| Publication checklist | `Draft/cryptographic_proof_review.md` (closing checklist) | 10-item reviewer verification table |
| Expected results table | `Draft/novelty-security proof draft.md` §Part 3 | 3 prescribed result targets vs achieved |
| TLS/DTLS differentiation table | `simulation/results/novelty_proof_and_results.md` §3.4, `Draft/cryptographic_proof_review.md` Fix 3 | 9-column comparison table |

---

### Paper File 6: `simulation_results_record.md` (16,775 bytes)

**Role:** Full MATLAB output record — all test results, exact values, conclusions.

| Section | Source File(s) Used | What Was Derived |
|---|---|---|
| Protocol as modelled (Phase 1–4) | `simulation/results/novelty_proof_and_results.md` §2 (full) | All 4-phase steps as implemented in scripts |
| M1 results table | `simulation/results/novelty_proof_and_results.md` §M1, `simulation/sim_latency.m` (script logic) | 0.062–0.068ms range, break-even table |
| M1 HKDF RFC compliance note | `Backup/metric1_fix_gemini.md`, RFC 5869 §2.3 | 1-call vs 2-call HKDF clarification |
| M2 results table | `simulation/results/novelty_proof_and_results.md` §M2, `simulation/sim_bandwidth.m` | 408 vs 224 bits, 184-bit saving |
| M3 results table | `simulation/results/novelty_proof_and_results.md` §M3, `Draft/master_draft_COMPLETE.md` Fig. 7 | All 5-method clock cycle comparison |
| M3 battery caveat | `Backup/metric3_fix_gemini.md` Flaw 1 | CPU scope limitation |
| P1 test-by-test results | `simulation/results/novelty_proof_and_results.md` §5, `simulation/proof1_ind_cca2.m` | TEST 1a (1K keys), TEST 2 (500K queries), TEST 3 (10K MAC) |
| P1 XOR justification | `Draft/cryptographic_proof_review.md` + `Validation and Fix/final_forensic_revalidation.md` NEW ISSUE D | "XOR with pseudorandom key = OTP = stronger than AES-GCM" |
| P2 test-by-test results | `simulation/results/novelty_proof_and_results.md` §6, `simulation/proof2_replay.m` | 4 scenarios, all exact counts |
| P3 test-by-test results | `simulation/results/novelty_proof_and_results.md` §7, `simulation/proof3_forward_secrecy.m` | 10×10 fix, TEST 1–4 |
| P3 code fix shown | `Validation and Fix/final_forensic_revalidation.md` NEW ISSUE A | OLD vs NEW code snippet |
| TLS/DTLS table | `simulation/results/novelty_proof_and_results.md` §3.4 | 9-row protocol comparison |
| 6-metric summary table | `simulation/results/novelty_proof_and_results.md` §conclusions | All 6 metrics, targets vs achieved |
| Conclusions paragraph | `simulation/results/novelty_proof_and_results.md` §conclusions (verbatim) | 5-point novelty summary |

---

### Paper File 7: `validation_and_scopus_reports.md` (13,846 bytes)

**Role:** Final forensic verdict and Scopus acceptance assessment.

| Section | Source File(s) Used | What Was Derived |
|---|---|---|
| 8 Original Issues Resolved Table | `Validation and Fix/final_forensic_revalidation.md` §Part 1 | All 8 issues: was → now → status |
| 5 New Issues Addressed Table | `Validation and Fix/final_forensic_revalidation.md` §Part 2 (NEW ISSUES A–E) | All 5 new findings and resolutions |
| Final Verdict Per Metric | `Validation and Fix/final_forensic_revalidation.md` §Part 3 | M1–P3 individual verdicts |
| Overall Scopus Assessment | `Validation and Fix/final_forensic_revalidation.md` §Part 4 | 9-item rejection ground elimination table |
| Algorithm Compliance (14/14) | `Validation and Fix/novelty_and_scopus_evaluation.md` §2.1 | All 14 algorithm requirements |
| Proof Compliance (18/18) | `Validation and Fix/novelty_and_scopus_evaluation.md` §2.2 | P1 (7), P2 (5), P3 (6) requirements |
| Expected Results (3/3) | `Validation and Fix/novelty_and_scopus_evaluation.md` §2.3 | Draft targets vs achieved |
| Base Paper Value Compliance (9/9) | `Validation and Fix/novelty_and_scopus_evaluation.md` §2.4, `Draft/master_draft_COMPLETE.md` | All 9 base paper values verified |
| Logical Invalidity Assessment | `Validation and Fix/novelty_and_scopus_evaluation.md` §2.5 | All algorithm, metric, proof cross-checks |
| Metrics Sufficiency | `Validation and Fix/novelty_sufficiency_validation.md` §1, §2 | "3 metrics + 3 proofs sufficient" conclusion |
| Final Novelty + Scopus Verdict | `Validation and Fix/novelty_and_scopus_evaluation.md` §2.7 | 7-item proof of claim table |

---

### Paper File 8: `reference_list.md` (13,058 bytes)

**Role:** Complete 25-reference bibliography with BibTeX entries.

| References | Source File(s) Used | What Was Derived |
|---|---|---|
| [1] Base paper | `Draft/master_draft_COMPLETE.md` (title, authors, year, journal, DOI) | Exact Kumari et al. citation |
| [2] RFC 5869 | Used in `sim_latency.m`, `Draft/novelty-security proof draft.md` §Proof 1 HKDF | RFC details + BibTeX |
| [3] RFC 2104 | `Draft/master_draft_COMPLETE.md` §8.4 "SHA in MAC-mode" | HMAC standard |
| [4] RFC 8446 | `simulation/results/novelty_proof_and_results.md` §3.4 TLS 1.3 | TLS 1.3 standard |
| [5] RFC 9147 | `simulation/results/novelty_proof_and_results.md` §3.4 DTLS 1.3 | DTLS 1.3 standard |
| [6] RFC 8613 | `paper_master_reference_draft.md` §9 Future Work item 4 | OSCORE standard |
| [7] NIST SP 800-38D | `Draft/novelty-security proof draft.md` §Proof 1 architecture, `simulation/sim_bandwidth.m` | AES-GCM standard |
| [8] NIST SP 800-88 | `Draft/cryptographic_proof_review.md` Fix 2 | Secure memory erasure |
| [9] FIPS 203 | `paper_master_reference_draft.md` §9 Future Work item 3 | CRYSTALS-Kyber standard |
| [10] Regev 2009 | `Draft/master_draft_COMPLETE.md` §5 LWE definition | LWE foundational paper |
| [11] Lyubashevsky 2013 | `Draft/master_draft_COMPLETE.md` §5.5 refs [41,42] | Ring-LWE foundational paper |
| [12] Peikert 2009 | `Draft/master_draft_COMPLETE.md` §5 lattice hardness | Worst-case LWE reduction |
| [13] Gallager 1962 | `Draft/master_draft_COMPLETE.md` §7 LDPC | LDPC foundational paper |
| [14] Baldi 2016 | `Draft/master_draft_COMPLETE.md` §7 QC-LDPC security | QC-LDPC McEliece |
| [15]–[16] IoT surveys | `Draft/master_draft_COMPLETE.md` §1 motivation references | IoT survey papers |
| [17]–[23] Base paper refs | `Draft/master_draft_COMPLETE.md` §4 related work [30,40,39,24,29,37,38] | Related works cited by base paper |
| [24]–[25] Bellare & Rogaway | `Draft/novelty-security proof draft.md` §Part 2 ROM model | IND-CCA2 game + ROM justification |

---

### Paper File 9: `figures_description.md` (9,305 bytes)

**Role:** Complete figure specifications for all 4 paper figures.

| Figure | Source File(s) Used | What Was Derived |
|---|---|---|
| Fig. 1 — Latency line graph | `simulation/results/sim_latency.png` (visual), `simulation/results/novelty_proof_and_results.md` §M1 | Series formulas: y=7.3728×N vs y=22.55+0.068×N; break-even N=4 |
| Fig. 1 caption | `Draft/novelty-security proof draft.md` §"Expected Simulation Results", `simulation/results/novelty_proof_and_results.md` | Caption text with all values |
| Fig. 2 — Bandwidth bars | `simulation/results/sim_bandwidth_bar.png` (visual), `simulation/results/novelty_proof_and_results.md` §M2 | Bar values: 408 vs 224 bits; Tier 1 identical at 26,368 bits |
| Fig. 2 annotation | `Backup/metric2_fix_gemini.md` Fix 2 | "Epoch-level authentication overhead...not shown" note |
| Fig. 3 — Clock cycles | `simulation/results/sim_energy.png` (visual), `Draft/master_draft_COMPLETE.md` Fig. 7 | All 5 methods with Enc+Dec bars; extends base paper Fig. 7 |
| Fig. 3 SAKE bar decomposition | `Backup/metric3_fix_gemini.md` Flaw 3 | Sender=40K, Receiver=40K — cryptographic justification |
| Fig. 4 — Amortized curve | `simulation/results/novelty_proof_and_results.md` §M1 (formula) | y=(22.55+0.068×N)/N asymptote curve |
| Fig. 5 — Security table | `simulation/results/novelty_proof_and_results.md` §3.4 | 9-row TLS/DTLS/SAKE comparison table |
| All MATLAB export commands | `simulation/sim_latency.m`, `sim_bandwidth.m`, `sim_energy.m` (script names) | `print(gcf, 'figX', '-depsc')` commands |

---

## PART 3 — SOURCE FILE USAGE FREQUENCY

Files used most extensively across all Paper folder files:

| Source File | Used In (Paper Files) | Key Contributions |
|---|---|---|
| `Draft/master_draft_COMPLETE.md` | ALL 9 | Base algorithms, all timing tables, Fig. 7, Theorem 2, Ring-LWE params, auth overhead |
| `simulation/results/novelty_proof_and_results.md` | ALL 9 | All 6 metric values, all proof results, TLS comparison, conclusions |
| `Draft/novelty-security proof draft.md` | 7/9 | All 3 proof games, expected results, ROM framework |
| `Draft/cryptographic_proof_review.md` | 6/9 | All 3 mandatory fixes (MATLAB disclaimer, memset_s, TLS differentiation) |
| `Draft/session amortization draft.md` | 5/9 | Complete 4-phase protocol, v3 corrections, timing |
| `Validation and Fix/final_forensic_revalidation.md` | 4/9 | 8+5 issue resolutions, per-metric verdicts |
| `Validation and Fix/novelty_and_scopus_evaluation.md` | 4/9 | 14/14, 18/18, Scopus readiness tables |
| `Backup/metric1_fix_gemini.md` | 2/9 | tic/toc fix rationale, HKDF 1-call justification |
| `Backup/metric2_fix_gemini.md` | 2/9 | Conservative baseline, 45.1% scoping |
| `Backup/metric3_fix_gemini.md` | 2/9 | Flaw 3 (50/50 split), battery scope |
| `Validation and Fix/metric1_latency_logical_validation.md` | 2/9 | M1 objections and flaws |
| `Validation and Fix/novelty_sufficiency_validation.md` | 2/9 | Sufficiency conclusion |

**Files NOT used in Paper folder (excluded):**
- `Backup/master_draft_part1/2/3.md` — superseded by `master_draft_COMPLETE.md`
- `Backup/gemini_vs_committed_comparison.md` — version control comparison, not content source
- `Backup/gap_fixes_complete_report.md.resolved` — archival, superseded by validation reports
- `pdf_output.txt` / `pdf_output_utf8.txt` — PDF extraction used for text lookup only; all values ultimately traced back to `master_draft_COMPLETE.md`
- `simulation/results/proof_results.txt` — raw terminal log; processed content is in `novelty_proof_and_results.md`
- `session amortization draft.md` (root) — duplicate of `Draft/session amortization draft.md`; `Draft/` version used

---

*Report generated: 2026-03-03 | Working directory: `C:\Users\aloob\Downloads\Research Backup`*
*All source file sizes confirmed by live directory listing.*
