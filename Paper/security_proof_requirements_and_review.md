# Security Proof Requirements, Full Draft, and Publication Review
## Sources: `Draft/novelty-security proof draft.md` + `Draft/cryptographic_proof_review.md`

> **PURPOSE OF THIS FILE:**
> This is the complete reference for all security proof requirements, formal proof text,
> and the publication-readiness review checklist for SAKE-IoT.
> Use this file to write §7 (Formal Security Analysis) of the research paper.
>
> **Two source documents combined here:**
> 1. `Draft/novelty-security proof draft.md` — Requirements, proof game specs, expected results
> 2. `Draft/cryptographic_proof_review.md` — Post-implementation review, 3 required fixes
>
> **All 3 fixes are applied in `paper_master_reference_draft.md` §7.**
> **MATLAB validation results → `Paper/simulation_results_record.md`**
> **Full metric detail → `Paper/master_metrics_presentation_draft.md`**

---

## PART 1 — PROOF REQUIREMENTS AND ARCHITECTURE

*Source: `Draft/novelty-security proof draft.md` §§1–2*

### 1.1 Why Formal Proofs Are Required (Scopus Mandate)

> *"Reviewers will not accept the novelty merely because it is faster; you must formally prove that reusing a Master Secret does not introduce critical vulnerabilities like replay attacks, chosen-ciphertext vulnerabilities, or the complete collapse of forward secrecy."*
> — `Draft/novelty-security proof draft.md` (opening)

### 1.2 Formal Proof Framework

**Section title for paper:** *"Formal Security Analysis in the Random Oracle Model (ROM)"*

**Model:** Random Oracle Model (ROM) — consistent with base paper §11.2.
**Adversary types:** PPT (Probabilistic Polynomial-Time) adversaries.
**Three mandatory proofs:** IND-CCA2, Strict Replay Resistance, Epoch-Bounded Forward Secrecy (EB-FS)

### 1.3 Required Protocol Architecture (Enables Proofs)

The SAKE architecture is designed so that these properties are provable:

| Architectural Feature | Enables Proof |
|---|---|
| HKDF-SHA256 per-packet key derivation | IND-CCA2 (session key pseudorandomness) |
| AES-256-GCM MAC-before-decrypt | IND-CCA2 (ciphertext forgery rejection) |
| AD = DeviceID ∥ EpochID ∥ Nonce_i | IND-CCA2 (cross-session binding) |
| Strict monotonic Ctr_Tx / Ctr_Rx | Strict Replay Resistance (Pr = 0) |
| T_max + N_max epoch bounds | Epoch-Bounded FS (timely zeroization) |
| Cryptographic MS zeroization (Phase 4) | EB-FS (past secrecy) |
| Fresh Ring-LWE ẽ per epoch | EB-FS (future secrecy + inter-epoch independence) |

---

## PART 2 — PROOF 1: IND-CCA2

*Source: `Draft/novelty-security proof draft.md` §Proof 1, `Draft/cryptographic_proof_review.md` §Part 2*

### 2.1 The Goal

Prove that derived session keys SK_i are indistinguishable from random noise, and an attacker cannot manipulate ciphertexts in transit.

### 2.2 Formal Game (ROM)

**Participants:** PPT Adversary A₃ vs Challenger C

**Setup:**
1. Challenger establishes MS (Master Secret)
2. Adversary receives access to:
   - KDF Oracle (HKDF queries, any Nonce_i)
   - Encryption Oracle O_E (encrypt any message m)
   - Decryption Oracle O_D (decrypt any ciphertext EXCEPT challenge CT*)

**Challenge Phase:**
1. A₃ submits two equal-length messages m₀ and m₁
2. Challenger flips secret bit b ∈ {0,1}; returns CT* = Enc(SK_i, m_b)
3. A₃ can continue querying O_D for ANY ciphertext except CT*
4. A₃ must output guess b' for b. Wins if b' = b.

**Winning condition:** A₃'s advantage = |Pr[b' = b] − 1/2| > negl(λ)

### 2.3 Formal Theorem (From `Draft/novelty-security proof draft.md` + Fix 3 of Review)

**Theorem 1 (IND-CCA2):** The SAKE-IoT Tier 2 data phase is IND-CCA2 secure under the AES-256 pseudorandom permutation (AES-PRP) and HMAC-SHA256 pseudorandom function (HMAC-PRF) assumptions.

