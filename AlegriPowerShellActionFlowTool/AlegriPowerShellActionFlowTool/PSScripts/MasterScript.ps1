#
# MasterScript.ps1
#
. "$PSScriptRoot\ActionFlow.ps1"

<#.Synopsis
.DESCRIPTION
With this you Start the Actionflow Tool
.PARAMETER pathToActionsXml
The Path to the XML File where declared the Actions
#>
function Start-ActionFlow 
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [string]$pathToActionsXml
	)
    Begin
    {
        Write-Verbose "Beginn Start-ActionFlow"
    }
    Process
    {
          try
        {
            $ActiveActions = Start-LoadActiveActions -pathToActionsXml $pathToActionsXml
            
            #Prüfe ob es Aktionen gibt
            if($ActiveActions)
            {
				foreach($actions in $ActiveActions)
				{
					Start-ALG_ExecutingActionsStack -XmlActions $actions #ActionFlow.ps1
				}
            }
            else
            {
                Write-Host "There are no actions to be performed" -ForegroundColor Magenta
            }
        }
        catch
        {
            Write-Error "Start-ActionFlow => Error Message: $($_.Exception.Message)"
        } 
    }

    End
    {
		Write-Verbose "End Start-ActionFlow"
    }
}

<#.Synopsis
.DESCRIPTION
Load the Active Actions from XML
.PARAMETER pathToActionsXml
The Path to the XML File where declared the Actions
#>
function Start-LoadActiveActions
{
    [CmdletBinding()]
    [OutputType([XML])]
    param
    (
        [Parameter(Mandatory=$true,
		ValueFromPipeline=$True,
		ValueFromPipelineByPropertyName=$true,
		Position=0)]
        [string]$pathToActionsXml
	)

    Begin
    {
        Write-Verbose "Start Start-LoadActiveActions"
    }
    Process
    {
		Write-Host "Step => The Actionsflow XML is read" -ForegroundColor Blue -BackgroundColor Yellow
		[XML]$actions = Get-Content -Path $pathToActionsXml
		$Global:XmlActions = $actions
		Write-Host "Step => The Actionsflow XML was loaded successfully" -ForegroundColor Green

		#Search the aktived Actions 
		$XmlActionConfigure = $actions.Actionflow.ActionConfigure
		$NotIgnoreXmlActions = $XmlActionConfigure.Actions | ? { $_.Ignore -ne "true" }

		return $NotIgnoreXmlActions
    }
    End
    {
		Write-Verbose "End Start-LoadActiveActions"
    }
}
