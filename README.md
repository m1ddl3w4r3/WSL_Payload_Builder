# WSL Payload Builder

A powerful shell script for creating custom WSL (Windows Subsystem for Linux) distributions with embedded payloads. This tool automates the process of building Alpine Linux-based WSL distributions that can execute custom payloads upon launch.

## Overview

The `Build_WSL_Payload.sh` script downloads the latest Alpine Linux rootfs, customizes it for WSL use, embeds a user-specified payload executable, and packages everything into a distributable `.wsl` file. This is particularly useful for penetration testing, security research, and custom WSL environment creation.

## Features

- **Automatic Alpine Linux Detection**: Finds and downloads the latest available Alpine Linux version
- **Custom Distribution Naming**: Specify custom names for your WSL distribution
- **Payload Integration**: Embed any executable payload that runs on Alpine Linux
- **WSL Configuration**: Automatically configures WSL-specific settings
- **Root Shell Customization**: Modifies the root user's shell to execute your payload
- **Clean Packaging**: Creates a single `.wsl` file ready for distribution

## Usage

### Basic Syntax

```bash
./Build_WSL_Payload.sh [-N|--name] <distribution_name> [-P|--payload] <payload_file>
```

### Required Arguments

- **`-N, --name`**: Specify the default distribution name for WSL
- **`-P, --payload`**: Specify the path to the payload executable file

### Optional Arguments

- **`-H, --help`**: Display the help menu

### Examples

```bash
# Build a WSL distribution named "TestWSL" with a custom payload
./Build_WSL_Payload.sh -N TestWSL -P /path/to/my_payload.exe

# Using long-form arguments
./Build_WSL_Payload.sh --name CalcWSL --payload /path/to/calculator.exe

# Show help menu
./Build_WSL_Payload.sh --help
```

## Security Considerations

- **Payload Execution**: The embedded payload runs with root privileges when the WSL distribution is launched
- **File Permissions**: All executable files are properly set with appropriate permissions
- **Isolation**: The generated WSL distribution is isolated from the host system
- **Validation**: The script validates that the specified payload file exists before proceeding

## License

MIT License

Copyright (c) 2024 WSL-Payloads

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Disclaimer

This tool is intended for legitimate security research and penetration testing. Users are responsible for ensuring they have proper authorization before testing systems they do not own or have explicit permission to test.

## References

This project was inspired by and builds upon the research and techniques documented in the [dmcxblue/WSL-Payloads](https://github.com/dmcxblue/WSL-Payloads) repository, which provides valuable insights into WSL file format weaponization and security research.
