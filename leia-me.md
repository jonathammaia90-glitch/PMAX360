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

## Limite importante

Os dados ficam salvos no próprio aparelho e sobrevivem a fechar o app, mas não são compartilhados: o lançamento feito no celular do gerente não aparece no do frentista. Para a rede operar de verdade é preciso backend com login e banco de dados.

## Caminho para as lojas

Este mesmo `index.html` empacota com Capacitor (`npx cap init`, `npx cap add android/ios`) e vira AAB para a Play Store e IPA para a App Store. Exige contas de desenvolvedor (Google, US$ 25 único; Apple, US$ 99/ano) e revisão. O ícone 1024px para a ficha da App Store está em `icons/icon-1024.png`.

## Os dois endereços

Depois de publicar no GitHub Pages (Settings → Pages → branch `main`, pasta `/ (root)`):

- `https://<usuario>.github.io/<repo>/` — app mobile instalável (este `index.html`)
- `https://<usuario>.github.io/<repo>/web/` — painel web para desktop

O `.nojekyll` na raiz impede o Jekyll de processar os arquivos. Ao publicar uma versão nova, incremente `CACHE` em `sw.js` para o PWA baixar a atualização; o service worker ignora o que está em `/web/`.

A interface segue o design system Nocturne — cores, tipografia, raios e sombras vêm dos seus tokens, já embutidos nos arquivos.
