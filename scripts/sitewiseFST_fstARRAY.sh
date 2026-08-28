#!/bin/bash

#SBATCH --time=0-08:00:00
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=5G
#SBATCH --job-name=fst
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
SFS_DIR=${BASEDIR}/sfs
FST_DIR=${BASEDIR}/sitewise_fst

#GOODNEWSBAY
realSFS fst index \
	${SAF_DIR}/GoodnewsBay_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Kotzebue_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/GoodnewsBay-Kotzebue_${chrom}_plm_folded.sfs \
	-fstout ${FST_DIR}/GoodnewsBay-Kotzebue_${chrom}_plm_folded.sfs.pbs \
	-whichFst 1
realSFS fst stats2 \
	${FST_DIR}/GoodnewsBay-Kotzebue_${chrom}_plm_folded.sfs.pbs.fst.idx \
	-win 1 -step 1 > \
	${FST_DIR}/GoodnewsBay-Kotzebue_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/GoodnewsBay_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/NelsonIsland_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/GoodnewsBay-NelsonIsland_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/GoodnewsBay-NelsonIsland_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/GoodnewsBay-NelsonIsland_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/GoodnewsBay-NelsonIsland_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/GoodnewsBay_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/NortonSound_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/GoodnewsBay-NortonSound_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/GoodnewsBay-NortonSound_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/GoodnewsBay-NortonSound_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/GoodnewsBay-NortonSound_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/GoodnewsBay_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/PortMoller_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/GoodnewsBay-PortMoller_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/GoodnewsBay-PortMoller_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/GoodnewsBay-PortMoller_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/GoodnewsBay-PortMoller_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/GoodnewsBay_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Togiak_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/GoodnewsBay-Togiak_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/GoodnewsBay-Togiak_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/GoodnewsBay-Togiak_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/GoodnewsBay-Togiak_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/GoodnewsBay_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Unalaska_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/GoodnewsBay-Unalaska_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/GoodnewsBay-Unalaska_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/GoodnewsBay-Unalaska_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/GoodnewsBay-Unalaska_${chrom}_plm_folded.fst.txt

#KOTZEBUE
realSFS fst index \
        ${SAF_DIR}/Kotzebue_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/NelsonIsland_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/Kotzebue-NelsonIsland_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/Kotzebue-NelsonIsland_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/Kotzebue-NelsonIsland_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/Kotzebue-NelsonIsland_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/Kotzebue_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/NortonSound_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/Kotzebue-NortonSound_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/Kotzebue-NortonSound_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/Kotzebue-NortonSound_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/Kotzebue-NortonSound_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/Kotzebue_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/PortMoller_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/Kotzebue-PortMoller_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/Kotzebue-PortMoller_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/Kotzebue-PortMoller_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/Kotzebue-PortMoller_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/Kotzebue_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Togiak_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/Kotzebue-Togiak_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/Kotzebue-Togiak_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/Kotzebue-Togiak_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/Kotzebue-Togiak_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/Kotzebue_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Unalaska_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/Kotzebue-Unalaska_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/Kotzebue-Unalaska_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/Kotzebue-Unalaska_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/Kotzebue-Unalaska_${chrom}_plm_folded.fst.txt

#NelsonIsland
realSFS fst index \
        ${SAF_DIR}/NelsonIsland_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/NortonSound_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/NelsonIsland-NortonSound_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/NelsonIsland-NortonSound_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/NelsonIsland-NortonSound_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/NelsonIsland-NortonSound_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/NelsonIsland_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/PortMoller_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/NelsonIsland-PortMoller_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/NelsonIsland-PortMoller_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/NelsonIsland-PortMoller_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/NelsonIsland-PortMoller_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/NelsonIsland_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Togiak_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/NelsonIsland-Togiak_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/NelsonIsland-Togiak_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/NelsonIsland-Togiak_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/NelsonIsland-Togiak_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/NelsonIsland_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Unalaska_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/NelsonIsland-Unalaska_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/NelsonIsland-Unalaska_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/NelsonIsland-Unalaska_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/NelsonIsland-Unalaska_${chrom}_plm_folded.fst.txt

#NortonSound
realSFS fst index \
        ${SAF_DIR}/NortonSound_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/PortMoller_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/NortonSound-PortMoller_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/NortonSound-PortMoller_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/NortonSound-PortMoller_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/NortonSound-PortMoller_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/NortonSound_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Togiak_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/NortonSound-Togiak_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/NortonSound-Togiak_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/NortonSound-Togiak_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/NortonSound-Togiak_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/NortonSound_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Unalaska_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/NortonSound-Unalaska_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/NortonSound-Unalaska_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/NortonSound-Unalaska_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/NortonSound-Unalaska_${chrom}_plm_folded.fst.txt

#PortMoller
realSFS fst index \
        ${SAF_DIR}/PortMoller_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Togiak_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/PortMoller-Togiak_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/PortMoller-Togiak_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/PortMoller-Togiak_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/PortMoller-Togiak_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/PortMoller_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Unalaska_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/PortMoller-Unalaska_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/PortMoller-Unalaska_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/PortMoller-Unalaska_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/PortMoller-Unalaska_${chrom}_plm_folded.fst.txt

#Togiak
realSFS fst index \
        ${SAF_DIR}/Togiak_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Unalaska_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/Togiak-Unalaska_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/Togiak-Unalaska_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/Togiak-Unalaska_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/Togiak-Unalaska_${chrom}_plm_folded.fst.txt

#EBS
realSFS fst index \
        ${SAF_DIR}/EBS_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Kotzebue_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/EBS-Kotzebue_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/EBS-Kotzebue_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/EBS-Kotzebue_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/EBS-Kotzebue_${chrom}_plm_folded.fst.txt

realSFS fst index \
        ${SAF_DIR}/EBS_${chrom}_plm_folded.saf.idx -fold 1 \
        ${SAF_DIR}/Unalaska_${chrom}_plm_folded.saf.idx -fold 1 \
        -sfs ${SFS_DIR}/EBS-Unalaska_${chrom}_plm_folded.sfs \
        -fstout ${FST_DIR}/EBS-Unalaska_${chrom}_plm_folded.sfs.pbs \
        -whichFst 1
realSFS fst stats2 \
        ${FST_DIR}/EBS-Unalaska_${chrom}_plm_folded.sfs.pbs.fst.idx \
        -win 1 -step 1 > \
        ${FST_DIR}/EBS-Unalaska_${chrom}_plm_folded.fst.txt
