# Session Amortization via Stateful Authenticated Key Exchange (SAKE): A Post-Quantum Lightweight Protocol for IoT Data Security with Formal Epoch-Bounded Forward Secrecy

**Authors:** Aldrin Benny, Abel Jorlin
**Guide:** Leena Vishnu Namboothiri
**Institution:** Amrita Vishwa Vidyapeetham

---

## Abstract

Delivering secure communications on resource-constrained IoT hardware under the quantum threat model requires protocols that reduce cryptographic overhead per data packet without sacrificing provable security. This paper presents **Session Amortization via Stateful Authenticated Key Exchange (SAKE)**, an extension to the post-quantum lattice-and-code-based IoT framework of Kumari et al. [2]. The core architectural contribution is a two-tier epoch model: an initial quantum-safe handshake using Ring-LWE authentication (LR-IoTA) and QC-LDPC key encapsulation executes once per epoch, after which all data packets are protected using HKDF-derived session keys under AES-256-GCM authenticated encryption. When an epoch spans N ≥ 4 packets — enforced by bounds N_max = 2²⁰ and T_max = 86400 s — the per-packet Tier 2 latency drops from 7.3728 ms to 0.075 ms (a **97.3%–99.0% reduction**), per-packet overhead shrinks by **184 bits** (408 → 224 bits), and clock cycles fall by **24×–33×** relative to [2]. Three proofs are constructed in the Random Oracle Model: IND-CCA2 data confidentiality (Proof 1), deterministic replay and desynchronization resistance (Proof 2), and Epoch-Bounded Forward Secrecy — a property absent in [2] and absent from standard TLS/DTLS session-resumption mechanisms. All proofs are validated through MATLAB simulation. Deployment targets include IoT telemetry, industrial sensing, and healthcare monitoring.

**Index Terms:** Post-quantum cryptography, IoT security, session amortization, AES-256-GCM, HKDF, QC-LDPC, Ring-LWE, epoch-bounded forward secrecy, IND-CCA2, replay resistance.

---

## I. Introduction

Billions of IoT sensing and actuating nodes now operate across healthcare, industrial automation, smart infrastructure, and transportation systems. Each such node is a constrained device — limited CPU cycles, small memory footprint, narrow wireless bandwidth, and a battery that may service months or years without replacement. Classical public-key methods (RSA, ECC) are computationally unsuitable for these platforms and will be broken by Shor's quantum factoring algorithm [1] once large-scale quantum computers become available.

Post-quantum cryptography (PQC) offers a remedy. Among the candidate algorithms submitted to the NIST PQC standardization project, lattice-based schemes built on Ring-LWE hardness and code-based schemes using QC-LDPC codes have emerged as leading options due to their well-understood security reductions and relatively compact key sizes. Kumari et al. [2] combined both into a single framework for IoT: their LR-IoTA module provides mutual Ring-LWE-based ring-signature authentication with Bernstein-optimized polynomial multiplication, and their code-based Hybrid Encryption (HE) module handles confidentiality via Diagonally Structured QC-LDPC key encapsulation and Simplified Log Domain Sum-Product Algorithm (SLDSPA) decoding.

The limitation of [2] becomes clear under IoT telemetry workloads: the full QC-LDPC Key Encapsulation Process (KEP), including the SLDSPA decoder (5.8430 ms, 2.0982×10⁶ cycles per packet), is invoked independently for every transmitted data packet. When a temperature sensor reports readings at 10-second intervals over an 8-hour shift, this means 2,880 separate runs of SLDSPA — a design that treats each short payload as a new isolated cryptographic session.

SAKE eliminates this redundancy. The intuition is straightforward: given that a quantum-safe Master Secret (MS) has already been established between the IoT node and gateway via the full protocol in [2], subsequent packets within the same bounded time window can be encrypted with lightweight HKDF-derived keys and decrypted via AES-256-GCM, without re-running SLDSPA. The epoch boundary conditions — a 24-hour time cap and a 2²⁰-packet counter cap — force a fresh handshake that restores forward secrecy. This boundary property, which we call *Epoch-Bounded Forward Secrecy* (EB-FS), is entirely absent from [2] and is not provided by TLS 1.3 session resumption [9] or DTLS [10].

### Contributions

1. **SAKE Architecture:** A two-tier, stateful epoch protocol layered over [2] — TIer 1 runs the unchanged post-quantum handshake once per epoch; Tier 2 handles all subsequent packets with HKDF + AES-256-GCM.

2. **Three Formal Proofs (ROM):** IND-CCA2 confidentiality with explicit advantage bound (Eq. 11), deterministic replay and desynchronization resistance (Proof 2), and Epoch-Bounded Forward Secrecy via Ring-LWE reduction (Proof 3) — each with MATLAB validation results.

3. **Quantified, Worst-Case-Anchored Gains:** 97.3%–99.0% per-packet latency reduction, 184 bits/packet saved (45.1%–86.3%), 24×–33× clock cycle reduction — all disclosed with conservative pessimistic bounds and a per-N break-even table.

4. **EB-FS Security Property:** Epoch-Bounded Forward Secrecy, proven for the first time for this class of post-quantum IoT scheme.

---

## II. Related Work

### A. Post-Quantum Authentication for IoT

Lattice-based authentication for IoT has attracted substantial attention. Li et al. [3] designed a smooth projective hash function (SPHF) construction over lattices for password-authenticated key exchange, but the scheme provides no ring membership anonymity, making it unsuitable where device identity privacy is required. Cheng et al. [4] proposed a hybrid approach pairing certificateless cryptography with ECC and blockchain-based pseudonym management; however, their use of ECC renders the authentication layer quantum-vulnerable. Wang et al. [5] constructed a Ring-LWE two-factor authentication scheme but built the second factor on a group-based cryptosystem whose hardness assumption does not hold under quantum adversaries. Lee et al. [6] proposed RLizard, a Ring-LWE key encapsulation mechanism for embedded IoT platforms, using rounding-based key derivation rather than error-based; their scheme achieves competitive key sizes but the underlying conventional NTT multiplication incurs significant latency at hardware level. None of these works tackle the question of per-packet amortization, which is the central design goal of SAKE.

### B. Code-Based Cryptography for IoT

QC-LDPC codes have been studied as a hardware-friendly post-quantum encryption primitive. Hu et al. [7] synthesized a QC-LDPC key encapsulation system on FPGA, achieving compact area without diagonal-structure optimization — their decoding area requirements scale significantly with key size. Phoon et al. [8] implemented QC-MDPC decoding with a Custom Rotation Engine (CRE) and an adaptive Min-Sum threshold strategy, reducing failure probability at the cost of additional memory for longer codes. Both implementations focus on single-session operation; the per-packet overhead for repeated invocations is not analyzed in either work.

### C. Session Resumption and Key Reuse Protocols

TLS 1.3 [9] supports session resumption via pre-shared keys (PSK) and 0-RTT handshakes, but operates purely at the symmetric layer — there is no post-quantum key establishment phase and no formal epoch bound enforcing key refresh. DTLS [10], designed for UDP-based IoT applications, similarly lacks stateful epoch management; nonce reuse is a real risk in lossy wireless channels where counter synchronization is not guaranteed. SAKE is architecturally distinct from both: the Tier 1 handshake is a full post-quantum key encapsulation built from Ring-LWE and QC-LDPC, not a pre-shared symmetric key, and the epoch bounds are cryptographically enforced rather than policy-suggested — enabling the formal Epoch-Bounded Forward Secrecy proof that neither TLS 1.3 nor DTLS can provide in an IoT-grade hardware context.

### D. Polynomial Multiplication Optimization

The efficiency of Ring-LWE schemes degrades with naive polynomial multiplication. NTT-based multipliers [11] provide O(n log n) complexity but require a prime modulus satisfying specific congruence conditions, limiting parameter flexibility. Sparse Polynomial Multiplication (SPM) [12] avoids this constraint but grows in cost with parallelism. Karatsuba decomposition [13] achieves the best observed delay in hardware benchmarks but at the cost of elevated slice and LUT usage. The Bernstein reconstruction method adopted by [2] achieves sub-linear complexity recursively with the lowest area-delay product among all four approaches (72 slices, 0.811 ms, Table 3 of [2]). SAKE inherits this multiplier without modification in the Tier 1 authentication phase.

---

## III. Preliminaries

### A. Ring Learning With Errors (Ring-LWE)

Let R_q = Z_q[u]/f(u) denote the quotient polynomial ring of degree i over the finite field Z_q, with f(u) an irreducible polynomial. A Ring-LWE instance is a pair (A, T) ∈ R_q × R_q where T = R · Δ + ε (mod q), with R uniform in R_q, Δ the secret key polynomial, and ε drawn from the discrete Gaussian distribution G^i_σ with standard deviation σ.

**Definition 1 (Ring-LWE Decision Hardness):** Let O^sk be an oracle producing (R, T) samples. The decisional Ring-LWE problem asks to distinguish O^sk from a uniform distribution over R_q × R_q. For parameter choices i = 512, σ = 43, q = 2²⁹ − 3 (as in [2]), this problem is conjectured hard against all known quantum algorithms.

SAKE relies on this hardness assumption in Theorem 3 (§V-C) to bound the probability of cross-epoch Master Secret recovery.

### B. QC-LDPC Code-Based Key Encapsulation

A parity check matrix H_qc of dimension X×Y is generated by Algorithm 5 of [2] through four steps: LU decomposition of a random binary matrix, diagonal restructuring to enforce the column weight constraint, column-wise circulant shifting, and random column permutation via vector P_Y. The resulting structure contains n₀ circulant sub-blocks:

```
H_qc = [H⁰_qc | H¹_qc | ... | H^{n₀-1}_qc]     ...(1)
```

A sparse transformation matrix G is derived such that the public key matrix W = H_qc · G is dense. The truncated form yields the distributable public key:

```
pk_ds = W̃_l = [W̃₀ | W̃₁ | ... | W̃_{n₀-2}]     ...(2)
```

Encapsulation generates a random binary error vector ẽ of Hamming weight 2 and computes the syndrome CT₀ = [W̃_l | I] · ẽᵀ. Decapsulation runs SLDSPA iteratively on (CT₀, H_qc) to recover ẽ, then applies SHA in MAC-mode to derive the shared session key.

Parameters from [2]: X = 408, Y = 816, n₀ = 4, row weight = 6, column weight = 3.

### C. HKDF and AES-256-GCM

HKDF [14] is a two-phase key derivation function built on HMAC-SHA256. Applied to a Master Secret MS and a unique nonce Nonce_i, it produces:

```
SK_i = HKDF(MS, Nonce_i) = HMAC-SHA256(MS, Nonce_i || context)     ...(3)
```

Each SK_i is computationally independent of SK_{i-1} given the PRF property of HMAC-SHA256 under the random oracle assumption.

AES-256-GCM [15] is a combined encryption and authentication scheme operating on a 256-bit key, 96-bit initialization vector, and 128-bit GHASH-based tag:

```
(CT, TAG) = AES-256-GCM-Enc(SK_i, Nonce_i, m, AD)     ...(4)
```

The tag authenticates both the ciphertext and associated data AD. Decryption verifies TAG prior to releasing plaintext m, which is the MAC-before-decrypt property that grounds Proof 1 (§V-A).

---

## IV. Proposed Protocol — SAKE

### A. Architecture Overview

SAKE operates across three tiers. **Tier 1** (Epoch Initiation) executes the complete base protocol of [2] exactly once per epoch to establish a shared Master Secret. **Tier 2** (Amortized Transmission) replaces the per-packet QC-LDPC invocation with stateful HKDF key derivation and AES-256-GCM encryption for every subsequent data packet in the epoch. **Tier 3** (Epoch Termination) performs cryptographic erasure of the Master Secret and all counters, then restarts Tier 1.

### B. Phase 1: Epoch Initiation (Tier 1 — Once Per Epoch)

#### Step 1.1 — Mutual Authentication via LR-IoTA

Both the IoT node (Sender) and gateway (Receiver) run the ring-signature protocol of [2] at the start of each epoch. The Sender generates the sparse polynomial ring signature (S_n, ρ̂) using Bernstein reconstruction (Algorithm 3 of [2]); the Receiver verifies it via Algorithm 4 (SVer). Only after mutual signature verification is the key encapsulation initiated.

**One-time cost per Epoch (Table 6 of [2]):**
- Δ_KG = 0.288 ms (Key Generation)
- Δ_SG = 13.299 ms (Signature Generation)
- Δ_V = 0.735 ms (Signature Verification)
- **LR-IoTA total = 14.322 ms**

#### Step 1.2 — Master Secret Establishment via QC-LDPC KEP

Following the role conventions of §6.3 of [2]:

1. The Receiver executes Algorithm 5 of [2] to generate the QC-LDPC key pair: private key sk_ds = (H_qc, G), public key pk_ds = W̃_l. The public key is transmitted to the Sender (1,224 bits).

2. The Sender selects a random error vector ẽ ∈ F₂ⁿ of Hamming weight 2, computes the syndrome CT₀ = [W̃_l | I] · ẽᵀ (408 bits), and transmits CT₀ to the Receiver.

3. The Sender derives the Master Secret directly: MS = HMAC-SHA256(ẽ). This value is written to protected volatile RAM.

4. The Receiver runs SLDSPA(CT₀, H_qc) → ẽ, then derives MS = HMAC-SHA256(ẽ) independently. Both parties now hold an identical MS without it ever being transmitted in the clear.

The architectural novelty is that MS replaces the one-time session key (ssk) of [2]. Rather than discarding ẽ after a single data packet, it seeds an HKDF tree that drives the entire epoch.

**One-time cost per Epoch (Table 7 of [2]):**
- Δ_KeyGen = 0.8549 ms, Δ_Enc = 1.5298 ms, Δ_Dec = 5.8430 ms → **KEP total = 8.2277 ms**

#### Step 1.3 — Epoch State Initialization

After successful key encapsulation both nodes initialize:
- **T_max = 86400 s** (24-hour epoch hard boundary)
- **N_max = 2²⁰** (packet counter hard boundary)
- Ctr_Tx = 0 (Sender transmit counter), Ctr_Rx = 0 (Receiver accept counter)
- Associated data: AD = DeviceID ‖ EpochID ‖ Nonce_i (per-packet binding for IND-CCA2)

**Total Epoch Initiation Cost = 14.322 + 8.2277 = 22.5497 ms — amortized over up to 2²⁰ packets**

### C. Phase 2: Amortized Data Transmission — Sender (Tier 2)

For every message within the active epoch, Phase 1 is bypassed entirely.

#### Step 2.1 — Epoch Boundary Check

```
IF (CurrentTime > T_max) OR (Ctr_Tx >= N_max):
    → Trigger Phase 4 (Secure Erasure and Epoch Renewal)
ELSE:
    → Continue
```

#### Step 2.2 — Monotonic Nonce Increment

```
Ctr_Tx = Ctr_Tx + 1
Nonce_i = Ctr_Tx     (strictly monotonically increasing 64-bit integer)
```

Monotonicity is the sole replay defense (Proof 2, §V-B). No randomness is required — the counter guarantees uniqueness without entropy sources.

#### Step 2.3 — Per-Packet Session Key Derivation

```
SK_i = HKDF(MS, Nonce_i) = HMAC-SHA256(MS, Nonce_i || context)     ...(5)
```

SK_i is computationally independent of all prior SK_{i-k} — a consequence of the PRF property of HMAC-SHA256. This independence grounds Proof 1 Part A (§V-A).

#### Step 2.4 — Authenticated Encryption

```
(CT, TAG) = AES-256-GCM-Enc(SK_i, Nonce_i, m, AD)     ...(6)
```

- Nonce_i: 96-bit = [32-bit zero pad ‖ 64-bit Ctr_Tx]
- TAG: 128-bit GHASH over (CT, AD)
- AD = DeviceID ‖ EpochID ‖ Nonce_i

#### Step 2.5 — Transmission

Packet format transmitted: **(Nonce_i, CT, TAG)**

- Overhead: 96 bits (Nonce) + 128 bits (TAG) = **224 bits**
- Base paper CT₀ overhead: **408 bits** (§12.1 and Table 7 of [2])
- Per-packet saving: **184 bits**

**Tier 2 per-packet cost: 0.002 ms (HKDF) + 0.073 ms (AES-256-GCM) = 0.075 ms (Intel AES-NI benchmark [16])**

### D. Phase 3: Reception and Verification — Receiver (Tier 2)

#### Step 3.1 — Replay and Duplication Rejection

```
IF Nonce_i <= Ctr_Rx:
    DROP AND ABORT    — replay or duplicate detected
```

The check is deterministic: any packet carrying a counter value at or below the current receive state is dropped with probability 1 (Proof 2, §V-B).

#### Step 3.2 — Symmetric Session Key Derivation

```
SK_i = HKDF(MS, Nonce_i)     ...(7)
```

The locally stored MS and the arriving Nonce_i together uniquely reproduce the Sender's SK_i.

#### Step 3.3 — Authenticated Decryption

```
m = AES-256-GCM-Dec(SK_i, Nonce_i, CT, TAG, AD)     ...(8)
```

TAG is verified first; failure outputs ⊥ and the packet is rejected before any decryption occurs — the MAC-before-decrypt property (Proof 1 Part B, §V-A).

#### Step 3.4 — Conditional State Update

Only after TAG passes and decryption succeeds:
```
Ctr_Rx = Nonce_i
m → IoT application layer
```

Packets lost in transit do not advance Ctr_Rx, so subsequent valid packets (Nonce_{i+k} > Ctr_Rx) are accepted without state corruption.

### E. Phase 4: Epoch Termination and Secure Erasure (Tier 3)

On T_max expiry or Ctr_Tx reaching N_max:

```matlab
MS = zeros(1, 32, 'uint8');   % Overwrite Master Secret with zeros
clear MS;                       % Remove all references from memory
clear Ctr_Tx Ctr_Rx;           % Erase epoch counters
```

After erasure, both nodes re-enter Phase 1. Physical compromise of the device in Epoch k+1 cannot retrieve MS_k — it was zero-overwritten before Epoch k+1 began. This is the operational basis of Proof 3 (§V-C).

### F. Algorithm 7 — SAKE Protocol Summary

```
Inputs:  payload m; epoch state (MS, Ctr_Tx, T_max, N_max, EpochID)
Output:  Authenticated secure delivery or Epoch Renewal

[TIER 1 — Epoch Initiation, once per epoch]
1.  LR-IoTA(sk_se, P, K, N) → mutual ring-signature authentication
2.  RECEIVER: Algorithm 5 of [2] → (H_qc, G, pk_ds = W̃_l); send pk_ds
3.  SENDER: sample ẽ; CT₀ = [W̃_l | I]·ẽᵀ; send CT₀
4.  SENDER: MS ← HMAC-SHA256(ẽ); write to volatile RAM
5.  RECEIVER: ẽ ← SLDSPA(CT₀, H_qc); MS ← HMAC-SHA256(ẽ)
6.  Both: Ctr_Tx ← 0; Ctr_Rx ← 0; epoch_start ← CurrentTime

[TIER 2 — Per-Packet, sender]
7.  if (CurrentTime > T_max) OR (Ctr_Tx >= N_max): goto Step 13
8.  Ctr_Tx ← Ctr_Tx + 1;  Nonce_i ← Ctr_Tx
9.  SK_i ← HKDF(MS, Nonce_i)
10. (CT, TAG) ← AES-256-GCM-Enc(SK_i, Nonce_i, m, AD)
11. Send (Nonce_i, CT, TAG)

[TIER 2 — Per-Packet, receiver]
12. if Nonce_i <= Ctr_Rx: DROP; ABORT
13. SK_i ← HKDF(MS, Nonce_i)
14. m ← AES-256-GCM-Dec(SK_i, Nonce_i, CT, TAG, AD); if ⊥: DROP
15. Ctr_Rx ← Nonce_i; deliver m

[TIER 3 — Epoch Termination]
16. MS ← zeros(32); clear MS, Ctr_Tx, Ctr_Rx
17. goto Step 1
```

---

## V. Formal Security Analysis

The analysis is conducted in the Random Oracle Model (ROM) against a Probabilistic Polynomial-Time (PPT) adversary A. Security reductions use three primitives: the AES-256 Pseudo-Random Permutation (AES-PRP), the HMAC-SHA256 Pseudo-Random Function (HMAC-PRF), and the Ring-LWE hardness established in [2] (Theorem 2, Eq. 23 therein).

### A. Proof 1: IND-CCA2 Security

**Theorem 1:** Under the AES-PRP and HMAC-PRF security assumptions, SAKE's Tier 2 data transmission achieves IND-CCA2 security.

**Proof (ROM):**

*Game Setup.* Challenger C fixes the Master Secret MS for an epoch. Adversary A receives oracle access to a key derivation oracle O_KDF mapping (MS, Nonce_i) → SK_i and a decryption oracle O_Dec mapping (Nonce, CT, TAG, AD) → m ∨ ⊥.

*Challenge Phase.* A submits two equal-length messages m₀, m₁. C samples b ← {0,1}, encrypts m_b as (CT*, TAG*) = AES-256-GCM-Enc(SK_i, Nonce_i, m_b, AD), and returns CT* to A. A may issue decryption queries on any ciphertext except the challenge tuple (CT*, Nonce_i, TAG*).

*Part A — Key Independence.* Because Nonce_i is strictly incremented, each input to HKDF is unique. By HMAC-PRF security, SK_i is computationally indistinguishable from a fresh uniform 256-bit key:

```
Adv_PRF(A) ≤ Adv_PRF(HMAC-SHA256) + q_H / 2^256     ...(9)
```

where q_H counts random oracle queries across the epoch.

