
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$CfnDir = Join-Path $Root "cloudformation"
$BuildDir = Join-Path $CfnDir "build"
$NestedBuildDir = Join-Path $BuildDir "nested"

New-Item -ItemType Directory `
    -Path $NestedBuildDir `
    -Force | Out-Null

$Utf8 = New-Object System.Text.UTF8Encoding($false)

# Copiar el stack principal
$MainSource = Join-Path $CfnDir "main.yaml"
$MainTarget = Join-Path $BuildDir "main.yaml"

[System.IO.File]::WriteAllText(
    $MainTarget,
    [System.IO.File]::ReadAllText($MainSource),
    $Utf8
)

# Generar las plantillas anidadas
foreach ($Role in @("frontend", "backend")) {

    $TemplatePath = Join-Path $CfnDir "nested\$Role.yaml"
    $CloudInitPath = Join-Path $Root "cloud-init\$Role.yaml"
    $OutputPath = Join-Path $NestedBuildDir "$Role.yaml"

    $Template = [System.IO.File]::ReadAllText($TemplatePath)
    $CloudInit = [System.IO.File]::ReadAllText($CloudInitPath)

    $CloudInit = $CloudInit -replace "`r`n", "`n"
    $CloudInit = $CloudInit.TrimEnd("`r", "`n")

    # Indentar cloud-init para YAML
    $Indented = (
        $CloudInit -split "`n" |
        ForEach-Object { "          $_" }
    ) -join "`n"

    $Placeholder = "          __CLOUD_INIT_CONTENT__"

    if (-not $Template.Contains($Placeholder)) {
        throw "Marcador no encontrado en $TemplatePath"
    }

    $Generated = $Template.Replace(
        $Placeholder,
        $Indented
    )

    [System.IO.File]::WriteAllText(
        $OutputPath,
        $Generated,
        $Utf8
    )

    Write-Host "Generado: $OutputPath"
}

Write-Host "Plantillas CloudFormation generadas correctamente"
