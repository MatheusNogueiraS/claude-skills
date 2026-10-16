# claude-skills

Coleção de skills do Claude Code criadas por Matheus.

## Skills

| Skill | O que faz |
|---|---|
| [gw-pr-flow](skills/gw-pr-flow/SKILL.md) | Fluxo de alteração com branch, validação, commit, push e Pull Request em linguagem simples. |

## Instalação (recomendado)

As skills ficam **somente** neste repositório. O script liga cada uma delas à pasta global de skills do Claude Code (`~\.claude\skills`), então ela vale em todos os projetos e um `git pull` aqui atualiza tudo, sem cópias.

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
