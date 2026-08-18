# Migração do FuelRank para 200 postos

Plano em quatro etapas. O app fica no ar entre elas — nada some do dia para a noite.

---

## Onde estamos hoje

Toda a rede é gravada como **um único bloco de texto** numa linha da tabela `fuelrank_estado`. Cada save reescreve o bloco inteiro. Funciona bem até uns 10 ou 15 postos.

## Onde queremos chegar

Cada coisa na sua tabela. O app busca só o que a tela precisa. Dois gerentes podem lançar ao mesmo tempo sem um apagar o outro.

---

## Etapa 1 — Criar a estrutura *(arquivo pronto)*

**O que você faz:**

1. Entre em https://supabase.com e abra o projeto do FuelRank.
2. No menu da esquerda, clique em **SQL Editor**.
3. Clique em **New query**.
4. Abra o arquivo `01-estrutura.sql`, copie **tudo** e cole na caixa.
5. Clique em **Run** (ou Ctrl+Enter).

Deve aparecer "Success. No rows returned". Pronto.

**O que isso faz:** cria as tabelas vazias ao lado das que já existem. **Não apaga nada** e **não muda o app** — ele continua funcionando exatamente como hoje. É seguro rodar mais de uma vez.

As tabelas criadas:

| Tabela | Guarda |
| --- | --- |
| `postos` | cadastro do posto, metas do mês, preços, custo de NF, concorrentes |
| `contas` | quem entra no app, com papel e posto |
| `equipe` | frentistas de cada posto, com turno |
| `lancamentos` | um registro por frentista, por dia |
| `dias_loja` | fechamento diário da conveniência |
| `resumo_mes` | soma automática do mês, usada no ranking |

---

## Etapa 2 — Copiar os cadastros *(arquivo pronto)*

**O que você faz:** mesma coisa da etapa 1, com o arquivo `02-copiar-cadastros.sql`. SQL Editor → New query → colar tudo → Run.

No fim aparece uma tabelinha assim:

| tabela | registros |
| --- | --- |
| postos | 3 |
| equipe | 24 |
| contas | 9 |

Confira se os números batem com o que você vê no app (quantos postos, quantos frentistas somando todos, quantos acessos). Se bater, a cópia deu certo.

**O que isso faz:** lê os dados que já estão no app e preenche as tabelas novas. **Não apaga nada** e **não muda o app** — ele continua lendo do bloco antigo. Pode rodar de novo depois de cadastrar mais gente; atualiza em vez de duplicar.

Os lançamentos e o fechamento de loja ficam para a etapa 3, junto com a mudança no app — assim, se algo der errado, nenhum movimento se perde.

## Etapa 3 — Mudar o app para as tabelas novas

Aqui eu mexo no app: ele passa a ler e gravar nas tabelas em vez do bloco único, e cada lançamento vira uma linha própria. É onde somem a lentidão e o risco de um gerente apagar o lançamento do outro.

Junto vai o script que copia os lançamentos e o fechamento de loja, e o aperto nas regras de acesso: cada gerente enxerga só o posto dele, cada frentista só os próprios números.

Você recebe um `index.html` novo para subir, como sempre.

## Etapa 4 — Desligar o bloco antigo

Confirmado que tudo está nas tabelas novas, a `fuelrank_estado` sai de cena. Guardo uma cópia antes.

---

## Sobre perder dados

Em nenhuma etapa algo é apagado. A tabela antiga só sai na Etapa 4, e com backup. Se qualquer etapa der problema, a anterior continua funcionando.

## Chave do banco

A chave que está dentro do app é a chave **pública** do Supabase — ela é feita para ficar visível, e é por isso que as regras de acesso (RLS) importam. A Etapa 3 é o que realmente tranca a porta. Nunca coloque a chave `service_role` no app.
