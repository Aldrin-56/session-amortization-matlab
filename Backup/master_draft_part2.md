# MASTER SYSTEM REFERENCE DRAFT — PART 2
# Continuation of: "A Post-Quantum Lattice-Based Lightweight Authentication and Code-Based Hybrid Encryption Scheme for IoT Devices"

---

## 6. SYSTEM MODEL (Section 4 of Paper)

### 6.1 Generic IoT Network Structure (Fig. 1)

The IoT network encompasses four types of smart environments:
1. **Smart Home** — sensors, appliances connected via home gateway
2. **Transportation** — vehicle-to-vehicle/roadside communication
3. **Wearable** — body-worn health/fitness devices
4. **Community** — public infrastructure sensors

All smart devices in each circumstance connect to the Internet via a **neighbouring gateway node**. Users (home users, doctors, traffic monitors) access real-time data from authorized IoT devices through the gateway.

### 6.2 Hierarchical IoT Network (Fig. 2)

A specific subtype of the generic IoT model. Three node types:
- **Gateway Node** — single per application, considered **trusted** (never compromised)
- **Cluster Head Nodes** — intermediate aggregators
- **Sensing Nodes** — leaf nodes sensing and transmitting data

Data flow: Sensing Node → Cluster Head Node → Gateway Node (via wireless links, hierarchically).

**Security challenge:** All entities except the gateway (users, sensing nodes, cluster heads) are **not trustworthy**. Every transmission uses a wireless medium.

### 6.3 Overall Proposed Scheme Architecture (Fig. 3 — Critical Diagram)

The system has **two phases** running between a **Sender** and a **Receiver**:

#### AUTHENTICATION PHASE (Top block):
**Sender side:**
- Key generation (produces: Public key 🔑, Private key 🗝️)
- Sign generation with Bernstein reconstruction (uses Private key + Keyword Message)
- Transmits: {Public key, Signature, Keyword Message} → to Receiver

**Receiver side:**
- Sign verification with Bernstein reconstruction (uses: Public key, Signature, Keyword Message)
- Returns '1' for Authenticated device → proceeds to Data Sharing Phase

#### DATA SHARING PHASE (Bottom block):
**Receiver side** (generates keys first):
- QC-LDPC Code generation (produces: Public key 🔑, Private key 🗝️)
- Receives Cipher text C_{T0} from Sender
- Runs SLDSPA (receives: H_qc, Error vector ẽ)
- KEP decryption with SHA → Session key 🔑
- AES decrypt CT₁ → Decrypted Message

**Sender side:**
- Receives Public key from Receiver
- Error vector → KEP encryption with SHA → Session key 🔑 + Cipher text C_{T0}
- AES encrypt (using session key + Original Message) → Cipher text C_{T1}
- Transmits: {CT₀, CT₁} → to Receiver

### 6.4 Ring Structure for Authentication

- IoT devices form a **ring network structure** with local authentication entities
- Ring structures deliver authorization services for locally registered entities (IoT devices)
- Same ring structures can extend for trust relations with other rings globally
- Sensing nodes + gateway nodes form a ring in the proposed authentication method
- After ring formation: each member generates public/private key pairs
- Sender generates lattice-based ring signature → transmitted with keyword to receiver for verification
- After successful verification: receiver accepts signature (output = 1) → data sharing allowed

### 6.5 Two-Phase Scheme Summary (Fig. 3 + Section 4 text)

**Phase 1 — Authentication:** Lattice-based ring signature (Ring-LWE + Bernstein polynomial multiplication)
- Purpose: network security + mutual authentication + identity/location privacy

**Phase 2 — Data Sharing:** Code-based hybrid encryption (Diagonal QC-LDPC + SLDSPA)
- Purpose: data security + confidentiality of exchanged data

---

## 7. PROPOSED PROTOCOL — LR-IoTA (Section 4.1)

### 7.1 Overview

LR-IoTA (Lattice-based Ring IoT Authentication) is a Ring-LWE-based cryptographic method with:
- **Finite field arithmetic** (addition: simple; multiplication: costlier)
- **Sparse + dense polynomial multiplication** for key generation
- **Bernstein reconstruction** to reduce XOR gates, AND gates, and delay

Security based on average-case hardness of **Learning with Errors (LWE)** problem.

The scheme consists of four algorithms: Setup, Key Generation, Signature Generation with Keyword, Signed Keyword Verification.

