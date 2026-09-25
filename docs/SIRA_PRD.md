# Registro de aprendices

## Product Requirements Document (PRD)

**Producto:** Sistema de Información para el Registro de Aprendices
**Nombre corto:** SIRA
**Versión:** 1.1  
**Estado:** Aprobado para planificación técnica  
**Fecha:** 21 de septiembre de 2026
**Fuente:** Entrevistas

---

## 1. Propósito del documento

Este PRD define el problema, los objetivos, los usuarios, el alcance funcional, las restricciones y las condiciones de aceptación de SIRA. Constituye la referencia funcional estable para el diseño técnico, la planificación, el desarrollo, las pruebas y la aceptación del producto.

Este documento define **qué debe resolver y hacer el producto**. Las decisiones de implementación se detallarán en el TRD y la secuencia de construcción en el PLAN.

## 2. Resumen ejecutivo

SIRA será una aplicación web adaptable orientada a digitalizar y gestionar la información de los aprendices. El sistema permitirá registrar, consultar, actualizar y eliminar la información asociada a cada aprendiz, proporcionando una interfaz sencilla, clara y accesible para la gestión de los datos.

El producto busca centralizar la información de los aprendices y facilitar su administración mediante operaciones básicas de registro y consulta, reduciendo el manejo manual de la información y favoreciendo su disponibilidad, organización y consistencia.

## 3. Problema y oportunidad

### 3.1 Problema principal

La información de los aprendices se registra y gestiona mediante mecanismos que dificultan su almacenamiento, consulta y actualización de manera centralizada, organizada y confiable. Esta situación puede generar inconsistencias en los datos, duplicidad de información y dificultades para acceder oportunamente a los registros de los aprendices.

SIRA surge como una oportunidad para digitalizar y centralizar la gestión de esta información mediante una aplicación web que facilite su registro, consulta, actualización y eliminación.


### 3.2 Problemas específicos

- Registro de información: no se dispone de un mecanismo centralizado que permita registrar de manera estructurada la información de los aprendices.
- Consulta de información: localizar los datos de un aprendiz puede requerir revisar diferentes registros o fuentes de información, dificultando su acceso oportuno.
- Actualización de datos: la modificación de la información de los aprendices puede resultar difícil de controlar, aumentando la posibilidad de mantener datos desactualizados.
- Eliminación de registros: no existe un mecanismo uniforme para retirar del sistema registros de aprendices que ya no deban conservarse dentro del conjunto de datos gestionado.
- Consistencia de la información: la ausencia de validaciones durante el registro y actualización puede ocasionar datos incompletos, incorrectos o duplicados.
- Acceso a la información: se requiere una interfaz sencilla y adaptable que permita gestionar los registros desde diferentes tamaños de pantalla de manera clara y eficiente.

### 3.3 Propuesta de valor

SIRA proporciona una solución sencilla, accesible y centralizada para gestionar la información de los aprendices, permitiendo registrar, consultar, actualizar y eliminar sus datos de manera organizada.

Su valor principal consiste en reemplazar mecanismos dispersos o manuales de gestión de información por una aplicación web que facilite el acceso a los registros, reduzca inconsistencias y contribuya a mantener información actualizada y confiable.


### 3.4 Visión del producto

SIRA busca convertirse en una herramienta web sencilla y confiable para la gestión digital de la información de los aprendices, proporcionando una experiencia de uso clara, adaptable y eficiente.

En su primera versión, el producto estará enfocado en las funcionalidades esenciales para administrar los registros de los aprendices. Su diseño funcional deberá permitir que, en futuras versiones, puedan incorporarse nuevas capacidades de gestión de acuerdo con las necesidades que surjan, sin alterar el propósito principal del sistema.

## 4. Objetivos

### 4.1 Objetivo general

Desarrollar una aplicación web adaptable que permita gestionar de manera centralizada, organizada y confiable la información de los aprendices, facilitando el registro, consulta, actualización y eliminación de sus datos.

### 4.2 Objetivos específicos

