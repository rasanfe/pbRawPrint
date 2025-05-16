//objectcomments Ventana antes de imprimir
forward
global type w_print_dialog from window
end type
type st_print from statictext within w_print_dialog
end type
type ddlb_salida from dropdownlistbox within w_print_dialog
end type
type cb_cancelar from commandbutton within w_print_dialog
end type
type cb_aceptar from commandbutton within w_print_dialog
end type
type cb_preliminar from commandbutton within w_print_dialog
end type
type em_paginas from editmask within w_print_dialog
end type
type st_8 from statictext within w_print_dialog
end type
type ddlb_printers from dropdownlistbox within w_print_dialog
end type
type p_2 from picture within w_print_dialog
end type
type p_1 from picture within w_print_dialog
end type
type st_1 from statictext within w_print_dialog
end type
type sle_paginas from singlelineedit within w_print_dialog
end type
type rb_todo from radiobutton within w_print_dialog
end type
type em_copias from editmask within w_print_dialog
end type
type st_copies from statictext within w_print_dialog
end type
type gb_impresora from groupbox within w_print_dialog
end type
type gb_copias from groupbox within w_print_dialog
end type
type gb_salida from groupbox within w_print_dialog
end type
type dw_1 from datawindow within w_print_dialog
end type
type ddlb_print from dropdownlistbox within w_print_dialog
end type
type cb_propiedades from commandbutton within w_print_dialog
end type
type gb_intervalo from groupbox within w_print_dialog
end type
type rb_paginas from radiobutton within w_print_dialog
end type
end forward

global type w_print_dialog from window
integer x = 256
integer y = 160
integer width = 2359
integer height = 1160
boolean titlebar = true
string title = "Imprimir"
windowtype windowtype = response!
long backcolor = 80269524
st_print st_print
ddlb_salida ddlb_salida
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
cb_preliminar cb_preliminar
em_paginas em_paginas
st_8 st_8
ddlb_printers ddlb_printers
p_2 p_2
p_1 p_1
st_1 st_1
sle_paginas sle_paginas
rb_todo rb_todo
em_copias em_copias
st_copies st_copies
gb_impresora gb_impresora
gb_copias gb_copias
gb_salida gb_salida
dw_1 dw_1
ddlb_print ddlb_print
cb_propiedades cb_propiedades
gb_intervalo gb_intervalo
rb_paginas rb_paginas
end type
global w_print_dialog w_print_dialog

type prototypes


end prototypes

type variables
String is_ruta, is_OldPrinter
Constant Integer UseSplitMerge = 1
Constant Integer UseGhostScript = 2
Constant Integer UsePdfDocument = 3
String is_ruta_montaje
end variables

forward prototypes
private subroutine wf_impresoras (dropdownlistbox arg_ddlb)
private subroutine wf_saveas ()
private function string wf_join_pdfs (string as_rutas[])
public subroutine wf_imprimir (string as_ruta)
private function string wf_montar_copias (string as_ruta)
private function string wf_montar_intervalos (string as_ruta)
public function any wf_obtener_parimpar (string as_parimpar, string as_paginas[])
private function any wf_obtener_intervalo (string as_intervalos)
private function boolean wf_abrir_archivo (string as_ruta)
end prototypes

private subroutine wf_impresoras (dropdownlistbox arg_ddlb);integer li_i, li_j
string ls_printers, ls_cad
n_cst_string ln_str

ln_str = create n_cst_string

arg_ddlb.Reset()

ls_printers = Trim(PrintGetPrinters())
li_j = ln_str.of_num_entries(ls_printers,'~n')

for li_i = 1 to li_j
	ls_cad = ln_str.of_entry(ls_printers,li_i,'~n')
	ls_cad = ln_str.of_entry(ls_cad,1,'~t')
	arg_ddlb.additem(ls_cad)
next
arg_ddlb.text = arg_ddlb.text(1)

destroy ln_str
end subroutine

private subroutine wf_saveas ();string ls_current, ls_dir
string ls_path 
string ls_file
boolean lb_exist 
Integer li_result

