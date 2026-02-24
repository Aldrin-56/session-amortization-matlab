# MASTER SYSTEM REFERENCE DRAFT — PART 1
# Paper: "A Post-Quantum Lattice-Based Lightweight Authentication and Code-Based Hybrid Encryption Scheme for IoT Devices"
# Authors: Swati Kumari, Maninder Singh, Raman Singh, Hitesh Tewari
# Published: Computer Networks 217 (2022) 109327, Elsevier
# DOI: https://doi.org/10.1016/j.comnet.2022.109327
# Received: 21 December 2021 | Revised: 18 June 2022 | Accepted: 25 August 2022

---

## 1. PAPER OVERVIEW

This paper proposes a robust, lightweight post-quantum cryptographic framework specifically designed for resource-constrained IoT devices. The framework has two tightly integrated components:

1. **LR-IoTA** — Lattice-Based Ring Signature Authentication for IoT devices, using Ring-LWE with Bernstein polynomial multiplication reconstruction.
2. **Code-based Hybrid Encryption (HE)** — A data security scheme using Diagonally Structured QC-LDPC codes with column loop optimization and Simplified Log Domain Sum-Product Algorithm (SLDSPA) decoding.

The system is validated on **MATLAB 2018a** and **Xilinx Virtex-6 FPGA** under Windows 10, Intel Core i5 8GB RAM.

---

## 2. ABSTRACT (Verbatim Summary)

The IoT introduces active connections between smart devices, but devices exhibit serious security issues. Conventional cryptographic approaches are too complex and vulnerable to quantum attacks. This paper presents:

- A **Ring-LWE-based mutual authentication** scheme using **Bernstein reconstruction in polynomial multiplication** to minimize computation cost, offering indefinite identity and location privacy.
- A **post-quantum hybrid code-based encryption** using **Diagonal Structure-Based QC-LDPC Codes** with column loop optimization and **SLDSPA** for lightweight encryption with minimum hardware.

**Key Results:**
- Total authentication delay is **23% less** than conventional polynomial multiplication schemes.
- Optimized code-based HE uses only **64 slices** (encoding) and **640 slices** (decoding) on Xilinx Virtex-6 FPGA.

---

## 3. INTRODUCTION

### 3.1 Problem Context

