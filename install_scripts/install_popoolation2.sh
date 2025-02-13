#!/bin/bash

# Set the script directory to the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Set the packages directory to the relative path from the script
packages_dir=$script_dir/../packages

# Define the filename of the zip file to be extracted
zip_file="popoolation2_1201.zip"

# Full path to the zip file
zip_path="$packages_dir/$zip_file"


# Check if the zip file exists
if [[ -f "$zip_path" ]]; then
    echo "Found $zip_file. Extracting..."

    # Extract the zip file
    unzip "$zip_path" -d "$packages_dir"

    # Check if the extracted directory exists
    extracted_dir="$packages_dir/popoolation2_1201"
    
    if [[ -d "$extracted_dir" ]]; then
        echo "Successfully extracted $zip_file to $extracted_dir"
    else
        echo "Error: Extracted directory '$extracted_dir' does not exist."
        exit 1
    fi
else
    echo "Error: File '$zip_file' not found in '$packages_dir'."
    exit 1
fi


# Move the extracted popoolation2 directory to the desired location
echo "Moving popoolation2 to /usr/local/bin/popoolation2_1201..."
sudo mv "$packages_dir/popoolation2_1201" /usr/local/bin/popoolation2_1201 || { echo "Failed to move popoolation2."; exit 1; }

# Confirm installation is complete
echo "Installation complete. popoolation2_1201 has been installed to /usr/local/bin/popoolation2_1201."

