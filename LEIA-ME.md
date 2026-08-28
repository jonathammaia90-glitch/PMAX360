# PMAX360 · v100 — como publicar

Substitui o v91 ao v99. Publique só este.

## O que mudou: carros abastecidos e cadastros no app não somem mais

Era a importação do relatório de litros. No modo **Substituir** ela apagava os
dias lançados e regravava o mês só com os números do relatório — e como o
relatório não traz carros nem cadastros no app, esses dois campos iam a zero.

Corrigido:

- a importação **nunca escreve** em carros abastecidos nem em cadastros no app;
- no modo Substituir, o total que a pessoa já tinha nesses dois campos é
  guardado antes dos dias saírem, então nada se perde junto com os dias;
- a coluna CARROS saiu da prévia da importação, e o aviso na tela agora diz que
  os dois campos são contagem da casa;
- o resto continua igual: volume, comum, aditivada, etanol, diesel e mix seguem
  vindo do relatório.

## Para trazer de volta o que já sumiu

Arquivo **16-recuperar-carros-app.sql**, incluído nesta pasta.

1. App fechado em todos os aparelhos.
2. SQL Editor do Supabase → cole e rode a **PARTE A** (só olha). Se a A2 mostrar
   linhas com `com_carros` ou `com_app` maiores que zero, o backup tem os dias
   e a recuperação funciona.
3. Rode a **PARTE B**. Ela grava só carros e app, e só onde o valor atual está
   vazio ou zero. Nada é apagado.
4. Rode a **PARTE C** para conferir.
5. Cada pessoa abre o app uma vez com internet.

Se a PARTE A vier vazia, o backup não tem os dias e o caminho é relançar à mão.

## Como publicar

Suba **o conteúdo desta pasta** para a raiz do site, por cima do que está lá:

- `index.html` — o app inteiro
- `sw.js`, `versao.json`, `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

Os `.sql` são só para você rodar no Supabase; não precisam subir.

Ninguém reinstala nada. Quem estiver com o app aberto vê o aviso de versão nova
e toca em Atualizar.

## Os outros SQL da pasta

- `12-papel-trocador.sql` — papel de trocador na equipe (já rodado, se foi o caso)
- `15-produtos-loja.sql` — produtos da loja (já rodado, se foi o caso)

Rodar de novo não faz mal: os dois são feitos para poder repetir.
