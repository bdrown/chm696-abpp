# Structural Analysis and Selectivity Assessment

This section extends the interpretation of your cysteine reactivity profiling results. After identifying hit compounds with z-score > 3, you will map the hit cysteines onto a three-dimensional structure of USP14 and critically evaluate whether AC35 represents a viable starting point for selective inhibitor development.

## Mapping Hit Cysteines onto USP14

Ubiquitin-specific protease 14 ([USP14](https://www.uniprot.org/uniprotkb/P54578/entry)) is a deubiquitinase that reversibly associates with the 26S proteasome. It contains an N-terminal ubiquitin-like (UBL) domain and a C-terminal catalytic USP domain. The catalytic triad consists of Cys114, His435, and Asp451 in UniProt numbering (P54578). Crystal structures of the isolated catalytic domain ([PDB: 2AYN](https://www.rcsb.org/structure/2AYN)) and ubiquitin-bound form ([PDB: 2AYO](https://www.rcsb.org/structure/2AYO)) are available, and cryo-EM structures of USP14 bound to the 26S proteasome have been determined at high resolution ([PDB: 7W3F](https://www.rcsb.org/structure/7W3F) and related entries).

> **Numbering note:** PDB 2AYN residue numbers are offset by **-1** from UniProt numbering. The catalytic triad is Cys113, His434, and Asp450 in the PDB file. If your FragPipe search results use a UniProt-derived FASTA database, the cysteine positions reported in your output will use UniProt numbering. Subtract 1 when editing the PyMOL script selections.

### Instructions

1. **Identify the hit cysteine(s).** In your filtered ratio file, find all rows corresponding to USP14 (UniProt accession P54578). For each hit cysteine identified with AC35 (z-score > 3), record the residue number.

2. **Launch PyMOL.** On Scholar, launch PyMOL from the `/class/bsdrown/apps` folder and run the provided script:

```bash
/class/bsdrown/apps/pymol/pymol ~/chm696-abpp/04_structural_analysis/visualize_usp14.pml
```

3. **Edit the script.** Open the `visualize_usp14.pml` file and replace the placeholder residue number in the `hit_cys` selection with the cysteine(s) you identified in step 1. Remember to subtract 1 from UniProt numbering to get the PDB residue number. If you have multiple hit cysteines on USP14, you can select them together (e.g. `resi 113+202`).

4. **Examine the structure.** The script will display the USP14 catalytic domain (PDB: 2AYN, chain A) with all cysteines in yellow sticks, the catalytic triad in red/blue/orange, and your hit cysteine(s) as magenta spheres.

### Questions

5. Where is the hit cysteine located relative to the catalytic triad? Measure the distance (in Ångströms) between the sulfur atom of your hit cysteine and the sulfur atom of the catalytic Cys113 (PDB numbering; Cys114 in UniProt). Is the hit cysteine in the active site cleft, on the protein surface, or buried in the interior? Include a figure that visualizes all the relevant cysteines.

6. Based on the location of the hit cysteine, would you predict that a covalent modification at this site would inhibit USP14 deubiquitinase activity? Briefly explain your reasoning (e.g. would it directly block substrate binding, allosterically disrupt folding, or have no functional consequence?).

7. Compare the structure of the free enzyme (2AYN) with the ubiquitin-bound form (2AYO). Does the hit cysteine become more or less solvent-exposed upon ubiquitin binding? You can overlay the two structures with the PyMOL command: `fetch 2AYO; align 2AYO and chain A, USP14`
