@ECHO OFF
For /f "delims=" %%i in (WoWLoc) DO (
XCOPY .\CheatSheet %%i\CheatSheet /s /i /y
XCOPY .\CheatSheet_Defaults %%i\CheatSheet_Defaults /s /i /y)