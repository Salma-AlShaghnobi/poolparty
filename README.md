# :fish: PoolParty (Updated) :pool:

### A Pool-Seq Bioinformatic Pipeline (ver 0.81)

A BASH pipeline to align and analyze paired-end NGS data.  

Current citation: "Micheletti SJ and SR Narum. 2018. Utility of pooled sequencing for association mapping in nonmodel organisms. Molecular Ecology Resources 10.1111/1755-0998.12784"

# Getting Started

Ensure that proper permissions are set to execute each package in the pipeline . 

 PoolParty is designed to be run on analysis servers. As such, memory and storage may be limiting factor for some systems depending on genome sizes, number of pools, number of SNPs, etc. In general, 128 gb of ram with at least 10 threads should suffice. 

 It is highly recommended to run the example files provided in the example directory before diving into large datasets.  

 PP_example.pdf under 'examples' contains additional detailed information on the pipeline.  

# Precursors

This repository contains minor code modifications and revised comments that assist the user during the installation process. This version offers enhanced details regarding all facets of the pipeline. It also rectifies and debugs errors encountered when attempting to execute the original work. Note: this file only contains edits, as for the rest of the information, please refer back to the original README file  

# Installation

Installing the [poolparty package](https://github.com/StevenMicheletti/poolparty/) to run PPAlign and PPanalyze on the example it provides requires installing certain versions of Ubuntu, R, and the libraries listed below (which may be older versions). The following sections are not exhaustive (it does not include a line to install perl, for example), but they correspond to the parts of the installation that need more work than just running an install command. 

## Ubuntu Versions
There are R packages (for example, [multtest](https://www.bioconductor.org/packages/release/bioc/html/multtest.html)) that require R version 4.4.* which according to the [R website](https://cran.r-project.org/bin/linux/ubuntu/fullREADME.html) (as of August 2024) only supports the following Ubuntu versions:
Noble Numbat (24.04, amd64 only)
 - Jammy Jellyfish (22.04, amd64 only)
 - Focal Fossa (20.04; LTS and amd64 only)
 - Bionic Beaver (18.04; LTS)
 - Xenial Xerus (16.04; LTS)
     
If the Linux version is not listed (e.g., 23.04), and installation of R 4.4.* is unattainable, you may need to upgrade or downgrade to one of the previously specified versions.

## R and R Packages

If the essential R packages are not available, PoolParty will try to install them automatically; however, some will fail if the R version is not 4.4.*. Below are the listed required high-level packages for each of the main poolparty scripts, and the bolded packages are the ones known to require R 4.4.*:
* PPalign: 
    1. matrixStats 
    2. tidyr 
    3. stringr 
    4. data.table

* PPstats: 
    1. reshape 
    2. fBasics 
    3. ggplot2 
    4. RColorBrewer

* PPanalyze:
    1. matrixStats 
    2. plyr 
    3. stringr 
    4. data.table 
    5. fBasics 
    6. ape 
    7. metap

If R is already installed, you can check the version by running the following:
> R --version

### R 4.4.*
If R is not installed or is not the correct version, first ensure that the Ubuntu version you are using is supported by running: 
>lsb_release -a

Which should generate the following output, identifying the version and codename:

    No LSB modules are available.

    Distributor ID:	Ubuntu

    Description:	Ubuntu 22.04.4 LTS

    Release:	22.04

    Codename:	jammy

Assuming it's a supported distribution and the codename you're using is "Jammy" as seen in the result of the preceding command, run the following to install the most recent version of R.
> sudo wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/cran.gpg

a. Necessary if the public key needed to verify the packages from the repository are missing.

> sudo echo "deb [signed-by=/usr/share/keyrings/cran.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee /etc/apt/sources.list.d/cran.list

> sudo apt-get update

> sudo apt-get install r-base

### R Packages
Certain R packages require lower-level libraries that may not have previously been installed. To install them, use the following commands:

> sudo apt-get update

> sudo apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev libfftw3-dev

To update all installed packages to their most recent versions, or rebuild them if you updated R, use the following command:

> Rscript -e 'update.packages(ask = FALSE, checkBuilt = TRUE)'

## Ubuntu Packages

Below are the [packages required by poolparty](https://github.com/StevenMicheletti/poolparty/?tab=readme-ov-file#required-package-with-version-at-inception) , the versions, a link to the website, and a link to the downloaded version on Google Drive (if available):

* samtools (1.5) - [Link](http://www.htslib.org/download/), [Drive](https://drive.google.com/file/d/1FQrrn2ttmSs6MOwo5mfICFdoTAzpW7R4/view?usp=drive_link)
* samblaster (0.1.24) - [Link](https://github.com/GregoryFaust/samblaster), [Drive](https://drive.google.com/file/d/1AQvhvDqGTz7KDtlZ6pP-gxCxSJEK7H1i/view?usp=drive_link)
* bcftools (1.5) - [Link](http://www.htslib.org/download/), [Drive](https://drive.google.com/file/d/1Lq8VDu4J7LigFYkMrg90NjCz4VZbd5WF/view?usp=drive_link)
* Burrows-Wheeler Aligner (BWA; 07.12) - [Link](http://bio-bwa.sourceforge.net/), [Drive](https://drive.google.com/file/d/132R--Ln5xnBBckMxgX3YdLbMvVnLH5BP/view?usp=drive_link)
* Popoolation2 (1.201) - [Link](https://sourceforge.net/p/popoolation2/wiki/Main/)
* BBMap (37.93) - [Link](https://sourceforge.net/projects/bbmap/), [Drive](https://drive.google.com/file/d/1TmvT0Vfq7yIO9Bo2DrxQZo2D5TjCdrtO/view?usp=drive_link)
* Picard Tools (2.17.11) - [Link](https://github.com/broadinstitute/picard/tree/2.17.11), [Drive](https://drive.google.com/file/d/1Ceb1gNdYyNCR6ZyNvGBRPoDj-riTxFAy/view?usp=drive_link)
* Fastqc (0.11.7) - [Link](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/), [Drive](https://drive.google.com/file/d/1vNVeTCMYZXZN6yNVoq3Ay133nHByvG9k/view?usp=drive_link)

In addition to these, these additional packages needed to be installed to install Picard Tools correctly:

* Java 8u66 - [Link](https://www.oracle.com/java/technologies/javase/8u66-relnotes.html), [Drive](https://drive.google.com/file/d/1PVnmFa7VrGE1wAH39gO5QNdZHbyEuAeI/view?usp=drive_link)
* Gradle (requires java) - [Link](https://gradle.org/)
* Gettext 0.22.5 - [Link](https://www.gnu.org/software/gettext/), [Drive](https://drive.google.com/file/d/1nY_Un7JXdloUju_-Yoi5chCXGiIf0Exv/view?usp=drive_link)

### Samtools (1.5)

Download and extract the directory, then run the configure command to specify the installation path, and finally run make and make install. To eliminate ambiguity, add an extra soft link to /usr/bin. If you don't have sudo privileges, install locally and add the local binary to the path. 
Steps:
> ./configure --prefix=/usr/local/
> make
> sudo make install
> sudo ln -s /usr/local/bin/samtools /usr/bin/samtools

Verify the version is correct by running: 
> samtools

### Samblaster (0.1.24)
Download and extract the directory, run make, and then create a soft link to the resulting binary
> make
> sudo ln -s ~/.local/packages/samblaster-v.0.1.24/samblaster /usr/bin/samblaster

Verify the version is correct by running: 
>samblaster

### Bcftools (1.5)
Download and extract the directory, configure to set the installation path, and then run make and make install. To eliminate ambiguity, add an extra soft link to /usr/bin. If you don't have sudo rights, install locally and add the local binary to the path. 

> ./configure --prefix=/usr/local/
> make
> sudo make install
> sudo ln -s /usr/local/bin/bcftools /usr/bin/bcftools

Verify the version is correct by running: 
> `bcftools`

### Burrows-Wheeler Aligner (BWA; 07.12)

BWA requires only that you run 'make' and make the resulting binary file available. The simplest way to accomplish this is to make a soft link to it in /usr/bin.
>make
>sudo ln -s ~/.local/packages/bwa-0.7.12/bwa /usr/bin/bwa

Verify the version is correct by running: 
> `bwa`

### Popoolation2 (1.201)

Use svn to get the package and then move it to the desired directory. If it isn't already installed, you'll need to install it before running the commands below. 
> svn checkout http://popoolation2.googlecode.com/svn/trunk/ popoolation2
> sudo mv popoolation2 /usr/local/bin/popoolation2_1201

### BBMap (37.93)
Download the specific version then move it to the local/bin directory
> sudo mv bbmap /usr/local/bin

Verify the version is correct by checking the readme file in the bbmap directory

### Java 8u66
Installing the correct version of Java was the most laborious part of the process. Download the specific version from the directory
> sudo mkdir -p /usr/local/java

> sudo mv jdk1.8.0_66 /usr/local/java/

> sudo update-alternatives --install /usr/bin/java java /usr/local/java/jdk1.8.0_66/bin/java 1

> sudo update-alternatives --install /usr/bin/javac javac /usr/local/java/jdk1.8.0_66/bin/javac 1

> sudo update-alternatives --config java

a. This command will list all installed versions of Java, select the one with the proper jdk (jdk1.8.0)
> sudo update-alternatives --config javac
a. Similar to above

Verify the version is correct by running:
> java -version
> javac -version

### Gradle

Note: This requires a few things to be installed in addition to the correct Java version above including curl, sdk (or brew),
> sudo apt install curl

> curl -s "https://get.sdkman.io" | bash

> sdk install gradle 8.9

### Picard Tools (2.17.11)

Very specific with what it needs to build properly:
* Gradle requires the environment variable JAVA_HOME be set to the correct java version we installed earlier (add this to your .bashrc so it doesn’t have to be run again):
  > export JAVA_HOME=/usr/local/java/jdk1.8.0_66/ 
  > export PATH=$JAVA_HOME/bin:$PATH
* The picard tools directory needs to have git initialized. This is not an issue if you used `git clone` to download the repo, however downloaded directly, the following command needs to be run:
  > git init
  
In the directory where picard is installed, run the following commands to create the picard jar file:
> ./gradlew shadowJar
> java -jar build/libs/picard.jar

The jar file is what is used by poolparty, so you can either link to this file directly in your config, or create softlink to a common location and link there:
> ln -s ~/.local/packages/picard-2.17.11/build/libs/picard.jar /usr/local/bin/picard.jar

### Fastqc (0.11.7)

One of the more straightforward packages. Download and move it somewhere permanent, then run the following commands from within it:
> chmod +x ./fastqc
> sudo ln -s ~/.local/packages/FastQC/fastqc /usr/bin/fastqc

## Poolparty Repository

To properly install the repo, a few additional steps and adjustments to the [provided instructions](https://github.com/StevenMicheletti/poolparty/?tab=readme-ov-file#installing-and-running-the-pipeline) were required. For example, moving the repo to the /usr/local/bin directory may necessitate sudo rights in order to conduct any operations or changes to the repo's files. The procedures below move it to a local directory and use softlinks to replicate the same arrangement, but it may be relocated anywhere. 

> git clone https://github.com/StevenMicheletti/poolparty/

> mkdir ~/applications

> mv poolparty ~/applications/poolparty

The commands that will be run inside the poolparty repo will need to be made executable:
> chmod +x ~/applications/poolparty/*.sh

Softlinks should now be created to the repo and the three primary scripts that are used. The following commands utilize sudo, although you can omit it if permissions are not an issue. 
>sudo ln -s ~/applications/poolparty /usr/local/bin/poolparty

> sudo ln -s /usr/local/bin/poolparty/PPalign.sh /usr/local/bin/PPalign

> sudo ln -s /usr/local/bin/poolparty/PPanalyze.sh /usr/local/bin/PPanalyze

> sudo ln -s /usr/local/bin/poolparty/PPstats.sh /usr/local/bin/PPstats

# General Notes

* The directories listed in the various config files are not set up to run immediately and will need to be changed to point to where the packages actually exist on the local machine.
* Make sure that R and its packages are current by running the command below. Note: this might take some time to complete
  > update.packages(ask = FALSE)

# Running the Example 

Even if it doesn't work perfectly, reference the [examples PDF](https://github.com/StevenMicheletti/poolparty/blob/master/example/pool_party_example.pdf) when attempting to execute the instructions listed below. For example, the genome preparation code is slightly different, therefore I would execute these instead of the prep_genome.sh file. 
> bwa index -a bwtsw PP_genome.fa

> samtools faidx PP_genome.fa

> java -jar /usr/local/bin/picard.jar CreateSequenceDictionary REFERENCE= PP_genome.fa OUTPUT= PP_genome.fa.dict

Below is the status on the functionality of each script:
  * PPAlign - Works on Ubuntu 23 - Desktop + virtual machine
  * PPAnalyze - Works on virtual machine (maybe desktop)
  * PPStats - Doesnt work anywhere

## PPAlign

The pp_align config file requires the output directory to already exist; otherwise, it fails. So, either create the directory first or set it to one that already exists.
> mkdir ~/applications/poolparty/example/phenoAB_out

And then set OUTDIR in pp_align.config as the following
> OUTDIR=~/applications/poolparty/example/phenoAB_out/

The provided output directory must terminate with a slash; otherwise, the script will fail due to path-munging difficulties. Run it as follows:
> PPalign pp_align.config

## PPAnalyze

Requires specific R packages to be installed, so here is the combination of commands that got it to run.

From within an R terminal:
> update.packages(ask = FALSE)

> sudo apt-get update

> sudo apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev libfftw3-dev

Run with:
> PPanalyze pp_analyze.config

### R Packages

Certain R packages require the installation of lower-level libraries, which may not already be installed. To install them, use the following commands:
> sudo apt-get update

> sudo apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev libfftw3-dev

Several packages are known to have troubles with installation.
To update all installed packages to their most recent versions, or rebuild them if you updated R, use the following commands: 
> sudo chmod -R +777 /usr/lib/R

a. Not a command to run in the final version but this is what worked for now to get through permission issues in the directory preventing an update

> Rscript -e 'update.packages(ask = FALSE, checkBuilt = TRUE)'

> Rscript -e 'if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("multtest")'

## PPStats
PPstats seems to require some additional packages
> Rscript -e 'install.packages("sparseMatrixStats", repos = "http://cran.us.r-project.org")'

PPstats runs several commands before failing at the final plotting script. After running it once, use the following command to just run the plotting script:

> Rscript ~/poolparty/rscripts/r_plotstats.R /usr/local/bin/poolparty/example/phenoAB_out/stats/PP_stats.txt /usr/local/bin/poolparty/example/phenoAB_out/stats

colMaxs does not appear to work in the way it was written. It can be resolved by turning all provided columns to matrices and running them. This was done manually for all calls to colMaxs, including the following example:

    #Check if the variable is a vector and not a matrix
    if (is.vector(tma$Mean_Coverage) && !is.matrix(tma$Mean_Coverage)) {
    #Convert vector to a column matrix (n rows, 1 column)
    tma_mean_coverage  <- matrix(tma$Mean_Coverage, ncol = 1)
    tma_stdev <- matrix(tma$Stdev, ncol = 1)
    } else {
	     # Otherwise do nothing
    tma_mean_coverage  <- tma$Mean_Coverage
    tma_stdev <- tma$Stdev
    }

    #Pass the matrix into colMaxs and colMins
    scalehigh <- colMaxs(tma_mean_coverage) + colMaxs(tma_stdev)
    scalelow <- colMins(tma_mean_coverage) - colMaxs(tma_stdev)

  Run with the following, and once complete, consult the PDF to see which files should have been outputted:
  PPstats pp_stats.config