### 7.2 Setup

System parameters provided with knowledge of security parameters. Random matrix:
```
Rₙ ∈ Z^i_q,  n = 1, 2, ...N
```
where N = number of ring members (IoT devices). Rₙ is a global constant → does not need resampling.

### 7.3 Algorithm 1 — Key Generation: KG(1^λ, Rₙ, N)

**Input:** public random polynomial matrix Rₙ, Ring IoT members N
**Output:** Public key pkₙ, private key skₙ

```
1.  for n = 1 to N
2.    δₙ, εₙ ← G^i_σ                          // Sample from Gaussian
3.    for n = 1 to i
4.      value[n] ← absolute(ε(n))
5.    end for
6.    Initialize T ← 0
7.    for n = 1 to ω                            // ω = weight value (=18)
8.      Initialize maximum ← 0
9.      Initialize position ← 0
10.     for k ← 1 to ω
11.       if value[k] > maximum then
12.         maximum ← value[k]
13.         position ← k
14.       end if
15.     end for
16.     value[position] ← 0
17.     T = T + value[position]                 // Accumulate ω largest entries
18.   end for
19.   if T > M = 7ωσ then                       // Rejection condition
20.     Restart key generation
21.   end if
22.   Tₙ ← Rₙδₙ + εₙ (mod q)                  // Public key computation
23.   pkₙ = Tₙ                                  // Public key
24.   skₙ = (δₙ, εₙ)                            // Private key
25. end for
26. return pkₙ, skₙ
```

**Notes:**
- Rejection condition |εₙ| > 7ωσ ensures correctness and short signatures
- ω (=18) massive entries of εₙ are counted and summed; compared to M = 7ωσ
- Matrix multiplication Rₙδₙ needed; Rₙ global constant → no resampling needed

### 7.4 Algorithm 2 — Signature Generation with Keyword: SG(sk_se, P, K, N)

**Input:** sender's private key sk_se, Ring IoT members N, public key set P, public random polynomial matrix Rₙ, keyword message K
**Output:** signature (Sₙ, ρ̂)

```
1.  for n = 1 to N
2.    Yₙ ← [-E, E]^i                           // Sample randomly from bound E
3.    νₙ ← RₙYₙ (mod q)                        // Compute polynomial
4.  end for
5.  ν ← add(ν₁, ν₂, ...νₙ)                    // Sum all νₙ
6.  ρ̂ ← encode(ρ̂)                             // Rounding: ⌊ν⌋_{f,q} concat K
7.  ρ̂ ← SHA(⌊ν⌋_{f,q}, K)                     // Hash with SHA
8.  if n ≠ se then
9.     Sₙ = RₙYₙ + pkₙρ̂                        // Signature for ring members  ...(3)
10. else if n = se then
11.    S_se = (Y_se + sk_se · ρ̂) · R_se        // Signature for sender node   ...(2)
12. end if
13. end if
14. end for
15. ω̆ ← νₙ - εₙρ̂ (mod q)                      // Compute ω̆ for rejection sampling
16. if |⌊ω̆ₙ⌋_{2f}| > 2^{f-1} - M  AND  Sₙ ≤ E - V then
17.   Restart                                   // Rejection condition check
18. end if
19. return (Sₙ, ρ̂)
```

**Steps requiring sparse polynomial multiplication (Bernstein optimized):**
- Step 3: RₙYₙ
- Step 9: pkₙρ̂ (i.e., Tₙρ̂)
- Step 11: sk_se · ρ̂ (i.e., εₙρ̂)

**Rejection conditions (Section 4.1.2):**
1. `|⌊ω̆ₙ⌋_{2f}| > 2^{f-1} - M` — ensures malicious devices can't extract signer's key
2. `Sₙ ∈ [-E+V, E-V]` (uniform distribution check), where V = 14σ√ω̄

When all conditions satisfied → return (Sₙ, ρ̂) and transmit with K to receiver.

### 7.5 Section 4.1.3 — Bernstein Reconstruction in Polynomial Multiplication

**Problem:** Conventional sparse polynomial multiplication has high space complexity (delay).

**Goal:** Reduce XOR gates, AND gates, and delay of polynomial multiplication.

**Setup:** Two polynomials of degree i in linear form:
```
ε(u) = Σ_{x=0}^{i-1} aₓuˣ
ρ̂(u) = Σ_{x=0}^{i-1} bₓuˣ    in F₂[u], power of 2 for i
```

