forward
global type vuo_dw_impresoras from userobject
end type
type st_impresora from statictext within vuo_dw_impresoras
end type
type cb_impresora from commandbutton within vuo_dw_impresoras
end type
type gb_1 from groupbox within vuo_dw_impresoras
end type
end forward

global type vuo_dw_impresoras from userobject
integer width = 1111
integer height = 176
long backcolor = 553648127
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_impresora st_impresora
cb_impresora cb_impresora
gb_1 gb_1
end type
global vuo_dw_impresoras vuo_dw_impresoras

type variables
private datawindow io_dw
private boolean ib_gb_visible=true
end variables

forward prototypes
public subroutine of_register (datawindow ao_dw, boolean ab_gb_visible)
public subroutine of_register (datawindow ao_dw)
public function string of_getprinter ()
end prototypes

public subroutine of_register (datawindow ao_dw, boolean ab_gb_visible);ib_gb_visible = ab_gb_visible
of_register(ao_dw)
end subroutine

public subroutine of_register (datawindow ao_dw);io_dw=ao_dw
st_impresora.text = of_getprinter()
//gb_impresoras.visible= ib_gb_visible 
end subroutine

public function string of_getprinter ();String ls_printername

IF IsValid(io_dw) Then
	ls_printername=io_dw.describe ( "DataWindow.Printer" )
END IF

return ls_printername
end function

on vuo_dw_impresoras.create
this.st_impresora=create st_impresora
this.cb_impresora=create cb_impresora
this.gb_1=create gb_1
this.Control[]={this.st_impresora,&
this.cb_impresora,&
this.gb_1}
end on

on vuo_dw_impresoras.destroy
destroy(this.st_impresora)
destroy(this.cb_impresora)
destroy(this.gb_1)
end on

type st_impresora from statictext within vuo_dw_impresoras
integer x = 347
integer y = 56
integer width = 736
integer height = 84
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = styleraised!
end type

type cb_impresora from commandbutton within vuo_dw_impresoras
integer x = 23
integer y = 56
integer width = 320
integer height = 84
integer taborder = 10
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "Hyperlink!"
string text = "Impresora..."
end type

event clicked;PrintSetup()
st_impresora.text = of_getprinter()
end event

type gb_1 from groupbox within vuo_dw_impresoras
integer width = 1106
integer height = 172
integer taborder = 10
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

