$files = Get-ChildItem -Filter *.html

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $originalContent = $content
    
    # 1. Image Replacements (Addressing Caucasian images)
    $content = $content -replace 'assets/images/hero-doctor\.jpg', 'assets/images/hero-black-therapist.jpg'
    $content = $content -replace 'assets/images/hero-people-[123]\.jpg', 'assets/images/hero-black-group.jpg'
    $content = $content -replace 'assets/images/about_main_therapist\.jpg', 'assets/images/hero-black-therapist.jpg'
    $content = $content -replace 'assets/images/group_therapy_new\.jpg', 'assets/images/hero-black-group.jpg'
    $content = $content -replace 'assets/images/youth_therapy_session\.jpg', 'assets/images/hero-black-youth.jpg'
    $content = $content -replace 'assets/images/individual_counseling_session\.jpg', 'assets/images/hero-black-therapist.jpg'
    $content = $content -replace 'assets/images/couples_counseling_session\.jpg', 'assets/images/hero-black-couple.jpg'
    $content = $content -replace 'assets/images/hero_portrait_new\.jpg', 'assets/images/hero-black-therapist.jpg'
    
    # 2. Contact Information
    # Emails - Replace any gmail or placeholder with protonmail
    $content = $content -replace 'care@prioritysuccess\.com', 'PrioritySuccessAssociate@protonmail.com'
    $content = $content -replace 'PrioritySuccessAssociate@protonmail\.com', 'PrioritySuccessAssociate@protonmail.com' # ensure it stays the same
    
    # Phones - Replace the dummy phone numbers with the new one
    $content = $content -replace '\(555\) 123-4567', '+1 (980) 214-2776'
    $content = $content -replace '1-800-555-0199', '+1 (980) 214-2776'
    $content = $content -replace '\+1 \(980\) 214-2776', '+1 (980) 214-2776'
    
    # Address
    $content = $content -replace '123 Healing Way, Suite 100, City, ST', '2442 Elendil Lane'
    $content = $content -replace '123 Healing Way, Suite 100', '2442 Elendil Lane'
    
    # Text changes
    $content = $content -replace '(?i)call our helpline', 'call our office'
    $content = $content -replace '100% Confidential', 'Your privacy is treated with care in accordance with applicable privacy requirements and legal limitations required by the state of North Carolina.'
    $content = $content -replace '(?i)Book An Appointment', 'Request an Appointment'
    $content = $content -replace '(?i)Book Evaluation', 'Request an Appointment'
    $content = $content -replace '(?i)Schedule Session', 'Request an Appointment'
    $content = $content -replace '(?i)Send Us an Inquiry', 'Request an Appointment'
    
    # Button in index3.html
    $content = $content -replace 'href="#who-we-are"', 'href="who-we-are.html"'
    
    if ($content -cne $originalContent) {
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        Write-Host "Updated $($file.Name)"
    }
}
