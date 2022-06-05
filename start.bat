@ECHO OFF

goto check_Permissions

:check_Permissions
    echo Administrative permissions required. Detecting permissions...
    
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
    ) else (
        echo Failed: Please run this script as administrator.
	pause
	exit
    )

echo:
echo This script may break your Minecraft Bedrock Edition install! Proceed with caution!

pause

echo:
echo Validating persona folder...

if exist "%~dp0persona\manifest.json" (
	echo manifest.json found!
) else (
	echo manifest.json doesn't exist, please fix the persona folder and try again.
	pause
	exit
)

echo:
echo Fetching Minecraft Bedrock Edition install location...
FOR /F "tokens=* USEBACKQ" %%g IN (`powershell -c "Get-AppxPackage -Name Microsoft.MinecraftUWP | Select -ExpandProperty InstallLocation"`) do (SET "MCPATH=%%g")
echo Install Location: %MCPATH%

echo:
echo Locate the Iobit Unlocker executable path
echo.  ^- Commonly found in "C:\Program Files (x86)\IObit\IObit Unlocker\IObitUnlocker.exe"
echo.  ^- Recommended to use v1.1, newer versions might not work.

set dialog="about:<meta http-equiv='X-UA-Compatible' content='IE=10'><input type=file id=f accept='.exe'><script>resizeTo(0,0); f.click();new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(f.value);close();</script>"

FOR /F "tokens=* delims=" %%p in ('mshta.exe %dialog%') do set "UNLOCKER=%%p"

echo:
echo Deleting current persona folder...
"%UNLOCKER%" /Delete "%MCPATH%\data\skin_packs\persona"

echo:
echo Replacing persona folder...
"%UNLOCKER%" /Copy "%~dp0persona" "%MCPATH%\data\skin_packs\"

echo:
echo Done! You can now close this window.
pause