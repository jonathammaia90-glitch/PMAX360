# PMAX360 · v93 — como publicar

Este pacote **substitui o v91 e o v92** (tem tudo). Publique só este.

## Novo no v93 — link do catálogo Tecfil
O endereço antigo (`tecfil-catalago.gruposofape.com.br`) saiu do ar. O botão na
tela de lançar troca agora abre o catálogo atual, `catalogo.tecfil.com.br`, que
tem **busca por placa** — o rótulo passou a ser "↗ Catálogo Tecfil (busca por
placa)".

## Do v92 — cadastro da equipe não entrava no login
A tabela `contas` do Supabase aceita só os papéis `Proprietário`,
`Administrador`, `Gerente` e `Frentista`. Quando o app cadastrava **trocador de
óleo**, gravava `Trocador` e o banco recusava a linha: o acesso aparecia no
aparelho de quem cadastrou e nunca subia, então em outro celular a pessoa não
existia e o login não entrava.

Agora o app grava o trocador como `Frentista` no banco e recupera o papel real
da função dele na equipe. Quem for liberado em "Liberar acesso de trocador"
também passa a ter linha na equipe automaticamente.

**Recadastrar quem ficou de fora:** aba **Equipe** → *Editar* na pessoa →
salvar. A coluna ACESSO mostra "sem acesso" para quem falta.

Opcional: `12-papel-trocador.sql` libera o valor `Trocador` no banco. O app
funciona sem rodar.

## Do v91 — importar loja apagava dias já lançados
O modo vinha em "Substituir o mês" e trocava **todos** os dias de loja do mês
pelos do arquivo.

- Arquivo **com data**: mexe só nos dias que ele traz.
- Arquivo **sem data** (fechamento): "Substituir o mês inteiro", "Gravar só em
  DD/MM/AAAA" ou "Somar em DD/MM/AAAA".
- O modo aplicado é sempre o que está marcado na tela.

Para ver o que foi perdido e o que dá para recuperar, rode
`13-conferir-dias-loja.sql` no Supabase. Se ele mostrar dias no backup antigo,
rode em seguida `migracao/08-recuperar-dias-loja.sql` (não apaga nada).

## 1. Repositório (GitHub Desktop)
Repositório: `jonathammaia90-glitch/PMAX360`, branch `main`.
Copie para a **raiz** do repositório, por cima dos anteriores:

- `index.html`
- `sw.js`
- `versao.json`
- `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

(Os dois `.sql` não vão para o repositório — são só para o Supabase.)

Depois: Commit → "PMAX360 v93" → Push origin.

## 2. Conferir
Abra o app, toque em **Atualizar** e confira `v93` no rodapé.

- Troca de óleo → Lançar troca → "↗ Catálogo Tecfil (busca por placa)" tem que
  abrir o catálogo novo.
- Cadastre alguém na equipe, saia e entre com o e-mail dela: tem que pedir para
  criar a senha.
- Lance um dia de loja na mão, importe um relatório de outro dia e veja se o dia
  lançado na mão continua na aba Loja.

## Ao gerar um pacote novo
- `var VERSAO` no topo do `index.html` e o número do `versao.json` têm que ser o
  mesmo. Se o index ficar atrás, o app pede atualização para sempre.
- O empacotador sobrescreve o `<head>`: reaplique o título PMAX360, o fundo
  `#0d0d0d` e as tags de PWA (feito neste pacote).
