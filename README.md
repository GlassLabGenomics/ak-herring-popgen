# ak-herring-popgen
# Genomic population structure of Pacific herring (_Clupea pallasii_) across three major marine regions of western Alaska
Details associated with the assembly, analyses, and visualization/plotting are below.

## Assembly
Non-data files required for running these scripts (files listing bamfiles associated with a group or population, mean individual sequencing depths, etc.) are provided in [miscellaneous](https://github.com/GlassLabGenomics/ak-herring-popgen/tree/main/miscellaneous).

### Index reference genomes
The [Pacific herring reference genome](https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/056/790/095/GCA_056790095.1_Clupal_KotzSound/GCA_056790095.1_Clupal_KotzSound_genomic.fna.gz) was prepared with: 
- [Clupal_KotzSound_assembly_bwa-indexSLURM.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/Clupal_KotzSound_assembly_bwa-indexSLURM.sh)
- [Clupal_KotzSound_assembly_faiSLURM.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/Clupal_KotzSound_assembly_faiSLURM.sh)

### Prepare the raw fastqs
Raw fastqs were quality-checked with FASTQC and multiQC with th following scripts:
- [CPAL-CPAL260-raw_fastqcARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260-raw_fastqcARRAY.sh) to check quality of raw fastqs with FASTQC
    - ran with the array input [CPAL-CPAL260-raw_fqcARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260-raw_fastqcARRAY_input.txt)

- [CPAL-CPAL260-raw_multiqcSLURM.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260-raw_multiqcSLURM.sh) to collate raw FASTQC results 

-  [CPAL-CPAL260_trimARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_trimARRAY.sh) to trim [Nextera adapters](https://github.com/usadellab/Trimmomatic/blob/main/adapters/NexteraPE-PE.fa)
    - ran with the array input [CPAL-CPAL260_trimARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_trimARRAY_input.txt).

- [CPAL-CPAL260-trim_fastqcARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260-trim_fastqcARRAY.sh) to check individual trimmed fastqs quality with FASTQC
    - ran with the array input [CPAL-CPAL260-trim_fqcARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260-trim_fastqcARRAY_input.txt)
- [CPAL-CPAL260-trim_multiqcSLURM.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260-trim_multiqcSLURM.sh) to collate rrimmed fastq results with multiQC

### Align to reference genome
Trimmed fastqs were aligned to the Pacific herring reference genome with the following scripts:
- [CPAL-CPAL260_alignARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_alignARRAY.sh) aligned fastqs to the reference genome, sorted reads, removed duplicates, and  clipped overalps with the single script 
    - ran with the array input script [CPAL-CPAL260_alignARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_alignARRAY_input.txt).

Mean alignment depth was calculated for each individual prior to genotype likelihood calculations using:
- [CPAL-CPAL260_depthsARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_depthsARRAY.sh) 
    - ran with array input [CPAL-CPAL260_depthsARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_depthsARRAY_input.txt)
    - depth calculation requires [mean_cov_ind.py](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/mean_cov_ind.py) 

One individual from Kotzebue (160432) fell below the mean sequencing depth threshold of 1x and was excluded from genotype likelihood calculation.

### Calculate genotype likelihoods across the genome
Genotype likelihoods were calculated across all polymorphic sites with:
- [CPAL-CPAL260_plm_glsARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_plm_glsARRAY.sh)
    - parallelized by chromosome with array input [CPAL-CPAL260_chromosomesARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_paralogsARRAY_input.txt)

As the output of these scripts are genotype likelihoods for each chromosome individually, data were concatenated manually.

### Filter paralogous sites
Paralogous sites were identified by piping samtools mpileup output to [ngsParalog](https://github.com/tplinderoth/ngsParalog). 

- To maintain computational tractability, the full list of SNPs identified through genotype likelihood calculation was split into 250 sites lists that could run in parallel with [CPAL-CPAL260_paralogsARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_paralogsARRAY.sh)
    - all 250 lists were passed with [CPAL-CPAL260_paralogsARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_paralogsARRAY_input.txt)

- The likelihood ratio for each site was tested for significance in R with [ngsParalog_sigTest.R](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/ngsParalog_sigTest.R)
    - retained sites were indexed in ANGSD with [CPAL-CPAL260_sigLR.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_sigLR.sh).

After indexing a list of homologous sites, genotype likelihoods were calculated by-chromosome at these sites. 
- For all samples: [CPAL-CPAL260_filtered_plm_glsARRAY.sh](https://github.com/letimm) 
- For eastern Bering Sea-only samples with [CPAL-CPAL260-EBS_filtered_plm_glsARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_filtered_plm_glsARRAY.sh)

Chromosomal beagles and mafs were concatenated manually and denoted with "wgph" - *w*hole *g*enome *p*olymorphic *h*omologous.

Analyses were conducted on these polymorphic, homologous data with the exception of PCA and Admixture 

### Filter sites in linkage disequilibrium
Calculating linkage disequilibrium (LD) between all pairs of wgph sites was computationally infeasible, so the sites list was subset by a factor of 25.

 - LD analysis was parallelized by chromosome and analyzed with [ngsLD](https://github.com/fgvieira/ngsLD/tree/master) as detailed in [CPAL-CPAL260_wgph_linkageARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_wgph_linkageARRAY.sh)
- Sites in LD were pruned with ngsLD's [prune_ngsLD.py](https://github.com/fgvieira/ngsLD/blob/master/scripts/prune_ngsLD.py)
- LD-pruned sites list was indexed
- Genotype likelihoods were calculated by-chromosome at these sites:
    - For all samples: [CPAL-CPAL260-GOA-UN-EBS-KOTZ_filtered_unlinked_plm_glsARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260-GOA-UN-EBS-KOTZ_filtered_unlinked_plm_glsARRAY.sh)
    - For eastern Bering Sea and Kotzebue samples: [CPAL-CPAL260-EBS-KOTZ_filtered_unlinked_plm_glsARRAY.sh](https://github.com/letimm)
    - For eastern Bering Sea-only samples: [CPAL-CPAL260-EBS_filtered_unlinked_plm_glsARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260-EBS_filtered_unlinked_plm_glsARRAY.sh). 

Chromosomal beagles and mafs were concatenated manually and denoted with "wgphu" - *w*hole *g*enome *p*olymorphic *h*omologous *u*nlinked.
These datasets were used for PCA and Admixture analysis.

## Population genomic analysis
### PCA
PCAs were ran with:
- [pcangsdARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/pcangsdARRAY.sh)
    - ran with the input [pcangsdARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/pcangsdARRAY_input.txt) 

Two outliers from Togiak were noted and  pruned with [pcangsd_2prunedARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/pcangsd_2prunedARRAY.sh)

PCAs were ran with the following data:
- wgphu data from all samples
- wgphu data from samples collected from the eastern Bering Sea and Kotzebue (outlier-pruned version presented in-text)
- wgphu data from samples collected from the eastern Bering Sea only (outlier-pruned version presented in-text)
- wgph data (including linked sites) from samples collected from the eastern Bering Sea (outlier-pruned version presented in-text)

PCAs were visualized in [pca_function.R](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/pca_function.R).
Four clusters were identified in the wgph data from the eastern Bering Sea, which were futher investigated in [Evaluating structural variants](*paste link to the right section here*). 

### Admixture
- Admixture analysis was accomplished by running [NGSadmix](https://github.com/aalbrechtsen/NGSadmix) in [CPAL_wholegenome_all_admixARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL_wholegenome_all_admixARRAY.sh)
- Admixture results were visualized in [admix.R](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/admix.R)
    - Results largely agreed with PCA results: The Gulf of Alaska, Unalaska, and eastern Bering Sea + Kotzebue samples form distinct groups. As K increased, Kotzebue separated from the other eastern Bering Sea samples. For this reason, collection locations within the eastern Bering Sea (Norton Sound, Nelson Island, Goodnews Bay, Togiak, and Port Moller) were considered as a single population.

### Pairwise _F_<sub>ST</sub>
After individuals were organized as described above, _F_<sub>ST</sub> values were calculated for all population pairs (Unalaska, Kotzebue, and eastern Bering Sea) using:
 - first with [pairwiseFST-pt1_ARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/pairwiseFST_pt1ARRAY.sh)
    - populations and population pairs specified in [pairwiseFST-pt1_ARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/pairwiseFST_pt1ARRAY_input.txt)
- second with [pairwiseFST-pt2_ARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/pairwiseFST_pt2ARRAY.sh)
    - populations and population pairs specified in [pairwiseFST-pt2_ARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/pairwiseFST_pt2ARRAY_input.txt)

To examine the statistical significance of the calculated _F_<sub>ST</sub> values, a permutation test was run for every population pair (Unalaska vs eastern Bering Sea, Unalaska vs Kotzebue, and eastern Bering Sea vs Kotzebue). 
    - See [pacific-herring_lcWGS](https://github.com/letimm/pacific-herring_lcWGS#pairwise-fst) for details

- Distributions were generated with [UN-EBS-KOTZ_fst-permutation-test.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/UN-EBS-KOTZ_fst-permutation-test.sh)
- Significance was tested with [generate-fst-posterior_chinook.py](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/generate-fst-posterior_chinook.py)

### Population-level metrics
- Diversity metrics were calculated with[diversityARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/diversityARRAY.sh)
    - ran with input [diversityARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/diversityARRAY_input.txt)

Population-level diversity was calculated from the pestPG files as
the sum of each chromosome's diversity value, divided by the total number of sites that diversity was calculated over.
    
- Heterozygosity was calculated with [hetARRAY.sh](https://github.com/letimm) 
    - ran arrayed across individuals with [hetARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/diversityARRAY_input.txt)


Individual heterozygosity was calculated from the ml files as the number of heterozygous sites divided by the total number of sites

Population-level heterozygosity was calculated as the average individual heterozygosity for the population.

### _F_<sub>ST</sub> genome scans
_F_<sub>ST</sub> was calculated for every SNP to identify genomic sites differentiating between collection locations.

- First site allele frequencies were estimated for each collection location with [sitewiseFST_safARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/sitewiseFST_safARRAY.sh)
- Next, site frequency spectra were calculated for all collection location pairs with [sitewiseFST_sfsARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/sitewiseFST_sfsARRAY.sh)
-  Sitewise _F_<sub>ST</sub> was then estimated with [sitewiseFST_fstARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/sitewiseFST_fstARRAY.sh)
- Sitewise _F_<sub>ST</sub> was also calculated between pairs of clusters identified in the PCA of wgph data from the eastern Bering Sea with   [CPAL-CPAL260-sv_popARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv_popARRAY.sh).
    - These scripts take [CPAL-CPAL260_chromosomesARRAY_input.txt](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/scripts/CPAL-CPAL260_chromosomesARRAY_input.txt) as array input to parallelize across chromosomes

## Evaluating structural variants (SVs)
PCA of wgph data from eastern Bering Sea samples placed individuals into four clusters (A, B, C, and D). Manhattan plots of sitewise _F_<sub>ST</sub> localized signal to structural variants (SVs) on chromosome 7 and chromosome 12. 

Visualization of analyses of these SVs is detailed in [CPAL-CPAL260-sv.Rmd](https://github.com/letimm).

### Genotype likelihoods
SV margins were determined by sitewise _F_<sub>ST</sub> and genotype likelihoods were calculated:
- For all SNPs within chromosome 7 SV with [CPAL-CPAL260-sv_chr7-2.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv_chr7-2.sh) 
- For all SNPs within chromosome 12 SV with [CPAL-CPAL260-sv_chr12-2.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv_chr12-2.sh)

 The first half of each chromosome appeared to have slightly elevated _F_<sub>ST</sub>, so genotype likelihoods were calculated for those regions to exclude the possibility of additional SVs.
- For chromosome 7 SV with [CPAL-CPAL260-sv_chr7-1.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv_chr7-1.sh)
 - For chromosome 12 SV with [CPAL-CPAL260-sv_chr12-1.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv_chr12-1.sh)

### Local PCA
Local PCAs of the SNPs on the first half and each SV were executed
- For chromosome 7 with [CPAL-CPAL260-sv_chr7_pcangsd.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv_chr7_pcangsd.sh)
- For chromosome 12 with and chromosome 12 were executed with [CPAL-CPAL260-sv_chr12_pcangsd.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv_chr12_pcangsd.sh)

### Linkage disequilibrium
Linkage disequilibrium (LD) was calculated between all pairs of SNPs within each SV targeted individuals with the SV karyotype:
- clusters A and D have the chromosome 7 SV karyotype
- clusters C and D have the chromosome 12 SV karyotype
-  individuals lacking the SV
    - clusters B and C lack the chromosome 7 SV karyotype
    - clusters A and B lack the chromosome 12 SV karyotype

 LD analyses for SVs are described 
 - For chromosome 7 in [CPAL-CPAL260-sv_chr7-2_linkage.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv_chr7-2_linkage.sh)
 - For chromosome 12 in [CPAL-CPAL260-sv_chr12-2_linkage.sh](http://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv_chr12-2_linkage.sh)

### Genotype heatmaps
Allelic dosages from beagle files of genotype likelihoods within each SV were calculated and visualized in [CPAL-CPAL260-sv.Rmd](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/CPAL-CPAL260-sv.Rmd).

### SVs in other collection locations
Once signal between clusters was analyzed as described above, SV karyotypes were searched for in collection location excluded from joint SV cluster analysis. 

Sitewise _F_<sub>ST</sub> was calculated for all SNPs within each SV, comparing all four clusters with:
- Kotzebue: [kotzebue-SV_popARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/kotzebue-SV_popARRAY.sh)
- Goodnews Bay: [goodnewsbay-SV_popARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/goodnewsbay-SV_popARRAY.sh)
- Unalaska: [unalaska-SV_popARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/unalaska-SV_popARRAY.sh)
- Gulf of Alaska: [goa-SV_popARRAY.sh](https://github.com/GlassLabGenomics/ak-herring-popgen/blob/main/sv_scripts/goa-SV_popARRAY.sh)
