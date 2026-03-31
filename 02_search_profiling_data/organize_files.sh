#!/bin/bash
#
# organize_files.sh
#
# Organizes raw mass spectrometry files and TMT annotation files into
# the directory structure expected by FragPipe. Run this script from the
# directory containing the downloaded .raw files.
#
# Usage:
#   bash organize_files.sh /path/to/raw/files /path/to/annotation/files
#
# Example:
#   bash organize_files.sh $SCRATCH/hct_cys ~/chm696-abpp/02_search_profiling_data
#
# After running, the directory tree at /path/to/raw/files will look like:
#   TMT01/
#   ├── JM5065_HCT_Cys_TMT1-1.raw
#   ├── JM5066_HCT_Cys_TMT1-2.raw
#   └── TMT01_annotation.txt
#   TMT02/
#   ├── ...
#   ...

set -euo pipefail

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
    echo "Usage: bash organize_files.sh <raw_dir> [annotation_dir]"
    echo ""
    echo "  raw_dir         Directory containing the downloaded .raw files"
    echo "  annotation_dir  Directory containing *_annotation.txt files"
    echo "                  (default: current working directory)"
    exit 1
fi

RAW_DIR="${1}"
ANNO_DIR="${2:-.}"

if [[ ! -d "$RAW_DIR" ]]; then
    echo "Error: raw file directory '$RAW_DIR' does not exist."
    exit 1
fi

# ---------------------------------------------------------------------------
# Create TMT directories and move raw files
# ---------------------------------------------------------------------------
echo "Organizing raw files in: $RAW_DIR"

moved=0
for raw in "$RAW_DIR"/JM*_HCT_Cys_TMT*.raw; do
    [[ -e "$raw" ]] || continue  # skip if glob matches nothing

    # Extract the TMT group number from the filename
    # e.g. JM5065_HCT_Cys_TMT1-1.raw  -->  1
    basename_raw=$(basename "$raw")
    tmt_num=$(echo "$basename_raw" | sed -n 's/.*_TMT\([0-9]*\)-.*/\1/p')

    if [[ -z "$tmt_num" ]]; then
        echo "  Warning: could not parse TMT number from '$basename_raw', skipping."
        continue
    fi

    # Zero-pad the directory name to two digits (TMT01 .. TMT19)
    tmt_dir=$(printf "TMT%02d" "$tmt_num")
    target_dir="$RAW_DIR/$tmt_dir"

    mkdir -p "$target_dir"
    mv "$raw" "$target_dir/"
    echo "  $basename_raw -> $tmt_dir/"
    ((moved++))
done

echo "Moved $moved raw file(s)."

# ---------------------------------------------------------------------------
# Copy annotation files into the appropriate TMT directories
# ---------------------------------------------------------------------------
copied=0
for anno in "$ANNO_DIR"/TMT*_annotation.txt; do
    [[ -e "$anno" ]] || continue

    basename_anno=$(basename "$anno")

    # Extract the TMT number from the annotation filename
    # Handle both TMT01_annotation.txt and TMT4_annotation.txt styles
    tmt_num=$(echo "$basename_anno" | sed -n 's/TMT0*\([0-9]*\)_annotation.txt/\1/p')

    if [[ -z "$tmt_num" ]]; then
        echo "  Warning: could not parse TMT number from '$basename_anno', skipping."
        continue
    fi

    tmt_dir=$(printf "TMT%02d" "$tmt_num")
    target_dir="$RAW_DIR/$tmt_dir"

    if [[ -d "$target_dir" ]]; then
        cp "$anno" "$target_dir/"
        echo "  $basename_anno -> $tmt_dir/"
        ((copied++))
    else
        echo "  Warning: directory '$tmt_dir' not found for '$basename_anno', skipping."
    fi
done

echo "Copied $copied annotation file(s)."

# ---------------------------------------------------------------------------
# Validation summary
# ---------------------------------------------------------------------------
echo ""
echo "=== Validation ==="
errors=0
for i in $(seq 1 19); do
    tmt_dir=$(printf "TMT%02d" "$i")
    dir_path="$RAW_DIR/$tmt_dir"

    if [[ ! -d "$dir_path" ]]; then
        echo "  MISSING: $tmt_dir directory not found"
        ((errors++))
        continue
    fi

    raw_count=$(find "$dir_path" -maxdepth 1 -name "*.raw" | wc -l)
    anno_count=$(find "$dir_path" -maxdepth 1 -name "*_annotation.txt" | wc -l)

    status=""
    if [[ "$raw_count" -ne 2 ]]; then
        status="$status [expected 2 .raw files, found $raw_count]"
        ((errors++))
    fi
    if [[ "$anno_count" -ne 1 ]]; then
        status="$status [expected 1 annotation file, found $anno_count]"
        ((errors++))
    fi

    if [[ -z "$status" ]]; then
        echo "  OK: $tmt_dir (2 raw, 1 annotation)"
    else
        echo "  ISSUE: $tmt_dir$status"
    fi
done

if [[ "$errors" -eq 0 ]]; then
    echo ""
    echo "All 19 TMT directories are correctly organized."
else
    echo ""
    echo "$errors issue(s) detected. Review the output above."
fi
