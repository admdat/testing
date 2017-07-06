XCOPY /y "Aswig.TaskFactory.WebSetup\bin\Release\Aswig.TaskFactory.Web.msi" "\\DVNAPP06\Temp"
XCOPY /y "Aswig.TaskFactory.ServicesSetup\bin\Release\Aswig.TaskFactory.Services.msi" "\\DVNAPP06\Temp"

powershell -command "&{"^
 "$encrypted= Get-Content HudsonScripts\\pwdDEV.txt;"^
 "$password = ConvertTo-SecureString $encrypted -key (1..16); "^
 "$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password);"^
 "$passwordtxt =  [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr);"^
 "[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr);"^
 "out-file -filepath \\DVNAPP06\Temp\tm2_pwd_temp.txt -inputobject $passwordtxt -encoding ASCII;"^
 "}"
 
set /p password=<\\DVNAPP06\Temp\tm2_pwd_temp.txt

Tools\PSTools\PsExec.exe \\DVNAPP06 -u "dvnaswig\hudson_app" -p %password% -e -s -accepteula msiexec /x {9e134b11-8c18-4da8-b68d-9458f0f05027} /qn INETPUB="C:\IISApps"
 
Tools\PSTools\PsExec.exe \\DVNAPP06 -u "dvnaswig\hudson_app" -p %password% -e -s -accepteula msiexec /i "\\DVNAPP06\Temp\Aswig.TaskFactory.Web.msi" /qn INETPUB="C:\IISApps" APPPOOL_USER="cm2" APPPOOL_PASS="password1" APPPOOL_DOMAIN="dvnaswig" WEB_APP_PORT="9999" CERT="CN=10.9.11.26" /log "\\DVNAPP06\Temp\Aswig.TaskFactory.Web.log"

Tools\PSTools\PsExec.exe \\DVNAPP06 -u "dvnaswig\hudson_app" -p %password% -e -s -accepteula msiexec /x {D6F62CEE-18AA-4F73-AB62-584E4223C4B2} /qn 
 
Tools\PSTools\PsExec.exe \\DVNAPP06 -u "dvnaswig\hudson_app" -p %password% -e -s -accepteula msiexec /i "\\DVNAPP06\Temp\Aswig.TaskFactory.Services.msi" /qn /log "\\DVNAPP06\Temp\Aswig.TaskFactory.Services.log"

DEL "\\DVNAPP06\Temp\tm2_pwd_temp.txt"  /f /q

Tools\Subinacl\subinacl.exe /SERVICE \\DVNAPP06\Aswig.TaskFactory.Services /GRANT=dvnaswig\cm2=R