The proposed scheme takes i inputs for each polynomial → generates l polynomial elements (PE).

PEs of ε and ρ̂: A₀(ε), A₁(ε), ...A_{l-1}(ε) and B₀(ρ̂), B₁(ρ̂), ...B_{l-1}(ρ̂)

**For k=2, l=3:** Split polynomials into two halves (Equation 4):
```
ε(u) = Σ_{x=0}^{i/2-1} aₓuˣ + u^{i/2} Σ_{x=0}^{i/2-1} a_{x+i/2} uˣ
ρ̂(u) = Σ_{x=0}^{i/2-1} bₓuˣ + u^{i/2} Σ_{x=0}^{i/2-1} b_{x+i/2} uˣ
```

**Two half polynomials:**
```
εₗ = Σ_{x=0}^{i/2-1} aₓuˣ       (lower half)
εₕ = Σ_{x=0}^{i/2-1} a_{x+i/2}uˣ  (upper half)
ρ̂ₗ = Σ_{x=0}^{i/2-1} bₓuˣ       (lower half)
ρ̂ₕ = Σ_{x=0}^{i/2-1} b_{x+i/2}uˣ  (upper half)
```

**Three polynomial element structures:**
```
From ε:  A₀(ε) = εₗ,  A₁(ε) = εₗ + εₕ,  A₂(ε) = εₕ
From ρ̂:  B₀(ρ̂) = ρ̂ₗ,  B₁(ρ̂) = ρ̂ₗ + ρ̂ₕ,  B₂(ρ̂) = ρ̂ₕ
```

**Pairwise multiplication (Equation 5):**
```
C₀ = A₀B₀;   C₁ = A₁B₁;   C₂ = A₂B₂
```

**Reconstruction (Equation 6 — Bernstein):**
```
R'₀ = C₀ + u^{i/2}·C₁
R'₁ = C₀·(1 + u^{1/2})·C  =  R'₁ + u^{i/2}·C₂
C   = R'₁ + u^{i/2}·C₂
```

This single recursion of Bernstein reconstruction:
- Applies to computing three half-size products in (4) recursively
- Introduces **parallel computation** for recursive computations
- Reduces space complexity and delay vs conventional non-recursive multipliers

**Hardware advantage:**
- Far fewer XOR gates, AND gates, and delay than conventional sparse polynomial multiplication
- Uses simple arithmetic (XOR + AND gates only)
- Reduced bit additions per recursion compared to Karatsuba Algorithm

### 7.6 Algorithm 3 — Bernstein Multiplication (BernsMul)

**Input:** ε, ρ̂, k
**Output:** C = ε × ρ̂

```
1.  if i ≤ (k-1)² then
2.    return ε × ρ̂                             // Base case
3.  λ = ⌊(i + k - 1)/k⌋,  λ' = i - (k-1)λ     // Slice parameters
4.  for n = 0 to k-2 do
5.    εₙ = slice(ε, n·λ, λ); εₗ ← εₙ
6.    ρ̂ₙ = slice(ρ̂, n·λ, λ); ρ̂ₗ ← ρ̂ₙ
7.  end
8.  ε_{n-1} = slice(ε, (k-1)·λ, λ'); εₕ ← ε_{n-1}
9.  ρ̂_{n-1} = slice(ρ̂, (k-1)·λ, λ'); ρ̂ₕ ← ρ̂_{n-1}
10. Determine A₀, A₁, ...A_{l-1}, B₀, B₁, ...B_{l-1}
11. end for
12. for n = 0 to l-1 do
13.   Cₙ = BernsMul(Aₙ, Bₙ, eₙ)               // Recursive call
14. end for
15. for n = 0 to l-1 do
16.   Determine C by applying (5) recursively
17. end for
18. Return C
```

**Complexity advantage:**
- Fewer XOR gates, AND gates than conventional NTT which needs exponential computations
- Sub-quadratic space complexity, logarithmic delay
- Parallel multiplications enabled

### 7.7 Algorithm 4 — Signed Keyword Verification: SV(Sₙ, ρ̂, P, K, N)

**Input:** signature (Sₙ, ρ̂), public key set P, keyword message K, Ring IoT members N
**Output:** Valid (1) or Invalid (0)

