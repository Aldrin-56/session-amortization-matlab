# SAKE-IoT: Complete Algorithm Specification
## Source: `Draft/session amortization draft.md` (v3 — all 4 corrections applied)

> **PURPOSE OF THIS FILE:**
> This is the complete, authoritative specification of the SAKE-IoT (Stateful Authenticated Key
> Exchange for IoT) protocol — the novelty at the core of the research paper.
> Use this file to write §6 (Protocol Description) and to derive all protocol-level claims.
>
> **Version note (v3):** 4 corrections applied from original draft — all confirmed against
> `master_draft_COMPLETE.md` (base paper ground truth). Corrections documented in §5 of this file.
>
> **Cross-reference:** All timing values trace back to `Paper/base_paper_complete_reference.md`.
> All security properties trace back to `Paper/security_proof_requirements_and_review.md`.

---

## OVERVIEW

SAKE-IoT is a **Stateful Authenticated Key Exchange** protocol that structures post-quantum IoT key establishment into 4 phases:

```
Phase 1 → [ONCE per epoch]      : LR-IoTA + QC-LDPC → Master Secret (~22.55 ms)
Phase 2 → [EVERY Tier 2 packet] : HKDF key derivation + AES-GCM encryption (~0.068 ms/packet)
Phase 3 → [EVERY Tier 2 packet] : Counter check + key derivation + AEAD decryption (~0.038 ms/packet)
Phase 4 → [Epoch termination]   : Cryptographic zeroization → new epoch
```

**Key novelty:** Phases 2–3 completely bypass the post-quantum operations of Phase 1.
The 22.55 ms post-quantum cost is amortized over up to 2²⁰ packets.
Break-even: N = 4 packets. Novelty wins from the 4th packet onward.

**Protocol components added beyond base paper:**
1. Epoch-based State Machine (T_max, N_max, Ctr_Tx, Ctr_Rx)
2. HKDF-SHA256 per-packet session key derivation (RFC 5869)
3. AES-256-GCM AEAD with 96-bit nonce and 128-bit TAG (NIST SP 800-38D)
4. Phase 4 cryptographic memory zeroization

---

## PHASE 1: EPOCH INITIATION (Post-Quantum Handshake — once per epoch)

### Step 1.1: Mutual Authentication (LR-IoTA)

**Who:** Sender (IoT Node) ↔ Receiver (Gateway)
**Protocol:** Exactly as defined in base paper Algorithms 1–4 (unchanged)

- Sender generates sparse-polynomial ring signature `(S_n, ρ̂)` via Bernstein reconstruction
- Receiver verifies via SV(S_n, ρ̂, P, K, N) → returns 1 (authenticated) or 0 (reject)
- Both nodes mutually verify identities

**Timing (from base paper Table 6):**
```
Δ_KG = 0.288 ms  (Key Generation — Algorithm 1)
Δ_SG = 13.299 ms (Signature Generation — Algorithm 2, dominant step)
Δ_V  = 0.735 ms  (Verification — Algorithm 4)
─────────────────
Total LR-IoTA = 14.322 ms  (one-time per epoch)
```

---

### Step 1.2: Master Secret Establishment (QC-LDPC KEP)

> ⚠️ **v3 Correction:** Role assignment corrected vs original draft to match base paper §6.3.

**RECEIVER initiates KEP (Algorithm 5):**
1. Generates Diagonally Structured QC-LDPC key pair:
   - Private key: `sk_ds = (H_qc, G)`
   - Public key: `pk_ds = W̃_l`
2. Sends `pk_ds` to Sender

**SENDER performs encapsulation:**
1. Generates random error vector: `ẽ ∈ F^n_2` (Hamming weight = 2)
2. Computes syndrome: `CT₀ = [W̃_l | I] × ẽᵀ` (408 bits)
3. Transmits `CT₀` to Receiver
4. Derives: `MS = HMAC-SHA256(ẽ)` — "SHA in MAC-mode" (§8.4 of base paper) → stores in volatile RAM

**RECEIVER decapsulates:**
1. Runs Algorithm 6 SLDSPA: `SLDSPA(CT₀, H_qc) → ẽ`
2. Derives: `MS = HMAC-SHA256(ẽ)` — exact same MS as Sender

**The Novelty (critical distinction from base paper):**
> Base paper: output `ssk` is used immediately as one-time session key, then discarded.
> SAKE-IoT: output `MS` is stored in protected volatile RAM for the entire epoch duration.
> All subsequent Tier 2 packets use `MS` as root key material, bypassing all QC-LDPC operations.

