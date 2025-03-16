# Proteomics Assignment

For Problem Set 4, students will search proteomics data to find electrophilic fragment ligands that engage specific cysteines.

## Fetch Data

We will continue using data from Kuljanin, M. et al. [Reimagining high-throughput profiling of reactive cysteines for cell-based screening of large electrophile libraries](https://doi.org/10.1038/s41587-020-00778-3). *Nat. Biotechnol.* 39, 630–641 (2021). but this time will focus on the large-scale experiment conducted in [HCT-116](https://www.cellosaurus.org/CVCL_0291), a colorectal carcinoma cell line.

Use Globus to fetch raw mass spectrometry data from [PRIDE](https://www.ebi.ac.uk/pride/archive/projects/PXD022511) and transfer it to the scratch space on Scholar. We'll want to fetch 38 raw files with the naming scheme `JM####_HCT_Cys_TMT#-#.raw`. These represent two biological replicates of 19 groups of compounds. You may also want the `NBT_TMT_Channel_layout.xlsx` file; it contains information about which compound was assigned to which TMT channel. The file transfer should take ~3 minutes.

## File organization

Because of the way that FragPipe associates TMT annotation files with data, there must be only one TMT annotation file in a folder and it must share that folder with the raw mass spectrometry data. This can be accomplished by creating 19 folders named `TMT01` through `TMT19`. Place the appropriate raw files into each folder. When you eventually create TMT annotation files, it should look something like this:

```
TMT01
├── JM5065_HCT_Cys_TMT1-1.raw
├── JM5066_HCT_Cys_TMT1-2.raw
└── TMT01_annotation.txt
TMT02
├── JM5067_HCT_Cys_TMT2-1.raw
├── JM5068_HCT_Cys_TMT2-2.raw
└── TMT02_annotation.txt
TMT03
├── JM5069_HCT_Cys_TMT3-1.raw
├── JM5070_HCT_Cys_TMT3-2.raw
└── TMT03_annotation.txt
TMT04
├── JM5072_HCT_Cys_TMT4-1.raw
├── JM5073_HCT_Cys_TMT4-2.raw
└── TMT4_annotation.txt
TMT05
├── JM5074_HCT_Cys_TMT5-1.raw
├── JM5075_HCT_Cys_TMT5-2.raw
└── TMT05_annotation.txt
TMT06
├── JM5078_HCT_Cys_TMT6-1.raw
├── JM5079_HCT_Cys_TMT6-2.raw
└── TMT06_annotation.txt
TMT07
├── JM5080_HCT_Cys_TMT7-1.raw
├── JM5081_HCT_Cys_TMT7-2.raw
└── TMT07_annotation.txt
TMT08
├── JM5082_HCT_Cys_TMT8-1.raw
├── JM5083_HCT_Cys_TMT8-2.raw
└── TMT08_annotation.txt
TMT09
├── JM5084_HCT_Cys_TMT9-1.raw
├── JM5085_HCT_Cys_TMT9-2.raw
└── TMT09_annotation.txt
TMT10
├── JM5086_HCT_Cys_TMT10-1.raw
├── JM5087_HCT_Cys_TMT10-2.raw
└── TMT10_annotation.txt
TMT11
├── JM5088_HCT_Cys_TMT11-1.raw
├── JM5089_HCT_Cys_TMT11-2.raw
└── TMT11_annotation.txt
TMT12
├── JM5090_HCT_Cys_TMT12-1.raw
├── JM5091_HCT_Cys_TMT12-2.raw
└── TMT12_annotation.txt
TMT13
├── JM5093_HCT_Cys_TMT13-1.raw
├── JM5094_HCT_Cys_TMT13-2.raw
└── TMT13_annotation.txt
TMT14
├── JM5095_HCT_Cys_TMT14-1.raw
├── JM5096_HCT_Cys_TMT14-2.raw
└── TMT14_annotation.txt
TMT15
├── JM5098_HCT_Cys_TMT15-1.raw
├── JM5099_HCT_Cys_TMT15-2.raw
└── TMT15_annotation.txt
TMT16
├── JM5100_HCT_Cys_TMT16-1.raw
├── JM5101_HCT_Cys_TMT16-2.raw
└── TMT16_annotation.txt
TMT17
├── JM5102_HCT_Cys_TMT17-1.raw
├── JM5103_HCT_Cys_TMT17-2.raw
└── TMT17_annotation.txt
TMT18
├── JM5104_HCT_Cys_TMT18-1.raw
├── JM5105_HCT_Cys_TMT18-2.raw
└── TMT18_annotation.txt
TMT19
├── JM5106_HCT_Cys_TMT19-1.raw
├── JM5107_HCT_Cys_TMT19-2.raw
└── TMT19_annotation.txt
```

## Develop FragPipe Workflow

Open FragPipe GUI on Scholar and load built-in `SLC-ABPP` workflow. This will load in most of the parameters that we want to use. Make any necessary changes (e.g. download/assign database, adjust modifications, change the way TMT reporter ions are quantified). Note that this dataset is using 16-plex TMTpro unlike the tutorial dataset. For this dataset, I recommend defining the DMSO-treated sample as the reference channel, do not normalize intensities, and do not Log2 transform the intensities. Save your custom workflow file and move on to building your manifest file.

## Manifest File

As described in the tutorial, the manifest file lists all of the raw mass spectrometry files and associates them with experiment names.

## Annotation Files

Each experiment defined in the manifest file needs a TMT annotation file. Since there are a lot of files and a lot of TMT channels, you can find the `_annotation.txt` files used in testing in the `02_search_profiling_data` folder. You can alternatively make them from scratch based on the `NBT_TMT_Channel_layout.xlsx` file. In either case, put them in the appropriate folders described in [File organization](#file-organization).

## Run search

Create a shell script for the job and add it to the queue using `sbatch`. You can use the shell script used in the tutorial (`01_scout/scout_search`) as a starting point. Be sure to adjust command line arguments so they point to the appropriate places.

In testing, running FragPipe with 16 threads on Scholar took ~85 minutes.
