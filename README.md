# claude-skills

Coleção de skills do Claude Code criadas por Matheus.

## Skills

| Skill | O que faz |
|---|---|
| [gw-pr-flow](skills/gw-pr-flow/SKILL.md) | Fluxo de alteração com branch, validação, commit, push e Pull Request em linguagem simples. |

## Agentes

Agentes pequenos, de função única, que um agente maior (ou você) pode convocar.

| Agente | Modelo | O que faz |
|---|---|---|
| [repo-sync](agents/repo-sync.md) | haiku | Mantém a `main` de um repositório local em dia com o GitHub, com travas de segurança (só na `main`, só sem alterações pendentes, só avanço sem conflito). Verifica uma vez ou vigia por um tempo determinado. |

O agente executa o script [scripts/sync-main.ps1](scripts/sync-main.ps1), que **só busca** informação no GitHub (`git fetch`). Nada entra na sua máquina: não há porta aberta nem serviço de terceiros.

Exemplo de convocação: *"use o agente repo-sync no C:\Users\mathe\gw-button"* ou, para vigiar por 30 minutos, *"use o repo-sync em C:\Users\mathe\gw-button por 30 minutos"*.

O script também funciona sozinho, sem o Claude:

```powershell
.\scripts\sync-main.ps1 -RepoPath C:\caminho\do\repo                      # uma vez
.\scripts\sync-main.ps1 -RepoPath C:\caminho\do\repo -DuracaoMinutos 30   # vigia por 30 min
```

## Instalação (recomendado)

As skills e os agentes ficam **somente** neste repositório. O script liga cada skill à pasta global do Claude Code (`~\.claude\skills`) e a pasta `agents` a `~\.claude\agents`, então valem em todos os projetos e um `git pull` aqui atualiza tudo, sem cópias.

```powershell
git clone https://github.com/MatheusNogueiraS/claude-skills.git
cd claude-skills
.\install.ps1
```

- Pode rodar quantas vezes quiser: o que já está ligado só é reportado, nada é sobrescrito.
- Depois de adicionar uma skill nova em `skills\<nome>\SKILL.md`, rode `.\install.ps1` de novo.
- Abra uma nova sessão do Claude Code para carregar as skills.

## Como adicionar uma skill

1. Crie `skills\<nome>\SKILL.md` (com `name` e `description` no cabeçalho).
2. Abra um Pull Request.
3. Depois do merge, rode `git pull` e `.\install.ps1`.

## Uso manual (sem script)

Se preferir copiar, coloque a pasta da skill em `~/.claude/skills/<nome>/` (todos os projetos) ou em `<projeto>/.claude/skills/<nome>/` (só aquele projeto). Cópias não se atualizam sozinhas e podem duplicar a skill.
