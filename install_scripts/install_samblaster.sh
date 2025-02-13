#!/bin/bash

# Set the script directory to the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Set the packages directory to the relative path from the script
packages_dir=$script_dir/../packages

# Define the filename of the archive to be extracted
archive_file="samblaster-v.0.1.24.zip"

# Full path to the archive file
archive_path="$packages_dir/$archive_file"

# First, try to install samblaster using apt
if command -v samblaster &> /dev/null; then
    echo "samblaster is already installed."
    exit 0
fi

# Check if the archive file exists
if [[ -f "$archive_path" ]]; then
    echo "Found $archive_file. Extracting..."

    # Extract the zip file using unzip
    unzip "$archive_path" -d "$packages_dir"

    # Extracted directory name based on the package
    extracted_dir="$packages_dir/samblaster-v.0.1.24"

    # Check if the extracted directory exists
    if [[ -d "$extracted_dir" ]]; then
    
        trap 'rm -rf "$extracted_dir"' EXIT
        echo "Successfully extracted $archive_file to $extracted_dir"

        # Change into the extracted directory
        cd "$extracted_dir"

        # Now, assuming there's no configure script, we'll directly attempt to build with make
        echo "Running make..."
        make

        if [[ $? -eq 0 ]]; then
            echo "Build successful."

            
            sudo mv $extracted_dir/samblaster /usr/bin/samblaster
            

            echo "Installation complete."
        else
            echo "Error: Make failed."
            exit 1
        fi
    else
        echo "Error: Extracted directory '$extracted_dir' does not exist."
        exit 1
    fi
else
    echo "Error: File '$archive_file' not found in '$packages_dir'."
    exit 1
fi
