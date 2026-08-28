#!/bin/bash

#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00
#SBATCH --job-name=sigLR
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_sigLR_%A.out
#SBATCH --error=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_sigLR_%A.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu

module purge
module load GCC/13.3.0 R/4.4.2

PATH=$PATH:/home/letimm/software/angsd

Rscript --vanilla /home/letimm/bin/ngsParalog_sigTest.R /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm.lr 0.05

angsd sites index /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites
