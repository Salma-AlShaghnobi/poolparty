#!/bin/bash

# Set the script directory to the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Set the packages directory to the relative path from the script
packages_dir=$script_dir/../packages

# Define the filename for the repository key
key_file="marutter_pubkey.asc"
# Define the filename for the R base package list
repo_file="cran.list"

# Full path to the key file
key_path="$packages_dir/$key_file"

# Function to install R and the required packages
install_r_and_packages() {
    # Check if the system version of R is installed
    if command -v R &> /dev/null; then
        echo "R is already installed."
    else
        echo "R is not installed. Proceeding with the installation."

        # First, ensure the Ubuntu version is supported
        lsb_release -a

        # Install the R public key if not already installed
        if [[ ! -f /usr/share/keyrings/cran.gpg ]]; then
            echo "Installing the R public key..."
            sudo wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/cran.gpg
        fi

        # Add the CRAN repository for Jammy
        if [[ ! -f /etc/apt/sources.list.d/cran.list ]]; then
            echo "Adding the CRAN repository for Jammy..."
            echo "deb [signed-by=/usr/share/keyrings/cran.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee /etc/apt/sources.list.d/cran.list
        fi

        # Update and install R
        sudo apt update
        sudo apt install -y r-base

        echo "R installation completed."
    fi

    # Install necessary libraries for R packages
    echo "Installing required dependencies for R packages..."
    sudo apt install -y build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev libfftw3-dev

    sudo chmod -R 777 /usr/local/lib/R

    # Update R packages
    echo "Updating R packages..."
    Rscript -e 'update.packages(ask = FALSE, checkBuilt = TRUE)'

    # Install BiocManager and multtest if necessary for PPanalyze
    echo "Installing BiocManager, sparseMatrixStatas, and multtest..."
    Rscript -e 'if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("multtest"); BiocManager::install("sparseMatrixStats")'

    echo "R and package installations are complete."
}

# Run the installation function
install_r_and_packages
