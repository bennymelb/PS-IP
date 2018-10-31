# This is a library for IP related function in powershell

function Test-IPPrivate ()
{
    Param 
    (
        [string]$ip
    )

    # private IP range
    # 10.0.0.0 - 10.255.255.255
    # 172.16.0.0 - 172.31.255.255
    # 192.168.0.0 - 192.168.255.255
    
    # Validate the IP address
    if (!(Test-IPFormat $ip)) {
        Write-Verbose "IP address $ip is in valid IP format"
        return $false
    }    
    else {
        # check first octet 
        if ( [int]$($ip.split("."))[0] -eq 10 ) {
        
            # first octet is 10, this means its a private IP
            Write-Verbose "First octet of $ip is 10, this means its a private IP"
            return $true
        }
        elseif ( [int]$($ip.split("."))[0] -eq 172 ) {

            # first octet is 172, need to check the second octet before we can determine whether this is a private IP
            Write-Verbose "First octet of $ip is 172, we need to check the second octet before we can determine this is a private IP or not"
            if ( ( [int]$($ip.split("."))[1] -ge 16 ) -or ( [int]$($ip.split("."))[1] -le 31 ) ) {

                # second octet is between 16 and 31, means its an private IP
                Write-Verbose "Second octet of $ip is between 16 and 31, this means its a private IP"
                return $true
            }
        }
        elseif ( [int]$($ip.split("."))[0] -eq 192 ) {

            # first octet is 192, need to check the second octet before we can determine whether this is a private IP
            Write-Verbose "First octet of $ip is 192, we need to check the second octet before we can determine this is a private IP or not"
            if ( [int]$($ip.split("."))[1] -eq 168 ) {

                # second octet is 168, means its an private IP
                Write-Verbose "Second octet of $ip is 168, this means its a private IP"
                return $true
            }        
        }
        else {
            # This IP address is not a private IP
            Write-Verbose "IP address $ip is not a private IP"
            return $false
        }
    }    
}

function Test-IPFormat ()
{
    Param
    (
        [string]$ip
    )
    
    $testswitch = $true

    # IP has a minimum lenght of 7 (0.0.0.0) and a maximum lenght of 15 (255.255.255.255)
    if ( ($ip.Length -lt 7) -or ($ip.Length -gt 15) )
    {
        Write-Verbose "$ip is shorter than 7 characters (0.0.0.0) or longer than 15 characters (255.255.255.255)"
        $testswitch = $false
    }

    # IP must have three dots 
    If ( ([regex]::Matches($ip, "\.")).Count -ne 3)
    {
        Write-Verbose "$ip does not have 3 dots"
        $testswitch = $false
    }

    # IP must have 4 octets 
    if ( $($ip.Split(".")).Count -ne 4 )
    {
        Write-Verbose "$ip does not have 4 octets"
        $testswitch = $false
    }
       
    # each octet has a minimum of 0 and and maximum of 255
    foreach ($octet in ($ip.Split("."))) 
    {
        try { 
            # Test if the octet is a number
            [int16]$octet | Out-Null
        }
        Catch { 
            Write-Verbose "$ip contains $octet that is not a number"
            $testswitch = $false
            break
        }
        If ( ([int16]$octet -lt 0) -or ([int16]$octet -gt 255) )
        {
            Write-Verbose "$ip contains $octet that is outside of 0 - 255 ranges"
            $testswitch = $false
            break
        }
    }

    # IP passes all the validation
    If ($testswitch)
    {
        Write-Verbose "$ip passes the format validation"
        return $true
    }
    else 
    {
        Write-Verbose "$ip failed the format validation"
        return $false    
    }
    
    # regex one liner (alternative way) 
    # commenting this out because I want user without regex knowledge understand how the validation logic works
    # if ( ([regex]::Matches($ip, "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b")).Success )
    #{
    #    Return $true
    #}
    #else 
    #{
    #    Return $false
    #}
}

# Export only the necessary function and Alias
Export-ModuleMember -Function Test-IPPrivate, Test-IPFormat