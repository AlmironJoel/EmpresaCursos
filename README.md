# BDCursosEmpresas

Base de datos para una plataforma de gestión de cursos corporativos. Permite administrar empresas, usuarios, suscripciones, cursos, inscripciones, evaluaciones y certificados.

---

## Esquema de Tablas

### Roles
Almacena los roles disponibles que pueden tener las empresas dentro de la plataforma.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDRol | INT PRIMARY KEY IDENTITY(1,1) | Identificador único del rol. |
| nombre | VARCHAR(50) NOT NULL | Nombre del rol. |
| descripcion | VARCHAR(255) | Descripción detallada del rol. |

---

### Empresas
Registra las empresas que utilizan la plataforma y el rol que desempeñan en ella.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDEmpresa | INT PRIMARY KEY IDENTITY(1,1) | Identificador único de la empresa. |
| nombre | VARCHAR(255) NOT NULL | Nombre de la empresa. |
| IDRol | INT NOT NULL | Rol asignado a la empresa. Referencia a `Roles`. |

---

### TiposSuscripcion
Catálogo de los tipos de suscripción disponibles en la plataforma.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDTipoSuscripcion | INT PRIMARY KEY IDENTITY(1,1) | Identificador único del tipo de suscripción. |
| nombre | VARCHAR(50) NOT NULL | Nombre del tipo de suscripción. |
| Detalle | VARCHAR(100) NOT NULL | Descripción detallada del tipo de suscripción. |
| Duracion | INT | Duración en días. `NULL` indica sin vencimiento. |
| Precio | MONEY NOT NULL | Precio del tipo de suscripción. |

---

### USUARIO
Contiene la información de los usuarios registrados en la plataforma.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDUsuario | INT PRIMARY KEY IDENTITY(1,1) | Identificador único del usuario. |
| nombre | VARCHAR(50) | Nombre del usuario. |
| apellido | VARCHAR(50) | Apellido del usuario. |
| mail | VARCHAR(100) | Correo electrónico del usuario. |
| contrasena | VARCHAR(255) | Hash de la contraseña del usuario. |
| FechaDeInscripcion | DATE | Fecha en la que el usuario se registró en la plataforma. |

---

### Suscripcion
Registra las suscripciones activas e históricas de cada usuario.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDSuscripcion | INT PRIMARY KEY IDENTITY(1,1) | Identificador único de la suscripción. |
| IDTipoSuscripcion | INT NOT NULL | Tipo de suscripción contratado. Referencia a `TiposSuscripcion`. |
| IDUsuario | INT NOT NULL | Usuario al que pertenece la suscripción. Referencia a `USUARIO`. |
| FechaInicio | DATE DEFAULT GETDATE() | Fecha de inicio de la suscripción. |
| FechaFinalizacion | DATE | Fecha de finalización. `NULL` si no vence. |
| Activa | BIT DEFAULT 0 | Indica si la suscripción se encuentra activa. |

---

### Curso
Almacena los cursos ofrecidos por las empresas dentro de la plataforma.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDCurso | INT PRIMARY KEY IDENTITY(1,1) | Identificador único del curso. |
| nombre | VARCHAR(100) NOT NULL | Nombre del curso. |
| descripcion | VARCHAR(250) | Descripción del contenido del curso. |
| IDEmpresa | INT NOT NULL | Empresa que ofrece el curso. Referencia a `Empresas`. |

---

### Archivo
Registra los archivos asociados a cada curso y el progreso del usuario sobre ellos.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDArchivo | INT PRIMARY KEY IDENTITY(1,1) | Identificador único del archivo. |
| IDCurso | INT NOT NULL | Curso al que pertenece el archivo. Referencia a `Curso`. |
| IDUsuario | INT NOT NULL | Usuario asociado al archivo. Referencia a `USUARIO`. |
| Completado | BIT DEFAULT 0 | Indica si el usuario completó el archivo. |

---

### Inscripcion
Registra las inscripciones de los usuarios a los cursos disponibles.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDInscripcion | INT PRIMARY KEY IDENTITY(1,1) | Identificador único de la inscripción. |
| IDUsuario | INT NOT NULL | Usuario inscripto. Referencia a `USUARIO`. |
| IDCurso | INT NOT NULL | Curso en el que se inscribió el usuario. Referencia a `Curso`. |
| Completado | BIT NOT NULL DEFAULT 0 | Indica si el usuario completó el curso. |

---

### Evaluacion
Almacena las evaluaciones asociadas a cada curso.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDEvaluacion | INT PRIMARY KEY IDENTITY(1,1) | Identificador único de la evaluación. |
| IDCurso | INT NOT NULL | Curso al que pertenece la evaluación. Referencia a `Curso`. |
| Titulo | VARCHAR(50) | Título de la evaluación. |
| Puntaje | INT | Puntaje máximo de la evaluación. |

---

### ResultadoEvaluacion
Registra el resultado obtenido por cada usuario en cada evaluación.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDResultado | INT PRIMARY KEY IDENTITY(1,1) | Identificador único del resultado. |
| IDEvaluacion | INT NOT NULL | Evaluación rendida. Referencia a `Evaluacion`. |
| IDUsuario | INT NOT NULL | Usuario que rindió la evaluación. Referencia a `USUARIO`. |
| Aprobado | BIT DEFAULT 0 | Indica si el usuario aprobó la evaluación. |

---

### Certificados
Registra los certificados emitidos a los usuarios que completaron y aprobaron un curso.

| Atributo | Tipo de Dato | Descripción |
|---|---|---|
| IDCertificado | INT PRIMARY KEY IDENTITY(1,1) | Identificador único del certificado. |
| IDCurso | INT NOT NULL | Curso por el que se emite el certificado. Referencia a `Curso`. |
| IDResultado | INT NOT NULL | Resultado que habilita el certificado. Referencia a `ResultadoEvaluacion`. |
| IDUsuario | INT NOT NULL | Usuario al que se emite el certificado. Referencia a `USUARIO`. |
| FechaDeEmision | DATE DEFAULT GETDATE() | Fecha en la que se emitió el certificado. |

---

## Orden de creación de tablas

El orden respeta las dependencias entre tablas (sin ciclos):