ls_dir= gs_dir
CreateDirectory (ls_dir) 
ls_current=GetCurrentDirectory ( )
li_result=GetFileSaveName("Guardar",  ls_path,ls_file,"PDF", + "PDF Files (*.PDF), *.pdf" ,ls_dir, 18)
ChangeDirectory ( ls_current )

if  li_result<>1 then return

nvo_fileservice ln_file

ln_file =  CREATE nvo_fileservice

lb_exist = FileExists(ls_path)

IF lb_exist THEN
	if messagebox("Remplazar", "¿ Desea sobreescirbir el archivo " +ls_file+ " ?", question!, yesno!, 1)=2 then return
	if not FileDelete(ls_path) then
		ls_file=""
		li_result=-1
	end if	
end if	

li_result = FileCopy(is_ruta, ls_path, true)


if li_result = 1 then
	if messagebox("Correcto","La información se ha grabado correctamente en :"+char(13)+char(13)+ls_path+"."+char(13)+char(13)+" ¿ Desea abrir el fichero ?", question!, yesno!, 1 )=1 then
		wf_abrir_archivo(ls_path) 
	end if	
else
	messagebox("ERROR","Al grabar el archivo.", stopsign!)
end if	

destroy ln_file
Close(this)
return
	

end subroutine

private function string wf_join_pdfs (string as_rutas[]);String ls_fileName, ls_filePath
Integer li_UpperBound
n_cst_pdfdocument ln_pdfsv
boolean lb_Result
nvo_fileservice ln_file

				
//Si no hay almenos 2 facturas salgo, no hay nada que unir
li_UpperBound=UpperBound(as_rutas[]) 
if li_UpperBound < 2 then
	return as_rutas[1]
end if	

ln_pdfsv = CREATE n_cst_pdfdocument
ln_file =  CREATE nvo_fileservice

ls_fileName =ln_File.of_GetFileName(as_rutas[1])
ls_filePath =  ln_File.of_GetDirectoryName(as_rutas[1])+"\"+ ln_File.of_GetFileNameWithoutExtension(ls_fileName)+"_join.pdf"

lb_Result =  ln_pdfsv.of_merge(as_rutas[], ls_filePath)

if lb_result=false then
	messagebox("Atención", ln_pdfsv.is_errorText, exclamation!)
end if

Destroy ln_pdfsv
destroy ln_file	
Return ls_filePath

end function

public subroutine wf_imprimir (string as_ruta);//Funcion para imprimir archivo directo a la impresora.
nvo_rawprint lo_rawprint
String ls_printerName

ls_printerName = ddlb_printers.text

lo_rawprint =  CREATE nvo_rawprint
		
lo_rawprint.of_printRawFile(ls_printerName, as_ruta, FALSE)

destroy lo_rawprint




end subroutine

private function string wf_montar_copias (string as_ruta);Integer li_Copia, li_TotalCopias, li_archivo
String ls_archivos[]
String ls_ruta, ls_fileName, ls_filePath
nvo_fileservice ln_file

ln_file =  create nvo_fileservice

li_TotalCopias = integer(em_copias.text)

IF li_TotalCopias > 1 THEN
	FOR li_Copia = 1 TO li_TotalCopias
		ls_fileName =ln_File.of_GetFileName(as_ruta)
		ls_filePath =  ln_File.of_GetDirectoryName(as_ruta)+"\"+ ln_File.of_GetFileNameWithoutExtension(ls_fileName)+"_copia_"+string(li_copia)+".pdf"
		FileCopy(as_ruta, ls_filePath, true)
		li_archivo ++
		ls_archivos[li_archivo] =ls_filePath 
	NEXT	
	ls_ruta = wf_join_pdfs( ls_archivos[])
ELSE
	ls_ruta = as_ruta
END IF


destroy ln_file	
RETURN ls_ruta


end function

