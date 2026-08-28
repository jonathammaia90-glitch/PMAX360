-- ============================================================
-- PMAX360 — Etapa 16: recuperar CARROS ABASTECIDOS e CADASTROS NO APP
-- Cole no SQL Editor do Supabase.
--
-- Por que: a importação do relatório de litros gravava por cima do
-- lançamento do dia e zerava dois campos que NÃO vêm de relatório —
-- carros abastecidos e cadastros no app. O app já foi corrigido
-- (v100): a importação não toca mais nesses dois. Este arquivo
-- devolve o que foi perdido, usando o backup fuelrank_estado.
--
-- RODE UMA PARTE DE CADA VEZ. A PARTE A só olha; a PARTE B grava
-- apenas carros/app e só onde o valor atual está vazio ou zero.
-- Nada é apagado.
--
-- IMPORTANTE: app FECHADO em todos os aparelhos até terminar.
-- Depois, cada pessoa abre o app uma vez com internet.
-- ============================================================


-- ============================================================
-- PARTE A — DIAGNÓSTICO (só leitura)
-- ============================================================

-- A1. Como está hoje: quantos dias por frentista têm carros e app.
select e.posto_id, e.nome,
       count(*)                                                          as dias,
       count(*) filter (where coalesce(l.indicadores->>'carros','') <> '') as dias_com_carros,
       count(*) filter (where coalesce(l.indicadores->>'app','') <> '')    as dias_com_app
from public.lancamentos l
join public.equipe e on e.id = l.frentista_id
group by e.posto_id, e.nome
order by 1, 2;

-- A2. O backup ainda tem carros/app nos dias? (é daqui que vem a volta)
select (j->>'id')::bigint as posto_id,
       f->>'nome'         as frentista,
       count(*)                                                        as dias_no_backup,
       count(*) filter (where coalesce(d->>'carros','') <> '')           as com_carros,
       count(*) filter (where coalesce(d->>'app','') <> '')              as com_app
from public.fuelrank_estado e,
     jsonb_array_elements(coalesce(e.dados->'postos','[]'::jsonb))   as j,
     jsonb_array_elements(coalesce(j->'equipe','[]'::jsonb))         as f,
     jsonb_array_elements(coalesce(f->'lanc','[]'::jsonb))           as d
where e.id = 'rede'
group by 1, 2
order by 1, 2;


-- ============================================================
-- PARTE B — RECUPERAÇÃO (grava só carros e app)
-- Rode só se a A2 mostrar linhas com com_carros/com_app > 0.
-- ============================================================
with estado as (select dados from public.fuelrank_estado where id = 'rede' limit 1),
p as (
  select (j->>'id')::bigint as posto_id, j->>'mes' as mes, j as posto
  from estado, jsonb_array_elements(coalesce(dados->'postos','[]'::jsonb)) as j
),
f as (
  select p.posto_id, p.mes, (x->>'id')::bigint as frentista_id, x as pessoa
  from p, jsonb_array_elements(coalesce(p.posto->'equipe','[]'::jsonb)) as x
),
d as (
  select f.posto_id, f.frentista_id, f.mes, y as dia
  from f, jsonb_array_elements(coalesce(f.pessoa->'lanc','[]'::jsonb)) as y
),
n as (
  select posto_id, frentista_id,
    case
      when dia->>'data' ~ '^\d{4}-\d{1,2}-\d{1,2}$'
        then to_date(dia->>'data','YYYY-MM-DD')
      when dia->>'data' ~ '^\d{1,2}/\d{1,2}/\d{4}$'
        then to_date(dia->>'data','DD/MM/YYYY')
      when dia->>'data' ~ '^\d{1,2}/\d{1,2}/\d{2}$'
        then to_date(regexp_replace(dia->>'data','/(\d{2})$','/20\1'),'DD/MM/YYYY')
      when dia->>'data' ~ '^\d{1,2}/\d{1,2}$' and mes ~ '^\d{1,2}/\d{4}$'
        then to_date((dia->>'data') || '/' || split_part(mes,'/',2),'DD/MM/YYYY')
      when dia->>'data' ~ '^\d{1,2}$' and mes ~ '^\d{1,2}/\d{4}$'
        then to_date(lpad(dia->>'data',2,'0') || '/' || mes,'DD/MM/YYYY')
      else null
    end                              as dia_norm,
    nullif(trim(coalesce(dia->>'carros','')), '') as carros,
    nullif(trim(coalesce(dia->>'app','')), '')    as app
  from d
),
u as (
  select distinct on (posto_id, frentista_id, dia_norm)
         posto_id, frentista_id, dia_norm, carros, app
  from n
  where dia_norm is not null and (carros is not null or app is not null)
  order by posto_id, frentista_id, dia_norm
)
update public.lancamentos l
set indicadores = l.indicadores
  || case when u.carros is not null
            and coalesce(nullif(regexp_replace(coalesce(l.indicadores->>'carros',''), '[^0-9]', '', 'g'), ''), '0') = '0'
          then jsonb_build_object('carros', u.carros) else '{}'::jsonb end
  || case when u.app is not null
            and coalesce(nullif(regexp_replace(coalesce(l.indicadores->>'app',''), '[^0-9]', '', 'g'), ''), '0') = '0'
          then jsonb_build_object('app', u.app) else '{}'::jsonb end
