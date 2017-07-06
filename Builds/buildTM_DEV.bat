cd Aswig.TMS.WcfSetup
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild setup.build /t:BuildWcf;PublishWebSite;Harvest;TransformWebConfig;WIX_DEV;DeleteTmpFiles  /p:BuildConfig=DEV

cd ..\Aswig.TMS.WebSetup
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild setup.build /t:BuildWeb;PublishWebSite;Harvest;TransformWebConfig;WIX_DEV;DeleteTmpFiles  /p:BuildConfig=DEV

cd..