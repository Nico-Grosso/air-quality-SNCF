# Project documents

This folder holds the framing, method and data documents of the project **Station Air Risk**.
The text uses ASD-STE100 Simplified Technical English for most sentences.

## Documents

| PDF | Contents | Status |
|---|---|---|
| [pdf/product-charter.pdf](pdf/product-charter.pdf) | Problem, product, 5W2H, objectives, user stories, constraints, scope, risks, writing rules | v0.1 draft |
| [pdf/method.pdf](pdf/method.pdf) | Evidence rules, bias checklist, phases, pre-registration sheet, leakage rules | v0.1 draft |
| [pdf/data.pdf](pdf/data.pdf) | Source discovery and register, data handling rule, manifest, data dictionary, audit protocol | v0.1 draft |
| [pdf/registers.pdf](pdf/registers.pdf) | Gaps, hypotheses and decision log | Living document |
| [reference/DaSci_BDA_Projet.pdf](reference/DaSci_BDA_Projet.pdf) | Course brief | Reference |

## Folder structure

```
docs/
  Makefile          builds all PDFs
  latexmkrc         latexmk settings
  registers/        CSV registers: single source of truth
    gaps.csv  hypotheses.csv  decisions.csv  sources.csv  manifest.csv
  latex/
    common/         shared preamble, macros, tags, title page, glossary, register renderer
    01-product-charter/  02-method/  03-data/  04-registers/
  pdf/              built PDFs (committed)
  build/            temporary LaTeX files (not committed)
  reference/        external documents
```

## Build the PDFs

You need `latexmk` and `pdflatex` (TeX Live with `csvsimple`, `tcolorbox`, `xurl`).

1. Open a terminal in `docs/`.
2. Run `make`. The PDFs go to `pdf/`.
3. To build one document, run `make <name>`. Example: `make registers`.
4. To remove temporary files, run `make clean`.

If the build fails, read the log in `build/<name>/<name>.log`.

## Update a register

1. Open the CSV file in `registers/`.
2. Use a semicolon as the separator. Do not use semicolons or double quotes in the text.
3. Add a row with the next free ID. Do not reuse an ID. Do not delete a row: change its status.
4. Write the date in the `updated` field (YYYY-MM-DD).
5. Run `make`.
6. Commit the CSV file and the PDFs together.

## Rules

- Do not change files in `spark/data/`. Processing writes to `spark/lake/` (decision D-014).
- Give each fact an evidence tag: SOURCE, OBSERVED, INTERPRETATION, ASSUMED or UNKNOWN.
- Write the refutation test of a hypothesis before you run it.
- Each working decision has at least one rival in the decision log.
