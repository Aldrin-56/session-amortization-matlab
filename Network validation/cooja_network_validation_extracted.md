# Cooja Network Validation — Extracted Content
## Source: Network validation/network_main.tex (939 lines)
## Extraction date: 2026-03-04
## Purpose: Raw extraction of all Cooja/network-layer simulation content, unmodified

---

## SIMULATION SETUP (from §6 Contiki-NG/Cooja subsection)

- **Platform:** Contiki-NG OS on Cooja Mote (JVM emulation)
- **Radio channel:** IEEE 802.15.4 virtual radio
- **MAC layer:** CSMA/CA
- **Network layer:** 6LoWPAN compression + RPL Lite routing
- **Metrics logger:** Custom JavaScript microsecond-resolution timestamps
- **Topology:** 2 nodes — Sender (IoT node) + Gateway (border router)
- **Simulation duration:** 2 complete amortization cycles (25 data messages + 2 renewals)
- **N_max in simulation:** 20 (practical; design value = 2²⁰)

---

## METRIC N1 — Authentication E2E Delay

**Value:** Δ_auth = **8,242.68 ms**

**Cause:** Dominated by 6LoWPAN fragmentation overhead, NOT computation.
- Authentication payload: **10,317 bytes** transmitted over **162 6LoWPAN fragments**
- ACK-based reliable delivery used
- Confirms amortization is critical from a *network* perspective

---

## METRIC N2 — Data Phase E2E Latency

**Value:** Δ_data = **25.096 ms**

**Reduction formula:**
```
E2E Reduction = (8,242.68 − 25.096) / 8,242.68 = 99.7%
```
**Note:** Exceeds MATLAB's 99.1% because single-frame data packet (52 bytes UDP)
costs drastically less than the 162-fragment auth payload at the network layer.

---

## METRIC N3 — Authentication Payload Breakdown

| Component | Bytes | Source |
|---|---|---|
| QC-LDPC Syndrome CT₀ | 13 | LDPC_ROWS/8 |
| Ring-LWE Public Key | 2,048 | n × 4 |
| Ring Sig. S₀ (signer) | 2,048 | Polynomial |
| Ring Sig. S₁ (member 1) | 2,048 | Polynomial |
| Ring Sig. S₂ (member 2) | 2,048 | Polynomial |
| Ring Sig. w (commitment) | 2,048 | Polynomial |
| SHA-256 Commit hash | 32 | Fixed |
| Keyword | 32 | Fixed |
| **Total payload** | **10,317** | |
| Fragmentation overhead | 1,458 | 162 × 9B hdr |
| **Total over-the-air** | **11,775** | |

---

## METRIC N4 — Per-Packet Data Overhead

**UDP frame structure:** 1B type + 8B SID + 4B ctr + 2B length + |m|B CT + 16B GCM tag = (31 + |m|)B

**For |m| = 13B:** total 44B UDP payload

**AEAD overhead:** Exactly **28 bytes** (12B nonce + 16B tag) — confirmed by simulation logger

---

## METRIC N5 — Session Renewal and EB-FS

**Two verified epoch renewal cycles:**

| Cycle | Auth (ms) | Setup (ms) | Data Msgs | EB-FS |
|---|---|---|---|---|
| 1 | 9,919.7 | 1.0 | 20 | — |
| 2 | 8,242.7 | 1.0 | 5 | ✓ |

**Gateway log confirmation (Cycle 2):**
`EB-FS: Zeroizing old K_master for renewing peer.`

**Key independence confirmed:**
- K_master(1) = `776cee61...`
- K_master(2) = `52685625...`
- Cryptographically independent → satisfies Epoch-Bounded FS

---

## METRIC N6 — Amortization Efficiency Ratio (AER)

**Formula:**
```
AER(N) = ((N-1) × B_auth) / (N × (B_auth + b))
where B_auth = 10,317 B (auth payload), b = 29 B/msg
```

**At N=20:** AER(20) = **94.7%**

**Byte counts confirmed from Cooja:**
- Unamortized: 20 × 10,317 = 206,340 B
- SAKE amortized: 10,317 + 20 × 29 = 10,897 B
- Saving: 195,443 B (94.7%)

---

## METRIC N7 (Bonus) — Packet Delivery Ratio

**PDR = 100%** (all data packets delivered, confirmed by Cooja log)

---

## CONSOLIDATED NINE-METRIC TABLE (from network_main.tex)

| ID | Metric | MATLAB | Cooja | Verdict |
|---|---|---|---|---|
| M1 | Computation reduction | 99.1% | 99.7% | Confirmed |
| M2 | BW saving/packet | 45.1% | 45.1% | Exact |
| M3 | Cycle reduction | 33× | Arch. | Confirmed |
| N1 | Auth E2E | — | 8,242 ms | Network |
| N2 | Data E2E | — | 25 ms | Network |
| N3 | Auth payload | 3,449 B | 11,775 B | Fragmented |
| N4 | Data overhead | 28 B | 28 B | Exact |
| N5 | Renewals | Thm. | 2 cycles | Empirical |
| N6 | AER @ N=20 | 94.7% | 94.7% | Exact |
| — | PDR | — | 100% | Perfect |

---

## PROTOCOL ARCHITECTURE IN network_main.tex

### Phase 1 — 1-RTT Post-Quantum Handshake
- Sender → GW: {pk_se, S_se, CT₀, K} (162 frags)
- GW verifies ring sig, SLDSPA-decodes ε̃
- GW → Sender: {SID, N_G} (ACK)
- **SID = Session ID (8 bytes)**
- **N_G = Gateway nonce (freshness binding)**

### Phase 2 — Session Key Extraction (separate phase in network_main.tex)
K_master = HKDF-SHA256(ε̃ ‖ N_G, "master-key")
- Note: Gateway nonce N_G is added for KCI (Key Compromise Impersonation) resistance

### Phase 3 — Amortized Data Transmission
K_i = HKDF(K_master, "session-key" ‖ SID ‖ ctr)
η = SID ‖ ctr  (96-bit GCM nonce)
AAD = SID ‖ ctr
(C, τ) = AES-256-GCM-Enc(K_i, η, m, AAD)
Transmit: type ‖ SID ‖ ctr ‖ |C| ‖ C ‖ τ

### Phase 4 — Epoch Renewal
secure_zero(K_master); re-initiate Phase 1

---

## DISCUSSION NOTES FROM network_main.tex

**Cooja JVM timing:** E2E latencies (8,242 ms auth, 25 ms data) represent pure network
transit times. On real MSP430 @ 8MHz, AES-256-GCM adds ≈0.99 ms/packet (< 4% of 25ms).

**AES-GCM vs AES-128-CTR/HMAC:** Chosen for:
1. 256-bit key → 128-bit post-quantum security (Grover's bound)
2. 28-byte overhead exactly matches MATLAB bandwidth model
3. Single-pass AEAD, less implementation complexity

**RAM footprint:** AES-256-GCM stack ≈ 450B. Ring-LWE arrays (n=512) ≈ 30.9 KB sender.
Exceeds Class-1 8KB limit → requires Class-2+ or reduced parameters (n=32).
