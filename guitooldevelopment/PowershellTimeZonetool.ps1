try{
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = <personalized tool name>
    $form.Size = New-Object System.Drawing.Size(300,300)
    $form.StartPosition = 'CenterScreen'
    $image = [System.Drawing.Image]::FromFile(<company Image/logo path>)
    $form.BackgroundImage = $image
    $form.BackgroundImageAnchor
    $Form.BackgroundImageLayout = 'Stretch'
    $form.Backcolor = 'White'

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(75,120)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = 'Select'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(150,120)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = 'Cancel'
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Please make a selection from the list below:'
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.Listbox
    $listBox.Location = New-Object System.Drawing.Point(10,40)
    $listBox.Size = New-Object System.Drawing.Size(260,20)

    $listBox.SelectionMode = 'MultiExtended'

    [void] $listBox.Items.Add('Time')
    [void] $listBox.Items.Add('Date')
    [void] $listBox.Items.Add('TimeZone')
    [void] $listBox.Items.Add('Disable TimeZone Auto Update')
    [void] $listBox.Items.Add('Enable Timezone Auto Update')


    $listBox.Height = 70
    $form.Controls.Add($listBox)
    $form.Topmost = $true

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $global:x = $listBox.SelectedItems
    }
if($global:x -eq "Date"){
    write-host "Select a date"
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
                        $form = New-Object Windows.Forms.Form -Property @{
                StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
                Size          = New-Object Drawing.Size 243, 230
                Text          = 'Select a Date'
                Topmost       = $true
            }

    $calendar = New-Object Windows.Forms.MonthCalendar -Property @{
        ShowTodayCircle   = $false
        MaxSelectionCount = 1
    }
    $form.Controls.Add($calendar)

    $okButton = New-Object Windows.Forms.Button -Property @{
        Location     = New-Object Drawing.Point 38, 165
        Size         = New-Object Drawing.Size 75, 23
        Text         = 'OK'
        DialogResult = [Windows.Forms.DialogResult]::OK
    }
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object Windows.Forms.Button -Property @{
        Location     = New-Object Drawing.Point 113, 165
        Size         = New-Object Drawing.Size 75, 23
        Text         = 'Cancel'
        DialogResult = [Windows.Forms.DialogResult]::Cancel
    }
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $result = $form.ShowDialog()

    if ($result -eq [Windows.Forms.DialogResult]::OK) {
        $date = $calendar.SelectionStart
        $deldate = "$($date.ToShortDateString())"
        $time = get-date -Format "HH:mm K"
        $timedate =  $deldate+" $time"
        set-date $timedate
    }
    }
if($global:x -eq "Time"){
    $deltime = Read-Host "What is the current time? (format: HH:mm 24 hour format)"
    set-date $deltime":00" -DisplayHint Time
    }
if($global:x -eq "TimeZone"){
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Time and Date Modification'
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(75,120)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = 'Select'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(150,120)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = 'Cancel'
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Please make a selection from the list below:'
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.Listbox
    $listBox.Location = New-Object System.Drawing.Point(10,40)
    $listBox.Size = New-Object System.Drawing.Size(260,20)

    $listBox.SelectionMode = 'MultiExtended'

    [void] $listBox.Items.Add('Central Standard Time')
    [void] $listBox.Items.Add('Mountain Standard Time')
    [void] $listBox.Items.Add('Eastern Standard Time')
    [void] $listBox.Items.Add('Pacific Standard Time')
    [void] $listBox.Items.Add('Alaska Standard Time')
    [void] $listBox.Items.Add('Hawaii-Aleutian Standard Time')
    [void] $listBox.Items.Add('Newfoundland Standard Time')
    [void] $listBox.Items.Add('Greenwich Mean Time')

    $listBox.Height = 70
    $form.Controls.Add($listBox)
    $form.Topmost = $true

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $global:tz = $listBox.SelectedItems
    }
        tzutil /s $global:tz
    }
if($global:x -eq "Disable TimeZone Auto Update"){
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "Type" -Value "NoSync"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate\" -Name "Start" -Value 4
        write-host "Disabling Auto Update. Please Wait....."
        read-host "Finished. Press anykey to exit..."
        }
if($global:x -eq "Enable TimeZone Auto Update"){
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "Type" -Value "NTP"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate\" -Name "Start" -Value 3
        write-host "Enabling Auto Update. Please Wait....."
        read-host "Finished. Press anykey to exit..."
        }

else{
    Write-Host "exiting."
    exit
}
}


catch{
    $time = get-date
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Send-MailMessage -to <emailaddress> -from <emailaddress> -subject "timechange Logs" -BodyAsHtml "TimeChange Failed on $time.
    $ErrorMessage
    $FailedItem
    " -smtpServer <smtp address>
}
Finally{
    "This Script failed on $time" | out-file  <logfile path and name>
}