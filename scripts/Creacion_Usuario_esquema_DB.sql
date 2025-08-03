Create Database Splotify_Staging


Create Database Splotify_DW
GO

create login splotify with password = 'splotify123'
Create user splotify for login splotify

USE Splotify_Staging
GO

Create Schema splotify
GO

grant select, update, delete, references, alter on SCHEMA::splotify to splotify
grant create table to splotify
GO

USE Splotify_DW
GO

Create Schema splotify
GO

grant select, update, delete, references, insert ,alter on SCHEMA::splotify to splotify
grant create table to splotify
GO
