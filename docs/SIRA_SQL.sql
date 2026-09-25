-- ============================================================================
-- SIRA - Sistema de Información para el Registro de Aprendices
-- Script SQL para Supabase
--
-- MODO: acceso público con el rol "anon" (sin autenticación real).
-- Cualquier cliente que use la anon key podrá leer, insertar, actualizar
-- y eliminar registros. Esto NO implementa RF-01 (autenticación) ni la
-- matriz RBAC del PRD (sección 6.2) -- se deja así porque fue pedido
-- explícitamente para esta fase (prototipo / pruebas).
--
-- Ejecutar en: Supabase Dashboard > SQL Editor > New query
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Extensiones
-- ----------------------------------------------------------------------------
create extension if not exists pgcrypto;

-- ----------------------------------------------------------------------------
-- 2. Catálogo de departamentos
-- ----------------------------------------------------------------------------
create table if not exists public.departamentos (
    id     smallint generated always as identity primary key,
    nombre text not null unique
);

-- ----------------------------------------------------------------------------
-- 3. Catálogo de ciudades (cada ciudad pertenece a un departamento)
-- ----------------------------------------------------------------------------
create table if not exists public.ciudades (
    id               smallint generated always as identity primary key,
    departamento_id  smallint not null references public.departamentos(id) on delete cascade,
    nombre           text not null,
    unique (departamento_id, nombre)
);

create index if not exists idx_ciudades_departamento on public.ciudades(departamento_id);

-- ----------------------------------------------------------------------------
-- 4. Tabla principal: aprendiz  (RF-02 a RF-06)
-- ----------------------------------------------------------------------------
create table if not exists public.aprendiz (
    id                  text primary key,                     -- identificador único (p. ej. documento)
    primer_nombre       text not null check (btrim(primer_nombre) <> ''),
    segundo_nombre      text,
    primer_apellido     text not null check (btrim(primer_apellido) <> ''),
    segundo_apellido    text,
    genero              char(1) not null check (genero in ('F', 'M')),
    fecha_nacimiento    date not null check (fecha_nacimiento <= current_date),
    departamento_id     smallint not null references public.departamentos(id),
    ciudad_id           smallint not null references public.ciudades(id),
    created_at          timestamptz not null default now(),
    updated_at          timestamptz not null default now()
);

create index if not exists idx_aprendiz_departamento on public.aprendiz(departamento_id);
create index if not exists idx_aprendiz_ciudad on public.aprendiz(ciudad_id);

-- ----------------------------------------------------------------------------
-- 5. Regla: la ciudad seleccionada debe pertenecer al departamento indicado
--    (criterio de aceptación de RF-02)
-- ----------------------------------------------------------------------------
create or replace function public.fn_validar_ciudad_departamento()
returns trigger
language plpgsql
as $$
begin
    if not exists (
        select 1
        from public.ciudades c
        where c.id = new.ciudad_id
          and c.departamento_id = new.departamento_id
    ) then
        raise exception 'La ciudad % no pertenece al departamento %', new.ciudad_id, new.departamento_id
            using errcode = '23514';
    end if;
    return new;
end;
$$;

drop trigger if exists trg_validar_ciudad_departamento on public.aprendiz;
create trigger trg_validar_ciudad_departamento
    before insert or update on public.aprendiz
    for each row
    execute function public.fn_validar_ciudad_departamento();

-- ----------------------------------------------------------------------------
-- 6. updated_at automático
-- ----------------------------------------------------------------------------
create or replace function public.fn_set_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists trg_aprendiz_updated_at on public.aprendiz;
create trigger trg_aprendiz_updated_at
    before update on public.aprendiz
    for each row
    execute function public.fn_set_updated_at();

-- ----------------------------------------------------------------------------
-- 7. Datos de ejemplo para los catálogos (ajusta/agrega según necesites)
-- ----------------------------------------------------------------------------
insert into public.departamentos (nombre) values
    ('Antioquia'),
    ('Bogotá D.C.'),
    ('Valle del Cauca'),
    ('Atlántico'),
    ('Santander')
