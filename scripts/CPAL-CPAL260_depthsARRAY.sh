#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --job-name=depth
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_depths_%A-%a.out
#SBATCH --error=/center1/GLASSLAB/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_depths_%A-%a.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-260%24

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasii260/scripts/CPAL-CPAL260_depthsARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	depth_file=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

touch /center1/GLASSLAB/letimm/Clupea_pallasii260/bamtools/CPAL-CPAL260_depths.csv
mean_cov_ind.py -i ${depth_file} -o /center1/GLASSLAB/letimm/Clupea_pallasii260/bamtools/CPAL-CPAL260_depths.csv
