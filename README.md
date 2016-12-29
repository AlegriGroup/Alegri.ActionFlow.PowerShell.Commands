# Alegri.ActionFlow.PowerShell.Commands

## Kurz Beschreibung

Das "Action Flow Tool" für Powershell ermöglicht es mit einer XML Datei verschiedene Aktionen auszuführen. Dieses Tool stellt jedoch rein die generalisierte Funktion des "Action Flow Tool" dar. Die eigentlichen Funktionen werden durch sogenannte "Action Packs" zur Verfügung gestellt. Diese Pakete müssen im "Action Pack Manager" des "Action Flow Tool" eingetragen werden.

Das "Action Flow Tool" kennt zwei Aktionstypen [manuell, automatisch].

Bei einer manuellen Aktion wird die Beschreibung als Hinweis auf der Konsole ausgegeben und es wird auf eine Interaktion des Users gewartet. Entsprechend der Eingabe des User wird dann das Skript beendet bzw. weitergeführt.

Das "Action Flow Tool" stellt eine Globale Funktion [Create-QuestionTask] bereit, die es dem Entwickler einer Aktion ermöglicht, ebenfalls eine manuelle Interaktion des Users einzubauen.

Ein Beispiel für ein "Action Pack" finden Sie in einem [seperaten Projekt](https://github.com/Campergue/Alegri.ActionPack.Template.Powershell.Commands).

## Anwendungszweck
Bei größeren Projekten gibt es für die Umsetzung der DevOps Prinzipien genügend Tools die der Aufgabe gerecht werden. In kleinere Projekten wie z.B. das implementieren von kleineren SharePoint Service Seiten stehen diese Tools nicht zur Verfügung bzw. machen in der Regel kein Sinn. Aus dieser Situation heraus ist die Idee für das "Action Flow Tool"gekommen. Durch die Übergabe der XML Datei ist wieder eine gute Übergabe an den Adiministrator[Operation] gegeben.

Um auf das Beispiel der SharePoint Service Seite zurückzukommen, könnte ein Szenario wie folgt aussehen. 

Der Entwickler provisioniert über das CSOM Modell die neue SharePoint Service Seiten mit allen seinen Artefakten. Das gerade bei SharePoint Artefakten eine Reihenfolge wichtig sein kann, definiert der Entwickler eine "Action Flow" und stellt diesem dem Administator [Operation] zur Verfügung. Der Administration kann nun die XML Datei mit dem "Action Flow Tool" ausführen um die Anwendung zu installieren. Idealerweise stellt der Entwickler auch eine Deinstallationsroutine bereit, sollte es bei der Provisionierung Probleme geben. 

Genau für dieses Szenario ist ein "Action Pack" für die SharePoint Provisionierung entstanden das Sie in folgenden Projekt [Link folgt] finden.

Ein weitere Vorteil der XML Definition der Aktionen ist, das ein Consulter keine PowerShell Kenntnisse mehr haben muss, um die Installation/Deinstallation einer Anwendung zu definieren.

## Ausführen des Action Flow Tools
Sie müssen die XML Datei als Pfad an die [Start-ActionFlow] Funktion übergeben und starten damit das ausführen der Aktionen.
![image](https://cloud.githubusercontent.com/assets/6292190/21510293/fcdb1292-cc91-11e6-8661-d862e0727727.png)

## Einfachste Form der Verwendung
1. Laden Sie das Projekt auf Ihren Lokalen Rechner
2. Fügen Sie das Modul dem lokalen Profil der PowerShell Umgebung hinzu.
  1. In der Regel finden Sie unter C:\User\[IhrUserName]\Documents einen WindowsPowerShell Ordner. [Wenn nicht erstellen Sie den Ordner]
  2. Innerhalb des Ordner befinden sich zwei Dateien für die UserProfile Einstellungen für die PowerShell
  ![image](https://cloud.githubusercontent.com/assets/6292190/21509854/afcb1abe-cc8d-11e6-8e49-858602bf1a14.png)
    1. Die ProfilDatei für die PowerShell Klassic. Sollte die Datei bei Ihnen nicht vorhanden sein, können Sie diese Datei selbst erstellen
    2. Die ProfilDatei für die PowerShell ISE. Sollte die Datei bei Ihnen nicht vorhanden sein, können Sie diese Datei selbst erstellen.
  3. Importieren Sie die .psm1 Datei des Moduls in die jeweilige Profil Datei. Ersetzen Sie den Pfad mit dem Pfad auf Ihren Rechner zu dem Projekt.
![image](https://cloud.githubusercontent.com/assets/6292190/21509915/46157d98-cc8e-11e6-9226-9babc9232767.png)

## Einbinden eines Aktionspaket
![image](https://cloud.githubusercontent.com/assets/6292190/21509729/24ecc7cc-cc8c-11e6-9194-3b1c02bb8c0d.png)
  1. Sie prüfen als erstes ob die Aktion in dem Aktionspaket enthalten ist. Wenn ja rufen Sie die Start Funktion auf um die Aktion auszuführen.

Sie müssen das Paket wie das "Action Flow Tool" Modul einbinden.

---
##Short Description
The "Action Flow Tool" for Powershell allows you to perform various actions with an XML file. However, this tool is purely the generalized function of the "Action Flow Tool". The actual functions are provided by so-called "Action Packs". These packages must be entered in the "Action Pack Manager" of the "Action Flow Tool".

The "Action Flow Tool" has two types of actions [manual, automatic].

In the case of a manual action, the description is displayed as a reference to the console and a user interaction is maintained. According to the user's input, the script is then terminated or redirected.

The "ActionFlowTool" provides a global function [Create-QuestionTask], which allows the developer of an action to also incorporate a manual interaction of the user.

An example of an "Action Pack" can be found in a [seperate project](https://github.com/Campergue/Alegri.ActionPack.Template.Powershell.Commands).

## Application purpose
For larger projects there are enough tools for the implementation of the DevOps principles to meet the task. In smaller projects, e.g. The implementation of smaller SharePoint service pages, these tools are not available or usually make no sense. The idea for the "Action Flow Tool" came from this situation. By the transfer of the XML file is again given a good transfer to the Adiministrator [Operation].

To return to the example of the SharePoint service page, a scenario might look like this.	

The developer provides the new SharePoint service pages with all its artifacts via the CSOM model. In the case of SharePoint artefacts, an order can be important, the developer defines an "ActionFlow" and makes it available to the administator [Operation]. The administration can now run the XML file with the "Action Flow Tool" to install the application. The developer usually also provides an uninstallation routine if there are problems with the provisioning process.

Exactly for this scenario, an "ActionPack" for the SharePoint Provisioning came into existence in the following project [Link follows].

Another advantage of the XML definition of the actions is that a consulter no longer needs to have PowerShell knowledge to define the installation / uninstallation of an application.

## Execute the ActionFlowTool
You must pass the XML file as a path to the [Start-ActionFlow] function to start the actions.
![Image](https://cloud.githubusercontent.com/assets/6292190/21510293/fcdb1292-cc91-11e6-8661-d862e0727727.png)

## The simplest form of use
1. Download the project to your local computer
2. Add the module to the local PowerShell environment profile.
  1. Typically, you will find a WindowsPowerShell folder under C: \ User \ [yourUserName] \ Documents. [If not, create the folder]
  2. Inside the folder are two files for the UserProfile settings for the PowerShell
  ![Image](https://cloud.githubusercontent.com/assets/6292190/21509854/afcb1abe-cc8d-11e6-8e49-858602bf1a14.png)
    1. The profile file for the PowerShell Classic. If the file does not exist, you can create it yourself
    2. The profile file for the PowerShell ISE. If the file does not exist, you can create it yourself.
  3. Import the .psm1 file of the module into the respective profile file. Replace the path with the path to your computer to the project.
![Image](https://cloud.githubusercontent.com/assets/6292190/21509915/46157d98-cc8e-11e6-9226-9babc9232767.png)
  
## Integrating an action package
![Image](https://cloud.githubusercontent.com/assets/6292190/21509729/24ecc7cc-cc8c-11e6-9194-3b1c02bb8c0d.png)
  1. You first check whether the action is contained in the action package. If so, call the startup function to perform the action.

You must include the package as the ActionFlowTool module.

