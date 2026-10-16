# Pesquisa: squad de agentes no Claude Code

Base de contexto para desenhar uma "equipe" de agentes (tech lead, implementador, revisor) que economize tokens sem perder qualidade.

- **Data da pesquisa:** 16/10/2026
- **Pergunta:** como montar uma squad de agentes do Claude que divida o trabalho como uma equipe humana, gastando menos tokens?
- **Status:** referência para decisões. Números de estrelas e documentação mudam; revalide antes de decisões grandes.

## Sumário

1. [Método e critérios](#1-método-e-critérios)
2. [Conclusões principais](#2-conclusões-principais)
3. [O que diz a documentação oficial](#3-o-que-diz-a-documentação-oficial)
4. [Repositórios com adoção comprovada](#4-repositórios-com-adoção-comprovada)
5. [Padrões a adotar, por fonte](#5-padrões-a-adotar-por-fonte)
6. [O que a comunidade critica](#6-o-que-a-comunidade-critica)
7. [Desenho recomendado para a nossa squad](#7-desenho-recomendado-para-a-nossa-squad)
8. [Anti-padrões](#8-anti-padrões)
9. [Correções em relação ao que assumimos antes](#9-correções-em-relação-ao-que-assumimos-antes)
10. [Perguntas em aberto](#10-perguntas-em-aberto)
11. [Fontes](#11-fontes)

## 1. Método e critérios

| Camada | Fontes | Peso |
|---|---|---|
| Oficial | Documentação do Claude Code e da plataforma; artigos de engenharia da Anthropic | Alto: define o que a ferramenta faz |
| Repositórios | Dados da API do GitHub (estrelas, forks, último push, licença) + leitura do código | Alto para adoção; médio para qualidade (estrela não é prova de eficácia) |
| Fóruns | Hacker News (threads com mais de 80 pontos) | Médio: relatos reais, mas anedóticos |
| Blogs e agregadores | Medium, dev.to, sites de listas | Baixo: só usados quando confirmados por outra camada |

Critérios para um repositório entrar: estrelas altas **e** push recente **e** licença clara. Leitura do código só nos que tratam diretamente de orquestração, implementação e revisão.

Limitações: o Reddit não retornou threads diretas na busca; os relatos de fórum vêm do Hacker News. Não auditamos os repositórios por completo, só os arquivos relevantes.

## 2. Conclusões principais

1. **Subagentes custam tokens, não economizam por padrão.** A economia vem de três coisas: modelo mais barato no trabalho volumoso, isolamento de contexto (só o resumo volta) e briefings precisos. Sem isso, gastam mais. Anthropic mediu: agentes usam ~4x mais tokens que chat; sistemas multiagente, ~15x.
2. **Para mudanças pequenas, a equipe é desperdício.** A documentação oficial manda usar a conversa principal para mudanças rápidas e direcionadas, tarefas com muito vai-e-volta e fases que compartilham muito contexto.
3. **"Agentes por tarefa, não por papel".** É a crítica mais forte dos fóruns: personas ("sou um dev sênior...") rendem pouco ou pioram o resultado. O que funciona são funções claras: implementar uma tarefa, revisar um diff.
4. **O padrão mais adotado (obra/superpowers, ~300 mil ★) é exatamente implementador + revisor por tarefa**, orquestrados pela sessão principal, com revisão final da branch no modelo mais forte.
5. **Revisão merece modelo forte; implementação mecânica, modelo barato.** Mas "turnos pesam mais que preço por token": modelos baratos levam 2-3x mais turnos em trabalho de várias etapas e acabam custando mais.
6. **Handoff por arquivo, não por colagem.** Tudo que é colado no prompt ou impresso de volta fica no contexto do orquestrador para sempre.
7. **Agent Teams (recurso experimental) não serve ao nosso objetivo agora:** ~7x mais tokens que uma sessão comum (em plan mode), e o modo de painéis não funciona no terminal do VS Code.

## 3. O que diz a documentação oficial

### Subagentes
- Arquivo `.md` com cabeçalho YAML. Só `name` e `description` são obrigatórios.
- Campos úteis para nós: `tools` (lista permitida), `disallowedTools`, `model` (`haiku`, `sonnet`, `opus`, `fable`, ID completo ou `inherit`), `maxTurns`, `effort`, `isolation: worktree`, `memory` (`project` é o padrão recomendado), `skills` (pré-carrega skills), `permissionMode`.
- Locais e prioridade: configurações gerenciadas > flag `--agents` > `.claude/agents/` (projeto) > `~/.claude/agents/` (usuário) > plugins.
- Cada subagente roda em contexto próprio e **não vê o histórico da conversa**; recebe o prompt de sistema, a tarefa escrita pelo orquestrador, os `CLAUDE.md` e um snapshot do `git status`.
- **Subagentes podem acionar subagentes, até 3 níveis abaixo da conversa principal.** Para impedir, retire `Agent` de `tools` ou coloque-o em `disallowedTools`.
- Ordem de escolha do modelo: parâmetro da chamada > `model` do arquivo > variável `CLAUDE_CODE_SUBAGENT_MODEL` > modelo da conversa.
- Descrições curtas (há aviso acima de 15 mil tokens somados); detalhes vão no corpo, que só carrega quando o agente roda. "Use proactively" na descrição incentiva a delegação.

### Quando não usar subagentes (oficial)
- Tarefa com vai-e-volta frequente ou refinamento iterativo.
- Fases que compartilham muito contexto (planejar, implementar, testar).
- Mudança rápida e direcionada.
- Quando a latência importa (o subagente começa do zero).

### Custos (oficial)
- Subagentes "enviam suas próprias requisições, que contam para os mesmos limites de uso".
- Sonnet atende a maioria das tarefas de código; Opus para arquitetura e raciocínio de várias etapas; Haiku para subagentes simples.
- Agent Teams: ~7x mais tokens em plan mode; recomendam Sonnet para os membros, times pequenos (3 a 5) e encerrar membros ociosos.
- `/usage` mostra quanto do consumo vem de subagentes e skills: é a nossa forma de medir.
- Mover instruções do `CLAUDE.md` para skills reduz contexto (skills carregam sob demanda). Manter o `CLAUDE.md` com menos de 200 linhas.

### Skills (boas práticas oficiais)
- Ser conciso: "o Claude já é muito inteligente"; só incluir o que ele não sabe.
- Corpo do `SKILL.md` com menos de 500 linhas; detalhes em arquivos de referência a **um nível** de profundidade.
- Descrição em terceira pessoa, dizendo o que faz e quando usar.
- Graus de liberdade conforme a fragilidade: passos frágeis viram script exato; julgamento fica em texto.
- **Avaliação antes da documentação:** 3 cenários reais, medir sem a skill, escrever o mínimo para passar.
- Testar com Haiku, Sonnet e Opus se a skill for usada por todos.
- Caminhos com barra `/`, nunca `\`.

### Engenharia da Anthropic
- **Orquestrador-trabalhadores** é o padrão indicado quando "as subtarefas não podem ser previstas", como mudanças de código em número desconhecido de arquivos.
- **Avaliador-otimizador** (gerar + avaliar em loop) quando há critérios claros de avaliação.
- Comece pelo mais simples e só aumente a complexidade quando medir ganho.
- Cada tarefa delegada precisa de: **objetivo, formato de saída, orientação de ferramentas e fontes, e limites claros**. Sem isso, os agentes duplicam trabalho.
- Falhas observadas: 50 subagentes para tarefas simples; continuar procurando depois de ter o suficiente; erros que se acumulam em execuções longas (mitigação: checkpoints).
- No sistema de pesquisa deles: líder em Opus, subagentes em Sonnet. Mas o próprio artigo diz que multiagente rende pouco na **maioria das tarefas de código**, por dependerem de contexto compartilhado.

## 4. Repositórios com adoção comprovada

Dados da API do GitHub em 16/10/2026.

| Repositório | ★ | Último push | Licença | O que é | Relevância |
|---|---|---|---|---|---|
| [obra/superpowers](https://github.com/obra/superpowers) | ~300 mil | 10/10/2026 | MIT | Metodologia de desenvolvimento em skills: planejar, implementar por subagente, revisar, TDD, worktrees | **Altíssima**: é o nosso padrão, maduro |
| [affaan-m/ECC](https://github.com/affaan-m/ECC) | ~281 mil | 15/10/2026 | MIT | "Harness" grande: agentes por linguagem, skills, hooks, memória, segurança | Média: bom catálogo de frontmatter, pesado demais para copiar |
| [anthropics/skills](https://github.com/anthropics/skills) | ~182 mil | 09/10/2026 | (sem chave) | Repositório oficial de skills | Alta para formato de skill |
| [github/spec-kit](https://github.com/github/spec-kit) | ~142 mil | 16/10/2026 | MIT | Desenvolvimento guiado por especificação | Média: útil para a etapa de plano |
| [ruvnet/ruflo](https://github.com/ruvnet/ruflo) (antigo claude-flow) | ~75 mil | 16/10/2026 | MIT | "Swarms" e orquestração autônoma | Baixa: oposto do nosso objetivo de economia |
| [shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) | ~68 mil | 15/10/2026 | MIT | Coletânea de boas práticas | Média: referência de leitura |
| [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) | ~64 mil | 31/05/2026 | MIT | Meta-prompting e desenvolvimento por especificação | Baixa: **arquivado** |
| [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | ~56 mil | 16/10/2026 | outra | Lista curada de recursos | Índice, não modelo |
| [bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) | ~54 mil | 16/10/2026 | outra | Agile com personas (analista, PM, arquiteto, dev, UX) | Média: é a "equipe humana" literal, mas por personas |
| [wshobson/agents](https://github.com/wshobson/agents) | ~41 mil | 15/10/2026 | MIT | Marketplace de plugins; tabela de modelos por papel | Alta para divisão de modelos |
| [davila7/claude-code-templates](https://github.com/davila7/claude-code-templates) | ~33 mil | 16/10/2026 | MIT | CLI para configurar e monitorar | Baixa |
| [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | ~26 mil | 11/10/2026 | MIT | 100+ subagentes por categoria | Média: catálogo, agentes longos e genéricos |
| [SuperClaude-Org/SuperClaude_Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework) | ~24 mil | 27/09/2026 | MIT | Comandos e "personas cognitivas" | Baixa |
| [contains-studio/agents](https://github.com/contains-studio/agents) | ~12 mil | 28/07/2025 | (sem chave) | Agentes de um estúdio | Baixa: parado há mais de 1 ano |

## 5. Padrões a adotar, por fonte

### obra/superpowers: `subagent-driven-development`
Padrão central: **um implementador novo por tarefa → revisão da tarefa (aderência à especificação + qualidade) → revisão final da branch inteira**.

- **Sessão principal = controlador.** Nunca corrige código ela mesma ("contamina o contexto e pula a revisão").
- **Contrato de status do implementador:** `DONE`, `DONE_WITH_CONCERNS`, `BLOCKED`, `NEEDS_CONTEXT`. Resposta com menos de 15 linhas; o relatório completo vai para um arquivo.
- **Implementador pode perguntar antes de começar** e deve escalar quando estiver "acima da sua capacidade": "trabalho ruim é pior que nenhum trabalho".
- **Implementador e revisor não acionam subagentes.** Revisor que o implementador chama "duplica a revisão a custo cheio".
- **Revisor:** somente leitura; recebe 3 arquivos (briefing, relatório, pacote de diff); "não confie no relatório"; dois veredictos obrigatórios (especificação e qualidade); não roda a suíte de testes de novo.
- **Loop de correção com teto:** até 5 rodadas; 1 a 3 retomam o mesmo implementador; 4 e 5 usam um implementador novo **com modelo mais forte**. No teto, o controlador decide e registra.
- **Ledger (registro em arquivo)** para sobreviver à compactação. Falha mais cara observada: controladores que perderam o lugar e refizeram tarefas já concluídas.
- **Seleção de modelo:** o menor que dê conta. Tarefa mecânica de 1-2 arquivos com especificação completa → barato; integração entre vários arquivos → padrão; arquitetura e revisão final → o mais forte. **Sempre informar o modelo explicitamente** (omitir herda o da sessão, geralmente o mais caro).
- **"Turnos pesam mais que preço":** modelo mediano é o piso para revisores e para implementadores que trabalham a partir de texto.
- **Agrupar tarefas pequenas do mesmo tipo** num único despacho.
- **Nunca implementadores em paralelo** no mesmo trabalho (conflitos).
- Caso real citado: um despacho chegou a 42 mil caracteres, 99% de histórico colado.

### wshobson/agents: modelos por papel
| Nível | Modelo | Uso |
|---|---|---|
| 1 | Opus | Arquitetura, segurança, **code review**, código de produção |
| 2 | inherit | Tarefas complexas, escolha do usuário |
| 3 | Sonnet | Documentação, testes, depuração |
| 4 | Haiku | Operações rápidas, tarefas simples |

### affaan-m/ECC: frontmatter enxuto
Planejador e arquiteto em `opus` com ferramentas **somente leitura** (`Read, Grep, Glob`); revisores em `sonnet` com `Read, Grep, Glob, Bash` (sem `Write`/`Edit`). Descrições com "Use PROACTIVELY when...".

### VoltAgent: `multi-agent-coordinator`
Regras de honestidade: não há barramento de mensagens; a coordenação é por **arquivos compartilhados** e pelo **orquestrador**; não inventar números de desempenho.

### BMAD-METHOD: contraste
Personas como skills na conversa principal (ex.: "Amelia, Senior Software Engineer", com saudação, ícone e menu). É a simulação mais literal de uma equipe humana, mas depende de configuração pesada (`uv`, arquivos TOML) e roda no contexto principal, o que não economiza tokens.

## 6. O que a comunidade critica

Do Hacker News (threads de 288 e 451 pontos):

- **"Faça agentes para tarefas, não para papéis"** (macrolime). Outro relato: subagentes com papéis "performaram pior que o Claude Code puro" (sixhobbits). Papéis parecem "mais cerimoniais que qualquer coisa".
- **Custo:** refatoração que gerou 40+ subagentes, cada um relendo o mesmo script: "frequentemente um exagero caro" (a_bonobo). Projeto de US$ 50 perdido por contexto contaminado (prash2488).
- **Perda de contexto no handoff:** subagentes recebem só a passagem de bastão.
- **Caixa-preta:** difícil acompanhar o que o subagente faz.
- **O que funciona, segundo os mesmos threads:** subagentes para pesquisa pesada em leitura (só o relatório volta); separar planejador de implementador com passos atômicos; um script determinístico que alimenta um passo por vez e commita após cada um; a síntese pela sessão principal.
- **Ceticismo geral:** a ferramenta "funciona notavelmente bem de fábrica" (redhale); personalização é ajuste fino; scripts determinísticos resolvem boa parte (hansmayer).

## 7. Desenho recomendado para a nossa squad

Ajustado pela pesquisa. Mantém a metáfora de equipe, mas com **papéis funcionais, não personas**.

```
Você
 └── Tech lead = sessão principal (skill "liderando-squad")
       ├── decide se delega (regra de limiar)
       ├── escreve o plano e um briefing por tarefa (em arquivo)
       ├── implementador (agente)  → executa um briefing, relata status
       ├── revisor (agente)        → lê briefing + relatório + diff, dá 2 veredictos
       ├── revisão final da branch → modelo mais forte
       └── fecha com a skill gw-pr-flow (PR com sua confirmação)
```

| Papel | Tipo | Modelo | Ferramentas | Regras-chave |
|---|---|---|---|---|
| Tech lead | Skill | o da sessão | todas | Não corrige código; decide e registra; pergunta a você o que for irreversível ou público |
| Implementador | Agente | `sonnet` (`haiku` só quando o briefing traz o código completo ou é ajuste mecânico de 1 arquivo) | ler, editar, buscar, PowerShell; **sem `Agent`** | Status `DONE` / `DONE_WITH_CONCERNS` / `BLOCKED` / `NEEDS_CONTEXT`; relatório em arquivo; pode perguntar antes |
| Revisor | Agente | `sonnet` por tarefa; **`opus` na revisão final** | ler, buscar, rodar lint/build; **sem editar, sem `Agent`** | Não confia no relatório; veredicto de especificação + qualidade |
| Batedor (opcional) | Agente | `haiku` | ler e buscar | Só localizar; devolve caminhos e linhas |

**Regra de limiar (quando montar a equipe):**
- Até ~2 arquivos ou mudança direta → o tech lead faz sozinho, sem agentes.
- Várias tarefas independentes ou volume grande de código → equipe.
- Tarefas muito acopladas (mesmo arquivo, mesma interface) → sessão principal com plano, sem paralelismo.

**Mecânica:**
- Handoff por arquivos numa pasta de trabalho ignorada pelo git (briefing, relatório, diff, ledger).
- Loop de correção com teto de **3 rodadas** (escala menor que a do superpowers); a 3ª usa modelo um nível acima.
- Nunca dois implementadores no mesmo arquivo; paralelismo só com `isolation: worktree`.
- Medir com `/usage` (participação de subagentes) e comparar com a mesma tarefa feita sem equipe.
- Começar com **3 cenários de avaliação** reais no `gw-button` antes de detalhar demais as skills.

## 8. Anti-padrões

- Personas com nome, saudação e "estilo de comunicação" (gasta tokens, sem ganho medido).
- Agentes de 400+ linhas com checklists genéricos ("cobertura > 80%") que não se aplicam ao projeto.
- Implementador ou revisor chamando subagentes.
- Colar histórico das tarefas anteriores em cada despacho.
- Omitir o modelo no despacho (herda o mais caro).
- Usar `haiku` em tarefa de várias etapas descrita em texto (mais turnos, mais custo).
- O tech lead "só corrigir rapidinho" o que o revisor apontou.
- Agent Teams para tarefas rotineiras.
- Instalar coleções inteiras de agentes de terceiros com `Bash`/`Write` sem ler.

## 9. Correções em relação ao que assumimos antes

| Antes | Depois da pesquisa |
|---|---|
| "Subagentes não podem acionar subagentes" (veio de blog) | **Podem**, até 3 níveis; bloqueamos retirando `Agent` das ferramentas |
| Revisor em `opus` sempre | `sonnet` por tarefa; `opus` na revisão final da branch (diff maior, mais risco) |
| `haiku` como modelo barato padrão para volume | Só para tarefas mecânicas com briefing completo; caso contrário, gasta mais turnos |
| Limite de 2 rodadas de revisão | 3 rodadas, com escalonamento de modelo na última |
| Papéis inspirados em senioridade humana | Papéis funcionais (implementar, revisar, localizar), sem persona |

Achados sobre o nosso próprio repositório:
- O agente `repo-sync` e a skill `gw-pr-flow` usam caminhos com `\` nos exemplos. A boa prática oficial pede `/`. Ajustar quando fizer sentido (o PowerShell aceita ambos).
- As descrições já estão em terceira pessoa.

## 10. Perguntas em aberto

- Qual o ganho real no `gw-button`, que é pequeno? É provável que a maioria das tarefas fique abaixo do limiar. Medir antes de investir mais.
- Vale adotar o próprio `obra/superpowers` em vez de escrever o nosso? Prós: maduro e testado. Contras: é extenso, pensado para bash e com TDD obrigatório. Possível caminho: instalar como plugin num projeto de teste e comparar.
- O recurso de `memory` dos subagentes (escopo `project`) ajuda o revisor a lembrar convenções do projeto?

## 11. Fontes

Oficiais:
- [Subagentes (Claude Code)](https://code.claude.com/docs/en/sub-agents)
- [Agent Teams (Claude Code)](https://code.claude.com/docs/en/agent-teams)
- [Gerenciar custos (Claude Code)](https://code.claude.com/docs/en/costs)
- [Boas práticas de autoria de skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [How we built our multi-agent research system (Anthropic)](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Building effective agents (Anthropic)](https://www.anthropic.com/engineering/building-effective-agents)

Repositórios: links na seção 4. Arquivos lidos: `skills/subagent-driven-development/` (SKILL, implementer-prompt, task-reviewer-prompt) do superpowers; `agents/*.md` do ECC; `skills/bmad-agent-dev` do BMAD; `ARCHITECTURE.md` do wshobson; `multi-agent-coordinator` e `code-reviewer` do VoltAgent.

Fóruns:
- [HN: How to use Claude Code subagents to parallelize development](https://news.ycombinator.com/item?id=45181577)
- [HN: Claude Code as a Daily Driver](https://news.ycombinator.com/item?id=48289950)

Secundárias (baixo peso):
- [Claude Code Swarms (Addy Osmani)](https://addyosmani.com/blog/claude-code-agent-teams/)
- [Agent Teams vs Subagents (Morph)](https://www.morphllm.com/agent-teams-vs-subagents)
