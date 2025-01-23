#!/bin/bash

# Set the script directory to the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Set the packages directory to the relative path from the script
packages_dir=$script_dir/../packages

# Define the filename of the archive to be extracted
archive_file="samtools-1.5.tar.bz2"

# Full path to the archive file
archive_path="$packages_dir/$archive_file"

# First, try to install samtools using apt
if command -v samtools &> /dev/null; then
    echo "samtools is already installed."
    exit 0
fi

# Check if the archive file exists
if [[ -f "$archive_path" ]]; then
    echo "Found $archive_file. Extracting..."

    # Extract the file using the correct extractor (tar with bz2 compression)
    tar -xjf "$archive_path" -C "$packages_dir"

    # Extracted directory name based on the package
    extracted_dir="$packages_dir/samtools-1.5"

    # Check if the extracted directory exists
    if [[ -d "$extracted_dir" ]]; then
    
        trap 'rm -rf "$extracted_dir"' EXIT
        echo "Successfully extracted $archive_file to $extracted_dir"

        # Change into the extracted directory
        cd "$extracted_dir" 



        # Run the configuration, make, and installation steps
        echo "Running ./configure..."
        ./configure --prefix=/usr/local/

        echo "Running make..."
        make

        echo "Running sudo make install..."
        sudo make install

        echo "Creating symlink for samtools..."
        sudo ln -sf /usr/local/bin/samtools /usr/bin/samtools

        echo "Installation complete."
    else
        echo "Error: Extracted directory '$extracted_dir' does not exist."
        exit 1
    fi
else
    echo "Error: File '$archive_file' not found in '$packages_dir'."
    exit 1
fi

