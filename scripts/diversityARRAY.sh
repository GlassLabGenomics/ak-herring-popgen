#!/bin/bash

#SBATCH --time=0-08:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=26G
#SBATCH --job-name=align
#SBATCH --output=/scratch/letimm/bering-sea-herring/job_outfiles/diversity_%A-%a.out
#SBATCH --error=/scratch/letimm/bering-sea-herring/job_outfiles/diversity_%A-%a.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-8%8

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

JOBS_FILE=/scratch/letimm/bering-sea-herring/scripts/diversityARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	pop_id=$(echo ${sample_line} | awk -F ":" '{print $2}')
	bamslist_file=$(echo ${sample_line} | awk -F ":" '{print $3}')
	min_depth=$(echo ${sample_line} | awk -F ":" '{print $4}')
	max_depth=$(echo ${sample_line} | awk -F ":" '{print $5}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

BASEDIR=/scratch/letimm/bering-sea-herring
SITES_FILE=${BASEDIR}/sites_files/CPAL-CPAL260_wgph-unlinked.sites
REF_FASTA=${BASEDIR}/reference_genome/Clupal_KotzSound_assembly.fasta
SAF_DIR=${BASEDIR}/saf
DIVERSITY_DIR=${BASEDIR}/diversity

angsd -b ${bamslist_file} \
        -sites ${SITES_FILE} \
        -ref ${REF_FASTA} \
        -anc ${REF_FASTA} \
        -out ${SAF_DIR}/${pop_id} \
        -nThreads 10 \
        -uniqueOnly 1 \
        -remove_bads 1 \
        -trim 0 \
        -C 50 \
        -minQ 15 \
        -minMapQ 15 \
        -doCounts 1 \
        -setminDepth ${min_depth} \
        -setmaxDepth ${max_depth} \
        -GL 1 \
        -doGlf 3 \
        -doMaf 1 \
        -minMaf 0.05 \
        -doMajorMinor 1 \
        -doSaf 1 \
        -only_proper_pairs 1

### Calculate site frequency spectra to get diversity and selection values (theta, Watterson, Tajima's D) for each population. ###
realSFS ${SAF_DIR}/${pop_id}.saf.idx \
        -fold 1 \
        -P 10 > ${DIVERSITY_DIR}/${pop_id}.saf.sfs

realSFS saf2theta \
        ${SAF_DIR}/${pop_id}.saf.idx \
        -fold 1 \
        -sfs ${DIVERSITY_DIR}/${pop_id}.saf.sfs \
        -outname ${DIVERSITY_DIR}/${pop_id}

thetaStat do_stat \
        ${DIVERSITY_DIR}/${pop_id}.thetas.idx
