USE Splotify_Staging;
GO

-- -----------------------------------------------------
-- Table Album
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Album', 'U') IS NOT NULL DROP Table splotify.Album 
CREATE Table splotify.Album (
  id_album INT PRIMARY KEY IDENTITY,
  titulo VARCHAR(100) NOT NULL,
  fecha_lanzamiento DATE NOT NULL
)

-- -----------------------------------------------------
-- Table Genero_Musical
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Genero_Musical', 'U') IS NOT NULL DROP Table splotify.Genero_Musical 
CREATE Table splotify.Genero_Musical (
  id_genero_musical INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(100) NOT NULL
)

-- -----------------------------------------------------
-- Table Cancion
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Cancion', 'U') IS NOT NULL DROP Table splotify.Cancion 
CREATE Table splotify.Cancion (
  id_cancion INT PRIMARY KEY IDENTITY,
  titulo VARCHAR(100) NOT NULL,
  duracion TIME NOT NULL,
  fecha_lanzamiento DATE NOT NULL,
  id_album INT NOT NULL,
  id_genero_musical INT NOT NULL,
  FOREIGN KEY (id_album) REFERENCES splotify.Album (id_album),
  FOREIGN KEY (id_genero_musical) REFERENCES splotify.Genero_Musical (id_genero_musical)
)

-- -----------------------------------------------------
-- Table Artista
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Artista', 'U') IS NOT NULL DROP Table splotify.Artista 
CREATE Table splotify.Artista (
  id_artista INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(100) NOT NULL,
  fecha_afiliacion DATE NOT NULL
)

-- -----------------------------------------------------
-- Table Artista_X_Cancion
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Artista_X_Cancion', 'U') IS NOT NULL DROP Table splotify.Artista_X_Cancion 
CREATE Table splotify.Artista_X_Cancion (
  id_artista INT NOT NULL,
  id_cancion INT NOT NULL,
  PRIMARY KEY (id_artista, id_cancion),
  FOREIGN KEY (id_artista)REFERENCES splotify.Artista (id_artista),
  FOREIGN KEY (id_cancion)REFERENCES splotify.Cancion (id_cancion)
)

-- -----------------------------------------------------
-- Table Artista_X_Album
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Artista_X_Album', 'U') IS NOT NULL DROP Table splotify.Artista_X_Album 
CREATE Table splotify.Artista_X_Album (
  id_artista INT NOT NULL,
  id_album INT NOT NULL,
  PRIMARY KEY (id_artista, id_album),
  FOREIGN KEY (id_artista) REFERENCES splotify.Artista (id_artista),
  FOREIGN KEY (id_album) REFERENCES splotify.Album (id_album)
)

-- -----------------------------------------------------
-- Table Region
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Region', 'U') IS NOT NULL DROP Table splotify.Region 
CREATE Table splotify.Region (
  id_region INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(45) NULL
)

-- -----------------------------------------------------
-- Table Pais
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Pais', 'U') IS NOT NULL DROP Table splotify.Pais 
CREATE Table splotify.Pais (
  id_pais INT PRIMARY KEY IDENTITY,
  nombre VARCHAR(100) NOT NULL,
  id_region INT NOT NULL,
  FOREIGN KEY (id_region) REFERENCES splotify.Region (id_region)
)

-- -----------------------------------------------------
-- Table Genero
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Genero', 'U') IS NOT NULL DROP Table splotify.Genero 
CREATE Table splotify.Genero (
  id_genero INT PRIMARY KEY IDENTITY,
  descripcion VARCHAR(50) NOT NULL
)

-- -----------------------------------------------------
-- Table Usuario
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Usuario', 'U') IS NOT NULL DROP Table splotify.Usuario 
CREATE Table splotify.Usuario (
  id_usuario INT PRIMARY KEY IDENTITY,
  nombre_usuario VARCHAR(100) NOT NULL,
  contrasena VARCHAR(100) NOT NULL,
  correo VARCHAR(100) NOT NULL,
  fecha_creacion DATE NOT NULL,
  fecha_nacimiento DATE NULL,
  id_pais INT NOT NULL,
  id_genero INT NOT NULL,
  FOREIGN KEY (id_pais) REFERENCES splotify.Pais (id_pais),
  FOREIGN KEY (id_genero) REFERENCES splotify.Genero (id_genero)
)

-- -----------------------------------------------------
-- Table Grupo
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Grupo', 'U') IS NOT NULL DROP Table splotify.Grupo 
CREATE Table splotify.Grupo (
  id_grupo INT PRIMARY KEY IDENTITY,
  max_integrantes INT CHECK(max_integrantes  IN (2,6))
)

-- -----------------------------------------------------
-- Table Suscripcion
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Suscripcion', 'U') IS NOT NULL DROP Table splotify.Suscripcion 
CREATE Table splotify.Suscripcion (
  id_suscripcion INT PRIMARY KEY IDENTITY,
  titulo VARCHAR(45) NOT NULL,
  descripcion VARCHAR(max) NOT NULL,
  precio DECIMAL(10,2) NOT NULL
)

-- -----------------------------------------------------
-- Table Suscripcion_X_Usuario
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Suscripcion_X_Usuario', 'U') IS NOT NULL DROP Table splotify.Suscripcion_X_Usuario 
CREATE Table splotify.Suscripcion_X_Usuario (
  id_registro_suscripcion INT PRIMARY KEY IDENTITY,
  id_suscripcion INT NOT NULL,
  id_usuario INT NOT NULL,
  id_grupo INT,
  fecha_inicio DATETIME NOT NULL,
  fecha_fin DATETIME NOT NULL,
  fecha_cancelacion DATETIME NULL,
  precio_dolar DECIMAL(10,2) NOT NULL,
  descuento DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_suscripcion) REFERENCES splotify.Suscripcion (id_suscripcion),
  FOREIGN KEY (id_usuario) REFERENCES splotify.Usuario (id_usuario),
  FOREIGN KEY (id_grupo) REFERENCES splotify.Grupo(id_grupo)
)

-- -----------------------------------------------------
-- Table Reproduccion
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Reproduccion', 'U') IS NOT NULL DROP Table splotify.Reproduccion 
CREATE Table splotify.Reproduccion (
  id_reproduccion INT PRIMARY KEY IDENTITY,
  id_usuario INT NOT NULL,
  id_cancion INT NOT NULL,
  tiempo_reproduccion TIME NOT NULL,
  fecha_reproduccion DATETIME NULL,
  FOREIGN KEY (id_usuario) REFERENCES splotify.Usuario (id_usuario),
  FOREIGN KEY (id_cancion) REFERENCES splotify.Cancion (id_cancion)
)

-- -----------------------------------------------------
-- Table Promocion
-- -----------------------------------------------------
IF OBJECT_ID('splotify.Promocion', 'U') IS NOT NULL DROP Table splotify.Promocion 
CREATE Table splotify.Promocion (
  id_promocion INT PRIMARY KEY IDENTITY,
  descripcion VARCHAR(MAX) NOT NULL,
  descuento DECIMAL(10,2) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  id_suscripcion INT NOT NULL,
  FOREIGN KEY (id_suscripcion) REFERENCES splotify.Suscripcion (id_suscripcion)    
)
