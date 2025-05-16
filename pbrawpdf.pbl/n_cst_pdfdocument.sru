forward
global type n_cst_pdfdocument from nonvisualobject
end type
end forward

global type n_cst_pdfdocument from nonvisualobject
end type
global n_cst_pdfdocument n_cst_pdfdocument

type variables
String is_ErrorText

end variables

forward prototypes
private subroutine of_setlasterror (long al_error)
public function boolean of_merge (string as_filenames[], string as_targetpdf)
public function long of_split (string as_inputfile, string as_outputpath)
public function long of_pagecount (string as_inputfile)
end prototypes

private subroutine of_setlasterror (long al_error);Choose Case al_error
	Case 1	
		is_ErrorText = ""
	Case -1
		is_ErrorText = "Error común."
	Case -2
		is_ErrorText = "Objeto no válido."
	Case -3
		is_ErrorText = "Objeto de documento no válido."
	Case -4
		is_ErrorText = "Objeto de página no válido."
	Case -5
		is_ErrorText = "Objeto de texto no válido."
	Case -6
		is_ErrorText = "Objeto de texto de varias líneas no válido."
	Case -7
		is_ErrorText = "Objeto de texto enriquecido no válido."
	Case -8
		is_ErrorText = "Objeto de imagen no válido."
	Case -9
		is_ErrorText = "Objeto de fuente no válido."
	Case -10
		is_ErrorText = "Objeto de capa no válido."
	Case -11
		is_ErrorText = "Contenedor de capa no válido."
	Case -12
		is_ErrorText = "Objeto de ensamblaje de capa no válido."
	Case -13
		is_ErrorText = "Índice no válido."
	Case -14
		is_ErrorText = "Argumento no válido."
	Case -15
		is_ErrorText = "Objeto no válido para importar."
	Case -16
		is_ErrorText = "Índice de inicio no válido."
	Case -17
		is_ErrorText = "Ámbito de índice no válido."
	Case -18
		is_ErrorText = "Nombre de objeto no válido."
	Case -19
		is_ErrorText = "Nombre de archivo no válido."
	Case -20
		is_ErrorText = "Nombre de fuente no válido."
	Case -21
		is_ErrorText = "Objeto visible no válido."
	Case -22
		is_ErrorText = "Contraseña no válida; la contraseña principal y la contraseña de usuario no pueden ser nulas ni iguales."
	Case -23
		is_ErrorText = "Objeto de propiedad de documento no válido."
	Case -24
		is_ErrorText = "Manejador no válido."
	Case -25
		is_ErrorText = "Operación anormal."
	Case -26
		is_ErrorText = "Error al abrir el documento PDF."
	Case -27
		is_ErrorText = "Error al crear el documento PDF."
	Case -28
		is_ErrorText = "Error al crear el texto de varias líneas."
	Case -29
		is_ErrorText = "Error al cargar la fuente."
	Case -30
		is_ErrorText = "Error al cargar la imagen."
	Case -31
		is_ErrorText = "Error al localizar el objeto en la página."
	Case -32
		is_ErrorText = "El objeto no existe."
	Case -33
		is_ErrorText = "El objeto ya tiene un propietario."
	Case -34
		is_ErrorText = "El objeto de solo lectura no se puede modificar."
	Case -35
		is_ErrorText = "Error al realizar la serialización XML."
	Case -36
		is_ErrorText = "Objeto no aplicable al formato de documento actual."
	Case -37
		is_ErrorText = "Ancho no especificado."
	Case -38
		is_ErrorText = "Error al inicializar el generador ficticio."
	Case -39
		is_ErrorText = "Operación no compatible."
	Case -40
		is_ErrorText = "Nombre de carpeta no válido."
	Case -41
		is_ErrorText = "Error al instanciar el objeto."
	Case -42
		is_ErrorText = "Error al escribir en el archivo."
	Case -43
		is_ErrorText = "Error al cargar el archivo."
	Case -44 
		is_ErrorText = "Ruta de archivo no válida."
	Case -45 
		is_ErrorText = "Protocolo no reconocido."
	Case -46
		is_ErrorText = "Marca de agua incompatible con el archivo adjunto."
	Case -48 
		is_ErrorText = "Contraseña maestra incorrecta o faltante."
	Case -49
		is_ErrorText = "El objeto de formulario se ha importado varias veces."	
	Case else
		is_ErrorText = "Código de error no reconocido."
		
End Choose 

	
end subroutine

public function boolean of_merge (string as_filenames[], string as_targetpdf);Long ll_Files, ll_File
String ls_file
Boolean lb_result=FALSE
Long ll_rtn
PDFDocument ln_PDFDoc

ln_PDFDoc =  CREATE PDFDocument

ll_Files = UpperBound(as_filenames[])

FOR ll_File =  1 TO ll_Files
	ls_file=as_filenames[ll_File]
	
	ll_rtn = ln_PDFDoc.importpdf(ls_file)
	
	IF ll_rtn <> 1 THEN EXIT
NEXT	

IF ll_rtn = 1 THEN
	ll_rtn =ln_PDFDoc.Save(as_targetpdf)
END IF	

IF ll_rtn = 1 THEN  lb_result = TRUE

of_SetLastError(ll_rtn)

Destroy ln_PDFDoc
Return lb_result

end function

public function long of_split (string as_inputfile, string as_outputpath);String ls_filename, ls_outputfile
Long ll_rtn
long ll_pag, ll_pageCount
nvo_fileservice ln_file
PDFDocument ln_PDFDoc

ln_file = CREATE nvo_FileService

ls_filename =  ln_file.of_getfilename(as_inputfile)
ls_filename = ln_file.of_getfilenamewithoutextension(ls_filename)

ll_pag = 0

//Obtenemos el nº de Páginas.
ll_pageCount = of_PageCount(as_inputfile)

IF ll_pageCount = -1 THEN
	return ll_pageCount
END IF	

FOR ll_pag = 1 TO ll_pageCount
	ln_PDFDoc =  CREATE PDFDocument
	ll_rtn = ln_PDFDoc.importpdf( as_inputFile, ll_pag, ll_pag, 1)
	IF ll_rtn = 1 THEN
		ls_outputFile=as_outputpath+ "\"+ls_filename+string(ll_pag)+".pdf"
		ll_rtn = ln_PDFDoc.Save(ls_outputFile)
		Destroy ln_PDFDoc
	ELSE
		EXIT
	END IF
NEXT	

of_SetLastError(ll_rtn)

Return ll_pageCount

end function

public function long of_pagecount (string as_inputfile);PDFDocument ln_PDFDoc
long ll_pageCount
Integer ll_rtn

ln_PDFDoc =  CREATE PDFDocument

ll_rtn = ln_pdfDoc.importpdf(as_inputfile)

IF ll_rtn = 1 THEN
	ll_pageCount = ln_PDFDoc.GetPageCount()
ELSE
	of_setlasterror(ll_rtn)
	ll_pageCount = -1
END IF	

Destroy ln_PDFDoc

RETURN ll_pageCount
end function

on n_cst_pdfdocument.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pdfdocument.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

