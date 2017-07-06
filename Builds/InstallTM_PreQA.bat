XCOPY /y "Aswig.TMS.WebSetup\bin\Release\Aswig.TMS.Web.msi" "\\DATA1\App_Packages\Task_Manager"
XCOPY /y "Aswig.TMS.WcfSetup\bin\Release\Aswig.TMS.WCF.msi" "\\DATA1\App_Packages\Task_Manager"

powershell -command "&{"^
 "$encrypted= Get-Content Builds\pwdPreQA.txt;"^
 "$password = ConvertTo-SecureString $encrypted -key (1..16); "^
 "$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password);"^
 "$passwordtxt =  [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr);"^
 "[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr);"^
 "out-file -filepath \\DATA1\App_Packages\Task_Manager\tms_pwd_temp.txt -inputobject $passwordtxt -encoding ASCII;"^
 "}"
 
set /p password=<\\DATA1\App_Packages\Task_Manager\tms_pwd_temp.txt

Tools\PSTools\PsExec.exe \\SYDAPP002 -u "mnlaswig\hudson_app" -p %password% -e -s -accepteula msiexec /x {7a676504-1d96-414a-ac1b-1576c8171b62} /qn INETPUB="C:\IISApps" 
Tools\PSTools\PsExec.exe \\SYDWEB003 -u "mnlaswig\hudson_app" -p %password% -e -s -accepteula msiexec /x {1721e870-72ef-4f43-b10d-bdc6fb4f9f39} /qn INETPUB="C:\IISApps"

Tools\PSTools\PsExec.exe \\SYDAPP002 -u "mnlaswig\hudson_app" -p %password% -e -s -accepteula msiexec /i "\\DATA1\App_Packages\Task_Manager\Aswig.TMS.WCF.msi" /qn INETPUB="C:\IISApps" APPPOOL_USER="taskmanager" APPPOOL_PASS="password1" APPPOOL_DOMAIN="mnlaswig" CERT="CN=SYDAPP002"  /log "\\DATA1\App_Packages\Task_Manager\Aswig.TMS.WCF.log"
Tools\PSTools\PsExec.exe \\SYDWEB003 -u "mnlaswig\hudson_app" -p %password% -e -s -accepteula msiexec /i "\\DATA1\App_Packages\Task_Manager\Aswig.TMS.Web.msi" /qn INETPUB="C:\IISApps" APPPOOL_USER="taskmanager" APPPOOL_PASS="password1" APPPOOL_DOMAIN="mnlaswig" CERT="CN=SYDWEB003" /log "\\DATA1\App_Packages\Task_Manager\Aswig.TMS.Web.log"

DEL "\\DATA1\App_Packages\Task_Manager\tms_pwd_temp.txt"  /f /q