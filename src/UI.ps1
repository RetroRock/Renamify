Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


Function GetNameFormat() {
    param([string]$folderName, [int]$totalFileLength, [int]$maxFileNameLength)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "${totalFileLength} Dateien umbenennen" 
    $form.Size = New-Object System.Drawing.Size(300, 260)
    $form.StartPosition = 'CenterScreen'
    
    # List box
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = 'Optionen:'
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.Listbox
    $listBox.Location = New-Object System.Drawing.Point(10, 40)
    $listBox.Size = New-Object System.Drawing.Size(260, 20)
    $listBox.SelectionMode = 'MultiExtended'
    $listBox.Items.Add('Aufnahmedatum (%cad%)') | Out-Null
    $listBox.Items.Add('Erstelldatum (%crd%)') | Out-Null
    $listBox.Items.Add([char]0x00C4 + 'nderungsdatum (%chd%)') | Out-Null
    $listBox.Items.Add('Elementtyp (%ety%)') | Out-Null
    $listBox.Items.Add('Breite (%wdth%)') | Out-Null
    $listBox.Items.Add('H' + [char]0x00F6 + 'he' + ' (%hght%)') | Out-Null

    # Breite = "%wdth%"; ('H' + [char]0x00F6 + 'he') = "%hght%" 
    $listBox.Height = 50
    $form.Controls.Add($listBox)
    
    # Text box
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 100)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = 'Neuer Name:'
    $form.Controls.Add($label)
    
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10, 120)
    $textBox.Size = New-Object System.Drawing.Size(260, 20)
    $textBox.Text = $folderName
    $textBox.SelectionStart = $textBox.Text.Length;
    $textBox.MaxLength = $maxFileNameLength
    $form.Controls.Add($textBox)
    
    # buttons
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(10, 180)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)
    
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(95, 180)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = 'Abbrechen'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $form.Topmost = $true
    $listBox.add_SelectedIndexChanged( {    
            $ListSelected = $listBox.SelectedIndex
            switch ($ListSelected) {
                0 { $shortCut = '%cad%'; Break }
                1 { $shortCut = '%crd%'; Break }
                2 { $shortCut = '%chd%'; Break }
                3 { $shortCut = '%ety%'; Break }
                4 { $shortCut = '%wdth%'; Break }
                5 { $shortCut = '%hght%'; Break }
                Default { $shortCut = '%crd' }
            }
            if ($textBox.TextLength + $shortCut.Length -le $maxFileNameLength) {
                $textBox.Text = $textBox.Text.Insert($textBox.SelectionStart, $shortCut)
            }
            
        })
    
    $form.Add_Shown( { $textBox.Select() })
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = 0
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $x = $textBox.Text
        return $x
    }
    return
}