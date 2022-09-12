@ECHO OFF
SETLOCAL
"%~dp0\node.exe" "%~dp0\..\..\playwright-core\lib\cli\cli.js" %*
