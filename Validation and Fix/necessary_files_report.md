# Necessary Files Report — Paper Folder Draft Generation
## Are the Right Files Being Used? Is V&F Folder Necessary?

**Date:** 2026-03-03 | Scope: All 9 Paper folder files (excluding main.tex)

---

## EXECUTIVE SUMMARY

**The Paper folder can be 100% generated from 5 primary source files only.**
The Validation and Fix folder is NOT a necessary source — it is a historical working log.
The Backup folder metric fix files are also NOT necessary — their conclusions are already in the primary Draft files and simulation output.

---

## PART 1 — THE ACTUAL 5 PRIMARY SOURCES (Everything the Paper Needs)

| # | File | Why It Is Irreplaceable |
|---|---|---|
| **P1** | `Draft/master_draft_COMPLETE.md` | ALL base paper values: algorithms 1–6, Tables 6/7/8, Fig. 7, Theorem 2, Ring-LWE params, QC-LDPC construction, auth overhead bits. Nothing else supplies these. |
| **P2** | `Draft/session amortization draft.md` | Complete 4-phase SAKE protocol spec: all steps, v3 role corrections, T_max/N_max, AD format, nonce format, MS derivation, Phase 4 zeroization. |
| **P3** | `Draft/novelty-security proof draft.md` | All 3 proof game requirements, expected simulation targets (~99%, massive bandwidth, fraction of cycles), ROM model, adversary oracle design. |
| **P4** | `Draft/cryptographic_proof_review.md` | The 3 mandatory Scopus fixes: (Fix 1) MATLAB disclaimer for IND-CCA2, (Fix 2) memset_s note for EB-FS, (Fix 3) TLS/DTLS differentiation table. These are PRIMARY specification requirements — not working notes. |
| **P5** | `simulation/results/novelty_proof_and_results.md` | All actual MATLAB output: 0.068ms, 99.1%, 184 bits, 33.1×, ε=0.0037, Pr=0, 0/100 past, 0/100 future. The only source of computed simulation values. |

> **These 5 files are necessary and sufficient to write the full research paper.**

---

## PART 2 — IS THE VALIDATION AND FIX FOLDER NECESSARY?

### What the V&F files actually are

Every file in `Validation and Fix/` is a **derivative document** — it was produced by reading the 5 primary sources and doing analysis. The V&F files do not contain original data:

| V&F File | What It Actually Is | Primary Source of Its Content |
|---|---|---|
| `final_forensic_revalidation.md` | Pass/fail record of whether simulation scripts match primary Draft specs | `Draft/` files + `simulation/results/` (the scripts themselves) |
| `novelty_and_scopus_evaluation.md` | Checklist checking if 14 draft requirements were met | Its own §1 says: *"evaluated against Draft/session amortization draft.md, Draft/novelty-security proof draft.md, Draft/master_draft_COMPLETE.md"* |
| `metric1/2/3_logical_validation.md` | Deep analysis of each metric's logic | `Draft/master_draft_COMPLETE.md` tables + simulation values |
| `novelty_sufficiency_validation.md` | Whether 3 metrics are sufficient for Scopus | Derived from all Draft files + simulation |
| `proof 1/3 limitation fix.md` | Fix records for proof issues | Fixes already applied to simulation scripts |

**Conclusion: V&F files are valid during development but are intermediate products, not primary data sources. The paper does not need them — it needs the primary sources they themselves derived from.**

---

## PART 3 — WHAT WAS UNNECESSARILY PULLED FROM V&F INTO PAPER FILES

### Inconsistency Found — `paper_master_reference_draft.md` Appendix B

**What it does:** Cites `Validation and Fix/final_forensic_revalidation.md` and `novelty_and_scopus_evaluation.md` as sources for the "14/14, 18/18" compliance numbers.

**The issue:** These compliance numbers are derivable directly from:
- 14 items in `Draft/session amortization draft.md` → checked against `simulation/results/novelty_proof_and_results.md`
- 18 proof requirements in `Draft/novelty-security proof draft.md` → checked against `simulation/results/novelty_proof_and_results.md`

The V&F file just did the counting. Citing it as a source creates a dependency on a working document.

**Impact level:** Low — the numbers are correct regardless. Appendix B is not paper content, it is an author reference.

---

### Inconsistency Found — `validation_and_scopus_reports.md` (Paper file itself)

**What it is:** A Paper folder file whose entire content derives from V&F files.

**The issue:** This file serves as a confidence check for the author — but it is not paper content (reviewers never see it). It is a meta-document inside the Paper folder. Its content is:
- Section 1: From `final_forensic_revalidation.md` → which came from `Draft/` + `simulation/`
- Section 2: From `novelty_and_scopus_evaluation.md` → which came from `Draft/` + `simulation/`

