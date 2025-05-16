forward
global type w_main from window
end type
type st_6 from statictext within w_main
end type
type pb_2 from picturebutton within w_main
end type
type st_5 from statictext within w_main
end type
type st_4 from statictext within w_main
end type
type pb_1 from picturebutton within w_main
end type
type st_1 from statictext within w_main
end type
type shl_1 from statichyperlink within w_main
end type
type pb_print from picturebutton within w_main
end type
type uo_printers from vuo_dw_impresoras within w_main
end type
type wb_1 from vs_web_browser within w_main
end type
type st_3 from statictext within w_main
end type
type p_1 from picture within w_main
end type
type st_infocopyright from statictext within w_main
end type
type st_myversion from statictext within w_main
end type
type st_platform from statictext within w_main
end type
type sle_archivo from singlelineedit within w_main
end type
type st_2 from statictext within w_main
end type
type cb_1 from commandbutton within w_main
end type
type r_2 from rectangle within w_main
end type
type dw_1 from datawindow within w_main
end type
end forward

global type w_main from window
integer width = 4631
integer height = 3368
boolean titlebar = true
string title = "PowerBuilder RawPrint"
boolean controlmenu = true
boolean minbox = true
string icon = "AppIcon!"
boolean center = true
st_6 st_6
pb_2 pb_2
st_5 st_5
st_4 st_4
pb_1 pb_1
st_1 st_1
shl_1 shl_1
pb_print pb_print
uo_printers uo_printers
wb_1 wb_1
st_3 st_3
p_1 p_1
st_infocopyright st_infocopyright
st_myversion st_myversion
st_platform st_platform
sle_archivo sle_archivo
st_2 st_2
cb_1 cb_1
r_2 r_2
dw_1 dw_1
end type
global w_main w_main

type prototypes
Function boolean QueryPerformanceFrequency ( &
	Ref Double lpFrequency &
	) Library "kernel32.dll"

Function boolean QueryPerformanceCounter ( &
	Ref Double lpPerformanceCount &
	) Library "kernel32.dll"

end prototypes

type variables
Double idbl_frequency = 0



end variables

forward prototypes
public subroutine wf_version (statictext ast_version, statictext ast_patform)
end prototypes

public subroutine wf_version (statictext ast_version, statictext ast_patform);String ls_version, ls_platform
environment env
integer rtn

rtn = GetEnvironment(env)

IF rtn <> 1 THEN 
	ls_version = string(year(today()))
	ls_platform="32"
ELSE
	ls_version = "20"+ string(env.pbmajorrevision)+ "." + string(env.pbbuildnumber)
	ls_platform=string(env.ProcessBitness)
END IF

ls_platform += " Bits"

ast_version.text=ls_version
ast_patform.text=ls_platform

end subroutine

on w_main.create
this.st_6=create st_6
this.pb_2=create pb_2
this.st_5=create st_5
this.st_4=create st_4
this.pb_1=create pb_1
this.st_1=create st_1
this.shl_1=create shl_1
this.pb_print=create pb_print
this.uo_printers=create uo_printers
this.wb_1=create wb_1
this.st_3=create st_3
this.p_1=create p_1
this.st_infocopyright=create st_infocopyright
this.st_myversion=create st_myversion
this.st_platform=create st_platform
this.sle_archivo=create sle_archivo
this.st_2=create st_2
this.cb_1=create cb_1
this.r_2=create r_2
this.dw_1=create dw_1
this.Control[]={this.st_6,&
this.pb_2,&
this.st_5,&
this.st_4,&
this.pb_1,&
this.st_1,&
this.shl_1,&
this.pb_print,&
this.uo_printers,&
this.wb_1,&
this.st_3,&
this.p_1,&
this.st_infocopyright,&
this.st_myversion,&
this.st_platform,&
this.sle_archivo,&
this.st_2,&
this.cb_1,&
this.r_2,&
this.dw_1}
end on

on w_main.destroy
destroy(this.st_6)
destroy(this.pb_2)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.shl_1)
destroy(this.pb_print)
destroy(this.uo_printers)
destroy(this.wb_1)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.st_infocopyright)
destroy(this.st_myversion)
destroy(this.st_platform)
destroy(this.sle_archivo)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.r_2)
destroy(this.dw_1)
end on

event open;wf_version(st_myversion, st_platform)
dw_1.settransobject(SQLCA)
uo_printers.of_register(dw_1)  //Registro un datawindow vacio para poder obtener las impresoras.

end event

type st_6 from statictext within w_main
integer x = 3150
integer y = 272
integer width = 274
integer height = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 553648127
string text = "Direct Print"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_main
integer x = 3218
integer y = 328
integer width = 110
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Hyperlink!"
string picturename = "PrintDataWindow!"
string disabledname = "PrintDataWindow!"
alignment htextalign = left!
string powertiptext = "Direct Print"
end type

