% Lawrencium 101 
% February 11, 2021
% Wei Feinstein


# Outline

- Orientation of Lawrencium supercluster
- Access/login to clusters
- Access software on the system
- Data transfer to/from clusters
- Job submission and monitoring
- Open Ondemand with Jupyter notebooks
- Remote visualization  

Slides can be found on github from [here](https://github.com/lbnl-science-it/Training-Lawrencium-101-Feb2021)


# Lawrencium Cluster Overview

- A computing service provided by the IT Division to support researchers in all disciplines at the Lab
- Help the scientists solve various problems  that positively impact the world.  
- Lawrencium is a LBNL Condo Cluster Computing program
  - Significant investment from LBNL
  - Individual PIs purchasing nodes and storage
  - Computational cycles are shared among all lawrencium users

- Lawrenium: IT Division & Condo Contributions
  - 1145 Compute nodes
  - 30,192 CPUs
  - 160 GPUs 
  - 722 User Accounts
  - 416 Groups 

- Standalone Clusters
  - UC Berkeley  
  - Advanced Light Source   
  - Nuclear Science Division   
  - Applied Nuclear Physics
  - Biological Systems Engineer Division


# Conceptual Diagram of Lawrencium

<left><img src="figures/lrc.png" width="70%"></left>

[Detailed informaton of Lawrencium](https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/lbnl-supercluster/lawrencium)


# Getting Access to Lawrencium

### Three types of Project Accounts

- Primary Investigator (PI) Computing Allowance (PCA) account: free 300K SUs per year (pc_xxx)
- Condo account: PIs can purchage compute nodes to be added to the general pool, in exchage for their own priority access and share the Lawrencium infrastructure (lr_xxx)
- Recharge account: pay as you go with minimal recharge rate ~ $0.01/SU (ac_xxx)
- Details about project accounts can be found [here](http://scs.lbl.gov/getting-an-account) 
- PIs can add researchers/students working with them to get user accounts with access to the PCA/condo/recharge resources available to them

### User accounts
- [User account request](http://scs.lbl.gov/getting-an-account)
- [User agreement consent](http://scs.lbl.gov/getting-an-account)


### Login to Lawrencium Cluster

- Linux terminal (command-line) session. 
- Mac terminal (see Applications -> Utilities -> Terminal). 
- Windows [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).
- One-time passwords (OPT): set up your smartphone or tablet with Google Authenticator 
- Login:
```
ssh $USER@lrc-login.lbl.gov
```
- Followed by password prompt 
```
$ password:
```
- Enter your PIN followed by the one-time password from which your Google Authenticator app generates on your phone / tablet.
- **DO NOT run jobs on login nodes!!**


# User Space
 
- Home: 10GB per user, backed up
`/global/home/users/$USER/`
- Global scratch: shared, no backup, where to launch jobs
`/global/scratch/$USER/`
- Shared group space
- `/global/home/groups-sw/  200GB backups
- /global/home/group/` 400GB no backup
- Condo storage 
`e.g. /clusterfs/etna/`


# Data Transfer 

### scp/rsync on lrc-xfer.lbl.gov (DTN)
```
# Transfer to Lawrencium (from your local machine)
scp file-xxx $USER@lrc-xfer.lbl.gov:/global/home/users/$USER
scp -r dir-xxx $USER@lrc-xfer.lbl.gov:/global/scratch/$USER

# Transfer data from Lawrencium (from your local machine)
scp $USER@lrc-xfer.lbl.gov:/global/scratch/$USER/file-xxx ~/Desktop

# Transfer from Lawrencium to Another Institute
ssh $USER@lrc-xfer.lbl.gov   # DTN
scp -r file-on-lawrencium $USER@other-institute:/destination/path/$USER
```
rsync: a better data transfer tool with regular backups
`rsync -avpz file-at-local $USER@lrc-xfer.lbl.gov:/global/home/user/$USER`

- On Window
  - [WinSCP](https://winscp.net/eng/index.php): SFTP client and FTP client for Microsoft Windows
  - [FileZella](https://filezilla-project.org/): multi-platform program via SFTP

### Data Transfer using Globus

- Transfer data faster and unattended between endpoints, see [instructions](https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/data-transfer)
- Possible endpoints include: lbnl#lrc, your laptop/desktop, NERSC, among others.
- Transfer data to/from your laptop (endpoint setup):
 - Globus Connect Personal [set up](https://www.globus.org/globus-connect-personal)
 - Your machine established as an endpoint
 - Globus Connect Pesonal actively running on your machine. 

<left><img src="figures/globus.jpg" width="70%"></left>


# Softwre Module Farm 

- Commonly used compiler, software tools provided to all cluster users
- Maintained on a centralized storage device and mounted as read-only NFS file system
   - Compilers: intel, gcc, MPI compilers, Python
   - Tools: matlab, singularity, cuda
   - Applications: machine learning, QChem, MD, cp2k
   - Libraries: fftw, lapack
- Environment Modules: framework to manage users’ software environment dynamically 
- Properly set up PATH, LD_LIBRARY_PATH…
- Avoid clashes between incompatible software

### Command line tool Module 

```  
module purge: clear user’s work environment
module avail: check available software packages
module load xxx*: load a package
module list: check currently loaded software 
```
- Modules are arranged in a hierarchical fashion, some of the modules become available only after you load the parent module (e.g., MKL, FFT, and HDF5/NetCDF software is nested within the gcc module). 
- Here's how to load MPI as an example
```
module load intel/2016.4.072
module av
module load mkl/2016.4.072 openmpi/3.0.1-intel
```
- More environment modules can be found [here](https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/sl6-module-farm-guide)
- Users are allowed to install software in their home or group space


# Install Python Modules 

- Users don't have admin rights, but most software can be installed  --prefix=/dir/to/your/path
- Python modules: abundantly available but cannot be installed in the default location without admin rights.
- pip install --user package_name
- export PYTHONPATH
```
[wfeinstein@n0000 ~]$ module available python
--------------------- /global/software/sl-7.x86_64/modfiles/langs -----------------------------------
python/2.7          python/3.5          python/3.6(default) python/3.7          python/3.7.6        python/3.8.2-dll
```
[wfeinstein@n0000 ~]$ module load python/3.7

[wfeinstein@n0000 ~]$ python3 -m site --user-site
/global/home/users/wfeinstein/.local/lib/python3.7/site-packages

[wfeinstein@n0000 ~]$ pip install --user ml-python
...
Successfully built ml-python
Installing collected packages: ml-python
Successfully installed ml-python-2.2

[wfeinstein@n0000 ~]$ export PYTHONPATH=~/.local/lib/python3.7/site-packages:$PYTHONPATH

- pip install --install-option="--prefix=$HOME/.local" package_name
- Install from souce code after download the code 
- python setup.py install –home=/home/user/package_dir
- Creat a virutal environment: python3 -m venv my_env 
 

# SLURM: Resource Manager & Job Scheduler

### Overview

All computations are done by submitting jobs to the scheduling software that manages jobs on the cluster, called SLURM.
SLURM is the resource manager and job scheduler to managing jobs on cluster

Why is this necessary? Otherwise your jobs would be slowed down by other people's jobs running on the same node. This also allows everyone to fairly share Savio.

The basic workflow is:

  - login to Lawrencium; you'll end up on one of the login nodes in your home directory
  - cd to the directory from which you want to submit the job
  - submit the job using sbatch (or an interactive job using srun, discussed later)
  - when your job starts, the working directory will be the one from which the job was submitted
  - the job will be running on a compute node, not the login node 

#### Accounts, Partitions, Quality of Service (QOS)
 
- Check slurm association, such as qos, account, partition, the information is required when submitting a job

`sacctmgr show association user=wfeinstein -p`

```
Cluster|Account|User|Partition|Share|Priority|GrpJobs|GrpTRES|GrpSubmit|GrpWall|GrpTRESMins|MaxJobs|MaxTRES|MaxTRESPerNode|MaxSubmit|MaxWall|MaxTRESMins|QOS|Def QOS|GrpTRESRunMins|
perceus-00|scs|wfeinstein|lr6|1||||||||||||lr_debug,lr_lowprio,lr_normal|||
perceus-00|ac_test|wfeinstein|lr5|1||||||||||||lr_debug,lr_lowprio,lr_normal|||
perceus-00|pc_test|wfeinstein|lr4|1||||||||||||lr_debug,lr_lowprio,lr_normal|||
perceus-00|pc_test|wfeinstein|lr_bigmem|1||||||||||||lr_debug,lr_lowprio,lr_normal|||
perceus-00|lr_test|wfeinstein|lr3|1||||||||||||condo_test|||
perceus-00|scs|wfeinstein|es1|1||||||||||||es_debug,es_lowprio,es_normal|||
...
```


# Job Submission

## Submit an Interactive Job

Commonly used for code debugging, testing, monitoring
- srun: Add your resource request to the queue. When the allocation starts, a new bash session will start up on one of the granted nodes
`srun --account=ac_xxx --nodes=1 --partition=lr5 --time=1:0:0 --qos=lr_normal --pty bash`
or
`srun -A ac_xxx -N 1 -p lr5 -q lr_normal -t 1:0:0 --pty bash`
- salloc : functions similarly srun --pty bash. however when the allocation starts, a new bash session will start up on the login node
```
[wfeinstein@n0003 ~]$ salloc --account=scs --nodes=1 --partition=lr6 --time=1:0:0 --qos=lr_normal
salloc: Granted job allocation 28755918
salloc: Waiting for resource configuration
salloc: Nodes n0101.lr6 are ready for job
[wfeinstein@n0003 ~]$ squeue -u wfeinstein
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
          28755918       lr6     bash wfeinste  R       0:14      1 n0101.lr6 
[wfeinstein@n0003 ~]$ ssh n0101.lr6
[wfeinstein@n0101 ~]$ hostname
n0101.lr6
```
Once you are on the node, run your commands or application
```
# cd to your work directory
cd /your/dir

## Commands to run
module load python/3.7
python my.py >& mypy.out
```


## Submit a Batch Job

- Get help with the complete command options
`sbatch --help`
- sbatch: submit a job to the batch queue system
`sbatch myjob.sh`

Job Submission Script Example - myjob.sh 

```
#!/bin/bash -l

# Job name:
#SBATCH --job-name=mytest
#
# Partition:
#SBATCH --partition=lr6
#
# Account:
#SBATCH --account=scs
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
#SBATCH --constrain=lr6_cas
#
# cd to your work directory
cd /your/dir

## Commands to run
module load python/3.7
python my.py >& mypy.out 
````


### Node Features 

Compute nodes have various hardware within a SLURM partition
  - lr6_sky
  - lr6_cas
  - lr6_cas,lr6_m192
  - lr6_sky,lr6_m192 
- Wait time for the resouces typically is longer
- --constrain flag   
```
[wfeinstein@n0000 ~]$ srun --account=scs --nodes=1 --partition=lr6 --time=1:0:0 --qos=lr_normal --constrain=lr6_sky --pty bash
[wfeinstein@n0081 ~]$ lscpu |egrep '^CPU\(s\):|Model name'
CPU(s):                32
Model name:            Intel(R) Xeon(R) Gold 6130 CPU @ 2.10GHz
[wfeinstein@n0081 ~]$ free -h
              total        used        free      shared  buff/cache   available
Mem:            93G        2.2G         83G        3.1G        7.4G         87G
Swap:          8.0G          0B        8.0G
[wfeinstein@n0081 ~]$ exit
exit
[wfeinstein@n0000 ~]$ srun --account=scs --nodes=1 --partition=lr6 --time=1:0:0 --qos=lr_normal --constrain=lr6_sky,lr6_m192 --pty bash
[wfeinstein@n0023 ~]$ free -h
              total        used        free      shared  buff/cache   available
Mem:           187G        2.6G        172G        1.7G         12G        182G
Swap:          8.0G        1.5G        6.5G
```
- Features can be found [here](https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/lbnl-supercluster/lawrencium)

Memeory speicification when using shared partition:
- Most Lawrencium partitions are exclusive: compute node belongs to one user
- Some condo accounts or departmental clusters, such as etna, each compute node can be shared by multiple users   
- --ntaks=1 --mem=4700 (1 core on a 192GB RAM node)
- --ntaks=2 --mem=9200 (2 core on a 192GB RAM node)
- --ntaks=1 --mem=4700 (1 core on a 96GB RAM node)
- --ntaks=2 --mem=9200 (2 core on a 96GB RAM node) 

There are two large memory nodes 1.5TB in lr6
- --partition=lr_bigmem


## Submit a Job to GPU cluster (es1)

### Interactive GPU Jobs

- --gres=gpu:type:GPU#
- --ntasks=CPU_CORE#
- Note: Ratio of CPU_CORE#:GPU# = 2:1
```
srun -A your_acct -N 1 -p es1 --gres=gpu:1 --ntasks=2 -q es_normal –t 0:30:0 --pty bash

[wfeinstein@n0000 ~]$ srun -A scs -N 1 -p es1 --gres=gpu:1 --ntasks=2 -q es_normal -t 0:30:0 --pty bash
[wfeinstein@n0019 ~]$ nvidia-smi
[wfeinstein@n0019 ~]$ nvidia-smi
Sat Feb  6 10:13:25 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.44       Driver Version: 440.44       CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla V100-SXM2...  Off  | 00000000:62:00.0 Off |                    0 |
| N/A   45C    P0    53W / 300W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   1  Tesla V100-SXM2...  Off  | 00000000:89:00.0 Off |                    0 |
| N/A   45C    P0    55W / 300W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
[wfeinstein@n0019 ~]$ hostname
n0019.es1
```
- Specify GPU type
  - V100 --gres=gpu:V100:1 
  - GTX1080TI --gres=gpu:GTX1080TI:1 
  - GTX1080TI --gres=gpu:GRTX2080TI:1
```
[wfeinstein@n0000 ~]$ srun -A scs -N 1 -p es1 --gres=gpu:GTX1080TI:1 --ntasks=2 -q es_normal -t 0:30:0 --pty bash
[wfeinstein@n0002 ~]$ nvidia-smi -L
GPU 0: GeForce GTX 1080 Ti (UUID: GPU-e15de6ae-dbbd-8fca-c888-be2bc9d9b519)
GPU 1: GeForce GTX 1080 Ti (UUID: GPU-55e97cf5-0388-2539-4577-5d940d83fa2f)
GPU 2: GeForce GTX 1080 Ti (UUID: GPU-e5c71e18-25a6-523c-34b2-0c0cb448acb8)
GPU 3: GeForce GTX 1080 Ti (UUID: GPU-fa31d967-ffe0-d500-e7eb-25e1349c8b05)```
```

### Submit A GPU Batch Job 

Job Submission Script Example 

```
#!/bin/bash -l

#SBATCH --job-name=mytest
#SBATCH --partition=es1         ## es1 GPU partition
#SBATCH --account=scs
#SBATCH --qos=es_normal         ## qos of es1
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --gres=gpu:GTX1080TI:2  ## GPU cards
#SBATCH --ntasks=4              ## CPU cores
#
cd /your/dir

## Commands to run
module load python/3.7
python my.py >& mypy.out 
````


### Submit A MPI Job

When use multiple nodes, you need to carefully specify the resources. The key flags for use in your job script are:

- --nodes (or -N): number of nodes 
- --ntasks-per-node: number of tasks (i.e., processes) one wants to run on each node, when your job uses large memory, < Max Core# of a node 
- --cpus-per-task (or -c): number of cpus to be used for each task
- --ntasks (or -n): total number of tasks and let the scheduler determine how many nodes and tasks per node are needed. 
- In general --cpus-per-task will be 1 except when running threaded code.

```
#!/bin/bash -l

#SBATCH --job-name=mytest
#SBATCH --partition=lr6
#SBATCH --account=scs
#SBATCH --qos=lr_normal
#SBATCH --time=2:00:00
#SBATCH --nodes=2             ## Node count
##SBATCH --ntasks=80          ## Number of MPI tasks to launch (example):  
##SBATCH --cpus-per-task=1
##SBATCH --ntasks-per-node    ## important with large memory requirement
cd /your/dir

## Commands to run
module load intel/2016.4.072 openmpi/3.0.1-intel
mpirun -np 80 ./a.out        ## your MPI application
````


### Submit Tasks in Parallel (GNU Parallel) 

GNU Parallel is a shell tool for executing jobs in parallel on one or multiple computers. 
- A job can be a single core serial task, multi-core or MPI application. 
- A job can also be a command that reads from a pipe. 
- The typical input is a list of parameters required for each task. 
- GNU parallel can then split the input and pipe it into commands in parallel. 
- GNU parallel makes sure output from the commands is the same output as you would get had you run the commands sequentially, and output names can be easily correlated to input file names for easy post-data processing. This makes it possible to use output from GNU parallel as input for other programs.
```
parallel --jobs $JOBS_PER_NODE --slf hostfile --wd $WDIR --joblog task.log --resume --progress \

                -a task.lst sh run-blast.sh {} output/{/.}.blst $NTHREADS
```
 
Detailed information of how to submit serial tasks in parallel can be found [here](https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/faq)


# Monitoring Jobs

- sinfo: check node status of partitions (idle, allocated, drain, down) 
```
[wfeinstein@n0000 ~]$ sinfo –r –p lr5
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST 
lr5          up   infinite      3 drain* n0004.lr5,n0032.lr5,n0169.lr5 
lr5          up   infinite      2  down* n0112.lr5,n0118.lr5 
lr5          up   infinite     58  alloc n0000.lr5,n0001.lr5,n0002.lr5,n0003.lr5,n0006.lr5,n0009.lr5
lr5          up   infinite    115   idle n0005.lr5,n0007.lr5,n0008.lr5
lr5          up   infinite     14   down n0048.lr5,n0050.lr5,n0054.lr5
...
```
- squeue: check job status in the batch queuing system (R or PD)
```
squeue –u $USER
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
          28757187       lr6     bash wfeinste  R       0:09      1 n0215.lr6 
          28757723       es1     bash wfeinste  R       0:16      1 n0002.es1 
          28759191       lr6     bash wfeinste PD       0:00    120 (QOSMaxNodePerJobLimit)
```
- sacct: check job information or history
```
[wfeinstein@n0002 ~]$ sacct -j 28757723
       JobID    JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
28757723           bash        es1        scs          2    RUNNING      0:0 

[wfeinstein@n0002 ~]$ sacct -X -o 'jobid,user,partition,nodelist,stat'
       JobID      User  Partition        NodeList      State 
------------ --------- ---------- --------------- ---------- 
28755594     wfeinste+        lr5       n0192.lr5  COMPLETED 
28755597     wfeinste+        lr6       n0101.lr6  COMPLETED 
28755598     wfeinste+        lr5       n0192.lr5  COMPLETED 
28755604     wfeinste+ csd_lr6_s+       n0144.lr6  COMPLETED 
28755693     wfeinste+        lr6       n0101.lr6 CANCELLED+ 
....
28757187     wfeinste+        lr6       n0215.lr6  COMPLETED 
28757386     wfeinste+        es1       n0019.es1     FAILED 
28757389     wfeinste+        es1       n0002.es1    TIMEOUT 
28757723     wfeinste+        es1       n0002.es1    RUNNING 
```
- wwall -j <JOB_ID>: check an active job resouce utilization, from a login node
```
[wfeinstein@n0000 ~]$ wwall -j 28757187
--------------------------------------------------------------------------------
Total CPU utilization: 0%                          
          Total Nodes: 1         
               Living: 1                           Warewulf
          Unavailable: 0                      Cluster Statistics
             Disabled: 0                 http://warewulf.lbl.gov/
                Error: 0         
                 Dead: 0         
--------------------------------------------------------------------------------
 Node      Cluster        CPU       Memory (MB)      Swap (MB)      Current
 Name       Name       [util/num] [% used/total]   [% used/total]   Status
n0215.lr6               0%   (40) % 3473/192058    % 1655/8191      READY
```
More information of [slurm usage](https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/scheduler/slurm-usage-instructions)
- scancel : cancel a job
- `scancel jobID`



# Open Ondemand 

- Single web point of entry to Lawrencium supercluster
- Allow access to Lawrencium compute resources 
- Supercomputer access 					
  - File browser: file editing, data transfer
  - Shell command line access - terminal
- Monitor jobs
- Interactive applications: Jupyter notebooks, MatLab, RStudio...
  - Two partitions, 4 CPU nodes and 1 GPU node, for exploration
  - Access to all Lawrencium partitions for computing jobs
- Sever: [https://lrc-ondemand.lbl.gov/](https://lrc-ondemand.lbl.gov/)
  - Intel Xeon Gold processor with 32 cores, 96 GB RAM

# Open Ondemnd One-Minute Demo Using Jupyter Notebooks

[https://lrc-ondemand.lbl.gov/](https://lrc-ondemand.lbl.gov/)
 

# Remote Visulization 

- Allow users to run a real desktop within the cluster environment 
- Allow applications with a GUI, commercial applications, debugger or visualization applications to render results. 
- Allows users to disconnect/resume from anywhere without losing the work. 
- RealVNC is provided as the remote desktop service, steps:
  - Login to viz node (lrc-viz.lbl.gov)
  - Start VNC service on viz node
  - Start applications: Firefox, Jupyter notebooks, paraview ...
  - Shut it down properly to release resource for other users (logout). Simply close the VNC Viewer does not clean the resource on the server
- Detailed [instructions](https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/remote-desktop)


# Getting help

- Virtual Office Hours:
    - Time: 10:30am - noon (Wednesdays)
    - Online [request](https://docs.google.com/forms/d/e/1FAIpQLScBbNcr0CbhWs8oyrQ0pKLmLObQMFmYseHtrvyLfOAoIInyVA/viewform)
- Sending us tickets at hpcshelp@lbl.gov
- More information, documents, tips of how to use LBNL Supercluster [http://scs.lbl.gov/](http://scs.lbl.gov)

To improve our HPC traing and services, please fill out [Training Survey](https://docs.google.com/forms/d/e/1FAIpQLSdrmW-7gZ8FankQwEceY6r_uXPmLHAuXFjDDfwu-86A1a0llg/viewform)


# Hands-on Exercise

- 1) Login  
- 2) Data transfer
- 3) Module load
- 4) Submit jobs


# Login and Data Transfer

Objective: transfer data to/from LRC 

1) Download test data [here](  ) 

2) Open two linux terminals on Mac or Window via Putty 

3) Transfer local data.sample to LRC on terminal 1 
```
scp -r data.sample $USER@lrc-xfer.lbl.gov:/global/home/users/$USER 
scp -r data.sample $USER@lrc-xfer.lbl.gov:~
``` 
4) On terminal 2, login to LRC
``` 
ssh $USER@lrc-login.lbl.gov 
pwd 
cat data.sample
cp data.sample data.bak
``` 
5) Transfer data from LRC to your local machine on terminal 1
```
scp -r $USER@lrc-xfer.lbl.gov:/global/home/users/$USER/data.bak .
ls data.*
```


# Modules

- Display software packages on LRC
` module available`
- Check modules in your env
` module list`
- Clear your env
` module purge`
- Load a module
```
 module load intel/2016.4.072
 module list
 module av
```


# Job Submission

- Check your account slurm association
```
sacctmgr show association -p user=$USER

Cluster|Account|User|Partition|Share|Priority|GrpJobs|GrpTRES|GrpSubmit|GrpWall|GrpTRESMins|MaxJobs|MaxTRES|MaxTRESPerNode|MaxSubmit|MaxWall|MaxTRESMins|QOS|Def QOS|GrpTRESRunMins|
perceus-00|scs|wfeinstein|lr6|1|||||||||||||lr6_lowprio,lr_debug,lr_normal|||
perceus-00|scs|wfeinstein|es1|1|||||||||||||es_debug,es_lowprio,es_normal|||

```
-   
- 


