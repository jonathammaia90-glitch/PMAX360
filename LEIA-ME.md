# PMAX360 · v111 — como publicar

Substitui todos os pacotes anteriores. Publique só este.

## O que mudou no v111

Corrigido bug na importação de litragem por planilha (CSV): comum, etanol e
diesel eram lidos do arquivo mas nunca gravados no frentista — só volume,
aditivada e mix chegavam a salvar. Por isso o novo ranking "por combustível"
ficava vazio para comum/etanol/diesel mesmo com o arquivo certo. Agora os
4 combustíveis são gravados, nos dois modos (substituir e somar) e também
quando o arquivo é de um dia específico.

## Como publicar

Suba o conteúdo desta pasta na raiz do site, por cima do que está lá.
Ninguém reinstala nada: quem estiver com o app aberto vê o aviso de versão
nova e toca em Atualizar.
