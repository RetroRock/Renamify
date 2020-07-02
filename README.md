## Installation
1. Run <code>powershell.exe Get-ExecutionPolicy</code> in *cmd.exe*<br>
    - If the output is <code>Remotesigned</code> or <code>Unrestricted</code>, you are good to go. You can continue to the next step.<br>
    - If not just run *cmd.exe* as admin with the following command: <br>    
                
                powershell.exe Set-ExecutionPolicy Remotesigned

2. Run *setup.exe.bat*<br>
    **Note:** If you don't see any errors in the console you can reset your execution policy to what ever you want
3. Enjoy! 😊