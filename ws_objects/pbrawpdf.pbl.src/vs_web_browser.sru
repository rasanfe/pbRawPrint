$PBExportHeader$vs_web_browser.sru
forward
global type vs_web_browser from webbrowser
end type
end forward

global type vs_web_browser from webbrowser
integer width = 4352
integer height = 2764
end type
global vs_web_browser vs_web_browser

on vs_web_browser.create
end on

on vs_web_browser.destroy
end on

event constructor;String ls_CurrentDir
ls_CurrentDir  = GetCurrentDirectory()
DefaultUrl = ls_CurrentDir+"\home.html"
Navigate(DefaultUrl)
end event

