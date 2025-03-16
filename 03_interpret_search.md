# Proteomics Assignment

Once the database search, peptide identification, protein inference, and quantification have been completed in the [first part of the assignment](02_search_profiling_data.md), the next step is to interpret our findings. Perform the following analysis and answer the associate questions.

## Overall Identifications

In the results folder, you will find many [output files](https://fragpipe.nesvilab.org/docs/tutorial_fragpipe_outputs.html) that describe the search results. Using the `combined_peptide.tsv`, `combined_modified_peptide.tsv`, and `combined_protein.tsv` files, answer the following questions:

1. How many peptides were identified in this study?
2. How many peptides were identified with a cysteine-reactive probe attached? 
3. How many protein groups were identified in this study?
4. Which non-contaminant protein group was identified the greatest number of times?

## Interpreting Reactivity

In the `tmt-report` folder you will find the quantification results. Quantification was performed at multiple levels (peptide, protein, and PTM-site) and reported as absolute abundances and ratios to the reference channel (e.g. DMSO).

Inspect the `ratio_single-site_None.tsv` file. This file lists all of the quantified peptides that contain a modified cysteine and the ratio of their abundance in each sample relative to the reference channel. Answer the following questions:

1. How many reactive cysteines were quantified?
2. How does this value compare to the number of peptides that were identified with an attached cysteine-reactive probe? Why might these numbers differ?
3. This file has many `NA` values, which indicates that the listed cysteine was not quantified in that specific LC-MS acquisition. Why are there so many `NA` values or put another way - what can cause a peptide to be quantified in one sample but not another?

### Filter Results

These incomplete data are still valuable but to keep things simple, let's only work with cysteine sites that were quantified in all channels and in all samples. This can be accomplished with a `sed` command:

```sh
sed '1b; /NA/d' ratio_single-site_None.tsv > ratio_single-site_None_filtered.tsv
```

`sed` is a builtin stream editor that reads a file and makes changes as it outputs it again. In this case, when a line in a file matches the regular expression `/NA/`, it is deleted with the `d` command. This will create a new file `ratio_single-site_None_filtered.tsv` that only contains cysteines that were quantified in all samples. You will find the filtered data set much smaller than the full dataset.

If you are more comfortable with a scripting language, the Python script `03_interpret_search/remove_nas.py` can accomplish the same things but is less efficient.

### Hit Calling

Our next step is to calculate the competition ratio (CR) for each compound against each cysteine. The competition ratio is defined as the abundance of the peptide when treated with DMSO divided by the abundance of the peptide when treated with the test compound. The tsv file that we just created is the reciprocal of the CR, so calculating the CR is straightforward.

Think of these CR values as a response in a high-throughput screen. We can use a similar approach to the one we took for interpreting HTS data in a previous assignment. Standardize our data by calculating the z-score for each cysteine-compound pair. Using a z-score of 3 or greater as the threshold for hits, answer the following questions:

1. Overall, how many hits (z-score > 3) do we observe in this dataset? What is the hit-rate?
2. Which compound proved to be the most promiscuous (greatest number of hits)?
3. Which cysteine was the most promiscuous (greatest number of compounds it engaged)?
4. I am interested in discovering selective covalent inhibitors of the deubiquitinase USP14 and see one compounds (AC35) hit against it in both biological replicates. Would this be a good starting point for developing a selective inhibitor? Why or why not?
5. What is your opinion on this overall approach to selective inhibitor discovery when compared to other screening and selection approaches discussed in class?
