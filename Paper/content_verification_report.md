# SAKE-IoT — Dual-Baseline Content Verification Report
## Baseline 1: Base Paper (master_draft_COMPLETE.md)
## Baseline 2: All Novelty Drafts (session amortization draft v3, sake_algorithm_full_specification.md, novelty-security proof draft.md)
## Date: 2026-03-04

> **What changed from previous report:** Re-analyzed against BOTH baselines — the base paper
> AND all novelty draft files. The novelty drafts specify precise requirements for the paper's
> novel contributions. Any deviation of the generated paper from these specs is a gap.

---

## VERIFICATION MATRIX — NOVELTY DRAFT REQUIREMENTS vs. PAPER CONTENT

The following table maps every explicit requirement from the novelty drafts to whether it is correctly present in `latex_content.tex`.

### A. From `session amortization draft.md` (v3, 4 corrections)

| Requirement from Draft | Present in Paper? | Fidelity |
|---|---|---|
| Phase 1: LR-IoTA runs Algorithms 1–4, unchanged | ✅ §5, §6.2 | Correct |
| Phase 1: RECEIVER generates QC-LDPC keys (v3 correction) | ✅ §6.2 Step 1.2 | Correct |
| Phase 1: SENDER generates ẽ → CT₀ | ✅ §6.2 | Correct |
| MS = HMAC-SHA256(ẽ) — "SHA in MAC-mode" (v3 correction) | ✅ §6.2 Step 1.2 | Correct |
| AES-GCM 96-bit nonce = [32-bit zero | 64-bit Ctr_Tx] (v3 correction) | ⚠️ §6 | Mentioned but nonce format **not stated in the LaTeX §6 text** |
| AD = DeviceID ∥ EpochID ∥ Nonce_i | ✅ Algorithm 7 | Present in algorithm, absent in prose |
| Phase 2: Epoch validity check BEFORE nonce generation | ✅ Algorithm 7 line 1 | Correct |
| Phase 2: Ctr_Tx increments BEFORE Nonce_i assignment | ✅ Algorithm 7 lines 5–6 | Correct |
| Phase 3: Drop BEFORE MAC check — Nonce check is FIRST | ✅ Algorithm 8 line 1 | Correct |
| Phase 3: Ctr_Rx updated ONLY after success | ✅ Algorithm 8 line 9 | Correct |
| Phase 4: MATLAB-specific zeroization: zeros(1,32,'uint8'); clear MS | ⚠️ §6.5 | Protocol-level described; **MATLAB code not shown in §6.5** |
| Novel distinction: MS stored for epoch vs base paper one-time ssk | ⚠️ §6.1 | Stated but **the distinction "stores vs discards" phrasing not explicit** |
| Break-even N=4 with algebraic table | ⚠️ §8.2 | Value stated; derivation missing |
| Per-packet SAKE cost: 0.068 ms | ✅ §8.2 | Correct |
| Bandwidth saving: 184 bits (45.1%) | ✅ §8.3 | Correct |

---

### B. From `sake_algorithm_full_specification.md` (449 lines, Alg 7/8 canonical spec)

| Requirement | Present in Paper? | Fidelity |
|---|---|---|
| Algorithm 7 pseudocode — 9 lines, exact structure | ✅ §6.3 | ✅ MATCH — all 9 lines present |
| Algorithm 8 pseudocode — 10 lines, exact structure | ✅ §6.4 | ✅ MATCH — all 10 lines present |
| ZeroizeAndRenew 3-step procedure | ✅ §6.5 | ✅ MATCH |
| Algorithm numbering: 1–6 = base paper, 7–8 = this work | ✅ §6.6 table | ✅ Present |
| Break-even table (N=1 to N=100, both cost columns) | ⚠️ §8.2 | Table present but misses N=1,2,3 rows showing SAKE costs MORE early |
| "No two packets share a nonce" — nonce uniqueness statement | ⚠️ §6 prose | Not explicitly stated as a uniqueness guarantee in prose |
| Correctness proof: HKDF deterministic → Receiver derives same SK_i | ⚠️ §7 | Implied but not stated as a **Protocol Correctness** property |
| TAG recomputation description: TAG' = GHASH(SK_i, CT, AD) | ⚠️ §6.4 |  Not in paper — only "MAC before decrypt" stated; GHASH detail missing |
| Phase 3 receiver cost: ~0.038 ms/packet | ❌ Missing | Paper only states sender-side cost 0.068 ms; receiver cost never stated |
| v3 Corrections log referenced | ⚠️ Not needed | Corrections are applied — log itself need not appear |
| CT₀ = 408 bits explicitly linked to X=408 (row dimension) | ❌ Missing | Paper states X=102 (wrong — GAP 1 from previous report) |

---

### C. From `novelty-security proof draft.md` (84 lines — 3 proofs required)

