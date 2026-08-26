# PMAX360 · v92 — como publicar

Este pacote **substitui o v91** (tem as duas correções). Se você ainda não
publicou o v91, publique só este.

## Correção 1 — cadastro da equipe não entrava no login
A tabela `contas` do Supabase foi criada aceitando só os papéis
`Proprietário`, `Administrador`, `Gerente` e `Frentista`. Quando o app passou a
cadastrar **trocador de óleo**, ele gravava o papel `Trocador` — e o banco
recusava a linha. Resultado: a pessoa aparecia cadastrada no aparelho de quem
cadastrou, mas o acesso nunca subia, então em qualquer outro celular ela não
existia e o login não entrava.

Agora o app grava o trocador como `Frentista` no banco e recupera o papel real
da função da pessoa na equipe — não depende mais do banco. Além disso, quem for
liberado em "Liberar acesso de trocador" passa a ter linha na equipe
automaticamente (sem ela o acesso voltava como frentista).

**Recadastrar quem ficou de fora:** abra **Equipe**, toque em *Editar* na pessoa
e salve — ou cadastre de novo. O acesso sobe na hora. A coluna ACESSO da tabela
mostra "sem acesso" para quem ainda não subiu.

Opcional: `migracao/12-papel-trocador.sql` (incluído neste pacote) libera o
valor `Trocador` no banco. O app funciona sem rodar, mas rodar deixa o banco
coerente com o app.

## Correção 2 — importar loja apagava dias já lançados (era o v91)
O modo vinha em "Substituir o mês" e trocava **todos** os dias de loja do mês
pelos dias do arquivo. Quem lançou dias na mão e depois importou perdeu os
lançamentos que não estavam no arquivo.

- Arquivo **com data**: mexe só nos dias que ele traz.
- Arquivo **sem data** (fechamento): "Substituir o mês inteiro", "Gravar só em
  DD/MM/AAAA" ou "Somar em DD/MM/AAAA".
- O modo aplicado é sempre o que está marcado na tela.

Os dias já apagados não voltam sozinhos: relance na aba **Loja** ou reimporte o
relatório diário que os contenha.

## 1. Repositório (GitHub Desktop)
Repositório: `jonathammaia90-glitch/PMAX360`, branch `main`.
Copie para a **raiz** do repositório, por cima dos anteriores:

- `index.html`
- `sw.js`
- `versao.json`
- `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

(`12-papel-trocador.sql` não vai para o repositório — é só para o Supabase.)

Depois: Commit → "PMAX360 v92" → Push origin.

## 2. Supabase
Opcional: `12-papel-trocador.sql`.

## 3. Conferir
Abra o app, toque em **Atualizar** e confira `v92` no rodapé.

- Cadastre alguém na equipe, saia e entre com o e-mail dela: tem que pedir para
  criar a senha no primeiro acesso.
- Lance um dia de loja na mão, importe um relatório de outro dia e veja se o dia
  lançado na mão continua na aba Loja.

## Ao gerar um pacote novo
- `var VERSAO` no topo do `index.html` e o número do `versao.json` têm que ser o
  mesmo. Se o index ficar atrás, o app pede atualização para sempre.
- O empacotador sobrescreve o `<head>`: reaplique o título PMAX360, o fundo
  `#0d0d0d` e as tags de PWA (feito neste pacote).
