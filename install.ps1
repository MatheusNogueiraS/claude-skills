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

# --- Agentes e regras gerais ---------------------------------------------------
# Cada pasta inteira é ligada a ~\.claude\<nome> (arquivos soltos não podem ser
# atalhados sem privilégio de administrador). Se já existir uma pasta real com
# esse nome, nada é alterado: o script avisa.
function Ligar-Pasta($origem, $nome) {
  if (-not (Test-Path $origem)) { return }
  $destinoPasta = Join-Path (Split-Path $Destino -Parent) $nome

  if (-not (Test-Path $destinoPasta)) {
    New-Item -ItemType Junction -Path $destinoPasta -Target $origem | Out-Null
    Write-Host "[ligada]   $nome"
    return
  }

  $item = Get-Item $destinoPasta -Force
  $alvo = @($item.Target) | Select-Object -First 1
  if ($item.LinkType -eq "Junction" -and $alvo -eq $origem) {
    Write-Host "[ok]       $nome (já ligada)"
  }
  elseif ($item.LinkType -eq "Junction") {
    Write-Warning "[conflito] $nome já aponta para '$alvo'. Nada foi alterado."
  }
  else {
    Write-Warning "[conflito] '$destinoPasta' já existe como pasta real. Nada foi alterado; mova os arquivos dela para este repositório e rode de novo."
  }
}

Ligar-Pasta (Join-Path $PSScriptRoot "agents") "agents"
Ligar-Pasta (Join-Path $PSScriptRoot "global\rules") "rules"

# --- CLAUDE.md geral ------------------------------------------------------------
# Arquivo solto não pode virar atalho sem administrador, então ~\.claude\CLAUDE.md
# recebe uma linha só, que importa global\CLAUDE.md deste repositório. Um CLAUDE.md
# que já tenha outro conteúdo não é alterado: o script avisa.
$origemGeral = Join-Path $PSScriptRoot "global\CLAUDE.md"
if (Test-Path $origemGeral) {
  $destinoGeral = Join-Path (Split-Path $Destino -Parent) "CLAUDE.md"
  $importacao = "@" + ($origemGeral -replace '\\', '/')

  if (-not (Test-Path $destinoGeral)) {
    [System.IO.File]::WriteAllText($destinoGeral, "$importacao`n", (New-Object System.Text.UTF8Encoding $false))
    Write-Host "[ligado]   CLAUDE.md geral"
  }
  elseif ((Get-Content $destinoGeral -Raw).Trim() -eq $importacao) {
    Write-Host "[ok]       CLAUDE.md geral (já ligado)"
  }
  else {
    Write-Warning "[conflito] '$destinoGeral' já tem outro conteúdo. Nada foi alterado; leve o conteúdo para global\CLAUDE.md e apague o arquivo para ligar."
  }
}

Write-Host ""
Write-Host "Pronto. Abra uma nova sessão do Claude Code para carregar as skills, os agentes, as regras e o CLAUDE.md geral."
