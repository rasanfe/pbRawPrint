forward
global type nvo_fileservice from oleobject
end type
end forward

global type nvo_fileservice from oleobject
end type
global nvo_fileservice nvo_fileservice

type variables
PRIVATEWRITE Long il_ErrorType   
PRIVATEWRITE String is_ErrorText 
end variables

forward prototypes
public function boolean of_filerename (string as_sourcefile, string as_targetfile)
public function string of_getfilename (string as_sourcefile)
public function string of_getfilenamewithoutextension (string as_sourcefile)
public function string of_getdirectoryname (string as_sourcefile)
public function string of_getextension (string as_sourcefile)
end prototypes

public function boolean of_filerename (string as_sourcefile, string as_targetfile);//////////////////////////////////////////////////////////////////////////////
//	Golbal Function: of_FileRename
//	Arguments:		as_SourceFile			The file to rename.
//						as_TargetFile			The new file name.
//	Returns:			Boolean
//						true if successful,
//						false if an error occurrs.
//	Description:	Rename or move a file or directory.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						12.7.R2.1756   Initial version
//////////////////////////////////////////////////////////////////////////////

Integer li_Result
Boolean lb_Result=False

IF trim(as_sourcefile) = trim(as_targetfile) THEN Return TRUE

// 1 = Success;  -1 = Error opening sourcefile;  -2 = Error writing targetfile
li_Result = FileCopy(as_sourcefile, as_targetfile, true)

if li_Result = 1 then 
	lb_Result = FileDelete(as_sourcefile)
else 
	lb_result = false
end if

if lb_Result=False then
	CHOOSE CASE li_result
		CASE 1	
			is_ErrorText = "Error Borando  Archivo de Origen "+as_sourcefile
		CASE -1
			is_ErrorText =  "Error Abriendo Archivo de Origen "+as_sourcefile
		CASE -2
			is_ErrorText = "Error Escribiendo Archivo de Destino "+as_targetfile
	END CHOOSE		
	il_ErrorType =  li_result - 1
end if	

RETURN lb_Result
	
end function

public function string of_getfilename (string as_sourcefile);// -----------------------------------------------------------------------------
// SCRIPT:    of_GetFileName(as_sourcefile)
//
// PURPOSE:    Retorna el nombre del archivo sin  la ruta.
//			
//	EJEMPLO si le pasas c:\hola\otro\mi.pdf  --> mi.pdf
//
// ARGUMENTS:     as_sourcefile    --> ruta completa
//						
//
// RETURN:     string ls_file--> Nombre de archivo limpio
//
// DATE          PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------      --------		-----------------------------------------------------
// 25/01/2017	Ramón		Initial coding
// -----------------------------------------------------------------------------
integer li_posBarra, li_posPunto, li_largo
string ls_file, ls_ruta

ls_ruta=trim(as_sourcefile)

li_posBarra=lastpos(ls_ruta, "\") 
li_posPunto=pos(ls_ruta, ".", li_posBarra)
li_largo=len(ls_ruta)

//Si no hay punto puede que el ultimo directorio termine en "\" o no.
if li_posPunto = 0 then
	 il_ErrorType = -1
	is_ErrorText="No se ha pasado ningun nombre de archivo junto con la ruta"
	ls_file=""
else
	ls_file = mid(ls_ruta, li_posBarra +1 , len(ls_ruta) - li_posBarra)
end if	

return ls_file
end function

public function string of_getfilenamewithoutextension (string as_sourcefile);// -----------------------------------------------------------------------------
// SCRIPT:    of_GetFileNameWithoutExtension(as_sourcefile)
//
// PURPOSE:    Retorna el nombre del archivo sin  la extensión.
//			
//	EJEMPLO si le pasas ejemplo.pdf  --> ejemplo
//
// ARGUMENTS:     as_sourcefile    --> Archivo sin ruta
//						
//
// RETURN:     string ls_file--> Nombre de archivo limpio
//
// DATE          PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------      --------		-----------------------------------------------------
// 25/10/2017	Ramón		Initial coding
// -----------------------------------------------------------------------------
integer li_posPunto
string ls_file

ls_file=trim(as_sourcefile)

li_posPunto=lastpos(ls_file, ".")

ls_file = mid(ls_file, 0 ,  li_pospunto - 1)


return ls_file
end function

public function string of_getdirectoryname (string as_sourcefile);// -----------------------------------------------------------------------------
// SCRIPT:    of_GetDirectoryName(as_sourcefile)
//
// PURPOSE:    Retorna el nombre de directorio sin el nombre de archivo.
//					y sin barra final. 
//	EJEMPLO si le pasas c:\hola\otro\mi.pdf  --> c:\hola\otro
//							   c:\hola\otro            --> c:\hola\otro
//							   c:\hola\otro\           --> c:\hola\otro
//
// ARGUMENTS:     as_sourcefile    --> ruta completa
//						
//
// RETURN:     string ls_ruta--> ruta limpoa sin nombre de archivo
//										 ni barra final.
//
// DATE          PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------      --------		-----------------------------------------------------
// 22/02/2016	Ramón		Initial coding
// 27/10/2016  Ramón		Reago función.
// -----------------------------------------------------------------------------
integer li_posBarra, li_posPunto, li_largo
string ls_ruta

ls_ruta=trim(as_sourcefile)

li_posBarra=lastpos(ls_ruta, "\") 
li_posPunto=pos(ls_ruta, ".", li_posBarra)
li_largo=len(ls_ruta)

//Si no hay punto puede que el ultimo directorio termine en "\" o no.
if li_posPunto = 0 then
	if li_posBarra=li_largo  then
		ls_ruta=left(ls_ruta, li_posBarra - 1)
	end if	
else
	ls_ruta=mid(ls_ruta, 0, li_posBarra -1 )
end if	

return ls_ruta

end function

public function string of_getextension (string as_sourcefile);// -----------------------------------------------------------------------------
// SCRIPT:    of_GetExtension(as_sourcefile)
//
// PURPOSE:    Retorna  la extensión de un archivo.
//			
//	EJEMPLO si le pasas ejemplo.pdf  --> .pdf
//
// ARGUMENTS:     as_sourcefile    --> Archivo sin ruta
//						
//
// RETURN:     string ls_file--> Nombre de archivo limpio
//
// DATE          PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------      --------		-----------------------------------------------------
// 25/10/2017	Ramón		Initial coding
// -----------------------------------------------------------------------------
integer li_posPunto
string ls_file

ls_file=trim(as_sourcefile)

li_posPunto=lastpos(ls_file, ".")

ls_file = mid(ls_file, li_pospunto,  4)


return ls_file
end function

on nvo_fileservice.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_fileservice.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

