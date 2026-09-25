-- SIRA authentication/RBAC migration.
-- Run in Supabase SQL Editor as project owner before using the app.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null default '',
  role text not null default 'operativo' check (role in ('admin', 'operativo')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create or replace function public.current_user_role()
returns text language sql stable security definer set search_path = ''
as $$ select coalesce((select p.role from public.profiles p where p.id = auth.uid()), 'operativo') $$;

create or replace function public.sync_profile_from_auth()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles(id, email)
  values(new.id, coalesce(new.email, ''))
  on conflict (id) do update set email = excluded.email, updated_at = now();
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_sira on auth.users;
create trigger on_auth_user_created_sira after insert or update of email on auth.users
for each row execute function public.sync_profile_from_auth();

insert into public.profiles(id, email)
select id, coalesce(email, '') from auth.users
on conflict (id) do update set email = excluded.email;

drop policy if exists profiles_read_self_or_admin on public.profiles;
create policy profiles_read_self_or_admin on public.profiles for select to authenticated
using (id = auth.uid() or public.current_user_role() = 'admin');
drop policy if exists profiles_admin_update on public.profiles;
create policy profiles_admin_update on public.profiles for update to authenticated
using (public.current_user_role() = 'admin') with check (role in ('admin', 'operativo'));
drop policy if exists profiles_admin_insert on public.profiles;
create policy profiles_admin_insert on public.profiles for insert to authenticated
with check (public.current_user_role() = 'admin');

-- Replace the prototype's public anonymous CRUD policies.
drop policy if exists "anon_all_aprendiz" on public.aprendiz;
drop policy if exists "anon_all_departamentos" on public.departamentos;
drop policy if exists "anon_all_ciudades" on public.ciudades;
revoke all on public.aprendiz, public.departamentos, public.ciudades, public.profiles from anon;
grant select, insert, update, delete on public.aprendiz, public.departamentos, public.ciudades to authenticated;
grant select, update on public.profiles to authenticated;
grant usage on schema public to authenticated;
grant usage, select on all sequences in schema public to authenticated;

drop policy if exists aprendiz_authenticated_select on public.aprendiz;
create policy aprendiz_authenticated_select on public.aprendiz for select to authenticated using (true);
drop policy if exists aprendiz_authenticated_insert on public.aprendiz;
create policy aprendiz_authenticated_insert on public.aprendiz for insert to authenticated with check (true);
drop policy if exists aprendiz_authenticated_update on public.aprendiz;
create policy aprendiz_authenticated_update on public.aprendiz for update to authenticated using (true) with check (true);
drop policy if exists aprendiz_admin_delete on public.aprendiz;
create policy aprendiz_admin_delete on public.aprendiz for delete to authenticated using (public.current_user_role() = 'admin');

drop policy if exists departamentos_authenticated_select on public.departamentos;
create policy departamentos_authenticated_select on public.departamentos for select to authenticated using (true);
drop policy if exists ciudades_authenticated_select on public.ciudades;
create policy ciudades_authenticated_select on public.ciudades for select to authenticated using (true);

-- Location catalogs can be maintained only by administrators.
drop policy if exists departamentos_admin_insert on public.departamentos;
create policy departamentos_admin_insert on public.departamentos for insert to authenticated
with check (public.current_user_role() = 'admin');
drop policy if exists departamentos_admin_update on public.departamentos;
create policy departamentos_admin_update on public.departamentos for update to authenticated
using (public.current_user_role() = 'admin') with check (public.current_user_role() = 'admin');
drop policy if exists departamentos_admin_delete on public.departamentos;
create policy departamentos_admin_delete on public.departamentos for delete to authenticated
using (public.current_user_role() = 'admin');

drop policy if exists ciudades_admin_insert on public.ciudades;
create policy ciudades_admin_insert on public.ciudades for insert to authenticated
with check (public.current_user_role() = 'admin');
drop policy if exists ciudades_admin_update on public.ciudades;
create policy ciudades_admin_update on public.ciudades for update to authenticated
using (public.current_user_role() = 'admin') with check (public.current_user_role() = 'admin');
drop policy if exists ciudades_admin_delete on public.ciudades;
create policy ciudades_admin_delete on public.ciudades for delete to authenticated
using (public.current_user_role() = 'admin');

-- Bootstrap the already-existing account as administrator. Replace the email
-- below with the Supabase Auth account that should own SIRA administration.
update public.profiles set role = 'admin', updated_at = now()
where lower(email) = lower('REEMPLAZAR_POR_CORREO_ADMIN');

notify pgrst, 'reload schema';
