#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --mem=10G
#SBATCH --job-name=kotz
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-sv_kotzebue_fst_%A-%a.out
#SBATCH --array=1-2%2

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

JOBS_FILE=/scratch/letimm/Clupea_pallasii260/scripts/sv_scripts/SV_chromsARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	chrom=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

PREFIX=CPAL-CPAL260-sv
BASEDIR=/scratch/letimm/Clupea_pallasii260/structural_variants
REF_GENOME=/scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta
SITES_FILE=/scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites
SAF_DIR=${BASEDIR}/saf
SFS_DIR=${BASEDIR}/sfs
FST_DIR=${BASEDIR}/fst

#clust A SAF: already done
#clust B SAF: already done
#clust C SAF: already done
#clust D SAF: already done

#kotzebue SAF
angsd \
        -b ${BASEDIR}/Kotzebue_bamslist.txt \
        -ref ${REF_GENOME} \
        -anc ${REF_GENOME} \
        -r ${chrom} \
        -sites ${SITES_FILE} \
        -out ${SAF_DIR}/${PREFIX}_${chrom}_kotzebue_plm_folded \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 \
        -setminDepth 19 \
        -setmaxDepth 95 \
        -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

#PAIRWISE COMPARISONS
#clust A v kotzebue fst
realSFS \
	${SAF_DIR}/${PREFIX}_${chrom}_A_plm_folded.saf.idx -fold 1 \
	${SAF_DIR}/${PREFIX}_${chrom}_kotzebue_plm_folded.saf.idx -fold 1 > \
	${SFS_DIR}/${PREFIX}_${chrom}_A-kotzebue_plm_folded.sfs
realSFS fst index \
	${SAF_DIR}/${PREFIX}_${chrom}_A_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_kotzebue_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_A-kotzebue_plm_folded.sfs \
	-fstout ${FST_DIR}/${PREFIX}_${chrom}_A-kotzebue_plm_folded.sfs.pbs \
	-whichFst 1
realSFS fst stats2 \
	${FST_DIR}/${PREFIX}_${chrom}_A-kotzebue_plm_folded.sfs.pbs.fst.idx \
	-win 1 -step 1 > \
	${FST_DIR}/${PREFIX}_${chrom}_A-kotzebue_plm_folded.sfs.pbs.fst.txt

#clust B v kotzebue fst
realSFS \
        ${SAF_DIR}/${PREFIX}_${chrom}_B_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_kotzebue_plm_folded.saf.idx -fold 1 > \
        ${SFS_DIR}/${PREFIX}_${chrom}_B-kotzebue_plm_folded.sfs
realSFS fst index \
        ${SAF_DIR}/${PREFIX}_${chrom}_B_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_kotzebue_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_B-kotzebue_plm_folded.sfs \
        -fstout ${FST_DIR}/${PREFIX}_${chrom}_B-kotzebue_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/${PREFIX}_${chrom}_B-kotzebue_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/${PREFIX}_${chrom}_B-kotzebue_plm_folded.sfs.pbs.fst.txt

#clust C v kotzebue fst
realSFS \
        ${SAF_DIR}/${PREFIX}_${chrom}_C_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_kotzebue_plm_folded.saf.idx -fold 1 > \
        ${SFS_DIR}/${PREFIX}_${chrom}_C-kotzebue_plm_folded.sfs
realSFS fst index \
        ${SAF_DIR}/${PREFIX}_${chrom}_C_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_kotzebue_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_C-kotzebue_plm_folded.sfs \
        -fstout ${FST_DIR}/${PREFIX}_${chrom}_C-kotzebue_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/${PREFIX}_${chrom}_C-kotzebue_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/${PREFIX}_${chrom}_C-kotzebue_plm_folded.sfs.pbs.fst.txt

#clust D v kotzebue fst
realSFS \
        ${SAF_DIR}/${PREFIX}_${chrom}_D_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_kotzebue_plm_folded.saf.idx -fold 1 > \
        ${SFS_DIR}/${PREFIX}_${chrom}_D-kotzebue_plm_folded.sfs
realSFS fst index \
        ${SAF_DIR}/${PREFIX}_${chrom}_D_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_kotzebue_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_D-kotzebue_plm_folded.sfs \
        -fstout ${FST_DIR}/${PREFIX}_${chrom}_D-kotzebue_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/${PREFIX}_${chrom}_D-kotzebue_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/${PREFIX}_${chrom}_D-kotzebue_plm_folded.sfs.pbs.fst.txt
