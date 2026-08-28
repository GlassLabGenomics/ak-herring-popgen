#!/bin/bash

#SBATCH --cpus-per-task=5
#SBATCH --mem=12G
#SBATCH --time=0-08:00:00
#SBATCH --job-name=plog
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_paralogs_%A-%a.out
#SBATCH --error=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_paralogs_%A-%a.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=6-250%48

PATH=$PATH:/home/letimm/software/samtools-1.22.1/
PATH=$PATH:/home/letimm/software/ngsParalog

JOBS_FILE=/scratch/letimm/Clupea_pallasii260/scripts/CPAL-CPAL260_paralogsARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	subsites_file=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

samtools mpileup \
	-b /scratch/letimm/Clupea_pallasii260/CPAL-CPAL260_filtered_bamslist.txt \
	-l ${subsites_file} \
	-q 0 \
	-Q 0 \
	--ff UNMAP,DUP | \
	ngsParalog calcLR \
	-infile - \
	-outfile ${subsites_file}.lr \
	-minQ 5 \
	-minind 1 \
	-mincov 1 \
       -allow_overwrite 1
