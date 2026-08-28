#!/bin/bash

#SBATCH --time=0-02:00:00
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=8G
#SBATCH --job-name=wgph
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_filtered_plm_gls_%A-%a.out
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --mail-type=FAIL
#SBATCH --array=1-26%26

module purge
module load GCC/13.3.0 bzip2/1.0.8

PATH=$PATH:/home/letimm/software/angsd

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

angsd \
	-b /scratch/letimm/Clupea_pallasii260/CPAL-CPAL260_filtered_bamslist.txt \
	-ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
	-r ${chrom} \
	-sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
	-out /scratch/letimm/Clupea_pallasii260/wgph_gls/CPAL-CPAL260_${chrom}_filtered_plm_gls \
	-nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 \
	-minMapQ 15 -minQ 15 \
	-doCounts 1 \
	-setminDepth 259 \
	-setmaxDepth 1295 \
	-doGlf 2 \
	-GL 1 -doMaf 1 -minMaf 0.05 -SNP_pval 1e-10 -doMajorMinor 1 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1