- Permitir el registro de la información de los aprendices mediante una interfaz clara y sencilla.
- Facilitar la consulta de los aprendices registrados y el acceso a su información.
- Permitir la actualización de los datos de un aprendiz cuando sea necesario.
- Permitir la eliminación de registros de aprendices de acuerdo con las condiciones definidas para el producto.
- Validar la información ingresada para reducir registros incompletos, incorrectos o inconsistentes.
- Proporcionar una interfaz web adaptable que facilite el uso del sistema en diferentes tamaños de pantalla.
- Centralizar la información de los aprendices para facilitar su administración y disponibilidad.


## 5. Indicadores de éxito

| ID     | Indicador                                      | Meta aprobada                                              | Método de medición                                                                                                                 |
| ------ | ---------------------------------------------- | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| KPI-01 | Tiempo de registro de un aprendiz              | Menos de 2 minutos                                         | Tiempo transcurrido desde el inicio del diligenciamiento del formulario hasta la confirmación del registro                         |
| KPI-02 | Registros con información obligatoria completa | 100 %                                                      | Registros con todos los campos obligatorios diligenciados / total de registros creados                                             |
| KPI-03 | Exactitud de la información registrada         | 98 % o superior                                            | Registros sin errores detectados / total de registros verificados                                                                  |
| KPI-04 | Tiempo de consulta de un aprendiz              | Menos de 5 segundos                                        | Tiempo transcurrido desde la solicitud de consulta hasta la presentación de la información                                         |
| KPI-05 | Operaciones CRUD ejecutadas correctamente      | 100 %                                                      | Operaciones de registro, consulta, actualización y eliminación completadas correctamente / total de operaciones válidas ejecutadas |
| KPI-06 | Prevención de registros duplicados             | 100 %                                                      | Intentos de registro con identificador único duplicado rechazados / total de intentos duplicados realizados                        |
| KPI-07 | Validación de datos obligatorios               | 100 %                                                      | Operaciones con datos obligatorios faltantes rechazadas / total de operaciones realizadas con datos obligatorios incompletos       |
| KPI-08 | Adaptabilidad de la interfaz                   | 100 % de los tamaños de pantalla definidos para aceptación | Pruebas satisfactorias de visualización y operación en los tamaños de pantalla establecidos                                        |

> **Nota de control:** Los KPI serán evaluados durante las pruebas de aceptación de SIRA utilizando datos y escenarios previamente definidos. Los indicadores asociados con tiempos de respuesta podrán variar según las condiciones de conectividad y del entorno de ejecución, por lo que deberán medirse bajo condiciones de prueba establecidas.

## 6. Usuarios, roles y permisos

### 6.1 Usuarios finales

SIRA estará dirigido a usuarios responsables del registro y gestión de la información de los aprendices. Para la versión 1.0 se identifican los siguientes tipos de usuarios finales:

- Administrador: Usuario responsable de administrar la información de los aprendices y supervisar el uso del sistema.
- Usuario operativo: Usuario encargado de registrar, consultar y mantener actualizada la información de los aprendices.

### 6.2 Matriz RBAC

| Funcionalidad / Permiso | Administrador | Usuario operativo |
|---|:---:|:---:|
| Acceder al sistema | ✓ | ✓ |
| Consultar aprendices | ✓ | ✓ |
| Registrar aprendices | ✓ | ✓ |
| Actualizar información de aprendices | ✓ | ✓ |
| Eliminar aprendices | ✓ | ✗ |
| Consultar listado de aprendices | ✓ | ✓ |
| Gestionar usuarios del sistema | ✓ | ✗ |
| Asignar roles y permisos | ✓ | ✗ |

### 6.3 Reglas de autorización

- Todo usuario deberá autenticarse antes de acceder a las funcionalidades protegidas de SIRA.
- Cada usuario tendrá asociado un rol que determinará las operaciones que puede realizar.
- El Administrador tendrá acceso a todas las funcionalidades definidas para SIRA 1.0.
- El Usuario operativo podrá registrar, consultar y actualizar información de aprendices, pero no podrá eliminar registros.
- La gestión de usuarios y la asignación de roles estarán reservadas al Administrador.
- Cuando un usuario intente ejecutar una operación para la cual no tenga autorización, SIRA deberá impedir la operación e informar que no posee los permisos requeridos.
- Los permisos deberán aplicarse independientemente de la interfaz desde la cual se intente realizar la operación.

