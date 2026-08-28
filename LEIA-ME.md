# PMAX360 · v101 — como publicar

Substitui todos os pacotes anteriores. Publique só este.

## O que mudou no v101

**Venda automotiva: trocador compete com trocador, frentista com frentista.**
A venda de pista é menor por natureza, então misturar os dois num ranking só
comparava coisas diferentes. Agora o bloco VENDA AUTOMOTIVA POR PESSOA (abas
Produtos e Equipe) vem em duas faixas — TROCADORES DE ÓLEO e FRENTISTAS — com
posição, participação e a marca de maior venda calculadas dentro do grupo.

**Volume, aditivada, mix, carros e cadastros no app continuam com todos juntos**
num ranking único.

**Mural do posto:**
- quadro novo VENDA AUTOMOTIVA, com as duas faixas e só o total de cada pessoa;
- o destaque da equipe e os "melhor em" passam a sair de volume, aditivada, mix,
  carros e app — sem o automotivo, que tem o quadro próprio;
- quem é da troca de óleo aparece marcado com ÓLEO ao lado do nome;
- o card de projeção de fechamento saiu.

**Do v100, que segue valendo:** a importação do relatório de litros não escreve
mais em carros abastecidos nem em cadastros no app, e no modo Substituir o total
já lançado nesses dois campos é preservado.

## Como publicar

Suba o conteúdo desta pasta na raiz do site, por cima do que está lá:

- `index.html` — o app inteiro
- `sw.js`, `versao.json`, `manifest.webmanifest`
- `icon-192.png`, `icon-512.png`, `maskable-512.png`, `apple-touch-180.png`

Ninguém reinstala nada: quem estiver com o app aberto vê o aviso de versão nova
e toca em Atualizar.

O `16-recuperar-carros-app.sql` é só para rodar no Supabase, se ainda precisar
devolver carros e app de dias antigos. Não precisa subir.
