# Shell App Creator

This is an experimental Project Template. This is meant to rapidly stand up a new modular app project. This is designed for teams to be able to break up development tasks across an application into pieces that make sense to be stand alone. Such an application may have multiple modules such as:

- Authentication Module
- User Profile Module
- Settings Module
- Dashboard Module
- and so on...

By using an approach in which each piece is architected Modularly this allows developers to work on an app without conflicts and to provide testing without all of the overhead that so often comes from Monolithic apps.

## How To Get Started

Clone this repo and add it to your Path. Then from any PowerShell window you can execute Create-ShellApp.ps1 from any directory. You can also specify the output path if you prefer to only execute this from the cloned directory without adding it to your path.

```ps1
# Creates a list of projects in a specified folder
$projects = { "Contoso.Auth", "Contoso.Settings", "Contoso.UserProfile", "Contoso.Dashboard" }
Create-ShellApp -Projects $projects -Company Contoso -OutputPath C:\Repos\ContosoApp

# Creates a list of project overriding the default AvantiPoint Company
Create-ShellApp -Projects "Datum.Auth","Datum.Dashboard" -Company Datum
```

The above examples will laydown multiple projects and then perform a git init and initial git commit with all of the project files along with a NuGet restore.

## Automation

Note that the Azure Pipelines definitions are still experimental and will take some additional configuration before you should use them.