#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --cpus-per-task=1
#SBATCH --job-name=tmqc
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-trim_multiQC.out
#SBATCH --error=/center1/GLASSLAB/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-trim_multiQC.err

source /home/letimm/bin/hydraQC/bin/activate
multiqc /center1/GLASSLAB/letimm/Clupea_pallasii260/fastqc/trimmed/