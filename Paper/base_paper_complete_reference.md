# Base Paper Complete Reference
## Source: `Draft/master_draft_COMPLETE.md` (Kumari et al., 2022)
## DOI: 10.1016/j.comnet.2022.109327

> **PURPOSE OF THIS FILE:**
> This file is the authoritative base paper reference for building the SAKE-IoT research paper.
> Every value, algorithm, table, and figure cited in the SAKE-IoT paper that comes from the
> base paper must trace back to this document.
>
> **DO NOT use `main.tex` as a source for base paper values.** Use this file exclusively.
>
> **Cross-reference:** Every value here was extracted from `Draft/master_draft_COMPLETE.md`
> which is itself a complete structured extraction of:
> Kumari, S., Singh, M., Singh, R., Tewari, H. (2022). "A Post-Quantum Lattice-Based Lightweight
> Authentication and Code-Based Hybrid Encryption Scheme for IoT Devices."
> *Computer Networks*, 217, 109327. Elsevier.

---

## 1. BASE PAPER IDENTITY

| Field | Value |
|---|---|
| Title | A Post-Quantum Lattice-Based Lightweight Authentication and Code-Based Hybrid Encryption Scheme for IoT Devices |
| Authors | Swati Kumari, Maninder Singh, Raman Singh, Hitesh Tewari |
| Journal | Computer Networks, Vol. 217 (2022), Elsevier |
| Article number | 109327 |
| **DOI** | **10.1016/j.comnet.2022.109327** |
| Received | 21 December 2021 |
| Revised | 18 June 2022 |
| Accepted | 25 August 2022 |
| Simulation platform | MATLAB 2018a, Xilinx Virtex-6 FPGA, Windows 10, Intel Core i5, 8 GB RAM |

---

## 2. SYSTEM OVERVIEW (Basis for SAKE §1, §2, §5)

Two tightly integrated components:
1. **LR-IoTA** — Lattice-Based Ring Signature Authentication (Ring-LWE + Bernstein polynomial multiplication)
2. **Code-based Hybrid Encryption (HE)** — Diagonally Structured QC-LDPC codes + SLDSPA decoding

**Key claim (base paper abstract):**
- Total authentication delay: **23% less** than conventional polynomial multiplication
- Hardware: **64 slices** (encoding), **640 slices** (decoding) on Xilinx Virtex-6

---

## 3. PARAMETER TABLE (Table 2 — Section 5) [FOR SAKE §4, §8]

### 3.1 LR-IoTA Authentication Parameters

| Parameter | Symbol | Value | Meaning |
|---|---|---|---|
| Polynomial degree | i (= n) | 512 | Degree of ring polynomial in R_q |
| Standard deviation (Gaussian) | σ | 43 | Gaussian error distribution std. dev. |
| Signature weight check | ω | 18 | Number of max entries of ε_n checked |
| Bound for Y_n sampling | E | 2²¹ − 1 | Uniform sampling bound for Y_n ∈ [−E, E] |
| Ring polynomial modulus | q | 2²⁹ − 3 | Prime modulus for ring R_q = Z_q[u]/(u^n+1) |
| Key acceptance bound | M = 7ωσ | 5418 | Max accumulated ε value (reject if T > M) |
| Signature acceptance bound | V = 14σ√ω̄ | 2554.069 | Rejection bound for uniform signature distribution |
| Anonymity set | N | 3 | Ring members per authentication |
| Euler's totient (ring) | j = 1024 | — | i = φ(j) = 512 |

**Security parameter rationale:**
- `m`: chosen by bound `2^m × (m choose m/2) ≥ 2^128` → 128-bit security
- E: must be `> 14√(mσ(i−1))` and power of 2
- q: must exceed `2^(2f+1+(c/n)/E)` where τ = 160

### 3.2 Code-Based HE Parameters (§10.2)