**Formal Advantage Bound:**
```
Adv_IND-CCA2(A₃) ≤ Adv_PRF(HMAC-SHA256) + Adv_PRP(AES-256) + (N_max × q_D) / 2¹²⁸
                  ≤ negl(λ)
```
where q_D = number of decryption oracle queries, N_max = 2²⁰, GHASH forgery probability = 2⁻¹²⁸.

**Full Reduction Proof Sketch (Fix 3 of cryptographic_proof_review.md — mandatory in paper):**

> Assume PPT adversary A breaks IND-CCA2 with advantage ε. Construct simulator B as follows.
> For any of A's decryption oracle queries CT ≠ CT*, the receiver checks the AES-GCM
> authentication tag before any decryption is attempted. Because AES-GCM's GHASH tag covers
> both (CT, AD), any forged or altered CT causes the receiver to output ⊥ (reject) — A receives
> zero information about the underlying plaintext from all oracle queries. Stripped of useful
> decryption feedback, A must guess challenge bit b from CT* alone. Since
> SK_i = HKDF(MS, Nonce_i) is computationally indistinguishable from a uniform random string
> (by HKDF-PRF security, RFC 5869), CT* = AES-256-GCM-Enc(SK_i, m_b) is computationally
> indistinguishable from random noise. Therefore A's guessing probability is at most
> 1/2 + negl(λ), and its advantage ε ≤ Adv_PRF(HMAC-SHA256) + Adv_PRP(AES-256)
> + (N_max × q_D)/2¹²⁸ ≤ negl(λ). □

### 2.4 Mandatory Paper Disclaimer (Fix 1 of cryptographic_proof_review.md — verbatim)

> *"The MATLAB simulation in proof1_ind_cca2.m validates the architectural MAC-before-decrypt property: any modification to the ciphertext is detected and rejected before decryption proceeds. The formal IND-CCA2 security bound is established through standard reduction to AES-PRP hardness and HKDF-PRF security (RFC 5869), not derived from the MATLAB simulation."*

### 2.5 How MATLAB Validates This

Script `simulation/proof1_ind_cca2.m` validates three properties:

| Test | What it proves | How |
|---|---|---|
| TEST 1a | Session key uniqueness (SK_i distinct per packet) | Real `javax.crypto.Mac` HMAC-SHA256; 1,000 keys; all unique (collision ≤ 2⁻²⁵⁶) |
| TEST 2 | IND-CCA2 formal game | 50 oracle queries × 10,000 trials = 500K. Adversary advantage ε = 0.0037 < 0.02 (negligible) |
| TEST 3 | MAC-before-decrypt rejection | Real HMAC-SHA256 256-bit MAC; 10,000 tamper attempts; 100% rejection rate |

**→ Full MATLAB test tables and reviewer objection pre-emption:**
**See `Paper/master_metrics_presentation_draft.md` — PROOF 1 section**

---

## PART 3 — PROOF 2: STRICT REPLAY RESISTANCE

*Source: `Draft/novelty-security proof draft.md` §Proof 2, `Draft/cryptographic_proof_review.md` §Part 3*

### 3.1 The Goal

> *"Prove that reusing the Master Secret does not allow an attacker to intercept Session 1 and replay it later to trick the receiver."*
> — `Draft/novelty-security proof draft.md` §Proof 2

### 3.2 Formal Game

**Setup:** Adversary A eavesdrops on network, records valid transmission tuple (Nonce_r, CT, TAG).
**Attack:** Later injects that exact tuple back into the receiver.
**Win condition:** Receiver accepts the replayed packet.

### 3.3 Formal Theorem

**Theorem 2 (Strict Replay Resistance):**
```
For any packet with Nonce_r ≤ Ctr_Rx:
Pr[Receiver accepts replay] = Pr[Nonce_r > Ctr_Rx | Nonce_r ≤ Ctr_Rx] = exactly 0
```

This is a **deterministic** rejection — not probabilistic, not negligible. No PPT assumptions needed.

> *"The packet is mathematically dropped with a probability of exactly 1."*
> — `Draft/novelty-security proof draft.md` §Proof 2

### 3.4 Proof Mechanism

Receiver enforces strict monotonic check: `Nonce_i > Ctr_Rx`

```
State machine:
   IF (Nonce_i <= Ctr_Rx) → DROP (deterministic, no computation)
   ELSE → proceed to MAC check
```

