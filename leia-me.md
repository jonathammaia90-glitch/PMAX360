# FuelRank — app instalável (PWA)

Conteúdo: `index.html` (o app inteiro, funciona offline), `manifest.webmanifest`, `sw.js`, `icons/`.

## Publicar (5 minutos, grátis)

O app precisa estar em um endereço HTTPS para instalar. Escolha um:

- **Netlify Drop** — abra app.netlify.com/drop e arraste a pasta `pwa` inteira. Ele devolve um endereço tipo `fuelrank.netlify.app`.
- **Vercel** ou **GitHub Pages** — mesmo princípio: suba a pasta como site estático.

Abrir o arquivo direto do celular (file://) mostra o app, mas **não** instala nem guarda offline — o navegador exige HTTPS para isso.

## Instalar no celular

- **Android (Chrome)** — abra o endereço, menu ⋮ → "Instalar app" / "Adicionar à tela inicial".
- **iPhone (Safari)** — abra o endereço, botão Compartilhar → "Adicionar à Tela de Início". Precisa ser o Safari.

Depois de instalado abre em tela cheia, com ícone próprio, sem barra de navegador, e funciona sem internet.

## Primeiro acesso

Entre como proprietário: **dono@fuelrank.app**, senha **123456**. Na aba Admins, use "Zerar dados de demonstração" para apagar os postos e acessos de exemplo, depois cadastre os administradores reais pelo e-mail do domínio. Cada convidado cria a própria senha no primeiro acesso.

Troque a senha do proprietário pelo fluxo "Esqueci minha senha" antes de distribuir o app.

## Sincronização

Todos os aparelhos leem e gravam no mesmo banco. O lançamento do gerente aparece no celular do frentista e no mural em até 20 segundos. Sem internet o app continua funcionando com o último dado recebido e reenvia sozinho ao reconectar.

O mural é somente leitura: ele nunca grava, apenas recebe. O selo no canto superior mostra `ATUALIZADO hh:mm`, `SEM CONEXÃO` ou `CONECTANDO…`.

## Caminho para as lojas

Este mesmo `index.html` empacota com Capacitor (`npx cap init`, `npx cap add android/ios`) e vira AAB para a Play Store e IPA para a App Store. Exige contas de desenvolvedor (Google, US$ 25 único; Apple, US$ 99/ano) e revisão. O ícone 1024px para a ficha da App Store está em `icons/icon-1024.png`.

## Os endereços definitivos

Publicado em GitHub Pages a partir de `jonathammaia90-glitch/fuelrank-app`, branch `main`, pasta `/ (root)`. Todos os endereços leem e gravam no mesmo banco.

| Para quem | Endereço |
| --- | --- |
| App instalável — proprietário, administrador, gerente e frentista | https://jonathammaia90-glitch.github.io/fuelrank-app/ |
| Mural do posto — tablet ou TV, sem login | https://jonathammaia90-glitch.github.io/fuelrank-app/#mural |
| Mural de um posto específico | https://jonathammaia90-glitch.github.io/fuelrank-app/#mural=ID_DO_POSTO |

O mesmo `index.html` atende celular, tablet e desktop — não existe endereço separado para web. O ID do posto aparece no cadastro do posto; sem ID o mural abre o primeiro da rede.

## Atualização

O app verifica versão nova a cada minuto e sempre que volta para a frente. Encontrando, baixa e recarrega sozinho — sem apagar nem reinstalar. Se houver formulário aberto, ele espera a tela ficar livre, e o rascunho fica salvo no aparelho.

Ao publicar uma versão nova, incremente `CACHE` em `sw.js`. É isso que dispara a atualização em todos os aparelhos.

A interface segue o design system Nocturne — cores, tipografia, raios e sombras vêm dos seus tokens, já embutidos nos arquivos.
