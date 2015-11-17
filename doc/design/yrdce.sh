#!/bin/sh
#unzip -o   overwrite files WITHOUT prompting  

#./yrdce.sh --tarServAll
#./yrdce.sh --tarFrontAll
#./yrdce.sh --tarMgrAll

export LANG=zh_CN.UTF-8

tarAll()
{
files=`find ~/ -type f -name "jdbc.properties" -o -name "rmi.properties" -o -name "coreRMI.properties" -o -name "gnnt_profile" -o -name "credentials*.properties" -o -name "start.sh" -o -name "runK.sh" -o -name "activemq.xml" -o -name "MEBS*.xml" -o -name "QSerice.xml" -o -name "spring_sys_msg.xml" -o -name "MarketMessage_zh_CN.properties"`
fname=$1
fname=${fname:2}.tgz
rm -f $fname
tar -zPcf $fname  ${files[@]}
}

tarProp()
{
files=`find ~/ -name "*.properties"`
fname=$1
fname=${fname:2}.tgz
rm -f $fname
tar -zPcf $fname  ${files[@]}
}

tarRmi()
{
files=`find ~/ -name "rmi.properties"`
fname=$1
fname=${fname:2}.tgz
rm -f $fname
tar -zPcf $fname  ${files[@]}
}

tarSh()
{
files=`find ~/ -name "*.sh"`
fname=$1
fname=${fname:2}.tgz
rm -f $fname
tar -zPcf $fname  ${files[@]}
}

tarXml()
{
files=`find ~/ -name "*.xml"`
fname=$1
fname=${fname:2}.tgz
rm -f $fname
tar -zPcf $fname  ${files[@]}
}

tarJdbc()
{
files=`find ~/ -name "jdbc.properties"`
fname=$1
fname=${fname:2}.tgz
rm -f $fname
tar -zPcf $fname  ${files[@]}
}

#cat /dev/null>nohup.out
case $1 in
--tarServAll)
	#shift
	tarAll $@
	;;
--tarServProp)
	#shift
	tarProp $@
	;;
--tarServSh)
	#shift
	tarSh $@
	;;
--tarServRmi)
	#shift
	tarRmi $@
	;;
--tarServXml)
	#shift
	tarXml $@
	;;
--tarServJdbc)
	#shift
	tarJdbc $@
	;;
--tarFrontAll)
	#shift
	tarAll $@
	;;
--tarFrontProp)
	#shift
	tarProp $@
	;;
--tarFrontSh)
	#shift
	tarSh $@
	;;
--tarFrontRmi)
	#shift
	tarRmi $@
	;;
--tarFrontXml)
	#shift
	tarXml $@
	;;
--tarFrontJdbc)
	#shift
	tarJdbc $@
	;;
--tarMgrAll)
	#shift
	tarAll $@
	;;
--tarMgrProp)
	#shift
	tarProp $@
	;;
--tarMgrSh)
	#shift
	tarSh $@
	;;
--tarMgrRmi)
	#shift
	tarRmi $@
	;;
--tarMgrXml)
	#shift
	tarXml $@
	;;
--tarMgrJdbc)
	#shift
	tarJdbc $@
	;;
*)
	echo "`date +"%F %T"` error $@"
esac