**Timing (from base paper Table 7):**
```
Δ_KeyGen = 0.8549 ms  (Algorithm 5 QC-LDPC generation)
Δ_Enc    = 1.5298 ms  (SENDER encapsulation)
Δ_Dec    = 5.8430 ms  (RECEIVER decapsulation via SLDSPA)
─────────────────────
Total KEP = 8.228 ms  (one-time per epoch)
```

---

### Step 1.3: State and Epoch Initialization

Both nodes set epoch bounds and initialize state:

```
T_max = 86,400 s           (24 hours — maximum epoch duration)
N_max = 2²⁰ = 1,048,576   (maximum packets per epoch)

Ctr_Tx = 0                 (Sender-side monotonic counter)
Ctr_Rx = 0                 (Receiver-side monotonic counter)

AD = DeviceID || EpochID || Nonce_i   (per-packet associated data, bound at encryption time)
```

**Total Phase 1 cost:**
```
14.322 ms (LR-IoTA)  +  8.228 ms (QC-LDPC KEP)  =  ~22.55 ms  (amortized over N_max packets)
```

---

## PHASE 2: AMORTIZED DATA TRANSMISSION — SENDER SIDE (~0.068 ms/packet)

For every payload within the active epoch, Sender **completely bypasses Phase 1** and executes this lightweight loop:

### Step 2.1: Epoch Validity Check

```
IF (CurrentTime > T_max) OR (Ctr_Tx >= N_max):
    → Trigger Phase 4 (Secure Erasure)
ELSE:
    → Proceed
```

### Step 2.2: Strict Nonce Generation

```
Ctr_Tx = Ctr_Tx + 1              // Strictly monotonic increment
Nonce_i = Ctr_Tx                  // 64-bit integer, embedded in 96-bit AES-GCM nonce
```

AES-GCM 96-bit nonce format: `[32-bit zero-prefix | 64-bit Ctr_Tx]`

> **Security property:** Strictly monotonically increasing — core mechanism for Proof 2 (Strict Replay Resistance).
> No two packets share a nonce within an epoch. Nonce reuse impossible since Ctr_Tx is 64-bit and N_max = 2²⁰ << 2⁶⁴.

### Step 2.3: Per-Packet Session Key Derivation (HKDF-SHA256)

```
SK_i = HKDF(MS, Nonce_i)
     = HMAC-SHA256(MS, Nonce_i || context)    // "SHA in MAC-mode" — consistent with base paper §8.4
```

**HKDF (RFC 5869) mechanics:**
- Extract: `PRK = HMAC-SHA256(salt, IKM=MS)`
- Expand: `SK_i = HMAC-SHA256(PRK, info || 0x01)` (one call for 32-byte output per RFC 5869 §2.3)

> **Security property:** SK_i is computationally indistinguishable from uniform random. Each SK_i unique per (MS, Nonce_i) pair. Decoupled from past and future SK_j for j ≠ i. This directly supports Proof 1 (IND-CCA2).

**Cost:** ≈ 0.019–0.021 ms per HKDF call (empirically measured via MATLAB tic/toc, 10,000 iterations)

### Step 2.4: Authenticated Encryption (AES-256-GCM)

```
(CT, TAG) = AES-256-GCM-Enc(SK_i, Nonce_i[96-bit], m, AD)
          where AD = DeviceID || EpochID || Nonce_i
```

- CT = AES-256 CTR-mode ciphertext
- TAG = 128-bit GHASH authentication tag over (CT, AD)
- MAC is computed BEFORE any plaintext is released during decryption (MAC-then-verify architecture)

> **Security property:** AD = DeviceID ∥ EpochID ∥ Nonce_i binds ciphertext to unique session context. Required for IND-CCA2 ciphertext binding (cross-session attack prevention).

**Cost:** ≈ 0.047–0.050 ms per AES-GCM call (empirically measured via MATLAB tic/toc, 10,000 iterations, ×1.20 GHASH overhead factor)

### Step 2.5: Transmission

```
Transmit: (Nonce_i, CT, TAG)
```

**Tier 2 overhead breakdown:**
```
96-bit Nonce  +  128-bit TAG  =  224 bits  (28 bytes)

Base paper comparison:
CT₀ syndrome = 408 bits (38 bytes)

Net saving per packet: 408 - 224 = 184 bits (45.1%)
```

**Total Tier 2 SENDER cost:**
```
HKDF ≈ 0.021 ms  +  AES-GCM ≈ 0.048 ms  =  ≈ 0.068 ms/packet
Reduction vs base: (7.37 - 0.068) / 7.37 × 100% = 99.1%
```

---

## PHASE 3: DATA RECEPTION AND VERIFICATION — RECEIVER SIDE (~0.038 ms/packet)

