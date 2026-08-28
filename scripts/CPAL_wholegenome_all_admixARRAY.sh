#!/bin/bash
#SBATCH --time=0-04:00:00
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=3
#SBATCH --mem=8G
#SBATCH --job-name=cpal_admix
#SBATCH --output=/scratch/letimm/bering-sea-herring/job_outfiles2/CPAL_wholegenome_all_admix_%A-%a.out
#SBATCH --error=/scratch/letimm/bering-sea-herring/job_outfiles2/CPAL_wholegenome_all_admix_%A-%a.err
#SBATCH --array=1-7%4

module purge
PATH=$PATH:/home/salmgren/packages/NGSadmix

for k_val in {1..7}
do
        if [[ ${SLURM_ARRAY_TASK_ID} == ${k_val} ]]; then
                break
        fi
done

# not ld pruned, all samples, k=7, 3x reps
NGSadmix -likes /scratch/letimm/bering-sea-herring/beagles/CPAL-CPAL260-GOA-UN-EBS-KOTZ_wgph.beagle.gz -K ${k_val} -outfiles /scratch/letimm/bering-sea-herring/admix/CPAL_CPAL260_GOA_UN_EBS_KOTZ_linked_k${k_val}-0 -P 10 -minMaf 0
NGSadmix -likes /scratch/letimm/bering-sea-herring/beagles/CPAL-CPAL260-GOA-UN-EBS-KOTZ_wgph.beagle.gz -K ${k_val} -outfiles /scratch/letimm/bering-sea-herring/admix/CPAL_CPAL260_GOA_UN_EBS_KOTZ_linked_k${k_val}-1 -P 10 -minMaf 0
NGSadmix -likes /scratch/letimm/bering-sea-herring/beagles/CPAL-CPAL260-GOA-UN-EBS-KOTZ_wgph.beagle.gz -K ${k_val} -outfiles /scratch/letimm/bering-sea-herring/admix/CPAL_CPAL260_GOA_UN_EBS_KOTZ_linked_k${k_val}-2 -P 10 -minMaf 0

# ld pruned, all samples, k=7, 3x reps
NGSadmix -likes /scratch/letimm/bering-sea-herring/beagles/CPAL-CPAL260-GOA-UN-EBS-KOTZ_wgphu.beagle.gz -K ${k_val} -outfiles /scratch/letimm/bering-sea-herring/admix/CPAL_CPAL260_GOA_UN_EBS_KOTZ_unlinked_k${k_val}-0 -P 10 -minMaf 0
NGSadmix -likes /scratch/letimm/bering-sea-herring/beagles/CPAL-CPAL260-GOA-UN-EBS-KOTZ_wgphu.beagle.gz -K ${k_val} -outfiles /scratch/letimm/bering-sea-herring/admix/CPAL_CPAL260_GOA_UN_EBS_KOTZ_unlinked_k${k_val}-1 -P 10 -minMaf 0
NGSadmix -likes /scratch/letimm/bering-sea-herring/beagles/CPAL-CPAL260-GOA-UN-EBS-KOTZ_wgphu.beagle.gz -K ${k_val} -outfiles /scratch/letimm/bering-sea-herring/admix/CPAL_CPAL260_GOA_UN_EBS_KOTZ_unlinked_k${k_val}-2 -P 10 -minMaf 0
