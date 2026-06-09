-- =====================================================
--  BDCursosEmpresas
-- =====================================================
USE MASTER;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'BDCursosEmpresas')
BEGIN
    DROP DATABASE BDCursosEmpresas;
END;
GO
CREATE DATABASE BDCursosEmpresas
COLLATE Latin1_General_CI_AI;
GO

USE BDCursosEmpresas;
GO

CREATE TABLE Roles (
    IDRol       INT          IDENTITY(1,1) NOT NULL,
    nombre      VARCHAR(50)  NOT NULL,
    descripcion VARCHAR(255),

    CONSTRAINT PK_IDRol PRIMARY KEY (IDRol)
);

-- =====================================================
-- EMPRESAS Depende de: Roles
-- =====================================================
CREATE TABLE Empresas (
    IDEmpresa INT          IDENTITY(1,1) NOT NULL,
    nombre    VARCHAR(255) NOT NULL,
    IDRol     INT          NOT NULL,

    CONSTRAINT PK_IDEmpresa PRIMARY KEY (IDEmpresa),

    CONSTRAINT FK_Empresas_Roles FOREIGN KEY (IDRol) REFERENCES Roles (IDRol)
);

CREATE TABLE TiposSuscripcion (
    IDTipoSuscripcion INT          IDENTITY(1,1) NOT NULL,
    nombre            VARCHAR(50)  NOT NULL,
    Detalle           VARCHAR(100) NOT NULL,
    Duracion          INT,                      -- duracion en dias, NULL = sin vencimiento
    Precio            MONEY        NOT NULL,

    CONSTRAINT PK_IDTipoSuscripcion PRIMARY KEY (IDTipoSuscripcion)
);


CREATE TABLE USUARIO (
    IDUsuario         INT          IDENTITY(1,1) NOT NULL,
    nombre            VARCHAR(50),
    apellido          VARCHAR(50),
    mail              VARCHAR(100),
    contrasena        VARCHAR(255),              -- guardar siempre el hash, nunca texto plano
    FechaDeInscripcion DATE         NULL,

    CONSTRAINT PK_IDUsuario PRIMARY KEY (IDUsuario)
);

-- =====================================================
-- SUSCRIPCION Depende de: TiposSuscripcion, USUARIO
-- =====================================================
CREATE TABLE Suscripcion (
    IDSuscripcion     INT  IDENTITY(1,1) NOT NULL,
    IDTipoSuscripcion INT  NOT NULL,
    IDUsuario         INT  NOT NULL,
    FechaInicio       DATE DEFAULT (GETDATE()),
    FechaFinalizacion DATE NULL,
    Activa            BIT  DEFAULT (0),

    CONSTRAINT PK_IDSuscripcion PRIMARY KEY (IDSuscripcion),

    CONSTRAINT FK_Suscripcion_TiposSuscripcion
        FOREIGN KEY (IDTipoSuscripcion) REFERENCES TiposSuscripcion (IDTipoSuscripcion),

    CONSTRAINT FK_Suscripcion_Usuario
        FOREIGN KEY (IDUsuario) REFERENCES USUARIO (IDUsuario)
);

-- =====================================================
-- CURSO Depende de: Empresas
-- =====================================================
CREATE TABLE Curso (
    IDCurso      INT          IDENTITY(1,1) NOT NULL,
    nombre       VARCHAR(100) NOT NULL,
    descripcion  VARCHAR(250),
    IDEmpresa    INT          NOT NULL,

    CONSTRAINT PK_IDCurso PRIMARY KEY (IDCurso),

    CONSTRAINT FK_Curso_Empresa
        FOREIGN KEY (IDEmpresa) REFERENCES Empresas (IDEmpresa)
);

-- =====================================================
-- 7. ARCHIVO Depende de: Curso, USUARIO
-- =====================================================
CREATE TABLE Archivo (
    IDArchivo  INT IDENTITY(1,1) NOT NULL,
    IDCurso    INT NOT NULL,
    IDUsuario  INT NOT NULL,
    Completado BIT DEFAULT (0),

    CONSTRAINT PK_IDArchivo PRIMARY KEY (IDArchivo),

    CONSTRAINT FK_Archivo_Curso
        FOREIGN KEY (IDCurso)   REFERENCES Curso   (IDCurso),

    CONSTRAINT FK_Archivo_Usuario
        FOREIGN KEY (IDUsuario) REFERENCES USUARIO (IDUsuario)
);

-- =====================================================
-- 8. INSCRIPCION Depende de: USUARIO, Curso
-- =====================================================
CREATE TABLE Inscripcion (
    IDInscripcion INT IDENTITY(1,1) NOT NULL,
    IDUsuario     INT NOT NULL,
    IDCurso       INT NOT NULL,
    Completado    BIT NOT NULL DEFAULT (0),

    CONSTRAINT PK_IDInscripcion PRIMARY KEY (IDInscripcion),

    CONSTRAINT FK_Inscripcion_Usuario
        FOREIGN KEY (IDUsuario) REFERENCES USUARIO (IDUsuario),

    CONSTRAINT FK_Inscripcion_Curso
        FOREIGN KEY (IDCurso)   REFERENCES Curso   (IDCurso)
);

-- =====================================================
-- EVALUACION Depende de: Curso
-- =====================================================
CREATE TABLE Evaluacion (
    IDEvaluacion INT         IDENTITY(1,1) NOT NULL,
    IDCurso      INT         NOT NULL,
    Titulo       VARCHAR(50),
    Puntaje      INT         NULL,

    CONSTRAINT PK_IDEvaluacion PRIMARY KEY (IDEvaluacion),

    CONSTRAINT FK_Evaluacion_Curso
        FOREIGN KEY (IDCurso) REFERENCES Curso (IDCurso)
);

-- =====================================================
--  RESULTADO EVALUACION Depende de: USUARIO, Evaluacion
-- =====================================================
CREATE TABLE ResultadoEvaluacion (
    IDResultado  INT IDENTITY(1,1) NOT NULL,
    IDEvaluacion INT NOT NULL,
    IDUsuario    INT NOT NULL,
    Aprobado     BIT DEFAULT (0),

    CONSTRAINT PK_IDResultado PRIMARY KEY (IDResultado),

    CONSTRAINT FK_ResultadoEval_Usuario
        FOREIGN KEY (IDUsuario)    REFERENCES USUARIO    (IDUsuario),

    CONSTRAINT FK_ResultadoEval_Evaluacion
        FOREIGN KEY (IDEvaluacion) REFERENCES Evaluacion (IDEvaluacion)
);

-- =====================================================
-- CERTIFICADOS Depende de: Curso, USUARIO, ResultadoEvaluacion
-- =====================================================
CREATE TABLE Certificados (
    IDCertificado INT  IDENTITY(1,1) NOT NULL,
    IDCurso       INT  NOT NULL,
    IDResultado   INT  NOT NULL,
    IDUsuario     INT  NOT NULL,
    FechaDeEmision DATE DEFAULT (GETDATE()),

    CONSTRAINT PK_Certificados PRIMARY KEY (IDCertificado),

    CONSTRAINT FK_Certificados_Curso
        FOREIGN KEY (IDCurso)     REFERENCES Curso               (IDCurso),

    CONSTRAINT FK_Certificados_Usuario
        FOREIGN KEY (IDUsuario)   REFERENCES USUARIO             (IDUsuario),

    CONSTRAINT FK_Certificados_Resultado
        FOREIGN KEY (IDResultado) REFERENCES ResultadoEvaluacion (IDResultado)
);