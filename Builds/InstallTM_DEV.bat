XCOPY /y "Aswig.TMS.WebSetup\bin\Release\Aswig.TMS.Web.msi" "\\DVNAPP06\Temp"
XCOPY /y "Aswig.TMS.WCFSetup\bin\Release\Aswig.TMS.WCF.msi" "\\DVNAPP06\Temp"

powershell -command "&{"^
 "$encrypted= Get-Content pwdDEV.txt;"^
 "$password = ConvertTo-SecureString $encrypted -key (1..16); "^
 "$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password);"^
 "$passwordtxt =  [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr);"^
 "[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr);"^
 "out-file -filepath \\DVNAPP06\Temp\tms_pwd_temp.txt -inputobject $passwordtxt -encoding ASCII;"^
 "}"
 
set /p password=<\\DVNAPP06\Temp\tms_pwd_temp.txt
 
Tools\PSTools\PsExec.exe \\DVNAPP06 -u "dvnaswig\hudson_app" -p %password% -e -s -accepteula msiexec /x {1721e870-72ef-4f43-b10d-bdc6fb4f9f39} /qn INETPUB="C:\IISApps" 
Tools\PSTools\PsExec.exe \\DVNAPP06 -u "dvnaswig\hudson_app" -p %password% -e -s -accepteula msiexec /x {7a676504-1d96-414a-ac1b-1576c8171b62} /qn INETPUB="C:\IISApps" 

Tools\PSTools\PsExec.exe \\DVNAPP06 -u "dvnaswig\hudson_app" -p %password% -e -s -accepteula msiexec /i "\\DVNAPP06\Temp\Aswig.TMS.WCF.msi" /qn INETPUB="C:\IISApps" APPPOOL_USER="cm2" APPPOOL_PASS="password1" APPPOOL_DOMAIN="dvnaswig" CERT="CN=10.9.11.26" /log "\\DVNAPP06\Temp\Aswig.TMS.WCF.log"
Tools\PSTools\PsExec.exe \\DVNAPP06 -u "dvnaswig\hudson_app" -p %password% -e -s -accepteula msiexec /i "\\DVNAPP06\Temp\Aswig.TMS.Web.msi" /qn INETPUB="C:\IISApps" APPPOOL_USER="cm2" APPPOOL_PASS="password1" APPPOOL_DOMAIN="dvnaswig" CERT="CN=10.9.11.26" /log "\\DVNAPP06\Temp\Aswig.TMS.Web.log"

DEL "\\DVNAPP06\Temp\tms_pwd_temp.txt"  /f /q