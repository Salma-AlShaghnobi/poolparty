#!/bin/bash

# Set the script directory to the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Set the packages directory to the relative path from the script
packages_dir=$script_dir/../packages

# Define the filename of the tar file to be downloaded
tar_file="BBMap_37.93.tar.gz"

# Full URL for downloading the tar file
tar_url="https://sourceforge.net/projects/bbmap/files/BBMap_37.93.tar.gz/download"

# Full path to the tar file
tar_path="$packages_dir/$tar_file"

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "wget is not installed. Installing wget..."
    sudo apt-get update
    sudo apt-get install -y wget
fi

# Check if the bbmap directory already exists in /usr/local/bin
if [ -d "/usr/local/bin/bbmap" ]; then
    echo "BBMap is already installed."
    exit 0
fi

# Download the tar file if it doesn't already exist
if [[ ! -f "$tar_path" ]]; then
    echo "Downloading $tar_file from $tar_url..."
    wget -O "$tar_path" "$tar_url" || { echo "Failed to download $tar_file"; exit 1; }
else
    echo "$tar_file already exists. Skipping download."
fi

# Extract the tar file
echo "Extracting $tar_file..."
tar -xzf "$tar_path" -C "$packages_dir"

# Check if the extracted directory exists
extracted_dir="$packages_dir/bbmap"
if [[ -d "$extracted_dir" ]]; then
    echo "Successfully extracted $tar_file to $extracted_dir"
else
    echo "Error: Extracted directory '$extracted_dir' does not exist."
    exit 1
fi

# Move the extracted bbmap directory to /usr/local/bin
echo "Moving bbmap to /usr/local/bin..."
sudo mv "$extracted_dir" /usr/local/bin/bbmap || { echo "Failed to move bbmap."; exit 1; }

# Confirm installation is complete
echo "Installation complete. BBMap has been installed to /usr/local/bin/bbmap."
