# WA
#$env:Path += ";C:\Program Files\dotnet;C:\Program Files\Git\cmd"

# WA: git credentials 

$url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/dotnet-hosting-10.0.5-win.exe"
$installer = "$env:TEMP\dotnet-hosting-10.0.5-win.exe"
$repo = "https://github.com/Taratay/intro_project.git"
$temp = "C:\tmp_build\task1"
$webdir = "C:\inetpub\wwwroot\api"

git config --global credential.helper ""

git config --system --unset credential.helper
echo "Enabling IIS features... this takes a minute or eternity xD..."
dism /online /enable-feature /featurename:IIS-WebServerRole /all /norestart
dism /online /enable-feature /featurename:IIS-ManagementConsole /all /norestart

if (!(Get-Command dotnet -ErrorAction 0)) {
    echo "Installing .NET 10..."
    winget install --id Microsoft.DotNet.SDK.10 -e --accept-source-agreements
}
if (!(Get-Command git -ErrorAction 0)) {
    echo "Installing Git..."
    winget install --id Git.Git -e --accept-source-agreements
}
if (!(Test-Path "$env:SystemRoot\system32\inetsrv\aspnetcore.dll")) {
    Write-Host "Installing Hosting Bundle via EXE (Silent)..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $installer
    
    Start-Process -FilePath $installer -ArgumentList "/quiet /install /norestart" -Wait
    
    net stop was /y
    net start w3svc
}

# Another WA (I ran windows on qemu vm probably it caused some registy issue)
$appcmd = "$env:SystemRoot\system32\inetsrv\appcmd.exe"
$moduleCheck = & $appcmd list config -section:system.webServer/globalModules | Select-String "AspNetCoreModuleV2"

# Re register module of web bundle just in case, again unusual error
if (!$moduleCheck) {
    & $appcmd add module /name:"AspNetCoreModuleV2" /image:"%SystemRoot%\system32\inetsrv\aspnetcore.dll" /add:true
}

if (Test-Path $temp) { rm $temp -Recurse -Force }
mkdir $temp
cd $temp

echo "Cloning code..."
git clone $repo .

echo "Building project..."
cd "$temp\task1"
dotnet publish -c Release -o "$temp\out"

Import-Module WebAdministration -ErrorAction 0
if (!(Test-Path $webdir)) { mkdir $webdir }
if (!(Get-Website "MyApiSite" -ErrorAction 0)) {
    New-IISAppPool "MyPool" -ErrorAction 0
    Set-ItemProperty "IIS:\AppPools\MyPool" managedRuntimeVersion ""
    New-Website -Name "MyApiSite" -Port 5000 -PhysicalPath $webdir -ApplicationPool "MyPool"
}

copy-item "$temp\out\*" $webdir -Recurse -Force
Start-Process "powershell" "-Command Start-IISSite 'MyApiSite'" -Verb RunAs

echo "endpoint: http://localhost:5000/pong"
pause