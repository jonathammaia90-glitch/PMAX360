# PMAX360 · v106 — como publicar

Substitui todos os pacotes anteriores. Publique só este.

## O que mudou no v106

**Fechamento por área.** A aba Fechamento agora lista quatro áreas — Equipe,
Loja, Automotivo e Troca de óleo. Cada uma mostra o que vai pro histórico e tem
"Fechar área" com confirmação em dois toques. Ao fechar, o bloco daquela área
entra no histórico do mês na hora, com quem fechou e quando. "Reabrir" refaz o
bloco com os dados de agora. Nenhum lançamento do dia a dia é alterado.

Quem pode fechar: gerente, administrador (que ganhou a aba Fechamento) e
proprietário.

**Histórico com o mês em curso.** O mês corrente aparece marcado "em curso" com
o contador "X de 4 áreas" assim que a primeira área fecha, e "Ver o mês" abre a
leitura completa antes de o mês terminar. As comparações "vs mês anterior"
ignoram esse registro parcial — só olham meses fechados de verdade.

**Fechar mês absorve as áreas já fechadas** e continua sendo o único lugar que
avança o mês.

## Vem do v105

- Aba "Fechar mês" própria do gerente; ao fechar, o app cai na aba Importar.
- O fechamento guarda o mês inteiro: metas vigentes, litros por combustível,
  loja com dia a dia e subgrupos, trocas com faturamento, preços e NF, e a
  equipe com função, turno, dias lançados e todos os indicadores.
- Botão "Ver o mês" em cada linha do Histórico.

## Como publicar

Suba o conteúdo desta pasta na raiz do site, por cima do que está lá:

- `index.html` — o app inteiro
- `sw.js`, `versao.json`, `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

Ninguém reinstala nada: quem estiver com o app aberto vê o aviso de versão nova
e toca em Atualizar.