private function string wf_montar_intervalos (string as_ruta);Integer li_paginas, li_PAG
String ls_file, ls_printerName, ls_dir
nvo_fileservice ln_file
n_cst_pdfdocument ln_pdfsv 
String ls_paginasImp[], ls_paginasInt[]
String ls_archivos[]
string ls_ruta
Integer li_Archivo
String ls_ParInpar, ls_intervalo
n_cst_string ln_str

ln_str = create n_cst_string
ln_file = create nvo_fileservice

//Obtener Paginas a Imprimir
IF rb_paginas.Checked = TRUE THEN
	ls_intervalo = trim(sle_paginas.text)
ELSE
	ls_intervalo = "1-"+trim(em_paginas.text)
END IF
ls_paginasInt[] = wf_obtener_intervalo(ls_intervalo)

//Filtrar Pares Impres
ls_ParInpar = left( ddlb_print.text, 1)
ls_paginasImp[] = wf_obtener_parimpar(ls_ParInpar, ls_paginasInt[])

IF isnull(ls_paginasImp[]) THEN
	messagebox("Atención", "¡ Selecciones las páginas a Imprimir !", exclamation!)
	sle_paginas.SetFocus()
	RETURN ""
END IF	

ln_pdfsv = CREATE n_cst_pdfdocument

ls_printerName = ddlb_printers.text
ls_dir = ln_File.of_GetDirectoryName(as_ruta) 
CreateDirectory (ls_dir)

li_paginas = ln_pdfsv.of_split(as_ruta, ls_dir)

IF li_paginas = -1 THEN
	messagebox("Atención", "¡ Error Dividiendo el Documento !"+char(13)+ln_pdfsv.is_errorText, exclamation!)
	RETURN ""   
END IF	

FOR li_pag = 1 TO li_paginas
	ls_file =ln_File.of_GetFileName(as_ruta)
	ls_file =  ls_dir+"\"+ ln_File.of_GetFileNameWithoutExtension(ls_file)+string(li_pag)+".pdf"
	
	IF ln_str.of_iin(string(li_pag), ls_paginasImp[]) = FALSE THEN
		FileDelete(ls_file)
	ELSE	
		li_archivo++
		ls_Archivos[li_archivo] = ls_file
	END IF
NEXT

IF upperbound(ls_Archivos[]) = 0 THEN
	messagebox("Atención", "¡ No hay páginas que cumplan el Intervalo !", exclamation!)
	RETURN ""
END IF	

ls_ruta = wf_join_pdfs(ls_Archivos[])

destroy ln_file
destroy ln_pdfsv
destroy ln_str

RETURN ls_ruta

end function

public function any wf_obtener_parimpar (string as_parimpar, string as_paginas[]);String ls_paginasPares[], ls_paginasImpares[], ls_paginas[]
String ls_pagina
Integer li_par, li_imp, li_TotalPaginas, li_pagina

li_TotalPaginas = UpperBound(as_paginas[])

FOR li_pagina = 1 to li_TotalPaginas
	ls_pagina = as_paginas[li_pagina]
	
	IF Mod(integer(ls_pagina) , 2) <> 0 THEN
		li_imp ++ 
		ls_paginasImpares[li_imp] =ls_pagina 
	ELSE
		li_PAR ++ 
		ls_paginasPares[li_par] =ls_pagina 
	END IF	
NEXT	
	
//Dejamos paginas Pares
CHOOSE CASE as_parimpar
	CASE "P" 
		ls_paginas[] = ls_paginasPares[]
	CASE "I"
		ls_paginas[] = ls_paginasImpares
	CASE ELSE
		ls_paginas[] = as_paginas[]
END CHOOSE	
	
RETURN ls_paginas[]	

end function

private function any wf_obtener_intervalo (string as_intervalos);String ls_Matriz[], ls_Intervalos[], ls_Limites[]
integer li_TotalIntervalos
Integer li_Intervalo, li_PagRango, li_Pos
String ls_Intervalo
integer li_LimiteInferior, li_LimiteSuperior
integer li_PaginaIndividual
integer li_pagina
 n_cst_string ln_str
 
 ln_str = create n_cst_string
 
