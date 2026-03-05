# Post-Fix Forensic Re-Verification Report — SAKE-IoT
## Scope: latex_content.tex (1,204 lines) after all 20 gap fixes
## Baselines: master_draft_COMPLETE.md + all novelty drafts + master_metrics_presentation_draft.md + Images folder
## Date: 2026-03-04

---

## SECTION-BY-SECTION FORENSIC AUDIT

### §1 — Introduction ✅
| Check | Status |
|---|---|
| Problem context (per-packet QC-LDPC cost on Class-1 IoT) | ✅ |
| The Amortization Gap subsection | ✅ |
| 5 key contributions listed with exact numbers | ✅ |
| EB-FS named as absent from base paper | ✅ |
| All 3 metric values in abstract (99.1%, 45.1%, 33.1×) | ✅ |
| Security results in abstract (ε=0.0037, Pr=0, 0/100) | ✅ |

### §2 — Related Work ✅
| Check | Status |
|---|---|
| Lattice-Based IoT Auth survey | ✅ |
| Code-Based encryption survey | ✅ |
| Session management survey | ✅ |
| TLS 1.3 / DTLS 1.3 differentiation table | ✅ |

**⚠️ Minor finding:** The TLS comparison table shows "Per-packet overhead: ~100 bits" for TLS/DTLS and "224 bits" for SAKE. This could raise a reviewer objection — it appears SAKE has MORE overhead than TLS per-packet. The paper should clarify that the 224-bit SAKE overhead **includes AES-GCM's MAC tag** providing authentication, whereas TLS's ~100 bits is for session-layer framing only (authentication is separate). Add a table footnote.

### §3 — Preliminaries ✅
| Check | Status |
|---|---|
| Notation table with all 12 symbols | ✅ |
| Lattice Λ formal definition | ✅ |
| Search-LWE and Decisional-LWE defined | ✅ |
| Ring-LWE with exact parameters (n=512, q=2²⁹-3, σ=43) | ✅ |
| QC-LDPC X=408, Y=816, row weight=6, col weight=3 | ✅ |
| HKDF-SHA256 two-phase mechanics (Extract+Expand) | ✅ |
| AES-256-GCM 96-bit nonce, 128-bit GHASH tag | ✅ |

**⚠️ Minor finding:** Lattice definition `Λ = { a_1β_1 + ... }` lacks the dimension parameter `j` (i.e., Λ ⊂ ℝʲ). The prose says "discrete additive subgroup" without stating the ambient space R^j. For a Scopus paper the lattice should be defined as Λ ⊂ ℤʲ. Currently one line — it is technically sufficient but marginally informal.

### §4 — System and Adversary Model ✅
| Check | Status |
|---|---|
| IoT network topology (Tier 1 gateway, Tier 2 sensors) | ✅ |
| Dolev-Yao adversary model | ✅ |
| Epoch lifecycle with Nmax/Tmax bounds | ✅ |
| Formal adversary capability definition | ✅ |

### §5 — Base Protocol ✅
| Check | Status |
|---|---|
| LR-IoTA (Alg 1–4) timing table (0.288 + 13.299 + 0.735 = 14.322 ms) | ✅ |
| Bernstein Polynomial Reconstruction subsection | ✅ |
| Bernstein: 72 Slices/LUTs, 0.811 ms, 23% improvement | ✅ |
| QC-LDPC KEP (Alg 5–6) timing table | ✅ |
| Δ_KeyGen excluded from per-packet cost — justified | ✅ |
| DEP explanation (what SAKE eliminates) | ✅ |
| Base paper bandwidth overhead table (408 bits CT₀) | ✅ |

### §6 — SAKE-IoT Protocol ✅
| Check | Status |
|---|---|
| Protocol flow TikZ diagram (Figure 4) | ✅ |
| Critical distinction prose (MS stored vs ssk discarded) | ✅ |
| Phase 1 Step 1.1/1.2/1.3 numbered steps | ✅ |
| RECEIVER role in KEP (v3 correction applied) | ✅ |
| AES-GCM nonce format [32-bit zero \| 64-bit Ctr_Tx] | ✅ |
| Nonce uniqueness guarantee statement | ✅ |
| Algorithm 7 — SAKE-Tier2-Sender (9 lines) | ✅ |
| Algorithm 8 — SAKE-Tier2-Receiver (10 lines) | ✅ |
| GHASH TAG recomputation detail | ✅ |
| Receiver cost ~0.038 ms stated | ✅ |
| Protocol Correctness table | ✅ |
| ZeroizeAndRenew Phase 4 procedure | ✅ |
| memset_s() hardware note | ✅ |

**⚠️ Minor finding:** Figure 4 (TikZ protocol diagram) references `\Kmaster` via the custom command `\Kmaster` — but the TikZ box labels use `K_{\mathrm{master}}` inline. Both resolve to the same symbol but the custom command `\Kmaster` defined in the preamble should be used consistently. Low risk for Scopus — cosmetic.

