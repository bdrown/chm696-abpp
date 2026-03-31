# visualize_usp14.pml
#
# PyMOL script for mapping reactive cysteines onto the USP14 structure.
#
# This script fetches the crystal structure of the human USP14 catalytic
# domain (PDB: 2AYN), highlights all cysteine residues, and marks the
# catalytic triad. Students should edit the HIT_CYSTEINES list below to
# include the cysteine residue number(s) identified as hits in their
# analysis.
#
# Usage (from Scholar ThinLinc terminal):
#   module load pymol
#   pymol visualize_usp14.pml
#
# Alternatively, run commands interactively in PyMOL's command line.
#
# IMPORTANT: Residue numbering in PDB 2AYN is offset by -1 from
# UniProt numbering for USP14 (P54578). For example, the catalytic
# cysteine is C114 in UniProt but C113 in 2AYN. The structure covers
# residues 90-493 in PDB numbering (91-494 in UniProt). If your
# search results report cysteine positions using UniProt numbering
# (e.g. from a UniProt-derived FASTA database), subtract 1 to get
# the correct PDB residue number for selections below.

# -----------------------------------------------------------------------
# STEP 1: Fetch structure
# -----------------------------------------------------------------------
fetch 2AYN, async=0
split_chains 2AYN
delete 2AYN

# Work with chain A (all three chains in the ASU are equivalent)
set_name 2AYN_A, USP14

# Clean up other chains
delete 2AYN_B
delete 2AYN_C

# -----------------------------------------------------------------------
# STEP 2: Basic display settings
# -----------------------------------------------------------------------
bg_color white
hide everything, USP14
show cartoon, USP14
color palecyan, USP14
set cartoon_transparency, 0.15, USP14
set ray_shadow, 0

# -----------------------------------------------------------------------
# STEP 3: Highlight all cysteines
# -----------------------------------------------------------------------
select all_cys, USP14 and resn CYS
show sticks, all_cys and sidechain
color yellow, all_cys and sidechain
label all_cys and name CA, "C%s" % resi

# -----------------------------------------------------------------------
# STEP 4: Mark the catalytic triad (Cys113, His434, Asp450 in PDB numbering)
#         These correspond to Cys114, His435, Asp451 in UniProt numbering.
# -----------------------------------------------------------------------
select catalytic_cys, USP14 and resi 113 and resn CYS
select catalytic_his, USP14 and resi 434 and resn HIS
select catalytic_asp, USP14 and resi 450 and resn ASP
select catalytic_triad, catalytic_cys or catalytic_his or catalytic_asp

show sticks, catalytic_triad and sidechain
color red, catalytic_cys and sidechain
color marine, catalytic_his and sidechain
color orange, catalytic_asp and sidechain

# -----------------------------------------------------------------------
# STEP 5: Map hit cysteines from your data
# -----------------------------------------------------------------------
# >>> EDIT THIS LIST <<<
# Replace the example residue numbers with the USP14 cysteine(s) that
# AC35 (or other compounds) hit in your analysis. You can find the
# residue number by looking at the "Index" column in your filtered
# ratio file. The index format is typically "UniProtAccession_CysNNN"
# where NNN uses UniProt numbering. Subtract 1 to get PDB numbering.
#
# Example: if your search results report a hit at C105 (UniProt), use
# resi 104 in the selection below:
#   select hit_cys, USP14 and resi 104 and resn CYS

select hit_cys, USP14 and resi 113 and resn CYS   # <-- EDIT THIS

show spheres, hit_cys and sidechain
color magenta, hit_cys and sidechain
set sphere_scale, 0.5, hit_cys

# -----------------------------------------------------------------------
# STEP 6: Measure distance from hit cysteine to catalytic cysteine
# -----------------------------------------------------------------------
# This creates a dashed line showing the distance between the sulfur
# atoms of the hit cysteine and the catalytic C113 (PDB) / C114 (UniProt).
# If your hit IS C113, the distance will be 0 and you can skip this.

# Uncomment and edit if your hit cysteine is NOT C113:
# distance hit_to_active, hit_cys and name SG, catalytic_cys and name SG
# set dash_color, gray50, hit_to_active

# -----------------------------------------------------------------------
# STEP 7: Camera and rendering
# -----------------------------------------------------------------------
orient USP14
zoom hit_cys, 15
set label_size, 14
set label_color, black
set label_font_id, 7

# -----------------------------------------------------------------------
# STEP 8: Save a figure (optional)
# -----------------------------------------------------------------------
# Uncomment the lines below to ray-trace and save a publication image.
# set ray_trace_mode, 1
# ray 2400, 1800
# png usp14_hit_cysteines.png, dpi=300
