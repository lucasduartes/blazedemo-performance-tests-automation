@echo off
setlocal

set RESULT_DIR=results\spike
set REPORT_DIR=reports\spike

if exist "%RESULT_DIR%" rmdir /s /q "%RESULT_DIR%"
if exist "%REPORT_DIR%" rmdir /s /q "%REPORT_DIR%"

mkdir "%RESULT_DIR%"
mkdir "%REPORT_DIR%"

echo Running BlazeDemo spike test...

jmeter -n ^
  -t jmeter\spike-test.jmx ^
  -JbaseRate=63 ^
  -JtotalDuration=150 ^
  -JgracePeriod=30 ^
  -JspikeStart=60 ^
  -JspikeExtraRate=62 ^
  -JspikeDuration=30 ^
  -JspikeTail=90 ^
  -l "%RESULT_DIR%\results.jtl" ^
  -e ^
  -o "%REPORT_DIR%"

if errorlevel 1 (
    echo.
    echo Spike test execution failed.
    exit /b 1
)

echo.
echo Spike test finished.
echo JTL: %RESULT_DIR%\results.jtl
echo HTML report: %REPORT_DIR%\index.html

endlocal