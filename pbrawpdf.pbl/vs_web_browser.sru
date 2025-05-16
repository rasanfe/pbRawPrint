forward
global type vs_web_browser from webbrowser
end type
end forward

global type vs_web_browser from webbrowser
integer width = 4352
integer height = 2764
end type
global vs_web_browser vs_web_browser

type variables
string is_file
end variables

forward prototypes
public subroutine of_printwithdialog ()
public function boolean of_loadfile (string as_file)
end prototypes

public subroutine of_printwithdialog ();openWithParm(w_print_dialog,is_file)

end subroutine

public function boolean of_loadfile (string as_file);if as_file="" then 
	is_file=DefaultURL
else
	is_file=as_file
end if	

if Navigate(is_file) <> 1 then
	RETURN FALSE
else
	RETURN TRUE
end if
end function

on vs_web_browser.create
end on

on vs_web_browser.destroy
end on

event constructor;DefaultUrl = gs_dir+"\home.html"
Navigate(DefaultUrl)
end event

