-- ============================================================
-- PMAX360 — Etapa 12: aceitar o papel 'Trocador' na tabela contas
-- Cole no SQL Editor do Supabase e clique em Run.
-- ============================================================
--
-- POR QUE: a tabela contas foi criada com
--   check (papel in ('Proprietário','Administrador','Gerente','Frentista'))
-- Quando o app passou a cadastrar trocador de óleo, ele começou a gravar
-- papel = 'Trocador'. O banco recusa a linha, então o acesso aparece no
-- aparelho de quem cadastrou mas NUNCA é salvo — em outro celular a pessoa
-- não existe e o login não entra.
--
-- Depois de rodar isto, cadastre a pessoa de novo (ou abra Equipe → Editar e
-- salve) para o acesso subir.

alter table public.contas drop constraint if exists contas_papel_check;

alter table public.contas
  add constraint contas_papel_check
  check (papel in ('Proprietário','Administrador','Gerente','Frentista','Trocador'));

-- Conferência: deve listar os papéis existentes sem erro.
select papel, count(*) as quantos
  from public.contas
 group by papel
 order by quantos desc;
