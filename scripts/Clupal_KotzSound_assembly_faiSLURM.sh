#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fai
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/fai_Clupal_KotzSound_assembly.out
#SBATCH --error=/scratch/letimm/Clupea_pallasii260/job_outfiles/fai_Clupal_KotzSound_assembly.err

module purge
module load GCC/13.3.0 SAMtools/1.21

samtools faidx /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta
