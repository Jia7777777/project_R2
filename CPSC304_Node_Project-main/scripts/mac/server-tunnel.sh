#!/bin/bash

# Take input from the user
read -p "Enter your remote Node starting port number: " destination_port

# Define a range
START=55001
END=60000

# Check if the provided port is free
if ! lsof -Pi :$destination_port -sTCP:LISTEN -t >/dev/null ; then
    echo "Local port $destination_port is available."
    chosen_port=$destination_port
else
    # If not free, find a port in the range 50000-60000
    for port in $(seq $START $END); do
        if ! lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
            echo "Local port $port is available."
            chosen_port=$port
            break
        fi
    done
fi

# No port is found in the range
if [[ -z "$chosen_port" ]]; then
    echo "No free port found in range $START-$END."
    exit 1
fi

echo "--------------------------------------------------------------------------"
echo "        You will be able to access your application at: "
echo "        http://localhost:$chosen_port"
echo "        after completing the steps below..."
echo "--------------------------------------------------------------------------"


echo "Building SSH tunnel using port $chosen_port..."

read -p "Enter your CWL name: " cwl_name

# Build the SSH tunnel
exec ssh -L $chosen_port:localhost:$destination_port $cwl_name@remote.students.cs.ubc.ca