@echo on
seclocal enabledelayedexpansion
REM only runs on WinNT.
SET OBJ_PATH=..\..\OCDC2308_Proj\build\obj\
SET OBJ_TEMP=..\..\OCDC2308_SW\build\tmp\
SET LIB_PATH=..\..\OCDC2308_SW\components\
SET LIB_NAME=libOCDC.a
SET TOOL_EXE=ppc-freevle-eabi-ar.exe
SET TOOL_ARGS=-rc
SET SRC_LIST=srcfile.lst
SET SRC_PATH=..\..\OCDC2308_SW\source\
SET OBJ_LIST=objfile.lst
SET INC_LIST=incfile.lst
SET PRJ_PATH=..\..\OCDC2308_Proj\
@echo off

RMDIR /s/q %OBJ_TEMP%

xcopy "%OBJ_PATH%*.o" "%OBJ_TEMP%" /s /i
DEL /q/f/s %SRC_PATH%*.c
for /f "tokens=*" %%i in (%SRC_LIST%) do (
    @REM SET "fileName=%%~ni"
    DEL %OBJ_TEMP%%%~ni.o
    for /r "%PRJ_PATH%" %%f in (%%i) do (
        copy %%f %SRC_PATH%%%~nxf
    )
)
DEL /f/q %OBJ_LIST%
for %%i in ("%OBJ_TEMP%\*.o") do (
    echo %OBJ_TEMP%%%~nxi>>"%OBJ_LIST%"
)
DEL /q/f %LIB_PATH%%LIB_NAME%
DEL /q/f/s %LIB_PATH%*.h
for /f "tokens=*" %%i in (%OBJ_LIST%) do (
    %TOOL_EXE% %TOOL_ARGS% %LIB_PATH%%LIB_NAME% %%i
)
for /r "%PRJ_PATH%" %%i in (*.h) do (
    copy %%i %LIB_PATH%%%~nxi
)

endlocal
