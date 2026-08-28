#!/bin/bash

#SBATCH --cpus-per-task=5
#SBATCH --mem=5G
#SBATCH --job-name=fst
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-sv_fst_%A-%a.out
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --mail-type=FAIL
#SBATCH --array=1-26%26

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

PREFIX=CPAL-CPAL260-sv
BASEDIR=/scratch/letimm/Clupea_pallasii260/structural_variants
SAF_DIR=${BASEDIR}/saf
SFS_DIR=${BASEDIR}/sfs
FST_DIR=${BASEDIR}/fst

#clustA SAF
angsd \
	-b ${BASEDIR}/A_bamslist.txt \
	-ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
	-anc /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
	-r ${chrom}: \
	-sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
	-out ${SAF_DIR}/${PREFIX}_${chrom}_A_plm_folded \
	-nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 \
	-setminDepth 17 \
	-setmaxDepth 85 \
	-GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

#clustB SAF
angsd \
        -b ${BASEDIR}/B_bamslist.txt \
        -ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -anc /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -r ${chrom}: \
        -sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
        -out ${SAF_DIR}/${PREFIX}_${chrom}_B_plm_folded \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 \
        -setminDepth 34 \
        -setmaxDepth 170 \
        -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 13

#clustC SAF
angsd \
        -b ${BASEDIR}/C_bamslist.txt \
        -ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -anc /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -r ${chrom}: \
        -sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
        -out ${SAF_DIR}/${PREFIX}_${chrom}_C_plm_folded \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 \
        -setminDepth 19 \
        -setmaxDepth 95 \
        -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

#clustD SAF
angsd \
        -b ${BASEDIR}/D_bamslist.txt \
        -ref /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -anc /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
        -r ${chrom}: \
        -sites /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
        -out ${SAF_DIR}/${PREFIX}_${chrom}_D_plm_folded \
        -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 \
        -setminDepth 8 \
        -setmaxDepth 40 \
        -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

#PAIRWISE COMPARISONS
#clust A v clust B fst
realSFS \
	${SAF_DIR}/${PREFIX}_${chrom}_A_plm_folded.saf.idx -fold 1 \
	${SAF_DIR}/${PREFIX}_${chrom}_B_plm_folded.saf.idx -fold 1 > \
	${SFS_DIR}/${PREFIX}_${chrom}_A-B_plm_folded.sfs
realSFS fst index \
	${SAF_DIR}/${PREFIX}_${chrom}_A_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_B_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_A-B_plm_folded.sfs \
	-fstout ${FST_DIR}/${PREFIX}_${chrom}_A-B_plm_folded.sfs.pbs \
	-whichFst 1
realSFS fst stats2 \
	${FST_DIR}/${PREFIX}_${chrom}_A-B_plm_folded.sfs.pbs.fst.idx \
	-win 1 -step 1 > \
	${FST_DIR}/${PREFIX}_${chrom}_A-B_plm_folded.sfs.pbs.fst.txt

#clust A v clust C fst
realSFS \
        ${SAF_DIR}/${PREFIX}_${chrom}_A_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_C_plm_folded.saf.idx -fold 1 > \
        ${SFS_DIR}/${PREFIX}_${chrom}_A-C_plm_folded.sfs
realSFS fst index \
        ${SAF_DIR}/${PREFIX}_${chrom}_A_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_C_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_A-C_plm_folded.sfs \
        -fstout ${FST_DIR}/${PREFIX}_${chrom}_A-C_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/${PREFIX}_${chrom}_A-C_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/${PREFIX}_${chrom}_A-C_plm_folded.sfs.pbs.fst.txt

#clust A v clust D fst
realSFS \
        ${SAF_DIR}/${PREFIX}_${chrom}_A_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_D_plm_folded.saf.idx -fold 1 > \
        ${SFS_DIR}/${PREFIX}_${chrom}_A-D_plm_folded.sfs
realSFS fst index \
        ${SAF_DIR}/${PREFIX}_${chrom}_A_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_D_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_A-D_plm_folded.sfs \
        -fstout ${FST_DIR}/${PREFIX}_${chrom}_A-D_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/${PREFIX}_${chrom}_A-D_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/${PREFIX}_${chrom}_A-D_plm_folded.sfs.pbs.fst.txt

#clust B v clust C fst
realSFS \
	${SAF_DIR}/${PREFIX}_${chrom}_B_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_C_plm_folded.saf.idx -fold 1 > \
        ${SFS_DIR}/${PREFIX}_${chrom}_B-C_plm_folded.sfs
realSFS fst index \
        ${SAF_DIR}/${PREFIX}_${chrom}_B_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_C_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_B-C_plm_folded.sfs \
        -fstout ${FST_DIR}/${PREFIX}_${chrom}_B-C_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/${PREFIX}_${chrom}_B-C_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/${PREFIX}_${chrom}_B-C_plm_folded.sfs.pbs.fst.txt

#clust B v clust D fst
realSFS \
        ${SAF_DIR}/${PREFIX}_${chrom}_B_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_D_plm_folded.saf.idx -fold 1 > \
        ${SFS_DIR}/${PREFIX}_${chrom}_B-D_plm_folded.sfs
realSFS fst index \
        ${SAF_DIR}/${PREFIX}_${chrom}_B_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_D_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_B-D_plm_folded.sfs \
        -fstout ${FST_DIR}/${PREFIX}_${chrom}_B-D_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/${PREFIX}_${chrom}_B-D_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/${PREFIX}_${chrom}_B-D_plm_folded.sfs.pbs.fst.txt

#clust C v clust D fst
realSFS \
        ${SAF_DIR}/${PREFIX}_${chrom}_C_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_D_plm_folded.saf.idx -fold 1 > \
        ${SFS_DIR}/${PREFIX}_${chrom}_C-D_plm_folded.sfs
realSFS fst index \
        ${SAF_DIR}/${PREFIX}_${chrom}_C_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/${PREFIX}_${chrom}_D_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/${PREFIX}_${chrom}_C-D_plm_folded.sfs \
        -fstout ${FST_DIR}/${PREFIX}_${chrom}_C-D_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/${PREFIX}_${chrom}_C-D_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/${PREFIX}_${chrom}_C-D_plm_folded.sfs.pbs.fst.txt
