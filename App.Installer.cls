/// Create DOXYGENERATE namespace + database and webapp
Class App.Installer
{

XData setup
{
<Manifest> 
  <Namespace Name="DOXYGENERATE" Code="DOXYGENERATE-CODE" Data="DOXYGENERATE-DATA" Create="yes" Ensemble="0">
    <Configuration>
      <Database Name="DOXYGENERATE-DATA" Dir="${mgrdir}doxygenerate/data" Create="yes" Resource="%DB_DOXYGENERATE-DATA"/>
      <Database Name="DOXYGENERATE-CODE" Dir="${mgrdir}doxygenerate/code" Create="yes" Resource="%DB_DOXYGENERATE-CODE"/>
    </Configuration>
    <CSPApplication Url="/csp/doxygenerate" Directory="${cspdir}doxygenerate"  ServeFiles="1" Recurse="1" AuthenticationMethods="32" 
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
