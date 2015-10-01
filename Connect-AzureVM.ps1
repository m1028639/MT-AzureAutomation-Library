workflow Connect-AzureVM
{
	[OutputType([System.Uri])]

    Param
    (            
        [parameter(Mandatory=$true)]
        [String]
        $AzureSubscriptionName,

		[parameter(Mandatory=$true)]
        [PSCredential]
        $AzureOrgIdCredential,
        
        [parameter(Mandatory=$true)]
        [String]
        $ServiceName,
        
        [parameter(Mandatory=$true)]
        [String]
        $VMName      
    )
   
    Add-AzureAccount -Credential $AzureOrgIdCredential | Write-Verbose

	# Select the Azure subscription we will be working against
    Select-AzureSubscription -SubscriptionName $AzureSubscriptionName | Write-Verbose

    InlineScript { 
        # Get the Azure certificate for remoting into this VM
        $winRMCert = (Get-AzureVM -ServiceName $Using:ServiceName -Name $Using:VMName | select -ExpandProperty vm).DefaultWinRMCertificateThumbprint   
        $AzureX509cert = Get-AzureCertificate -ServiceName $Using:ServiceName -Thumbprint $winRMCert -ThumbprintAlgorithm sha1

        # Add the VM certificate into the LocalMachine
        if ((Test-Path Cert:\LocalMachine\Root\$winRMCert) -eq $false)
        {
            Write-Progress "VM certificate is not in local machine certificate store - adding it"
            $certByteArray = [System.Convert]::fromBase64String($AzureX509cert.Data)
            $CertToImport = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList (,$certByteArray)
            $store = New-Object System.Security.Cryptography.X509Certificates.X509Store "Root", "LocalMachine"
            $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
            $store.Add($CertToImport)
            $store.Close()
        }
		
		# Return the WinRM Uri so that it can be used to connect to this VM
		Get-AzureWinRMUri -ServiceName $Using:ServiceName -Name $Using:VMName     
    }
}