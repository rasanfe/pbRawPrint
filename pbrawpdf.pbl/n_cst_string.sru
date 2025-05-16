forward
global type n_cst_string from nonvisualobject
end type
end forward

global type n_cst_string from nonvisualobject
end type
global n_cst_string n_cst_string

forward prototypes
public function integer of_num_entries (string as_cadena, string as_separador)
public function any of_split (string as_source, string as_separator)
public function string of_entry (string as_cadena, integer ai_pos, string as_separador)
public function boolean of_iin (readonly any aa_value, readonly any aa_check[])
end prototypes

public function integer of_num_entries (string as_cadena, string as_separador);string ls_separador = '¦'
integer li_i, li_num = 0

if as_separador <> '' then ls_separador = as_separador
for li_i = 1 to len(as_cadena)
	if Mid(as_cadena,li_i,1) = ls_separador then li_num++
next
if li_num > 0 then
	li_num++
else
	li_num = 1
end if	
RETURN li_num
end function

public function any of_split (string as_source, string as_separator);int 		li_pos, li_item
string 	ls_SplitArray[]

li_item = 1
do
	li_pos = Pos(as_source, as_separator)	// Get the position of the separator
	if li_pos = 0 then					// if no separator, 
		ls_SplitArray[li_item] = as_source				// return the whole source string and
	else
		ls_SplitArray[li_item] = Mid(as_source, 1, li_pos - 1)	// otherwise, return just the token and
		li_item ++
		as_source = Right(as_source, Len(as_source) - li_pos)	// strip it & the separator		
	end if
loop until li_pos = 0


return ls_SplitArray
end function

public function string of_entry (string as_cadena, integer ai_pos, string as_separador);/* Funcion que regresa una entry en una cadena el parametro as_separador puede ser null, si es asi se pondra por defaul ¦ */
string ls_RETURN, ls_char, ls_separador = ","
integer li_pos, li_pos_ini, li_pos_fin, li_num_entries, li_i, li_ctr = 0

if as_separador <> '' then ls_separador = as_separador
li_num_entries = of_num_entries(as_cadena,ls_separador)
setnull(ls_RETURN)

if ai_pos > 0 and ai_pos <= li_num_entries then
	li_pos = Pos(as_cadena,ls_separador)
	if li_pos > 0 then
		CHOOSE CASE ai_pos
		CASE 1 
			li_pos_fin = li_pos - 1
			ls_RETURN = Left(as_cadena,li_pos_fin)		
		CASE li_num_entries
				li_pos = LastPos(as_cadena,ls_separador)
				li_pos_fin = li_pos + 1
				ls_RETURN = Mid(as_cadena,li_pos_fin)			
		CASE ELSE
				ls_RETURN = ''
				for li_i = 1 to len(as_cadena)
					ls_char = Mid(as_cadena,li_i,1) 
					if ls_char <> ls_separador then ls_RETURN = ls_RETURN + ls_char
					if ls_char = ls_separador then
						li_ctr++		
						if li_ctr = ai_pos then 
							RETURN ls_RETURN
						else
							ls_RETURN = ''
						end if							
					end if						
				next
		END CHOOSE
	else
		ls_RETURN = as_cadena
	end if
end if	
RETURN trim(ls_RETURN)
end function

public function boolean of_iin (readonly any aa_value, readonly any aa_check[]);/*
Method				:  of_iin (Global Function) 
Author				: Chris Pollach
Scope  				: Public
Extended			: No
Level					: Base'

Description			: Performs just like a DBMS's  IN command in SQL.
Behaviour			: Allows the PB developer to pass in two arguments. The first argument is used to check its value 
							with the value(s) passed INTO the 2nd argument. If there is a match, the function RETURNs a TRUE
							otherwise, it RETURNs a FALSE (not match).
							
Note					:  Retuns a Boolean TRUE/FALSE

Argument(s)			: 	any (ReadOnly)			-	aa_value
							any (ReadOnly)			-	aa_check   (array)
							
Throws				: N/A

RETURN Value		: new value

-----------------------------------------------------------  CopyRight ------------------------------------------------------------------
Copyright © 2015 by Software Tool & Die Inc, here in known as STD Inc.  All rights reserved.
Any distribution of the STD Foundation Classes (STD_FC) for InfoMaker, Appeon,
PowerBuilder® source code by other than STD, Inc. is prohibited.
-----------------------------------------------------------  Revisions -------------------------------------------------------------------
1.0 		Inital Version																		-	2015-05-28
*/

// Declarations

Integer		li_loop																					// Work Var
Integer		li_max																						// Work Var
String			ls_type																					// Work Var
Boolean		lb_rc = FALSE																			// Work Var
ls_type		=	ClassName (aa_value)															// Get 1st arg's data type
li_max			=	UpperBound (aa_check[])														// Get # of 2nd Arg's.

FOR  li_loop		=	1  to  li_max																		// Loop thru data
	IF  ClassName (aa_check[li_loop] )  <>  ls_type THEN								// Data type match?
		Continue																								// NO=>Continue the loop!
	ELSE
		IF  aa_check[li_loop]	=	aa_value THEN													// YES=>Values Equal?
			lb_rc	=	 TRUE																					// YES=>Set RC
			EXIT																									// Exit the Loop!
		END IF
	END IF
NEXT

RETURN	lb_rc 																						// RETURN RC to caller

end function

on n_cst_string.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_string.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

