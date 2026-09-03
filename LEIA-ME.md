# PMAX360 · v108 — como publicar

Substitui todos os pacotes anteriores. Publique só este.

## O que mudou no v108

**Lucro por combustível.** Nova leitura na aba Pricing: margem por litro ×
litros vendidos de cada combustível (comum, aditivada, etanol, diesel S10),
comparando o mês atual com o mês anterior fechado.

**Melhor produto por frentista.** A tabela de lançamento da equipe agora tem a
coluna "Melhor produto", com o item automotivo que cada um mais vende (vem do
relatório de vendas por vendedor importado).

**Histórico com lucro total.** A aba Histórico e a tela "Ver o mês" agora
separam margem de combustível e lucro de loja, somando os dois num lucro
total — incluindo média diária de combustível e lucro por produto de
combustível no mês fechado.

## Vem do v107

Corrigido o mês inicial do posto de demonstração, que estava fixo em 08/2026.

## Como publicar

Suba o conteúdo desta pasta na raiz do site, por cima do que está lá:

- `index.html` — o app inteiro
- `sw.js`, `versao.json`, `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

Ninguém reinstala nada: quem estiver com o app aberto vê o aviso de versão nova
e toca em Atualizar.
