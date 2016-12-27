. "$PSScriptRoot\ActionPackageManager.ps1"

#------------------------------------------------------------------------------------------------------------------------------------------
# All Functions to process the actions
# Alle Funktionen um die Actionen abzuarbeiten
#------------------------------------------------------------------------------------------------------------------------------------------
function Start-ALG_ExecutingActionsStack
{
    <#
    .SYNOPSIS
	The activated actions are executed here

	Hier werden die aktivierten Aktionen ausgeführt    
    .DESCRIPTION
	The activated actions within the action block are determined and executed

	Es werden die aktivierten Aktionen innerhalb des Aktionsblock ermittelt und abgearbeitet
    .PARAMETER XmlActions 
	An XML node <alg: Actions> with the actions to be performed

    Ein XML Knoten <alg:Actions> mit den durchzuführende Aktionen
    #>
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$XmlActions
    )
    begin
    {
        Write-Verbose "Start-ALG_ExecutingActionsStack begin"
    }
    process
    {
        $NotIgnoreXmlAction = $XmlActions.Action | ? {$_.Ignore -ne "true"}

		if($NotIgnoreXmlAction) {
			foreach($action in $NotIgnoreXmlAction)
			{
				Start-ALG_ExecutingAction -XmlAction $action			
			}
		}
		else
		{
			Write-Host "There are no actions to be performed" -ForegroundColor Magenta
		}
    }
    end
    {
        Write-Verbose "Start-ALG_ExecutingActionsStack end"
    }    
}

function Start-ALG_ExecutingAction
{
    <#
    .SYNOPSIS
	Manual or automatic function

    Manuelle oder Automatische Funktion ausführen
    .DESCRIPTION
	It is checked whether the action is manual or automatic processing and accordingly
    The action is passed on to the processing.

    Es wird geprüft ob die Aktion eine manuelle oder eine automatische Abarbeitung ist und entsprechend
    wird die Aktion zur Abarbeitung weitergereicht.
    .PARAMETER XmlAction
	An XML node <alg: Action> with the action to be performed

    Ein XML Knoten <alg:Action> mit den durchzuführende Aktion
    #>
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
        [System.Xml.XmlLinkedNode]$XmlAction
    )
    begin
    {
        Write-Verbose "Start-ALG_ExecutingAction begin"
    }
    process
    {
        $actionID = $XmlAction.ActionID

        Write-Host "($actionID) is starting => " $XmlAction.ActionDescription -ForegroundColor Blue -BackgroundColor Yellow 

        if($XmlAction.AutomationAction)
        {
            Start-ALG_ExecutingAutomationAction -XmlAutomationAction $XmlAction.AutomationAction -ActionID $actionID    
        }
        elseif($XmlAction.ManuellAction)
        {
            Start-ALG_ExecutingManuellAction -XmlManuellAction $XmlAction.ManuellAction -ActionID $actionID
        }
        else
        {
            Write-Host "The action ($actionID) contains incorrect elements" -ForegroundColor Red
        }
    }
    end
    {
        Write-Verbose "Start-ALG_ExecutingAction end"
    }    
}