### §7 — Security Analysis ✅
| Check | Status |
|---|---|
| ROM security model stated | ✅ |
| Lemma 1 / G0-G1 game referenced | ✅ |
| findSearchLWE equation (Ring-LWE hardness) | ✅ |
| Proof Architecture table (7 features) | ✅ |
| Theorem 1 (IND-CCA2): ε=0.0037 < 0.02 | ✅ |
| Theorem 2 (Replay): Pr=0 exact, deterministic | ✅ |
| Theorem 2 corollary (desynchronization safety) | ✅ |
| Replay Resistance comparison table (negl(λ) vs Pr=0) | ✅ |
| Theorem 3 (EB-FS): Part A future secrecy | ✅ |
| Theorem 3 (EB-FS): Part B past secrecy — HMAC inversion | ✅ |
| Theorem 3 (EB-FS): Part C Ring-LWE reduction | ✅ |
| MATLAB simulation validation cited for each proof | ✅ |
| "EB-FS absent from base paper" stated explicitly | ✅ |

### §8 — Performance Evaluation ✅
| Check | Status |
|---|---|
| Simulation setup (MATLAB R2023b, Intel Core i5, 8GB) | ✅ |
| Break-even algebraic derivation equation | ✅ |
| N=1,2,3 rows showing SAKE costs MORE early | ✅ |
| N=4 break-even row highlighted | ✅ |
| N=50, N=100 cumulative savings | ✅ |
| HKDF=0.021ms, AES-GCM=0.047ms decomposition | ✅ |
| Receiver cost 0.038ms | ✅ |
| Figure 1 (latency) with caption | ✅ |
| Figure ref (fig:latency) in text | ✅ |
| M2: 184 bits / 45.1% saving + equation | ✅ |
| M2: 86.3% conservative upper bound stated | ✅ |
| Figure 2 (bandwidth) with caption | ✅ |
| Cross-scheme comparison table (Shim/Mundhe/HAN baseline) | ✅ |
| 108× speedup vs nearest competitor | ✅ |
| M3: Tab. clock cycles (Lizard/RLizard/LEDAkem/Base/SAKE) | ✅ |
| M3: HKDF=6,000 cycles / AES-GCM=68,000 cycles stated | ✅ |
| M3: 33.1× reduction, conservative range 24×–33× | ✅ |
| M3: Figure 3 (energy) with caption | ✅ |
| M3: FPGA 64 slices / 640 slices baseline cited | ✅ |
| Battery scope caveat (CPU-dominated only) | ✅ |
| Six-Metric Summary table (M1–M3, P1–P3) | ✅ |

---

## MASTER_METRICS_PRESENTATION_DRAFT.MD — COMPLIANCE

**27 of 27 claims verified: ALL PASS ✅**

---

## IMAGES FOLDER — ASSESSMENT

The `Draft/Images/` folder contains **15 files** that are base paper figures (fig3–7.jpg, img8–img12.jpg, table 3–4.jpg, optional 1–2.jpg). Here is the assessment of which are relevant to include in the SAKE-IoT paper:

| File | Base Paper Content | Include in SAKE Paper? | Reason |
|---|---|---|---|
| `fig3.jpg` | Overall proposed scheme architecture (base paper Fig. 3) | ⚠️ Optional | Could be included in §5 as "Base paper system model (reproduced)" |
| `fig4.jpg` | Complete flow diagram (protocol flow, base paper Fig. 4) | ❌ Replaced | SAKE-IoT has its own TikZ flow diagram (Fig. 4 new) |
| `fig5.jpg` | Attack detection graph (§11.5) | ❌ Not needed | Attack model is textual in §7 — figure not part of novelty |
| `fig6.jpg` | Authentication delay comparison (base paper Fig. 6) | ⚠️ Optional | Could be cited in §8 cross-scheme table as supplementary |
| `fig7.jpg` | Clock cycles comparison (base paper Fig. 7) | ✅ Recommended | Our Fig. 3 explicitly **extends** base paper Fig. 7 — citing this directly strengthens the claim and shows continuity |
| `img8.jpg` | SLDSPA equations (Section 4.2) | ❌ Not needed | Algorithm 6 pseudocode in paper already covers this |
| `img9.jpg` | Equations 7, 8 | ❌ Not needed | Already cited via \cite{kumari2022} |
| `img10 part 1/2.jpg` | Encrypted section equations | ❌ Not needed | Derived values already in tables |
| `img11.jpg` | Security parameter bounds | ⚠️ Optional | Supports Theorem 3 bounds — add as informal citation |
| `img12.jpg` | Game G1 (ROM proof) | ✅ Recommended | Directly supports the G0-G1 Lemma 1 we added — could include as inline equation image |
| `table 3.jpg` | Polynomial multiplication hardware comparison | ✅ Recommended | Our Bernstein §5.1 cites this table — include as Table with caption "reproduced from [1]" |
| `table 4.jpg` | Comparative Ring-LWE hardware table | ✅ Recommended | Our cross-scheme table §8 already replicates this content — cite it |
| `optional 1.jpg` | Optional supplementary | ❌ Skip | Not needed for main paper |
| `optional 2.jpg` | Optional supplementary | ❌ Skip | Not needed for main paper |

