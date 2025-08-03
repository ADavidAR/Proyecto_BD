USE Splotify_Staging;
GO

-- Insertar datos en Genero_Musical
INSERT INTO splotify.Genero_Musical (nombre) VALUES
('Pop'), ('Rock'), ('Hip Hop'), ('R&B'), ('Electrónica'),
('Reggaeton'), ('Salsa'), ('Balada'), ('Jazz'), ('Clásica'),
('Country'), ('Metal'), ('Indie'), ('Folk'), ('Blues'),
('K-Pop'), ('Reggae'), ('Soul'), ('Funk'), ('Disco');

-- Insertar datos en Region
INSERT INTO splotify.Region (nombre) VALUES
('América del Norte'), ('América Latina'), ('Europa'),
('Asia'), ('África'), ('Oceanía'), ('Caribe');

-- Insertar datos en Pais
INSERT INTO splotify.Pais (nombre, id_region) VALUES
('Estados Unidos', 1), ('Canadá', 1), ('México', 2),
('Brasil', 2), ('Argentina', 2), ('Colombia', 2),
('España', 3), ('Francia', 3), ('Alemania', 3),
('Reino Unido', 3), ('Italia', 3), ('China', 4),
('Japón', 4), ('Corea del Sur', 4), ('India', 4),
('Sudáfrica', 5), ('Australia', 6), ('Nueva Zelanda', 6),
('República Dominicana', 7), ('Puerto Rico', 7);

-- Insertar datos en Genero
INSERT INTO splotify.Genero (descripcion) VALUES
('Masculino'), ('Femenino'), ('No binario'), ('Otro'), ('Prefiero no decir');

-- Insertar datos en Suscripcion
INSERT INTO splotify.Suscripcion (titulo, descripcion, precio) VALUES
('Gratis', 'Suscripción básica gratuita con anuncios', 0.00),
('Individual', 'Suscripción premium para una persona', 9.99),
('Estudiante', 'Suscripción premium con descuento para estudiantes', 4.99),
('Familiar', 'Suscripción premium para hasta 6 miembros', 14.99),
('Duo', 'Suscripción premium para 2 personas', 12.99);

-- Insertar datos en Usuario (50 usuarios)
DECLARE @i INT = 1;
DECLARE @startDate DATE = DATEADD(YEAR, -3, GETDATE());
DECLARE @endDate DATE = GETDATE();

WHILE @i <= 50
BEGIN
    INSERT INTO splotify.Usuario (nombre_usuario, contrasena, correo, fecha_creacion, fecha_nacimiento, id_pais, id_genero)
    VALUES (
        'usuario' + CAST(@i AS VARCHAR),
        CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'password' + CAST(@i AS VARCHAR)), 2),
        'usuario' + CAST(@i AS VARCHAR) + '@example.com',
        DATEADD(DAY, ABS(CHECKSUM(NEWID()) % DATEDIFF(DAY, @startDate, @endDate)), @startDate),
        DATEADD(YEAR, -20 - (ABS(CHECKSUM(NEWID())) % 30), DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), CAST('2000-01-01' AS DATE))),
        1 + (ABS(CHECKSUM(NEWID())) % 19),
        1 + (ABS(CHECKSUM(NEWID())) % 5)
    );
    SET @i = @i + 1;
END

-- Insertar suscripciones gratuitas para todos los usuarios
INSERT INTO splotify.Suscripcion_X_Usuario (id_suscripcion, id_usuario, fecha_inicio, fecha_fin, fecha_cancelacion, precio_dolar, descuento)
SELECT 
    1, 
    id_usuario, 
    fecha_creacion, 
    '9999-12-31', 
    NULL, 
    0.00, 
    0.00
FROM splotify.Usuario;

-- Insertar otras suscripciones aleatorias para algunos usuarios
DECLARE @j INT = 1;
DECLARE @userCount INT = (SELECT COUNT(*) FROM splotify.Usuario);
DECLARE @subCount INT = (SELECT COUNT(*) FROM splotify.Suscripcion);

