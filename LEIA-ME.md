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

## Etapa 2 — Mudar o cadastro para as tabelas novas

Eu reescrevo a parte do app que salva postos, contas e equipe. Os lançamentos continuam no formato antigo por enquanto — assim, se algo der errado, dá para voltar sem perder movimento.

Junto vai um script que **copia os dados de hoje** para as tabelas novas, sem digitação manual.

## Etapa 3 — Mudar os lançamentos

A parte que mais pesa. Cada lançamento vira uma linha própria. Aqui somem a lentidão e o risco de sobrescrita.

Depois disso, aperto as regras de acesso: cada gerente passa a enxergar só o posto dele, cada frentista só os próprios números.

## Etapa 4 — Desligar o bloco antigo

Confirmado que tudo está nas tabelas novas, a `fuelrank_estado` sai de cena. Guardo uma cópia antes.

---

## Sobre perder dados

Em nenhuma etapa algo é apagado. A tabela antiga só sai na Etapa 4, e com backup. Se qualquer etapa der problema, a anterior continua funcionando.

## Chave do banco

A chave que está dentro do app é a chave **pública** do Supabase — ela é feita para ficar visível, e é por isso que as regras de acesso (RLS) importam. A Etapa 3 é o que realmente tranca a porta. Nunca coloque a chave `service_role` no app.