| Parameter | Symbol | Value | Meaning |
|---|---|---|---|
| QC-LDPC parity check matrix rows (H_qc) | X | 408 | Row dimension — **CT₀ = 408 bits** |
| QC-LDPC parity check matrix columns | Y | 816 | Column dimension |
| Row weight | rowweight | 6 | Non-zeros per row of H_qc |
| Column weight | colweight | 3 | Non-zeros per column of H_qc |
| Circulant matrices | n₀ | 4 | QC-LDPC structure parameter |
| Private key size | sk_ds = (H_qc, G) | — | Bit-size = n₀ × (κ + Y·log(p)) |
| Public key size | pk_ds = W̃_l | 3 × 408 = 1,224 bits | (n₀−1) × X = 3 × 408 bits |
| **CT₀ ciphertext size** | CT₀ = [W̃_l\|I] × ẽᵀ | **408 bits** | **X = 408 bits (H_qc row dimension)** |

> ⚠️ **SAKE-IoT paper critical note:** The 408-bit CT₀ is eliminated in Tier 2.
> Replaced by 224 bits (96-bit Nonce + 128-bit GCM TAG). Saving = **184 bits/packet**.

---

## 4. ALGORITHMS 1–6 COMPLETE (For SAKE §6, §4)

### 4.1 Algorithm 1 — Key Generation: KG(1^λ, R_n, N)

```
Input: public random polynomial matrix R_n, Ring IoT members N
Output: Public key pk_n, private key sk_n

1.  for n = 1 to N
2.    δ_n, ε_n ← G^i_σ           // Sample from Gaussian
3.    for n = 1 to i
4.      value[n] ← absolute(ε(n))
5.    end for
6.    Initialize T ← 0
7.    for n = 1 to ω              // ω = 18
8.      Initialize maximum ← 0; position ← 0
9.      for k ← 1 to ω
10.       if value[k] > maximum then
11.         maximum ← value[k]; position ← k
12.       end if
13.     end for
14.     value[position] ← 0
15.     T = T + value[position]
16.   end for
17.   if T > M = 7ωσ then Restart
18.   T_n ← R_n·δ_n + ε_n (mod q)  // Public key
19.   pk_n = T_n; sk_n = (δ_n, ε_n)
20. end for
21. return pk_n, sk_n
```

### 4.2 Algorithm 2 — Signature Generation: SG(sk_se, P, K, N)

```
Input: sender's sk_se, Ring members N, public key set P, R_n, keyword K
Output: signature (S_n, ρ̂)

1.  for n = 1 to N
2.    Y_n ← [−E, E]^i
3.    ν_n ← R_n·Y_n (mod q)
4.  end for
5.  ν ← add(ν₁, ν₂, ...ν_N)
6.  ρ̂ ← encode(ρ̂) = ⌊ν⌋_{f,q} concat K
7.  ρ̂ ← SHA(⌊ν⌋_{f,q}, K)            // Hash with SHA
8.  if n ≠ se then
9.     S_n = R_n·Y_n + pk_n·ρ̂          // Ring members ...(3)
10. else (n = se):
11.    S_se = (Y_se + sk_se·ρ̂)·R_se   // Sender ...(2)
12. end if
13. ω̂ ← ν_n − ε_n·ρ̂ (mod q)
14. if |⌊ω̂_n⌋_{2f}| > 2^{f−1} − M AND S_n ≤ E − V: Restart
15. return (S_n, ρ̂)
```

**Polynomial multiplications requiring Bernstein optimization:**
- Step 3: R_n·Y_n
- Step 9: pk_n·ρ̂ (= T_n·ρ̂)
- Step 11: sk_se·ρ̂ (= ε_n·ρ̂)

### 4.3 Algorithm 3 — Bernstein Polynomial Multiplication: BernsMul(ε, ρ̂, k)