event clicked;//With thanks to Frogmore Computer Services Ltd as the original author of the RawPrint project:
//https://github.com/frogmorecs/RawPrint

//Funcion para imprimir archivo directo a la impresora.
nvo_rawprint lo_rawprint
boolean lb_result
String ls_printer, ls_ruta

ls_ruta =  sle_archivo.Text 
ls_printer=uo_printers.of_getprinter() 

IF ls_ruta = "" THEN RETURN

if not FileExists(ls_ruta) then
	messagebox("Atención", "¡ No existe el Fichero "+ls_ruta+" !", Exclamation!, Ok!)
	return
end if	

lo_rawprint =  CREATE nvo_rawprint

lo_rawprint.of_printRawFile(ls_printer, ls_ruta, FALSE)

destroy lo_rawprint
end event

type st_5 from statictext within w_main
integer x = 2711
integer y = 272
integer width = 370
integer height = 52
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 553648127
string text = "Print With Dialog"
boolean focusrectangle = false
end type

type st_4 from statictext within w_main
integer x = 2034
integer y = 272
integer width = 288
integer height = 52
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 553648127
string text = "Brower Print"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_main
integer x = 2825
integer y = 328
integer width = 110
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Hyperlink!"
string picturename = "PrintDataWindow!"
string disabledname = "PrintDataWindow!"
alignment htextalign = left!
string powertiptext = "Print With Dialog"
end type

event clicked;IF sle_archivo.Text = "" THEN RETURN

wb_1.of_printwithdialog()
end event

type st_1 from statictext within w_main
integer x = 14
integer y = 192
integer width = 2414
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "With thanks to Frogmore Computer Services Ltd as the original author of the RawPrint project:"
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_main
integer x = 2446
integer y = 188
integer width = 869
integer height = 68
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 33521664
string text = "github.com/frogmorecs/RawPrint"
boolean focusrectangle = false
string url = "https://github.com/frogmorecs/RawPrint"
end type

type pb_print from picturebutton within w_main
integer x = 2112
integer y = 328
integer width = 110
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Hyperlink!"
boolean originalsize = true
string picturename = "PrintDataWindow!"
string disabledname = "PrintDataWindow!"
alignment htextalign = left!
string powertiptext = "Browser Print"
end type

event clicked;IF sle_archivo.Text = "" THEN RETURN

wb_1.Print()
end event

type uo_printers from vuo_dw_impresoras within w_main
event destroy ( )
integer x = 3415
integer y = 284
integer taborder = 110
end type

on uo_printers.destroy
call vuo_dw_impresoras::destroy
end on

type wb_1 from vs_web_browser within w_main
integer x = 64
integer y = 472
integer width = 4489
integer height = 2712
end type

type st_3 from statictext within w_main
integer x = 2121
integer y = 36
integer width = 1829
integer height = 156
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 33521664
string text = "PowerBuilder RawPrint"
alignment alignment = right!
boolean focusrectangle = false
end type

type p_1 from picture within w_main
integer x = 5
integer y = 4
integer width = 1253
integer height = 248
boolean originalsize = true
string picturename = "logo.jpg"
boolean focusrectangle = false
end type

type st_infocopyright from statictext within w_main
integer x = 3072
integer y = 3216
integer width = 1289
integer height = 56
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 553648127
string text = "Copyright © Ramón San Félix Ramón  rsrsystem.soft@gmail.com"
boolean focusrectangle = false
end type

type st_myversion from statictext within w_main
integer x = 4059
integer y = 60
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Versión"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_platform from statictext within w_main
integer x = 4059
integer y = 148
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Bits"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_archivo from singlelineedit within w_main
integer x = 251
integer y = 332
integer width = 1673
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_main
integer x = 73
integer y = 344
integer width = 169
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Pdf:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_main
integer x = 1934
integer y = 332
integer width = 174
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;integer li_rtn
string ls_path, ls_ruta
string  ls_current

ls_ruta="C:\Users\Ramon\Pictures\ControlCenter4\pdf\"
ls_current=GetCurrentDirectory ( )
li_rtn = GetFileOpenName("Archivo a cargar", sle_archivo.text, ls_path, "pdf", "Acrobat Reader (*.pdf), *.Pdf", ls_ruta)
ChangeDirectory ( ls_current )



if li_rtn < 1 then 	sle_archivo.text = ""

if not wb_1.of_loadfile(sle_archivo.text) then
	Messagebox("Error","Al cargar el archivo PDF", Stopsign!)
	sle_archivo.text = ""
end if
	

end event

type r_2 from rectangle within w_main
long linecolor = 33554432
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 33521664
integer width = 4599
integer height = 260
end type

type dw_1 from datawindow within w_main
integer x = 832
integer y = 1008
integer width = 686
integer height = 400
integer taborder = 110
string title = "none"
string dataobject = "dw_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

