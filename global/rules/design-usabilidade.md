---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/*.vue"
  - "**/*.svelte"
  - "**/*.html"
  - "**/*.css"
  - "**/*.scss"
  - "**/*.stories.*"
  - "**/DESIGN.md"
---

# Princípios de design e usabilidade

Valem ao criar ou alterar qualquer interface. O `DESIGN.md` do projeto, quando existir, vem antes destes princípios.

- **Pessoa e tarefa primeiro.** Antes de propor uma tela, deixe claro quem usa, o que quer fazer e em que contexto. Se não souber, pergunte ou marque como hipótese.
- **Consistência antes de novidade.** Use o que o design system do projeto já tem antes de criar componente, variação ou token novo.
- **Toda tela tem estados.** Considere vazio, carregando, erro, sucesso e desabilitado, não só o caminho feliz.
- **Texto é interface.** Linguagem simples e voz ativa; botões dizem a ação com verbo ("Salvar alteração", não "OK"); mensagem de erro diz o que houve e como resolver.
- **Acessível por padrão (WCAG 2.2 AA).** Contraste de 4,5:1 no texto e 3:1 em ícones e bordas de controle; foco visível; área de toque de pelo menos 24 × 24 px; todo controle com rótulo; tudo funciona pelo teclado; cor nunca é o único sinal.
- **Problema citado com critério.** Ao apontar um problema de usabilidade, diga qual heurística de Nielsen ou critério da WCAG ele fere.
