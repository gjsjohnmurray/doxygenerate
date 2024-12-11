/// Create DOXYGEN namespace + database and webapp
Class App.Installer
{

XData setup
{
<Manifest> 
  <Namespace Name="DOXYGEN" Code="DOXYGEN-CODE" Data="DOXYGEN-DATA" Create="yes" Ensemble="0">
    <Configuration>
      <Database Name="DOXYGEN-DATA" Dir="${mgrdir}DOXYGEN/data" Create="yes" Resource="%DB_DOXYGEN-DATA"/>
      <Database Name="DOXYGEN-CODE" Dir="${mgrdir}DOXYGEN/code" Create="yes" Resource="%DB_DOXYGEN-CODE"/>
    </Configuration>
    <CSPApplication Url="/csp/doxygen" Directory="${cspdir}doxygen" ServeFiles="1" Recurse="1" AuthenticationMethods="32" 
    />
  </Namespace>
</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}
