#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --mem=10G
#SBATCH --job-name=ld
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-sv_chr12-2_linkage_%A.out

module purge
module load bzip2/1.0.8 GCCcore/13.3.0 zlib/1.2.12

PATH=$PATH:/home/letimm/software/ngsLD

#SV genotype 1
base_filename="/scratch/letimm/Clupea_pallasii260/structural_variants/gls/CPAL-CPAL260-sv_AB_chr12-2"
ld_base_filename=${base_filename/gls/linkage}

#aiming for 250 sites retained across the region: 33,759 snps / 250 snps ~ 135
snp_ct=250
zcat ${base_filename}.beagle.gz | awk 'NR % 135 == 0' | gzip > ${base_filename}.tmp.beagle.gz
zcat ${base_filename}.tmp.beagle.gz | awk '{print $1}' | sed 's/_/\t/3' > ${ld_base_filename}_${snp_ct}snps.pos
zcat ${base_filename}.tmp.beagle.gz | cut -f 4- | gzip > ${ld_base_filename}_${snp_ct}snps.beagle.gz

if [ -f ${ld_base_filename}_${snp_ct}snps.beagle.gz ]; then
	rm ${base_filename}.tmp.beagle.gz
else
	echo "Subset beagle not found!"
	exit 1
fi

num_lines=$(< "${ld_base_filename}_${snp_ct}snps.beagle.gz" zcat | wc -l)

ngsLD \
	--geno ${ld_base_filename}_${snp_ct}snps.beagle.gz \
	--pos ${ld_base_filename}_${snp_ct}snps.pos \
	--probs \
	--n_ind 51 \
	--n_sites ${num_lines} \
	--max_kb_dist 0 \
	--n_threads 10 \
	--out ${ld_base_filename}_${snp_ct}snps.ld

#SV genotype 2
base_filename="/scratch/letimm/Clupea_pallasii260/structural_variants/gls/CPAL-CPAL260-sv_CD_chr12-2"
ld_base_filename=${base_filename/gls/linkage}

#aiming for 250 sites retained across the region: 50,943 snps / 250 snps ~ 204
snp_ct=250
zcat ${base_filename}.beagle.gz | awk 'NR % 204 == 0' | gzip > ${base_filename}.tmp.beagle.gz
zcat ${base_filename}.tmp.beagle.gz | awk '{print $1}' | sed 's/_/\t/3' > ${ld_base_filename}_${snp_ct}snps.pos
zcat ${base_filename}.tmp.beagle.gz | cut -f 4- | gzip > ${ld_base_filename}_${snp_ct}snps.beagle.gz

if [ -f ${ld_base_filename}_${snp_ct}snps.beagle.gz ]; then
        rm ${base_filename}.tmp.beagle.gz
else
        echo "Subset beagle not found!"
        exit 1
fi

num_lines=$(< "${ld_base_filename}_${snp_ct}snps.beagle.gz" zcat | wc -l)

ngsLD \
        --geno ${ld_base_filename}_${snp_ct}snps.beagle.gz \
        --pos ${ld_base_filename}_${snp_ct}snps.pos \
        --probs \
        --n_ind 27 \
        --n_sites ${num_lines} \
        --max_kb_dist 0 \
        --n_threads 10 \
        --out ${ld_base_filename}_${snp_ct}snps.ld