**4 base paper images are recommended for inclusion: fig7.jpg, img12.jpg, table 3.jpg, table 4.jpg**

---

## REMAINING GAPS (Post all fixes applied)

### 🟡 MINOR (do not block acceptance but improve rigor)

| # | Gap | Location | Fix |
|---|---|---|---|
| R1 | TLS/DTLS overhead table shows SAKE at 224 bits > TLS's ~100 bits — needs footnote clarifying "auth+framing vs. pure framing" | §2 TLS table | Add 1-line table footnote |
| R2 | Lattice definition missing ambient dimension j (Λ ⊂ ℤʲ) | §3.2.1 | Cosmetic — add " ⊂ ℤʲ" |
| R3 | Base paper Fig. 7 (fig7.jpg): our paper says "extends Fig. 7" but never shows the original side-by-side or references the image file | §8.4 | Cite `fig7.jpg` as \includegraphics or add caption note |
| R4 | Table 3.jpg (polynomial hardware comparison) is referenced in our Bernstein §5.1 but image not included | §5.1 | Add `\includegraphics{../../Draft/Images/table 3}` or reproduce values |
| R5 | img12.jpg (Game G1) directly supports the Lemma 1 we cited — not shown | §7 | Optional: include as reference image |
| R6 | IND-CCA2 adversary advantage formula bound: ε = ε_KDF + ε_GCM is written but individual bounds ε_KDF and ε_GCM not numerically evaluated | §7.1 | Add: "where ε_KDF ≈ 2^{-128} (HMAC-PRF) and ε_GCM ≤ q_D/2^{128}" |
| R7 | §8 M2 has no Figure ref (`Figure~\ref{fig:bandwidth}`) in text body before the equation | §8.2 | Add "as shown in Figure~\ref{fig:bandwidth}" before or after equation |
| R8 | Conclusion lacks explicit "future work" sentence on FPGA synthesis of SAKE Tier 2 | §9 | Add 1 sentence on FPGA synthesis as future work |

### 🔴 CRITICAL (none remaining)
All 4 previously critical gaps are resolved.

---

## NOVELTY COMPLETENESS SCORE

| Novelty Dimension | Status |
|---|---|
| Two-tier epoch architecture | ✅ Complete |
| Master Secret persistence (vs base paper ssk discard) | ✅ Complete + explicit |
| HKDF-SHA256 per-packet key derivation | ✅ Complete |
| AES-256-GCM with MAC-before-decrypt | ✅ Complete |
| Strict monotonic counter (Pr=0 replay) | ✅ Complete |
| AES-GCM nonce format [32-bit zero \| 64-bit Ctr] | ✅ Complete |
| Epoch-Bounded Forward Secrecy (new property) | ✅ Complete |
| Phase 4 cryptographic zeroization | ✅ Complete |
| AD = DeviceID ∥ EpochID ∥ Nonce_i binding | ✅ Complete |
| QC-LDPC role correction (RECEIVER generates keys) | ✅ Complete |
| Break-even N=4 algebraic derivation | ✅ Complete |
| Formal security proofs (3 theorems) | ✅ Complete |
| Base paper Fig. 7 extension with SAKE bar | ✅ In paper |
| MATLAB validation for all 3 proofs + 3 metrics | ✅ Complete |

**Novelty completeness: 14/14 dimensions covered.**

---

## FINAL VERDICT

| Category | Score | Status |
|---|---|---|
| Core novelty representation | 14/14 | ✅ Complete |
| Master metrics compliance | 27/27 | ✅ Complete |
| Critical gaps | 0 | ✅ None remaining |
| Minor gaps | 8 (R1–R8) | ⚠️ Cosmetic improvements |
| Images integrated (simulation) | 3 of 3 (+ TikZ) | ✅ Complete |
| Base paper images from Images folder | 0 of 4 recommended ones | ⚠️ Optional additions |
| All mandatory Scopus statements | 4/4 | ✅ Complete |

**The paper is submission-ready for Scopus-indexed journals/conferences. The 8 remaining items are cosmetic improvements that strengthen rigor but do not constitute blockers. R7 (missing Figure~\ref{fig:bandwidth} cross-ref text) is the most important of the eight.**

---
*Generated: 2026-03-04 | Source: latex_content.tex (1,204 lines)*
