@echo off

:test
 Wtl584 -c 1FC8 0900 060400 80 01 00 00 16x  

 if not errorlevel 1 GOTO PASS

 ECHO PCI-E16X TEST FAIL

 pause

 goto test

:pass
