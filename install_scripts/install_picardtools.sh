#!/bin/bash

# Set the script directory to the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Set the packages directory to the relative path from the script
packages_dir=$script_dir/../packages

# Define the filename of the Picard zip file
picard_zip="picard-2.17.11.zip"

# Full path to the Picard zip file
picard_zip_path="$packages_dir/$picard_zip"

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Installing curl..."
    sudo apt update
    sudo apt install -y curl
fi

# Check if sdkman is installed, if not, install sdkman and Gradle
if ! command -v sdk &> /dev/null; then
    #echo "sdkman is not installed. Installing sdkman..."
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    #source "/home/user/.sdkman/bin/sdkman-init.sh"
    sdk install gradle 3.1
    #used to be 8.9
   export GRADLE_HOME=$HOME/.sdkman/candidates/gradle/current/bin/gradle
   export PATH=$GRADLE_HOME/bin:$PATH
fi

# Set JAVA_HOME environment variable if it's not already set
if ! grep -q "export JAVA_HOME" ~/.bashrc; then
    echo "Setting JAVA_HOME environment variable in ~/.bashrc"
    echo "export JAVA_HOME=/usr/local/java/jdk1.8.0_66/" >> ~/.bashrc
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
    source ~/.bashrc
fi

# Check if Picard is already installed
if [ -f "/usr/local/bin/picard.jar" ]; then
    echo "Picard is already installed."
else
    git clone https://github.com/broadinstitute/picard.git 
    cd picard
    git fetch --tags
    git checkout tags/2.17.11
    gradle shadowJar
    chmod +x $script_dir/picard/build/libs/picard.jar
    sudo ln -sf $script_dir/picard/build/libs/picard.jar /usr/local/bin/picard.jar
fi

# Confirm installation
echo "Installation complete. Picard is available at /usr/local/bin/picard.jar"
