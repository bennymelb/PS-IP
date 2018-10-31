# PS-IP
This is a powershell module that contains my collection of IP address related functions

It provide 2 functions

1. Test-IPFormat
2. Test-IPPrivate

Test-IPFormat:
This function takes a string input and check if its a IPv4 validate format. 
If the IP passes the validation the function will return true, if not it will return false

```
PS C:\Users\blo> Test-IPFormat "1.1.1.1"
True
PS C:\User\blo> Test-IPFormat "a.a.a.a"
False
PS C:\User\blo> Test-IPFormat "999.999.999.999"
False
PS C:\User\blo> Test-IPFormat 1.1.1.1
True

```

Test-IPPrivate:
This function takes a string input and check if its a IPv4 private IP address (RFC1918)
If the IP address is a private IP address the function will return true, if not it will return false

```
PS C:\User\blo> Test-IPPrivate "1.1.1.1"
False
PS C:\Userblo> Test-IPPrivate "10.1.1.1"
True

```

To use this library, you need to either place it into the default powershell module path $env:PSModulePath or you have to add the path where this module reside to the $env:PSModulePath like this

```
Param (

    # Set the working directory
    [string]$WorkDir = (Split-Path $MyInvocation.MyCommand.Path),

    # custom library location 
    [string]$lib = (join-path $WorkDir "lib")
)
# if library location is a relative path, append the working directory in front to make it a absolute path
If (!([System.IO.Path]::IsPathRooted($lib)))
{
    $lib = (join-path $WorkDir $lib)        
}

# Add the custom library location in the the PSModulePath env variable 
$env:PSModulePath = $env:PSModulePath + ";$lib"

# Load the logging module
Import-Module ip -ErrorAction Stop

```

If you are loading this in a interactive powershell session, assuming you place the module in the current folder

```
$env:PSModulePath = $env:PSModulePath + ";$pwd"
import-module ip

```

The .psm file will have to be place inside a folder in the $env:PSModulePath

