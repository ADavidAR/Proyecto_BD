USE Splotify_DW;
GO

-- -----------------------------------------------------
-- Table Dim_Cancion
-- -----------------------------------------------------
CREATE TABLE splotify.Dim_Cancion (
  id_cancion INT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  duracion TIME NOT NULL,
  fecha_lanzamiento DATE NOT NULL,
  artista VARCHAR(500) NOT NULL,
  fecha_afiliacion_artista VARCHAR(200) NOT NULL,
  genero_musical VARCHAR(100) NOT NULL
)

-- -----------------------------------------------------
-- Table Dim_Album
-- -----------------------------------------------------
CREATE TABLE splotify.Dim_Album (
  id_album INT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  fecha_lanzamiento DATE NOT NULL,
  artista VARCHAR(500) NOT NULL,
  fecha_afiliacion_artista VARCHAR(500) NOT NULL
)

-- -----------------------------------------------------
-- Table Dim_Suscripcion
-- -----------------------------------------------------
CREATE TABLE splotify.Dim_Suscripcion (
  id_registro_suscripcion INT PRIMARY KEY,
  id_grupo INT,
  num_integrantes INT NOT NULL DEFAULT 1,
  titulo_suscripcion VARCHAR(50) NOT NULL,
  descripcion_suscripcion VARCHAR(max) NOT NULL,
  descripcion_promocion VARCHAR(max),
  fecha_inicio DATETIME NOT NULL,
  fecha_fin DATETIME NOT NULL,
  fecha_cancelacion DATETIME NULL,
  precio_dolar DECIMAL(10,2) NOT NULL,
  descuento DECIMAL(10,2) NOT NULL,
  nombre_usuario VARCHAR(100) NOT NULL,
  contrasena VARCHAR(100) NOT NULL,
  correo VARCHAR(100) NOT NULL,
  fecha_creacion DATE NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  genero VARCHAR(50) NOT NULL,
  pais VARCHAR(100) NOT NULL,
  region VARCHAR(100) NOT NULL
)

-- -----------------------------------------------------
-- Table Dim_Tiempo
-- -----------------------------------------------------
CREATE TABLE splotify.Dim_Tiempo (
  id_tiempo INT PRIMARY KEY IDENTITY,
  fecha DATE NOT NULL,
  anio INT NOT NULL,
  mes INT NOT NULL,
  dia INT NOT NULL,
  trimestre INT NOT NULL
)

-- -----------------------------------------------------
-- Table Hecho_Reproduccion
-- -----------------------------------------------------
CREATE TABLE splotify.Hecho_Reproduccion (
  id_reproduccion INT PRIMARY KEY,
  id_cancion INT NOT NULL,
  id_album INT NOT NULL,
  id_suscripcion INT NOT NULL,
  id_tiempo INT,
  tiempo_reproduccion TIME NOT NULL,
    FOREIGN KEY (id_cancion) REFERENCES splotify.Dim_Cancion (id_cancion),
    FOREIGN KEY (id_album) REFERENCES splotify.Dim_Album (id_album),
    FOREIGN KEY (id_suscripcion) REFERENCES splotify.Dim_Suscripcion (id_registro_suscripcion),
    FOREIGN KEY (id_tiempo) REFERENCES splotify.Dim_Tiempo (id_tiempo)
)


