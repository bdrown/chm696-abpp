#!/usr/bin/python

import csv
import argparse

def remove_na_rows_ignore_header(input_file, output_file):
    """
    Removes rows containing "NA" from a TSV file, ignoring the header row.

    Args:
        input_file (str): Path to the input TSV file.
        output_file (str): Path to the output TSV file.
    """
    with open(input_file, 'r', newline='', encoding='utf-8') as infile, \
         open(output_file, 'w', newline='', encoding='utf-8') as outfile:

        reader = csv.reader(infile, delimiter='\t')
        writer = csv.writer(outfile, delimiter='\t')

        header = next(reader)
        writer.writerow(header)

        for row in reader:
            if not any("NA" in cell for cell in row):
                writer.writerow(row)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Remove rows containing 'NA' from a TSV file.")
    parser.add_argument("input_file", help="Path to the input TSV file")
    parser.add_argument("output_file", help="Path to the output TSV file")

    args = parser.parse_args()

    remove_na_rows_ignore_header(args.input_file, args.output_file)
    print(f"Rows containing 'NA' removed. Output written to {args.output_file}")