# Diretrizes gerais

Valem em todos os projetos. O CLAUDE.md de cada projeto completa estas regras e, em caso de conflito, prevalece.

Trabalho com projetos de design de usabilidade: pesquisa, fluxos, interfaces, design systems e protótipos em código. Primeiro a pessoa que vai usar, depois a tela, depois o código. Os princípios de usabilidade ficam em `rules/design-usabilidade.md` e carregam quando um arquivo de interface é aberto; a avaliação completa é a skill `auditoria-usabilidade`.

## Como trabalhamos

- **Idioma:** sempre português do Brasil, inclusive em resumos, tabelas, avisos, commits e descrições de PR.
- **Ambiente:** Windows com PowerShell. Comandos que eu for rodar vêm em PowerShell.
- **GitHub:** as contas `matheuscider` e `MatheusNogueiraS` são minhas. Commit de qualquer uma das duas é meu.
- **Antes de codar:** se um pedido tiver uma consequência que talvez eu não tenha previsto (quebra um alinhamento, apaga algo, foge de uma regra do projeto), explique e espere minha resposta antes de alterar. Pedido sem esse efeito segue direto.
- **Hipótese não é dado:** nunca invente resultado de pesquisa, número ou fala de usuário. Suposição aparece escrita como suposição.
- **Git:** todo trabalho acontece numa branch aberta a partir da `main` atualizada, com um assunto só. Commit e push só quando eu pedir.
- **Entregas:** PRs e resumos em linguagem simples: o que mudou, por que mudou e o que ficou de fora.

## Onde guardar cada coisa

Antes de registrar uma regra, uma preferência ou uma decisão, pergunte: **"num projeto novo, amanhã, isso continua verdade?"** Se sim, é geral; se não, é do projeto.

| Onde | O que entra |
|---|---|
| **Este arquivo** (`claude-skills/global/CLAUDE.md`) | Quem eu sou e como trabalhamos. Curto: só o que vale em toda sessão. |
| **Regras gerais** (`claude-skills/global/rules/`) | Princípios que valem em todo projeto, mas só para certos arquivos (ex.: usabilidade em arquivos de interface). |
| **Skill** (`claude-skills/skills/`) | Um procedimento com passos que se repete (ex.: auditoria de usabilidade). |
| **CLAUDE.md do projeto** (no repositório, vai para o Git) | Regras daquele produto: stack, estrutura, comandos, convenções. Aponta para o `DESIGN.md`. |
| **DESIGN.md do projeto** | Pessoas e tarefas do produto, tom de voz, tokens, componentes e decisões de design. |
| **CLAUDE.local.md do projeto** (fora do Git) | Notas pessoais minhas sobre aquele projeto. |
| **Memória automática** (`~\.claude\projects\...\memory`) | O que o Claude aprende no caminho. Fica só nesta máquina e presa ao repositório: nada essencial fica **só** nela. |

- Quando eu disser "sempre", "nunca" ou "em todo projeto", ou quando a mesma preferência aparecer em dois projetos, proponha o texto para o arquivo geral certo em vez de salvar só na memória.
- Quando você errar a mesma coisa duas vezes num projeto, proponha uma linha para o CLAUDE.md ou o DESIGN.md dele.
- Regra que precisa acontecer sempre, sem depender de interpretação, vira hook, não texto.
- Novo projeto começa pelo modelo em `claude-skills/templates/projeto/`.
