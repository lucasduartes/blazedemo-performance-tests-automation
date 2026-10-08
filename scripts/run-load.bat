@echo off
setlocal

set RESULT_DIR=results\load
set REPORT_DIR=reports\load

if exist "%RESULT_DIR%" rmdir /s /q "%RESULT_DIR%"
if exist "%REPORT_DIR%" rmdir /s /q "%REPORT_DIR%"

mkdir "%RESULT_DIR%"
mkdir "%REPORT_DIR%"

echo Running BlazeDemo load test...

jmeter -n ^
  -t jmeter\load-test.jmx ^
  -JflowRate=63 ^
  -Jduration=180 ^
  -JgracePeriod=30 ^
  -l "%RESULT_DIR%\results.jtl" ^
  -e ^
  -o "%REPORT_DIR%"

if errorlevel 1 (
    echo.
    echo Load test execution failed.
    exit /b 1
)

echo.
echo Load test finished.
echo JTL: %RESULT_DIR%\results.jtl
echo HTML report: %REPORT_DIR%\index.html

endlocal