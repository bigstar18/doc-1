@echo off

echo 长三角交易系统 银行人工签到签退....
echo path:%~dp0

rem set base=%~dp0

set base=C:\bank\pingan\apache-tomcat-8.0.28\webapps\pinganBankAdapter\WEB-INF
set class=%base%\classes
set libs=%base%\lib

set class_path=%class%;%libs%\processor4adapter.jar;%libs%\util-settlePlatform-api-1.0.0.jar;%libs%\baseAdapter.jar;
set class_path=%class%;%libs%\slf4j-api-1.7.7.jar;%libs%\..\..\..\..\lib\servlet-api.jar;%libs%\httpclient-4.2.1.jar;
set class_path=%class%;%libs%\httpcore-4.2.1.jar;%libs%\commons-lang-2.6.jar;

java -classpath %class_path% com.yrdce.bank.adapter.pingan.utils.LononOutUtil
@pause
