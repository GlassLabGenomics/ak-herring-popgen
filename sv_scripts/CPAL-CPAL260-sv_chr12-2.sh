#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --job-name=chr12-2
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-sv_chr12-2_%A.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu

PATH=$PATH:/home/letimm/software/angsd

angsd \
	-b /scratch/letimm/Clupea_pallasii260/CPAL-CPAL260-sv_filtered_bamslist.txt \
	-ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
	-sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
	-r Clupal_KotzSound_chrom12:18704886-26654660 \
	-out /scratch/letimm/Clupea_pallasii260/structural_variants/gls/CPAL-CPAL260-sv_chr12-2 \
	-nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 \
	-minMapQ 15 -minQ 15 \
	-doCounts 1 \
	-setminDepth 78 \
	-setmaxDepth 390 \
	-doGlf 2 \
	-GL 1 -doMaf 1 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-10 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1

#only sv genotype1 (A and B)
angsd \
        -b /scratch/letimm/Clupea_pallasii260/structural_variants/AB_bamslist.txt\
	-ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
        -r Clupal_KotzSound_chrom12:18704886-26654660 \
        -out /scratch/letimm/Clupea_pallasii260/structural_variants/gls/CPAL-CPAL260-sv_AB_chr12-2 \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 \
        -minMapQ 15 -minQ 15 \
        -doCounts 1 \
        -setminDepth 51 \
        -setmaxDepth 255 \
        -doGlf 2 \
        -GL 1 -doMaf 1 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-10 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1

#only sv genotype2 (C and D)
angsd \
        -b /scratch/letimm/Clupea_pallasii260/structural_variants/CD_bamslist.txt\
        -ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
        -r Clupal_KotzSound_chrom12:18704886-26654660 \
        -out /scratch/letimm/Clupea_pallasii260/structural_variants/gls/CPAL-CPAL260-sv_CD_chr12-2 \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 \
        -minMapQ 15 -minQ 15 \
        -doCounts 1 \
        -setminDepth 27 \
        -setmaxDepth 135 \
        -doGlf 2 \
        -GL 1 -doMaf 1 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-10 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1