## 7. Alcance del producto

### 7.1 Alcance del MVP

- **MVP-01. Autenticación de usuarios:** Permitir el acceso al sistema mediante credenciales válidas.
- **MVP-02. Control de acceso por roles:** Autorizar las funcionalidades disponibles de acuerdo con el rol asignado.
- **MVP-03. Registro de aprendices:** Permitir crear un nuevo registro de aprendiz mediante el diligenciamiento de la información requerida.
- **MVP-04. Consulta de aprendices:** Permitir consultar la información de los aprendices registrados.
- **MVP-05. Listado de aprendices:** Presentar los aprendices registrados de manera organizada.
- **MVP-06. Actualización de aprendices:** Permitir modificar la información de un aprendiz existente.
- **MVP-07. Eliminación de aprendices:** Permitir al rol autorizado eliminar un registro de aprendiz.
- **MVP-08. Validación de datos:** Verificar los campos obligatorios y las reglas básicas de integridad antes de registrar o actualizar información.
- **MVP-09. Interfaz web adaptable:** Permitir el uso adecuado de las funcionalidades principales en los tamaños de pantalla definidos para el producto.
- **MVP-10. Gestión básica de usuarios:** Permitir al Administrador gestionar los usuarios que tendrán acceso a SIRA.

### 7.2 Iteraciones posteriores

- Búsqueda avanzada de aprendices: Permitir localizar aprendices utilizando diferentes criterios de búsqueda y filtros.
- Gestión de fichas de formación: Asociar los aprendices con sus respectivas fichas de formación.
- Gestión de programas de formación: Administrar información relacionada con los programas de formación asociados a los aprendices.
- Importación masiva de aprendices: Permitir registrar múltiples aprendices a partir de archivos estructurados.
- Exportación de información: Permitir generar archivos con información de los aprendices registrados.
- Reportes e indicadores: Generar reportes y estadísticas relacionadas con los aprendices y la información gestionada por el sistema.
- Historial de cambios: Mantener trazabilidad sobre las modificaciones realizadas a la información de los aprendices.
-   Recuperación de contraseña: Permitir que los usuarios recuperen o restablezcan sus credenciales de acceso.

## 8. Requisitos funcionales y criterios de aceptación

### RF-01. Autenticación de usuario

**Historia de usuario:**

Como usuario de SIRA, quiero autenticarme mediante mis credenciales para acceder de manera segura a las funcionalidades autorizadas del sistema.

**Criterios de aceptación:**

- El sistema debe solicitar las credenciales requeridas para iniciar sesión.
- Si las credenciales son válidas, el sistema debe permitir el acceso.
- Si las credenciales son inválidas, el sistema debe rechazar el acceso e informar al usuario.
- El sistema debe identificar el rol asociado al usuario autenticado.
- El usuario solo debe acceder a las funcionalidades autorizadas para su rol.

---

### RF-02. Registrar aprendiz

**Historia de usuario:**

**Como** usuario encargado de la gestión de aprendices,  
**quiero** registrar la información de un aprendiz,  
**para** almacenar sus datos de manera organizada y mantener un registro confiable dentro del sistema.


**Criterios de aceptación:**

- El sistema debe permitir ingresar la identificación del aprendiz.
- El sistema debe permitir registrar:
  - Primer nombre.
  - Segundo nombre.
  - Primer apellido.
  - Segundo apellido.
- El primer nombre y el primer apellido son obligatorios.
- El segundo nombre y el segundo apellido son opcionales.
- El sistema debe permitir registrar el género únicamente con los valores `F` o `M`.
- El sistema debe permitir registrar la fecha de nacimiento.
- El sistema debe permitir seleccionar el departamento de residencia.
- El sistema debe permitir seleccionar la ciudad de residencia.
- La ciudad seleccionada debe corresponder al departamento indicado.
- El sistema no debe permitir registrar dos aprendices con el mismo identificador.
- Si la información suministrada es válida, el sistema debe almacenar el nuevo aprendiz.
- Si alguna validación falla, el sistema no debe realizar el registro y debe informar al usuario.

