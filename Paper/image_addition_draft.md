# Image Addition Draft — SAKE-IoT Paper
## LaTeX figure blocks ready to paste into latex_content.tex
## Source: figures_description.md + master_metrics_presentation_draft.md
## Date: 2026-03-04

> **How to use this file:**
> Each block below is a complete LaTeX `\begin{figure}...\end{figure}` environment.
> Paste each block at the exact location indicated inside `latex_content.tex`.
> The image files referenced already exist in `simulation/results/`.
> One new figure (Fig. 4 — Protocol Flow) needs to be created first — specification below.

---

## FIGURE 1 — Per-Packet Latency Comparison

**Paste location in latex_content.tex:** After the latency results table (line ~717, after `\end{table}` of `tab:latency`)

**Image file:** `../simulation/results/sim_latency.png` ✅ exists

```latex
\begin{figure}[!t]
\centering
\includegraphics[width=\columnwidth]{../simulation/results/sim_latency}
\caption{Cumulative per-packet computation latency: base paper~\cite{kumari2022}
vs.\ proposed SAKE-IoT. The base paper incurs a constant 7.3728~ms per packet
(solid red, linear growth). SAKE-IoT incurs a one-time 22.55~ms epoch initiation
(Phase~1) and $\approx$0.068~ms per Tier~2 packet (solid blue). Break-even occurs
at $N=4$ packets; at $N=100$, cumulative latency is \textbf{29.23~ms vs.\ 737.28~ms}
(25.2$\times$ improvement). Measured by MATLAB R2023b \texttt{tic/toc},
10,000-iteration average with 500-iteration JIT warm-up.}
\label{fig:latency}
\end{figure}
```

**In-text cross-reference** — add this sentence at the START of §8.2, before the table:

```latex
Figure~\ref{fig:latency} illustrates the cumulative latency comparison as a
function of session size~$N$.
```

---

## FIGURE 2 — Per-Packet Bandwidth Overhead Comparison

**Paste location:** After the bandwidth saving equation in §8.3 (after the `\begin{equation}` block for the 45.1% formula)

**Image file:** `../simulation/results/sim_bandwidth_bar.png` ✅ exists

```latex
\begin{figure}[!t]
\centering
\includegraphics[width=\columnwidth]{../simulation/results/sim_bandwidth_bar}
\caption{Per-packet communication overhead: base paper [1] vs.\ proposed SAKE-IoT.
\textbf{Tier~1 (epoch initiation):} both schemes carry identical overhead
(26,368~bits — ring signature + QC-LDPC public key, [1] \S12.1).
\textbf{Tier~2 (per data packet):} base paper transmits the QC-LDPC syndrome
$CT_0 = 408$~bits per packet ([1] \S10.2); SAKE-IoT transmits a 96-bit AES-GCM
nonce and 128-bit authentication tag (224~bits total, NIST SP~800-38D~[7]).
Net saving: \textbf{184~bits per Tier~2 packet (45.1\%).}}
\label{fig:bandwidth}
\end{figure}
```

**In-text cross-reference** — add at start of §8.3:

```latex
Figure~\ref{fig:bandwidth} shows the per-packet overhead decomposition for
both protocol phases.
```

---

## FIGURE 3 — Clock Cycles per Packet (Extends Base Paper Fig. 7)

**Paste location:** After the clock cycles table (after `\end{table}` of `tab:energy`)

**Image file:** `../simulation/results/sim_energy.png` ✅ exists

> **IMPORTANT NOTE on sim_energy.png:** The current sim_energy.png was generated
> from base paper Fig. 7 values only (Lizard, RLizard, LEDAkem, Base HE).
> The SAKE-IoT bar (0.074M cycles total) must be added before final submission.
> If the MATLAB script `sim_energy.m` already adds a SAKE bar, use the
> existing PNG. Otherwise run `sim_energy.m` with the SAKE bar enabled and
> re-export. Caption states the source for all non-SAKE bars is [1] Fig. 7.