// Dividir el string en intervalos individuales
ls_Intervalos[] = ln_str.of_Split(as_intervalos, ",")

// Obtener el número total de intervalos
li_TotalIntervalos = UpperBound(ls_Intervalos[])

// Recorrer cada intervalo y agregar las páginas correspondientes a la matriz
FOR li_Intervalo = 1 TO li_TotalIntervalos
   
    ls_Intervalo = Trim(ls_Intervalos[li_Intervalo])

    // Verificar si el intervalo tiene un guion (-) para indicar un rango
    li_Pos = Pos(ls_Intervalo, "-")
    IF li_Pos  > 0 THEN
        // Dividir el intervalo en límites inferior y superior del rango
      
        ls_Limites = ln_str.of_Split(ls_Intervalo, "-")

        // Convertir los límites a números enteros
        li_LimiteInferior = Integer(ls_Limites[1])
        li_LimiteSuperior = Integer(ls_Limites[2])

        // Agregar las páginas del rango a la matriz
        FOR li_PagRango = li_LimiteInferior TO li_LimiteSuperior
			li_pagina ++
            ls_Matriz[li_pagina] = String(li_PagRango)
        NEXT
    ELSE
		li_pagina ++
        // No hay guion, por lo tanto, solo hay una página individual
        ls_Matriz[li_pagina] = ls_Intervalo
    END IF
NEXT

destroy ln_str

// Devolver la matriz con las páginas a imprimir
RETURN ls_Matriz[]
end function

private function boolean wf_abrir_archivo (string as_ruta);IF isValid(w_main) THEN
	w_main.sle_archivo.text = as_ruta
	w_main.wb_1.of_loadfile(as_ruta)
	RETURN TRUE
ELSE	
	RETURN FALSE
END IF	


		
end function

event open;//HAgo un retrieve en un Datawindow para poder Capturar las Impresoras
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()

wf_impresoras(ddlb_printers)

is_OldPrinter = dw_1.describe ( "DataWindow.Printer" )
ddlb_printers.SelectItem (ddlb_printers.FindItem(is_OldPrinter, 0))


is_ruta =  Message.StringParm

	
ddlb_print.SelectItem(1)
ddlb_salida.SelectItem(1)


n_cst_pdfdocument ln_pdfDoc

ln_pdfDoc = Create n_cst_pdfdocument

em_paginas.text = string(ln_pdfDoc.of_PageCount(is_ruta))

Destroy ln_pdfDoc

end event

on w_print_dialog.create
this.st_print=create st_print
this.ddlb_salida=create ddlb_salida
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.cb_preliminar=create cb_preliminar
this.em_paginas=create em_paginas
this.st_8=create st_8
this.ddlb_printers=create ddlb_printers
this.p_2=create p_2
this.p_1=create p_1
this.st_1=create st_1
this.sle_paginas=create sle_paginas
this.rb_todo=create rb_todo
this.em_copias=create em_copias
this.st_copies=create st_copies
this.gb_impresora=create gb_impresora
this.gb_copias=create gb_copias
this.gb_salida=create gb_salida
this.dw_1=create dw_1
this.ddlb_print=create ddlb_print
this.cb_propiedades=create cb_propiedades
this.gb_intervalo=create gb_intervalo
this.rb_paginas=create rb_paginas
this.Control[]={this.st_print,&
this.ddlb_salida,&
this.cb_cancelar,&
this.cb_aceptar,&
this.cb_preliminar,&
this.em_paginas,&
this.st_8,&
this.ddlb_printers,&
this.p_2,&
this.p_1,&
this.st_1,&
this.sle_paginas,&
this.rb_todo,&
this.em_copias,&
this.st_copies,&
this.gb_impresora,&
this.gb_copias,&
this.gb_salida,&
this.dw_1,&
this.ddlb_print,&
this.cb_propiedades,&
this.gb_intervalo,&
this.rb_paginas}
end on