---

### RF-03. Consultar aprendiz

**Historia de usuario:**

**Como** usuario encargado de la gestión de aprendices,  
**quiero** consultar la información de un aprendiz mediante su identificador,  
**para** visualizar los datos registrados y verificar su información.

**Criterios de aceptación:**

- El sistema debe permitir ingresar el identificador del aprendiz que se desea consultar.
- El sistema debe buscar el aprendiz utilizando el campo `id`.
- Si el aprendiz existe, el sistema debe mostrar su información registrada.
- La información presentada debe incluir:
  - Identificación.
  - Primer nombre.
  - Segundo nombre.
  - Primer apellido.
  - Segundo apellido.
  - Género.
  - Fecha de nacimiento.
  - Departamento de residencia.
  - Ciudad de residencia.
- Si el aprendiz no existe, el sistema debe informar que no se encontró ningún registro asociado al identificador suministrado.
- La consulta no debe modificar la información almacenada.
- La información mostrada debe corresponder exactamente al aprendiz consultado.

---

### RF-04. Listar aprendices

**Historia de usuario:**

**Como** usuario encargado de la gestión de aprendices,  
**quiero** visualizar el listado de los aprendices registrados,  
**para** consultar de manera organizada la información disponible en el sistema.

**Criterios de aceptación:**

- El sistema debe mostrar los aprendices registrados en la tabla `aprendiz`.
- El listado debe presentar información básica de cada aprendiz.
- La información mostrada puede incluir:
  - Identificación.
  - Primer nombre.
  - Segundo nombre.
  - Primer apellido.
  - Segundo apellido.
  - Género.
  - Fecha de nacimiento.
  - Departamento de residencia.
  - Ciudad de residencia.
- Cada registro mostrado debe corresponder a un aprendiz almacenado en el sistema.
- Si no existen aprendices registrados, el sistema debe informar que no hay registros disponibles.
- La visualización del listado no debe modificar la información almacenada.
- El sistema debe permitir seleccionar un aprendiz del listado para consultar su información detallada.

---

### RF-05. Actualizar aprendiz

**Historia de usuario:**

**Como** usuario encargado de la gestión de aprendices,  
**quiero** actualizar la información de un aprendiz registrado,  
**para** mantener sus datos correctos y vigentes dentro del sistema.

**Criterios de aceptación:**

- El sistema debe permitir seleccionar un aprendiz existente.
- El sistema debe mostrar la información actual del aprendiz.
- El usuario debe poder modificar los campos permitidos.
- El sistema debe validar los datos antes de guardar los cambios.
- Si los datos son válidos, el sistema debe almacenar la información actualizada.
- El sistema debe informar cuando la actualización se realice correctamente.

---

### RF-06. Eliminar aprendiz

**Historia de usuario:**

Como Administrador, quiero eliminar el registro de un aprendiz para retirar del sistema información que ya no deba permanecer registrada.

**Criterios de aceptación:**

- Únicamente un usuario con permiso de eliminación debe poder ejecutar esta operación.
- El sistema debe permitir seleccionar el aprendiz que será eliminado.
- Antes de eliminar el registro, el sistema debe solicitar confirmación.
- Si el usuario cancela la operación, el registro debe permanecer sin modificaciones.
- Si el usuario confirma la operación, el sistema debe eliminar el registro.
- El sistema debe informar cuando la eliminación se haya realizado correctamente.

---

### RF-07. Controlar acceso por roles

**Historia de usuario:**

Como Administrador, quiero que las funcionalidades de SIRA estén disponibles según el rol de cada usuario para controlar las operaciones que puede realizar dentro del sistema.

**Criterios de aceptación:**