on conflict (nombre) do nothing;

insert into public.ciudades (departamento_id, nombre)
select d.id, c.nombre
from (values
    ('Antioquia', 'Medellín'),
    ('Antioquia', 'Envigado'),
    ('Antioquia', 'Itagüí'),
    ('Bogotá D.C.', 'Bogotá'),
    ('Valle del Cauca', 'Cali'),
    ('Valle del Cauca', 'Palmira'),
    ('Atlántico', 'Barranquilla'),
    ('Santander', 'Bucaramanga')
) as c(departamento_nombre, nombre)
join public.departamentos d on d.nombre = c.departamento_nombre
on conflict (departamento_id, nombre) do nothing;

-- ============================================================================
-- 8. Row Level Security: acceso público total vía rol "anon"
-- ============================================================================

alter table public.departamentos enable row level security;
alter table public.ciudades      enable row level security;
alter table public.aprendiz      enable row level security;

-- Limpia políticas previas si vuelves a correr el script
drop policy if exists "anon_select_departamentos" on public.departamentos;
drop policy if exists "anon_all_departamentos"     on public.departamentos;
drop policy if exists "anon_select_ciudades"       on public.ciudades;
drop policy if exists "anon_all_ciudades"          on public.ciudades;
drop policy if exists "anon_all_aprendiz"          on public.aprendiz;

-- Catálogos: lectura pública (no suelen necesitar escritura desde el cliente,
-- pero si tu app también necesita crearlos/editarlos, usa la versión "all")
create policy "anon_all_departamentos"
    on public.departamentos
    for all
    to anon
    using (true)
    with check (true);

create policy "anon_all_ciudades"
    on public.ciudades
    for all
    to anon
    using (true)
    with check (true);

-- Aprendiz: CRUD completo sin restricciones para el rol anon
create policy "anon_all_aprendiz"
    on public.aprendiz
    for all
    to anon
    using (true)
    with check (true);

-- ----------------------------------------------------------------------------
-- 9. Permisos a nivel de esquema/tabla para el rol anon
--    (RLS filtra filas, pero además el rol necesita el GRANT correspondiente)
-- ----------------------------------------------------------------------------
grant usage on schema public to anon;

grant select, insert, update, delete on public.departamentos to anon;
grant select, insert, update, delete on public.ciudades      to anon;
grant select, insert, update, delete on public.aprendiz      to anon;

-- Necesario porque departamentos/ciudades usan "generated always as identity"
grant usage, select on all sequences in schema public to anon;

-- ============================================================================
-- Fin del script
-- ============================================================================

-- ============================================================================
-- 1. Modificar las columnas ID para permitir inserción de los códigos DIAN/DANE
-- ============================================================================

-- Cambiar el tipo de id en ciudades a INTEGER (para soportar códigos de 5 dígitos como 99773)
ALTER TABLE public.ciudades ALTER COLUMN id TYPE integer;

-- Cambiar GENERATED ALWAYS a GENERATED BY DEFAULT para permitir insertar IDs explícitos
ALTER TABLE public.departamentos ALTER COLUMN id DROP IDENTITY IF EXISTS;
ALTER TABLE public.departamentos ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY;

ALTER TABLE public.ciudades ALTER COLUMN id DROP IDENTITY IF EXISTS;
ALTER TABLE public.ciudades ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY;

-- ============================================================================
-- 2. Poblar Departamentos (Códigos Oficiales DIAN/DANE)
-- ============================================================================

