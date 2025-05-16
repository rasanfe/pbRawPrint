forward
global type w_print_preview from window
end type
type wb_1 from vs_web_browser within w_print_preview
end type
end forward

shared variables

end variables

global type w_print_preview from window
integer y = 172
integer width = 4585
integer height = 3068
boolean titlebar = true
string title = "Vista Preliminar Impresión"
boolean controlmenu = true
windowtype windowtype = response!
boolean center = true
windowanimationstyle closeanimation = fadeanimation!
wb_1 wb_1
end type
global w_print_preview w_print_preview

type variables

end variables

on w_print_preview.create
this.wb_1=create wb_1
this.Control[]={this.wb_1}
end on

on w_print_preview.destroy
destroy(this.wb_1)
end on

event open;String ls_ruta

ls_ruta  =  Message.StringParm

if wb_1.Navigate(ls_ruta) <> 1 then
	messagebox("Atención","¡ Error al cargar el PDF para Imprimir !", exclamation!)
	close(this)
end if

		



end event

type wb_1 from vs_web_browser within w_print_preview
integer x = 18
integer y = 20
integer width = 4549
integer height = 2952
end type

