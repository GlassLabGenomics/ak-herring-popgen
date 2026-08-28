#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=16G
#SBATCH --job-name=pca12
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260-sv_chr12_pca_%A.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu

module purge

source activate pcangsd

BASEDIR=/scratch/letimm/Clupea_pallasii260/structural_variants
GLSDIR=${BASEDIR}/gls
PCADIR=${BASEDIR}/pca

#chr7-1
PREFIX1=CPAL-CPAL260-sv_chr12-1
pcangsd \
        --beagle ${GLSDIR}/${PREFIX1}.beagle.gz \
        -o ${PCADIR}/${PREFIX1} \
        --sites-save --pcadapt --threads 10

#chr7-2
PREFIX2=CPAL-CPAL260-sv_chr12-2
pcangsd \
        --beagle ${GLSDIR}/${PREFIX2}.beagle.gz \
        -o ${PCADIR}/${PREFIX2} \
        --sites-save --pcadapt --threads 10