WHILE @j <= 30 -- 30 suscripciones premium
BEGIN
    DECLARE @userId INT = 1 + (ABS(CHECKSUM(NEWID())) % @userCount);
    DECLARE @subId INT = 2 + (ABS(CHECKSUM(NEWID())) % (@subCount - 1)); -- Corregido aquí
    DECLARE @startSubDate DATETIME = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, DATEADD(YEAR, -2, GETDATE()));
    DECLARE @endSubDate DATETIME = DATEADD(MONTH, 3 + (ABS(CHECKSUM(NEWID())) % 9), @startSubDate); -- Corregido aquí
    DECLARE @cancelDate DATETIME = CASE WHEN ABS(CHECKSUM(NEWID())) % 3 = 0 THEN DATEADD(DAY, 10 + (ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, @startSubDate, @endSubDate)), @startSubDate) ELSE NULL END;
    DECLARE @price DECIMAL(10,2) = (SELECT precio FROM splotify.Suscripcion WHERE id_suscripcion = @subId);
    DECLARE @discount DECIMAL(10,2) = CASE WHEN ABS(CHECKSUM(NEWID())) % 4 = 0 THEN 10.00 ELSE 0.00 END;

	DECLARE @id_reg_sub INT = (Select id_registro_suscripcion from splotify.Suscripcion_X_Usuario Where id_suscripcion = 1 AND id_usuario =  @userId)
	UPDATE splotify.Suscripcion_X_Usuario SET fecha_fin = (SELECT Min(fecha_inicio) From splotify.Suscripcion_X_Usuario WHERE id_registro_suscripcion <> @id_reg_sub AND id_usuario = @userId)
	Where id_registro_suscripcion = @id_reg_sub
    
    INSERT INTO splotify.Suscripcion_X_Usuario (id_suscripcion, id_usuario, fecha_inicio, fecha_fin, fecha_cancelacion, precio_dolar, descuento)
    VALUES (@subId, @userId, @startSubDate, @endSubDate, @cancelDate, @price, @discount);
    
    SET @j = @j + 1;
END
-- Insertar datos en Artista (30 artistas)
DECLARE @k INT = 1;
WHILE @k <= 30
BEGIN
    INSERT INTO splotify.Artista (nombre, fecha_afiliacion)
    VALUES (
        CASE 
            WHEN @k % 10 = 0 THEN 'Artista ' + CAST(@k AS VARCHAR) + ' y los ' + CHOOSE(1 + (@k % 6), 'Ritmos', 'Sonidos', 'Acordes', 'Notas', 'Melodías', 'Armonías')
            WHEN @k % 5 = 0 THEN 'DJ ' + CAST(@k AS VARCHAR)
            ELSE 'Artista ' + CAST(@k AS VARCHAR)
        END,
        DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1095, DATEADD(YEAR, -3, GETDATE()))
    );
    SET @k = @k + 1;
END

-- Insertar datos en Album (50 álbumes)
DECLARE @l INT = 1;
WHILE @l <= 50
BEGIN
    INSERT INTO splotify.Album (titulo, fecha_lanzamiento)
    VALUES (
        CASE 
            WHEN @l % 10 = 0 THEN 'Álbum ' + CAST(@l AS VARCHAR) + ': La Gran Colección'
            WHEN @l % 5 = 0 THEN 'Lo Mejor del Artista ' + CAST(@l % 10 AS VARCHAR)
            ELSE 'Álbum ' + CAST(@l AS VARCHAR)
        END,
        DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1095, DATEADD(YEAR, -3, GETDATE()))
    );
    SET @l = @l + 1;
END

-- Asociar artistas a álbumes (Artista_X_Album)
DECLARE @m INT = 1;
DECLARE @artistCount INT = (SELECT COUNT(*) FROM splotify.Artista);
DECLARE @albumCount INT = (SELECT COUNT(*) FROM splotify.Album);

WHILE @m <= 70 -- 70 asociaciones
BEGIN
    DECLARE @artistId INT = 1 + (ABS(CHECKSUM(NEWID())) % @artistCount);
    DECLARE @albumId INT = 1 + (ABS(CHECKSUM(NEWID()))) % @albumCount;
    
    -- Evitar duplicados
    IF NOT EXISTS (SELECT 1 FROM splotify.Artista_X_Album WHERE id_artista = @artistId AND id_album = @albumId)
    BEGIN
        INSERT INTO splotify.Artista_X_Album (id_artista, id_album)
        VALUES (@artistId, @albumId);
        SET @m = @m + 1;
    END
END