INSERT INTO public.departamentos (id, nombre) VALUES
    (5, 'Antioquia'),
    (8, 'Atlántico'),
    (11, 'Bogotá, D.C.'),
    (13, 'Bolívar'),
    (15, 'Boyacá'),
    (17, 'Caldas'),
    (18, 'Caquetá'),
    (19, 'Cauca'),
    (20, 'Cesar'),
    (23, 'Córdoba'),
    (25, 'Cundinamarca'),
    (27, 'Chocó'),
    (41, 'Huila'),
    (44, 'La Guajira'),
    (47, 'Magdalena'),
    (50, 'Meta'),
    (52, 'Nariño'),
    (54, 'Norte de Santander'),
    (63, 'Quindío'),
    (66, 'Risaralda'),
    (68, 'Santander'),
    (70, 'Sucre'),
    (73, 'Tolima'),
    (76, 'Valle del Cauca'),
    (81, 'Arauca'),
    (85, 'Casanare'),
    (86, 'Putumayo'),
    (88, 'San Andrés, Providencia y Santa Catalina'),
    (91, 'Amazonas'),
    (94, 'Guainía'),
    (95, 'Guaviare'),
    (97, 'Vaupés'),
    (99, 'Vichada')
ON CONFLICT (id) DO UPDATE SET nombre = EXCLUDED.nombre;

-- ============================================================================
-- 3. Poblar Ciudades / Municipios (Códigos DIVIPOLA completamos)
-- ============================================================================

