USE Splotify_DW

IF OBJECT_ID('splotify.Hecho_Reproduccion', 'U') IS NOT NULL DROP Table splotify.Hecho_Reproduccion 

IF OBJECT_ID('splotify.Dim_Cancion', 'U') IS NOT NULL DROP Table splotify.Dim_Cancion

IF OBJECT_ID('splotify.Dim_Album', 'U') IS NOT NULL DROP Table splotify.Dim_Album

IF OBJECT_ID('splotify.Dim_Usuario', 'U') IS NOT NULL DROP Table splotify.Dim_Usuario

IF OBJECT_ID('splotify.Dim_Pais', 'U') IS NOT NULL DROP Table splotify.Dim_Pais

IF OBJECT_ID('splotify.Dim_Suscripcion', 'U') IS NOT NULL DROP Table splotify.Dim_Suscripcion

IF OBJECT_ID('splotify.Dim_Genero_Musical', 'U') IS NOT NULL DROP Table splotify.Dim_Genero_Musical 

IF OBJECT_ID('splotify.Dim_Promocion', 'U') IS NOT NULL DROP Table splotify.Dim_Promocion

IF OBJECT_ID('splotify.Dim_Tiempo', 'U') IS NOT NULL DROP Table splotify.Dim_Tiempo