| Requirement | Present in Paper? | Fidelity |
|---|---|---|
| **Proof 1 (IND-CCA2):** Decryption oracle returns ⊥ for any altered CT | ✅ Theorem 1 proof | Correct |
| **Proof 1:** Advantage bounded by negl(λ) via AES-PRP + HKDF-PRF reduction | ✅ Theorem 1 equation | Correct |
| **Proof 1:** MATLAB simulation validates MAC-before-decrypt property | ✅ §7.2 disclaimer | Correct |
| **Proof 2 (Replay):** Pr=0 (exact, not negligible) | ✅ Theorem 2 | Correct |
| **Proof 2:** Receiver counter check = FIRST action before MAC | ✅ Algorithm 8 line 1 + Theorem 2 | Correct |
| **Proof 2:** Desynchronization safety (counter self-heals) | ✅ §7.3 corollary | Correct |
| **Proof 3 (EB-FS):** Past secrecy — zeroization + HMAC inversion = both infeasible | ✅ Theorem 3 parts A, B | Correct |
| **Proof 3:** Future secrecy — MS_k cannot predict Epoch (k+1) keys | ✅ Theorem 3 | Correct |
| **Proof 3:** Fresh ẽ_{k+1} from Ring-LWE underpins future secrecy | ✅ Theorem 3 Part C | Correct |
| Section titled "Security Analysis in ROM" | ✅ §7 header | Correct |
| 3 games defined against PPT adversaries | ✅ §7 | Correct (Theorem 1–3 each structures a game) |
| Novelty claim: "Base paper has NO forward secrecy" | ✅ §7.4 final paragraph | Correct |
| Graph ~99% CPU reduction → Metric M1 | ✅ §8.2 + Fig 1 | Correct |
| Bar chart → bandwidth reduction → Metric M2 | ✅ §8.3 + Fig 2 | Correct |
| Clock cycle chart (Fig 7 extension) → Metric M3 | ✅ §8.4 + Fig 3 | Correct |
| Battery life extension claim | ⚠️ §8.4 | Limited to 33.1× clock cycle reduction with battery caveat. Draft suggests graphing actual battery extension — pending FPGA synthesis |

---

## GAPS CONSOLIDATED — Dual-Baseline View

This supersedes the previous 11-gap report. New gaps from novelty draft comparison are added (N prefix), previous gaps from base paper comparison are retained (G prefix).

### 🔴 CRITICAL — Blocks Scopus Acceptance

| ID | Source | Gap | In Paper | Fix |
|---|---|---|---|---|
| G1 | Base paper §10.2 | **QC-LDPC X=102, Y=204 WRONG** → correct X=408, Y=816 | §3 notation table + §5.3 | Fix dimensions globally |
| G3 | Base paper §11.3 | **Lemma 1 / G0-G1 ROM game absent** — Theorem 3 Ring-LWE citation floats | §7.1 | Add 1 paragraph |
| N1 | Novelty spec | **AES-GCM nonce format [32-bit zero \| 64-bit Ctr_Tx] not in §6 prose** | §6.3 algorithm only | Add explicit nonce format statement |
| N2 | Novelty spec | **"MS stored for epoch vs. one-time ssk" distinction not explicitly phrased** | §6.1 | Add 1 sentence: "Unlike the base paper which discards ssk immediately after use, SAKE-IoT stores MS for the entire epoch" |

---

### 🟡 MINOR — Strengthens Novelty Claim