```
1.  ρ̂ ← encode(ρ̂)                            // Encode using function F(ρ̂) → vector ρ̃
2.  Initialize ω̆ ← 0
3.  for n = 1 to N do
4.    ω̆ ← Sₙ - Tₙρ̂ (mod q)                   // Requires sparse polynomial multiplication with Bernstein
5.    ω̆ ← ω̆ + ω̆'
6.  end for
7.  ρ̂' ← SHA((⌊ω̆⌋_{f,q}, K))                 // Hash to recompute ρ̂
8.  if ρ̂'' == ρ̂ then
9.    return 1                                  // Signature valid → device authenticated
10. else
11.   return 0                                  // Signature invalid → reject
12. end if
```

**Step 4 requires sparse polynomial multiplication with Bernstein reconstruction (Tₙρ̂)**

---

## 8. PROPOSED PROTOCOL — CODE-BASED HYBRID ENCRYPTION (Section 4.2)

### 8.1 Overview

**Source: img8.jpg (Section 4.2 — garbled section recovered)**

The proposed code-based hybrid encryption combines KEP + DEP:
- **KEP (Key Encapsulation Process):** generates public/private keys; encrypts session key using sender's public key
- **DEP (Data Encapsulation Process):** encrypts message m using session key (AES)
- **KDF (Key Derivation Function):** uses hash function to resist quantum attacks
- **QC-LDPC Codes:** generate keys with Diagonal Structure → minimizes sparsity overhead
- **Column-wise loop optimization:** achieves optimization of Diagonal Structure-Based QC-LDPC codes
- **SLDSPA:** decodes QC-LDPC code with less computational complexity

### 8.2 Algorithm 5 — Generation of Diagonally Structured QC-LDPC Codes

**Source: img9.jpg (garbled section recovered — equations 7, 8 confirmed)**

**Construction of Parity Check Matrix (PCM) H_d of size X×Y:**

Step 1: Initialize PCM with random binary values, size X×Y.

Step 2: Perform **Lower-Upper (LU) decomposition** on PCM to get new diagonal matrix:
```
H = H_U × H_L    ...(7)
```

Where:
```
       [1    0   ··· 0 ]              [U₁,₁  U₁,₂ ··· U₁,X]
H_L =  [L₂,₁ 1   ··· 0 ]    H_U =  [0      U₂,₂ ··· U₂,X]    ...(8)
       [⋮    ⋮   ⋱  ⋮ ]              [⋮      ⋮    ⋱  ⋮    ]
       [L_{Y,1} L_{Y,2} ··· 1]       [0      0    ··· U_{YX}]
```

Step 3: Construct diagonal matrix for i=1,2,...X and j=1,2,...Y.

Step 4: Determine number of non-zero diagonal components.

Step 5: Reorganize PCM H column by column using **columns re-ordering strategy**.

Step 6: Decompose H into z sub-matrices with Y = column_weight × z and X = row_weight × z.

Step 7: Perform **column-wise circulant shifting** on sub-matrices to get QC-LDPC codes H_qc:
```
H_cir(i,j) = circshift(H_sub{i,j}, 1)    ...(9)
```
(MATLAB-style column-wise circulant permutation)

Full Algorithm 5 pseudocode:
```
1.  Initialize PCM with random binary values, size X×Y
2.  Perform LU decomposition → new matrix as in (7)
3.  Construct diagonal matrix i=1,2,...X and j=1,2,...Y
4.  Determine number of non-zero diagonal components
5.  Reorganize PCM H column by column
6.  Decompose H into z sub-matrices: Y=columnweight×z, X=rowweight×z
7.  Perform column-wise circulant shifting on sub-matrices
8.  Permute sub-matrices via random permutation matrix of size z (using column vector P_Y)
9.  Execute XOR operation to shift elements of each row and column → get H_qc
10. Return H_qc
```

**Column-wise loop optimization (programmatic steps applied during step 7):**
- Step 1: Obtain sub-matrices H_sub(i,j) where i=1,2,...X/rowweight and j=1,2,...Y/columnweight
- Step 2: Determine number of sub-matrices along column direction using `size(H_sub, 2)`
- Step 3: Determine number of sub-matrices along row direction using `size(H_sub, 1)`
- Step 4: Iterate j=1 to size(H_sub, 2) and i=1 to size(H_sub, 1): apply `circshift(H_sub{i,j}, 1)` — column-wise traversing is faster than row-wise
- Step 5: End

