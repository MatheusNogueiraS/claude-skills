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

# --- Agentes -----------------------------------------------------------------
# A pasta 'agents' inteira é ligada a ~\.claude\agents (arquivos soltos não podem
# ser atalhados sem privilégio de administrador). Se já existir uma pasta real de
# agentes, nada é alterado: o script avisa.
$origemAgentes = Join-Path $PSScriptRoot "agents"
if (Test-Path $origemAgentes) {
  $destinoAgentes = Join-Path (Split-Path $Destino -Parent) "agents"

  if (-not (Test-Path $destinoAgentes)) {
    New-Item -ItemType Junction -Path $destinoAgentes -Target $origemAgentes | Out-Null
    Write-Host "[ligada]   agents"
  }
  else {
    $item = Get-Item $destinoAgentes -Force
    $alvo = @($item.Target) | Select-Object -First 1
    if ($item.LinkType -eq "Junction" -and $alvo -eq $origemAgentes) {
      Write-Host "[ok]       agents (já ligada)"
    }
    elseif ($item.LinkType -eq "Junction") {
      Write-Warning "[conflito] agents já aponta para '$alvo'. Nada foi alterado."
    }
    else {
      Write-Warning "[conflito] '$destinoAgentes' já existe como pasta real. Nada foi alterado; copie os agentes à mão ou mova os seus para este repositório."
    }
  }
}

Write-Host ""
Write-Host "Pronto. Abra uma nova sessão do Claude Code para carregar as skills e os agentes."
