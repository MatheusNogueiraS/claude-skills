<#
.SYNOPSIS
  Mantém a branch main de um repositório local em dia com o GitHub, com travas de segurança.

.DESCRIPTION
  Só VAI BUSCAR informação no GitHub (git fetch); nunca recebe conexão de fora.
  Só atualiza a pasta quando é seguro:
    - a branch atual é a main (ou a indicada em -Branch);
    - não há alterações pendentes;
    - o avanço é "fast-forward" (sem conflito, sem reescrever histórico).
  Em qualquer outro caso, não altera nada e explica o motivo.

  A última linha de saída é sempre uma linha de status, fácil de ler por um agente:
    STATUS=UPDATED   a pasta foi atualizada (lista os commits novos)
    STATUS=UPTODATE  já estava em dia
    STATUS=SKIPPED   não é seguro atualizar (motivo na mesma linha)
    STATUS=ERROR     algo falhou (motivo na mesma linha)

.PARAMETER RepoPath
  Caminho do repositório local.

.PARAMETER Branch
  Branch a manter atualizada. Padrão: main.

.PARAMETER DuracaoMinutos
  0 (padrão) = verifica uma vez e termina.
  >0 = continua verificando até esse tempo acabar; imprime uma linha a cada mudança.

.PARAMETER IntervaloSegundos
  Intervalo entre verificações no modo com duração. Padrão: 60 (mínimo 15).

.EXAMPLE
  .\sync-main.ps1 -RepoPath C:\Users\mathe\gw-button

.EXAMPLE
  .\sync-main.ps1 -RepoPath C:\Users\mathe\gw-button -DuracaoMinutos 30
#>
param(
  [Parameter(Mandatory = $true)][string]$RepoPath,
  [string]$Branch = "main",
  [int]$DuracaoMinutos = 0,
  [int]$IntervaloSegundos = 60
)

$ErrorActionPreference = "Stop"
if ($IntervaloSegundos -lt 15) { $IntervaloSegundos = 15 }

function Sync-Once {
  param([string]$Repo, [string]$Br)

  if (-not (Test-Path (Join-Path $Repo ".git"))) {
    return "STATUS=ERROR motivo='$Repo não é um repositório git'"
  }

  $atual = (git -C $Repo branch --show-current).Trim()
  if ($atual -ne $Br) {
    return "STATUS=SKIPPED motivo='você está na branch $atual, não em $Br'"
  }

  $pendentes = git -C $Repo status --porcelain
  if ($pendentes) {
    return "STATUS=SKIPPED motivo='há alterações não commitadas'"
  }

  git -C $Repo fetch origin $Br --quiet
  if ($LASTEXITCODE -ne 0) {
    return "STATUS=ERROR motivo='git fetch falhou (sem rede ou sem acesso?)'"
  }

  $local  = (git -C $Repo rev-parse HEAD).Trim()
  $remoto = (git -C $Repo rev-parse "origin/$Br").Trim()

  if ($local -eq $remoto) {
    return "STATUS=UPTODATE branch=$Br commit=$($local.Substring(0,7))"
  }

  # remoto contém o local? (local está atrás => fast-forward possível)
  git -C $Repo merge-base --is-ancestor $local $remoto
  if ($LASTEXITCODE -ne 0) {
    return "STATUS=SKIPPED motivo='histórico divergente (há commits locais fora do GitHub); resolva manualmente'"
  }

  $novos = git -C $Repo log --oneline "$local..$remoto"
  git -C $Repo merge --ff-only "origin/$Br" --quiet
  if ($LASTEXITCODE -ne 0) {
    return "STATUS=ERROR motivo='fast-forward falhou'"
  }

  $qtd = @($novos).Count
  $lista = ($novos | ForEach-Object { "  + $_" }) -join "`n"
  return "$lista`nSTATUS=UPDATED branch=$Br commits=$qtd head=$($remoto.Substring(0,7))"
}

try {
  if ($DuracaoMinutos -le 0) {
    Sync-Once -Repo $RepoPath -Br $Branch
    exit 0
  }

  $fim = (Get-Date).AddMinutes($DuracaoMinutos)
  $ultimo = ""
  Write-Output "VIGIA iniciado: $RepoPath ($Branch) por $DuracaoMinutos min, a cada $IntervaloSegundos s"
  while ((Get-Date) -lt $fim) {
    $res = Sync-Once -Repo $RepoPath -Br $Branch
    $statusLinha = ($res -split "`n")[-1]
    # só imprime quando algo mudou (atualizou) ou o estado mudou
    if ($statusLinha -ne $ultimo -or $statusLinha -like "STATUS=UPDATED*") {
      Write-Output ("[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $res)
      $ultimo = $statusLinha
    }
    Start-Sleep -Seconds $IntervaloSegundos
  }
  Write-Output "VIGIA encerrado: tempo esgotado."
}
catch {
  Write-Output "STATUS=ERROR motivo='$($_.Exception.Message)'"
  exit 1
}
