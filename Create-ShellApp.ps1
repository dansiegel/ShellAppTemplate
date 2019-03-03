<# 
.SYNOPSIS 
    Create Shell App Template for Prism for Xamarin Forms projects
.DESCRIPTION 
    This script can create a single or multiple projects in a single shot. All project directories are automatically created
    in the OutputPath. If no OutputPath is specified it will use the current operating directory. The OutputPath does not need
    to exist at the time the command is executed.
.NOTES 
    Author     : Dan Siegel - dsiegel@avantipoint.com
.LINK 
    https://dansiegel.net/
.EXAMPLE
    Create-ShellApp -Projects "Contoso.Auth","Contoso.Settings","Contoso.UserProfile" -CompanyName Contoso
.EXAMPLE
    Create-ShellApp -Projects "Contoso.Auth","Contoso.Settings","Contoso.UserProfile" -CompanyName Contoso -OutputPath C:\Repos\ContosoApp
#> 

Param(
    [Parameter(Mandatory=$true)]
    [string[]]$Projects,
    [string]$CompanyName,
    [string]$OutputPath,
    [int]$SyslogPort = 514
)

function Update-TemplateFile {
Param(
    [string]$FilePath,
    [string]$Pattern,
    [string]$Replacement
)
    ((Get-Content -Path $FilePath -Raw) -replace $Pattern, $Replacement) | Set-Content -Path $FilePath
}

[string]$shellResources = Join-Path -Path (Split-Path $MyInvocation.MyCommand.Definition) -ChildPath "resources"
[string]$currentDirectory = Get-Location

if([string]::IsNullOrEmpty($CompanyName)) {
    $CompanyName = "avantipoint"
}

if([string]::IsNullOrEmpty($OutputPath) -eq $false) {
    $currentDirectory = $OutputPath
    mkdir $currentDirectory -Force | Out-Null
}

$nugetPath = "$env:TEMP\nuget.exe"
if(!(Test-Path -Path $nugetPath)) {
    Write-Host "Downloading latest NuGet.exe to Temp directory"
    Invoke-WebRequest -Uri https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile $nugetPath
}

$localIPAddress = Get-NetIPAddress | Where-Object {$_.PrefixOrigin -eq 'Dhcp' -or $_.PrefixOrigin -eq 'Manual' } | Select-Object -First 1 -ExpandProperty IPAddress

foreach($project in $Projects) {
  $projectDir = Join-Path -Path $currentDirectory -ChildPath $project
  mkdir $projectDir -Force | Out-Null
  Set-Location -Path $projectDir | Out-Null

  $projectName = $project -replace ".*\.",""
  Write-Host "Project Name: $($project) - ($($projectName)Module)"
  $bundleId = "$($CompanyName).$($projectName)".ToLower()
  Write-Host "Bundle Id: com.$($bundleId)"

  Copy-Item -Force -Recurse $shellResources\* -Destination $projectDir

  $secrets = @{
    AppCenterSecret = ""
    BackendUri = "https://localhost:8443"
    Host = "$localIPAddress"
    Port = "$SyslogPort"
    AppName = "$project"
  }

  $secrets | ConvertTo-Json | Out-File $projectDir\shell\ShellApp\secrets.json

  Update-TemplateFile -FilePath $projectDir\ShellApp.sln -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\ReadMe.md -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\shell\ShellApp\ShellApp.csproj -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\shell\ShellApp\App.xaml.cs -Pattern 'MyProjectModule' -Replacement "$($projectName)Module"
  Update-TemplateFile -FilePath $projectDir\shell\ShellApp\App.xaml.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\src\MyProject\MyProjectModule.cs -Pattern 'MyProjectModule' -Replacement "$($projectName)Module"
  Update-TemplateFile -FilePath $projectDir\src\MyProject\MyProjectModule.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\src\MyProject\i18n\Resources.Designer.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.Tests\Mocks\Logging\XunitLogger.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.Tests\Mocks\XunitApp.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.Tests\Mocks\XunitPlatformInitializer.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.Tests\Tests\AppFixture.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.Tests\Tests\ModuleTests.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.UITests\AppManager.cs -Pattern 'avantipoint.myproject' -Replacement $bundleId
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.UITests\AppManager.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.UITests\BaseTestFixture.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.UITests\Pages\BasePage.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.UITests\Pages\MainPage.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.UITests\PlatformQuery.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.UITests\Tests.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\tests\MyProject.UITests\WaitTimes.cs -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\shell\ShellApp.Android\Properties\AndroidManifest.xml -Pattern 'myproject' -Replacement $bundleId
  Update-TemplateFile -FilePath $projectDir\shell\ShellApp.Android\Properties\AndroidManifest.xml -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\shell\ShellApp.iOS\Info.plist -Pattern 'avantipoint.myproject' -Replacement $bundleId
  Update-TemplateFile -FilePath $projectDir\shell\ShellApp.iOS\Info.plist -Pattern 'MyProject' -Replacement $project
  Update-TemplateFile -FilePath $projectDir\shell\ShellApp.iOS\Entitlements.plist -Pattern 'avantipoint.myproject' -Replacement $bundleId
  Update-TemplateFile -FilePath $projectDir\shell\ShellApp.iOS\Entitlements.plist -Pattern 'MyProject' -Replacement $project

  Move-Item -Path $projectDir\ShellApp.sln -Destination "$projectDir\$project.sln"
  Move-Item -Path $projectDir\src\MyProject\MyProject.csproj -Destination "$projectDir\src\MyProject\$project.csproj"
  Move-Item -Path $projectDir\src\MyProject\MyProjectModule.cs -Destination "$projectDir\src\MyProject\$($projectName)Module.cs"
  Move-Item -Path $projectDir\src\MyProject\ -Destination "$projectDir\src\$project\"
  Move-Item -Path $projectDir\tests\MyProject.Tests\MyProject.Tests.csproj -Destination "$projectDir\tests\MyProject.Tests\$project.Tests.csproj"
  Move-Item -Path $projectDir\tests\MyProject.Tests\ -Destination "$projectDir\tests\$project.Tests\"
  Move-Item -Path $projectDir\tests\MyProject.UITests\MyProject.UITests.csproj -Destination "$projectDir\tests\MyProject.UITests\$project.UITests.csproj"
  Move-Item -Path $projectDir\tests\MyProject.UITests\ -Destination "$projectDir\tests\$project.UITests\"

  git init --quiet
  Write-Host "Initialized empty git repository for $project"

  git add * 2> $null
  Write-Host "Staging Files"

  git commit -m "Initial Commit" --quiet
  Write-Host "Added Initial Commit"

  Invoke-Expression -Command "$nugetPath restore" | Out-Null
  Write-Host "Restored NuGet Pacakges"
}

Remove-Item -Path $nugetPath
Set-Location -Path $currentDirectory