#!/bin/bash

# Set the script directory to the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Set the packages directory to the relative path from the script
packages_dir=$script_dir/../packages

# Define the filename of the archive to be extracted
archive_file="bwa-0.7.12.tar.bz2"

# Full path to the archive file
archive_path="$packages_dir/$archive_file"

# First, try to install bwa using apt
if command -v bwa &> /dev/null; then
    echo "bwa is already installed."
    exit 0
fi

# Check if the archive file exists
if [[ -f "$archive_path" ]]; then
    echo "Found $archive_file. Extracting..."

    # Extract the file using the correct extractor (tar with bz2 compression)
    tar -xjf "$archive_path" -C "$packages_dir"

    # Extracted directory name based on the package
    extracted_dir="$packages_dir/bwa-0.7.12"

    # Check if the extracted directory exists
    if [[ -d "$extracted_dir" ]]; then
        trap 'rm -rf "$extracted_dir"' EXIT
        echo "Successfully extracted $archive_file to $extracted_dir"

        # Change into the extracted directory
        cd "$extracted_dir"

        # Run the compilation
        echo "Running make..."
        make

        # Manually copy the binary to /usr/local/bin/
        echo "Copying bwa binary to /usr/local/bin/"
        sudo cp bwa /usr/local/bin/

        # Create symlink for bwa
        echo "Creating symlink for bwa..."
        sudo ln -s /usr/local/bin/bwa /usr/bin/bwa

        echo "Installation complete."
    else
        echo "Error: Extracted directory '$extracted_dir' does not exist."
        exit 1
    fi
else
    echo "Error: File '$archive_file' not found in '$packages_dir'."
    exit 1
fi
