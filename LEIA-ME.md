# PMAX360 · v109 — como publicar

Substitui todos os pacotes anteriores. Publique só este.

## O que mudou no v109

**Marca renomeada.** Removidas todas as referências a "FuelRank" que
restavam no app (e-mails de exemplo, chave de armazenamento local) — tudo
agora usa "pmax360". Dados salvos de quem já usa o app continuam sendo lidos
normalmente.

**Ranking do Painel corrigido.** O gráfico "Ranking da equipe" comparava
atingimento sem tratar frentista sem lançamento no mês, o que bagunçava a
ordem. Agora ordena certo, do maior para o menor.

**"Melhor em" corrigido.** Os destaques do mural comparavam o atingimento
(%) de cada indicador em vez do valor bruto vendido, então às vezes mostravam
o frentista errado como líder. Agora cada indicador (volume, mix, aditivada,
carros, app) mostra quem realmente vendeu mais naquele indicador — igual à
tabela.

## Vem do v108

Lucro por combustível na aba Pricing, melhor produto por frentista na tabela
da equipe, lucro total (combustível + loja) no Histórico e na tela "Ver o
mês".

## Como publicar

Suba o conteúdo desta pasta na raiz do site, por cima do que está lá:

- `index.html` — o app inteiro
- `sw.js`, `versao.json`, `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

Ninguém reinstala nada: quem estiver com o app aberto vê o aviso de versão nova
e toca em Atualizar.
