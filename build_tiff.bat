@ECHO OFF
REM
REM build_tiff.bat
REM
REM Compile and install tiff
REM
REM Version 1.0, 23.11.2016

REM Save path to this script
SET SB_SCRIPT_PATH=%~dp0

REM Get paths and variables
CALL set_paths.bat
CALL set_vars.bat
CALL libs_versions.bat

REM Check distributable file is present
IF NOT EXIST %SB_DOWNLOAD_PATH%\%SB_TIFF_FILENAME% (
	ECHO File %SB_TIFF_FILENAME% not found. Please download it and put it into the download folder %SB_DOWNLOAD_PATH%.
	pause
	EXIT /B 1
)

REM Set Visual Studio environment
CALL %SB_VSTUDIO_PATH%\vcvarsall.bat %SB_VSTUDIO_ARCHITECTURE%

REM Set path
SET PATH=%PATH%;%SB_CMAKE_PATH%;%SB_NINJA_PATH%;%SB_MSYS2_PATH%

REM Convert download path into MSYS path
SET "SB_DOWNLOAD_PATH_FWD=%SB_DOWNLOAD_PATH:\=/%"
SET "SB_DOWNLOAD_PATH_FWD2=%SB_DOWNLOAD_PATH_FWD::=%"
SET SB_DOWNLOAD_PATH_MSYS=/%SB_DOWNLOAD_PATH_FWD2%"

REM Delete source directory
CD %SB_SOURCE_PATH%
CALL %SB_UTIL_SCRIPTS_PATH%\fast_rmdir.bat %SB_TIFF_PATH%
IF ERRORLEVEL 1 GOTO error_exit

REM Extract source
tar -xf %SB_DOWNLOAD_PATH_MSYS%/%SB_TIFF_FILENAME%

REM Patch libtiff/CMakeLists.txt: Remove reference to libtiff.def as this breaks building a static library
sed -i 's/libtiff.def//g' %SB_TIFF_PATH%/libtiff/CMakeLists.txt

REM Delete old build directory
CD %SB_BUILD_PATH%
CALL %SB_UTIL_SCRIPTS_PATH%\fast_rmdir.bat tiff_build
IF ERRORLEVEL 1 GOTO error_exit

REM Create build directory
MKDIR tiff_build
IF ERRORLEVEL 1 GOTO error_exit
CD tiff_build

REM Convert paths to cmake (backslashes to forward slashes)
SET "SB_INSTALL_PATH_FWD=%SB_INSTALL_PATH:\=/%"
SET "SB_SOURCE_PATH_FWD=%SB_SOURCE_PATH:\=/%"

REM ZLIB
SET ZLIB_ROOT=%SB_INSTALL_PATH_FWD%
SET ZLIB_INCLUDE_DIR=%ZLIB_ROOT%/include
SET ZLIB_LIBRARY=%ZLIB_ROOT%/lib/zlibstatic.lib

REM Call CMake
cmake -Wno-dev -G "Ninja" -DCMAKE_BUILD_TYPE="Release" -DBUILD_SHARED_LIBS=OFF -Dld-version-script=OFF -DZLIB_LIBRARY=%ZLIB_LIBRARY% -DZLIB_INCLUDE_DIR=%ZLIB_INCLUDE_DIR% -DCMAKE_INSTALL_PREFIX=%SB_INSTALL_PATH_FWD% %SB_SOURCE_PATH_FWD%/%SB_TIFF_PATH% 2>&1 | tee cmake_output.txt 
IF ERRORLEVEL 1 GOTO error_exit

REM Call Ninja
ninja all 2>&1 | tee ninja_all_output.txt 
IF ERRORLEVEL 1 GOTO error_exit
ninja install 2>&1 | tee ninja_install_output.txt 
IF ERRORLEVEL 1 GOTO error_exit

pause
exit

:error_exit
ECHO Error occurred, exiting
pause

