# Statistical data analysis of microarray data

## Summary
Pyrococcus Furiosus is an extremophile of Archea domain. It can adapt to extreme environmental conditions hence it is of interest to study what are the mechanisms that lead to their strength.
In the experiment where cellular cultures were exposed to 2500 Gy of gamma irradiation made by Jocelyne DiRuggiero et al. in *Microarray analysis of the hyperthermophilic archaeon Pyrococcus Furiosus exposed to gamma irradiation*, two interesting features come out: 
one is that following irradiation a large fraction of the changes are decreases in mRNA levels suggesting a down-regulation of metabolic functions following stress induction;
an other is that very few DNA repair genes displayed significant differential expression in P. furiosus following gamma irradiation suggesting that DNA repair proteins in P. Furiosus 
and several other archaea are constitutively expressed and that they may be present in the cell at a level sufficient to maintain the integrity of the cell's genetic material.<br>
In the statistical data analysis that I made, I considered the time trend behavior of gene expression (of just 5 genes) assessing that it can be well modeled by a linear regression model with negative slope.<br>
Furthermore, I considered 5 DNA repair genes and I attested that there is no significant changes in gene expression following the irradiation.

## Contents
The repository contains:
* [statistics.R](https://github.com/ManuelaCarriero/microarray-analysis/blob/main/statistics.R) R code used for the analysis;
* [stat_presentation.pptx](https://github.com/ManuelaCarriero/microarray-analysis/blob/main/stat_presentation.pptx) presentation of statistical data analysis;
* [GSE5919_series_matrix.txt](https://github.com/ManuelaCarriero/microarray-analysis/blob/main/GSE5919_series_matrix.txt) data file.<br>
Then I made the following data files for the investingation:
* [DNARepairGenes.txt](https://github.com/ManuelaCarriero/microarray-analysis/blob/main/DNARepairGenes.txt) 
* [FiveGenesRefIrr.txt](https://github.com/ManuelaCarriero/microarray-analysis/blob/main/FiveGenesRefIrr.txt)
* [ID1-4-5-6-7.txt](https://github.com/ManuelaCarriero/microarray-analysis/blob/main/ID1-4-5-6-7.txt)
* [ID1001-2-3-4.txt](https://github.com/ManuelaCarriero/microarray-analysis/blob/main/ID1001-2-3-4.txt)
* [RadVsNotRadiation.txt](https://github.com/ManuelaCarriero/microarray-analysis/blob/main/RadVsNotRadiation.txt)

## Data
Data are available here: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE5919.