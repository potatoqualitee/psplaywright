
function Invoke-Program {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSObject])]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ArgumentList,
        [string]$WorkingDirectory,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [uint32[]]$SuccessReturnCode = @(0, 3010),
        [switch]$EnableException
    )
    process {
        try {

            $output = [pscustomobject]@{
                ComputerName     = $Env:COMPUTERNAME
                Path             = $FilePath
                ArgumentList     = $ArgumentList
                WorkingDirectory = $WorkingDirectory
                Successful       = $false
                stdout           = $null
                stderr           = $null
                ExitCode         = $null
            }
            $command = Get-Command $FilePath | Select-Object -ExpandProperty Source
            #npx --help
            $processStartInfo = New-Object System.Diagnostics.ProcessStartInfo
            $processStartInfo.FileName = $command
            if ($ArgumentList) {
                $processStartInfo.Arguments = $ArgumentList
                if ($ExpandStrings) {
                    $processStartInfo.Arguments = $ExecutionContext.InvokeCommand.ExpandString($ArgumentList)
                }
            }
            if ($WorkingDirectory) {
                $processStartInfo.WorkingDirectory = $WorkingDirectory
                if ($ExpandStrings) {
                    $processStartInfo.WorkingDirectory = $ExecutionContext.InvokeCommand.ExpandString($WorkingDirectory)
                }
            }
            $processStartInfo.UseShellExecute = $false # This is critical for installs to function on core servers
            $processStartInfo.CreateNoWindow = $true
            $processStartInfo.RedirectStandardError = $true
            $processStartInfo.RedirectStandardOutput = $true
            $ps = New-Object System.Diagnostics.Process
            $ps.StartInfo = $processStartInfo
            $started = $ps.Start()
            if ($started) {
                $stdOut = $ps.StandardOutput.ReadToEnd()
                $stdErr = $ps.StandardError.ReadToEnd()
                $ps.WaitForExit()
                # assign output object values
                $output.stdout = $stdOut
                $output.stderr = $stdErr
                $output.ExitCode = $ps.ExitCode
                # Check the exit code of the process to see if it succeeded.
                if ($ps.ExitCode -in $SuccessReturnCode) {
                    $output.Successful = $true
                }
                $output
            }
        } catch {
            Stop-PSFFunction -EnableException:$EnableException -Message "Failed to invoke program '$FilePath'." -ErrorRecord $PSItem
        }
    }
}