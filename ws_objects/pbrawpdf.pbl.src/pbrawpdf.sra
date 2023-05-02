$PBExportHeader$pbrawpdf.sra
$PBExportComments$Generated Application Object
forward
global type pbrawpdf from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

end variables

global type pbrawpdf from application
string appname = "pbrawpdf"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 21.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "icono.ico"
string appruntimeversion = "22.0.0.1900"
boolean manualsession = false
boolean unsupportedapierror = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
end type
global pbrawpdf pbrawpdf

type variables

end variables

on pbrawpdf.create
appname="pbrawpdf"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pbrawpdf.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_main) 
end event

