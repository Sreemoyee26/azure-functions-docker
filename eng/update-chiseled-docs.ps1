param(
    [switch]$Check
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $root 'samples\chiseled\manifest.json'
$manifest = Get-Content -Raw $manifestPath | ConvertFrom-Json

if ($manifest.schemaVersion -ne 1 -or -not $manifest.images) {
    throw 'samples/chiseled/manifest.json does not match schema version 1.'
}

$requiredProperties = @(
    'displayName', 'runtime', 'version', 'functionsImage', 'runtimeDonor', 'sample',
    'architecture', 'releaseState', 'buildValidation', 'notes'
)

foreach ($image in $manifest.images) {
    foreach ($property in $requiredProperties) {
        if ($null -eq $image.$property -or [string]::IsNullOrWhiteSpace([string]$image.$property)) {
            throw "Manifest entry '$($image.displayName)' is missing '$property'."
        }
    }

    $samplePath = Join-Path $root ($image.sample -replace '/', '\')
    if (-not (Test-Path $samplePath -PathType Leaf)) {
        throw "Sample Dockerfile '$($image.sample)' does not exist."
    }

    $dockerfile = Get-Content -Raw $samplePath
    if ($dockerfile -notmatch [regex]::Escape("FROM $($image.functionsImage)")) {
        throw "Sample '$($image.sample)' does not use '$($image.functionsImage)' as its final base."
    }
    if ($dockerfile -notmatch 'COPY .+ /home/site/wwwroot') {
        throw "Sample '$($image.sample)' does not copy application content to /home/site/wwwroot."
    }

    $finalBaseIndex = $dockerfile.LastIndexOf("FROM $($image.functionsImage)", [StringComparison]::Ordinal)
    $finalStage = $dockerfile.Substring($finalBaseIndex)
    if ($finalStage -match '(?m)^RUN\s') {
        throw "Sample '$($image.sample)' uses RUN in the shell-free final stage."
    }
    if ($finalStage -match '(?m)^USER\s+(app|1654)\s*$') {
        throw "Sample '$($image.sample)' overrides the required root user."
    }
}

$sortedImages = @($manifest.images | Sort-Object runtime, version)

$tagRows = foreach ($image in $sortedImages) {
    $sampleLink = "../$($image.sample)"
    "| $($image.displayName) | ``$($image.functionsImage)`` | $($image.architecture) | [$($image.sample)]($sampleLink) | $($image.releaseState) |"
}
$tagSection = @(
    '<!-- BEGIN GENERATED CHISELED TAGS -->'
    '<!-- Run eng/update-chiseled-docs.ps1 to update this section. -->'
    ''
    '| Runtime | Floating public tag | Platform | Sample | State |'
    '| --- | --- | --- | --- | --- |'
    $tagRows
    '<!-- END GENERATED CHISELED TAGS -->'
) -join "`n"

$sampleRows = foreach ($image in $sortedImages) {
    $relativeSample = $image.sample -replace '^samples/chiseled/', ''
    "| $($image.displayName) | ``$($image.functionsImage)`` | ``$($image.runtimeDonor)`` | [$relativeSample]($relativeSample) | $($image.notes) |"
}
$sampleSection = @(
    '<!-- BEGIN GENERATED CHISELED SAMPLES -->'
    '<!-- Run eng/update-chiseled-docs.ps1 to update this section. -->'
    ''
    '| Runtime | Azure Functions image | Runtime donor | Dockerfile | Notes |'
    '| --- | --- | --- | --- | --- |'
    $sampleRows
    '<!-- END GENERATED CHISELED SAMPLES -->'
) -join "`n"

function Set-GeneratedSection {
    param(
        [string]$Path,
        [string]$BeginMarker,
        [string]$EndMarker,
        [string]$Replacement
    )

    $content = (Get-Content -Raw $Path) -replace "`r`n", "`n"
    $pattern = '(?s)' + [regex]::Escape($BeginMarker) + '.*?' + [regex]::Escape($EndMarker)
    $updated = [regex]::Replace($content, $pattern, $Replacement)
    if ($updated -eq $content -and $content -notmatch [regex]::Escape($Replacement)) {
        throw "Generated markers were not found in '$Path'."
    }

    if ($Check) {
        if ($updated -ne $content) {
            throw "Generated content is stale in '$Path'. Run eng/update-chiseled-docs.ps1."
        }
    }
    else {
        [IO.File]::WriteAllText($Path, $updated.Replace("`n", [Environment]::NewLine))
    }
}

Set-GeneratedSection `
    -Path (Join-Path $root 'documentation\supported-tags.md') `
    -BeginMarker '<!-- BEGIN GENERATED CHISELED TAGS -->' `
    -EndMarker '<!-- END GENERATED CHISELED TAGS -->' `
    -Replacement $tagSection

Set-GeneratedSection `
    -Path (Join-Path $root 'samples\chiseled\README.md') `
    -BeginMarker '<!-- BEGIN GENERATED CHISELED SAMPLES -->' `
    -EndMarker '<!-- END GENERATED CHISELED SAMPLES -->' `
    -Replacement $sampleSection

$markdownFiles = @(
    Get-ChildItem -Path (Join-Path $root 'README.md') -File
    Get-ChildItem -Path (Join-Path $root 'documentation') -Filter '*.md' -File -Recurse
    Get-ChildItem -Path (Join-Path $root 'samples') -Filter '*.md' -File -Recurse
)

foreach ($markdownFile in $markdownFiles) {
    $markdown = Get-Content -Raw $markdownFile.FullName
    foreach ($match in [regex]::Matches($markdown, '\[[^\]]+\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value
        if ($target -match '^(https?://|mailto:|#)') {
            continue
        }

        $pathOnly = ($target -split '[?#]', 2)[0]
        $resolved = [IO.Path]::GetFullPath((Join-Path $markdownFile.DirectoryName $pathOnly))
        if (-not (Test-Path $resolved)) {
            throw "Broken local link '$target' in '$($markdownFile.FullName)'."
        }
    }
}

Write-Host "Validated $($manifest.images.Count) Resolute Chiseled documentation entries."