INSERT INTO public.ciudades (id, departamento_id, nombre) VALUES
    -- Antioquia (05)
    (5001, 5, 'Medellín'),
    (5002, 5, 'Abejorral'),
    (5045, 5, 'Apartadó'),
    (5088, 5, 'Bello'),
    (5172, 5, 'Caucasia'),
    (5266, 5, 'Envigado'),
    (5360, 5, 'Itagüí'),
    (5615, 5, 'Rionegro'),
    (5631, 5, 'Sabaneta'),
    (5856, 5, 'Turbo'),

    -- Atlántico (08)
    (8001, 8, 'Barranquilla'),
    (8078, 8, 'Baranoa'),
    (8433, 8, 'Malambo'),
    (8606, 8, 'Puerto Colombia'),
    (8675, 8, 'Sabanalarga'),
    (8770, 8, 'Soledad'),

    -- Bogotá D.C. (11)
    (11001, 11, 'Bogotá, D.C.'),

    -- Bolívar (13)
    (13001, 13, 'Cartagena de Indias'),
    (13052, 13, 'Arjona'),
    (13248, 13, 'El Carmen de Bolívar'),
    (13430, 13, 'Magangué'),
    (13836, 13, 'Turbaco'),

    -- Boyacá (15)
    (15001, 15, 'Tunja'),
    (15176, 15, 'Chiquinquirá'),
    (15244, 15, 'Duitama'),
    (15533, 15, 'Paipa'),
    (15774, 15, 'Sogamoso'),
    (15407, 15, 'Villa de Leyva'),

    -- Caldas (17)
    (17001, 17, 'Manizales'),
    (17174, 17, 'Chinchiná'),
    (17380, 17, 'La Dorada'),
    (17614, 17, 'Riosucio'),
    (17887, 17, 'Villamaría'),

    -- Caquetá (18)
    (18001, 18, 'Florencia'),
    (18610, 18, 'San Vicente del Caguán'),

    -- Cauca (19)
    (19001, 19, 'Popayán'),
    (19698, 19, 'Santander de Quilichao'),

    -- Cesar (20)
    (20001, 20, 'Valledupar'),
    (20011, 20, 'Aguachica'),
    (20013, 20, 'Agustín Codazzi'),

    -- Córdoba (23)
    (23001, 23, 'Montería'),
    (23162, 23, 'Cereté'),
    (23417, 23, 'Lorica'),
    (23660, 23, 'Sahagún'),

    -- Cundinamarca (25)
    (25126, 25, 'Cajicá'),
    (25175, 25, 'Chía'),
    (25269, 25, 'El Rosal'),
    (25279, 25, 'Facatativá'),
    (25288, 25, 'Funza'),
    (25293, 25, 'Fusagasugá'),
    (25312, 25, 'Girardot'),
    (25436, 25, 'Madrid'),
    (25473, 25, 'Mosquera'),
    (25754, 25, 'Soacha'),
    (25758, 25, 'Sopó'),
    (25817, 25, 'Tocancipá'),
    (25899, 25, 'Zipaquirá'),

    -- Chocó (27)
    (27001, 27, 'Quibdó'),
    (27372, 27, 'Istmina'),

    -- Huila (41)
    (41001, 41, 'Neiva'),
    (41298, 41, 'Garzón'),
    (41551, 41, 'Pitalito'),

    -- La Guajira (44)
    (44001, 44, 'Riohacha'),
    (44430, 44, 'Maicao'),
    (44847, 44, 'Uribia'),

    -- Magdalena (47)
    (47001, 47, 'Santa Marta'),
    (47189, 47, 'Ciénaga'),
    (47288, 47, 'Fundación'),

    -- Meta (50)
    (50001, 50, 'Villavicencio'),
    (50110, 50, 'Acacías'),
    (50318, 50, 'Granada'),

    -- Nariño (52)
    (52001, 52, 'Pasto'),
    (52356, 52, 'Ipiales'),
    (52835, 52, 'Tumaco'),

    -- Norte de Santander (54)
    (54001, 54, 'Cúcuta'),
    (54405, 54, 'Los Patios'),
    (54498, 54, 'Ocaña'),
    (54518, 54, 'Pamplona'),
    (54874, 54, 'Villa del Rosario'),

    -- Quindío (63)
    (63001, 63, 'Armenia'),
    (63130, 63, 'Calarcá'),
    (63190, 63, 'Circasia'),
    (63470, 63, 'Montenegro'),
    (63594, 63, 'Quimbaya'),

    -- Risaralda (66)
    (66001, 66, 'Pereira'),
    (66170, 66, 'Dosquebradas'),
    (66682, 66, 'Santa Rosa de Cabal'),

    -- Santander (68)
    (68001, 68, 'Bucaramanga'),
    (68081, 68, 'Barrancabermeja'),
    (68271, 68, 'Floridablanca'),
    (68307, 68, 'Girón'),
    (68547, 68, 'Piedecuesta'),
    (68669, 68, 'San Gil'),

    -- Sucre (70)
    (70001, 70, 'Sincelejo'),
    (70215, 70, 'Corozal'),

    -- Tolima (73)
    (73001, 73, 'Ibagué'),
    (73217, 73, 'Chaparral'),
    (73283, 73, 'Espinal'),
    (73504, 73, 'Melgar'),

    -- Valle del Cauca (76)
    (76001, 76, 'Cali'),
    (76109, 76, 'Buenaventura'),
    (76111, 76, 'Guadalajara de Buga'),
    (76147, 76, 'Cartago'),
    (76364, 76, 'Jamundí'),
    (76520, 76, 'Palmira'),
    (76845, 76, 'Tuluá'),
    (76895, 76, 'Yumbo'),

    -- Arauca (81)
    (81001, 81, 'Arauca'),
    (81736, 81, 'Saravena'),
    (81794, 81, 'Tame'),

    -- Casanare (85)
    (85001, 85, 'Yopal'),
    (85010, 85, 'Aguazul'),
    (85410, 85, 'Tauramena'),

    -- Putumayo (86)
    (86001, 86, 'Mocoa'),
    (86568, 86, 'Puerto Asís'),

    -- San Andrés (88)
    (88001, 88, 'San Andrés'),

    -- Amazonas (91)
    (91001, 91, 'Leticia'),

    -- Guainía (94)
    (94001, 94, 'Inírida'),

    -- Guaviare (95)
    (95001, 95, 'San José del Guaviare'),

    -- Vaupés (97)
    (97001, 97, 'Mitú'),

    -- Vichada (99)
    (99001, 99, 'Puerto Carreño')
ON CONFLICT (id) DO UPDATE SET departamento_id = EXCLUDED.departamento_id, nombre = EXCLUDED.nombre;