#!/bin/bash

# Change to the directory where the script is located
cd "$(dirname "$0")"

# File path
ENV_FILE_PATH="../../.env"

# Define a range
START=50000
END=55000

# Variables to track if ORACLE_HOST and ORACLE_PORT are found
found_host=0
found_port=0

# Check if ORACLE_HOST and ORACLE_PORT variables exist in the .env file
if grep -q '^ORACLE_HOST=' $ENV_FILE_PATH; then
    found_host=1
fi
if grep -q '^ORACLE_PORT=' $ENV_FILE_PATH; then
    found_port=1
fi

# Check if ORACLE_HOST and ORACLE_PORT were found, if not, exit 1
if [[ $found_host -eq 0 ]] || [[ $found_port -eq 0 ]]; then
    echo "ERROR: ORACLE_HOST or ORACLE_PORT not found in the .env file."
    exit 1
fi

# Loop through the range and check if the port is in use
for port in $(seq $START $END); do
    # Use lsof to check if the port is in use
    if ! lsof -i :$port > /dev/null; then
        perl -i -pe "s/^ORACLE_HOST=.*/ORACLE_HOST=localhost/" $ENV_FILE_PATH
        perl -i -pe "s/^ORACLE_PORT=.*/ORACLE_PORT=$port/" $ENV_FILE_PATH
        chosen_port=$port
        break
    fi
done

if [[ -z "$chosen_port" ]]; then
    echo "No free port found in range 50000-60000."
    exit 1
fi

echo "Building SSH tunnel on port $chosen_port to your oracle database..."

read -p "Enter your CWL name: " cwl_name

exec ssh -L $chosen_port:dbhost.students.cs.ubc.ca:1522 $cwl_name@remote.students.cs.ubc.ca


