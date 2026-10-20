---
name: aurora-ds
description: Regras de trabalho do Projeto Aurora, o design system do Bmg (tokens em JSON, componentes shadcn/React, Storybook). Use sempre que a conversa envolver o projeto-aurora, o design system Aurora, tokens de design (cores, tipografia, espaçamento, raio, sombra), componentes do DS, o Storybook do Aurora, ou pedidos do Matheus para ajustar, refinar, documentar, criar branch, commitar ou abrir PR nesse projeto — mesmo que ele não cite o nome "Aurora".
---

# Projeto Aurora — regras de trabalho

Estas regras foram definidas pelo Matheus ao longo da construção do Aurora. Ele é designer, está montando o design system e aprendendo Git. O objetivo maior: **mudar um token e ver o design system inteiro mudar, sem precisar revisar componente por componente**, com uma base reprodutível que não gere dores no futuro.

Repositório: `C:\Users\mathe\projeto-aurora` (GitHub `MatheusNogueiraS/projeto-aurora`, privado). Stack: Vite + React + TypeScript, shadcn/ui (Radix e Base UI), Tailwind v4 só como motor, pnpm, Storybook 10.

## 1. Como conversar

- Sempre em **português**, com explicações didáticas: diga o que vai fazer e por quê, em linguagem de produto, não de código. Termos técnicos ganham uma explicação curta.
- Quando a resposta tiver números ou comparações, prefira tabela.
- Ao terminar um ajuste, diga em uma linha **onde ele foi feito**: no token (JSON), no componente ou só na documentação do Storybook.
- Liste as decisões que você tomou sozinho, para ele poder corrigir.
- Ele usa voz para digitar: frases podem vir truncadas ou com palavras trocadas ("radios" = radius, "o verbo" = os values). Interprete pelo contexto e diga como interpretou.

## 2. Git e Pull Request

- **Uma branch nova a partir da `main` atualizada para cada mudança**, criada **antes** de editar qualquer arquivo (`feat/...`, `fix/...`). Se a branch atual já foi mergeada, volte para a `main`, faça `git pull` e crie outra.
- **Commit, push e PR só quando ele pedir.** Ao terminar um trabalho, ofereça.
- **Merge só quando ele pedir.** Depois do merge, **não apague a branch** (nem local, nem no GitHub), a não ser que ele peça.
- Depois de um merge, atualize a `main` local antes de começar outra coisa.
- Antes de commitar, rode e confirme que passam: `pnpm lint` (inclui a trava de tokens), `pnpm build` e, se tiver mexido em histórias ou componentes, `pnpm build-storybook`.
- Descrição de PR em **linguagem simples**, legível por qualquer pessoa: o que muda, mudanças visuais esperadas, como revisar. Nada de `localhost` ou jargão sem explicação.
- Mensagens de commit em português.
- Avisos "LF will be replaced by CRLF" são do Windows e não importam.

## 3. Instalações e publicação

- **Não rode instaladores ou geradores** (`shadcn init`, `storybook init`, `npm create...`) por conta própria. As escolhas de preset e configuração são dele: espere ele passar a configuração ou confirmar explicitamente. Perguntas antes são bem-vindas.
- Ao adicionar dependência, prefira instalar pacote por pacote, com versão fixa e publicada há pelo menos duas semanas.
- O conteúdo é do Bmg (marca e design system interno). Publicar algo fora do computador (link, hospedagem, serviço externo) só com confirmação dele. Telemetria de ferramentas fica desligada.

## 4. Tokens — as regras centrais

A fonte de verdade é `tokens/*.json` (formato de design tokens): `foundation.json`, `semantic.json` e `themes/dark.json`. O CSS é **gerado** (`pnpm tokens`) em `src/styles/tokens.css`, `src/styles/tailwind.css` e `src/lib/tokens-merge.ts`. **Nunca edite os arquivos gerados**: mude o JSON e rode `pnpm tokens`. O guia completo do projeto está em `tokens/README.md`.

**Dois níveis — átomos servem semânticos, semânticos servem componentes:**

| Nível | O que é | Regra |
|---|---|---|
| Fundação | Valores puros: cores em **hexadecimal**, `value.*` em px (gerados em rem), pesos, durações, curvas | Só valores literais. **Imutável**: nunca mude o número de um átomo para "ajustar"; crie outro e aponte o semântico para ele. |
| Semântico | Dá significado (`color.focus`, `radius.button`, `typography.body-small`, `size.control.md`) — inclui os tokens específicos de componente | Só referências (`{grupo.nome}`), nunca valor literal. São os **únicos** que componentes usam. |