```
Input: ε, ρ̂, k
Output: C = ε × ρ̂

1.  if i ≤ (k−1)² then return ε × ρ̂    // Base case
2.  λ = ⌊(i + k − 1)/k⌋;  λ' = i − (k−1)λ
3.  for n = 0 to k−2: slice polynomials into halves
4.  Determine A₀, A₁, ...A_{l−1}, B₀, B₁, ...B_{l−1}
5.  for n = 0 to l−1: C_n = BernsMul(A_n, B_n, e_n)  // Recursive
6.  Apply reconstruction (Eq. 5, Eq. 6)
7.  Return C
```

**Reconstruction (Bernstein, Eq. 6):**
```
R'₀ = C₀ + u^{i/2}·C₁
R'₁ = C₀·(1 + u^{1/2})·C  =  R'₁ + u^{i/2}·C₂
C   = R'₁ + u^{i/2}·C₂
```

**Hardware advantage:** Fewer XOR+AND gates than NTT; sub-quadratic space complexity; logarithmic delay; parallel multiplications enabled.

### 4.4 Algorithm 4 — Signed Keyword Verification: SV(S_n, ρ̂, P, K, N)

```
Input: (S_n, ρ̂), public key set P, keyword K, Ring members N
Output: Valid (1) or Invalid (0)

1.  ρ̂ ← encode(ρ̂)                    // Function F(ρ̂) → vector ρ̃
2.  Initialize ω̂ ← 0
3.  for n = 1 to N:
4.    ω̂ ← S_n − T_n·ρ̂ (mod q)       // Requires Bernstein sparse mult
5.    ω̂ ← ω̂ + ω̂'
6.  end for
7.  ρ̂' ← SHA(⌊ω̂⌋_{f,q}, K)
8.  if ρ̂'' == ρ̂ then return 1        // Valid → authenticated
9.  else return 0                       // Invalid → reject
```

### 4.5 Algorithm 5 — QC-LDPC Code Generation (Hybrid Encryption Key Gen)

```
Input: X, Y, rowweight, columnweight
Output: H_qc (parity check matrix), G (transformation matrix)

1.  Initialize PCM with random binary values, size X×Y
2.  Perform LU decomposition → H = H_U × H_L    ...(7)
3.  Construct diagonal matrix i=1..X, j=1..Y
4.  Determine non-zero diagonal components
5.  Reorganize PCM H column by column (columns re-ordering)
6.  Decompose H into z sub-matrices: Y = colweight×z; X = rowweight×z
7.  Column-wise circulant shifting: H_cir(i,j) = circshift(H_sub{i,j},1)  ...(9)
8.  Permute sub-matrices via random permutation matrix (column vector P_Y)
9.  XOR shift elements of each row and column → H_qc
10. Return H_qc
```

**Column-loop optimization (critical for efficiency):**
```
iterate j=1 to size(H_sub,2)     // column-first (cache-efficient)
   iterate i=1 to size(H_sub,1)
      apply circshift(H_sub{i,j}, 1)
```

**Key derivation:**
- Private key: sk_ds = (H_qc, G)
- W = H_qc·G → W̃ = W⁻¹_{n₀−1}·W = [W̃₀|W̃₁|...|W̃_{n₀−2}|I]
- Public key: pk_ds = W̃_l = [W̃₀|W̃₁|...|W̃_{n₀−2}]

**Encapsulation (SENDER):**
```
1. Generate random error vector ẽ ∈ F^n_2  (weight = 2)
2. CT₀ = [W̃_l | I] × ẽᵀ                   (syndrome, 408 bits)
3. ssk = HMAC-SHA256(ẽ)                     ("SHA in MAC-mode" — §8.4)
4. CT₁ = AES(ssk, m)
5. CT = (CT₀, CT₁)
```

**Decapsulation (RECEIVER):**
```
1. Run SLDSPA(CT₀, H_qc) → ẽ
2. ssk = HMAC-SHA256(ẽ)
3. m = AES(ssk, CT₁)
```

### 4.6 Algorithm 6 — SLDSPA Decoding

