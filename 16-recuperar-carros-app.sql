-- ============================================================
-- PMAX360 — Etapa 16 (v2): devolver CARROS e CADASTROS NO APP
-- Cole tudo no SQL Editor do Supabase e clique em Run.
--
-- Confirmado no backup: data no formato DD/MM/YYYY e frentista
-- encontrado na equipe. Este script:
--   1) atualiza os dias que existem na tabela;
--   2) insere os dias que a importação apagou;
--   3) mostra a conferência no final.
--
-- Só escreve em 'carros' e 'app', e só onde o valor atual está
-- vazio ou zero. Nada é apagado. Pode rodar mais de uma vez.
--
-- App fechado nos aparelhos. Depois, cada pessoa abre uma vez
-- com internet.
-- ============================================================

-- Uma tabela temporária com o que o backup tem.
drop table if exists tmp_recup;
create temporary table tmp_recup as
with estado as (
  select dados from public.fuelrank_estado where id = 'rede' limit 1
),
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
    nullif(regexp_replace(coalesce(dia->>'carros',''), '[^0-9]', '', 'g'), '') as carros,
    nullif(regexp_replace(coalesce(dia->>'app',''),    '[^0-9]', '', 'g'), '') as app
  from d
)
select distinct on (posto_id, frentista_id, dia_norm)
       posto_id, frentista_id, dia_norm, carros, app
from n
where dia_norm is not null
  and (coalesce(carros,'0') <> '0' or coalesce(app,'0') <> '0')
  and exists (select 1 from public.equipe e where e.id = n.frentista_id)
order by posto_id, frentista_id, dia_norm;

-- Quantos dias vamos devolver.
select count(*) as dias_para_recuperar,
       count(*) filter (where carros is not null) as com_carros,
       count(*) filter (where app    is not null) as com_app
from tmp_recup;

-- 1) Dias que existem: completa carros/app onde está vazio ou zero.
update public.lancamentos l
set indicadores = l.indicadores
  || case when r.carros is not null
            and coalesce(nullif(regexp_replace(coalesce(l.indicadores->>'carros',''), '[^0-9]', '', 'g'), ''), '0') = '0'
          then jsonb_build_object('carros', r.carros) else '{}'::jsonb end
  || case when r.app is not null
            and coalesce(nullif(regexp_replace(coalesce(l.indicadores->>'app',''), '[^0-9]', '', 'g'), ''), '0') = '0'
          then jsonb_build_object('app', r.app) else '{}'::jsonb end
from tmp_recup r
where l.posto_id = r.posto_id
  and l.frentista_id = r.frentista_id
  and l.dia = r.dia_norm;

-- 2) Dias que a importação apagou: reinsere só com carros/app.
--    O combustível fica de fora de propósito: dele a verdade é o
--    relatório, que já está gravado nos dias do mês.
insert into public.lancamentos (posto_id, frentista_id, dia, indicadores, criado_por)
select r.posto_id, r.frentista_id, r.dia_norm,
       case when r.carros is not null then jsonb_build_object('carros', r.carros) else '{}'::jsonb end
    || case when r.app    is not null then jsonb_build_object('app',    r.app)    else '{}'::jsonb end,
       'recuperacao-16'
from tmp_recup r
where not exists (
  select 1 from public.lancamentos l
  where l.posto_id = r.posto_id
    and l.frentista_id = r.frentista_id
    and l.dia = r.dia_norm
);

notify pgrst, 'reload schema';

-- 3) Conferência: total por pessoa depois da recuperação.
select e.posto_id, e.nome,
       count(*) filter (where coalesce(l.indicadores->>'carros','') <> '') as dias_com_carros,
       sum(coalesce(nullif(regexp_replace(coalesce(l.indicadores->>'carros',''), '[^0-9]', '', 'g'), ''), '0')::numeric) as carros,
       sum(coalesce(nullif(regexp_replace(coalesce(l.indicadores->>'app',''),    '[^0-9]', '', 'g'), ''), '0')::numeric) as app
from public.lancamentos l
join public.equipe e on e.id = l.frentista_id
group by 1, 2
order by 1, 4 desc;
