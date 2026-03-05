# Reference List — SAKE-IoT Research Paper
## Complete Bibliography (~25 references) for Scopus Submission

> **FORMAT:** References are numbered and grouped by category.
> All RFC/NIST/DOI links included for verification.
> BibTeX keys provided for LaTeX `\bibliography{}` use.
> **[1] is the mandatory anchor — verify DOI before submission.**

---

## Category 1 — Anchor / Base Paper

**[1]** S. Kumari, M. Singh, R. Singh, and H. Tewari, "A post-quantum lattice-based lightweight authentication and code-based hybrid encryption scheme for IoT devices," *Computer Networks*, vol. 217, p. 109327, Oct. 2022.
**DOI:** 10.1016/j.comnet.2022.109327
```bibtex
@article{kumari2022postquantum,
  author  = {Kumari, Swati and Singh, Maninder and Singh, Raman and Tewari, Hitesh},
  title   = {A post-quantum lattice-based lightweight authentication and code-based hybrid encryption scheme for {IoT} devices},
  journal = {Computer Networks},
  volume  = {217},
  pages   = {109327},
  year    = {2022},
  doi     = {10.1016/j.comnet.2022.109327}
}
```

---

## Category 2 — IETF Standards (Algorithm Foundations)

**[2]** H. Krawczyk and P. Eronen, "HMAC-based Extract-and-Expand Key Derivation Function (HKDF)," RFC 5869, IETF, May 2010.
URL: https://www.rfc-editor.org/rfc/rfc5869
```bibtex
@techreport{rfc5869,
  author = {Krawczyk, H. and Eronen, P.},
  title  = {{HMAC}-based Extract-and-Expand Key Derivation Function ({HKDF})},
  type   = {{RFC}},
  number = {5869},
  institution = {IETF},
  year   = {2010}
}
```

**[3]** H. Krawczyk, M. Bellare, and R. Canetti, "HMAC: Keyed-Hashing for Message Authentication," RFC 2104, IETF, Feb. 1997.
URL: https://www.rfc-editor.org/rfc/rfc2104
```bibtex
@techreport{rfc2104,
  author = {Krawczyk, H. and Bellare, M. and Canetti, R.},
  title  = {{HMAC}: Keyed-Hashing for Message Authentication},
  type   = {{RFC}},
  number = {2104},
  institution = {IETF},
  year   = {1997}
}
```

**[4]** E. Rescorla, "The Transport Layer Security (TLS) Protocol Version 1.3," RFC 8446, IETF, Aug. 2018.
URL: https://www.rfc-editor.org/rfc/rfc8446
```bibtex
@techreport{rfc8446,
  author = {Rescorla, E.},
  title  = {The Transport Layer Security ({TLS}) Protocol Version 1.3},
  type   = {{RFC}},
  number = {8446},
  institution = {IETF},
  year   = {2018}
}
```

**[5]** E. Rescorla, H. Tschofenig, N. Modadugu, "The Datagram Transport Layer Security (DTLS) Protocol Version 1.3," RFC 9147, IETF, Apr. 2022.
URL: https://www.rfc-editor.org/rfc/rfc9147
```bibtex
@techreport{rfc9147,
  author = {Rescorla, E. and Tschofenig, H. and Modadugu, N.},
  title  = {The Datagram Transport Layer Security ({DTLS}) Protocol Version 1.3},
  type   = {{RFC}},
  number = {9147},
  institution = {IETF},
  year   = {2022}
}
```

**[6]** G. Selander, J. Mattsson, F. Palombini, and L. Seitz, "Object Security for Constrained RESTful Environments (OSCORE)," RFC 8613, IETF, Jul. 2019.
URL: https://www.rfc-editor.org/rfc/rfc8613
```bibtex
@techreport{rfc8613,
  author = {Selander, G. and Mattsson, J. and Palombini, F. and Seitz, L.},
  title  = {Object Security for Constrained {RESTful} Environments ({OSCORE})},
  type   = {{RFC}},
  number = {8613},
  institution = {IETF},
  year   = {2019}
}
```

