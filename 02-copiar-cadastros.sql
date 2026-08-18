-- ============================================================
-- FuelRank — Etapa 2: copiar os cadastros para as tabelas novas
-- Cole no SQL Editor do Supabase e clique em Run.
-- Lê o que já existe em fuelrank_estado e preenche postos, contas e equipe.
-- Nada é apagado. Pode rodar quantas vezes quiser: atualiza em vez de duplicar.
-- ============================================================

with estado as (
  select dados from public.fuelrank_estado where id = 'rede' limit 1
),
p as (
  select j as posto
  from estado, jsonb_array_elements(coalesce(dados->'postos','[]'::jsonb)) as j
)
insert into public.postos (id, nome, gerente, cadastro, mes, metas, subgrupos, precos, nf, concorrentes)
select
  (posto->>'id')::bigint,
  coalesce(posto->>'nome','Sem nome'),
  posto->>'gerente',
  posto->>'cadastro',
  posto->>'mes',
  coalesce(posto->'metas','{}'::jsonb),
  coalesce(posto->'subgrupos','[]'::jsonb),
  coalesce(posto->'precos','{}'::jsonb),
  coalesce(posto->'nf','{}'::jsonb),
  coalesce(posto->'concorrentes','[]'::jsonb)
from p
where posto->>'id' is not null
on conflict (id) do update set
  nome         = excluded.nome,
  gerente      = excluded.gerente,
  cadastro     = excluded.cadastro,
  mes          = excluded.mes,
  metas        = excluded.metas,
  subgrupos    = excluded.subgrupos,
  precos       = excluded.precos,
  nf           = excluded.nf,
  concorrentes = excluded.concorrentes;

-- ---------- EQUIPE ----------
with estado as (
  select dados from public.fuelrank_estado where id = 'rede' limit 1
),
p as (
  select j as posto
  from estado, jsonb_array_elements(coalesce(dados->'postos','[]'::jsonb)) as j
),
f as (
  select (posto->>'id')::bigint as posto_id, e as pessoa
  from p, jsonb_array_elements(coalesce(posto->'equipe','[]'::jsonb)) as e
)
insert into public.equipe (id, posto_id, nome, email, funcao, turno)
select
  (pessoa->>'id')::bigint,
  posto_id,
  coalesce(pessoa->>'nome','Sem nome'),
  pessoa->>'email',
  pessoa->>'funcao',
  pessoa->>'turno'
from f
where pessoa->>'id' is not null
on conflict (id) do update set
  posto_id = excluded.posto_id,
  nome     = excluded.nome,
  email    = excluded.email,
  funcao   = excluded.funcao,
  turno    = excluded.turno;

-- ---------- CONTAS ----------
with estado as (
  select dados from public.fuelrank_estado where id = 'rede' limit 1
),
c as (
  select j as conta
  from estado, jsonb_array_elements(coalesce(dados->'contas','[]'::jsonb)) as j
)
insert into public.contas (usuario, nome, papel, senha, posto_id)
select
  lower(conta->>'user'),
  coalesce(conta->>'nome', conta->>'user'),
  case conta->>'role'
    when 'Proprietário'  then 'Proprietário'
    when 'Administrador' then 'Administrador'
    when 'Gerente'       then 'Gerente'
    when 'Frentista'     then 'Frentista'
    else 'Frentista'
  end,
  conta->>'senha',
  nullif(conta->>'postoId','')::bigint
from c
where conta->>'user' is not null
on conflict (usuario) do update set
  nome     = excluded.nome,
  papel    = excluded.papel,
  senha    = coalesce(excluded.senha, public.contas.senha),
  posto_id = excluded.posto_id;

-- ============================================================
-- CONFERÊNCIA — deve mostrar os mesmos números que você vê no app
-- ============================================================
select 'postos'  as tabela, count(*) as registros from public.postos
union all
select 'equipe',  count(*) from public.equipe
union all
select 'contas',  count(*) from public.contas;
