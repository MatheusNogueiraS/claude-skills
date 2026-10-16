<#
.SYNOPSIS
  Liga todas as skills deste repositório à pasta global de skills do Claude Code.

.DESCRIPTION
  Para cada pasta em .\skills que tenha um SKILL.md, cria um atalho (junction)
  em ~\.claude\skills\<nome> apontando para ela. Assim a skill vale em todos os
  projetos e um "git pull" aqui atualiza todos de uma vez, sem cópias.

  É seguro rodar várias vezes: o que já está ligado é só reportado, e nada que
  já exista é sobrescrito ou apagado.

.PARAMETER Destino
  Pasta de skills do Claude. Padrão: ~\.claude\skills

.EXAMPLE
  .\install.ps1
#>
param(
  [string]$Destino = (Join-Path $env:USERPROFILE ".claude\skills")
)

$ErrorActionPreference = "Stop"
$origem = Join-Path $PSScriptRoot "skills"

if (-not (Test-Path $origem)) {
  Write-Error "Pasta 'skills' não encontrada em $PSScriptRoot"
}

New-Item -ItemType Directory -Force $Destino | Out-Null

$skills = Get-ChildItem $origem -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") }

if (-not $skills) {
  Write-Host "Nenhuma skill encontrada em $origem"
  exit 0
}

foreach ($skill in $skills) {
  $link = Join-Path $Destino $skill.Name

  if (-not (Test-Path $link)) {
    New-Item -ItemType Junction -Path $link -Target $skill.FullName | Out-Null
    Write-Host "[ligada]   $($skill.Name)"
    continue
  }

  $item = Get-Item $link -Force
  $alvo = @($item.Target) | Select-Object -First 1

  if ($item.LinkType -eq "Junction" -and $alvo -eq $skill.FullName) {
    Write-Host "[ok]       $($skill.Name) (já ligada)"
  }
  elseif ($item.LinkType -eq "Junction") {
    Write-Warning "[conflito] $($skill.Name) já aponta para '$alvo'. Remova o atalho manualmente se quiser trocar."
  }
  else {
    Write-Warning "[conflito] $($skill.Name) já existe em '$link' como pasta real. Nada foi alterado."
  }
}

Write-Host ""
Write-Host "Pronto. Abra uma nova sessão do Claude Code para carregar as skills."
