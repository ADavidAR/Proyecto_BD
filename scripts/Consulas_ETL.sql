-- Dim_Album
Select al.id_album, 
	   titulo, 
	   fecha_lanzamiento, 
	   STRING_AGG(ar.nombre, ',') artista, 
	   STRING_AGG(CAST(ar.fecha_afiliacion AS varchar(500)), ',') fecha_afiliacion_artista
From splotify.Album al
Join splotify.Artista_X_Album aa ON aa.id_album = al.id_album
Join splotify.Artista ar ON aa.id_artista = ar.id_artista
GROUP BY al.id_album, titulo, fecha_lanzamiento

-- Dim_Cancion
Select c.id_cancion, 
	   titulo,
	   duracion,
	   fecha_lanzamiento, 
	   STRING_AGG(ar.nombre, ',') artista, 
	   STRING_AGG(CAST(ar.fecha_afiliacion AS varchar(500)), ',') fecha_afiliacion_artista,
	   gm.nombre AS genero_musical
From splotify.Cancion c
Join splotify.Artista_X_Cancion ac ON ac.id_cancion = c.id_cancion
Join splotify.Artista ar ON ac.id_artista = ar.id_artista
Join splotify.Genero_Musical gm ON gm.id_genero_musical = c.id_genero_musical
GROUP BY c.id_cancion, titulo, duracion, fecha_lanzamiento, gm.nombre

--Dim_suscripcion
Select su.id_registro_suscripcion,
	   su.id_grupo,
	   COALESCE((Select COUNT(1) From splotify.Suscripcion_X_Usuario Where id_grupo = su.id_grupo), 1) num_integrantes,
	   s.titulo as titulo_suscripcion,
	   s.descripcion AS descripcion_suscripcion,
	   (Select pro.descripcion
		From splotify.Promocion pro
		Where id_suscripcion = su.id_suscripcion 
			  AND (su.fecha_inicio BETWEEN pro.fecha_inicio AND pro.fecha_fin)
	   ) AS descripcion_promocion,

	   su.fecha_inicio,
	   su.fecha_fin,
	   su.fecha_cancelacion,
	   su.precio_dolar,
	   su.descuento,
	   u.nombre_usuario,
	   u.contrasena,
	   u.correo,
	   u.fecha_creacion,
	   u.fecha_nacimiento,
	   ge.descripcion AS genero,
	   pa.nombre AS pais,
	   r.nombre AS region
From splotify.Suscripcion_X_Usuario su
Left Join splotify.Suscripcion s ON s.id_suscripcion=su.id_suscripcion
Left Join splotify.Grupo g ON g.id_grupo = su.id_grupo
Left Join splotify.Promocion p ON p.id_suscripcion = s.id_suscripcion
Left Join splotify.Usuario u ON u.id_usuario = su.id_usuario
Left Join splotify.Pais pa ON pa.id_pais = u.id_pais
Left Join splotify.Region r ON r.id_region = pa.id_region
Left Join splotify.Genero ge ON ge.id_genero = u.id_genero

--Dim_Tiempo
BEGIN
DECLARE @fecha_inicio DATE = CAST( '2023-01-01' AS DATE)
DECLARE @fecha_fin DATE = CAST( '2025-12-31' AS DATE)
DECLARE @anio INT
DECLARE @mes INT
DECLARE @dia INT
DECLARE @trimestre INT
WHILE @fecha_inicio < @fecha_fin
Begin
	Print(@fecha_inicio)
	SET @anio = YEAR(@fecha_inicio)
	SET @mes = MONTH(@fecha_inicio)
	SET @dia = DAY(@fecha_inicio)
	
	SET @trimestre = CASE 
						WHEN @mes <= 3 THEN 1 
						WHEN @mes <= 6 THEN 2 
						WHEN @mes <= 9 THEN 3 
						WHEN @mes <= 12 THEN 4 
						END
	Insert Into splotify.Dim_Tiempo(fecha, anio, mes, dia, trimestre) VALUES
	(@fecha_inicio, @anio, @mes, @dia, @trimestre)

	SET @fecha_inicio = DATEADD(DAY, 1, @fecha_inicio)
End
END

--Hecho_Reproduccion
Select r.id_reproduccion,
	   c.id_cancion,
	   c.id_album,
	   su.id_registro_suscripcion id_suscripcion,
	   DATEDIFF(DAY, CAST( '2023-01-01' AS DATE), r.fecha_reproduccion) + 1 id_tiempo,
	   r.tiempo_reproduccion
From splotify.Reproduccion r
Left Join splotify.Usuario u ON u.id_usuario = r.id_usuario
Left Join splotify.Cancion c ON c.id_cancion = r.id_cancion
Left Join splotify.Suscripcion_X_Usuario su ON su.id_usuario = u.id_usuario
Where r.fecha_reproduccion BETWEEN su.fecha_inicio AND su.fecha_fin

