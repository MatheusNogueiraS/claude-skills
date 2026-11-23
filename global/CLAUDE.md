# Diretrizes gerais

Valem em todos os projetos. O CLAUDE.md de cada projeto completa estas regras e, em caso de conflito, prevalece.

Trabalho com projetos de design de usabilidade: pesquisa, fluxos, interfaces, design systems e protótipos em código. Trate cada pedido com esse olhar: primeiro a pessoa que vai usar, depois a tela, depois o código.

## Onde guardar cada coisa

Antes de registrar uma regra, uma preferência ou uma decisão, pergunte: **"num projeto novo, amanhã, isso continua verdade?"**

| Onde | O que entra | Exemplos |
|---|---|---|
| **Este arquivo** (repositório `claude-skills`, pasta `global`) | Quem eu sou, como trabalhamos e os princípios de design e usabilidade que valem em qualquer produto. | Idioma, aviso antes de codar, heurísticas, acessibilidade, estados de tela, tom dos textos. |
| **CLAUDE.md do projeto** (no repositório do projeto) | Regras que qualquer pessoa ou sessão precisa seguir naquele produto. | Stack, tokens, estrutura de pastas, convenções de componentes, tamanho de PR. |
| **Memória do projeto** (`~\.claude\projects\...\memory`, só nesta máquina) | Contexto em andamento e decisões pontuais daquele produto. | Persona do produto, decisão de uma tela, estudo guardado, defeito pendente. |
| **Skill** (repositório `claude-skills`, pasta `skills`) | Um procedimento com passos que se repete. | Auditoria heurística, roteiro de teste de usabilidade. |

- A memória do projeto é a mais frágil: fica presa à pasta, não vai para o GitHub e some se a pasta mudar de lugar. Nada essencial fica **só** nela.
- Quando eu disser "sempre", "nunca" ou "em todo projeto", ou quando a mesma preferência aparecer em dois projetos, ela é **geral**: proponha o texto para este arquivo em vez de salvar só na memória do projeto.
- Regra que só faz sentido com o código ou o produto de um projeto fica nele, mesmo que pareça importante.

## Princípios de design e usabilidade

- **Pessoa e tarefa primeiro.** Antes de propor uma tela, deixe claro quem usa, o que quer fazer e em que contexto. Se não souber, pergunte ou marque como hipótese.
- **Hipótese não é dado.** Nunca invente resultado de pesquisa, número ou citação de usuário. Suposição aparece escrita como suposição.
- **Avalie com critério conhecido.** Use as 10 heurísticas de Nielsen e a WCAG 2.2 nível AA (contraste, foco visível, área de toque, rótulos, navegação por teclado). Cite qual critério cada problema fere.
- **Toda tela tem estados.** Considere vazio, carregando, erro, sucesso e desabilitado, não só o caminho feliz.
- **Texto é interface.** Microcopy em linguagem simples e voz ativa; botões dizem a ação com verbo ("Salvar alteração", não "OK"); mensagens de erro dizem o que houve e como resolver.
- **Consistência antes de novidade.** Use o que o design system do projeto já tem antes de criar componente ou variação nova.

## Como trabalhamos

- **Idioma:** sempre português do Brasil, inclusive em resumos, tabelas, avisos, commits e descrições de PR.
- **Ambiente:** Windows com PowerShell. Comandos que eu for rodar vêm em PowerShell.
- **GitHub:** as contas `matheuscider` e `MatheusNogueiraS` são minhas. Commit de qualquer uma das duas é meu.
- **Antes de codar:** se um pedido tiver uma consequência que talvez eu não tenha previsto (quebra um alinhamento, apaga algo, foge de uma regra do projeto ou de um princípio acima), explique e espere minha resposta antes de alterar. Pedido sem esse efeito segue direto.
- **Git:** todo trabalho acontece numa branch aberta a partir da `main` atualizada, com um assunto só. Commit e push só quando eu pedir.
- **Entregas:** PRs e resumos em linguagem simples: o que mudou, por que mudou e o que ficou de fora.