-- Insertar datos en Cancion (200 canciones)
DECLARE @n INT = 1;
WHILE @n <= 200
BEGIN
    INSERT INTO splotify.Cancion (titulo, duracion, fecha_lanzamiento, id_album, id_genero_musical)
    VALUES (
        CASE 
            WHEN @n % 20 = 0 THEN 'Canción ' + CAST(@n AS VARCHAR) + ' (Remix)'
            WHEN @n % 10 = 0 THEN 'Gran Éxito ' + CAST(@n/10 AS VARCHAR)
            ELSE 'Canción ' + CAST(@n AS VARCHAR)
        END,
        DATEADD(SECOND, 120 + (ABS(CHECKSUM(NEWID())) % 240), CAST('00:00:00' AS TIME)),
        DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1095, DATEADD(YEAR, -3, GETDATE())),
        1 + (ABS(CHECKSUM(NEWID())) % @albumCount),
        1 + (ABS(CHECKSUM(NEWID()))) % 20
    );
    SET @n = @n + 1;
END

-- Asociar artistas a canciones (Artista_X_Cancion)
DECLARE @o INT = 1;
DECLARE @songCount INT = (SELECT COUNT(*) FROM splotify.Cancion);

WHILE @o <= 300 -- 300 asociaciones
BEGIN
    DECLARE @artistId2 INT = 1 + (ABS(CHECKSUM(NEWID())) % @artistCount);
    DECLARE @songId INT = 1 + (ABS(CHECKSUM(NEWID()))) % @songCount;
    
    -- Evitar duplicados
    IF NOT EXISTS (SELECT 1 FROM splotify.Artista_X_Cancion WHERE id_artista = @artistId2 AND id_cancion = @songId)
    BEGIN
        INSERT INTO splotify.Artista_X_Cancion (id_artista, id_cancion)
        VALUES (@artistId2, @songId);
        SET @o = @o + 1;
    END
END

-- Insertar datos en Promocion
INSERT INTO splotify.Promocion (descuento, fecha_inicio, fecha_fin, id_suscripcion) VALUES
(50.00, '2022-11-01', '2022-11-30', 2), -- Black Friday Individual
(50.00, '2022-11-01', '2022-11-30', 4), -- Black Friday Familiar
(40.00, '2023-06-01', '2023-06-30', 2), -- Verano Individual
(30.00, '2023-12-01', '2023-12-31', 3), -- Navidad Estudiante
(25.00, '2024-02-01', '2024-02-29', 5); -- San Valentín Duo

-- Insertar 2000 reproducciones
DECLARE @p INT = 1;
WHILE @p <= 2000
BEGIN
    DECLARE @userId2 INT = 1 + (ABS(CHECKSUM(NEWID())) % @userCount);
    DECLARE @songId2 INT = 1 + (ABS(CHECKSUM(NEWID())) % @songCount);
    DECLARE @playTime TIME = DATEADD(SECOND, 10 + (ABS(CHECKSUM(NEWID()))) % 230, CAST('00:00:00' AS TIME));

	DECLARE @sus TABLE(rn int, dt1 datetime, dt2 datetime) 
	DECLARE @cuenta_sus INT = (SELECT COUNT(1) FROM splotify.Suscripcion_X_Usuario WHERE id_usuario = @userId2);
	DECLARE @index INT = 1 + (ABS(CHECKSUM(NEWID())) % @cuenta_sus);

	Insert into @sus	
	SELECT ROW_NUMBER() Over (Order by fecha_inicio) rn, fecha_inicio, fecha_fin FROM splotify.Suscripcion_X_Usuario WHERE id_usuario = @userId2

	DECLARE @FechaMin Datetime = (Select dt1 from @sus Where rn = @index)
	DECLARE @FechaMax Datetime = (Select min(dt2) from @sus Where rn = @index)

	IF @FechaMax > Cast('2025-08-02' AS DATETIME)
		SET @FechaMax = Cast('2025-08-02' AS DATETIME)

	DECLARE @DiasDiferencia INT = DATEDIFF(DAY, @FechaMin, @FechaMax)
	DECLARE @playDate DATE

	-- Generar fecha aleatoria
	SET @playDate = DATEADD(DAY, CAST(RAND() * @DiasDiferencia AS INT), @FechaMin)
    
    INSERT INTO splotify.Reproduccion (id_usuario, id_cancion, tiempo_reproduccion, fecha_reproduccion)
    VALUES (@userId2, @songId2, @playTime, @playDate);
    
    SET @p = @p + 1;
	Delete from @sus
END



