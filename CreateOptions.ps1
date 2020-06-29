
Function SaveFileMetaData { 
    Param([string[]]$folder) 
    $options = New-Object -TypeName psobject
    foreach ($sFolder in $folder) { 
        $a = 0 
        $objShell = New-Object -ComObject Shell.Application 
        $objFolder = $objShell.namespace($sFolder) 
        foreach ($File in $objFolder.items()) {  
            for ($a ; $a -le 266; $a++) {  
                if ($objFolder.getDetailsOf($File, $a)) { 
                    $option = $objFolder.getDetailsOf($objFolder.items, $a)
                    $options | Add-Member -MemberType NoteProperty -Name $option -Value $a -Force
                } #end if 
            } #end for  
        } #end foreach $file 
    } #end foreach $sfolder 
    Write-Output($options)
    $options | ConvertTo-Json > options.json
} #end Get-FileMetaData