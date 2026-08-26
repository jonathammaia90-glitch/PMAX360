-- ============================================================
-- PMAX360 — 13: conferir e recuperar os dias de loja apagados
-- Cole no SQL Editor do Supabase e clique em Run. Nada é apagado.
-- ============================================================
--
-- O importador antigo apagava do banco os dias que não estavam no arquivo
-- (corrigido no v91/v92). Este script mostra o que sobrou, o que dá para
-- recuperar do backup antigo e onde estão os buracos.

-- ------------------------------------------------------------
-- 1) O que existe hoje, posto por posto
-- ------------------------------------------------------------
select p.id, p.nome, p.mes,
       count(d.id)  as dias_no_banco,
       min(d.dia)   as primeiro,
       max(d.dia)   as ultimo,
       coalesce(sum(d.venda), 0) as venda_total
  from public.postos p
  left join public.dias_loja d on d.posto_id = p.id
 group by p.id, p.nome, p.mes
 order by p.id;

-- ------------------------------------------------------------
-- 2) Buracos: dias do mês corrente do posto que NÃO têm lançamento
-- ------------------------------------------------------------
with mes as (
  select p.id, p.nome,
         to_date('01/' || p.mes, 'DD/MM/YYYY') as ini
    from public.postos p
   where p.mes ~ '^[0-9]{2}/[0-9]{4}$'
),
calendario as (
  select m.id, m.nome, g::date as dia
    from mes m,
         generate_series(m.ini, (m.ini + interval '1 month - 1 day')::date, interval '1 day') g
   where g::date <= current_date
)
select c.id, c.nome, c.dia
  from calendario c
  left join public.dias_loja d on d.posto_id = c.id and d.dia = c.dia
 where d.id is null
 order by c.id, c.dia;

-- ------------------------------------------------------------
-- 3) O backup antigo (fuelrank_estado) ainda tem esses dias?
--    Se a contagem vier > 0, rode migracao/08-recuperar-dias-loja.sql:
--    ele reinsere sem apagar nada do que já está no banco.
-- ------------------------------------------------------------
select coalesce(count(*), 0) as dias_no_backup
  from public.fuelrank_estado e
  cross join lateral jsonb_array_elements(coalesce(e.dados->'postos','[]'::jsonb)) p
  cross join lateral jsonb_array_elements(coalesce(p->'dias','[]'::jsonb)) d
 where e.id = 'rede';

-- ------------------------------------------------------------
-- Se o backup não tiver (ele parou de ser escrito na migração), sobram
-- dois caminhos:
--   a) Supabase → Database → Backups: restaurar um ponto anterior à
--      importação (depende do plano do projeto).
--   b) Relançar os dias na aba Loja, ou reimportar o relatório diário
--      que os contenha — no v92 a importação não apaga mais os outros dias.
-- ------------------------------------------------------------