**Net result:** `validation_and_scopus_reports.md` is effectively a second-hand copy of V&F content, which is itself a second-hand copy of primary sources.

**Is it needed for paper writing?** No. The paper's claims are grounded in the 5 primary files. This is a useful author's confidence record, but not required for generating any paper section.

---

### Are the Backup/ metric fix files necessary?

| Backup File | What It Contributed | Actually Necessary? |
|---|---|---|
| `Backup/metric1_fix_gemini.md` | Rationale for tic/toc empirical fix | ❌ No — the fix is already in `simulation/sim_latency.m` and explained in `simulation/results/novelty_proof_and_results.md` |
| `Backup/metric2_fix_gemini.md` | Conservative baseline explanation for M2 | ❌ No — the 45.1% conservative claim logic is self-evident from `Draft/master_draft_COMPLETE.md` §10.2 arithmetic |
| `Backup/metric3_fix_gemini.md` | Flaw 3 cosmetic split analysis | ❌ No — the fix (Gap 5) was proposed but not yet committed; the primary source for M3 is `Draft/master_draft_COMPLETE.md` Fig.7 + `simulation/results/` |

**These were useful development tools but are not primary sources for paper content.**

---

## PART 4 — COMPLETE FILE NECESSITY CLASSIFICATION

### Required (5 files — irreplaceable primary sources)

| File | Status |
|---|---|
| `Draft/master_draft_COMPLETE.md` | ✅ REQUIRED — base paper values, irreplaceable |
| `Draft/session amortization draft.md` | ✅ REQUIRED — protocol specification, irreplaceable |
| `Draft/novelty-security proof draft.md` | ✅ REQUIRED — proof game specs and targets, irreplaceable |
| `Draft/cryptographic_proof_review.md` | ✅ REQUIRED — 3 Scopus-mandatory fixes (publication spec) |
| `simulation/results/novelty_proof_and_results.md` | ✅ REQUIRED — all actual computed values, irreplaceable |

### Conditionally Useful (historical/working files — not strictly required)

| File | Status | Reason |
|---|---|---|
| `Validation and Fix/final_forensic_revalidation.md` | 🟡 OPTIONAL | Valid only as author confidence record. Paper does not cite V&F files directly. |
| `Validation and Fix/novelty_and_scopus_evaluation.md` | 🟡 OPTIONAL | Same — useful checklist but NOT a primary source |
| `Backup/metric1/2/3_fix_gemini.md` | 🟡 OPTIONAL | Fix rationale already embedded in primary sources |
| `Validation and Fix/metric1/2/3_logical_validation.md` | 🟡 OPTIONAL | Analysis already incorporated; primary data is in Draft/ and simulation/ |
| `Validation and Fix/novelty_sufficiency_validation.md` | 🟡 OPTIONAL | Conclusion already stated in primary sources |
| `Validation and Fix/proof 1/3 limitation fix.md` | 🟡 OPTIONAL | Fixes already applied to scripts |

### Not Required (do not use as content sources)

| File | Status | Reason |
|---|---|---|
| `Backup/master_draft_part1/2/3.md` | ❌ EXCLUDE | Superseded by `master_draft_COMPLETE.md` |
| `Backup/gemini_vs_committed_comparison.md` | ❌ EXCLUDE | Version control artifact, not content |
| `Backup/gap_fixes_complete_report.md.resolved` | ❌ EXCLUDE | Archival, superseded |
| `session amortization draft.md` (root) | ❌ EXCLUDE | Duplicate of `Draft/session amortization draft.md` |
| `pdf_output.txt` / `pdf_output_utf8.txt` | ❌ EXCLUDE | PDF extraction artifacts — `master_draft_COMPLETE.md` is already the clean version |
| `simulation/results/proof_results.txt` | ❌ EXCLUDE | Raw terminal log — `novelty_proof_and_results.md` is the processed clean version |
| `Validation and Fix/gap_resolution_proposals.md` | ❌ EXCLUDE | Working doc for this session — not content source |
| `Validation and Fix/source_traceability_report.md` | ❌ EXCLUDE | Working doc for this session — not content source |

---

## PART 5 — DO THE CURRENT PAPER FILES CONTAIN ANYTHING SOURCED FROM UNNECESSARY FILES?