```
1.  Initialize L_cy = −C^y_{T₀}
2.  Associate L_cy with non-zeros of H_qc → L_{Q_{y,x}}
3.  Process check nodes using non-zeros in column of H_qc
4.  Obtain L_{c_{x,y}} via (18): min-sum approximation
5.  Determine posterior LÌ‚_cy via (15)
6.  Process bit nodes using non-zeros in row of H_qc
7.  Obtain L_{Q_{y,x}} via (19)
8.  Decoding decision: ẽ = {1 if L_cy < 0; 0 if L_cy > 0}
9.  Return ẽ
```

**Min-sum approximation (Eq. 17):**
```
L_{c_{X,Y}} = ∏_{y'∈Y(x)\y} sign(L_{Q_{y',x}}) · min_{y'∈Y(x)\y} |L_{Q_{y',x}}|
```

---

## 5. TIMING TABLES (For SAKE §6, §8, M1) [Source: Tables 6–7]

### 5.1 Table 6 — LR-IoTA Authentication Computation Cost

| Method | Key Generation (ms) | Signature Generation (ms) | Verification (ms) |
|---|---|---|---|
| Wang [30] | higher | higher | higher |
| Mundhe [40] | ~0.5 | ~18.2 | ~1.2 |
| HAN [39] | ~0.4 | ~16.8 | ~1.0 |
| Shim [24] | ~0.6 | ~20.1 | ~1.4 |
| **LR-IoTA (Proposed)** | **0.288** | **13.299** | **0.735** |

**LR-IoTA auth cost** (one-time per epoch):
```
Δ_KG = 0.288 ms  +  Δ_SG = 13.299 ms  +  Δ_V = 0.735 ms  =  14.322 ms
```

### 5.2 Table 7 — Code-Based HE Computation Cost

| Method | Key Generation (ms) | Encryption (ms) | Decryption (ms) |
|---|---|---|---|
| Aujla [29] | — | higher | higher |
| Ebrahimi [33] | — | higher | — |
| Phoon [38] | higher | — | higher |
| **Code-based HE (Proposed)** | **0.8549** | **1.5298** | **5.8430** |

**Decryption breakdown:**
```
Δ_dec = Δ_SLDSPA + Δ_SHA-ssk + Δ_AES ≈ 5.8430 ms
```

**Total per-packet HE cost (base paper):**
```
Δ_KeyGen + Δ_Enc + Δ_Dec = 0.8549 + 1.5298 + 5.8430 = 8.228 ms
Total auth + HE = 14.322 + 8.228 = 22.55 ms per session
```

> **SAKE-IoT impact:** SAKE amortizes this 22.55 ms over 2²⁰ packets.
> Tier 2 cost = **0.068 ms/packet** (≡ 99.1% reduction vs 7.37 ms base HE only).

---

## 6. HARDWARE TABLES [For SAKE §8, M3]

### 6.1 Table 3 — Polynomial Multiplier Hardware Comparison

| Multiplier | Slices | LUTs | Flip Flops | Delay_cpu (ms) |
|---|---|---|---|---|
| NTT [31] | 251 | — | — | 4.14 |
| Adaptive NTT [30] | 545 | 576 | 361 | 11.11 |
| SPM [40] | 127 | 393 | 240 | 7.40 |
| **Proposed Bernstein** | **72** | **72** | **64** | **0.811** |

**Key result:** Proposed is lowest on all four dimensions. SPM needs 127 slices/7.40 ms vs 72 slices/0.811 ms.

### 6.2 Table 4 — Ring-LWE Hardware Comparison (Full Scheme)

| Method | Approach | LUTs | Flip Flops | Slices | Delay (ms) |
|---|---|---|---|---|---|
| Liu et al. [48] | oSPMA | 317 | 198 | 103 | 3.00 |
| Zhang et al. [49] | Extended oSPMA | 699 | 705 | 265 | 3.33 |
| Liu et al. [50] | NTT | — | — | 8,680 | 4.25 |
| Feng et al. [51] | Stockham NTT | 1,307 | 889 | 406 | 12.50 |
| Wong et al. [47] | Karatsuba | 1,125 | 1,034 | 394 | 2.97 |
| **Proposed** | **Bernstein** | **486** | **235** | **124** | **2.43** |

