#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --job-name=trim
#SBATCH --cpus-per-task=1
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_trimming_%A-%a.out
#SBATCH --error=/center1/GLASSLAB/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_trimming_%A-%a.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --time=0-12:00:00
#SBATCH --array=1-140%8

TRIMMOMATIC=/home/letimm/software/Trimmomatic-0.39/trimmomatic-0.39.jar

PATH=$PATH:/home/letimm/software

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasii260/scripts/CPAL-CPAL260_trimARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	fq_r1=$(echo ${sample_line} | awk -F ":" '{print $2}')
	fq_r2=$(echo ${sample_line} | awk -F ":" '{print $3}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

sample_id=$(echo $fq_r1 | sed 's!^.*/!!')
sample_id=${sample_id%%_*}

java -jar ${TRIMMOMATIC} PE -threads 4 -phred33 ${fq_r1} ${fq_r2} /center1/GLASSLAB/letimm/Clupea_pallasii260/trimmed/${sample_id}_trimmed_R1_paired.fq.gz /center1/GLASSLAB/letimm/Clupea_pallasii260/trimmed/${sample_id}_trimmed_R1_unpaired.fq.gz /center1/GLASSLAB/letimm/Clupea_pallasii260/trimmed/${sample_id}_trimmed_R2_paired.fq.gz /center1/GLASSLAB/letimm/Clupea_pallasii260/trimmed/${sample_id}_trimmed_R2_unpaired.fq.gz ILLUMINACLIP:/home/letimm/bin/TruSeq3-PE.fasta:2:30:10:1:true MINLEN:40
fastp --trim_poly_g -L -A --cut_right -i /center1/GLASSLAB/letimm/Clupea_pallasii260/trimmed/${sample_id}_trimmed_R1_paired.fq.gz -o /center1/GLASSLAB/letimm/Clupea_pallasii260/trimmed/${sample_id}_trimmed_clipped_R1_paired.fq.gz -I /center1/GLASSLAB/letimm/Clupea_pallasii260/trimmed/${sample_id}_trimmed_R2_paired.fq.gz -O /center1/GLASSLAB/letimm/Clupea_pallasii260/trimmed/${sample_id}_trimmed_clipped_R2_paired.fq.gz -h /center1/GLASSLAB/letimm/Clupea_pallasii260/trimmed/${sample_id}_trimmed_clipped_paired_report.html