| Paper File | Uses V&F/Backup Content? | Issue | Severity |
|---|---|---|---|
| `paper_master_reference_draft.md` | Appendix B cites V&F | Numbers correct; Appendix is author reference not paper text | ⬜ Very low |
| `master_metrics_presentation_draft.md` | Reviewer objection tables draw from `metric1/2/3_fix_gemini.md` | The objections are valid; same conclusions reachable from primary sources | ⬜ Very low |
| `base_paper_complete_reference.md` | No — pure `master_draft_COMPLETE.md` extraction | None | ✅ Clean |
| `sake_algorithm_full_specification.md` | No — pure `session amortization draft.md` + `cryptographic_proof_review.md` Fix 2 | None | ✅ Clean |
| `security_proof_requirements_and_review.md` | No — pure `novelty-security proof draft.md` + `cryptographic_proof_review.md` | None | ✅ Clean |
| `simulation_results_record.md` | No — pure `simulation/results/novelty_proof_and_results.md` | One mention of `final_forensic_revalidation.md` for P3 fix code — this is the actual code fix, not a derivative | ⬜ Very low |
| `validation_and_scopus_reports.md` | Entire file derives from V&F | This file **is** a V&F derivative by design | 🟡 See note |
| `reference_list.md` | No — all refs from primary Draft files, RFCs, NIST standards | None | ✅ Clean |
| `figures_description.md` | No — pure `simulation/results/` + `master_draft_COMPLETE.md` Fig. 7 | None | ✅ Clean |

> **Note on `validation_and_scopus_reports.md`:** This file is the only Paper folder file that derives substantially from the V&F folder. However, it does not contribute to any actual paper section — it is an author confidence document. If the Paper folder is being used strictly for paper writing, this file can be treated as reference-only and is not needed to write §1–§10 of the paper.

---

## PART 6 — VERDICT: IS VALIDATION AND FIX NEEDED?

| Question | Answer |
|---|---|
| Is V&F needed to write the paper's §1–§10? | **NO.** All content traces to the 5 primary files. |
| Is V&F needed for the 6 metrics/3 proofs? | **NO.** Values come from `simulation/results/novelty_proof_and_results.md` directly. |
| Does V&F provide any UNIQUE content not in the 5 primaries? | **Only `final_forensic_revalidation.md` NEW ISSUE A** — the P3 10×10 code fix. This fix is already documented in `simulation_results_record.md` §7 inside Paper folder. |
| Should V&F files be cited in the published paper? | **No.** These are working/development documents — academic papers cite primary sources only. |
| Can the Paper folder be rebuilt from 5 primary files if V&F is deleted? | **Yes — completely.** |

---

## PART 7 — CONFIRMED USED CONTENT THAT IS CORRECT AND LATEST

All values in the 9 Paper folder files come from the correct latest sources:

| Claim | Source | Latest? |
|---|---|---|
| 7.3728 ms base cost | `Draft/master_draft_COMPLETE.md` Table 7 (published 2022) | ✅ |
| 0.068 ms Tier 2 | `simulation/results/novelty_proof_and_results.md` (run 2026-03-02) | ✅ |
| 408 bits CT₀ | `Draft/master_draft_COMPLETE.md` §10.2 | ✅ |
| 184 bits / 45.1% | `simulation/results/novelty_proof_and_results.md` §M2 | ✅ |
| 33.1× clock cycles | `simulation/results/novelty_proof_and_results.md` §M3 | ✅ |
| ε = 0.0037 | `simulation/results/novelty_proof_and_results.md` §5 | ✅ |
| Pr = 0 (replay) | `simulation/results/novelty_proof_and_results.md` §6 | ✅ |
| 0/100 past+future FS | `simulation/results/novelty_proof_and_results.md` §7 (10×10 fix included) | ✅ |
| All Draft proof games | `Draft/novelty-security proof draft.md` | ✅ |
| 3 publication fixes | `Draft/cryptographic_proof_review.md` | ✅ |

**No stale, outdated, or pre-fix values detected in any of the 9 Paper folder files.**

---

## SUMMARY ANSWER

The Paper folder's 9 draft files are built from:

**✅ Is correct:** 5 primary source files (`Draft/` × 4 + `simulation/results/`) — all latest, all correct, no stale values.

**🟡 Used but not strictly necessary:** V&F folder files and Backup metric fix files — these contributed context and wording to reviewer objection tables and the `validation_and_scopus_reports.md` file, but their content traces back to the 5 primary files.

**❌ Not used (correctly excluded):** `Backup/master_draft_part1/2/3.md`, `pdf_output*.txt`, `proof_results.txt`, root-level duplicate amortization draft, all version control artifacts.

**For paper writing, only these 5 files need to be open:**
1. `Draft/master_draft_COMPLETE.md`
2. `Draft/session amortization draft.md`
3. `Draft/novelty-security proof draft.md`
4. `Draft/cryptographic_proof_review.md`
5. `simulation/results/novelty_proof_and_results.md`

---

*Generated: 2026-03-03 | Forensic analysis of all source → Paper file derivation chains*
