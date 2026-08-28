#!/bin/bash

#SBATCH --time=0-08:00:00
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=5G
#SBATCH --job-name=saf
#SBATCH --output=/scratch/letimm/bering-sea-herring/job_outfiles/sitewise-fst_%A-%a.out
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --mail-type=FAIL
#SBATCH --array=1-26%26

module purge
module load GCC/13.3.0 bzip2/1.0.8

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

JOBS_FILE=/scratch/letimm/Clupea_pallasii260/scripts/CPAL-CPAL260_chromosomesARRAY_input.txt
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
SITES_FILE=${BASEDIR}/sites_files/CPAL-CPAL260_wholegenome_plm_retain.sites
REF_FASTA=/scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta
SAF_DIR=${BASEDIR}/saf

#pops with N=20 SAFs
for pop in GoodnewsBay NelsonIsland NortonSound PortMoller Togiak Unalaska
do
angsd \
	-b ${BASEDIR}/${pop}_bamslist.txt \
	-ref ${REF_FASTA} \
	-anc ${REF_FASTA} \
	-r ${chrom} \
	-sites ${SITES_FILE} \
	-out ${SAF_DIR}/${pop}_${chrom}_plm_folded \
	-nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 \
	-setminDepth 20 \
	-setmaxDepth 100 \
	-GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1
done

#EBS SAF
angsd \
        -b ${BASEDIR}/EBSspawning_bamslist.txt \
        -ref ${REF_FASTA} \
        -anc ${REF_FASTA} \
        -r ${chrom} \
        -sites ${SITES_FILE} \
        -out ${SAF_DIR}/EBS_${chrom}_plm_folded \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 \
        -setminDepth 100 \
        -setmaxDepth 500 \
        -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

#Kotzebue SAF
angsd \
        -b ${BASEDIR}/Kotzebue_bamslist.txt \
        -ref ${REF_FASTA} \
        -anc ${REF_FASTA} \
        -r ${chrom} \
        -sites ${SITES_FILE} \
        -out ${SAF_DIR}/Kotzebue_${chrom}_plm_folded \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 \
        -setminDepth 19 \
        -setmaxDepth 95 \
        -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1
