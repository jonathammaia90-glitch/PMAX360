# PMAX360 · v91 — como publicar

## O que este pacote corrige
**Importar faturamento da loja apagava os dias já lançados no mês.**

O modo de gravação vinha em "Substituir o mês" e ele trocava *todos* os dias de
loja do mês pelos dias do arquivo. Quem lançou os dias na mão e depois importou
um relatório perdeu os lançamentos que não estavam no arquivo — foi isso que
sumiu.

Agora:

- **Arquivo com data** (uma linha por dia): mexe **só nos dias que ele traz**.
  Os outros dias do mês continuam como estão. Os dois modos são "Somar nos dias
  do arquivo" e "Substituir os dias do arquivo".
- **Arquivo sem data** (fechamento do mês): três modos — "Substituir o mês
  inteiro" (o comportamento antigo, correto aqui porque o fechamento já contém
  o mês todo), "Gravar só em DD/MM/AAAA" e "Somar em DD/MM/AAAA".
- O aviso na tela de importação passou a dizer exatamente o que cada modo faz.

## Sobre os dias que já sumiram
O app grava direto no Supabase, então os dias apagados não voltam sozinhos. É
preciso relançar na mão os dias que faltam (aba **Loja** → "＋ Lançar
faturamento por subgrupo"), ou importar de novo o relatório diário que os
contenha — agora sem risco de apagar o resto.

## 1. Repositório (GitHub Desktop)
Repositório: `jonathammaia90-glitch/PMAX360`, branch `main`.
Copie estes arquivos para a **raiz** do repositório, por cima dos anteriores:

- `index.html`
- `sw.js`
- `versao.json`
- `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

Depois: Commit → "PMAX360 v91" → Push origin.

## 2. Supabase
Nada a rodar. O v91 não muda o banco.

## 3. Conferir
Abra o app, toque em **Atualizar** e confira o rótulo `v91` no rodapé.
Teste: lance um dia de loja na mão, importe um relatório de outro dia e veja se
o dia lançado na mão continua na aba Loja.

## Ao gerar um pacote novo
- `var VERSAO` no topo do `index.html` e o número do `versao.json` têm que ser o
  mesmo. Se o index ficar atrás, o app pede atualização para sempre.
- O empacotador sobrescreve o `<head>`: reaplique o título PMAX360, o fundo
  `#0d0d0d` e as tags de PWA (feito neste pacote).