### 6.3 Table 8 — QC-LDPC FPGA Hardware (Xilinx Virtex-6)

| Component | Method | Slices | LUTs | FFs | Delay (ms) |
|---|---|---|---|---|---|
| Encoding | Hu [37] | higher | higher | higher | higher |
| **Encoding** | **Proposed** | **64** | **64** | **64** | **0.317** |
| Decoding | Hu [37] | higher | higher | higher | higher |
| **Decoding** | **Proposed** | **640** | **635** | **646** | **1.427** |

**Proposed QC-LDPC is minimum-hardware among all KEM implementations.**

---

## 7. CLOCK CYCLE COMPARISON (Figure 7) [For SAKE §8, M3]

Source: Fig. 7 of base paper — "Comparative analysis of clock cycles required for code-based HE"

| Method | Encryption (×10⁶ cycles) | Decryption (×10⁶ cycles) | Total/packet |
|---|---|---|---|
| Original Lizard | ≈ 2.3 | ≈ 3.2 | 5.5 |
| RLizard | ≈ 3.3 | ≈ 4.75 | 8.05 (highest) |
| LEDAkem | ≈ 0.6 | ≈ 2.25 | 2.85 |
| **Code-based HE (Proposed)** | **≈ 0.35 (lowest)** | **≈ 2.0982 (lowest)** | **≈ 2.4482** |

**Key values for SAKE M3:**
- Base HE clock cycles = **2,448,200 cycles** (2.4482 × 10⁶)
- SAKE Tier 2 (HKDF + AES-GCM) = **74,000 cycles** (0.074 × 10⁶)
- Clock cycle reduction = 2,448,200 / 74,000 = **33.1×**

> **Note for paper:** Battery life extension claim must be scoped to "CPU-dominated IoT devices."
> For radio-dominated nodes, CPU cycle saving is additive (~5–15% total power), not 33×.

---

## 8. COMMUNICATION COST ANALYSIS (§12.1) [For SAKE §4, §8, M2]

### 8.1 LR-IoTA Authentication Communication

| Component | Size |
|---|---|
| Public key: i × log₂(q) bits | 512 × 29 = **14,848 bits (≈1.86 KB)** |
| Signature: i × log₂(2E+1) bits | 512 × 22 = **11,264 bits (≈1.41 KB)** |
| Keyword (SHA output) | 256 bits |
| **Total auth overhead** | **≈26,368 bits (3.27 KB)** |

### 8.2 Code-Based HE Communication

| Component | Size | Source |
|---|---|---|
| Public key pk_ds = W̃_l | (n₀−1) × X = 3 × 408 = **1,224 bits** | §12.1 |
| **CT₀ syndrome (per-packet)** | **X = 408 bits** | **§10.2 — eliminated in SAKE Tier 2** |
| CT₁ ciphertext | \|m\| bits | AES output |

### 8.3 SAKE Tier 2 vs Base Comparison

| Metric | Base Paper (per packet) | SAKE Tier 2 (per packet) | Saving |
|---|---|---|---|
| Data overhead bits | **408 bits (CT₀)** | **224 bits (Nonce + TAG)** | **184 bits = 45.1%** |
| Auth overhead | 26,368 bits (unchanged) | 26,368 bits (unchanged) | Identical |

---

## 9. SECURITY ANALYSIS — BASE PAPER (§11) [For SAKE §7]

### 9.1 Adversary Model (§11.1)

| Type | Capabilities |
|---|---|
| A1 | Passive — public parameters only |
| A2 | A1 + corrupt multiple IoT devices + modify parameters |
| A3 | A2 + adaptive oracle query access (strongest) |

### 9.2 Security Criteria for LR-IoTA

| Criterion | Definition |
|---|---|
| E1 (Unforgeability) | A3-level adversary cannot forge valid signature for non-queried keyword |
| E2 (Anonymity) | A1-level adversary cannot distinguish which ring member created signature |
| E3 (Unlinkability) | A2-level adversary cannot link two signatures to one member |

