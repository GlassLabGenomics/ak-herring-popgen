#!/bin/bash

#SBATCH --time=0-03:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=26G
#SBATCH --job-name=align
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_alignment_%A-%a.out
#SBATCH --error=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_alignment_%A-%a.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=5-260%24

module purge
module load GCC/13.3.0 BWA/0.7.18 SAMtools/1.21 picard/3.3.0-Java-17

source activate bamutil

JOBS_FILE=/scratch/letimm/Clupea_pallasii260/scripts/CPAL-CPAL260_alignARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	fq_r1=$(echo ${sample_line} | awk -F ":" '{print $2}')
	fq_r2=$(echo ${sample_line} | awk -F ":" '{print $3}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

sample_id=$(echo $fq_r1 | sed 's!^.*/!!')
sample_id=${sample_id%%_*}

BASEDIR=/scratch/letimm/Clupea_pallasii260
BWADIR=${BASEDIR}/bwa
BAMDIR=${BASEDIR}/bamtools

#align short reads to reference genome
bwa mem -M \
	-t 10 \
	${BWADIR}/Clupal_KotzSound_assembly \
	${fq_r1} ${fq_r2} 2> ${BWADIR}/CPAL-CPAL260_${sample_id}_bwa-mem.out > ${BAMDIR}/CPAL-CPAL260_${sample_id}.sam

#convert SAM to BAM
samtools view -bS \
	-F 4 \
	${BAMDIR}/CPAL-CPAL260_${sample_id}.sam > ${BAMDIR}/CPAL-CPAL260_${sample_id}.bam

#if conversion was successful, delete SAM (if unsuccessful, exit script)
if [ -f ${BAMDIR}/CPAL-CPAL260_${sample_id}.bam ]; then
	echo "Conversion from SAM to BAM: SUCCESS"
	rm ${BAMDIR}/CPAL-CPAL260_${sample_id}.sam
else
	echo "Conversion from SAM to BAM: FAILURE"
	exit 1
fi

#add readgroup
samtools addreplacerg -r "@RG\tID:${sample_id}\tSM:${sample_id}\tPL:Illumina\tLB:Clupal_KotzSound" \
        -o ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg.bam \
        ${BAMDIR}/CPAL-CPAL260_${sample_id}.bam

#if readgroup addition was successful, delete previous BAM (if unsuccessful, exit script)
if [ -f ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg.bam ]; then
	echo "readgroup addition: SUCCESS"
        rm ${BAMDIR}/CPAL-CPAL260_${sample_id}.bam
else
	echo "readgroup addition: FAILURE"
        exit 1
fi

#sort reads
samtools view -h \
	${BAMDIR}/CPAL-CPAL260_${sample_id}_rg.bam \
	| samtools view -buS - \
	| samtools sort -o ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted.bam

#if sort was successful, delete previous BAM (if unsuccessful, exit script)
if [ -f ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted.bam ]; then
	echo "read sorting: SUCCESS"
        rm ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg.bam
else
	echo "read sorting: FAILURE"
        exit 1
fi

#mark and remove duplicates
java -jar $EBROOTPICARD/picard.jar MarkDuplicates \
	I=${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted.bam \
	O=${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted_dedup.bam \
	M=${BAMDIR}/CPAL-CPAL260_${sample_id}_dups.log \
	VALIDATION_STRINGENCY=SILENT \
	REMOVE_DUPLICATES=true

#if deduplication was successful, delete previous BAM (if unsuccessful, exit script)
if [ -f ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted_dedup.bam ]; then
        echo "deduplication: SUCCESS"
	rm ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted.bam
else
	echo "deduplication: FAILURE"
        exit 1
fi

#clip overlapping reads
bam clipOverlap \
	--in ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted_dedup.bam \
	--out ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted_dedup_clipped.bam \
	--stats

#if clipping was successful, delete previous BAM (if unsuccessful, exit script)
if [ -f ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted_dedup_clipped.bam ]; then
	echo "overlap clipping: SUCCESS"
        rm ${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted_dedup.bam
else
	echo "overlap clipping: FAILURE"
    	exit 1
fi

#get depths from final BAM
samtools depth -aa \
	${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted_dedup_clipped.bam \
	| cut -f 3 \
	| gzip > ${BAMDIR}/CPAL-CPAL260_${sample_id}.depth.gz

touch ${BAMDIR}/CPAL-CPAL260_depths.csv
mean_cov_ind_vGOMBESSA.py -i ${BAMDIR}/CPAL-CPAL260_${sample_id}.depth.gz -o ${BAMDIR}/CPAL-CPAL260_depths.csv

#index final BAM
samtools index \
	${BAMDIR}/CPAL-CPAL260_${sample_id}_rg_sorted_dedup_clipped.bam
