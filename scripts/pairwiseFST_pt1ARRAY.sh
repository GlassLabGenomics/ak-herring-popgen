#!/bin/bash

#SBATCH --time=0-08:00:00
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=5G
#SBATCH --job-name=saf
#SBATCH --output=/scratch/letimm/bering-sea-herring/job_outfiles/pairwise-fst_%A-%a.out
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --mail-type=FAIL
#SBATCH --array=9

module purge
module load GCC/13.3.0 bzip2/1.0.8

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

JOBS_FILE=/scratch/letimm/bering-sea-herring/scripts/pairwiseFST_pt1ARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	pop=$(echo ${sample_line} | awk -F ":" '{print $2}')
	n=$(echo ${sample_line} | awk -F ":" '{print $3}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

BASEDIR=/scratch/letimm/bering-sea-herring
SITES_FILE=${BASEDIR}/sites_files/CPAL-CPAL260_wholegenome_plm_retain.sites
REF_FASTA=/scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta
SAF_DIR=${BASEDIR}/saf
SFS_DIR=${BASEDIR}/sfs

angsd \
	-b ${BASEDIR}/${pop}_bamslist.txt \
	-ref ${REF_FASTA} \
	-anc ${REF_FASTA} \
	-out ${SAF_DIR}/${pop} \
	-sites ${SITES_FILE} \
	-nThreads 10 \
	-uniqueOnly 1 \
	-remove_bads 1 \
	-trim 0 \
	-C 50 \
	-minQ 15 \
	-minMapQ 15 \
	-doCounts 1 \
	-setminDepth ${n} \
	-setmaxDepth $((n * 5)) \
	-GL 1 \
	-doGlf 1 \
	-doMaf 1 \
	-minMaf 0.05 \
	-SNP_pval 1e-10 \
	-doMajorMinor 1 \
	-dumpCounts 3 \
	-doDepth 1 \
	-doSaf 1 \
	-only_proper_pairs 1

realSFS \
	${SAF_DIR}/${pop}.saf.idx > ${SFS_DIR}/${pop}.sfs
