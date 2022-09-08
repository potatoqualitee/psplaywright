function Start-PwPlaywright {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$TypeDefinition
    )
    if (-not $TypeDefinition) {
        $code = '
            await using var playwright = await Playwright.CreateAsync();
            await using var browser = await playwright.Chromium.LaunchAsync();
            var page = await browser.NewPageAsync();
            await page.GotoAsync("https://playwright.dev/dotnet");
            await page.ScreenshotAsync(new PageScreenshotOptions { Path = "screenshot.png" });
            '
        $random = Get-Random
        $TypeDefinition = @"
using Microsoft.Playwright;
using System.Threading.Tasks;

public class PlaywrightExample$random
{
   public static void Main()
   {
       WaitTwoSeconds().Wait();
   }

   private static async Task WaitTwoSeconds()
   {
        var playwright = await Playwright.CreateAsync();
        var browser = await playwright.Chromium.LaunchAsync();
        var page = await browser.NewPageAsync();
        await page.GotoAsync("https://playwright.dev/dotnet");
        await page.ScreenshotAsync(new PageScreenshotOptions { Path = "screenshot.png" });
   }
}
"@
    }
    Add-Type -TypeDefinition $TypeDefinition -ReferencedAssemblies Microsoft.Playwright, "$script:root\bin\Microsoft.Bcl.AsyncInterfaces.dll", "$script:root\bin\netstandard.dll" -ErrorAction Stop
    #Invoke-Expression -Command "[PSPlaywright$random]::Main()"
}