### 9.3 Theorem 2 — Unforgeability (ROM) — CRITICAL FOR SAKE §7

**Source: §11.3, Equations 21–23 of base paper — anchor for SAKE Proof 3 (EB-FS)**

```
Pr[A wins LR-IoTA] ≤ Pr[Φ₁] + Pr[Φ₂] + ε    ...(21)
```

- Pr[Φ₁]: adversary forges for queried keyword (bounded by Gaussian, Eq. 22)
- Pr[Φ₂]: adversary forges for non-queried keyword:
  ```
  ρ_n[Δ^sk_{p'_adv}(λ) = 1] = ρ_n[findSearchLWE_{p'_adv}(λ) = S_ch]    ...(23)
  ```
  where `ρ_n[findSearchLWE(λ) = S_ch]` is negligible — private key cannot be computed from public key under Ring-LWE hardness.

> **SAKE §7 direct citation:**
> "Recovery requires solving the Ring-LWE search problem (Theorem 2, Eq. 23 of [1])."
> This is the formal anchor for SAKE Proof 3 (EB-FS past secrecy).

### 9.4 Attack Models (§11.4) [For SAKE §5]

| Attack | Base Paper Defense | SAKE Status |
|---|---|---|
| Replay | Random Y_n per session (probabilistic) | **Strengthened** — deterministic monotonic counter, Pr=0 |
| MITM | Ring signature — any modification fails verification | **Inherited** — Phase 1 unchanged |
| KCI | Ring-LWE hardness — cannot compute another member's signature | **Inherited** — Phase 1 unchanged |
| ESL | Y_n leakage: SHA(ẽ) is one-way; ssk per-session | **Extended** — HKDF per-packet isolation |

---

## 10. SIMULATION ENVIRONMENT (§13) [For SAKE §8]

| Parameter | Base Paper Value | SAKE Compliance |
|---|---|---|
| Software | MATLAB 2018a | SAKE: MATLAB R2023b (same class) |
| FPGA | Xilinx Virtex-6 | SAKE: Software-level only |
| OS | Windows 10 | SAKE: Windows 10 |
| Processor | Intel Core i5 | SAKE: Intel Core i5 |
| RAM | 8 GB | SAKE: 8 GB |

> **SAKE paper note:** "MATLAB simulation performed on same hardware class as base paper
> (Intel Core i5, 8 GB RAM, MATLAB-compatible platform)."

---

## 11. BASE PAPER CONCLUSION CLAIMS (§14) [For SAKE Related Work / Conclusion]

- LR-IoTA: **23% lower authentication delay** vs conventional polynomial multiplication
- Bernstein multiplier: **72 Slices, 72 LUTs** — fewest resources of all compared multipliers
- QC-LDPC HE: **64 slices encoding** (Xilinx Virtex-6) — fewest of all KEM implementations
- Clock cycles: **lowest of all** (0.35M enc, 2.0982M dec) vs Lizard, RLizard, LEDAkem
- Attack detection: **Hybrid scheme** highest detection probability, lowest attack success rate

---

## 12. AUTHOR AND INSTITUTION [For SAKE Paper Header/Acknowledgements]

| Author | Institution | ORCID |
|---|---|---|
| Swati Kumari (Corresponding) | Thapar Institute of Engineering and Technology, Patiala, India | — |
| Maninder Singh | Thapar Institute of Engineering and Technology, Patiala, India | — |
| Raman Singh | Thapar Institute of Engineering and Technology, Patiala, India | — |
| Hitesh Tewari | Trinity College Dublin, Ireland | — |

**Funding:** No specific grant received.
**Data Availability:** Available on request.

---

*Source: `Draft/master_draft_COMPLETE.md` (complete 1190-line extraction of base paper)*
*main.tex EXCLUDED — this file is the only base paper content reference for Paper folder*