---

## Category 3 — NIST Standards

**[7]** M. Dworkin, "Recommendation for Block Cipher Modes of Operation: Galois/Counter Mode (GCM) and GMAC," NIST Special Publication 800-38D, Nov. 2007.
URL: https://doi.org/10.6028/NIST.SP.800-38D
```bibtex
@techreport{nist80038d,
  author      = {Dworkin, Morris},
  title       = {Recommendation for Block Cipher Modes of Operation: {Galois/Counter Mode (GCM)} and {GMAC}},
  institution = {National Institute of Standards and Technology},
  number      = {NIST SP 800-38D},
  year        = {2007},
  doi         = {10.6028/NIST.SP.800-38D}
}
```

**[8]** R. Kissel, A. Regenscheid, M. Scholl, and K. Stine, "Guidelines for Media Sanitization," NIST Special Publication 800-88 Rev. 1, Dec. 2014.
URL: https://doi.org/10.6028/NIST.SP.800-88r1
```bibtex
@techreport{nist80088,
  author      = {Kissel, R. and Regenscheid, A. and Scholl, M. and Stine, K.},
  title       = {Guidelines for Media Sanitization},
  institution = {NIST},
  number      = {NIST SP 800-88 Rev. 1},
  year        = {2014},
  doi         = {10.6028/NIST.SP.800-88r1}
}
```

**[9]** NIST, "Module-Lattice-Based Key-Encapsulation Mechanism Standard (ML-KEM / CRYSTALS-Kyber)," Federal Information Processing Standard FIPS 203, Aug. 2024.
URL: https://doi.org/10.6028/NIST.FIPS.203
```bibtex
@techreport{fips203,
  author      = {{National Institute of Standards and Technology}},
  title       = {Module-Lattice-Based Key-Encapsulation Mechanism Standard},
  institution = {NIST},
  number      = {FIPS 203},
  year        = {2024},
  doi         = {10.6028/NIST.FIPS.203}
}
```

---

## Category 4 — Ring-LWE / Lattice Foundations

**[10]** O. Regev, "On lattices, learning with errors, random linear codes, and cryptography," *J. ACM*, vol. 56, no. 6, Art. 34, Sep. 2009. (Original LWE paper)
DOI: 10.1145/1568318.1568324
```bibtex
@article{regev2009lattices,
  author  = {Regev, Oded},
  title   = {On lattices, learning with errors, random linear codes, and cryptography},
  journal = {Journal of the ACM},
  volume  = {56},
  number  = {6},
  pages   = {34:1--34:40},
  year    = {2009},
  doi     = {10.1145/1568318.1568324}
}
```

**[11]** V. Lyubashevsky, C. Peikert, and O. Regev, "On ideal lattices and learning with errors over rings," *J. ACM*, vol. 60, no. 6, pp. 1–35, Nov. 2013. (Ring-LWE)
DOI: 10.1145/2535925
```bibtex
@article{lyubashevsky2013ideal,
  author  = {Lyubashevsky, Vadim and Peikert, Chris and Regev, Oded},
  title   = {On ideal lattices and learning with errors over rings},
  journal = {Journal of the ACM},
  volume  = {60},
  number  = {6},
  year    = {2013},
  doi     = {10.1145/2535925}
}
```

**[12]** C. Peikert, "Public-key cryptosystems from the worst-case shortest vector problem," in *Proc. 41st STOC*, pp. 333–342, 2009.
```bibtex
@inproceedings{peikert2009public,
  author    = {Peikert, Chris},
  title     = {Public-key cryptosystems from the worst-case shortest vector problem},
  booktitle = {Proc. 41st ACM Symposium on Theory of Computing (STOC)},
  pages     = {333--342},
  year      = {2009}
}
```

---

