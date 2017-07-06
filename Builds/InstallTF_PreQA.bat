XCOPY /y "Aswig.TaskFactory.WebSetup\bin\Release\Aswig.TaskFactory.Web.msi" "\\DATA1\App_Packages\Task_Manager"
XCOPY /y "Aswig.TaskFactory.ServicesSetup\bin\Release\Aswig.TaskFactory.Services.msi" "\\DATA1\App_Packages\Task_Manager"

powershell -command "&{"^
 "$encrypted= Get-Content Builds\pwdPreQA.txt;"^
 "$password = ConvertTo-SecureString $encrypted -key (1..16); "^
 "$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password);"^
 "$passwordtxt =  [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr);"^
 "[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr);"^
 "out-file -filepath \\DATA1\App_Packages\Task_Manager\tm2_pwd_temp.txt -inputobject $passwordtxt -encoding ASCII;"^
 "}"
 
set /p password=<\\DATA1\App_Packages\Task_Manager\tm2_pwd_temp.txt
 
Tools\PSTools\PsExec.exe \\SYDWEB003 -u "mnlaswig\hudson_app" -p %password% -e -s -accepteula msiexec /x {9e134b11-8c18-4da8-b68d-9458f0f05027} /qn INETPUB="C:\IISApps" 
Tools\PSTools\PsExec.exe \\SYDWEB003 -u "mnlaswig\hudson_app" -p %password% -e -s -accepteula msiexec /i "\\DATA1\App_Packages\Task_Manager\Aswig.TaskFactory.Web.msi" /qn INETPUB="C:\IISApps" APPPOOL_USER="taskmanager" APPPOOL_PASS="password1" APPPOOL_DOMAIN="mnlaswig" WEB_APP_PORT="9999" CERT="CN=SYDWEB003" /log "\\DATA1\App_Packages\Task_Manager\Aswig.TaskFactory.Web.log"
 
Tools\PSTools\PsExec.exe \\SYDAPP002 -u "mnlaswig\hudson_app" -p %password% -e -s -accepteula msiexec /x {D6F62CEE-18AA-4F73-AB62-584E4223C4B2} /qn 
Tools\PSTools\PsExec.exe \\SYDAPP002 -u "mnlaswig\hudson_app" -p %password% -e -s -accepteula msiexec /i "\\DATA1\App_Packages\Task_Manager\Aswig.TaskFactory.Services.msi" /qn /log "\\DATA1\App_Packages\Task_Manager\Aswig.TaskFactory.Services.log"

DEL "\\DATA1\App_Packages\Task_Manager\tm2_pwd_temp.txt"  /f /q

Tools\Subinacl\subinacl.exe /SERVICE \\SYDAPP002\Aswig.TaskFactory.Services /GRANT=mnlaswig\taskmanager=R