After circulant shifting → column-wise circulant permutation of sub-matrices using column vector P_Y with random integers from [1:Y] → construct random permutation matrix of size z → XOR shift elements of each row and column → get **H_qc of size X×Y with n₀ circulant matrices**.

### 8.3 QC-LDPC Code Representation (Equations 10–13)

**Source: img10 part 2.jpg and img 10 part 2.jpg (encrypted section recovered)**

H_qc of size X×Y with n₀ circulant matrices:
```
H_qc = [H^0_qc | H^1_qc | H^2_qc | ··· | H^{n₀-1}_qc]    ...(10)
```

Sparse transformation matrix G (size: dictated by QC-LDPC params):
```
G = [G_{0,0}  G_{0,1}  ··· G_{0,n₀-1} ]
    [G_{1,0}  G_{1,1}  ··· G_{1,n₀-1} ]    ...(11)
    [⋮        ⋮        ⋱  ⋮            ]
    [G_{n₀-1,0} G_{n₀-1,1} ··· G_{n₀-1,n-1}]
```

Weight of every row/column of G: ω_G = Σ_{n=0}^{n₀-1} ω_n

Dense matrix W:
```
W = H_qc · G = [W₀ | W₁ | W₂ | ··· | W_{n₀-1}]    ...(12)
```
Size of W is X×Y. W_{n₀-1} is inverted to get W̃ using:
```
W̃ = W^{-1}_{n₀-1} · W = [W̃₀ | W̃₁ | ··· | W̃_{n₀-2} | I] = [W̃_l | I]    ...(13)
```

**Private key:** sk_ds = (H_qc, G)
**Public key:** pk_ds = W̃_l = [W̃₀ | W̃₁ | ··· | W̃_{n₀-2}]
- Bit-size of pk_ds = (n₀ - 1) × p
- Bit-size of sk_ds = n₀(κ + Y·log(p)) where κ = 18 = row_weight × column_weight

### 8.4 Hybrid Encryption — Key Generation, Encryption, Decryption

#### Key Generation:
Input: X, Y, rowweight, columnweight
→ Execute Algorithm 5 → get (H_qc, G) as private key sk_ds
→ Compute W̃_l = [W̃₀|W̃₁|...|W̃_{n₀-2}] as public key pk_ds
→ Return (pk_ds, sk_ds)

#### Encryption (CT = KEP_enc + DEP_enc):
**KEP encryption:**
- Create random error vector ẽ ∈ F^n_2 of weight wei(ẽ) = 2, where y ∈ Y
- Calculate syndrome: CT₀ = [W̃_l | I] × ẽᵀ
- Use SHA in MAC-mode to generate session key ssk of length l_k from ẽ
- Decrypt message using AES: CT₁ = AES(ssk, m)
- Output: CT = (CT₀, CT₁)

**DEP encryption:**
- Encrypt message using session key: CT₁ = AES(ssk, m)

#### Decryption:
**KEP decryption:**
- Receive CT₀ = [W̃_l | I] × ẽᵀ = W^{-1}_{n₀-1} · W · ẽᵀ = W^{-1}_{n₀-1} · H_qc · G · ẽᵀ
- Private key (H_qc, G) used; decoding algorithm SLDSPA used to return random error ẽ
- Syndrome: C^y_{T₀} = H_qc · ẽᵀ (with transformation matrix G and W^{-1}_{n₀-1} from private key)
- QC-LDPC decoding: based on H_qc and syndrome H_qc · ẽᵀ
- After decoding: SHA in MAC-mode → ssk of length l_k from ẽ
- Bipartite graph used to represent input matrix H_qc; variable nodes = columns of H_qc, check nodes = rows of H_qc
- Syndrome C_y = [C^0_{T₀}, C^1_{T₀}, ...C^Y_{T₀}] decoded via check and bit-node processing

**DEP decryption:**
- m = AES(ssk, CT₁)

### 8.5 SLDSPA Decoding (Section 4.2 / Fig. 4)

SLDSPA modifies the conventional sum-product algorithm using a **min-sum algorithm** for check node processing.

**Notation:**
- L_cy = prior data of variable node y
- L̃_cy = posterior data of variable node y
- L_{R_{x,y}} = extrinsic check-to-variable message from x to y
- L_{Q_{y,x}} = extrinsic variable-to-check message from y to x

**Four steps of decoding:**