```latex
\begin{figure}[!t]
\centering
\includegraphics[width=\columnwidth]{../simulation/results/sim_energy}
\caption{Comparative analysis of clock cycles per packet, extending the base
paper [1] Figure~7 with the proposed SAKE-IoT Tier~2 result.
\textbf{Blue bars:} encryption cycles.
\textbf{Orange bars:} decryption cycles.
Proposed SAKE Tier~2 requires a total of \textbf{74,000~cycles/packet}
(HKDF-SHA256: $\approx$6,000 cycles + AES-256-GCM: $\approx$68,000~cycles,
Intel AES-NI benchmark), representing a \textbf{33.1$\times$ reduction} over
the base paper Code-based HE (2,448,200~cycles). Conservative range: 24$\times$--33$\times$
acknowledging Intel CPU vs.\ Xilinx Virtex-6 FPGA platform variance.
Clock cycle values for Lizard, RLizard, LEDAkem, and Code-based HE are reproduced
from [1] Figure~7.}
\label{fig:energy}
\end{figure}
```

**In-text cross-reference** — add at start of §8.4:

```latex
Figure~\ref{fig:energy} extends the base paper~\cite{kumari2022} Fig.~7 with the
proposed SAKE Tier~2 bar, demonstrating the lowest clock cycle count across all
compared schemes.
```

---

## FIGURE 4 — SAKE-IoT Four-Phase Protocol Architecture Diagram

**This figure needs to be created — it does not yet exist as an image.**

**Paste location:** In §6.1 (Protocol Overview), immediately after the tiered architecture description paragraph.

**Figure creation options (choose one before submission):**
1. **Draw in LaTeX using TikZ** (preferred for Elsevier — no rasterization) — draft TikZ code below
2. **Draw externally** (LucidChart / draw.io) → export to PDF → `\includegraphics{sake_flow.pdf}`

### Draft TikZ Code (paste into preamble: add `\usepackage{tikz}` and `\usetikzlibrary{arrows.meta,positioning,shapes}`)

```latex
\begin{figure}[!t]
\centering
\begin{tikzpicture}[
  box/.style={draw, rounded corners, fill=blue!10, minimum width=3.2cm,
              minimum height=0.7cm, align=center, font=\small},
  pqbox/.style={draw, rounded corners, fill=red!10, minimum width=3.2cm,
                minimum height=0.7cm, align=center, font=\small},
  aedbox/.style={draw, rounded corners, fill=green!10, minimum width=3.2cm,
                 minimum height=0.7cm, align=center, font=\small},
  zerobox/.style={draw, rounded corners, fill=orange!15, minimum width=3.2cm,
                  minimum height=0.7cm, align=center, font=\small},
  arr/.style={-Stealth, thick},
  node distance=0.5cm
]

%% PHASE 1 — PQ Epoch Initiation (Tier 1)
\node[pqbox] (p1a) {Phase 1A: LR-IoTA\\Ring Signature Auth\\(Alg.\ 1--4, $\Delta_{\mathrm{SG}}$=13.3ms)};
\node[pqbox, below=of p1a] (p1b) {Phase 1B: QC-LDPC KEP\\Syndrome $CT_0$ + SLDSPA\\($\Delta_{\mathrm{Enc}}$+$\Delta_{\mathrm{Dec}}$=7.37ms)};
\node[pqbox, below=of p1b] (p1c) {Both derive:\\$K_{\mathrm{master}} = \mathrm{HMAC}(\tilde{\varepsilon})$};

%% PHASE 2 — Tier 2 Sender
\node[aedbox, below=1.2cm of p1c] (p2) {Phase 2 (Sender):\\$K_i \leftarrow \mathrm{HKDF}(K_m, \mathrm{Nonce}_i)$\\$(CT, TAG) \leftarrow \mathrm{AES\text{-}GCM\text{-}Enc}$\\$\approx$0.068 ms/packet};

%% PHASE 3 — Tier 2 Receiver
\node[aedbox, right=1.5cm of p2] (p3) {Phase 3 (Receiver):\\Drop if $\mathrm{Nonce}_i \leq \mathrm{Ctr}_{Rx}$\\$K_i \leftarrow \mathrm{HKDF}(K_m, \mathrm{Nonce}_i)$\\MAC-then-Decrypt};

%% PHASE 4 — Zeroization
\node[zerobox, below=1.2cm of p2] (p4) {Phase 4: Zeroization\\$K_m \leftarrow \mathbf{0}^{32}$, clear state\\Trigger new Phase 1};

%% Epoch bounds
\node[draw, dashed, right=0.6cm of p1c, font=\footnotesize, align=left] (bounds) {Epoch bounds:\\$N_{\max} = 2^{20}$ pkts\\$T_{\max} = 86400$s};

%% Arrows
\draw[arr] (p1a) -- (p1b);
\draw[arr] (p1b) -- (p1c);
\draw[arr] (p1c) -- node[right,font=\tiny]{Start Tier 2} (p2);
\draw[arr] (p2) -- node[above,font=\tiny]{(Nonce,CT,TAG)} (p3);
\draw[arr] (p2) -- node[right,font=\tiny]{Epoch expired} (p4);
\draw[arr] (p4.west) to[bend right=60] node[left,font=\tiny]{Re-key} (p1a.west);
\draw[dashed] (bounds) -- (p1c.east);

\end{tikzpicture}
\caption{SAKE-IoT four-phase protocol architecture. Phase~1 (red) performs the
full post-quantum epoch initiation (one-time 22.55~ms, Tier~1).
Phases~2--3 (green) execute lightweight AEAD per data packet ($\approx$0.068~ms,
Tier~2). Phase~4 (orange) triggers on epoch expiry ($\Nmax = 2^{20}$ packets or
$\Tmax = 86{,}400$~s), cryptographically overwrites $\Kmaster$, and re-initiates
Phase~1. The $\Kmaster$ state is shared only within the current epoch; each epoch
derives an independent $\Kmaster$ from a fresh Ring-LWE error vector~$\tilde{\varepsilon}$
(Theorem~3, Epoch-Bounded Forward Secrecy).}
\label{fig:protocol}
\end{figure}
```