### Step 3.1: Strict Replay and Desynchronization Check (FIRST — before MAC or decryption)

```
Extract Nonce_i from received packet
IF (Nonce_i <= Ctr_Rx):
    DROP PACKET AND ABORT             // Replay/duplicate/delayed packet detected
    (Do NOT attempt MAC check; do NOT decrypt)
```

**Security guarantee:** Any replayed, duplicated, or delayed packet has `Nonce_i ≤ Ctr_Rx`.
The strict inequality `Nonce_i > Ctr_Rx` check means:
```
Pr[Receiver accepts replayed packet] = Pr[Nonce_i > Ctr_Rx | Nonce_i ≤ Ctr_Rx] = exactly 0
```

**Desynchronization safety:** If packets 3, 4 are dropped (Ctr_Rx = 2, Ctr_Tx = 5):
- Packet with Nonce_5 = 5 > 2 → accepted; Ctr_Rx updated to 5
- Replays of 3 or 4 → rejected (Nonce ≤ 5)
- Counter self-heals without state corruption

### Step 3.2: Symmetric Session Key Derivation

```
SK_i = HKDF(MS, Nonce_i)    // Deterministic: same (MS, Nonce_i) → same SK_i
```

Because HKDF is deterministic given the same inputs, Receiver derives an identical SK_i to what Sender used.

### Step 3.3: Authenticated Decryption (MAC-before-decrypt — critical for IND-CCA2)

```
m = AES-256-GCM-Dec(SK_i, Nonce_i, CT, TAG, AD)
```

AES-GCM decryption sequence:
1. Recompute TAG' = GHASH(SK_i, CT, AD)
2. If TAG' ≠ TAG: output ⊥ (reject). **No plaintext released.** This is the MAC-before-decrypt property.
3. If TAG' = TAG: proceed with AES decryption → output m

**Security consequence:** Any chosen-ciphertext attack that modifies CT or AD causes TAG rejection with probability ≥ 1 − 2⁻¹²⁸. Adversary obtains ⊥ for all oracle queries on modified ciphertexts. Directly supports Proof 1 (IND-CCA2).

### Step 3.4: State Update (only after successful authentication)

```
Ctr_Rx = Nonce_i       // ONLY after successful MAC verification + decryption
→ pass decrypted m to IoT application layer
```

---

## PHASE 4: EPOCH TERMINATION AND SECURE ERASURE

### Step 4.1: Trigger Condition

Either condition triggers Phase 4:
```
T > T_max   (24-hour epoch lifetime expired)
OR
Ctr_Tx >= N_max   (2²⁰ packet limit reached — nonce exhaustion prevention)
```

### Step 4.2: Cryptographic Zeroization (MATLAB level)

```matlab
MS = zeros(1, 32, 'uint8');   % Overwrite memory with zero-vector (32 bytes = 256 bits)
clear MS;                      % Remove from MATLAB workspace
clear Ctr_Tx Ctr_Rx;          % Clear all epoch state
% → Trigger new Epoch (Phase 1)
```

**Formal security consequence:**
Zeroized MS → any computation using MS = 0 produces a fixed degenerate key, not original SK_i values.
Recovery requires either:
1. Inverting HMAC-SHA256 to find ẽ from MS — negligible (HMAC one-way)
2. Recovering ẽ from public parameters — equivalent to Ring-LWE search problem (Theorem 2, Eq. 23 of base paper)

This establishes **Epoch-Bounded Forward Secrecy (EB-FS)** — Proof 3.

> **Hardware deployment note:** MATLAB `zeros + clear` demonstrates the protocol-level property.
> Actual embedded deployment requires `memset_s` per NIST SP 800-88 / C11 Annex K to prevent RAM remnant recovery.

### Step 4.3: Handshake Re-initiation

Nodes automatically trigger Phase 1 to generate a fresh MS_{k+1} from a new, independently sampled Ring-LWE error vector ẽ_{k+1}. MS_{k+1} is cryptographically independent of MS_k.

---

## PROTOCOL CORRECTNESS GUARANTEES

| Property | Requirement | Mechanism | Formally Proved By |
|---|---|---|---|
| Key agreement | Sender and Receiver derive identical SK_i | HKDF deterministic given same (MS, Nonce_i) | Construction |
| Replay safety | Every Nonce_i unique within epoch | Strict monotonic Ctr_Tx; Ctr_Tx 64-bit; N_max = 2²⁰ << 2⁶⁴ | Proof 2 |
| No GCM nonce reuse | Nonce unique per AES-GCM call | Ctr_Tx monotonically increasing; N_max << 2⁶⁴ | Nonce bound |
| Epoch independence | MS_{k+1} independent of MS_k | Fresh ẽ_{k+1} from Ring-LWE per base paper Theorem 2 | Proof 3 / Ring-LWE |
| IND-CCA2 | Adversary cannot distinguish ciphertexts | HKDF-PRF + AES-GCM MAC-before-decrypt | Proof 1 |