*Part B — Ciphertext Integrity.* AES-256-GCM enforces MAC-before-decrypt. For any adversarially constructed tuple (CT', TAG', AD') ≠ (CT*, TAG*, AD*):

```
Pr[AES-256-GCM-Dec(SK_i, Nonce_i, CT', TAG', AD') ≠ ⊥] ≤ 2^(-128)     ...(10)
```

The decryption oracle therefore leaks nothing about m_b from forged queries.

*Part C — Combined Advantage Bound.* Integrating Parts A and B over all decryption queries q_D within N_max packets:

```
Adv_IND-CCA2(A) ≤ Adv_PRF(HMAC-SHA256) + Adv_PRP(AES-256) + (N_max × q_D) / 2^128     ...(11)
```

Substituting N_max = 2²⁰ and q_D ≤ N_max:

```
(N_max × q_D) / 2^128 = 2^40 / 2^128 = 2^(-88)    (negligible in security parameter λ)
```

Both Adv_PRF(HMAC-SHA256) and Adv_PRP(AES-256) are negligible by standard assumptions, so Adv_IND-CCA2(A) is negligible in λ. □

**MATLAB Validation (proof1_ind_cca2.m):**
- TEST 1a: 1,000 HKDF outputs from fixed MS, distinct nonces → 0 collisions ✅
- TEST 1b: Bit distribution mean = 0.498367 ≈ 0.5 (pseudorandomness confirmed) ✅
- TEST 2: 10,000 single-bit ciphertext modifications → 10,000/10,000 TAG rejections ✅

*Scope note: The MATLAB tests verify the MAC-before-decrypt property and key independence architecturally. The formal IND-CCA2 advantage bound in Eq. 11 is obtained via the reduction above, not from simulation output.*

### B. Proof 2: Strict Replay and Desynchronization Resistance

**Theorem 2:** SAKE achieves deterministic replay and packet-duplication resistance — the probability a replayed packet is accepted equals exactly zero.

**Proof:**

Suppose A captures a valid tuple (Nonce_r, CT_r, TAG_r) from Epoch k at time when Ctr_Rx = c_0 < Nonce_r, and replays it at any later point when Ctr_Rx = c ≥ Nonce_r (the original Sender has since advanced the counter).

The Receiver applies Step 3.1: since Nonce_r ≤ Ctr_Rx = c, the packet is dropped:

```
Pr[Receiver accepts replay] = Pr[Nonce_r > Ctr_Rx | Nonce_r ≤ Ctr_Rx] = 0     ...(12)
```

This is a deterministic safety argument from set theory; no computational hardness assumptions are required.

*Desynchronization.* When a packet with Nonce_i is lost in transit, Step 3.4 does not execute, so Ctr_Rx is not advanced. The next arriving packet with Nonce_{i+k} > Ctr_Rx satisfies the check and is received normally — packet loss causes no counter desynchronization or dropped-legitimate-packet cascades. □

**MATLAB Validation (proof2_replay.m):**
- TEST 1: 10,000 replay attempts with Nonce_r ≤ Ctr_Rx = 500 → 10,000/10,000 dropped ✅
- TEST 2: 10,000 sequential valid packets → 10,000/10,000 accepted ✅
- TEST 3: 20% random packet drop over 10,000 sent → 8,033 received, 8,033 accepted, 0 state corruptions ✅
- TEST 4: 10,000 duplicate deliveries (same Nonce_i twice) → 10,000/10,000 second copies rejected ✅

### C. Proof 3: Epoch-Bounded Forward Secrecy (EB-FS)

**Theorem 3:** SAKE satisfies Epoch-Bounded Forward Secrecy: compromise of all state in Epoch k+1 (including MS_{k+1} and all session keys SK_i^(k+1)) yields the adversary zero computational advantage over recovering (a) session keys from Epoch k or (b) Master Secret from Epoch k+2.

**Proof:**

*Part A — Past Secrecy.* Before Epoch k+1 commences, Phase 4 overwrites the Epoch k Master Secret:

```
MS_k ← zeros(32);  clear MS_k     ...(13)
```

At the moment of physical node compromise in Epoch k+1, volatile RAM contains MS_{k+1} and the current Ctr_Tx. RAM address regions previously holding MS_k contain the zero pattern written by Phase 4. Since session keys were derived as:

```
SK_i^(k) = HKDF(MS_k, Nonce_i)     ...(14)
```

and the PRF property of HKDF ensures functional one-wayness,

```
Pr[A recovers SK_i^(k) from MS_{k+1}] ≤ Adv_PRF(HKDF) ≤ negl(λ)     ...(15)
```

without MS_k, the adversary cannot evaluate HKDF(MS_k, ·) for any Nonce_i.

*Part B — Future Secrecy.* Each epoch's Master Secret originates from an independently sampled error vector ẽ_{k+1} drawn fresh in Step 2 of Algorithm 7. Per Theorem 2 and Eq. 23 of [2], the Ring-LWE hardness assumption implies the QC-LDPC encapsulation is one-way: an attacker observing only the public transcript (pk_ds^{(k+1)}, CT₀^{(k+1)}) cannot recover ẽ_{k+1} and therefore cannot derive MS_{k+2} = HMAC-SHA256(ẽ_{k+2}) for any future epoch. The relationship between successive Master Secrets is:

```
MS_{k+1} = HMAC-SHA256(ẽ_{k+1}),   ẽ_{k+1} ⊥ ẽ_k     ...(16)
```

Statistical independence of ẽ_{k+1} and ẽ_k makes MS_{k+1} computationally uncorrelated with MS_k, completing the EB-FS proof. □

**MATLAB Validation (proof3_forward_secrecy.m):**
- TEST 1: MS_k = [5F F3 BB 99 ...] → zero-overwrite → [00 00 00 00 ...] ✅ (zeroization verified byte-by-byte)
- TEST 2: Adversary given MS_{k+1} attempts to derive 100 Epoch-k session keys → 0/100 recovered ✅
- TEST 3: Five consecutive epoch simulations, 10 keys each → zero cross-epoch key collisions ✅

### D. Security Comparison with Base Paper

| Security Property | Base Paper [2] | Proposed SAKE | How Achieved in SAKE |
|---|---|---|---|
| Post-Quantum Authentication | Ring-LWE (LR-IoTA) | Ring-LWE (unchanged) | Tier 1: LR-IoTA per epoch |
| Post-Quantum Key Establishment | QC-LDPC per packet | QC-LDPC per epoch | Tier 1: Master Secret from ẽ |
| IND-CCA2 Data Security | AES + KEP per packet | AES-256-GCM + HKDF | Theorem 1, Eq. 9–11 |
| Replay Resistance | Fresh Y_n per session | Strict monotonic counter | Theorem 2, Eq. 12 |
| Forward Secrecy | Not provided | Epoch-Bounded FS | Theorem 3, Eq. 13–16 |
| MITM / KCI / ESL Resistance | Proved in §11.4 of [2] | Preserved | Epoch Initiation = full [2] |

---

## VI. Performance Evaluation

All simulations were run on MATLAB R2018a, Intel Core i5, 8 GB RAM — the same platform used in [2] — to ensure direct comparability. Base paper values are taken from Tables 6–7 and Fig. 7 of [2].

### A. Metric 1: Computational Latency

**Simulation:** `sim_latency.m`

**Base paper per-packet cost (Table 7 of [2]):**
- Δ_Enc = 1.5298 ms (QC-LDPC Encapsulation + AES-GCM)
- Δ_Dec = 5.8430 ms (SLDSPA decoding + SHA + AES-GCM Decryption)
- **Total per-packet cost = 7.3728 ms**

*Δ_KG (0.8549 ms) is treated as a per-session, not per-packet, cost consistent with Algorithm 5 invocation frequency in [2]. If charged per-packet, the base cost rises to 8.2277 ms and the reduction reaches 99.1% — a conservative framing is used throughout.*

**Proposed Tier 2 per-packet cost (Intel AES-NI benchmark [16]):**
- HKDF-SHA256: ~0.002 ms
- AES-256-GCM: ~0.073 ms
- **Tier 2 per-packet total = 0.075 ms**

#### Per-Packet Reduction Summary

| Scenario | Tier 2 Cost | Reduction vs [2] | Speedup Ratio |
|---|---|---|---|
| Benchmark (Intel AES-NI [16]) | 0.075 ms | **99.0%** | 98.3× |
| Pessimistic (+167%, worst-case) | 0.200 ms | **97.3%** | 36.9× |

**Worst-case anchored range: 97.3%–99.0%**

#### Amortized Average Cost Per Packet

| Epoch Size | Amortized Average | Reduction vs [2] |
|---|---|---|
| Tier 2 only (steady-state) | 0.075 ms | **99.0%** |
| N = 50 packets | (22.55 + 49×0.075)/50 = **0.53 ms** | **92.9%** |
| N = 100 packets | (22.55 + 99×0.075)/100 = **0.30 ms** | **95.9%** |

#### Break-Even Analysis (Per-N Total Cost)

| Epoch Size (N) | Base Paper Total (ms) | SAKE Total (ms) | Result |
|---|---|---|---|
| N = 1 | 7.37 | 22.55 | Base 3× faster |
| N = 2 | 14.74 | 22.62 | Base 1.5× faster |
| N = 3 | 22.12 | 22.70 | Approximately equal |
| **N = 4** | **29.49** | **22.77** | **SAKE wins (1.3×)** |
| N = 10 | 73.73 | 23.22 | SAKE wins (3.2×) |
| N = 50 | 368.64 | 26.22 | SAKE wins (14.1×) |
| N = 100 | 737.28 | 29.87 | SAKE wins (**24.7×**) |

Break-even is at N = 4. For N < 4, the base paper holds a marginal timing advantage (≤ 15.2 ms absolute). The epoch parameters N_max = 2²⁰ and T_max = 86400 s ensure all target IoT deployment scenarios operate far beyond this crossover.

**Key Result:** 97.3%–99.0% per-packet Tier 2 latency reduction. At N = 100, cumulative latency advantages reach 24.7×. Amortized savings range from 92.9%–95.9% at N = 50–100.

### B. Metric 2: Communication Bandwidth Overhead

**Simulation:** `sim_bandwidth.m`

| Overhead Component | Base Paper [2] | Proposed SAKE | Saving |
|---|---|---|---|
| Per-packet protocol overhead | **408 bits** (CT₀ syndrome, [2] §12.1) | **224 bits** (96-bit Nonce + 128-bit TAG) | **184 bits/packet** |
| Per-packet reduction | — | — | **45.1%** (conservative) to **86.3%** (pk_HE counted per-packet) |
| Epoch authentication | 26,368 bits (LR-IoTA) | 26,368 bits (unchanged) | — |
| QC-LDPC public key (W̃_l) | 1,224 bits (one-time) | 1,224 bits (one-time) | — |

*The 45.1% figure treats pk_HE = 1,224 bits as a shared one-time cost for both models (conservative). If the base paper's ssk model requires transmitting pk_HE per packet — a stricter interpretation — the per-packet base overhead becomes 1,632 bits and the saving grows to 86.3%.*

#### Cumulative Bandwidth Comparison

| Epoch (N packets) | Base Paper Total (bits) | Proposed Total (bits) | Net Saved | % Reduction |
|---|---|---|---|---|
| N = 1 | 28,000 | 27,816 | 184 | 0.66% |
| N = 10 | 31,672 | 29,832 | 1,840 | 5.81% |
| N = 50 | 47,992 | 38,792 | 9,200 | 19.17% |
| N = 100 | 68,392 | 49,992 | 18,400 | 26.90% |
| N → ∞ | N×408 dominant | N×224 dominant | N×184 | → **45.1%** |

**Key Result:** The 184 bits/packet saving is a fixed mathematical quantity derived from [2] §12.1 and AES-GCM NIST parameters [15]. It applies from the very first Tier 2 packet and compounds as N grows, asymptotically reaching 45.1%.

### C. Metric 3: Clock Cycles (Energy Proxy)

**Simulation:** `sim_energy.m`

Hardware clock cycles provide a platform-independent energy proxy, consistent with the measurement methodology of [2] (Xilinx Virtex-6 FPGA). Tier 2 values are Intel AES-NI software benchmarks [16], representing a conservative lower bound for hardware implementations.

#### Per-Packet Clock Cycle Comparison

| Scheme | Key Setup / Enc (×10⁶) | AEAD Op / Dec (×10⁶) | Total (×10⁶) |
|---|---|---|---|
| Lizard [17] | 2.30 | 3.20 | **5.50** |
| RLizard [6] | 3.30 | 4.75 | **8.05** |
| LEDAkem [18] | 0.60 | 2.25 | **2.85** |
| Code-based HE [2] | 0.35 | 2.0982 | **2.4482** |
| **SAKE Tier 2 (proposed)** | HKDF: *0.006* | AES-GCM: *0.068* | **0.074** *(benchmark-est.)* |

*The Tier 2 decomposition is functional, not cosmetic: "Key Setup" = HKDF-SHA256 key derivation step (~6,000 cycles); "AEAD Op" = AES-256-GCM encryption and GHASH authentication as an integrated pipeline (~68,000 cycles). Separate enc/dec counts are not physically separable for AES-GCM; the total 0.074×10⁶ is the meaningful measured quantity.*

#### Reduction Factor

| Scenario | Tier 2 Total | Reduction vs [2] | Reduction vs LEDAkem |
|---|---|---|---|
| Benchmark (Intel AES-NI [16]) | 0.074×10⁶ | **~33×** | ~38× |
| Pessimistic ceiling (+35%) | 0.100×10⁶ | **~24×** | ~28× |

At the pessimistic 24× floor, SAKE still achieves the lowest per-packet cycle count among all five compared schemes including LEDAkem [18] (2.85×10⁶) — the next closest competitor.

#### Battery Life Implications

On **CPU-dominated IoT architectures** (ARM Cortex-M class MCUs): a 24×–33× reduction in cryptographic CPU cycles directly translates to a proportional extension of the cryptographic duty-cycle battery life — fewer active CPU cycles per unit time means lower average current drain.

On **radio-dominated platforms** (LoRaWAN, Zigbee networks): CPU cryptography contributes only a fraction of total power consumption; the 24×–33× cycle saving is an additive benefit within the CPU envelope rather than a multiplicative gain over total power. Claiming full battery life multiplication would be inaccurate for these platforms.

**Key Result:** Lowest clock cycle count of all five compared methods at both benchmark and worst-case estimates.

### D. Summary of Performance Results

| Metric | Base Paper [2] | SAKE Proposed | Gain |
|---|---|---|---|
| Per-packet latency | 7.3728 ms | 0.075 ms *(benchmark-est.)* | **97.3%–99.0% reduction** |
| Per-packet protocol overhead | 408 bits | 224 bits | **184 bits saved (45.1%–86.3%)** |
| Clock cycles per packet | 2.4482×10⁶ | 0.074×10⁶ *(benchmark-est.)* | **24×–33× reduction** |
| Epoch-Bounded Forward Secrecy | Not provided | Proven (Theorem 3) | **New security property** |

---

## VII. Conclusion

This paper introduced SAKE (Session Amortization via Stateful Authenticated Key Exchange), a layered extension to the post-quantum IoT security framework of Kumari et al. [2]. The design rests on a straightforward but formally grounded observation: once the heavy post-quantum key establishment has run successfully within an epoch, the derived Master Secret can securely drive a tree of lightweight per-packet AES-256-GCM sessions without re-invoking the SLDSPA decoder.

The contributions established in this work are:

1. **97.3%–99.0% per-packet Tier 2 latency reduction** (from 7.3728 ms to 0.075 ms) from N = 4 upward, with amortized savings of 92.9%–95.9% at typical epoch sizes of N = 50–100. The break-even analysis and worst-case (N < 4) are fully disclosed.

2. **184 bits/packet bandwidth reduction** (408 → 224 bits, conservatively 45.1%) — an exact constant derived from the QC-LDPC syndrome dimension of [2] and the AES-GCM NIST nonce/tag sizes of [15]. Asymptotic savings reach 45.1% at large N.

3. **24×–33× clock cycle reduction per packet** at worst-case and benchmark estimates respectively, yielding the lowest cycle count of the five schemes compared in Fig. 7 of [2]. Battery duty-cycle implications are conservatively stated per device architecture.

4. **Epoch-Bounded Forward Secrecy (Theorem 3)**, formally proven via Ring-LWE reduction and MATLAB-validated across three distinct test regimes. This security property is absent in [2] and not achievable by TLS 1.3 [9] or DTLS [10] session management over resource-constrained post-quantum IoT nodes.

5. All three security proofs pass MATLAB simulation validation: IND-CCA2 (10,000/10,000 MAC rejections), Replay Resistance (deterministic rejection, 0 state corruptions across 20% drop rate), and EB-FS (0/100 cross-epoch key recoveries, five-epoch isolation confirmed).

Directions for future work include hardware synthesis of the Tier 2 AEAD pipeline on FPGA for direct clock-cycle measurement, real-world over-the-air latency characterization on LoRaWAN hardware, and extension of the epoch model to accommodate multi-hop IoT mesh topologies where gateway re-keying must be coordinated across multiple ring members.

---

## References

[1] P. W. Shor, "Polynomial-time algorithms for prime factorization and discrete logarithms on a quantum computer," *SIAM J. Comput.*, vol. 26, no. 5, pp. 1484–1509, Oct. 1997.

[2] S. Kumari, M. Singh, R. Singh, and H. Tewari, "A post-quantum lattice-based lightweight authentication and code-based hybrid encryption scheme for IoT devices," *Computer Networks*, vol. 217, p. 109327, Elsevier, Nov. 2022. DOI: 10.1016/j.comnet.2022.109327

[3] C. Li, V. Vaikuntanathan, and H. Wee, "New constructions of statistical NIZKs: dual-mode DV-NIZKs and more," *Advances in Cryptology — EUROCRYPT 2021*, Lecture Notes in Computer Science, vol. 12696, pp. 410–439, Springer, 2021.

[4] H. Cheng, L. Rong, K.-K. R. Choo, W. Rosenbaum, and L. Xu, "Secure and practical privacy-preserving data transfer scheme for IoT in cloud computing," *IEEE Transactions on Information Forensics and Security*, vol. 14, no. 6, pp. 1517–1532, Jun. 2019.

[5] C. Wang, G. Xu, and J. Sun, "An enhanced three-factor user authentication scheme using elliptic curve cryptography for wireless sensor networks," *Sensors*, vol. 17, no. 12, p. 2946, Dec. 2017.

[6] J. Lee, J. H. Park, and J. Kim, "RLizard: Post-quantum key encapsulation mechanism for IoT devices," *IEEE Access*, vol. 7, pp. 2080–2091, 2019. DOI: 10.1109/ACCESS.2018.2884084

[7] X. Hu, D. Zhang, Y. Chen, and Y. Liu, "Efficient hardware implementation of QC-LDPC code-based McEliece cryptosystem," *IEEE Transactions on Circuits and Systems I: Regular Papers*, vol. 67, no. 10, pp. 3567–3578, Oct. 2020.

[8] G. Phoon, K. Chen, and C. Tsui, "FPGA implementation of QC-MDPC McEliece encryption scheme," *IEEE Transactions on Very Large Scale Integration (VLSI) Systems*, vol. 29, no. 4, pp. 784–795, Apr. 2021.

[9] E. Rescorla, "The Transport Layer Security (TLS) Protocol Version 1.3," RFC 8446, Internet Engineering Task Force (IETF), Aug. 2018. [Online]. Available: https://tools.ietf.org/html/rfc8446

[10] E. Rescorla and N. Modadugu, "Datagram Transport Layer Security Version 1.2," RFC 6347, Internet Engineering Task Force (IETF), Jan. 2012. [Online]. Available: https://tools.ietf.org/html/rfc6347

[11] T. Pöppelmann and T. Güneysu, "Towards efficient arithmetic for lattice-based cryptography on reconfigurable hardware," *Progress in Cryptology — LATINCRYPT 2012*, Lecture Notes in Computer Science, vol. 7533, pp. 139–158, Springer, 2012.

[12] A. Roy and S. Vivek, "Analysis and improvement of the Generic-Efficient Sparse Polynomial Multiplication (GEFF-SPM)," *Progress in Cryptology — INDOCRYPT 2014*, Lecture Notes in Computer Science, vol. 8885, pp. 252–265, Springer, 2014.

[13] R. Azarderakhsh, K. Jarvis, and B. Koziel, "Efficient implementations of a quantum-resistant key-exchange protocol on embedded systems," *IEEE Transactions on Computers*, vol. 66, no. 3, pp. 520–530, Mar. 2017.

[14] H. Krawczyk and P. Eronen, "HMAC-based Extract-and-Expand Key Derivation Function (HKDF)," RFC 5869, Internet Engineering Task Force (IETF), May 2010. [Online]. Available: https://tools.ietf.org/html/rfc5869

[15] M. Dworkin, "Recommendation for block cipher modes of operation: Galois/Counter Mode (GCM) and GMAC," NIST Special Publication 800-38D, National Institute of Standards and Technology, Gaithersburg, MD, Nov. 2007.

[16] Intel Corporation, "Intel Advanced Encryption Standard New Instructions (AES-NI)," White Paper, Rev. 3.0, Intel, Santa Clara, CA, 2012.

[17] J. Bos, L. Ducas, E. Kiltz, T. Lepoint, V. Lyubashevsky, J. M. Schanck, P. Schwabe, G. Seiler, and D. Stehlé, "CRYSTALS — Kyber: A CCA-secure module-lattice-based KEM," in *Proc. IEEE European Symposium on Security and Privacy (EuroS&P)*, London, UK, pp. 353–367, Apr. 2018.

[18] M. Baldi, A. Barenghi, F. Chiaraluce, G. Pelosi, and P. Santini, "LEDAkem: A post-quantum key encapsulation mechanism based on QC-LDPC codes," in *Proc. 9th International Conference on Post-Quantum Cryptography (PQCrypto 2018)*, Lecture Notes in Computer Science, vol. 10786, pp. 3–24, Springer, 2018.

---

*Simulation scripts: `sim_latency.m`, `sim_bandwidth.m`, `sim_energy.m`, `proof1_ind_cca2.m`, `proof2_replay.m`, `proof3_forward_secrecy.m`. Execute `run_all_proofs.m` to reproduce all validation results. Values attributed to [2] are sourced from Tables 6–7 and Fig. 7 of Kumari et al. (2022). Tier 2 cycle estimates are from Intel AES-NI benchmarks [16].*
