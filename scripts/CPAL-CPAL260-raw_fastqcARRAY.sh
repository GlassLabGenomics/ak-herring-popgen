#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --job-name=rfqc
#SBATCH --cpus-per-task=1
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-raw_fastqc_%A-%a.out
#SBATCH --error=/center1/GLASSLAB/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-raw_fastqc_%A-%a.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --time=0-03:00:00
#SBATCH --array=1-280%24

PATH=$PATH:/home/letimm/software/FastQC

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasii260/scripts/CPAL-CPAL260-raw_fastqcARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	fq=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

fastqc ${fq} -o /center1/GLASSLAB/letimm/Clupea_pallasii260/fastqc/raw/