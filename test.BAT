@echo off
d:
cd\testap
showwin 1
disableX.exe
ping 127.0.0.1 -n 1 >nul


:audiof
echo FRONT AUDIO TEST NOW..........
echo FRONT AUDIO TEST NOW..........
CD\TESTAP\HDTEST
DEL PASS.TXT
DEL FPASS.TXT
copy front.cfg hdatest.cfg
wautest
if not errorlevel 1 goto pass1
wautest
if not errorlevel 1 goto pass1
wautest
if not errorlevel 1 goto pass1
wautest
if not errorlevel 1 goto pass1
wautest
if not errorlevel 1 goto pass1
goto fail1

:audior
echo REAR AUDIO TEST NOW..........
echo REAR AUDIO TEST NOW..........
CD\TESTAP\HDTEST
DEL PASS.TXT
DEL RPASS.TXT
copy rear.cfg hdatest.cfg
wautest
if not errorlevel 1 goto pass2
wautest
if not errorlevel 1 goto pass2
wautest
if not errorlevel 1 goto pass2
wautest
if not errorlevel 1 goto pass2
wautest
if not errorlevel 1 goto pass2
goto fail2

:fail1
echo audio(front)test fail!!!
echo audio(front) fail!!!
ping 127.0.0.1 -n 2 >nul
reg add hkey_current_user\software\ft\WindowsTest /v AUDIOF /t reg_sz /d FAIL /f
reg add hkey_current_user\software\ft\WindowsTest /v rerrcode /t reg_sz /d TXA01 /f
goto audiof

:fail2
echo audio(rear)test fail!!!
echo audio(rear) fail!!!
ping 127.0.0.1 -n 2 >nul
reg add hkey_current_user\software\ft\WindowsTest /v AUDIOR /t reg_sz /d FAIL /f
reg add hkey_current_user\software\ft\WindowsTest /v rerrcode /t reg_sz /d TXA01 /f
goto audior

:pass1
ECHO AUDIOF TEST PASS!!!
COPY PASS.TXT FPASS.TXT
if exist fpass.txt goto audior
goto audiof

:pass2
ECHO AUDIOR TEST PASS!!!
COPY PASS.TXT RPASS.TXT
if exist rpass.txt goto end
goto audior

:end
echo audio.bat >>d:\testap\test.log 
find "audio.bat" d:\testap\test.log
if errorlevel 1 goto end
cd\testap\backup
call audiochk.bat
call chklog.bat
cd\testap
del test.log
reg add hkey_current_user\software\ft\WindowsTest /v AUDIO /t reg_sz /d PASS /f
exit