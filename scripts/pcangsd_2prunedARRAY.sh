#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --ntasks=10
#SBATCH --mem=15G
#SBATCH --job-name=pca2
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/scratch/letimm/bering-sea-herring/job_outfiles/pcangsd-2pruned_%A-%a.out
#SBATCH --array=109-111%3

module purge

source activate pcangsd

JOBS_FILE=/scratch/letimm/bering-sea-herring/scripts/pcangsd_2prunedARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
        job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	data_id=$(echo ${sample_line} | awk -F ":" '{print $2}')
	beagle=$(echo ${sample_line} | awk -F ":" '{print $3}')
	filter_file=$(echo ${sample_line} | awk -F ":" '{print $4}')
        if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
                break
        fi
done

BASEDIR=/scratch/letimm/bering-sea-herring
PCA_DIR=${BASEDIR}/pcaLET

pcangsd \
	--threads 10 \
	--beagle ${beagle} \
	-o ${PCA_DIR}/${data_id}_2pruned \
	--pcadapt \
	--filter ${filter_file}
