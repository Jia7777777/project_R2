#!/bin/bash

# Change to the directory where the script is located
cd "$(dirname "$0")"

echo "Please enter the absolute path to the Oracle Instant Client directory:"
read oraclePath

# Construct the local start script
(
echo '#!/bin/bash'
echo
echo '# Change to the directory where the script is located'
echo 'cd "$(dirname "$0")"'
echo
echo "# Configure the oracle instant client env variable"
echo "export DYLD_LIBRARY_PATH=$oraclePath:\$DYLD_LIBRARY_PATH"
echo
echo "# Start Node application"
echo "exec node server.js"
) > ../../local-start.sh

# Change the permissions of the script to make it executable
chmod +x ../../local-start.sh
echo "--------------------------------------------------------------------------"
echo "Setup complete. Run 'sh local-start.sh' in your project folder to start your Node.js application."
echo "--------------------------------------------------------------------------"

exit 0