**Step 1: Initialization**
```
L_cy = -C^y_{T₀}    (prior log-likelihood)
L_{Q_{y,x}} = L_cy  (initialize variable-to-check)
```

**Step 2: Check node processing (Equations 14, 16, 17, 18)**
```
L_{R_{x,y}} = log( (1 + Π_{y'∈Y(x)\y} tanh(L_{Q_{y',x}}/2)) /
                   (1 - Π_{y'∈Y(x)\y} tanh(L_{Q_{y',x}}/2)) )    ...(14)
```

Simplified using the relation `2tanh⁻¹A = log((1+A)/(1-A))` and min-sum approximation:
```
L_{c_{X,Y}} = 2tanh⁻¹( Π_{y'∈Y(x)\y} sign(L_{Q_{y',x}}) · tanh(L_{Q_{y',x}}/2) )    ...(16)
```

Min-sum (least-magnitude rules the product):
```
L_{c_{X,Y}} = Π_{y'∈Y(x)\y} sign(L_{Q_{y',x}}) · min_{y'∈Y(x)\y} |L_{Q_{y',x}}|    ...(17)
```

Simplified using non-zeros in column of H_qc (count = c₁):
```
L_{c_{x,y}} = Π_{y'∈Y(x)\y} sign(L_{Q_{y',x}})(x, c₁) · min_{y'∈Y(x)\y} |L_{Q_{y',x}}(x, c₁)|    ...(18)
```

**Step 3: Variable node processing (Equations 15, 19)**
```
L_{Q_{y,x}} = L_cy - L_{R_{x,y}}    ...(15)
```
where `L̃_cy = L_cy + Σ_{x∈X(n)} L_{R_{x,y}}`

Simplified using non-zeros in row of H_qc (count = r₁):
```
L_{Q_{y,x}} = L_cy + Σ_{x∈X(n)} L_{R_{x,y}}(r₁, y) - L_{R_{x,y}}(r₁, y)    ...(19)
```

**Step 4: Decoding decision (Equation 20)**
```
ẽ = { 1  if L_cy < 0
      0  if L_cy > 0    ...(20)
```

If ẽ is valid decoding result → SHA in MAC-mode → generate ssk of length l_k from ẽ.

### 8.6 Algorithm 6 — Decoding Using SLDSPA

```
1.  Initialize L_cy = -C^y_{T₀}
2.  Associate L_cy with non-zero elements of H_qc to get L_{Q_{y,x}}
3.  Process check nodes using non-zeros in column of H_qc
4.  Obtain L_{c_{x,y}} using (18)
5.  Determine posterior data of variable node L̃_cy using (15)
6.  Process bit nodes using non-zeros in row of H_qc
7.  Obtain L_{Q_{y,x}} using (19)
8.  Perform decoding using (20)
9.  Return ẽ
```

---

## 9. COMPLETE FLOW DIAGRAM (Fig. 4)

**Source: fig4.jpg (fully read)**

### LEFT BRANCH — Authentication:
```
Start
  ↓
Generate secret matrices δₛₑ, εₛₑ from G^i_σ
  ↓
Check: T > M = 7ωσ?  → Y → (loop back to previous step)
  ↓ N
Generate public and private key pk_ₙ, sk_ₙ
  ↓
Execute signature generation algorithm (taking sk_ₛₑ, N, P, Rₙ, K as inputs)
  ↓
Verify the signature (Sₙ, ρ̂)
  ↓
Valid? → N → End
  ↓ Y
[connects to Data Sharing middle branch]
```

### MIDDLE BRANCH — Data Sharing / Sender:
```
Generate Diagonally Structured QC-LDPC code with column loop optimization
  ↓
Construct (H_qc, G) and ñ^l as private and public key of encryption algorithm
  ↓
Generate random error vector ẽ
  ↓
Execute SHA algorithm to generate session key and syndrome (ssk, C_{T0})
  ↓
Execute AES algorithm to generate cipher text C_{T1}
  ↓
Transmit C_T = (C_{T0}, C_{T1}) to receiver
```

### RIGHT BRANCH — Receiver/Decryption:
```
Execute SLDSPA algorithm to get error vector ẽ
  ↓
Obtain session key using SHA algorithm
  ↓
Decrypt the message using AES algorithm
  ↓
Return original message
  ↓
End
```

---
*[CONTINUED IN PART 3]*