## Category 5 — QC-LDPC / Code-Based Cryptography

**[13]** R. G. Gallager, "Low-density parity-check codes," *IRE Trans. Inf. Theory*, vol. 8, no. 1, pp. 21–28, Jan. 1962.
DOI: 10.1109/TIT.1962.1057683
```bibtex
@article{gallager1962low,
  author  = {Gallager, Robert G.},
  title   = {Low-density parity-check codes},
  journal = {IRE Transactions on Information Theory},
  volume  = {8},
  number  = {1},
  pages   = {21--28},
  year    = {1962},
  doi     = {10.1109/TIT.1962.1057683}
}
```

**[14]** M. Baldi, M. Bianchi, F. Chiaraluce, J. Rosenthal, and D. Schipani, "Enhanced public key security for the McEliece cryptosystem," *J. Cryptology*, vol. 29, pp. 1–27, 2016.
DOI: 10.1007/s00145-014-9187-8
```bibtex
@article{baldi2016enhanced,
  author  = {Baldi, Marco and Bianchi, Marco and Chiaraluce, Franco and Rosenthal, Joachim and Schipani, Davide},
  title   = {Enhanced public key security for the {McEliece} cryptosystem},
  journal = {Journal of Cryptology},
  volume  = {29},
  pages   = {1--27},
  year    = {2016},
  doi     = {10.1007/s00145-014-9187-8}
}
```

---

## Category 6 — IoT Security / Authentication Protocols

**[15]** P. Porambage, J. Okwuibe, M. Liyanage, M. Ylianttila, and T. Taleb, "Survey on multi-access edge computing for internet of things realization," *IEEE Commun. Surveys Tuts.*, vol. 20, no. 4, pp. 2961–2991, 2018.
DOI: 10.1109/COMST.2018.2849509
```bibtex
@article{porambage2018survey,
  author  = {Porambage, Pawani and Okwuibe, Jude and Liyanage, Madhusanka and Ylianttila, Mika and Taleb, Tarik},
  title   = {Survey on multi-access edge computing for internet of things realization},
  journal = {IEEE Communications Surveys \& Tutorials},
  volume  = {20},
  number  = {4},
  pages   = {2961--2991},
  year    = {2018},
  doi     = {10.1109/COMST.2018.2849509}
}
```

**[16]** J. Granjal, E. Monteiro, and J. S. Silva, "Security for the internet of things: a survey of existing protocols and open research issues," *IEEE Commun. Surveys Tuts.*, vol. 17, no. 3, pp. 1294–1312, 2015.
DOI: 10.1109/COMST.2015.2388550
```bibtex
@article{granjal2015security,
  author  = {Granjal, Jorge and Monteiro, Edmundo and Silva, Jorge S{\'a}},
  title   = {Security for the internet of things: a survey of existing protocols and open research issues},
  journal = {IEEE Communications Surveys \& Tutorials},
  volume  = {17},
  number  = {3},
  pages   = {1294--1312},
  year    = {2015},
  doi     = {10.1109/COMST.2015.2388550}
}
```

---

## Category 7 — Related Work from Base Paper §4 (Already analyzed)

> These are already cited in base paper [1] — reuse their exact BibTeX from the base paper's reference list (DOI 10.1016/j.comnet.2022.109327).

**[17]** H. Wang et al. — Adaptive NTT polynomial multiplier [cited as [30] in base paper]

**[18]** P. Mundhe et al. — SPM polynomial multiplication [cited as [40] in base paper]

**[19]** M. HAN et al. — Trapdoor ring signature for IoT [cited as [39] in base paper]

**[20]** K.-A. Shim — Secure V2I/V2V communications [cited as [24] in base paper]

**[21]** G. S. Aujla et al. — Code-based cloud IoT scheme [cited as [29] in base paper]

**[22]** J. Hu et al. — QC-LDPC FPGA implementation [cited as [37] in base paper]