---

## BREAK-EVEN ANALYSIS (Amortization Economics)

| N (packets) | Base Paper total cost | SAKE total cost | SAKE savings |
|---|---|---|---|
| 1 | 7.37 ms | 22.55 ms (epoch) + 0.068 ms | **SAKE costs more** (amortization not started) |
| 2 | 14.74 ms | 22.55 + 0.136 = 22.69 ms | SAKE costs more |
| 3 | 22.11 ms | 22.55 + 0.204 = 22.75 ms | SAKE costs more |
| **4** | **29.49 ms** | **22.55 + 0.272 = 22.82 ms** | **SAKE wins** ✅ Break-even |
| 50 | 368.64 ms | 22.55 + 3.30 = 25.85 ms | **342.8 ms saved** |
| 100 | 737.28 ms | 22.55 + 6.68 = 29.23 ms | **708.1 ms saved** |

**Break-even: N = 4 packets. Novelty is advantageous for virtually all practical IoT deployments.**

---

## KEY PARAMETERS SUMMARY

| Parameter | Value | Source |
|---|---|---|
| Master Secret length | 32 bytes (256 bits) | AES-256 requirement |
| HKDF hash function | HMAC-SHA256 | RFC 5869 + consistent with base paper "SHA in MAC-mode" |
| AEAD cipher | AES-256-GCM | NIST SP 800-38D |
| AES-GCM nonce | 96 bits [32-bit zero \| 64-bit Ctr_Tx] | NIST SP 800-38D standard |
| AES-GCM TAG | 128 bits | NIST SP 800-38D |
| N_max | 2²⁰ = 1,048,576 | Epoch design |
| T_max | 86,400 s (24 hours) | Epoch design |
| CT₀ (base) | 408 bits | Base paper §10.2, X = 408 |
| Tier 2 overhead | 224 bits (96 Nonce + 128 TAG) | Protocol design |
| Saving | 184 bits per packet (45.1%) | Deterministic |
| Tier 2 cost | ≈ 0.068 ms/packet | MATLAB empirical |
| Tier 2 cycle reduction | 33.1× | From Fig. 7 of base paper |
| Break-even | N = 4 packets | Mathematical |

---

## V3 CORRECTIONS LOG

| # | Issue | Original | Corrected | Reason |
|---|---|---|---|---|
| 1 | QC-LDPC role assignment | SENDER generates keys | **RECEIVER generates keys; SENDER generates ẽ → CT₀** | §6.3 of base paper (Fig. 3 architecture) |
| 2 | MS derivation function | SHA (unspecified) | **MS = HMAC-SHA256(ẽ)** | Base paper §8.4: "SHA in MAC-mode" = HMAC |
| 3 | AES-GCM nonce format | Not specified | **96-bit: [32-bit zero \| 64-bit Ctr_Tx]** | NIST SP 800-38D standard nonce + IND-CCA2 binding |
| 4 | Zeroization specifics | Implied | **`zeros(1,32,'uint8'); clear MS`** — MATLAB explicit | Required for Proof 3 (EB-FS MATLAB validation) |

---

*Source: `Draft/session amortization draft.md` v3*
*All timing values → `Paper/base_paper_complete_reference.md`*
*Security proofs → `Paper/security_proof_requirements_and_review.md`*
*Metric detail → `Paper/master_metrics_presentation_draft.md`*

---

## PAPER-READY ALGORITHM BOXES (Gap 7 — §6 Insertion-Ready)

> **PURPOSE:** These are the formal algorithm pseudocode boxes for direct insertion into the
> paper's §6 (Protocol Description). Use `\begin{algorithm}...\end{algorithm}` in LaTeX
> with the `algorithm2e` package. The prose description above is the reference;
> these boxes are the journal-typesetting-ready version.
>
> **Follows:** Algorithms 1–6 of the base paper [1]. SAKE adds Algorithms 7–8.

---

### Algorithm 7 — SAKE Tier 2: Sender-Side Amortized Transmission

