Function getUniqueName {
  param ([string[]]$fileNames, [string]$name, [string]$extension, [int]$counter) 
  $newFullName = "${name}${extension}"
  $newFullNameCounter = "${name} (${counter})${extension}"
  if (-not ($fileNames -contains $newFullName)) {
    return $newFullName
  }
  else {
    if (-not ($fileNames -contains $newFullNameCounter)) {
      return $newFullNameCounter
    }
    else {
      getUniqueName $fileNames $name $extension ($counter + 1)
    }
  }
}


Function RenameFiles { 
  Param([string]$path, [string]$pathToUI) 
  . $pathToUI
  $host.PrivateData.ProgressBackgroundColor = $host.UI.RawUI.BackgroundColor
  $host.privatedata.ProgressForegroundColor = "green";
  $excludedExtensions = @(".reg", ".ps1", ".bat", ".js", ".ts", ".html", ".exe", ".dll")
  $index = 0;
  $folder = Get-ChildItem $path
  $objShell = New-Object -ComObject Shell.Application 
  $objFolder = $objShell.namespace($path) 
  $folderName = $objFolder.Title
  
  # Removes all information but Name
  $fileNamings = @()
  $folder | ForEach-Object { $fileNamings += $_.Name }
  $totalFilesLength = @($fileNamings).length

  $options = @{Aufnahmedatum = "%cad%"; Erstelldatum = "%crd%"; ([char]0x00C4 + 'nderungsdatum') = "%chd%"; Elementtyp = "%ety%"; Breite = "%wdth%"; ('H' + [char]0x00F6 + 'he') = "%hght%" }
  
  $newFolderName = (GetNameFormat $folderName $totalFilesLength 26)
  if (-not $newFolderName) { return }

  foreach ($File in $objFolder.items()) { 
    $currentName = $folder[$index].Name
    $Extension = $folder[$index].Extension
    $newFileName = $newFolderName
    if ($Extension -and -not($excludedExtensions -contains $Extension)) {
      $progress = [math]::floor(($index / $totalFilesLength) * 100)
      for ($a ; $a -le 266; $a++) {  
        $propertyName = $objFolder.getDetailsOf($objFolder.items, $a)
        # Write-Host $propertyName $objFolder.getDetailsOf($File, $a)
        if ($options[$propertyName] -and $newFileName -match $options.$propertyName) {
          if ($objFolder.getDetailsOf($File, $a)) {
            # $newFileName = $newFileName.Replace($options[$propertyName], $objFolder.getDetailsOf($File, $a).Split(" ")[0].Replace(":", "."))
            $newFileName = $newFileName.Replace($options[$propertyName], $objFolder.getDetailsOf($File, $a).Replace(":", "."))
          }
          else {
            $newFileName = $newFileName.Replace($options[$propertyName], "")
          }
        }
      } #end for  
      $newFullName = (getUniqueName $fileNamings $newFileName $Extension 0)
      $fileNamings[$index] = $newFullName
      Write-Progress -Activity "${path}" -Status "${currentName} > ${newFullName}" -CurrentOperation "[${progress}%] Umbenennen..." -PercentComplete $progress
      Rename-Item -Path "${path}\${currentName}" -NewName $newFullName 
    }
    $a = 0
    $index++
  } #end foreach $File 	
} #end RenameFiles
