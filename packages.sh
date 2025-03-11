#!/bin/bash

# Define the release URL and the file to be downloaded
url="https://github.com/Salma-AlShaghnobi/poolparty/releases/download/v0.0.0/packages.rar"
# Downloads to the same directory the script lives in
download_dir=$(dirname "$(realpath "$0")") 
downloaded_file="$download_dir/packages.rar"

# Create the Downloads directory if it doesn't exist
mkdir -p "$download_dir"

# Print the download URL for debugging
echo "Attempting to download from: $url"

# Download the file using wget and display verbose output to debug if necessary
wget --verbose "$url" -O "$downloaded_file"

# Check if the download was successful
if [ $? -eq 0 ]; then
	echo "Download completed successfully."
	echo "File saved to: $downloaded_file"
else
	echo "Download failed."
	exit 1
fi

# Verify the file exists after download
if [ ! -f "$downloaded_file" ]; then
	echo "Error: The downloaded file does not exist at $downloaded_file"
	exit 1
fi

# Check if 'unrar' is installed, install if necessary
if ! command -v unrar &> /dev/null; then
	echo "'unrar' not found. Installing it now..."
	sudo apt-get update
	sudo apt-get install -y unrar
fi

# Extract the .rar file using unrar
echo "Extracting the packages.rar file..."
unrar x "$downloaded_file" "$download_dir/"

# Check if extraction was successful
if [ $? -eq 0 ]; then
	echo "Extraction completed successfully."
else
	echo "Extraction failed."
	exit 1
fi