IoT devices are resource-constrained (limited storage, power, bandwidth). Conventional PKE schemes (RSA, ECC) are:
- Computationally too expensive for IoT devices
- Vulnerable to quantum attacks (Shor's algorithm breaks RSA/ECC)

### 3.2 Post-Quantum Cryptography Background

Post-quantum algorithms resist quantum attacks. Categories:
- Lattice-based (most promising — fastest, quantum-resistant)
- Code-based cryptography
- Multivariate quadratics
- Hash functions
- Isogeny-based

The paper uses **lattice-based** (for authentication/network security) and **code-based** (for data encryption) together.

### 3.3 Identity & Location Privacy Problem

- IoT devices must authenticate over wireless medium → identity transmitted in plaintext → privacy risk.
- Smart environment cameras/devices can reveal user location.
- Conventional pseudonym-based approaches have high computational complexity.
- **Solution:** Ring signatures — authenticate without revealing identity.

### 3.4 Motivation & Goals

- Existing methods use EITHER Ring-LWE OR code-based cryptography, not both.
- NTT-based polynomial multipliers need complex pre-computation and array reordering.
- Sparse Polynomial Multiplication (SPM) increases overhead with parallelism.
- Existing QC-LDPC encoders use dense parity check matrices → high decoding complexity.

**Proposed Solution:**
- Combine Ring-LWE + code-based cryptography
- Replace NTT with **Bernstein reconstruction** in sparse polynomial multiplication
- Replace dense QC-LDPC with **Diagonal Structure-Based QC-LDPC** + column loop optimization

### 3.5 Key Contributions

1. **LR-IoTA**: A new lattice-based authentication scheme introducing polynomial multiplication with Bernstein reconstruction for high-speed authentication with minimal message exchanges and hardware components.

2. **Novel code-based HE**: Improves data security with lower computational/hardware requirements. Optimizes diagonally structured QC-LDPC code generation and decoding via column loop optimization and SLDSPA.

3. **Security + Performance Validation**: Attack models (Replay, MITM, KCI, ESL) and performance analysis (communication cost, computation cost, hardware requirements).

---

## 4. RELATED WORKS

### 4.1 Lattice-Based Authentication

| Work | Approach | Limitation |
|---|---|---|
| Li et al. | SPHF + PHS + asymmetric PAKE over lattice | No full anonymity; authority can reveal identity |
| Cheng et al. | Certificateless + ECC + pseudonym + blockchain | Lower security than ring signature |
| Shim et al. | Lattice-based blind signature using homomorphic encryption | Signature too long; no detailed unforgeability proof |
| Wang et al. | Ring-LWE-based 2FA (quantum) | Based on group cryptosystems susceptible to post-quantum era |
| Lee et al. (RLizard) | Ring-LWE key encapsulation; rounding instead of errors | Conventional polynomial multiplication; high space/delay |
| Chaudhary et al. | LWE/Ring-LWE review for IoT | Not implemented in hardware |
| Aujla et al. | Ring-LWE for healthcare (5G/SDN/edge/cloud) | Not in hardware platform |
| Wang et al. [30] | FPGA-based lattice crypto; adaptive NTT polynomial multiplier | Fixed params; pre-calculation overhead |
| Buchmann et al. | Binary distribution instead of Gaussian | Short messages only |
| Ebrahimi et al. | Binary Ring-LWE fault attack analysis | Only software (8-bit/32-bit MCU) |
| Liu (double auth) [34] | Double authentication for Ring-LWE | Doubles computation time |
| Norah et al. | SIMON block cipher for IoT healthcare | Needs optimization for shift ops |

### 4.2 Code-Based Cryptography

| Work | Approach | Limitation |
|---|---|---|
| Chikouche et al. | Code-based auth using QC-MDPC (McEliece variant) | Against typical attacks only |
| Hu et al. [37] | QC-LDPC key encapsulation on FPGA | Speed/area/power analyzed; no diagonal structure |
| Phoon et al. [38] | QC-MDPC on FPGA + Custom Rotation Engine (CRE) + adaptive threshold + Hamming weight estimation | More area for longer keys |

### 4.3 Polynomial Multiplication Approaches

| Method | Type | Note |
|---|---|---|
| NTT [31] | Schoolbook transform | Pre-computation exponential; hardware-heavy |
| Adaptive NTT [30] | Parameterizable NTT | Reusable but high overhead |
| SPM [40] | Sparse Polynomial Multiplication | Increases overhead with parallelism |
| Liu et al. [48] — oSPMA | Optimized Schoolbook | Low throughput |
| Zhang et al. [49] | Extended oSPMA with extra DSP | Higher throughput but still low vs NTT |
| Liu et al. [50] | NTT-based, side-channel secure | Resource-efficient but high hardware |
| Feng et al. [51] | Stockham FFT-based NTT | Low hardware req; very slow |
| Wong et al. [47] | One-level Karatsuba in FPGA | Best delay but high space complexity |
| **Proposed** | **Bernstein reconstruction in sparse polynomial multiplication** | **Best area-delay tradeoff** |

### 4.4 Vehicular / IoT Ring Signature Works

| Work | Approach | Limitation |
|---|---|---|
| HAN et al. [39] | Traceable Ring Signature (TRS) on ideal lattice | No location privacy |
| Mundhe et al. [40] | Ring signature-based CPPA for VANETs | High hardware complexity (NTT+SPM) |

---

## 5. PRELIMINARIES

### 5.1 Notations Table (Table 1 — Complete)

| Symbol | Description | Symbol | Description |
|---|---|---|---|
| Λ | Lattice structure | E | Bound to sample uniform random value for Yₙ |
| βᵢ | Linearly independent vectors | q | Polynomial bounded modulus |
| Zʲ | j-dimensional integer space | νₙ | A sample vector of length n |
| G^n_σ | Discrete Gaussian distribution | ⌊ν⌋_{f,q} | Polynomial with ν mod q applied to all coefficients |
| Z_q | Finite field over q | ρ̂ | Hashed codeword |
| ℝ⁺ | Positive real numbers | ρ̃ | Encoded output of ρ̂ |
| ℕ | Natural number | S_se | Signature of sender node |
| χ | Probability distribution for error vector | V | Bound to check uniform distribution of signature |
| R_q | Quotient ring | l | Number of polynomial elements (PEs) |
| i | Degree of polynomial | u | Variables of linear polynomial equation |
| N | Number of IoT members | a, b | Coefficients of linear polynomial equation |
| pk_n | Public key of IoT device n | R'₀ | First reconstruction in Bernstein method |
| sk_n | Secret key of IoT device n | R'₁ | Second level of reconstruction in Bernstein method |
| sk_se | Secret key of sender device | C | Final recursive product |
| P | Public key set | H_qc | Parity check matrix of QC-LDPC code |
| K | Keyword message | X×Y | Size of H_qc |
| Sₙ | Signature of all ring members | H_L | Lower decomposition of H_qc |
| pk_ds | Required public key during data sharing | H_U | Upper decomposition of H_qc |
| sk_ds | Required secret key during data sharing | z | Number of submatrices |
| m | Message | P_Y | Column vector used to construct permutation matrix in code-based HE |
| ssk | Session key | W | Dense permutation matrix in code-based HE |
| CT | Cipher text | n₀ | Number of circulant matrices |
| Rₙ | Random matrix | G | Sparse transformation matrix |
| δₙ, εₙ | Secret matrices | ε̃ | Random error vector |
| ω | Weight value to check short signature | L_cy | Prior data of variable node y |
| σ | Standard deviation | L̃_cy | Posterior data of variable node y |
| M | Probability of acceptance key generation | L_{R_{x,y}} | Extrinsic check-to-variable message from x to y |
| Yₙ | Polynomial with coefficients in [-E, E] | L_{Q_{y,x}} | Extrinsic variable-to-check message from y to x |

### 5.2 Lattice Definition

A lattice Λ is a collection of points with periodic arrangement in i-dimensional space:

```
Λ = { a₁β₁ + a₂β₂ + ... + aᵢβᵢ | aᵢ ∈ Z }    ...(1)
```

Where β₁, β₂, ...βᵢ ∈ Zʲ are linearly independent vectors, Zʲ is j-dimensional integer space, i = rank, j = dimension. Full rank lattice: i = j.

### 5.3 Gaussian Distribution

Centered discrete Gaussian distribution G_σ for σ > 0 relates probability p_σ(u)/p_σ(Z) to u ∈ Z:

```
p_σ(u) = e^(-u²/2σ²)
p_σ(Z) = 1 + 2 Σ_{u=1}^{∞} p_σ(u)
G^i_σ = p_σ(u)/p_σ(Zⁱ)
```

The scheme uses δ ← G^n_σ to represent matrix δ with n elements independently sampled from G^n_σ.

(Source: optional 1.jpg — formally confirmed)

### 5.4 Learning with Errors (LWE)

Vectors from error-set linear equations are distinguished using LWE. Given:
- Modulus q = poly(i), random
- Vector δₙ ∈ Zⁱ_q
- Random matrix Rₙ ∈ Zⁱ_q

**LWE distribution:** Tₙ = Rₙδₙ + εₙ (mod q)
where probability distribution χ: Z_p → ℝ⁺ specifies each coordinate of error vector εₙ ∈ Z_q.

**Computational-LWE problem:** Given arbitrary samples from LWE distribution, compute δ.

**Decisional-LWE problem:** Distinguish samples from Zⁱ_q + 1 uniformly distributed vs LWE-distributed (for hidden vector δ ← χⁱ).

### 5.5 Ring-LWE (Ring Learning With Errors)

Ring-LWE is LWE over polynomial rings over finite fields. Defined by Lyubashevsky et al. [41, 42].

- Integer modulus q ≥ 2 parameterizes Ring-LWE
- R_q = quotient ring = R/qR (where R = Z[u]/f(u))
- Polynomials Rₙ(u) and δₙ(u) selected from R_q = Z_q[u]/f(u) uniformly
- f(u) is irreducible polynomial of degree i
- Error polynomials εₙ(u) sampled from discrete Gaussian G^i_σ with std dev σ
- Ring-LWE distribution: tuples (A, T) where T = Rδ + ε (mod q)

### 5.6 Hardness Assumption

The security of the authentication method is based on the Ring-LWE problem hardness. Finding private key sk from (R, T) is computationally hard.

**Definition 1:** Assume i ∈ ℕ, prime i ∈ ℕ, access oracle O^sk for output pair (R, T). R ∈ R^i_q is uniform polynomial, T = R⊗sk + ε (mod q). Private key sk selected from R^i_q, ε from G^i_σ.

Two variants:
- **Search-LWE:** Hard problem of finding private key sk from (R, T)
- **Decisional-LWE:** Probability of distinguishing O^sk and R is negligible

Size of public key reduced using Ring-LWE → faster operations.

### 5.7 Ring Signature

Ring signatures provide user anonymity (unlike group signatures). Key properties:
- Users not fixed to a group — ad-hoc group formed by signer
- Signer uses other users' public keys without their knowledge to hide identity
- Security requirements: **Anonymity** and **Unforgeability**

Three algorithms in Ring-LWE signature:
1. **Key Generation:** Input: security parameters → Output: public key pkₙ, private key skₙ (n = IoT member index, n=1,2,...N)
2. **Signature generation with keyword:** Input: keyword message K, sender secret key sk_se, public keys P of all ring members (se ∈ {1,2,...N}) → Output: ring signature Sₙ
3. **Signed keyword verification:** Input: public keys P, keyword K, signature Sₙ → Output: valid(1) or invalid(0) → authenticated device allowed to start data sharing

### 5.8 Hybrid Encryption (HE)

HE = Key Encapsulation Process (KEP) + Data Encapsulation Process (DEP)

Three algorithms:
1. **Key generation:** Takes security parameters → returns (pk_ds, sk_ds)
2. **Encryption:** Input: pk_ds, message m
   - KEP encryption → session key ssk + ciphertext CT₀
   - DEP encryption → ciphertext CT₁
   - Final output: CT = (CT₀, CT₁)
3. **Decryption:** Input: sk_ds, CT
   - KEP decryption → session key ssk (from CT₀)
   - DEP decryption → message m (from CT₁ using ssk)

Key pair for data sharing differentiated from authentication: (pk_ds, sk_ds)

---
*[CONTINUED IN PART 2]*