| ID | Source | Gap | Fix |
|---|---|---|---|
| G2 | Base paper | Bernstein reconstruction not explained (why 22.55 ms is achievable) | Add §5.1 description |
| G9 | Base paper | Formal LWE definition (lattice Λ, Search/Decisional) missing | Add §3 formal definitions |
| G10 | Base paper | DEP role never explained — reviewers can't understand what SAKE eliminates | Add 2 sentences §5.2 |
| G11 | Both | Break-even N=4 not algebraically derived | Add 3-line derivation §8.2 |
| N3 | Novelty spec | Break-even table missing N=1,2,3 rows (showing SAKE costs more early) | Extend Table in §8.2 |
| N4 | Novelty spec | Receiver Tier 2 cost (~0.038 ms) never stated | Add to §8.2 table |
| N5 | Novelty spec | GHASH TAG detail (TAG' = GHASH(SK_i, CT, AD)) missing from Algorithm 8 context | Add 1 line in §6.4 prose |
| N6 | Novelty spec | Nonce uniqueness guarantee not stated in prose ("no two packets share a nonce within epoch") | Add 1 sentence §6.3 |
| N7 | Novelty spec | Protocol correctness lemma absent (HKDF deterministic → both sides derive same SK_i) | Add short correctness table §6.6 |
| G4 | Base paper | Attack table missing base paper replay (negl(λ)) vs SAKE (Pr=0) comparison row | Add row to attack table |
| G5 | Base paper | No cross-scheme comparison table (Wang, Mundhe, HAN vs SAKE) | Add Table §8.2 |
| G6 | Base paper | FPGA hardware results (64/640 slices) not referenced in §8.4 | Add 1 sentence |
| G7 | Both | No protocol flow diagram | See image_addition_draft.md |
| G8 | Both | No `\ref{}` cross-references for 3 figures | Fix in §8 |

---

## NOVELTY CLAIM VERIFICATION — Are All 6 Distinguishing Points Correctly Present?

These are the specific novelty claims the paper must prove over the base paper:

| Novelty Point | Required by Draft | In Paper | Verdict |
|---|---|---|---|
| 1. Two-tier architecture (Tier 1: PQ epoch, Tier 2: AEAD) | ✅ session amortization draft §Overview | ✅ §6.1 | ✅ |
| 2. HKDF-SHA256 per-packet key derivation | ✅ novelty-security proof draft Part 1 | ✅ §6.3, Alg 7 | ✅ |
| 3. AES-256-GCM with MAC-before-decrypt | ✅ novelty-security proof draft Part 1 | ✅ §6.4, Alg 8 | ✅ |
| 4. Strict monotonic counter (Pr[replay]=0, vs base paper negl(λ)) | ✅ sessionamortization draft §3.1 | ✅ Theorem 2 | ✅ But not compared in attack table |
| 5. Epoch-Bounded FS (absent in base paper) | ✅ novelty-security proof draft Proof 3 | ✅ Theorem 3 | ✅ |
| 6. Phase 4 cryptographic zeroization | ✅ sake_algorithm_full_specification §Phase 4 | ✅ §6.5 | ✅ But MATLAB code not shown |
| 7. MS stored per-epoch vs base paper one-time ssk | ✅ sake_algorithm_full_specification §1.2 critical distinction | ⚠️ §6.1 | **Implied but should be explicit** |
| 8. QC-LDPC role assignment (RECEIVER generates keys) | ✅ v3 correction | ✅ §6.2 | ✅ |
| 9. AD = DeviceID ∥ EpochID ∥ Nonce_i binding | ✅ sake_algorithm_full_specification | ✅ Alg 7, §6.2 | ✅ |
| 10. N_max = 2²⁰, T_max = 86400 as proof-driven bounds | ✅ session amortization draft §1.3 | ✅ §4.3 | ✅ |

**Score: 9/10 fully present, 1/10 implied but not explicit (point 7).**

---

## IMAGE ADDITION DRAFT UPDATE

The image addition draft (`image_addition_draft.md`) remains valid. One addition from novelty draft cross-check:

### NEW — Figure N1: Break-Even Cost Comparison with N=1,2,3,4 Rows

The `sake_algorithm_full_specification.md` §BREAK-EVEN ANALYSIS specifies a table showing that SAKE **costs more than the base paper for N=1,2,3** and wins from N=4 onward. This table is present in `paper_body_compiled.md` but missing from `latex_content.tex §8.2`. Without showing N=1,2,3 rows, the claim that N=4 is a genuine break-even (not just an assertion) cannot be verified by a reviewer.

**Action:** Add these rows to the existing `tab:latency` table in §8.2:

```latex
%% Add these rows ABOVE the "Per-packet Tier 2 cost" row in tab:latency:
N=1 & 7.37~ms & 22.62~ms & \textit{Base wins} \\
N=2 & 14.74~ms & 22.69~ms & \textit{Base wins} \\
N=3 & 22.11~ms & 22.75~ms & \textit{Base wins} \\
\textbf{N=4 (break-even)} & \textbf{29.49~ms} & \textbf{22.82~ms} & \textbf{SAKE wins ✓} \\
N=50 & 368.64~ms & 25.85~ms & SAKE wins \\
N=100 & 737.28~ms & 29.23~ms & SAKE wins \\
```

---

## FINAL VERDICT

| Aspect | Status |
|---|---|
| Core novelty (2-tier SAKE, HKDF, AES-GCM, EB-FS, Phase 4) | ✅ Fully present and correct |
| Novelty draft Algorithms 7/8 — exact pseudocode match | ✅ Perfect match against spec |
| 3 security proofs (IND-CCA2, Replay Pr=0, EB-FS) | ✅ All theorems structurally correct |
| v3 corrections (role, HMAC, nonce format, zeroize) — applied | ✅ 3 of 4; nonce format not in prose (GAP N1) |
| Novelty distinction vs base paper clearly phrased | ⚠️ Improvement needed (GAP N2, G10) |
| QC-LDPC parameters (X=408, Y=816) | ❌ Currently wrong X=102, Y=204 (GAP G1) |
| Formal LWE / Lemma 1 foundations | ❌ Missing (GAP G3, G9) |
| Figures with cross-references | ⚠️ Figures present; \ref{} missing (GAP G8) |
| Break-even table complete (N=1,2,3 loss rows) | ⚠️ Missing (GAP N3) |

**Recommended next step:** Apply critical fixes G1, G3, N1, N2 first (4 targeted edits), then add the break-even rows (N3) and figure cross-references (G8). This brings the paper to submission readiness for the listed fixes.

---

*Sources read for this analysis:*
*- session amortization draft.md (v3, 149 lines)*
*- sake_algorithm_full_specification.md (449 lines)*
*- novelty-security proof draft.md (84 lines)*
*- master_draft_COMPLETE.md (1190 lines, all 3 parts)*
*- latex_content.tex (1009 lines)*
*- paper_body_compiled.md (700 lines)*
*Generated: 2026-03-04*