Because legitimate transmissions advance Ctr_Rx monotonically, every replayed, duplicated, or delayed packet has `Nonce_r ≤ Ctr_Rx` and is unconditionally dropped.

### 3.5 Desynchronization Safety (Corollary)

```
Scenario: Ctr_Tx = 5, Ctr_Rx = 2 (packets 3, 4 dropped)
→ Packet Nonce_5 = 5 > 2: accepted; Ctr_Rx → 5
→ Replay of 3 or 4: Nonce ≤ 5 → rejected
→ Counter self-heals: no state corruption
```

### 3.6 Novelty vs. Base Paper [1]

| Property | Base Paper [1] | SAKE-IoT |
|---|---|---|
| Replay defense mechanism | Random Y_n per session (probabilistic) | Strict monotonic counter |
| Acceptance probability of replay | negl(λ) — probabilistic | **Exactly 0 — deterministic** |
| Strength of guarantee | Computational | **Information-theoretic** |

> *"This is your strongest proof. No PPT assumptions needed — this is a pure safety property."*
> — `Draft/cryptographic_proof_review.md` §Part 3

### 3.7 MATLAB Validation

Script `simulation/proof2_replay.m` — 4 scenarios:

| Scenario | Test | Verdict |
|---|---|---|
| TEST 1 | 10,000 replay attempts | All 10,000 rejected (Pr = 0) ✅ |
| TEST 2 | 10,000 valid packets | All 10,000 accepted ✅ |
| TEST 3 | Desynchronization (20% drop rate) | All received packets accepted; counter self-heals ✅ |
| TEST 4 | 10,000 duplicate deliveries | All rejected ✅ |

**→ Full MATLAB test tables and result interpretation:**
**See `Paper/master_metrics_presentation_draft.md` — PROOF 2 section**

---

## PART 4 — PROOF 3: EPOCH-BOUNDED FORWARD SECRECY (EB-FS)

*Source: `Draft/novelty-security proof draft.md` §Proof 3, `Draft/cryptographic_proof_review.md` §Part 4*

### 4.1 The Goal

> *"The base paper claims perfect forward secrecy because keys are ephemeral. You must prove that storing the MS does not cause catastrophic historical leakage if the device is physically hacked."*
> — `Draft/novelty-security proof draft.md` §Proof 3

### 4.2 Formal Game

**Setup:** Adversary A physically compromises an IoT node during Epoch k+1, extracts MS_{k+1} from RAM.
**Goal:** Recover any session key SK_i from Epoch k (past secrecy) or predict SK_j from Epoch k+1 (future secrecy — optional extension).

### 4.3 Formal Theorem

**Theorem 3 (Epoch-Bounded Forward Secrecy):**

Let `MS_k = HMAC-SHA256(ẽ_k)` and `MS_{k+1} = HMAC-SHA256(ẽ_{k+1})`, where ẽ_k and ẽ_{k+1} are independently sampled Ring-LWE error vectors.

**(1) Past Secrecy:**
```
Pr[Adversary(MS_{k+1}) recovers ANY SK_i from Epoch k] ≤ negl(λ)
```

**(2) Future Secrecy (demonstrated):**
```
Pr[Adversary(MS_k) predicts ANY SK_j from Epoch k+1] ≤ negl(λ)
```

### 4.4 Proof Sketch

**Part A — Zeroization (directly addresses physical compromise):**
At epoch end: `MS_k = zeros(1, 32, 'uint8')` → MS_k becomes a fixed zero-vector.
Any computation using MS_k = 0 produces degenerate keys, not original SK_i values.
An adversary arriving in Epoch k+1 finds an already-overwritten MS_k.

**Part B — Computational Barrier (Ring-LWE reduction):**

Recovery of Epoch k keys from Epoch k+1 requires either:

*(Path 1) Invert HMAC-SHA256:* Find ẽ_k from MS_k = HMAC-SHA256(ẽ_k)
→ Requires breaking HMAC as one-way function → negligible.

*(Path 2) Re-derive from public parameters:* Compute ẽ_k from public randomness R_n, T_n
→ Equivalent to Ring-LWE **search** problem:
```
Pr[findSearchLWE(λ) = S_ch] is negligible     (Theorem 2, Eq. 23 of base paper)
```

Both paths infeasible. Therefore Past Secrecy holds.

**Part C — Epoch Bound (timely zeroization guarantee):**
```
N_max = 2²⁰: prevents indefinite epoch lifetime; forces zeroization before nonce exhaustion
T_max = 86,400 s: time-bounded epoch regardless of packet count
```

