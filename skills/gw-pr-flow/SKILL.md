---
name: gw-pr-flow
description: Faz uma alteração no gw-button seguindo o fluxo de revisão - cria branch a partir da main, altera, valida com lint e build, commita, faz push e abre um Pull Request em linguagem simples. Use sempre que o usuário pedir para mudar, ajustar, corrigir ou adicionar algo no código do projeto.
---

# Fluxo de alteração com Pull Request (gw-button)

Toda alteração no código passa por branch + Pull Request. **Nunca** commitar nem fazer push direto na `main`, e **nunca** fazer merge: quem aprova e faz o merge é uma pessoa.

## Antes de começar

1. Confirme com o usuário o que deve mudar, se o pedido estiver ambíguo (qual token, qual valor, qual componente).
2. Rode `git status`. Se houver alterações não commitadas que não sejam deste pedido, pare e pergunte o que fazer com elas.
3. Atualize a base:
   ```
   git checkout main
   git pull
   ```

## Passo a passo

### 1. Criar a branch
Nome no formato `<tipo>/<descricao-curta-em-kebab-case>`:

| Tipo | Quando |
|---|---|
| `feat/` | funcionalidade ou variação nova |
| `fix/` | correção de bug |
| `style/` | só aparência (cores, espaçamentos, tokens) |
| `docs/` | documentação, skills, README |
| `chore/` | configuração, dependências |

```
git checkout -b style/brand-primary-surface-fa00d0
```

### 2. Fazer a alteração
- Mude só o que foi pedido. Uma branch = uma mudança.
- Prefira editar os tokens em `src/styles/tokens.css` a escrever valores soltos nos componentes.
- Ao terminar, mostre o `git diff` ao usuário.

### 3. Validar
```
npm run lint
npm run build
```
Se algum falhar, corrija ou avise o usuário. Não siga adiante com erro.

### 4. Commit
- Mensagem em português, no imperativo, primeira linha com até ~70 caracteres.
- Corpo curto explicando o porquê, quando ajudar.
- Adicione somente os arquivos desta mudança (`git add <arquivo>`), nunca `git add .` às cegas.

### 5. Push — pedir confirmação
**Antes do push, pare e confirme com o usuário**, mostrando o nome da branch e o resumo do commit. Push publica o código. Só prossiga com o OK.

```
git push -u origin <branch>
```

### 6. Abrir o Pull Request
Use `gh pr create --base main`. Se `gh` não estiver no PATH no Windows, use `"C:\Program Files\GitHub CLI\gh.exe"`.

A descrição do PR **deve ser legível por qualquer pessoa**, inclusive quem não é dev. Regras:
- Português simples; explique qualquer jargão.
- **Nunca** use `localhost` como forma de conferir o resultado (não funciona no computador de outra pessoa).
- Aponte para a aba **Files changed** para ver a mudança e, quando existir, para o link de prévia ou um print.

Template:

```markdown
## Resumo
<uma frase: o que muda e por quê>

## O que muda para quem usa
<efeito visível ou de comportamento, sem jargão>

## Onde está a mudança no código
<arquivo(s); tabela antes/depois quando for valor simples>

## Como conferir
- **Só a mudança:** aba **Files changed** deste PR.
- **O visual:** <link de prévia ou print; se ainda não houver, diga isso>

## Risco
<Baixo / Médio / Alto e uma frase explicando>
```

### 7. Entregar
Devolva ao usuário o link do PR e diga o que falta: revisão e merge por uma pessoa. **Não** faça merge.

## Depois do merge (quando o usuário avisar)

```
git checkout main
git pull
git branch -d <branch>
```
Remova também branches locais cujo remoto foi apagado (`git branch -v` e procure `[gone]`).

## Regras rápidas

- Nunca `git push --force` (se for inevitável, `--force-with-lease`, com confirmação).
- Nunca `--no-verify` nem pular hooks.
- Não altere configuração global do git; se faltar identidade, configure só no repositório.
- Se algo inesperado aparecer (conflito, arquivo que não é seu, erro de push), pare e explique em vez de improvisar.
