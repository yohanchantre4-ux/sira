# SIRA · Registro de aprendices

Aplicación web Flutter para el registro y consulta de aprendices, conectada a Supabase con `supabase_flutter`.

## Ejecutar

Requiere Flutter 3.24 o posterior y acceso de red al proyecto Supabase.

```sh
flutter pub get
flutter run -d web
```

La URL del proyecto y la clave publicable están configuradas con los valores entregados. Para usar otro proyecto, se pueden inyectar al compilar:

```sh
flutter run -d web \
  --dart-define=SUPABASE_URL=https://<proyecto>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<clave-publicable>
```

La clave incluida es la clave publicable (`sb_publishable_…`); nunca se debe incluir una `service_role` en una aplicación cliente.

## Funcionalidades

- Listado adaptable de aprendices, búsqueda por identificación, nombre o ubicación y conteos por género.
- Alta y edición con campos obligatorios, género F/M, fecha no futura y selección de ciudad filtrada por departamento.
- Consulta del detalle en el listado y eliminación con confirmación.
- Inicio/cierre de sesión con correo y contraseña de Supabase Auth y recuperación de contraseña.
- Roles `admin` y `operativo`; eliminación de aprendices y administración de cuentas solo para administradores.
- Catálogos de departamentos y ciudades/municipios: consulta para todos los usuarios autenticados y altas, edición y eliminación reservadas a administradores.
- Mensajes para estados de carga, lista vacía, errores y operaciones completadas.

## Mapeo a la base de datos

| Tabla SQL | Modelo Dart | Repositorio | Uso |
| --- | --- | --- | --- |
| `public.aprendiz` | `Aprendiz` | `AprendizRepository` | CRUD, búsqueda por `id`; muestra nombres de ubicación mediante relaciones PostgREST. |
| `public.departamentos` | `Departamento` | `DepartamentoRepository` | Catálogo editable por administradores y selector del formulario de aprendiz. |
| `public.ciudades` | `Ciudad` | `CiudadRepository` | Catálogo editable por administradores y selector filtrado por `departamento_id`. |
| `auth.users` + `public.profiles` | `PerfilUsuario` | `PerfilRepository` | Identidad de Supabase Auth y rol/perfil de aplicación. |

Los nombres de columnas respetan el SQL: `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `genero`, `fecha_nacimiento`, `departamento_id` y `ciudad_id`. La clave primaria de `aprendiz` es el identificador de texto. El trigger de la base de datos valida también que la ciudad pertenezca al departamento.

## Alcance de autenticación y permisos

El SQL inicial abre CRUD a `anon`. Si aún no instalaste el esquema base, ejecuta primero `docs/SIRA_SQL.sql`. Para que autenticación, RBAC y edición de catálogos sean efectivos, aplica después `docs/supabase_auth_setup.sql` en el SQL Editor. Si ya aplicaste una versión anterior de la migración, vuelve a ejecutar la versión actualizada. Cambia `REEMPLAZAR_POR_CORREO_ADMIN` por el correo del administrador que ya existe en Supabase Auth. La migración crea `profiles`, conecta cada usuario nuevo a su perfil, asigna roles y configura las políticas RLS para aprendices y catálogos.

La creación de usuarios desde la interfaz usa la Edge Function `admin-users`; despliega la función desde la raíz del proyecto con Supabase CLI:

```sh
supabase link --project-ref xpizbtncnkqnldwzdeph
supabase functions deploy admin-users
```

La función valida el JWT y el rol administrador en el servidor y usa `SUPABASE_SERVICE_ROLE_KEY` solo en el entorno de Edge Functions. Nunca copies esa clave a Flutter. En Supabase Auth configura la URL del sitio y las redirect URLs del dominio local/de producción para que los enlaces de recuperación regresen a la app. Tras aplicar migración y desplegar la función, inicia sesión con la cuenta existente; las cuentas nuevas se crean desde **Gestionar usuarios**.

## Estructura

```text
lib/
  main.dart
  models/       modelos de las tres tablas
  services/     repositorios Supabase por entidad
  screens/      listado adaptable y formulario CRUD
  widgets/      componentes reutilizables
supabase/
  functions/    Edge Function protegida para crear cuentas Auth
docs/
  SIRA_PRD.md
  SIRA_SQL.sql
  supabase_auth_setup.sql
```

El archivo `docs/SIRA_SQL.sql` es la fuente de verdad del esquema; sus instrucciones deben ejecutarse en Supabase SQL Editor antes de usar la app.