### 4.5 Implementation Scope Disclaimer (Mandatory in Paper)

> *"The formal security argument holds at the protocol specification level. Hardware deployment requires `memset_s` (NIST SP 800-88 / C11 Annex K) to prevent physical RAM remnant recovery. This is standard practice in protocol-level security proofs."*
> — `Draft/novelty-security proof draft.md` §Proof 3 Part A

### 4.6 Novelty vs. Base Paper [1]

| Property | Base Paper [1] | SAKE-IoT |
|---|---|---|
| Forward secrecy | ❌ None (one-time ssk, no FS protocol) | ✅ Epoch-Bounded FS |
| Proof mechanism | Not attempted | Ring-LWE hardness + zeroization |
| Scope | Per-session key is ephemeral, but MS not modelled | MS formally bounded by T_max, N_max, zeroization |

**EB-FS is a new security property formally proven in this paper that does not exist in the base paper.**

### 4.7 MATLAB Validation

Script `simulation/proof3_forward_secrecy.m` — 4 scenarios (Revised — full 10×10 cross-epoch fix applied):

| Scenario | Test | Verdict |
|---|---|---|
| TEST 1 | MS zeroization verification | Zero-vector confirmed post-epoch ✅ |
| TEST 2 | Past Secrecy — 100 Epoch-k keys | 0/100 recoverable from Epoch-(k+1) MS ✅ |
| TEST 3 | 5-epoch mutual isolation (10×10 full) | All key-sets mutually exclusive ✅ |
| TEST 4 | Future Secrecy — 100 Epoch-(k+1) keys | 0/100 predictable from MS_k ✅ |

**→ Full MATLAB test tables and result interpretation:**
**See `Paper/master_metrics_presentation_draft.md` — PROOF 3 section**

---

## PART 5 — CRYPTOGRAPHIC PROOF REVIEW (Publication-Readiness)

*Source: `Draft/cryptographic_proof_review.md` (full 194-line review)*

Three mandatory fixes required for Scopus acceptance. All three applied.

### Fix 1 — MATLAB Disclaimer (IND-CCA2 — CRITICAL)

**Status:** ✅ Applied in §7.2 of `paper_master_reference_draft.md`

The paper MUST include this exact disclaimer in the IND-CCA2 section:
> *"The MATLAB simulation validates the architectural MAC-before-decrypt property of the proposed scheme using real `javax.crypto.Mac` HMAC-SHA256. The formal IND-CCA2 security bound is established through standard reduction to AES-PRP hardness and HKDF-PRF security (RFC 5869), not derived from the MATLAB simulation."*

**Why:** MATLAB cannot execute AES-256-GCM natively. If a reviewer believes the IND-CCA2 bound ε = 0.0037 is derived from the MATLAB test, they would correctly reject it. The disclaimer makes clear the proof is from the formal reduction, validated architecturally by MATLAB.

### Fix 2 — P3 MATLAB Scope Disclaimer (EB-FS — CRITICAL)

**Status:** ✅ Applied in §7.4 of `paper_master_reference_draft.md`

The paper MUST include this note in the EB-FS section:
> *"The formal security argument holds at the protocol specification level. Hardware deployment requires `memset_s` (NIST SP 800-88 / C11 Annex K) to prevent physical RAM remnant recovery."*

**Why:** MATLAB `zeros()` demonstrates the protocol-level zeroization intent. Real IoT devices require hardware-level primitives. Without this note, a reviewer who knows embedded security will flag MATLAB zeroization as insufficient.

### Fix 3 — TLS 1.3 / DTLS Differentiation Paragraph (CRITICAL for Novelty)

**Status:** ✅ Applied in §3.4 of `paper_master_reference_draft.md`

The paper MUST include a comparison against TLS 1.3 and DTLS in Related Work.

**Why:** Without this, reviewers will ask "Why not just use TLS 1.3 session resumption?" and may reject as not novel.

**Required comparison table (from `simulation/results/novelty_proof_and_results.md` §3.4):**

