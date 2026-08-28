#!/bin/bash

#SBATCH --time=0-08:00:00
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=5G
#SBATCH --job-name=pt2
#SBATCH --output=/scratch/letimm/bering-sea-herring/job_outfiles/pairwise-fst_%A-%a.out
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --mail-type=FAIL
#SBATCH --array=24

module purge
module load GCC/13.3.0 bzip2/1.0.8

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

JOBS_FILE=/scratch/letimm/bering-sea-herring/scripts/pairwiseFST_pt2ARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	pop1=$(echo ${sample_line} | awk -F ":" '{print $2}')
	pop2=$(echo ${sample_line} | awk -F ":" '{print $3}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

BASEDIR=/scratch/letimm/bering-sea-herring
SITES_FILE=${BASEDIR}/sites_files/CPAL-CPAL260_wholegenome_plm_retain.sites
REF_FASTA=/scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta
SAF_DIR=${BASEDIR}/saf
SFS_DIR=${BASEDIR}/sfs
FST_DIR=${BASEDIR}/pairwise_fst

realSFS \
	${SAF_DIR}/${pop1}.saf.idx \
	${SAF_DIR}/${pop2}.saf.idx \
	-P 10 \
	-maxIter 30 > \
	${SFS_DIR}/${pop1}-${pop2}.ml

realSFS \
	fst index \
	${SAF_DIR}/${pop1}.saf.idx \
	${SAF_DIR}/${pop2}.saf.idx \
	-sfs ${SFS_DIR}/${pop1}-${pop2}.ml \
	-fstout ${FST_DIR}/${pop1}-${pop2}

realSFS \
	fst stats \
	${FST_DIR}/${pop1}-${pop2}.fst.idx > \
	${FST_DIR}/${pop1}-${pop2}.pairwise.fst.txt