function Start-ALG_ExecutingManuellAction
{
    <#
    .SYNOPSIS
	Perform a manual action

    Manuelle Aktion ausführen
    .DESCRIPTION
	The script will remain at this point, showing you what your manual action is.
	The script is then executed after confirmation of the user.
	If the user selects No, the complete commissioning is canceled.

    Das Skript bleibt an dieser Stelle stehen und zeigt Ihnen an was Ihre manuelle Aktion ist.
	Anschließend nach Bestätigung des Users wird der Skript ausgeführt. 
	Wenn der User Nein auswählt, bricht die komplette Provisionerung ab.
    .PARAMETER XmlManuellAction
	An XML node <alg: ManualAction> with the text displayed to the user.

    Ein XML Knoten <alg:ManuellAction> mit dem Text der dem User angezeigt wird.
	.PARAMETER ActionID
	The ActionID from which the action was triggered

	Die AktionID aus dem die Aktion angestossen wurde
    #>
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNull()]
        [System.Xml.XmlLinkedNode]$XmlManuellAction,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
        [string]$ActionID
    )
    begin
    {
        Write-Verbose "Start-ALG_ExecutingManuellAction begin"
    }
    process
    {
		
		#Check if more than one manual task is stored
		#Prüfe ob mehr als ein Manueller Task hinterlegt ist
		if($XmlManuellAction.ManuellTask.Count)
		{
			for($i=0;$i -lt $XmlManuellAction.ManuellTask.Count;$i++)
			{
				$aktion = $XmlManuellAction.ManuellTask[$i].Aktion
				$counter = $i + 1;
				$text =  "$counter ) => $aktion"
				Create-QuestionTask -statement $text
			}                
		}
		else
		{
			$aktion = $XmlManuellAction.ManuellTask.Aktion
			Create-QuestionTask -statement $aktion
		}		
    }
    end
    {
        Write-Verbose "Start-ALG_ExecutingManuellAction end"
    }    
}

function Start-ALG_ExecutingAutomationAction
{
    <#
    .SYNOPSIS
	Perform an automatic action

    Automatische Aktion ausführen
    .DESCRIPTION
	The corresponding action is started by calling the action function

    Es wird die entsprechende Aktion durch Aufruf der Aktionsfunktion gestartet 
    .PARAMETER XmlAction
	An XML node <alg: AutomationAction> with the action to be performed

    Ein XML Knoten <alg:AutomationAction> mit den durchzuführende Aktion
	.PARAMETER ActionID
	The ActionID from which the action was triggered

	Die AktionID aus dem die Aktion angestossen wurde
    #>
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$XmlAutomationAction,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
        [string]$ActionID
    )
    begin
    {
        Write-Verbose "Start-ALG_ExecutingAutomationAction begin"
    }
    process
    {
		$erg = Search-ActionFromActionPackage -XmlAutomationAction $XmlAutomationAction -ActionID $ActionID #ActionPackageManager

		if($erg -eq $false)
		{
			Write-Host "We found no Action" -ForegroundColor Red
		}
		else
		{
			Write-Verbose "Action $($ActionID) is done"
		}
    }
    end
    {
        Write-Verbose "Start-ALG_ExecutingAutomationAction end"
    }    
}

<#
.Synopsis
Create Question Action
Erstelle Frage Aktion
.DESCRIPTION
The passed text is output as a manual statement on the console. The user confirms the action by entering Y or N.
If the user has selected N, an error is generated with the text "Aborting the user ..."

Der übergebene Text wird als eine manuelle Anweisung auf der Konsole ausgegeben. Der User bestätigt die Aktion indem dieser Y oder N eingibt.
Sollte der User N ausgewählt haben wird ein Fehler erzeugt mit dem Text "Aborting the user..."
.PARAMETER statement
The text output as a statement
Den Text der als Anweisung ausgegeben wird
#>
function Create-QuestionTask
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $statement
	)
    Begin
    {
      Write-Verbose "Start Create-QuestionTask"    
    }
    Process
    {
        $eingabeOkay = $false
		$textManuell = "Please perform the following manual task : ";
        
		while(!$eingabeOkay)
        {
			
			Write-Host $textManuell -ForegroundColor Magenta
			Write-Host "=> $statement" -ForegroundColor Yellow
			Write-Host

            $input = Read-Host "Confirm that you have performed the work with [Y] or [N] for abort"

            if($input -eq "N")
            {
                throw "Aborting the user..."                
            }
            elseif($input -eq "Y")
            {
                $eingabeOkay = $true;
                Write-Host "The script is now processed further" -ForegroundColor Green
            }
            else
            {
                throw "Invalid input"
            }
        }
    }
    End
    {
		Write-Verbose "End Create-QuestionTask" 
    }
}

