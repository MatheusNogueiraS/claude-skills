# Aurora — detalhes técnicos dos tokens

Leia antes de criar ou alterar token, componente ou história. Complementa `tokens/README.md` do projeto.

## Comandos

| Comando | O que faz |
|---|---|
| `pnpm tokens` | Gera `src/styles/tokens.css`, `src/styles/tailwind.css` e `src/lib/tokens-merge.ts` a partir de `tokens/*.json` e valida as regras (fundação só literais, semântico só referências, tema não mexe em marca, sem referência quebrada, circular ou duplicada). |
| `pnpm tokens:check` | A trava: arquivos gerados atualizados; toda classe usada em `src/**/*.tsx` gera CSS; nenhum valor solto, átomo da fundação ou variável desconhecida; contraste WCAG dos pares principais nos dois temas. Roda dentro de `pnpm lint`. |
| `pnpm build` | Falha se os arquivos gerados estiverem desatualizados. |
| `pnpm build-storybook` | Gera o Storybook estático em `storybook-static/`. |

## Como um token vira classe

O Tailwind carrega só `preflight.css` e `utilities.css` (sem `theme.css`). O adaptador gerado (`src/styles/tailwind.css`) expõe **só semânticos**:

| Grupo semântico | Namespace do Tailwind | Exemplo de classe |
|---|---|---|
| `color.*` | `--color-*` | `bg-link-1`, `text-text-3`, `border-field`, `ring-focus` |
| `spacing.*` e `size.*` | `--spacing-*` (alimenta p, m, gap, inset, translate, w, h, size, min-*, max-*) | `p-nano`, `h-control-md`, `size-icon-md`, `w-popover`, `max-w-tooltip-max` |
| `radius.*` | `--radius-*` | `rounded-button`, `rounded-t-card` |
| `opacity.*` | `--opacity-*` | `opacity-disabled`, `bg-link-5/hover` |
| `layer.*` | `--z-index-*` | `z-overlay` |
| `motion.easing.*` | `--ease-*` | `ease-standard` |
| `motion.distance.*` | `--translate-*` | `slide-in-from-top-overlay` |
| `rotate.*` | `--rotate-*` | `rotate-diagonal`, `rotate-flip` |
| `elevation.*` | `--shadow-*` | `shadow-s`, `shadow-m` |
| `stroke.default` | `--border-width-*` | `border-default`, `border-b-default` |
| `breakpoint.*` | `--breakpoint-*` (valor literal, media query não aceita var) | `sm:`, `md:`, `lg:` |
| `typography.*` | `@utility typo-*` (aplica as 6 propriedades) | `typo-body-small`, `md:typo-body` |

Sem classe nomeada no Tailwind, use a variável semântica direto:
`duration-(--aurora-motion-duration-fast)`, `ring-(length:--aurora-stroke-focus)`, `border-(length:--aurora-stroke-none)`, `underline-offset-(--aurora-underline-offset)`, `zoom-in-(--aurora-motion-scale-overlay)`, `fade-in-(--aurora-opacity-hidden)`.

Valores arbitrários só com variáveis semânticas e conta: `translate-x-[calc(100%-2*var(--aurora-stroke-default))]`.

## Armadilhas já encontradas

- **Zero e números puros não existem**: `p-0`, `inset-0`, `p-4`, `text-sm` não geram CSS. Use os nomes (`p-none`, `inset-none`). A trava acusa "não gera CSS".
- **`border-none` é estilo do Tailwind, não espessura**: para zerar a espessura use `border-(length:--aurora-stroke-none)`. Por isso `stroke.none` não vira classe.
- **`max-w-none` / `max-h-none` viram zero** (colidem com `spacing.none`). A trava barra; para não ter limite, não use classe de max.
- **`cn()` precisa conhecer os tokens**: o gerador cria `tokens-merge.ts` com os nomes. Sem isso, `border-default border-field` perdia a espessura e `border-transparent` vencia `border-link-4`. Palavras-chave (`transparent`, `current`, `inherit`) estão na lista de cores. Sempre importe de `@/lib/utils`.
- **Classes dinâmicas** (`` `rounded-${nome}` ``) não são vistas pelo Tailwind. Em documentação, use `style={{ borderRadius: cssVar(id) }}`.
- **Variáveis citadas fora de classe** (`style`, objetos como o do sonner) também são conferidas pela trava: precisam ser semânticas `--aurora-*` ou de biblioteca conhecida.
- **`@theme` com mesmo nome do token causa referência circular**: por isso os tokens têm o prefixo `--aurora-` e o adaptador mapeia `--color-x: var(--aurora-color-x)`.

## Novo token, passo a passo

1. Já existe escala que serve? Dá para derivar com conta? Só então crie.
2. Se o valor não existe, crie o átomo em `tokens/foundation.json` (cor em hex, medida em px).
3. Crie o semântico em `tokens/semantic.json` apontando para ele, com `$description`.
4. Se muda no escuro, sobrescreva em `tokens/themes/dark.json` (nunca `color.brand`).
5. `pnpm tokens` e `pnpm lint`. Confira no Storybook (Fundamentos lê o JSON sozinho).

## Conferência visual (Windows)

- Chrome: `"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 --window-size=1280,900 --virtual-time-budget=9000 --screenshot=<arquivo.png> <url>`.
- Página de uma história: `http://localhost:6007/iframe.html?id=<id-da-historia>&viewMode=story`; tema escuro: acrescente `&globals=theme:Escuro`. Os ids estão em `storybook-static/index.json`.
- O Chrome headless impõe largura mínima de ~500 px. Para ver o celular de verdade, coloque uma página auxiliar na pasta servida com `<iframe src="/" style="width:390px">` (mesma origem) e capture essa página.
- Encerre os servidores no fim (porta 6007 do Storybook, 4173 do `vite preview`).
