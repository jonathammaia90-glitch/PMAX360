# PMAX360 · v96 — como publicar

Substitui o v91 ao v95. Publique só este.

## Correções do v96
- **Cinco grupos da loja não apareciam na aba Loja.** CERVEJAS, BALAS E DOCES,
  SNACKS E BISCOITOS, DROPS E PASTILHAS e SUCOS E ISOTONICOS não estavam na
  lista de subgrupos do posto, então R$ 12,7 mil do mês ficavam fora da quebra
  por subgrupo (o total do dia estava certo, mas as linhas não somavam o dia).
  Os cinco já foram cadastrados no banco — nada a fazer.
- **A aba Produtos não explicava por que o bloco da loja estava vazio.** Agora,
  enquanto o `15-produtos-loja.sql` não for rodado, aparece um aviso dizendo o
  que falta.

## Novo no v95 — troca de óleo refeita pelo relatório
As trocas de 08/2026 foram reconstruídas a partir do relatório de vendas
automotivas, que é quem sabe de fato o que cada um vendeu. Só **GILSON e
VALMIRSON são trocadores**; quando um frentista vende óleo **com filtro**, a
troca entra como **troca puxada** — conta no faturamento do mês e no crédito de
quem puxou, mas fica fora do ranking de trocador.

Como ficou o mês (38 trocas, R$ 10.253,04):

- VALMIRSON — 12 trocas, R$ 4.398,11
- GILSON — 18 trocas, R$ 3.772,35
- puxadas: JOSLEY 4 (R$ 832,80) · GERALDO 2 (R$ 704,82) · MICHAEL 1 (R$ 344,96)
  · JESSIKA 1 (R$ 254,60)

Duas coisas que estavam erradas e saíram: a troca de 21/08 lançada à mão
(R$ 629,30, cliente jefferson) era a mesma do relatório em 24/08 (R$ 629,93) —
o cliente foi transferido para a linha do relatório e a duplicata apagada. E as
vendas de óleo **sem filtro** feitas por frentista não são mais contadas como
troca; elas continuam no automotivo da pessoa.

No ranking a troca puxada aparece com o selo TROCA PUXADA, e na lista de trocas
do carro o nome vem com "· puxada".

Lembrando: no automotivo do mês o GILSON é o maior vendedor (R$ 5.420,70,
contra R$ 4.684,69 do VALMIRSON) — automotivo inclui aditivo, arla, palheta e
tudo mais, não só o óleo da troca.


## O que já está no banco (não precisa fazer nada)
Apurei os três relatórios de 01/08 a 26/08 e gravei direto no Supabase:

- **Loja, 26 dias completos** — R$ 106.428,31 de venda e R$ 66.591,26 de custo,
  agora com a **quebra por grupo em todos os dias** (antes só 24 e 25/08 tinham).
  O 26/08 entrou (faltava) e dez dias foram corrigidos para o valor do
  relatório.
- **Combustível por frentista, dia por dia** — 168 lançamentos: litros,
  aditivada, mix e carros de cada um. Total 200.835 L no mês (o posto marcava
  151.594 L) e 12.635 carros.
- **Automotivo por pessoa** — o mês inteiro, com o detalhe de cada produto:
  GILSON R$ 5.420,70 · VALMIRSON R$ 4.684,69 · JOSLEY R$ 1.855,23 ·
  MICHAEL R$ 1.641,92 · GERALDO R$ 1.523,20 · JESSIKA R$ 707,35 ·
  FERNANDA R$ 602,47 · LAURI R$ 230,69.

Como o arquivo não traz custo por item, o custo de cada grupo foi rateado pela
participação na venda do dia, e o custo do 26/08 foi estimado pela margem média
do mês (62,6%). Os totais de venda são exatos.

Ficaram fora da equipe (aparecem no relatório mas não têm cadastro): BRUNA,
JULIANA, ISABELA, JONATHAN, DAIANA, GRACIELLE, VANESSA e as vendas sem
vendedor definido.

## Novo no app — produtos da loja
A aba **Produtos** ganhou o bloco **PRODUTO DA LOJA**, com três visões:

- **Mais vendidos** — os 40 que mais faturam.
- **Menos vendidos** — os 40 de menor faturamento, para achar o que está
  encalhado.
- **Por grupo** — Tabacaria, Padaria, Cervejas, Chocolate e as outras 17.

Mais quatro números no topo: loja no mês, produto campeão, grupo líder e quantos
itens saíram com 2 unidades ou menos.

No mês: 695 produtos diferentes. Campeão CIG PM L M BLUE FIRST CUT
(R$ 11.033). Tabacaria é metade da loja (R$ 53.553).

## 1. Repositório (GitHub Desktop)
Repositório: `jonathammaia90-glitch/PMAX360`, branch `main`. Copie para a **raiz**:

- `index.html`, `sw.js`, `versao.json`, `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

Commit → "PMAX360 v96" → Push origin.

## 2. Supabase — rode `15-produtos-loja.sql`
**Este é obrigatório para o bloco da loja aparecer.** Ele cria a coluna
`produtos_loja` e grava os 695 produtos. SQL Editor → cole → Run.

Opcional: `12-papel-trocador.sql` (libera o papel `Trocador` no banco).

## 3. Conferir
Abra o app, toque em **Atualizar** e confira `v96` no rodapé.

- **Troca de óleo** → o ranking com as puxadas marcadas.
- **Produtos** → o bloco PRODUTO DA LOJA com os três botões.
- **Loja** → 26 dias, cada um com os grupos.
- **Equipe** → litros, mix, carros e automotivo de cada frentista no mês.

## Correções que vieram nas versões anteriores
- **v95** — trocas de óleo refeitas pelo relatório, com troca puxada.
- **v94** — bloco de produtos da loja e os dados de 01 a 26/08 no banco.
- **v93** — o botão do catálogo Tecfil aponta para `catalogo.tecfil.com.br`
  (busca por placa); o endereço antigo saiu do ar.
- **v92** — cadastro da equipe não subia para o banco quando a função era
  trocador de óleo, então a pessoa não conseguia fazer login em outro celular.
- **v91** — importar faturamento da loja apagava os dias já lançados no mês.
  Agora um arquivo com data mexe só nos dias que ele traz.

## Ao gerar um pacote novo
- `var VERSAO` no topo do `index.html` e o número do `versao.json` têm que ser o
  mesmo. Se o index ficar atrás, o app pede atualização para sempre.
- O empacotador sobrescreve o `<head>`: reaplique o título PMAX360, o fundo
  `#0d0d0d` e as tags de PWA (feito neste pacote).