**[23]** J. Lee et al. — RLizard key encapsulation [cited as [38] in base paper]

> **Note:** Full citations for [17]–[23] copy-paste directly from the reference list of base paper [1]. Do NOT independently reconstruct them — use the exact text from DOI 10.1016/j.comnet.2022.109327 to avoid citation errors.

---

## Category 8 — Formal Security / IND-CCA2 Foundations

**[24]** M. Bellare and P. Rogaway, "Entity Authentication and Key Distribution," in *Proc. CRYPTO 1993*, LNCS vol. 773, pp. 232–249.
```bibtex
@inproceedings{bellare1993entity,
  author    = {Bellare, Mihir and Rogaway, Phillip},
  title     = {Entity Authentication and Key Distribution},
  booktitle = {Advances in Cryptology -- {CRYPTO} 1993},
  series    = {LNCS},
  volume    = {773},
  pages     = {232--249},
  year      = {1993}
}
```

**[25]** M. Bellare and P. Rogaway, "Random Oracles are Practical: A Paradigm for Designing Efficient Protocols," in *Proc. 1st CCS*, pp. 62–73, 1993.
```bibtex
@inproceedings{bellare1993random,
  author    = {Bellare, Mihir and Rogaway, Phillip},
  title     = {Random Oracles are Practical: A Paradigm for Designing Efficient Protocols},
  booktitle = {Proc. 1st ACM Conference on Computer and Communications Security (CCS)},
  pages     = {62--73},
  year      = {1993}
}
```

---

## Usage Notes for Paper Building

| Reference | Used In Paper Section | Claim It Supports |
|---|---|---|
| [1] | ALL — anchor for all values | Base paper ground truth |
| [2] RFC 5869 | §6 Phase 2 Step 2.3, §7.2, Footnote 1 | HKDF is RFC-standard; 32-byte = 1 HMAC call |
| [3] RFC 2104 | §6 Phase 1.2, §7.2 | HMAC-SHA256 standard definition |
| [4] RFC 8446 | §3.4 Related Work (TLS 1.3 comparison) | TLS 1.3 is classical-only |
| [5] RFC 9147 | §3.4 Related Work (DTLS 1.3 comparison) | DTLS nonce-reuse risk on lossy channels |
| [6] RFC 8613 | §9 Future Work item 4 | OSCORE/CoAP integration |
| [7] NIST 800-38D | §6 Phase 2.4 (AES-GCM), §7.2 | GHASH TAG forgery probability 2⁻¹²⁸ |
| [8] NIST 800-88 | §7.4 Proof 3 Implementation Note | Secure memory erasure (`memset_s`) |
| [9] FIPS 203 | §9 Future Work item 3 | CRYSTALS-Kyber NIST 2024 |
| [10] Regev 2009 | §4 Preliminaries (LWE) | LWE hardness foundational paper |
| [11] Lyubashevsky 2013 | §4 Preliminaries (Ring-LWE) | Ring-LWE formal definition |
| [12] Peikert 2009 | §4 Sec. proof (lattice hardness) | Worst-case to average-case reduction |
| [13] Gallager 1962 | §4 Preliminaries (LDPC) | LDPC code foundational paper |
| [14] Baldi 2016 | §4 QC-LDPC description | QC-LDPC code-based crypto |
| [15] Porambage 2018 | §1 Introduction (IoT survey) | IoT security motivation |
| [16] Granjal 2015 | §1 Introduction, §3 Related Work | IoT protocol security landscape |
| [17]–[23] | §3 Related Work, §8 Performance | Per base paper §4 citations |
| [24] Bellare & Rogaway 1993 | §7 Security Analysis intro | IND-CCA2 game formalization |
| [25] Bellare & Rogaway 1993 | §7 Security Analysis, ROM | Random Oracle Model justification |

---

*Source file: `Validation and Fix/gap_resolution_proposals.md` Gap 1*
*All RFC and NIST DOIs verified as live URLs.*
