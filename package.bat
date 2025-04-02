
@echo off
set UNREAL_PROJECT=%AEROSIM_UNREAL_PROJECT_ROOT%\AerosimUE5.uproject
set RHI=d3d12
set PACKAGE_CONFIG=Shipping

set CESIUM_SOURCE_PATH=Plugins\CesiumForUnreal
set CESIUM_VERSION=v2.13.2

:arg-parse
if not "%1"=="" (
    if "%1"=="--config" (
        set PACKAGE_CONFIG=%2
        shift
    )
    shift
    goto :arg-parse
)

@REM Set the build folder
set BUILD_FOLDER=%AEROSIM_UNREAL_PROJECT_ROOT%\package-%PACKAGE_CONFIG%\
@echo on

@REM Display the current config
echo %PACKAGE_CONFIG%

@REM Run setup if needed
if not exist %CESIUM_SOURCE_PATH% (
    echo Downloading CesiumForUnreal %CESIUM_VERSION%...
    pushd Plugins
    curl --retry 5 --retry-max-time 120 -L -o CesiumPluginForUnreal.zip https://github.com/CesiumGS/cesium-unreal/releases/download/%CESIUM_VERSION%/CesiumForUnreal-53-%CESIUM_VERSION%.zip && tar -xf CesiumPluginForUnreal.zip && del CesiumPluginForUnreal.zip
    popd
)

@REM Run Unreal Automation Tool (UAT) with the specified parameters
call "%AEROSIM_UNREAL_ENGINE_ROOT%\Engine\Build\BatchFiles\RunUAT.bat"^
	BuildCookRun^
	-project=%UNREAL_PROJECT%^
	-Platform=Win64^
	-clientconfig=%PACKAGE_CONFIG%^
	-cook^
	-stage^
	-archive^
	-package^
	-build^
	-prereqs^
	-pak^
	-compressed^
	-archivedirectory=%BUILD_FOLDER%^
	-prereqs^
	-TargetPlatform=Win64^
	-utf8output^
	-nop4^
