# PMAX360 · v105 — como publicar

Substitui todos os pacotes anteriores. Publique só este.

## O que mudou no v105

**Aba "Fechar mês".** O fechamento do mês saiu de dentro do painel e virou aba
própria do gerente, entre Carros e Histórico. Abre direto na tela de
confirmação em dois toques; ao fechar, o app já cai na aba Importar para você
subir os relatórios do mês novo.

**O fechamento passou a guardar o mês inteiro.** Antes ia para o histórico só o
resumo. Agora vai: metas vigentes do mês, volume, mix, litros de gasolina
comum, aditivada, etanol e diesel, carros, automotivo, cadastros no app,
venda/custo/lucro da loja com o dia a dia, subgrupos, trocas de óleo com
faturamento, preços e custo da NF, e a equipe com função, turno, dias lançados
e todos os indicadores de cada pessoa.

**Histórico: botão "Ver o mês" em cada linha.** Abre a leitura completa do mês
fechado — cards de realizado vs meta com atingimento, venda por subgrupo da
loja, como cada frentista fechou e a tabela dia a dia da loja. Só leitura, com
"← Voltar ao histórico".

Meses fechados antes desta versão não têm metas nem dia a dia gravados: a tela
mostra os totais que existem e avisa na tabela de dias.

## Como publicar

Suba o conteúdo desta pasta na raiz do site, por cima do que está lá:

- `index.html` — o app inteiro
- `sw.js`, `versao.json`, `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

Ninguém reinstala nada: quem estiver com o app aberto vê o aviso de versão nova
e toca em Atualizar.
