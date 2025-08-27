#!/bin/sh

# Function to display help menu
show_help() {
    echo ""
    echo "Usage: $0 [-N|--name] <distribution_name> [-P|--payload] <payload_file>"
    echo ""
    echo "Options:"
    echo "  -N, --name    Specify the default distribution name for WSL"
    echo "  -P, --payload Specify the payload executable file path"
    echo "  -H, --help    Show this help message"
    echo ""
    exit 1
}

# Parse command line arguments
DISTRIBUTION_NAME=""
PAYLOAD_FILE=""
while [ $# -gt 0 ]; do
    case "$1" in
        -N|--name)
            if [ -n "$2" ] && [ "${2#-}" = "$2" ]; then
                DISTRIBUTION_NAME="$2"
                shift 2
            else
                echo "Error: -N/--name requires a distribution name"
                show_help
            fi
            ;;
        -P|--payload)
            if [ -n "$2" ] && [ "${2#-}" = "$2" ]; then
                PAYLOAD_FILE="$2"
                shift 2
            else
                echo "Error: -P/--payload requires a file path"
                show_help
            fi
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# Check if distribution name was provided
if [ -z "$DISTRIBUTION_NAME" ]; then
    echo "Error: No distribution name specified"
    show_help
fi

# Check if payload file was provided
if [ -z "$PAYLOAD_FILE" ]; then
    echo "Error: No payload file specified"
    show_help
fi

# Check if payload file exists
if [ ! -f "$PAYLOAD_FILE" ]; then
    echo "Error: Payload file '$PAYLOAD_FILE' does not exist"
    exit 1
fi

# Function to find the latest available Alpine Linux version
find_latest_alpine_version() {
    local major=3
    local minor=22
    local patch=1
    local max_attempts=3  # Prevent infinite loops
    
    echo "Searching for latest Alpine Linux version..." >&2
    
    for attempt in $(seq 1 $max_attempts); do
        local version="${major}.${minor}.${patch}"
        local url="https://dl-cdn.alpinelinux.org/alpine/v${major}.${minor}/releases/x86_64/alpine-minirootfs-${version}-x86_64.tar.gz"
        
        echo "Checking version ${version}..." >&2
        
        # Check if URL exists (returns 0 if exists, 1 if 404)
        if wget --spider --quiet "$url"; then
            echo "Found valid version: ${version}" >&2
            echo "$url"
            return 0
        else
            echo "Version ${version} not found (404), trying next version..." >&2
            # Increment patch version
            patch=$((patch + 1))
        fi
    done
    
    echo "Error: Could not find a valid Alpine Linux version after ${max_attempts} attempts" >&2
    return 1
}

# download the latest version of alpine linux
ALPINE_URL=$(find_latest_alpine_version)
if [ $? -eq 0 ]; then
    echo "Downloading Alpine Linux from: $ALPINE_URL"
    wget "$ALPINE_URL" -O /tmp/alpine.tar.gz
else
    echo "Failed to find valid Alpine Linux version. Exiting."
    exit 1
fi

# Create extraction directory
mkdir -p /tmp/alpine

# extract the tar.gz file
tar -xzf /tmp/alpine.tar.gz -C /tmp/alpine
echo "Extracted Alpine Linux to /tmp/alpine/"


# Create wsl-distribution.conf file
echo "Creating WSL distribution configuration..."
mkdir -p /tmp/alpine/etc
cat > /tmp/alpine/etc/wsl-distribution.conf << EOF
[oobe]
defaultName = ${DISTRIBUTION_NAME}
EOF

echo "Created /tmp/alpine/etc/wsl-distribution.conf with distribution name: ${DISTRIBUTION_NAME}"
echo "Configuration file contents:"
cat /tmp/alpine/etc/wsl-distribution.conf

# Modify the passwd file to change root shell to launch.sh
echo "Modifying /etc/passwd file..."
sed -i '1s|^root:.*|root:x:0:0:root:/root:/root/launch.sh|' /tmp/alpine/etc/passwd

echo "Updated /etc/passwd file."

# Create the launch.sh script
echo "Creating /root/launch.sh script..."
mkdir -p /tmp/alpine/root

# Get just the filename from the payload path
PAYLOAD_FILENAME=$(basename "$PAYLOAD_FILE")

cat > /tmp/alpine/root/launch.sh << EOF
#!/bin/sh
exec /root/${PAYLOAD_FILENAME}
exit 0
EOF

# Make the launch.sh script executable
chmod +x /tmp/alpine/root/launch.sh

# Copy the payload file to /tmp/alpine/root/
echo "Copying payload file to /root/${PAYLOAD_FILENAME}..."
cp "$PAYLOAD_FILE" "/tmp/alpine/root/${PAYLOAD_FILENAME}"
chmod +x "/tmp/alpine/root/${PAYLOAD_FILENAME}"
# make the payload file executable
chmod +x /tmp/alpine/root/launch.sh
echo "Created /root/launch.sh and copied payload file ${PAYLOAD_FILENAME}"

# create the tar file
tar --numeric-owner -cf Alpine.tar -C /tmp/alpine/ .

# remove the temporary directory
rm -rf /tmp/alpine

#rename the tar file to the distribution name
mv Alpine.tar ${DISTRIBUTION_NAME}.wsl

# print the tar file size
echo "Tar file size: $(du -sh ${DISTRIBUTION_NAME}.wsl)"

# print finish statement
echo "Finished creating ${DISTRIBUTION_NAME}.wsl"
exit 0