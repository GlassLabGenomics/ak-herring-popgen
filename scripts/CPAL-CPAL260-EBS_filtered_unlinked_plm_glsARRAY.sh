#!/bin/bash

#SBATCH --time=0-04:00:00
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=3
#SBATCH --mem=8G
#SBATCH --job-name=wgphu
#SBATCH --output=/scratch/letimm/bering-sea-herring/job_outfiles/CPAL-CPAL260-EBS_filtered_unlinked_plm_gls_%A-%a.out
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --mail-type=FAIL
#SBATCH --array=1-26%26

module purge
module load GCC/13.3.0 bzip2/1.0.8

PATH=$PATH:/home/letimm/software/angsd

JOBS_FILE=/scratch/letimm/bering-sea-herring/scripts/CPAL-CPAL260_chromosomesARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	chrom=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

BASEDIR=/scratch/letimm/bering-sea-herring
PREFIX=CPAL-CPAL260-EBS
REF_FASTA=/scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta
BAMSLIST_FILE=${BASEDIR}/EBSspawning_bamslist.txt
SITES_FILE=${BASEDIR}/sites_files/CPAL-CPAL260_wgph-unlinked.sites
MIN_DEPTH=100
MAX_DEPTH=500
BEAGLE_DIR=${BASEDIR}/beagles

angsd \
	-b ${BAMSLIST_FILE} \
	-ref ${REF_FASTA} \
	-r ${chrom} \
	-sites ${SITES_FILE} \
	-out ${BEAGLE_DIR}/${PREFIX}_${chrom}_filtered_unlinked_plm_gls \
	-nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 \
	-minMapQ 15 -minQ 15 \
	-doCounts 1 \
	-setminDepth ${MIN_DEPTH} \
	-setmaxDepth ${MAX_DEPTH} \
	-doGlf 2 \
	-GL 1 -doMaf 1 -minMaf 0.05 -SNP_pval 1e-10 -doMajorMinor 1 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1