- Cada usuario debe tener asociado un rol.
- El sistema debe identificar el rol después de la autenticación.
- El sistema debe habilitar únicamente las funcionalidades permitidas para el rol.
- El sistema debe impedir operaciones para las cuales el usuario no tenga autorización.
- Cuando se intente ejecutar una operación no autorizada, el sistema debe informar al usuario.

---

### RF-08. Gestionar usuarios

**Historia de usuario:**

Como Administrador, quiero gestionar los usuarios de SIRA para controlar quién puede acceder al sistema.

**Criterios de aceptación:**

- El Administrador debe poder registrar usuarios.
- El Administrador debe poder consultar los usuarios existentes.
- El Administrador debe poder actualizar la información permitida de un usuario.
- El Administrador debe poder asignar un rol a cada usuario.
- Los usuarios sin permisos administrativos no deben tener acceso a la gestión de usuarios.

## 9. Requisitos de iteraciones posteriores

Los siguientes requisitos representan funcionalidades candidatas para futuras versiones de SIRA. No forman parte del alcance del MVP y su implementación estará sujeta a validación, priorización y aprobación antes de ser incorporados al producto.

### RIP-01. Búsqueda avanzada de aprendices

El sistema podrá permitir la búsqueda de aprendices mediante diferentes criterios y la aplicación de filtros sobre la información registrada.

### RIP-02. Gestión de fichas de formación

El sistema podrá permitir registrar y administrar fichas de formación y asociar los aprendices a la ficha correspondiente.

### RIP-03. Gestión de programas de formación

El sistema podrá permitir administrar los programas de formación y establecer su relación con las fichas y los aprendices.

### RIP-04. Importación masiva de aprendices

El sistema podrá permitir el registro de múltiples aprendices mediante la importación de archivos estructurados, validando la información antes de incorporarla.

### RIP-05. Exportación de información

El sistema podrá permitir exportar la información de los aprendices utilizando formatos de archivo definidos para este propósito.

### RIP-06. Reportes e indicadores

El sistema podrá proporcionar reportes, estadísticas e indicadores derivados de la información almacenada.

### RIP-07. Historial de cambios

El sistema podrá mantener un historial de las modificaciones realizadas sobre la información de los aprendices, incluyendo los datos necesarios para identificar los cambios efectuados.

### RIP-08. Recuperación de contraseña

El sistema podrá proporcionar un mecanismo que permita a los usuarios recuperar o restablecer sus credenciales de acceso.

### RIP-09. Notificaciones

El sistema podrá generar notificaciones relacionadas con eventos relevantes ocurridos durante la utilización del producto.

### RIP-10. Perfil del aprendiz

El sistema podrá proporcionar un perfil individual del aprendiz que permita consultar de manera organizada su información y los datos que sean incorporados en futuras versiones.

> **Nota de alcance:** Los requisitos RIP-01 a RIP-10 no forman parte del MVP de SIRA 1.0. Antes de su implementación deberán ser analizados, priorizados y formalmente incorporados al alcance de una versión posterior del producto.

## 10. Requisitos no funcionales

### RNF-01. Plataforma y experiencia

SIRA deberá funcionar como una aplicación web adaptable, con una interfaz sencilla, clara y consistente que permita su utilización en diferentes tamaños de pantalla.

### RNF-02. Rendimiento

Las consultas de información deberán presentar resultados en un tiempo máximo de **5 segundos**, bajo condiciones normales de operación y conectividad.

### RNF-03. Seguridad y privacidad

El acceso a SIRA deberá requerir autenticación. Las funcionalidades y la información disponible deberán estar restringidas de acuerdo con el rol y los permisos asignados a cada usuario.

### RNF-04. Integridad y conservación

SIRA deberá validar los datos obligatorios y garantizar la consistencia de la información almacenada, evitando registros incompletos o duplicados cuando exista una restricción de unicidad.

### RNF-05. Disponibilidad y recuperación

La información registrada correctamente deberá permanecer disponible para los usuarios autorizados y deberá contemplarse un mecanismo que permita su recuperación ante fallos o pérdida accidental.

### RNF-06. Observabilidad