| Property | TLS 1.3 Session Resumption | DTLS 1.3 | **SAKE-IoT (This Work)** |
|---|---|---|---|
| Post-Quantum Key Establishment | ❌ Classical ECDH/RSA only | ❌ Classical only | ✅ Ring-LWE + QC-LDPC (per epoch) |
| Epoch-Bounded Forward Secrecy | ❌ No formal epoch boundary | ❌ No formal epoch boundary | ✅ N_max + T_max dual trigger |
| In-epoch Forward Secrecy | ❌ PSK reuse across sessions | ❌ No per-packet key derivation | ✅ SK_i = HKDF(MS, Nonce_i) per packet |
| Formal FS Hardness Reduction | Classical DH only | Classical DH only | ✅ Ring-LWE (PQ-secure, Theorem 2) |
| Replay Protection Model | Sequence numbers (TCP layer) | DTLS sequence + epoch | ✅ Strict monotonic counter (Pr=0) |
| Nonce Reuse Risk (lossy channel) | TCP handles retransmit | ⚠️ UDP loss risks nonce reuse | ✅ Drop-safe; counter self-heals |
| Master Secret Zeroization | Session ticket expiry (timeout) | Timeout-based | ✅ Cryptographic zero-overwrite (Phase 4) |
| Target Environment | General web/cloud | General UDP apps | ✅ Resource-constrained IoT |
| Per-packet overhead | TLS record + header | DTLS: 13-byte header + MAC | ✅ 224 bits (Nonce + GCM tag only) |

**3 distinguishing points for paper narrative:**
1. **PQ Foundation:** TLS 1.3 / DTLS use classical DH — broken by Shor's algorithm. SAKE uses Ring-LWE per epoch.
2. **Formal Epoch Bounds:** Neither TLS 1.3 nor DTLS define a formally bounded epoch tied to a proof. SAKE N_max = 2²⁰, T_max = 86,400 s are proof-driven limits.
3. **Cryptographic Zeroization:** TLS/DTLS session expiry = administrative timeout. SAKE Phase 4 = byte-level memory overwrite verified in TEST 1 of Proof 3.

---

## PART 6 — PUBLICATION-READINESS CHECKLIST

**Source: `Draft/cryptographic_proof_review.md`**

| Requirement | Status | Where in Paper |
|---|---|---|
| Formal security claims under named standard assumptions (AES-PRP, HMAC-PRF) | ✅ | §7.2 Theorem 1 |
| Full IND-CCA2 reduction proof sketch | ✅ | §7.2 Proof Sketch |
| MATLAB disclaimer for IND-CCA2 (Fix 1) | ✅ | §7.2 Mandatory Disclaimer |
| Replay resistance as deterministic (Pr = 0) not probabilistic | ✅ | §7.3 Theorem 2 |
| EB-FS with both past AND future secrecy | ✅ | §7.4 Theorem 3 |
| memset_s / NIST SP 800-88 implementation note (Fix 2) | ✅ | §7.4 Implementation Note |
| TLS 1.3/DTLS differentiation paragraph (Fix 3) | ✅ | §3.4 Related Work |
| Ring-LWE formal reduction cited (Theorem 2, Eq. 23 of [1]) | ✅ | §7.4 Part B |
| Random Oracle Model declared explicitly | ✅ | §7 Opening |
| Adversary oracle access modelled (A₁, A₂, A₃) | ✅ | §5.2 + §7.2 |

---

## PART 7 — EXPECTED SIMULATION RESULTS (Scopus Targets)

*Source: `Draft/novelty-security proof draft.md` §Part 3 — "Expected Simulation Results for Scopus Acceptance"*

The draft explicitly prescribes three result graphs/tables:

| Expected Result | Prescribed Target | Actual Achieved |
|---|---|---|
| 1. Algorithmic Delay | "~99% reduction in CPU delay" / "≈0.075 ms" | **99.1% / 0.068 ms** ✅ (beats target) |
| 2. Communication Bandwidth | "massive reduction in transmitted bits/packet" | **45.1% / 184 bits** ✅ |
| 3. Hardware Energy | "AEAD takes fraction of QC-LDPC clock cycles" | **33.1× fewer cycles** ✅ |

> *"By structuring the paper with this strict AEAD + Nonce architecture, proving IND-CCA2 and Epoch-Bounded Forward Secrecy, and presenting a 99% reduction in computational latency, your manuscript will represent a highly rigorous, publishable improvement over the base protocol."*
> — `Draft/novelty-security proof draft.md` (closing)

---

*Sources: `Draft/novelty-security proof draft.md` + `Draft/cryptographic_proof_review.md`*
*MATLAB results → `Paper/simulation_results_record.md`*
*Full metric detail → `Paper/master_metrics_presentation_draft.md`*