**In-text cross-reference** — add at END of the §6.1 overview paragraph:

```latex
Figure~\ref{fig:protocol} illustrates the four-phase SAKE-IoT protocol architecture
and epoch lifecycle.
```

---

## CROSS-REFERENCE FIXES REQUIRED IN latex_content.tex

The following `Figure~\ref{}` calls must be inserted at specific locations in `latex_content.tex`.
Currently the figures are included but never referenced by `\ref{}` in the text.

| Figure | Label | Insert location in §8 |
|---|---|---|
| Fig. 1 (Latency) | `fig:latency` | Start of §8.2, before the table |
| Fig. 2 (Bandwidth) | `fig:bandwidth` | Start of §8.3, after the equation |
| Fig. 3 (Energy) | `fig:energy` | Start of §8.4, before the table |
| Fig. 4 (Protocol) | `fig:protocol` | End of §6.1 overview paragraph |

---

## METRICS CONTEXT FOR FIGURE CAPTIONS
*(Derived from master_metrics_presentation_draft.md — exact values)*

| Metric | Value to use in caption | Source |
|---|---|---|
| Base paper per-packet cost | 7.3728 ms (enc 1.5298 + dec 5.8430) | [1] Table 7 |
| SAKE Tier 2 per-packet cost | ≈0.068 ms (HKDF 0.019 + AES-GCM 0.047) | MATLAB empirical |
| Break-even | N = 4 packets | Algebraic derivation |
| Bandwidth base | 408 bits (CT₀ syndrome, X=408 rows) | [1] §10.2 |
| Bandwidth SAKE | 224 bits (96-bit nonce + 128-bit tag) | NIST SP 800-38D |
| Clock cycle base | 2,448,200 cycles (≈2.45×10⁶) | [1] Fig. 7 |
| Clock cycle SAKE | 74,000 cycles | Intel AES-NI |
| Reduction factor | 33.1× (conservative range: 24×–33×) | Ratio |
| JVM variance note | ±0.006 ms; 0.068 ms is conservative upper bound | master_metrics §M1 |
| GHASH overhead factor | ×1.20 applied to AES-GCM estimate | master_metrics §M1 disclaimer |

---

## SUMMARY TABLE — What to add, where

| # | Figure | Image exists? | Action needed |
|---|---|---|---|
| Fig. 1 | Latency line chart | ✅ sim_latency.png | Paste Fig. 1 block + add \ref in §8.2 |
| Fig. 2 | Bandwidth bar chart | ✅ sim_bandwidth_bar.png | Paste Fig. 2 block + add \ref in §8.3 |
| Fig. 3 | Clock cycles bar chart | ✅ sim_energy.png | Verify SAKE bar present; paste Fig. 3 block + add \ref |
| Fig. 4 (new) | Protocol flow diagram | ❌ Needs creation | Paste TikZ code in §6.1 and add \usepackage{tikz} to preamble |

---

*Derived from: figures_description.md, master_metrics_presentation_draft.md, simulation_results_record.md*
*For content gaps addressed by this draft: see content_verification_report.md GAP 7 and GAP 8*
*Generated: 2026-03-04*
