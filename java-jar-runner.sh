#!/bin/bash
# =============================================================================
# Generic JAR File Launcher
# =============================================================================
# This script launches Java JAR files from their own directory, ensuring that
# relative paths within the JAR work correctly.
#
# When you double-click a JAR file in Nemo, the %f placeholder in the .desktop
# file gets replaced with the full path to the JAR, and that path is passed as
# $1 to this script.
#
# Example: If you double-click /path/to/myapp/MyApp.jar
#          This script receives: $1 = "/path/to/myapp/MyApp.jar"
# =============================================================================

# Check if a JAR file path was provided as the first argument
if [ -z "$1" ]; then
    echo "Usage: $0 <jar-file>"
    exit 1
fi

# $1 contains the full path passed by the desktop file's %f placeholder
# Example: /storage/develop/opensourcephysics/EJS/EjsConsole.jar
JAR_FILE="$1"

# Extract the directory path from the full JAR file path
# dirname extracts: /storage/develop/opensourcephysics/EJS
JAR_DIR="$(dirname "$JAR_FILE")"

# Change to the JAR's directory so relative paths work correctly
# The || exit 1 means: if cd fails, exit with error code 1
cd "$JAR_DIR" || exit 1

# Run Java with just the JAR filename (not the full path)
# basename extracts: EjsConsole.jar
# "${@:2}" passes any additional arguments (starting from argument 2)
java -jar "$(basename "$JAR_FILE")" "${@:2}"
