# claude-skills

Coleção de skills do Claude Code criadas por Matheus.

## Skills

| Skill | O que faz |
|---|---|
| [gw-pr-flow](skills/gw-pr-flow/SKILL.md) | Fluxo de alteração com branch, validação, commit, push e Pull Request em linguagem simples. |

## Como usar uma skill

Copie a pasta da skill para um dos locais:

- `~/.claude/skills/<nome>/` — vale para todos os projetos.
- `<projeto>/.claude/skills/<nome>/` — vale só para aquele projeto.

Exemplo (PowerShell):

```powershell
Copy-Item -Recurse skills\gw-pr-flow "$env:USERPROFILE\.claude\skills\gw-pr-flow"
```
