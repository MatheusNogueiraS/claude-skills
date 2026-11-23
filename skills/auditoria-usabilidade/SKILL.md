---
name: auditoria-usabilidade
description: Avalia a usabilidade e a acessibilidade de uma tela, fluxo ou componente pelas 10 heurísticas de Nielsen e pela WCAG 2.2 AA, e devolve um relatório com severidade e recomendação. Use quando o usuário pedir auditoria, avaliação heurística, revisão de usabilidade ou de acessibilidade, ou "o que está ruim nesta tela". Não altera nada.
---

# Auditoria de usabilidade

Relatório só de leitura: não altere código, Figma nem documentos. Correções viram uma proposta separada, depois da resposta do usuário.

## 1. Entenda o que está sendo avaliado

- **Material:** código, URL rodando, captura de tela ou link do Figma. Se for uma URL ou o app rodando, abra e navegue; se for código, leia os componentes e os estados que ele monta.
- **Pessoa e tarefa:** quem usa e o que precisa fazer. Procure no `DESIGN.md` do projeto; se não houver, pergunte. Sem resposta, siga e marque no relatório como hipótese.
- **Escopo:** quais telas e qual caminho do fluxo entram. Avalie o caminho principal primeiro.

## 2. Percorra os critérios

**10 heurísticas de Nielsen:**
1. Visibilidade do status do sistema
2. Correspondência entre o sistema e o mundo real
3. Controle e liberdade do usuário
4. Consistência e padrões
5. Prevenção de erros
6. Reconhecer em vez de lembrar
7. Flexibilidade e eficiência de uso
8. Estética e design minimalista
9. Ajudar a reconhecer, diagnosticar e corrigir erros
10. Ajuda e documentação

**WCAG 2.2 AA, no mínimo:** contraste (1.4.3 e 1.4.11), uso da cor (1.4.1), rótulos e nomes (1.3.1, 2.5.3, 3.3.2), teclado (2.1.1), foco visível e não encoberto (2.4.7, 2.4.11), tamanho do alvo (2.5.8), mensagens de erro (3.3.1, 3.3.3), redimensionamento de texto (1.4.4).

**Estados:** vazio, carregando, erro, sucesso, desabilitado. Estado que não existe é um problema.

**Texto:** rótulos, botões, mensagens de erro e vazios em linguagem simples e com verbo na ação.

Só aponte o que você viu. O que não deu para verificar (ex.: leitor de tela, contraste numa imagem) vai para "Não verificado".

## 3. Classifique a severidade (escala de Nielsen)

| Nota | Significado |
|---|---|
| 4 | Catástrofe: impede a tarefa. Corrigir antes de lançar. |
| 3 | Grave: atrapalha muito ou atinge muita gente. Alta prioridade. |
| 2 | Moderado: atrapalha, mas há como contornar. |
| 1 | Cosmético: corrigir se sobrar tempo. |

## 4. Entregue o relatório

Em português, nesta ordem:

1. **Resumo:** duas ou três frases com o que mais pesa na experiência.
2. **Problemas**, do mais grave para o mais leve:

| # | Severidade | Onde | Problema | Critério | Recomendação |
|---|---|---|---|---|---|
| 1 | 4 | Tela de pagamento, botão Confirmar | O botão some no teclado do celular | H3 · WCAG 2.4.11 | Fixar o botão acima do teclado |

3. **O que funciona bem:** até três pontos, para não serem desfeitos.
4. **Hipóteses e não verificado:** o que foi suposto sobre pessoa e tarefa, e o que ficou sem checar.
5. **Próximo passo:** pergunte se o usuário quer uma proposta de correção para os problemas de severidade 3 e 4.