SIRA deberá registrar información básica sobre errores y eventos relevantes del sistema que facilite la identificación y diagnóstico de problemas durante su operación.


## 11. Estados de interfaz obligatorios

### 11.1 Carga

- Mostrar mensajes claros como `Cargando aprendices`, `Consultando información` o `Guardando aprendiz`.
- Desactivar temporalmente la acción que se encuentre en ejecución.
- Evitar que una misma operación sea enviada varias veces mientras se procesa.

### 11.2 Estado vacío

- Cuando no existan aprendices registrados, informar claramente al usuario.
- Presentar una acción pertinente como `Registrar aprendiz`, cuando el rol del usuario tenga permiso para realizarla.
- No mostrar tablas vacías sin información u orientación para el usuario.

### 11.3 Validación y error

- Mostrar mensajes claros cuando existan campos obligatorios sin diligenciar o datos inválidos.
- Mostrar el mensaje de validación junto al campo correspondiente cuando sea posible.
- Mantener los datos válidos previamente ingresados para evitar que el usuario tenga que diligenciarlos nuevamente.
- Ante un error del sistema, informar al usuario y ofrecer la opción `Reintentar`.

### 11.4 Éxito

- Informar claramente cuando una operación de registro, actualización o eliminación se haya realizado correctamente.
- Mostrar la información actualizada después de completar la operación.
- Ofrecer la siguiente acción lógica, como `Consultar aprendiz`, `Registrar otro aprendiz` o `Volver al listado`, sin ejecutarla automáticamente.

## 12. Restricciones y exclusiones
### 12.1 Restricciones obligatorias

- El MVP funcionará como una aplicación web con conexión a Internet.
- El acceso al sistema requerirá autenticación de usuarios.
- El sistema utilizará control de acceso basado en roles (RBAC).
- Los usuarios únicamente podrán ejecutar las operaciones autorizadas para su rol.
- Los datos obligatorios deberán ser validados antes de realizar operaciones de registro o actualización.
- El identificador definido como único para cada aprendiz no podrá estar asociado a más de un registro.
- La información de los aprendices deberá ser gestionada únicamente por usuarios autorizados.

### 12.2 Fuera del alcance del MVP

- Aplicación móvil nativa.
- Funcionamiento completo sin conexión a Internet.
- Gestión de fichas y programas de formación.
- Importación masiva de aprendices.
- Generación de reportes y estadísticas avanzadas.
- Integración con sistemas institucionales del SENA.
- Envío de notificaciones por correo electrónico, SMS u otros canales externos.
- Analítica predictiva o funcionalidades basadas en inteligencia artificial.

### 12.3 Componentes protegidos

- SIRA no modificará sistemas institucionales, bases de datos externas ni aplicaciones existentes.
- No se realizarán integraciones con plataformas institucionales sin autorización y documentación técnica correspondiente.
- Las credenciales, configuraciones de seguridad y demás información sensible no deberán exponerse directamente en la interfaz de usuario.
- Cualquier integración futura con sistemas externos deberá ser previamente definida y aprobada antes de incorporarse al producto.

## 13. Casos críticos y pruebas obligatorias