on w_print_dialog.destroy
destroy(this.st_print)
destroy(this.ddlb_salida)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.cb_preliminar)
destroy(this.em_paginas)
destroy(this.st_8)
destroy(this.ddlb_printers)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.sle_paginas)
destroy(this.rb_todo)
destroy(this.em_copias)
destroy(this.st_copies)
destroy(this.gb_impresora)
destroy(this.gb_copias)
destroy(this.gb_salida)
destroy(this.dw_1)
destroy(this.ddlb_print)
destroy(this.cb_propiedades)
destroy(this.gb_intervalo)
destroy(this.rb_paginas)
end on

event closequery;PrintSetPrinter( is_OldPrinter)
FileDelete(is_ruta_montaje)

end event

type st_print from statictext within w_print_dialog
integer x = 1477
integer y = 72
integer width = 233
integer height = 68
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean enabled = false
string text = "&Imprimir:"
alignment alignment = right!
end type

type ddlb_salida from dropdownlistbox within w_print_dialog
integer x = 69
integer y = 816
integer width = 1001
integer height = 480
integer taborder = 80
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean sorted = false
string item[] = {"Impresora","Fichero PDF"}
end type

event selectionchanged;call super::selectionchanged;Boolean lb_enabled=false

if index = 1 then
	lb_enabled = true
end if	


ddlb_printers.enabled=lb_enabled
ddlb_print.selectitem(1)
ddlb_print.enabled=lb_enabled
sle_paginas.text=""
sle_paginas.enabled=lb_enabled
rb_todo.checked=true
rb_paginas.checked=false
rb_todo.enabled=lb_enabled
rb_paginas.enabled=lb_enabled
em_copias.text="1"
em_copias.enabled=lb_enabled
cb_propiedades.enabled=lb_enabled
gb_impresora.enabled=lb_enabled
cb_preliminar.enabled=lb_enabled
end event

type cb_cancelar from commandbutton within w_print_dialog
integer x = 1888
integer y = 960
integer width = 320
integer height = 84
integer taborder = 70
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;Close(parent)
return

end event

type cb_aceptar from commandbutton within w_print_dialog
integer x = 1568
integer y = 960
integer width = 320
integer height = 84
integer taborder = 100
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;String ls_ruta
//Control Previo
IF NOT FileExists(is_ruta) THEN
	messagebox("Atención", "¡ No existe el Fichero "+is_ruta+" !", exclamation!)
	Close(parent)
	Return
END IF


// Imprimir en Fichero
IF ddlb_salida.text="Fichero PDF" THEN 
	wf_SaveAs()
	Return
END IF

//Salida por la Impresora
IF rb_paginas.Checked=TRUE OR left(ddlb_print.text, 1) <> "T" THEN
	ls_ruta = wf_montar_intervalos(is_ruta)
ELSE
	ls_ruta = is_ruta
END IF	

ls_ruta = wf_montar_copias(ls_ruta)

IF ls_ruta = "" THEN
	Return
ELSE
	is_ruta_montaje = ls_ruta
	wf_imprimir(ls_ruta)
END IF

Close(Parent)


end event

type cb_preliminar from commandbutton within w_print_dialog
integer x = 1243
integer y = 960
integer width = 320
integer height = 84
integer taborder = 30
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Preliminar..."
end type

event clicked;String ls_ruta
//Control Previo
IF NOT FileExists(is_ruta) THEN
	messagebox("Atención", "¡ No existe el Fichero "+is_ruta+" !", exclamation!)
	Close(parent)
	Return
END IF

//Salida por la Impresora
IF rb_paginas.Checked=TRUE OR left(ddlb_print.text, 1) <> "T" THEN
	ls_ruta = wf_montar_intervalos(is_ruta)
ELSE
	ls_ruta = is_ruta
END IF	

ls_ruta = wf_montar_copias(ls_ruta)

IF ls_ruta = "" THEN
	Return
ELSE
	is_ruta_montaje = ls_ruta
	OpenWithParm(w_print_preview, ls_ruta) 
END IF

Close(Parent)




end event

