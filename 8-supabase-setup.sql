-- Run once in the Supabase SQL Editor for the Coop Tracker project.
create table if not exists public.coop_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  version bigint not null default 1 check (version > 0),
  updated_at timestamptz not null default now()
);

alter table public.coop_state enable row level security;
revoke all on table public.coop_state from anon;
grant select, insert, update, delete on table public.coop_state to authenticated;

drop policy if exists "Owners can read coop state" on public.coop_state;
create policy "Owners can read coop state" on public.coop_state for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "Owners can create coop state" on public.coop_state;
create policy "Owners can create coop state" on public.coop_state for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "Owners can update coop state" on public.coop_state;
create policy "Owners can update coop state" on public.coop_state for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Owners can delete coop state" on public.coop_state;
create policy "Owners can delete coop state" on public.coop_state for delete to authenticated using ((select auth.uid()) = user_id);

create or replace function public.set_coop_state_updated_at() returns trigger language plpgsql security invoker set search_path = '' as $$
begin new.updated_at = now(); return new; end; $$;
drop trigger if exists set_coop_state_updated_at on public.coop_state;
create trigger set_coop_state_updated_at before update on public.coop_state for each row execute function public.set_coop_state_updated_at();

-- Required for live updates on another signed-in device.
do $$ begin
  alter publication supabase_realtime add table public.coop_state;
exception when duplicate_object then null;
end $$;