Regras que ele reforçou:

- **Nenhum valor direto em componente**: nada de `p-4`, `text-sm`, `[13px]`, `#fff`, `opacity-50`, `rounded-full`, `z-50`, `/50`. Nem `value.*` ou outro átomo da fundação, nem para "mecânica" interna.
- **Nada duplicado**: uma única coleção por assunto. O Tailwind roda **sem o tema padrão dele**; só os semânticos viram classe.
- **Enxuto**: só vira token o que é decisão de design ou se repete. Para detalhes internos de um componente, siga esta ordem: (1) reaproveite uma escala semântica existente (`control`, `icon`, `spacing`, `stroke`, `opacity`); (2) derive com uma conta entre semânticos (ex.: bolinha do switch = `size.switch.height − 2 × stroke.default`); (3) só então crie um token específico.
- **Papéis de estado** já existem e devem ser usados em vez de cor numerada: `focus`, `invalid`, `field`, `divider`, `disabled`, `disabled-surface`.
- **Tema**: só o modo Bmg (ignore PJ, Clubes, wireframe e a coleção "colors web" do Figma). O tema escuro (`themes/dark.json`) sobrescreve só semânticos e **nunca** `color.brand.*`. O tema é aplicado com a classe `.dark` no `<html>`; temas por região da página não são suportados (limitação aceita).
- Para cores novas no tema escuro, pode criar átomos na fundação, desde que o contraste fique bom e a marca não mude.
- Nomes em kebab-case (`link-1`, `brand-details-1`); variáveis CSS com prefixo `--aurora-`.
- O Figma ("Genesis tokens", modo Bmg) foi a base de criação. Não precisa consultá-lo, a menos que ele mande um link.

Antes de mexer em token ou componente, leia `references/tokens-tecnico.md` (como as classes são formadas e armadilhas já encontradas).

## 5. Componentes

- Ficam em `src/components/ui` (shadcn). Use só classes semânticas: `bg-link-1`, `text-text-3`, `p-nano`, `gap-quark`, `h-control-md`, `size-icon-md`, `rounded-button`, `typo-body-small`, `shadow-s`, `z-overlay`, `ring-focus/focus-ring`.
- Importe `cn` de `@/lib/utils` (ele conhece os tokens; o `cn` do pacote não).
- Um valor visual novo nasce **primeiro no JSON**, depois vai para o componente.
- Ao mudar um componente reaproveitado por outros (o `Button` é usado pelo calendário e pelo input-group), confira que a mudança não "vaza" para eles.

## 6. Storybook — onde ele valida o trabalho

- O Storybook (`pnpm storybook`) é a **tela de validação**. Todo ajuste que ele pedir olhando o Storybook vai para a **fonte do DS** (token ou componente), **nunca só para a história**.
- Fica só no Storybook o que é apresentação da documentação: textos de exemplo, descrições, layout das páginas de Fundamentos.
- Histórias em `src/stories/componentes/*.stories.tsx`; páginas de Fundamentos em `src/stories/fundamentos/`, que **leem o JSON de tokens direto** (`tokens-data.ts`), sem copiar valores. Introdução em `src/stories/Introducao.mdx`.
- A trava de tokens também confere as histórias, então elas seguem as mesmas regras dos componentes.
- Para conferir visualmente, gere `pnpm build-storybook`, sirva com `pnpm exec vite preview --outDir storybook-static --port 6007` e capture com o Chrome headless (detalhes em `references/tokens-tecnico.md`). Encerre os servidores no final.

## 7. Decisões já tomadas (não reabrir sem ele pedir)

- Fontes: Montserrat (títulos, `font.heading`) e Lato 400/700 (textos, `font.body`). A Lato não tem peso 500: não use `font-medium`.
- Botão: pill, Lato Bold (`typo-button-small-bold`; `typo-button-bold` no lg), padding sm 12 / default 16 / lg 16, alturas da escala `control`. Uma versão com Montserrat 16/18 e padding de 24 px foi rejeitada por destoar dos demais componentes.
- Badge pill (`radius.tag` aponta para `pill`); tooltip com raio 4; card, input e dia do calendário com 8; itens de lista com 6.
- Borda de campo (`color.field`) aponta para `neutral.50`, por contraste mínimo de 3:1.
- A vitrine `src/App.tsx` continua no projeto até ele aprovar o Storybook; depois será removida numa mudança separada.
