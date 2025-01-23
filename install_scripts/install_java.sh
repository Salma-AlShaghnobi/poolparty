#!/bin/bash

# Set the script directory to the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Set the packages directory to the relative path from the script
packages_dir=$script_dir/../packages

# Define the filename of the archive to be extracted
archive_file="server-jre-8u66-linux-x64.tar.gz"

# Full path to the archive file
archive_path="$packages_dir/$archive_file"

# # First, try to install samtools using apt
# if command -v samtools &> /dev/null; then
#     echo "samtools is already installed."
#     exit 0
# fi

# Check if the archive file exists
if [[ -f "$archive_path" ]]; then
    echo "Found $archive_file. Extracting..."

    # Extract the file using the correct extractor (tar with bz2 compression)
    tar -xzf "$archive_path" -C "$packages_dir"
   
    # Extracted directory name based on the package
    name="jdk1.8.0_66"
    extracted_dir="$packages_dir/$name"
    

    # Check if the extracted directory exists
    if [[ -d "$extracted_dir" ]]; then
    
        trap 'rm -rf "$extracted_dir"' EXIT
        echo "Successfully extracted $archive_file to $extracted_dir"
        local_java_dir="/usr/local/java"
        sudo mkdir -p $local_java_dir
        sudo mv -n $extracted_dir $local_java_dir
        
        sudo update-alternatives --install /usr/bin/java java $local_java_dir/$name/bin/java 1
        sudo update-alternatives --install /usr/bin/javac javac $local_java_dir/$name/bin/javac 1
        #sudo update-alternatives --config java
    
    else
        echo "Error: Extracted directory '$extracted_dir' does not exist."
        exit 1
    fi
else
    echo "Error: File '$archive_file' not found in '$packages_dir'."
    exit 1
fi

