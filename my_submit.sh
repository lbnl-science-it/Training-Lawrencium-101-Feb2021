#!/bin/bash -l

# Job name:
#SBATCH --job-name=mytest
#
# Partition:
#SBATCH --partition=lr6
#
# Account:
#SBATCH --account=your_account
#
# qos:
#SBATCH --qos=lr_normal
#
# Wall clock time:
#SBATCH --time=1:00:00
#
# Node count
#SBATCH --nodes=1
#
# Node feature
##SBATCH --constrain=lr6_cas
#
# cd to your work directory
cd /global/scratch/$USER

## Commands to run
module load python/3.7
python my.py >& mypy.out 