from u
where l.posto_id = u.posto_id
  and l.frentista_id = u.frentista_id
  and l.dia = u.dia_norm;

-- B2. Dias que existiam no backup e não existem mais na tabela:
-- reinsere só com carros/app (combustível fica zerado de propósito,
-- porque o relatório é a verdade dele e já está gravado).
with estado as (select dados from public.fuelrank_estado where id = 'rede' limit 1),
p as (
  select (j->>'id')::bigint as posto_id, j->>'mes' as mes, j as posto
  from estado, jsonb_array_elements(coalesce(dados->'postos','[]'::jsonb)) as j
),
f as (
  select p.posto_id, p.mes, (x->>'id')::bigint as frentista_id, x as pessoa
  from p, jsonb_array_elements(coalesce(p.posto->'equipe','[]'::jsonb)) as x
),
d as (
  select f.posto_id, f.frentista_id, f.mes, y as dia
  from f, jsonb_array_elements(coalesce(f.pessoa->'lanc','[]'::jsonb)) as y
),
n as (
  select posto_id, frentista_id,
    case
      when dia->>'data' ~ '^\d{1,2}/\d{1,2}/\d{4}$' then to_date(dia->>'data','DD/MM/YYYY')
      when dia->>'data' ~ '^\d{4}-\d{1,2}-\d{1,2}$' then to_date(dia->>'data','YYYY-MM-DD')
      when dia->>'data' ~ '^\d{1,2}/\d{1,2}$' and mes ~ '^\d{1,2}/\d{4}$'
        then to_date((dia->>'data') || '/' || split_part(mes,'/',2),'DD/MM/YYYY')
      else null
    end as dia_norm,
    nullif(trim(coalesce(dia->>'carros','')), '') as carros,
    nullif(trim(coalesce(dia->>'app','')), '')    as app
  from d
),
u as (
  select distinct on (posto_id, frentista_id, dia_norm)
         posto_id, frentista_id, dia_norm, carros, app
  from n
  where dia_norm is not null and (carros is not null or app is not null)
  order by posto_id, frentista_id, dia_norm
)
insert into public.lancamentos (posto_id, frentista_id, dia, indicadores, criado_por)
select u.posto_id, u.frentista_id, u.dia_norm,
       coalesce(case when u.carros is not null then jsonb_build_object('carros', u.carros) else '{}'::jsonb end
             || case when u.app    is not null then jsonb_build_object('app',    u.app)    else '{}'::jsonb end,
             '{}'::jsonb),
       'recuperacao-16'
from u
on conflict (posto_id, frentista_id, dia) do nothing;

notify pgrst, 'reload schema';


-- ============================================================
-- PARTE C — CONFERÊNCIA (só leitura)
-- Repita a A1: dias_com_carros e dias_com_app devem ter subido.
-- E o total do mês por pessoa:
-- ============================================================
select e.posto_id, e.nome,
       sum(coalesce(nullif(regexp_replace(coalesce(l.indicadores->>'carros',''), '[^0-9]', '', 'g'), ''), '0')::numeric) as carros_no_periodo,
       sum(coalesce(nullif(regexp_replace(coalesce(l.indicadores->>'app',''),    '[^0-9]', '', 'g'), ''), '0')::numeric) as app_no_periodo
from public.lancamentos l
join public.equipe e on e.id = l.frentista_id
group by 1, 2
order by 1, 3 desc;
