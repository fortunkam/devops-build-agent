Set-ExecutionPolicy Bypass -Scope Process -Force

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

$Packages = @( `
            [pscustomobject]@{ name='curl';version='latest' },`
            [pscustomobject]@{ name='jdk8';version='latest' },`
            [pscustomobject]@{ name='azure-cli';version='latest' },`
            [pscustomobject]@{ name='terraform';version='0.11.7' },`
            [pscustomobject]@{ name='jfrog-cli';version='latest' },`
            [pscustomobject]@{ name='visualstudio2017buildtools';version='latest' },`
            [pscustomobject]@{ name='pdk';version='latest' },`
            [pscustomobject]@{ name='notepadplusplus';version='latest' },`
            [pscustomobject]@{ name='googlechrome';version='latest' },`
            [pscustomobject]@{ name='maven';version='latest' },`
            [pscustomobject]@{ name='pester';version='latest' },`
            [pscustomobject]@{ name='sqlserver-cmdlineutils';version='latest' },`
            [pscustomobject]@{ name='msoidcli';version='latest' },`
            [pscustomobject]@{ name='python';version='latest' },`
            [pscustomobject]@{ name='kubernetes-cli';version='latest' },`
            [pscustomobject]@{ name='kubernetes-helm';version='latest' },`
            [pscustomobject]@{ name='terrahelp';version='latest' }`
            )

Foreach ($Package in $Packages)
{
    if($Package.version -ne 'latest')
    {
        choco install $Package.name --version $Package.version -y
    }
    else {
        choco install $Package.name -y
    }
}

Restart-Computer