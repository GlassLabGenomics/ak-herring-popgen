#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --job-name=chr7-2
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-sv_chr7-2_%A.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu

PATH=$PATH:/home/letimm/software/angsd

angsd \
	-b /scratch/letimm/Clupea_pallasii260/CPAL-CPAL260-sv_filtered_bamslist.txt \
	-ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
	-sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
	-r Clupal_KotzSound_chrom07:20986379-27222580 \
	-out /scratch/letimm/Clupea_pallasii260/structural_variants/gls/CPAL-CPAL260-sv_chr7-2 \
	-nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 \
	-minMapQ 15 -minQ 15 \
	-doCounts 1 \
	-setminDepth 78 \
	-setmaxDepth 390 \
	-doGlf 2 \
	-GL 1 -doMaf 1 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-10 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1

#only sv genotype1 (B and C)
angsd \
        -b /scratch/letimm/Clupea_pallasii260/structural_variants/BC_bamslist.txt\
	-ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
        -r Clupal_KotzSound_chrom07:20986379-27222580 \
        -out /scratch/letimm/Clupea_pallasii260/structural_variants/gls/CPAL-CPAL260-sv_BC_chr7-2 \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 \
        -minMapQ 15 -minQ 15 \
        -doCounts 1 \
        -setminDepth 25 \
        -setmaxDepth 125 \
        -doGlf 2 \
        -GL 1 -doMaf 1 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-10 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1

#only sv genotype2 (A and D)
angsd \
        -b /scratch/letimm/Clupea_pallasii260/structural_variants/AD_bamslist.txt\
        -ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
        -r Clupal_KotzSound_chrom07:20986379-27222580 \
        -out /scratch/letimm/Clupea_pallasii260/structural_variants/gls/CPAL-CPAL260-sv_AD_chr7-2 \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 \
        -minMapQ 15 -minQ 15 \
        -doCounts 1 \
        -setminDepth 53 \
        -setmaxDepth 265 \
        -doGlf 2 \
        -GL 1 -doMaf 1 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-10 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1
