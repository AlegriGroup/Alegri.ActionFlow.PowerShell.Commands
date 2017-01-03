#
# ActionPackageManager.ps1
#

function Search-ActionFromActionPackage
{
	<#
	.Synopsis
	Initialized action packets

	Initialsierung der Aktionspakete
	.DESCRIPTION
	The action packets are initialized here

	Hier werden die Actionspakete initialisiert
	.PARAMETER XmlAction
	An XML node <alg: AutomationAction> with the action to be performed

	Ein XML Knoten <alg:AutomationAction> mit den durchzuführende Aktion
	.PARAMETER ActionID
	The ActionID from which the action was triggered

	Die AktionID aus dem die Aktion angestossen wurde
	#>
    [CmdletBinding()]
    [OutputType([bool])]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$XmlAutomationAction,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
        [string]$ActionID
	)
    Begin
    {
      Write-Verbose "Start Search-ActionFromActionPackage"    
    }
    Process
    {
		<#
			In this area, I enter the action packages. By definition, each action package must provide two functions
			1. A function that checks if it contains the action at all
			2. A function which then performs the corresponding action.

			In diesem Bereich trage ich die Aktionspakete ein. Nach Definition muss jedes Aktionspaket zwei Funktionen zur Verfüfung stellen
			1. Eine Funktion die überprüft ob er die Aktion überhaupt enthält
			2. Eine Funktion die dann die entsprechende Aktion ausführt.
		#>
		
		$returnValue = $true

		if((Find-ActionInAP_SPEnvironment($XmlAutomationAction.ActionObject.FirstChild.LocalName)) -eq $true)
		{
			Start-ActionFromAP_SPEnvironment($XmlAutomationAction)
			    
            Write-Verbose "Action has Find in ActionPackage SharePoint Environment"
		}
		elseif((Find-ActionInAP_Template($XmlAutomationAction.ActionObject.FirstChild.LocalName)) -eq $true)
		{
			Start-ActionFromAP_Template($XmlAutomationAction)
			    
            Write-Verbose "Action has Find in ActionPackage Template"
		}
		elseif((Find-ActionInAP_SPProvisioning($XmlAutomationAction.ActionObject.FirstChild.LocalName)) -eq $true)
		{
			Start-ActionFromAP_SPProvisioning($XmlAutomationAction)
			    
            Write-Verbose "Action has Find in ActionPackage SharePoint Provisioning"
		}
		else 
		{
			$returnValue = $false
		}        

		return $returnValue
    }
    End
    {
		Write-Verbose "End Search-ActionFromActionPackage" 
    }
}