| ID | Escenario obligatorio | Resultado esperado |
|---|---|---|
| CP-01 | Inicio de sesión con credenciales válidas | El usuario accede correctamente al sistema y visualiza las funcionalidades correspondientes a su rol. |
| CP-02 | Inicio de sesión con credenciales inválidas | El sistema rechaza el acceso e informa que las credenciales no son válidas. |
| CP-03 | Registro de aprendiz con información válida | El aprendiz es registrado correctamente y el sistema confirma la operación. |
| CP-04 | Registro de aprendiz con campos obligatorios vacíos | El sistema impide el registro e informa cuáles campos deben ser completados. |
| CP-05 | Registro de aprendiz con identificador duplicado | El sistema rechaza el registro e informa que ya existe un aprendiz con ese identificador. |
| CP-06 | Consulta de un aprendiz existente | El sistema presenta correctamente la información asociada al aprendiz consultado. |
| CP-07 | Consulta de un aprendiz inexistente | El sistema informa que no se encontró un registro asociado al criterio de búsqueda. |
| CP-08 | Actualización de un aprendiz con datos válidos | El sistema guarda los cambios y presenta la información actualizada. |
| CP-09 | Eliminación de aprendiz por un usuario autorizado | El sistema solicita confirmación y, al aceptarla, elimina el registro correctamente. |
| CP-10 | Intento de eliminación por un usuario sin permisos | El sistema impide la operación e informa que el usuario no tiene autorización. |
| CP-11 | Consulta del listado sin aprendices registrados | El sistema muestra un estado vacío con una orientación adecuada para el usuario. |
| CP-12 | Error durante una operación | El sistema informa el error sin perder los datos válidos previamente ingresados y permite reintentar la operación. |
| CP-13 | Registro de usuario por un Administrador | El sistema crea el usuario, asocia un rol válido y confirma la operación sin exponer credenciales privilegiadas. |
| CP-14 | Consulta y actualización de usuario por un Administrador | El sistema permite consultar el usuario y actualizar únicamente la información permitida, conservando la integridad de la cuenta. |
| CP-15 | Asignación o cambio de rol por un Administrador | El sistema actualiza el rol y las autorizaciones efectivas corresponden al nuevo rol. |
| CP-16 | Intento de gestión de usuarios por un Usuario operativo | El sistema impide la operación e informa que el usuario no posee permisos administrativos. |

> **Nota:** Todos los casos críticos CP-01 a CP-16 deberán ser ejecutados y aprobados antes de considerar el MVP de SIRA como aceptado.

## 14. Supuestos y dependencias

### 14.1 Supuestos

- Los usuarios dispondrán de conexión a Internet para acceder a SIRA.
- Los usuarios contarán con credenciales válidas y un rol asignado.
- La información suministrada para registrar a los aprendices será correcta y estará disponible al momento del registro.
- Los usuarios utilizarán un navegador web compatible con la aplicación.
- El volumen de información del MVP será adecuado para un escenario académico de prueba.
- Los usuarios tendrán conocimientos básicos para interactuar con formularios y aplicaciones web.

### 14.2 Dependencias

- Disponibilidad del servicio utilizado para almacenar y consultar la información.
- Disponibilidad del servicio utilizado para la autenticación de usuarios.
- Disponibilidad de conexión a Internet.
- Correcta configuración de los roles y permisos definidos para SIRA.
- Disponibilidad del entorno donde se encuentre desplegada la aplicación web.

> **Nota:** La selección de tecnologías, servicios, infraestructura y mecanismos específicos para satisfacer estas dependencias será definida en el TRD.

## 15. Riesgos funcionales

| ID | Riesgo | Impacto | Mitigación |
|---|---|---|---|
| R-01 | Registro de información incorrecta o incompleta | Datos de aprendices inconsistentes o poco confiables | Validar campos obligatorios y formatos antes de guardar la información. |
| R-02 | Registro duplicado de aprendices | Duplicidad e inconsistencia de información | Utilizar un identificador único y validar su existencia antes del registro. |
| R-03 | Acceso a funcionalidades no autorizadas | Usuarios ejecutando operaciones fuera de sus permisos | Aplicar autenticación y control de acceso basado en roles (RBAC). |
| R-04 | Eliminación accidental de un aprendiz | Pérdida no intencionada de información | Solicitar confirmación antes de ejecutar la eliminación. |
| R-05 | Fallo durante una operación | Operaciones incompletas o pérdida de información ingresada | Informar el error, conservar los datos válidos cuando sea posible y permitir reintentar. |
| R-06 | Baja facilidad de uso | Errores de operación o dificultad para utilizar SIRA | Utilizar una interfaz clara, consistente y adaptable. |

> **Nota:** Los riesgos técnicos relacionados con arquitectura, infraestructura, tecnologías, despliegue y seguridad de implementación serán analizados en el TRD.

## 16. Condiciones de aceptación del MVP

El MVP de SIRA se considerará aceptado cuando se cumplan las siguientes condiciones:

- Los requisitos funcionales definidos para el MVP se encuentran implementados y operativos.
- Los usuarios pueden autenticarse correctamente mediante credenciales válidas.
- El control de acceso basado en roles (RBAC) restringe las funcionalidades de acuerdo con los permisos definidos.
- Las operaciones de registrar, consultar, listar, actualizar y eliminar aprendices funcionan de acuerdo con los criterios de aceptación establecidos.
- El sistema valida los campos obligatorios e impide el registro de aprendices con identificadores duplicados.
- Los estados de interfaz de carga, vacío, validación, error y éxito se presentan correctamente cuando corresponda.
- Los requisitos no funcionales definidos para el MVP han sido verificados.
- Los casos críticos y pruebas obligatorias definidos en la sección 13 han sido ejecutados satisfactoriamente.
- No existen errores críticos que impidan la utilización de las funcionalidades principales.
- La aplicación web puede ser utilizada correctamente en los tamaños de pantalla y navegadores definidos para las pruebas de aceptación.

> **Criterio de aceptación final:** SIRA 1.0 será considerado apto para aceptación cuando todas las funcionalidades incluidas en el alcance del MVP puedan ser ejecutadas correctamente por los roles autorizados y los casos críticos definidos hayan sido aprobados.

## 17. Trazabilidad resumida

La siguiente matriz permite relacionar los principales requisitos funcionales de SIRA con las funcionalidades del MVP, los indicadores de éxito y los casos críticos definidos para su validación.

| Requisito | Funcionalidad MVP relacionada | KPI relacionado | Caso(s) de prueba |
|---|---|---|---|
| RF-01 Autenticación de usuario | MVP-01, MVP-02 | KPI-05 | CP-01, CP-02 |
| RF-02 Registrar aprendiz | MVP-03, MVP-08 | KPI-01, KPI-02, KPI-03, KPI-06, KPI-07 | CP-03, CP-04, CP-05 |
| RF-03 Consultar aprendiz | MVP-04 | KPI-04, KPI-05 | CP-06, CP-07 |
| RF-04 Listar aprendices | MVP-05 | KPI-04, KPI-05 | CP-11 |
| RF-05 Actualizar aprendiz | MVP-06, MVP-08 | KPI-03, KPI-05, KPI-07 | CP-08 |
| RF-06 Eliminar aprendiz | MVP-07 | KPI-05 | CP-09, CP-10 |
| RF-07 Controlar acceso por roles | MVP-02 | KPI-05 | CP-01, CP-10, CP-15, CP-16 |
| RF-08 Gestionar usuarios | MVP-10 | KPI-05 | CP-13, CP-14, CP-15, CP-16 |

> **Nota:** La trazabilidad permite verificar que los requisitos principales del MVP estén relacionados con funcionalidades, indicadores y mecanismos de validación. La matriz podrá ampliarse durante la planificación y el diseño de las pruebas.

## 18. Control de cambios

Los cambios realizados sobre este PRD deberán registrarse para mantener la trazabilidad de la evolución de los requisitos y del alcance de SIRA.

| Versión | Fecha | Descripción del cambio | Estado |
|---|---|---|---|
| 1.0 | 10 de septiembre de 2026 | Creación y aprobación inicial del PRD de SIRA. | Aprobado |
| 1.1 | 21 de septiembre de 2026 | Corrección editorial; identificación explícita de MVP-01 a MVP-10; incorporación de CP-13 a CP-16 para RF-08; actualización de trazabilidad. | Aprobado |

### Reglas de control de cambios

- Todo cambio que afecte el alcance, requisitos funcionales, requisitos no funcionales o condiciones de aceptación deberá ser documentado.
- Los nuevos requerimientos deberán ser analizados antes de incorporarse al alcance del producto.
- Los cambios aprobados deberán generar una nueva versión del PRD cuando corresponda.
- Las funcionalidades definidas para iteraciones posteriores no se considerarán parte del MVP hasta que sean formalmente aprobadas.
- Las versiones anteriores del PRD deberán conservarse como referencia histórica.
---

**Fin del PRD — SIRA, versión 1.1**
