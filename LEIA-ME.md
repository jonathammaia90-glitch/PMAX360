# PMAX360 · v90 — como publicar

## 1. Repositório (GitHub Desktop)
Repositório: `jonathammaia90-glitch/PMAX360`, branch `main`.
Copie estes arquivos para a **raiz** do repositório, por cima dos anteriores:

- `index.html`
- `sw.js`
- `versao.json`
- `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

Depois: Commit → "PMAX360 v90" → Push origin.

Este pacote **substitui o v88 e o v89**. Se você não publicou nenhum dos dois,
publique só este — tem tudo.

## 2. Supabase
Nada a rodar. O v90 não muda o banco.

Pendentes do v87, se ainda não rodou: `migracao/10-v87-tudo-junto.sql` e, para
virar os logins para `@pmax.com`, `migracao/11-dominio-pmax.sql`.

## 3. Conferir
Abra o app e toque em Atualizar. Não precisa reinstalar.

### Abas novas
- **Produtos** (gerente): total de automotivos contra a meta, produto líder,
  maior vendedor; a lista de todo mundo com o que cada um mais vende; e a
  tabela por produto com faturamento, quantidade, quantas pessoas vendem
  aquilo e quem vende mais.
- **Carros** (gerente e trocador): busca por placa, cliente, telefone, óleo ou
  código de filtro. Abrindo o carro, a ficha traz todas as trocas dele, óleo,
  filtro, quanto já rendeu, quando vence o retorno, a mensagem de WhatsApp
  pronta e o botão "Lançar troca deste carro" já preenchido.

### Na troca de óleo
- Painel de WhatsApp na tela de lançar, com **ORÇAMENTO** e **COMPROVANTE**
  (troca nova abre no orçamento; editando uma salva, no comprovante). Com o
  telefone preenchido abre direto na conversa do cliente.
- `↗ Catálogo Tecfil` e `↗ Consultar óleo do carro` no rodapé do formulário.
- Painel "QUEM ESTÁ GERANDO NA TROCA DE ÓLEO" para o gerente.
- Filtros e óleos que mais saem passaram a mostrar 4 linhas em vez de 6 e 8.

### Na equipe e nos números
- **Equipe**: painel "VENDA AUTOMOTIVA POR PESSOA", com o que cada um mais vende.
- **Frentista → Meus números**: painel "MEUS PRODUTOS QUE MAIS VENDO".

## Detalhe do WhatsApp
No celular o botão usa o esquema nativo do WhatsApp (`whatsapp://send`), que é
mais confiável dentro do app instalado; no computador usa `wa.me`. Nos dois
casos o texto é copiado ao clicar, então o botão "Copiar texto" é reserva.

## Correções do empacotamento aplicadas aqui
O `index.html` gerado vem com `<title>Bundled Page</title>`, fundo claro na tela
de carregamento e sem as tags de PWA no `<head>`. Corrigidos à mão neste pacote.
**Ao gerar um pacote novo, reaplique isso** — o empacotador sobrescreve o `<head>`.

## Limitações conhecidas
- A aba Carros cobre o mês corrente. Ao fechar o mês as trocas individuais saem
  e ficam só os totais, então não há histórico por placa entre meses. Mudar isso
  é alteração no banco.
- A troca guarda um nome só: o frentista que puxa a venda e o trocador que faz o
  serviço dividem o mesmo campo. Quem puxou pode aparecer no painel dos trocadores.