type em_paginas from editmask within w_print_dialog
integer x = 2016
integer y = 524
integer width = 137
integer height = 88
integer taborder = 70
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "1"
boolean border = false
alignment alignment = center!
string mask = "#####"
double increment = 1
string minmax = "1~~15"
end type

type st_8 from statictext within w_print_dialog
integer x = 1701
integer y = 524
integer width = 315
integer height = 68
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Nº Páginas:"
end type

type ddlb_printers from dropdownlistbox within w_print_dialog
integer x = 69
integer y = 124
integer width = 1083
integer height = 624
integer taborder = 100
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean sorted = false
end type

event selectionchanged;String ls_printer

if ddlb_printers.totalitems() > 0 then
	 ls_printer = ddlb_printers.text
	PrintSetPrinter ( ls_printer)
end if	
end event

type p_2 from picture within w_print_dialog
integer x = 1394
integer y = 560
integer width = 160
integer height = 208
boolean originalsize = true
string picturename = "inter.gif"
boolean focusrectangle = false
end type

type p_1 from picture within w_print_dialog
integer x = 1211
integer y = 560
integer width = 160
integer height = 208
boolean originalsize = true
string picturename = "inter.gif"
boolean focusrectangle = false
end type

type st_1 from statictext within w_print_dialog
integer x = 73
integer y = 584
integer width = 992
integer height = 116
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean enabled = false
string text = "Escriba números de páginas e intervalos separados por comas. Ejemplo: 1,3,5-12,14"
end type

type sle_paginas from singlelineedit within w_print_dialog
event pbm_enchange pbm_enchange
integer x = 357
integer y = 460
integer width = 672
integer height = 80
integer taborder = 50
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
end type

event pbm_enchange;if this.text = "" then
   parent.rb_todo.checked   = true
   parent.rb_paginas.checked = false
else
   parent.rb_todo.checked   = false
   parent.rb_paginas.checked = true
end if
end event

type rb_todo from radiobutton within w_print_dialog
integer x = 82
integer y = 372
integer width = 343
integer height = 64
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "&Todo"
boolean checked = true
end type

type em_copias from editmask within w_print_dialog
integer x = 1609
integer y = 364
integer width = 617
integer height = 80
integer taborder = 80
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
alignment alignment = right!
integer accelerator = 99
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

type st_copies from statictext within w_print_dialog
integer x = 1184
integer y = 380
integer width = 416
integer height = 52
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean enabled = false
string text = "Número de &copias:"
end type

type gb_impresora from groupbox within w_print_dialog
integer x = 37
integer y = 32
integer width = 2272
integer height = 228
integer taborder = 10
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
string text = "Impresora"
end type

type gb_copias from groupbox within w_print_dialog
integer x = 1129
integer y = 288
integer width = 1175
integer height = 648
integer taborder = 90
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
string text = "Copias"
end type

type gb_salida from groupbox within w_print_dialog
integer x = 37
integer y = 752
integer width = 1065
integer height = 188
integer taborder = 30
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Salida"
end type

type dw_1 from datawindow within w_print_dialog
integer x = 1422
integer y = 640
integer width = 82
integer height = 56
integer taborder = 100
string dataobject = "dw_1"
end type

type ddlb_print from dropdownlistbox within w_print_dialog
integer x = 1522
integer y = 128
integer width = 722
integer height = 288
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean sorted = false
string item[] = {"Todas la Páginas del Rango","Impares","Pares"}
end type

type cb_propiedades from commandbutton within w_print_dialog
integer x = 1161
integer y = 120
integer width = 343
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Propiedades"
end type

event clicked;
PrintSetupPrinter ( )
end event

type gb_intervalo from groupbox within w_print_dialog
integer x = 37
integer y = 288
integer width = 1065
integer height = 452
integer taborder = 80
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Intervalo de páginas"
end type

type rb_paginas from radiobutton within w_print_dialog
integer x = 82
integer y = 468
integer width = 238
integer height = 64
boolean bringtotop = true
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "Pá&ginas:"
end type

