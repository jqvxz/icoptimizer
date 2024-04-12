@echo off
title IC - Optimizer setup
if exist .main/.v3.4 (
    echo [*] ^> Files are already installed (removing...)
    echo [*] ^> Press any key to start
    rmdir /s /q .main >nul 2>&1
    pause >nul
    echo.
)
mkdir .main
cd .main
mkdir header
mkdir info
mkdir addons

cd header
curl -L https://github.com/jqvxz/icoptimizer/raw/main/header.txt > header.txt
curl -L https://github.com/jqvxz/icoptimizer/raw/main/jqvon.txt > jqvon.txt
cd ..

cd addons
curl -L https://github.com/jqvxz/icoptimizer/raw/main/driverfix.bat > driverfix.bat
curl -L https://github.com/jqvxz/icoptimizer/raw/main/sysfix.bat > sysfix.bat
cd ..

curl -L https://github.com/jqvxz/icoptimizer/raw/main/start.bat > start.bat
curl -L https://github.com/jqvxz/icoptimizer/raw/main/clear.bat > clear.bat
curl -L https://github.com/jqvxz/icoptimizer/raw/main/.help.txt > .help.txt
curl -L https://github.com/jqvxz/icoptimizer/raw/main/.v3.4 > .v3.4

echo.
cd .main
echo [*] ^> Files installed successfully
start .
exit