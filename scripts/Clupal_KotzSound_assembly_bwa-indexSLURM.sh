#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --job-name=bwai
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/bwa-index_Clupal_KotzSound_assembly.out
#SBATCH --error=/center1/GLASSLAB/letimm/Clupea_pallasii260/job_outfiles/bwa-index_Clupal_KotzSound_assembly.err

module purge
module load GCC/13.3.0 BWA/0.7.18

bwa index -p /scratch/letimm/Clupea_pallasii260/bwa/Clupal_KotzSound_assembly /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta
