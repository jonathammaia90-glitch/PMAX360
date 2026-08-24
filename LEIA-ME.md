# PMAX360 · v87 — como publicar

## 1. Repositorio (GitHub Desktop)
Copie estes arquivos para a pasta `site2/` do repositorio, substituindo os antigos:

- `index.html`
- `sw.js`
- `versao.json`

Nao mexa nos outros arquivos de `site2/` (manifest.webmanifest, icones).
Depois: Commit -> "PMAX360 v87" -> Push origin.

## 2. Logo e icones
O logo novo entra como `logo.png` e `apple-touch-180.png`.
Os icones do PWA (`icon-192.png`, `icon-512.png`, `maskable-512.png`) ainda sao os antigos —
se quiser trocar, gere nesses tamanhos a partir do logo novo e substitua em `site2/`.

## 3. Supabase
No SQL Editor, cole e execute `migracao/10-v87-tudo-junto.sql` (uma vez).
Ele roda as migracoes 09, 08 e 07 na ordem certa. Nenhuma apaga dados.

## 4. Conferir
Abra o app e recarregue. Deve aparecer PMAX360 com o logo novo.
Dados salvos e logins continuam os mesmos (a chave local segue `fuelrank.web.v4`
e os emails seguem `@fuelrank.com` — de proposito).
