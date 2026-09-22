$files = Get-ChildItem -Filter *.html

$trustInfo = @"
            <div class="footer-trust-info" style="margin-top: 2rem; font-size: 0.85rem; color: rgba(255,255,255,0.7); text-align: left; max-width: 1200px; margin-left: auto; margin-right: auto; padding-top: 1.5rem; border-top: 1px solid rgba(255,255,255,0.1);">
                <p style="margin-bottom: 0.5rem;"><strong style="color:#fff;">Emergency/Crisis Statement:</strong> If you are experiencing a life-threatening emergency or mental health crisis, please call 911, go to the nearest emergency room, or call/text the National Suicide Prevention Lifeline at 988.</p>
                <p style="margin-bottom: 0.5rem;"><strong style="color:#fff;">Service Area & Availability:</strong> Providing culturally responsive care to the African-American community and beyond. Serving Charlotte, NC and surrounding areas. Services are available both in-person and via telehealth.</p>
                <p style="margin-bottom: 0.5rem;"><strong style="color:#fff;">Insurance & Payment:</strong> We accept major insurance plans and offer flexible payment options. Please contact our office to verify your benefits.</p>
                <p style="margin-bottom: 0;">
                    <a href="#" style="color: rgba(255,255,255,0.7); text-decoration: underline; margin-right: 15px;">Privacy Policy</a>
                    <a href="#" style="color: rgba(255,255,255,0.7); text-decoration: underline; margin-right: 15px;">Notice of Privacy Practices</a>
                    <span>All providers are fully credentialed and licensed in the state of North Carolina.</span>
                </p>
            </div>
"@

$metaTags = @"
    <!-- OpenGraph & SEO Meta Tags -->
    <meta property="og:title" content="Priority Success Associates | Culturally Responsive Therapy in Charlotte, NC">
    <meta property="og:description" content="Age-appropriate, supportive therapy and peer support for the African-American community and beyond in Charlotte, NC. Available in-person and via telehealth.">
    <meta property="og:image" content="https://prioritysuccessassociates.com/assets/images/hero-black-therapist.jpg">
    <meta property="og:url" content="https://prioritysuccessassociates.com">
    <meta name="twitter:card" content="summary_large_image">
"@

$hipaaNote = @"
<div style="margin-top: 1rem; font-size: 0.85rem; color: #555; background: #f9f9f9; padding: 1rem; border-left: 3px solid var(--color-earth-orange); border-radius: 4px;">
    <strong>Notice:</strong> This form is for general inquiries. To ensure your health information remains secure under HIPAA guidelines, please do not submit sensitive medical information here. If you need immediate assistance or are experiencing a crisis, please call 911 or the National Suicide Prevention Lifeline at 988.
</div>
"@

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $originalContent = $content
    
    # 1. Add Trust Info before <div class="footer-bottom">
    if ($content -notmatch 'footer-trust-info' -and $content -match '<div class="footer-bottom">') {
        $content = $content -replace '<div class="footer-bottom">', ($trustInfo + "`n            <div class=`"footer-bottom`">")
    }
    
    # 2. Add Meta Tags before </head>
    if ($content -notmatch 'og:title' -and $content -match '</head>') {
        $content = $content -replace '</head>', ($metaTags + "`n</head>")
    }
    
    # 3. Add HIPAA note after formaloo script
    if ($content -notmatch 'This form is for general inquiries' -and $content -match '<script src="https://embed.formaloo.me/v1/main.js" defer></script>') {
        $content = $content -replace '<script src="https://embed.formaloo.me/v1/main.js" defer></script>', ("<script src=`"https://embed.formaloo.me/v1/main.js`" defer></script>`n" + $hipaaNote)
    }
    
    # Write back
    if ($content -cne $originalContent) {
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        Write-Host "Updated structure in $($file.Name)"
    }
}
