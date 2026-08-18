-- ============================================================
-- FuelRank — Etapa 1: estrutura do banco
-- Cole este arquivo inteiro no SQL Editor do Supabase e clique em Run.
-- Pode rodar mais de uma vez: nada é apagado, nada é duplicado.
-- ============================================================

-- ---------- POSTOS ----------
create table if not exists public.postos (
  id            bigint primary key,
  nome          text not null,
  gerente       text,
  cadastro      text,
  mes           text,
  metas         jsonb  not null default '{}'::jsonb,
  subgrupos     jsonb  not null default '[]'::jsonb,
  precos        jsonb  not null default '{}'::jsonb,
  nf            jsonb  not null default '{}'::jsonb,
  concorrentes  jsonb  not null default '[]'::jsonb,
  ativo         boolean not null default true,
  criado_em     timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);

-- ---------- CONTAS ----------
create table if not exists public.contas (
  usuario   text primary key,
  nome      text not null,
  papel     text not null check (papel in ('Proprietário','Administrador','Gerente','Frentista')),
  senha     text,
  posto_id  bigint references public.postos(id) on delete set null,
  ativo     boolean not null default true,
  criado_em timestamptz not null default now()
);
create index if not exists contas_posto_idx on public.contas (posto_id);

-- ---------- EQUIPE ----------
create table if not exists public.equipe (
  id       bigint primary key,
  posto_id bigint not null references public.postos(id) on delete cascade,
  nome     text not null,
  email    text,
  funcao   text,
  turno    text,
  ativo    boolean not null default true
);
create index if not exists equipe_posto_idx on public.equipe (posto_id);

-- ---------- LANÇAMENTOS (um por frentista, por dia) ----------
create table if not exists public.lancamentos (
  id           bigserial primary key,
  posto_id     bigint not null references public.postos(id) on delete cascade,
  frentista_id bigint references public.equipe(id) on delete cascade,
  dia          date not null,
  indicadores  jsonb not null default '{}'::jsonb,
  criado_por   text,
  criado_em    timestamptz not null default now(),
  unique (posto_id, frentista_id, dia)
);
create index if not exists lanc_posto_dia_idx on public.lancamentos (posto_id, dia desc);

-- ---------- FECHAMENTO DIÁRIO DA LOJA ----------
create table if not exists public.dias_loja (
  id            bigserial primary key,
  posto_id      bigint not null references public.postos(id) on delete cascade,
  dia           date not null,
  venda         numeric(14,2) not null default 0,
  custo         numeric(14,2) not null default 0,
  segmentos     jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now(),
  unique (posto_id, dia)
);
create index if not exists dias_posto_idx on public.dias_loja (posto_id, dia desc);

-- ---------- CARIMBO DE ATUALIZAÇÃO ----------
create or replace function public.toca_atualizado()
returns trigger language plpgsql as $$
begin
  new.atualizado_em := now();
  return new;
end $$;

drop trigger if exists postos_toca on public.postos;
create trigger postos_toca before update on public.postos
  for each row execute function public.toca_atualizado();

drop trigger if exists dias_toca on public.dias_loja;
create trigger dias_toca before update on public.dias_loja
  for each row execute function public.toca_atualizado();

-- ---------- RESUMO DO MÊS POR POSTO (usado pelo ranking) ----------
create or replace view public.resumo_mes as
select
  p.id            as posto_id,
  p.nome          as posto,
  to_char(l.dia, 'MM/YYYY') as mes,
  sum(coalesce((l.indicadores->>'volume')::numeric, 0))      as volume,
  sum(coalesce((l.indicadores->>'aditivada')::numeric, 0))   as aditivada,
  sum(coalesce((l.indicadores->>'carros')::numeric, 0))      as carros,
  sum(coalesce((l.indicadores->>'automotiva')::numeric, 0))  as automotiva,
  sum(coalesce((l.indicadores->>'app')::numeric, 0))         as app,
  count(distinct l.frentista_id)                             as frentistas,
  count(distinct l.dia)                                      as dias_lancados
from public.postos p
join public.lancamentos l on l.posto_id = p.id
group by p.id, p.nome, to_char(l.dia, 'MM/YYYY');

-- ---------- SEGURANÇA ----------
-- RLS ligado em todas as tabelas. Por enquanto a regra é permissiva
-- (mesmo comportamento de hoje) para o app continuar funcionando
-- durante a migração. A Etapa 3 troca estas regras por acesso por posto.
alter table public.postos      enable row level security;
alter table public.contas      enable row level security;
alter table public.equipe      enable row level security;
alter table public.lancamentos enable row level security;
alter table public.dias_loja   enable row level security;

do $$
declare t text;
begin
  foreach t in array array['postos','contas','equipe','lancamentos','dias_loja'] loop
    execute format('drop policy if exists %I on public.%I', 'temp_tudo_' || t, t);
    execute format(
      'create policy %I on public.%I for all to anon, authenticated using (true) with check (true)',
      'temp_tudo_' || t, t);
  end loop;
end $$;
