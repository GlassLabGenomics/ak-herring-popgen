#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-00:05:00
#SBATCH --job-name=sigFST
#SBATCH --output=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_sigFST_%A.out
#SBATCH --error=/scratch/letimm/Clupea_pallasii260/job_outfiles/CPAL-CPAL260_sigFST_%A.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu

module purge

for iteration in {1..50}
do
	/home/letimm/bin/generate-fst-posterior_gombessa.py \
		--full_bamslist /scratch/letimm/Clupea_pallasii260/UN-EBS-KOTZ_bamslist.txt \
		--sites_file /scratch/letimm/Clupea_pallasii260/paralogs/CPAL-CPAL260_wholegenome_plm_retain.sites \
		--population_details unalaska:20,ebs:100,kotzebue:19 \
		--population_pairs kotzebue-unalaska,ebs-unalaska,kotzebue-ebs \
		--reference_genome /scratch/letimm/reference_genomes/Clupal_KotzSound_assembly.fasta \
		--email letimm@alaska.edu \
		--iteration ${iteration} \
		--software_dir /home/letimm/software/ \
		--group_id UN-EBS-KOTZ
done
