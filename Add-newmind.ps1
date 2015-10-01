
Function Add-newmind
{
	param
	(
	
		[parameter(Mandatory=$true)]
		[string]
		$mail,
		
		[parameter(Mandatory=$true)]
		[string]
		$RG,
		
		[parameter(Mandatory=$true)]
		[string]
		$Rloc,

		[parameter (Mandatory=$true)]
		[PSCredential]	
		$cred
)

Switch-AzureMode AzureResourceManager
	
	New-AzureResourceGroup -Name $RG -Location $Rloc -TemplateUri http://myreposit.blob.core.windows.net/script/azurevnetwithdmz.json
    New-AzureRoleAssignment -Mail $mail -RoleDefinitionName Owner -ResourceGroupName $RG


}

	


