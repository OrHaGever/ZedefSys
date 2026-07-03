-- Hatzedef tips app cloud state
-- Run this in Supabase SQL Editor.

create table if not exists public.app_state (
  restaurant_id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_by text,
  updated_at timestamptz not null default now()
);

alter table public.app_state enable row level security;

drop policy if exists "hatzedef_app_state_read" on public.app_state;
drop policy if exists "hatzedef_app_state_insert" on public.app_state;
drop policy if exists "hatzedef_app_state_update" on public.app_state;

create policy "hatzedef_app_state_read"
on public.app_state
for select
to anon
using (restaurant_id = 'hatzedef');

create policy "hatzedef_app_state_insert"
on public.app_state
for insert
to anon
with check (restaurant_id = 'hatzedef');

create policy "hatzedef_app_state_update"
on public.app_state
for update
to anon
using (restaurant_id = 'hatzedef')
with check (restaurant_id = 'hatzedef');

insert into public.app_state (restaurant_id, data)
values ('hatzedef', '{"employees":[],"days":[],"closedMonths":[],"version":6}'::jsonb)
on conflict (restaurant_id) do nothing;