```
Algorithm 7: SAKE-Tier2-Sender(MS, Ctr_Tx, T_max, N_max, m, AD)
─────────────────────────────────────────────────────────────────
Input:  Master Secret MS ∈ {0,1}^256
        Sender counter Ctr_Tx ∈ ℕ
        Epoch bounds T_max = 86400 s, N_max = 2^20
        Plaintext payload m
        Associated data AD = DeviceID ∥ EpochID ∥ Nonce_i
Output: (Nonce_i, CT, TAG) or EPOCH_EXPIRED

1:  IF CurrentTime > T_max OR Ctr_Tx ≥ N_max THEN
2:      ZeroizeAndRenew(MS, Ctr_Tx, Ctr_Rx)           ▷ Phase 4 — trigger re-key
3:      RETURN EPOCH_EXPIRED
4:  END IF
5:  Ctr_Tx ← Ctr_Tx + 1                               ▷ Strictly monotonic increment
6:  Nonce_i ← Ctr_Tx                                   ▷ 64-bit counter as packet nonce
7:  SK_i ← HKDF-SHA256(MS, Nonce_i)                    ▷ RFC 5869 — per-packet session key
8:  (CT, TAG) ← AES-256-GCM-Enc(SK_i, Nonce_i, m, AD) ▷ NIST SP 800-38D
9:  RETURN (Nonce_i, CT, TAG)
```

**Complexity:** O(1) per packet — no post-quantum operations.
**Cost:** ≈ 0.068 ms/packet (HKDF ≈ 0.021 ms + AES-GCM ≈ 0.047 ms, empirically measured).

---

### Algorithm 8 — SAKE Tier 2: Receiver-Side Authenticated Decryption

```
Algorithm 8: SAKE-Tier2-Receiver(MS, Ctr_Rx, Nonce_i, CT, TAG, AD)
────────────────────────────────────────────────────────────────────
Input:  Master Secret MS ∈ {0,1}^256
        Receiver counter Ctr_Rx ∈ ℕ
        Received packet (Nonce_i, CT, TAG)
        Associated data AD = DeviceID ∥ EpochID ∥ Nonce_i
Output: Decrypted plaintext m  OR  ⊥ (reject)

1:  IF Nonce_i ≤ Ctr_Rx THEN                           ▷ Replay / duplicate guard
2:      RETURN ⊥                                        ▷ DROP — no MAC check, no decryption
3:  END IF
4:  SK_i ← HKDF-SHA256(MS, Nonce_i)                    ▷ RFC 5869 — deterministic key recovery
5:  m ← AES-256-GCM-Dec(SK_i, Nonce_i, CT, TAG, AD)    ▷ MAC verified BEFORE decryption
6:  IF m = ⊥ THEN                                       ▷ TAG mismatch — tampered packet
7:      RETURN ⊥
8:  END IF
9:  Ctr_Rx ← Nonce_i                                   ▷ State update ONLY after authentication
10: RETURN m
```

**Complexity:** O(1) per packet.
**Security:** Line 1 gives Pr[replay accepted] = 0 (Proof 2). Line 5 MAC-before-decrypt gives IND-CCA2 (Proof 1).

---

### Supporting Procedure — ZeroizeAndRenew (Phase 4)

```
Procedure ZeroizeAndRenew(MS, Ctr_Tx, Ctr_Rx):
───────────────────────────────────────────────
1:  MS ← 0^{32}                 ▷ Overwrite 256-bit MS with zero-vector
2:  Erase MS, Ctr_Tx, Ctr_Rx   ▷ Clear all epoch state from volatile RAM
3:  Trigger Algorithm 1–6       ▷ Begin new epoch (Phase 1)
```

**Hardware note:** Requires `memset_s()` per NIST SP 800-88 [8] / C11 Annex K on embedded deployment
to prevent RAM remnant recovery. MATLAB equivalent: `zeros(1,32,'uint8'); clear MS`.

---

### Algorithm Numbering in Paper

| Algorithm | Name | Phase | From |
|---|---|---|---|
| Algorithms 1–4 | KG, SG, BernsMul, SV | LR-IoTA (base paper) | Reused from [1] |
| Algorithm 5 | QC-LDPC KeyGen + KEP | Phase 1 (base paper) | Reused from [1] |
| Algorithm 6 | SLDSPA | Phase 1 (base paper) | Reused from [1] |
| **Algorithm 7** | **SAKE-Tier2-Sender** | **Phase 2 (novelty)** | **This work** |
| **Algorithm 8** | **SAKE-Tier2-Receiver** | **Phase 3 (novelty)** | **This work** |
| ZeroizeAndRenew | Phase 4 | Supporting procedure | This work |

---

*Gap 7 resolution — Paper-ready algorithm pseudocode for §6 LaTeX insertion*
*Format: algorithm2e compatible. Use with `\usepackage[ruled,vlined]{algorithm2e}`*
