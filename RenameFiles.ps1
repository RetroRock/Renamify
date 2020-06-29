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
  Param([string]$path) 
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
  
  foreach ($File in $objFolder.items()) { 
    $currentName = $folder[$index].Name
    $Extension = $folder[$index].Extension
    if ($Extension -and -not($excludedExtensions -contains $Extension)) {
	$progress = [math]::floor(($index / $totalFilesLength) * 100)
      for ($a ; $a -le 266; $a++) {  
        $propertyName = $objFolder.getDetailsOf($objFolder.items, $a)
        # Write-Output $objFolder.getDetailsOf($objFolder.items, $a)
        if ($propertyName -eq "Erstelldatum" -AND $objFolder.getDetailsOf($File, $a)) {
          $creationDate = $objFolder.getDetailsOf($File, $a).Split(" ")[0].Replace(":", ".")
          $newNameWithoutExtension = "${folderName} ${creationDate}"
          $newFullName = (getUniqueName $fileNamings $newNameWithoutExtension $Extension 0)
          $fileNamings[$index] = $newFullName
		  Write-Progress -Activity "${path}" -Status "${currentName} > ${newFullName}" -CurrentOperation "[${progress}%] Umbenennen..." -PercentComplete $progress
          Rename-Item -Path "${path}\${currentName}" -NewName $newFullName 
          break
        }
      } #end for  
    }
    $index++
  } #end foreach $File 	
} #end RenameFiles

