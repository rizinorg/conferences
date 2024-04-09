$rizin_release = "0.7.2"
$release_hash = "2E67AD7475F4CC814B20B9506F7BF581D054EA9A6F4C86B2D6986689DD799662"
$url_release = "https://github.com/rizinorg/rizin/releases/download/v$rizin_release/rizin-windows-static-v$rizin_release.zip"
$release_zip = "rizin-windows-release.zip"
$rizin_unzip = "rizin-win-installer-vs2019_static-64"
$rizin_move  = "rizin-$rizin_release"

if (!(Test-Path $rizin_move)) {
    # download zip from GH if doesn't exists
    if (!(Test-Path $release_zip)) {
        Write-Warning "Downloading $url_release"
        $ProgressPreference = 'Continue'
        Invoke-WebRequest -Uri $url_release -OutFile $release_zip
    }
    # check release hash
    if (!((Get-FileHash $release_zip -Algorithm SHA256).Hash -eq $release_hash)) {
        Remove-Item -Path $release_zip -Force
        throw (New-Object System.IO.FileNotFoundException("Hash mismatch! try again to run this script."))
    }
    Write-Warning "Hash matches"
    # unzip the release
    if (!(Test-Path $rizin_unzip)) {
        Write-Warning "Unzipping $release_zip"
        Expand-Archive $release_zip -DestinationPath "."
    }
    Write-Warning "Renaming to $rizin_move"
    # rename the directory to something meaningful.
    Rename-Item -path "$rizin_unzip" -NewName "$rizin_move"
}

# retrieve full path
$path_rizin = (Get-Item $rizin_move | Resolve-Path).ProviderPath
Write-Warning "You can temporary add rizin to your environment PATH using the following command"
Write-Warning "`$env:PATH = `"`$env:PATH;$path_rizin\bin`""
