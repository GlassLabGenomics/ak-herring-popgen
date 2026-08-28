#!/bin/bash

#SBATCH --time=0-03:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=12G
#SBATCH --job-name=align
#SBATCH --output=/scratch/letimm/bering-sea-herring/job_outfiles/heterozygosity_%A-%a.out
#SBATCH --error=/scratch/letimm/bering-sea-herring/job_outfiles/heterozygosity_%A-%a.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=26,108,109%3

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

JOBS_FILE=/scratch/letimm/bering-sea-herring/scripts/hetARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
        job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
        alignment=$(echo ${sample_line} | awk -F ":" '{print $2}')
        if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
                break
        fi
done

IFS='_'
read -ra file_name_array <<< "$alignment"
sample_id=${file_name_array[2]}
unset IFS

BASEDIR=/scratch/letimm/bering-sea-herring
SITES_FILE=${BASEDIR}/sites_files/CPAL-CPAL260_wgph-unlinked.sites
REF_FASTA=${BASEDIR}/reference_genome/Clupal_KotzSound_assembly.fasta
HET_DIR=${BASEDIR}/heterozygosity

#individual saf
angsd \
        -i ${alignment} \
        -sites ${SITES_FILE} \
        -anc ${REF_FASTA} \
        -ref ${REF_FASTA} \
        -out ${HET_DIR}/${sample_id} \
        -C 50 \
        -dosaf 1 \
        -gl 1

#individual het
realSFS \
        ${HET_DIR}/${sample_id}.saf.idx -fold 1 > ${HET_DIR}/${sample_id}.ml
