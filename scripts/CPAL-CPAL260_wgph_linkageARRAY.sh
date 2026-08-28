#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --mem=10G
#SBATCH --job-name=ld
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_linkage_%A-%a.out
#SBATCH --array=2-26%25

module purge
module load bzip2/1.0.8 GCCcore/13.3.0 zlib/1.2.12

PATH=$PATH:/home/letimm/software/ngsLD

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

base_filename=/scratch/letimm/Clupea_pallasii260/wgph_gls/CPAL-CPAL260_${chrom}_filtered_plm_gls
ld_base_filename=${base_filename/wgph_gls/linkage}

### Subset beagle
subset_factor=25

#zcat ${base_filename}.beagle.gz | awk "NR % ${subset_factor} == 0" | gzip > ${base_filename}.tmp.beagle.gz
#zcat ${base_filename}.tmp.beagle.gz | awk '{print $1}' | sed "s/${chrom}_/${chrom}\t/g" > ${ld_base_filename}_factor${subset_factor}.pos
#zcat ${base_filename}.tmp.beagle.gz | cut -f 4- | gzip > ${ld_base_filename}_factor${subset_factor}.beagle.gz

#if [ -f ${ld_base_filename}_factor${subset_factor}.beagle.gz ]; then
#       rm ${base_filename}.tmp.beagle.gz
#else
#       echo "Subset beagle not found!"
#       exit 1
#fi

#num_lines=$(< "${ld_base_filename}_factor${subset_factor}.beagle.gz" zcat | wc -l)

### or don't (subset the beagle)
##zcat ${base_filename}.beagle.gz | sed '1d' | awk '{print $1}' | sed "s/${chrom}_/${chrom}\t/g" > ${ld_base_filename}.pos
##zcat ${base_filename}.beagle.gz | sed '1d' | cut -f 4- | gzip > ${ld_base_filename}.beagle.gz

##num_lines=$(< "${ld_base_filename}.beagle.gz" zcat | wc -l)

### LD calc
#ngsLD \
#	--geno ${ld_base_filename}_factor${subset_factor}.beagle.gz \
#	--pos ${ld_base_filename}_factor${subset_factor}.pos \
#	--probs \
#	--n_ind 259 \
#	--n_sites ${num_lines} \
#	--max_kb_dist 0 \
#	--n_threads 10 \
#	--out ${ld_base_filename}_factor${subset_factor}.ld

### housekeeping
## remove the header
#sed -i '1d' ${ld_base_filename}_factor${subset_factor}.ld
## gzip the file (these are big)
#gzip ${ld_base_filename}_factor${subset_factor}.ld

### LD pruning
source activate prune-ngsLD

#max_dist reflects a conservative estimate of the chr12 inversion, which has elevated LD
/home/letimm/software/ngsLD/scripts/prune_ngsLD.py \
	--input ${ld_base_filename}_factor${subset_factor}.ld.gz \
	--max_dist 8000000 \
	--min_weight 0.5 \
	--output ${ld_base_filename}_factor${subset_factor}_unlinked.sites
