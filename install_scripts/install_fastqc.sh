#!/bin/bash

# Set the script directory to the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Set the packages directory to the relative path from the script
packages_dir=$script_dir/../packages

# Define the filename of the archive to be extracted
archive_file="fastqc_v0.11.7.zip"

# Full path to the archive file
archive_path="$packages_dir/$archive_file"

# First, try to install fastqc using apt
if command -v fastqc &> /dev/null; then
    echo "fastqc is already installed."
    exit 0
fi

# Check if the archive file exists
if [[ -f "$archive_path" ]]; then
    echo "Found $archive_file. Extracting..."

    # Create the FastQC directory if it doesn't exist
    fastqc_dir="$packages_dir/FastQC"

    # Extract the ZIP archive to the FastQC directory
    unzip "$archive_path" -d "$packages_dir"

    # Check if the extracted directory contains the fastqc executable
    if [[ -f "$fastqc_dir/fastqc" ]]; then

        echo "Successfully extracted $archive_file to $fastqc_dir"

        # Make the fastqc file executable
        chmod +x "$fastqc_dir/fastqc"

        # Create a symlink for fastqc in /usr/bin
        sudo ln -s "$fastqc_dir/fastqc" /usr/local/bin/fastqc

        echo "Installation complete. fastqc is now available."
    else
        echo "Error: fastqc executable not found in '$fastqc_dir'."
        exit 1
    fi
else
    echo "Error: File '$archive_file' not found in '$packages_dir'."
    exit 1
fi
