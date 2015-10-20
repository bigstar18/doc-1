#通用模板---------------------------------------------------------------------------
/home/hadoop/hadoop-1.0.4/bin/hadoop job  -Dmapred.job.tracker=hdfs://jobtracker:3003/ -kill job_201205171801_11344

bin/hadoop dfsadmin -safemode leave
/home/hadoop/hadoop-1.0.4/bin/hadoop fsck / -delete
/home/hadoop/hadoop-1.0.4/bin/hadoop balancer &
/home/hadoop/hadoop-1.0.4/bin/start-balancer.sh –t 10%

/home/hadoop/hadoop-1.0.4/bin/start-dfs.sh
/home/hadoop/hadoop-1.0.4/bin/start-mapred.sh
/home/hadoop/hadoop-1.0.4/bin/hadoop-daemon.sh stop datanode
/home/hadoop/hadoop-1.0.4/bin/hadoop-daemon.sh stop tasktracker
/home/hadoop/hadoop-1.0.4/bin/hadoop-daemon.sh start datanode
/home/hadoop/hadoop-1.0.4/bin/hadoop-daemon.sh start tasktracker

/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -lsr /home/hadoop/hadoop-hadoop/data/stats/redirect/2012/*/*/*
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -lsr /home/hadoop/hadoop-hadoop/data/stats/hwcdr/2012*/*
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -lsr /home/hadoop/hadoop-hadoop/data/stats/open/*/*/2012*/*
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -lsr /home/hadoop/hadoop-hadoop/data/stats/surfas/*/2012*/*

/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -du /
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash /user/hive/warehouse/m_surfinproduct/dt=20111124
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash  /tmp/hive-hadoop/hive_2012-04*
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash  /tmp/hive-hadoop/hive_2012-05*
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash  /tmp/hive-hadoop/hive_2012-06*
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash  /tmp/hive-hadoop/hive_2012-07-0*

nohup bin/hive --service hwi &
http://112.4.20.168:9999/hwi/
add jar hdfs://jobtracker:3001/jar/hbase-coprocessor-1.0.0.jar;


add jar /home/hadoop/hive-0.9.0/lib/jdom.jar;
add jar /home/hadoop/hive-0.9.0/lib/ojdbc14_g.jar;
add jar /home/hadoop/hive-0.9.0/lib/cplatform.tools.jar;
add jar /home/hadoop/hive-0.9.0/lib/WorkManager.jar;
create temporary function stats_region as 'com.cplatform.statistics.util.HiveUDFRegion';
create temporary function rd_area as 'com.cplatform.statistics.util.HiveUDFRDArea';
create temporary function stats_percent as 'com.cplatform.statistics.util.HiveUDFPercent';
create temporary function stats_domain as 'com.cplatform.statistics.util.HiveUDFDomain';
create temporary function surf_isharepartner as 'com.cplatform.statistics.util.HiveUDFISharePartner';
create temporary function surf_assistantpartner as 'com.cplatform.statistics.util.HiveUDFAssistantPartner';
create temporary function surf_cooperation as 'com.cplatform.statistics.util.HiveUDFCooperation';
create temporary function surf_bookmarkdownpage as 'com.cplatform.statistics.util.HiveUDFBookmarkDownPage';
create temporary function surf_browserdownpage as 'com.cplatform.statistics.util.HiveUDFBrowserDwonPage';
create temporary function surf_browserpackagedown as 'com.cplatform.statistics.util.HiveUDFBrowserPackageDown';
create temporary function surf_navigation as 'com.cplatform.statistics.util.HiveUDFNavigation';
create temporary function surf_domain as 'com.cplatform.statistics.util.HiveUDFSurfDomain';
create temporary function stats_numformat as 'com.cplatform.statistics.util.HiveUDFNumFormater';
create temporary function stats_timeInterval as 'com.cplatform.statistics.util.HiveUDFTimeInterval';
create temporary function surf_column as 'com.cplatform.statistics.util.HiveUDFColumn';
create temporary function surf_exactdata as 'com.cplatform.statistics.util.HiveUDFExactDataBySymbol';
create temporary function surf_areacode as 'com.cplatform.statistics.util.HiveUDFAreaCode';
create temporary function surf_columncategory as 'com.cplatform.statistics.util.HiveUDFColumnCategory';
create temporary function surf_doubleformat as 'com.cplatform.statistics.util.HiveUDFDoubleFormat';
create temporary function mobile_format as 'com.cplatform.statistics.util.HiveUDFMobileFormat';
create temporary function msip_region as 'com.cplatform.statistics.util.HiveUDFRdMSIPRegion';
show tables;

set mapred.reduce.tasks=1;
set hive.merge.mapredfiles=true;
set hive.merge.mapfiles=true;
nohup /home/hadoop/hive-0.7.1/bin/hive -f /home/hadoop/hive-script.sql &
nohup /home/hadoop/hive-0.7.1/bin/hive -f /home/hadoop/tmp/bf2830.txt &

drop table s_asconf;
describe EXTENDED s_urlnavigation;
ALTER TABLE s_apache ADD PARTITION (dt='20120116');
ALTER TABLE m_surfinproduct DROP PARTITION (dt='20120116',product='assistant');
ALTER TABLE s_ishare DROP PARTITION (dt='20120626');
ALTER TABLE s_ishare DROP PARTITION (dt='20120629');
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash /user/hive/warehouse/s_ishare/dt=20120626
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash /user/hive/warehouse/s_ishare/dt=20120629

LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/asconf/20120713/*.log' OVERWRITE INTO TABLE s_asconf PARTITION (dt='20120713');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfasout/20120116/*.log' INTO TABLE s_surfasout PARTITION (dt='20120116');
LOAD DATA LOCAL INPATH '/home/hadoop/asstd_0706.txt' INTO TABLE m_kpi_month_user PARTITION (dt='201206',origin='assistant_quit');

INSERT OVERWRITE LOCAL DIRECTORY '/tmp/tmp20120628'

select stats_region(r.mobile,'province'),count(r.mobile) from
(select v1.mobile,v1.taskid from (select mobile,taskid from s_surfasmm7 where dt='20130218' and (time like '08:%' or time like '09:%')) v1 left semi join (select mobile from tmp_0110) v2
on (v1.taskid=v2.mobile)) r group by stats_region(r.mobile,'province');

select stats_region(r.mobile,'province'),count(r.mobile) from
(select v1.mobile,v1.taskid from (select mobile,taskid from s_surfasmm7 where dt='20130218' ) v1 left semi join (select mobile from tmp_0110) v2
on (v1.taskid=v2.mobile)) r group by stats_region(r.mobile,'province');

select * from s_surfasmm7 where dt='20130218' and (time like '08:%' or time like '09:%');


#not in
select v1.mobile
from (select mobile FROM m_surfassend where dt='20120321' and type='pvmms' and stats_region(mobile,'province')='上海') v1
left outer join (select t2.mobile from t_mobile t2 where t2.type='shanghai') v2
on (v1.mobile=v2.mobile) where v2.mobile is null;

#北分数据补全
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/hadoop-hadoop/tmp/tmpsms20120628'
select concat(vssend.mobile,'^@@^','20120628','^@@^',stats_region(vssend.mobile,'province'),'^@@^',stats_region(vssend.mobile,'city'),'^@@^^@@^^@@^0^@@^',vssend.stype,'^@@^0^@@^',COALESCE(vshit.hit,0),'^@@^^@@^^@@^0') from
(select v1.mobile as mobile,'1' as stype
FROM (select t1.taskid,t1.mobile from s_surfassms2 t1 where t1.dt='20120628' union all select t2.taskid,t2.mobile from s_surfassms3 t2 where t2.dt='20120628') v1
left semi join (select taskid,tasktype from s_surfasmsgcreat where dt='20120628' and tasktype='S') v2
on (v1.taskid=v2.taskid)
union all
select v11.mobile as mobile,'3' as stype
FROM (select t1.taskid,t1.mobile from s_surfassms2 t1 where t1.dt='20120628' union all select t2.taskid,t2.mobile from s_surfassms3 t2 where t2.dt='20120628') v11
left semi join (select taskid,tasktype from s_surfasmsgcreat where dt='20120628' and tasktype='W') v12
on (v11.taskid=v12.taskid)) vssend
left outer join
(select mobile,count(mobile) as hit from m_surfassend where dt='20120628' and (type='pvmms' or type='pvpush') and mobile is not null group by mobile) vshit
on (vssend.mobile=vshit.mobile)
;

INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/hadoop-hadoop/tmp/tmpmms20120628'
select concat(vmsend.mobile,'^@@^','20120628','^@@^',stats_region(vmsend.mobile,'province'),'^@@^',stats_region(vmsend.mobile,'city'),'^@@^^@@^^@@^0^@@^',vmsend.stype,'^@@^0^@@^',COALESCE(vmhit.hit,0),'^@@^',COALESCE(vmreport.status,''),'^@@^^@@^0') from
(select v1.mobile,'102' as stype
from (select taskid,mobile FROM s_surfasmm7 where dt='20120628'
      union all
      select taskid,mobiles[0] as mobile FROM s_surfasmm7batch where dt='20120628'
      union all
      select taskid,mobiles[1] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>1
      union all
      select taskid,mobiles[2] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>2
      union all
      select taskid,mobiles[3] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>3
      union all
      select taskid,mobiles[4] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>4
      union all
      select taskid,mobiles[5] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>5
      union all
      select taskid,mobiles[6] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>6
      union all
      select taskid,mobiles[7] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>7
      union all
      select taskid,mobiles[8] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>8
      union all
      select taskid,mobiles[9] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>9) v1
left semi join (select t2.taskid from s_surfasmsgcreat t2 where t2.dt='20120628' and t2.tasktype='PM') v2
on (v1.taskid=v2.taskid)
union all
select v11.mobile,'2' as stype
from (select taskid,mobile FROM s_surfasmm7 where dt='20120628'
      union all
      select taskid,mobiles[0] as mobile FROM s_surfasmm7batch where dt='20120628'
      union all
      select taskid,mobiles[1] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>1
      union all
      select taskid,mobiles[2] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>2
      union all
      select taskid,mobiles[3] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>3
      union all
      select taskid,mobiles[4] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>4
      union all
      select taskid,mobiles[5] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>5
      union all
      select taskid,mobiles[6] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>6
      union all
      select taskid,mobiles[7] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>7
      union all
      select taskid,mobiles[8] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>8
      union all
      select taskid,mobiles[9] as mobile FROM s_surfasmm7batch where dt='20120628' and size(mobiles)>9) v11
left semi join (select t2.taskid from s_surfasmsgcreat t2 where t2.dt='20120628' and t2.tasktype='DM') v12
on (v11.taskid=v12.taskid)) vmsend
left outer join
(select v3.mobile,status
from (select serial,mobile,status FROM s_surfasmm7rp where dt='20120628') v3
left semi join (select serial
                from (select taskid,serial from s_surfasmm7 where dt='20120628'
                      union all
                      select taskid,serial from s_surfasmm7batch where dt='20120628') v1
                left semi join (select taskid from s_surfasmsgcreat where dt='20120628' and (tasktype='PM' or tasktype='DM')) v2
                on (v1.taskid=v2.taskid)) v4
on (v3.serial=v4.serial)) vmreport
on (vmsend.mobile=vmreport.mobile)
left outer join
(select mobile,count(mobile) as hit from m_surfassend where dt='20120628' and (type='pvmms' or type='pvpush') and mobile is not null group by mobile) vmhit
on (vmsend.mobile=vmhit.mobile)
;

#给臧圣宏
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/hadoop-hadoop/tmp/zsh/mmsbatch/20120724'
select taskid,mobile,dt,status,serial from s_surfasmm7 where dt='20120724';

INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/hadoop-hadoop/tmp/zsh/apache/20120724'
select mobile,time_format_US(createtime),httpcode,httpsize,refurl,ua,ip,url,httpmethod,partner_out_domain(url,'g3url','url'),partner_out_domain(url,'g3url','sec'),partner_out_domain(url,'m_id','') from s_apache where dt='20120724';
select mobile,time_format_US(createtime),httpcode,httpsize,refurl,ua,ip,url,httpmethod,partner_out_domain(url,'g3url','url'),partner_out_domain(url,'g3url','sec'),partner_out_domain(url,'m_id','') from s_apache where dt='20120724' and url like '%g3url%' limit 10;

INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/hadoop-hadoop/tmp/zsh/ashit/20120724'
select contentid,createtime,mobile,urltype,uid,orgin,issueid,functype from s_surfashit2 where dt='20120724';

#数据墙sql
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/asconf/20120713/*.log' OVERWRITE INTO TABLE s_asconf PARTITION (dt='20120713');

INSERT OVERWRITE TABLE m_asconfuser PARTITION(dt='20120713')
select v1.province,v1.city,COALESCE(v1.mmsuser,0),COALESCE(v2.pushuser,0),COALESCE(v1.mmsuser,0)+COALESCE(v2.pushuser,0),COALESCE(v3.todayadduser,0),COALESCE(v4.todayremoveuser,0),0
from (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(*) as mmsuser from s_asconf where dt='20120713' and STATUS='0' and SEND_TYPE='0' group by stats_region(MOBILE,'province'),stats_region(MOBILE,'city')) v1
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(*) as pushuser from s_asconf where dt='20120713' and STATUS='0' and (SEND_TYPE='1' or SEND_TYPE='2') group by stats_region(MOBILE,'province'),stats_region(MOBILE,'city')) v2
on (v1.province=v2.province and v1.city=v2.city)
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(*) as todayadduser from s_asconf where dt='20120713' and STATUS='0' and CREATETIME like '20120713%' group by stats_region(MOBILE,'province'),stats_region(MOBILE,'city')) v3
on (v1.province=v3.province and v1.city=v3.city)
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(*) as todayremoveuser from s_asconf where dt='20120713' and STATUS='1' and QX_TIME like '2012-07-13%' group by stats_region(MOBILE,'province'),stats_region(MOBILE,'city')) v4
on (v1.province=v4.province and v1.city=v4.city)
;
INSERT OVERWRITE LOCAL DIRECTORY '/tmp/asconf0713'
select province,city,mmsuser,pushuser,totaluser,todayadduser,todayremoveuser from m_asconfuser where dt='20120713';
INSERT OVERWRITE LOCAL DIRECTORY '/tmp/ashit0713' select t.province,city,stats_percent(mmsuv/mmsreceive),stats_percent(pushuv/pushsend),stats_percent((mmsuv+pushuv)/(mmsreceive+pushsend))
from m_surfasaccess t where t.dt='20120713'
;

INSERT OVERWRITE LOCAL DIRECTORY '/tmp/asconf0713'
select province,sum(mmsuser),sum(pushuser),sum(totaluser),sum(todayadduser),sum(todayremoveuser) from m_asconfuser where dt='20120713' group by province;
INSERT OVERWRITE LOCAL DIRECTORY '/tmp/ashit0713' select t.province,stats_percent(sum(t.mmsuv)/sum(t.mmsreceive)),stats_percent(sum(t.pushuv)/sum(t.pushsend)),stats_percent((sum(t.mmsuv)+sum(pushuv))/(sum(t.mmsreceive)+sum(t.pushsend)))
from m_surfasaccess t where t.dt='20120713' group by t.province
;
select t.province,sum(t.mmsuser),sum(t.pushuser),sum(t.totaluser),sum(t.todayadduser),sum(t.todayremoveuser),sum(t.monthadduser)
from m_asconfuser t where t.dt='20120713' group by t.province
;


#查询---------------------------------------------------------------------------

select size(mobiles),mobiles[0] from s_surfasmm7batch where dt='20120116' limit 20;
SELECT * from s_apache t WHERE t.dt='20120116' and t.url RLIKE '^/([pw]|n[pw])/.*$' and stats_region(t.mobile,'province')='青海';
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/wuxi'
SELECT DISTINCT mobile from s_apache t WHERE t.dt like '201201%' and t.url LIKE '/?adid=%' and stats_region(t.mobile,'city')='无锡';
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/hubei'
SELECT mobile,min(createTime) from s_apache t WHERE t.dt like '201201%' and t.url LIKE '/?adid=%' and stats_region(t.mobile,'province')='湖北' group by mobile;
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/surfinproduct'
select t.dt,t.product,t.partner,t.pv,t.uv from r_surfinproduct t where t.dt='20120116' order by t.pv desc;

SELECT count(*),count(DISTINCT mobile) from s_apache t WHERE t.dt>='20120126' and dt<'20120203';

SELECT dt,count(*),count(DISTINCT mobile) from s_apache t WHERE t.dt>='20120612' and dt<'20120620' and t.url LIKE '/indexDefault.do?original=error%' group by dt;
SELECT dt,count(*),count(DISTINCT mobile) from s_apache t WHERE t.dt>='20120612' and dt<'20120620' and t.url LIKE '/awstatsInfo.do?original=error%' group by dt;
SELECT dt,count(*),count(DISTINCT mobile) from s_apache t WHERE t.dt>='20120612' and dt<'20120620' and t.url LIKE '/subscribeFun.do?method=detailColumn%original=error%' group by dt;
SELECT dt,count(*),count(DISTINCT mobile) from s_apache t WHERE t.dt>='20120612' and dt<'20120620' and (t.url LIKE '%id=iiZ3hp%mcpid=324Z2FVZ2N9%' or t.url LIKE '%id=iiZ3hq%mcpid=324Z2FVZ2Na%' or t.url LIKE '%id=iiZ3hr%mcpid=324Z2FVZ2Nb%') group by dt;


SELECT url from s_apache t WHERE t.dt>'20120411' and dt<'20120423' and (t.url like '%000400070002%' or url like '%000400010001%');
SELECT count(*),count(DISTINCT mobile) from s_apache t WHERE dt>'20120411' and dt<'20120423' and (url like '%000400070002%' or url like '%000400010001%');
SELECT count(*),count(DISTINCT mobile) from s_apache t WHERE dt='20120412' and url='http://wap.js.10086.cn/page?FOLDERID=000400010001';

SELECT count(*) from s_apache t WHERE t.dt='20120213' and t.url LIKE '%m_id=322287492%';
SELECT count(*),count(DISTINCT mobile) from s_apache t WHERE t.dt='20120303' and t.url LIKE '%mcpid=1RQZ1TKZ1TT%';
SELECT count(*),count(DISTINCT mobile) from s_urlnavigation t WHERE t.dt='20120303' and t.url LIKE '%mcpid=1RQZ1TKZ1TT%';
SELECT DISTINCT url from s_urlnavigation t WHERE t.dt='20120303' and t.url LIKE '%mcpid=1RQZ1TKZ1TT%';

http://go.10086.cn/awstatsNew.do?versionType=2&deep=2&m_id=51588473&g3url=http://go.10086.cn/adsi/adclk?id=iiZ2Kh&mcpid=1RQZ1TKZ1TT&show_form=1

INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/daohang'
http://go.10086.cn/adsi/adclk?id=iiZ2Ks&amp;mcpid=1RQZ1TKZ1TN&amp;show_form=1

SELECT count(DISTINCT mobile) from s_urlnavigation t WHERE t.dt='20120214' and t.url LIKE '%mcpid=1RQZ1TKZ1TN%';
SELECT DISTINCT url from s_urlnavigation t WHERE t.dt='20120214' and t.url LIKE '%mcpid=1RQZ1TKZ1TN%';

SELECT count(*) from s_apache t WHERE t.dt='20120218' and t.url LIKE '/?adid4101=%';
SELECT DISTINCT url from s_apache t WHERE t.dt='20120220' and t.url LIKE '%adid4101=%';


from m_surfassend
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/forHot'
select DISTINCT mobile where dt >='20120312' and dt <='20120317' and type like 'pv%' and  stats_region(mobile,'province')='江苏';

LOAD DATA INPATH '/user/hive/warehouse/m_kpi_month_user/dt=201206/origin=assistant_quit/*' INTO TABLE m_kpi_month_user PARTITION (dt='201205',origin='assistant_quit');
ALTER TABLE m_kpi_month_user DROP PARTITION (dt='201206',origin='assistant_quit');
LOAD DATA LOCAL INPATH '/home/hadoop/asstd_0706.txt' INTO TABLE m_kpi_month_user PARTITION (dt='201206',origin='assistant_quit');

from m_surfassend
INSERT OVERWRITE local DIRECTORY '/tmp/安徽六安助手清单_20120704'
select DISTINCT mobile where dt='20120704' and stats_region(mobile,'city')='六安' and (type='pvmms' or type='pvpush')
INSERT OVERWRITE local DIRECTORY '/tmp/安徽六安助手清单_20120705'
select DISTINCT mobile where dt='20120705' and stats_region(mobile,'city')='六安' and (type='pvmms' or type='pvpush')
INSERT OVERWRITE local DIRECTORY '/tmp/安徽六安助手清单_20120706'
select DISTINCT mobile where dt='20120706' and stats_region(mobile,'city')='六安' and (type='pvmms' or type='pvpush')
INSERT OVERWRITE local DIRECTORY '/tmp/安徽六安助手清单_20120707'
select DISTINCT mobile where dt='20120707' and stats_region(mobile,'city')='六安' and (type='pvmms' or type='pvpush')
INSERT OVERWRITE local DIRECTORY '/tmp/安徽六安助手清单_20120708'
select DISTINCT mobile where dt='20120708' and stats_region(mobile,'city')='六安' and (type='pvmms' or type='pvpush');

insert into td_hive_sql_task (sqlstr) values('INSERT OVERWRITE local DIRECTORY '/tmp/coc_华为工具条_mobile' select distinct mobile_format(mobile) from m_coc where dt >='20120607' and dt<='20120703' and channels_code='6GG3GGJV'')

select * from s_ishare where dt='20120614' and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154' and stats_region(sMobile,'city')='南京';

#join示例
select
from () v1
left OUTER join () v2
on (v1.province=v2.province and v1.city=v2.city)
left OUTER join () v3
on (v1.province=v3.province and v1.city=v3.city)
left OUTER join () v4
on (v1.province=v4.province and v1.city=v4.city)
left OUTER join () v5
on (v1.province=v5.province and v1.city=v5.city)
left OUTER join () v6
on (v1.province=v6.province and v1.city=v6.city)
left OUTER join () v7
on (v1.province=v7.province and v1.city=v7.city)
left OUTER join () v8
on (v1.province=v8.province and v1.city=v8.city)
left OUTER join () v9
on (v1.province=v9.province and v1.city=v9.city)
left OUTER join () v10
on (v1.province=v10.province and v1.city=v10.city)
;

#合作方
SELECT DISTINCT url from s_apache t WHERE t.dt='20120310' and t.url like '/sub.do%';

SELECT surf_isharepartner(t.url),count(*) from s_apache t WHERE t.dt like '2012032%' and t.url like '/ishare.do%' GROUP BY surf_isharepartner(t.url);
SELECT surf_isharepartner(t.url),count(*) from s_apache t WHERE t.dt='20120321' and t.url like '/ishare.do%' GROUP BY surf_isharepartner(t.url);
SELECT surf_browserpackagedown(t.url),count(*) from s_apache t WHERE t.dt='20120313' and t.url like '/msb_server/download/%.apk%' GROUP BY surf_browserpackagedown(t.url);

INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/ishare'
SELECT * from s_apache t WHERE (t.dt='20120307' or t.dt='20120308') and t.url like '/ishare.do%';

SELECT DISTINCT url from s_apache t WHERE t.dt='20120310' and t.url like '/co/surf.jsp?adid=%' limit 200;
SELECT DISTINCT url from s_apache t WHERE t.dt='20120310' and t.url like '/tools/browser.jsp?adid=%' limit 200;
SELECT DISTINCT url from s_apache t WHERE t.dt='20120310' and t.url like '/msb_server/download/%.apk%' limit 200;

SELECT * from s_apache t WHERE t.dt like '2012030%' and t.url like '/awstats.do?sid=10011%' limit 200;
SELECT url FROM s_apache t WHERE t.dt='20120321' and url like '%sid=6295c13d16170cd3930687d8156ed4a0%';

SELECT count(*) FROM s_surfasHit2 t WHERE t.dt='20120315' and url like '%sohu.com%';
SELECT count(*) FROM s_surfasHit2 t WHERE t.dt='20120315' and url like '%fr=sjcl_zsmh%';
SELECT surf_domain(t.url,'top'),surf_domain(t.url,'sec'),count(*) FROM s_surfasHit2 t WHERE t.dt='20120225' and surf_domain(t.url,'top')!='空' GROUP BY surf_domain(t.url,'top'),surf_domain(t.url,'sec');

SELECT url FROM s_surfasHit2 t
 WHERE t.dt='20120227' and surf_domain(t.url,'top')='空';

SELECT url FROM s_urlnavigation t
 WHERE t.dt='20120227' and t.type='out' and surf_domain(t.url,'top')='空';

FROM m_surfoutproduct t
INSERT OVERWRITE TABLE r_surfoutproduct PARTITION(dt='20120116')
SELECT t.product,t.topdomain,t.secdomain,sum(t.pv),count(DISTINCT t.mobile)
WHERE t.dt='20120116'
GROUP BY t.product,t.topdomain,t.secdomain;

select t.dt,t.product,t.topdomain,t.secdomain,t.pv,t.uv from r_surfoutproduct t where t.dt='20120116' order by t.pv desc,t.topdomain,t.secdomain;
SELECT t.dt,t.product,t.topdomain as ttopdomain,sum(t.pv) as spv,count(DISTINCT t.mobile) FROM m_surfoutproduct t WHERE t.dt='20120116' GROUP BY t.dt,t.product,t.topdomain order by spv desc,ttopdomain;
SELECT t.dt,t.product,t.topdomain as ttopdomain,t.secdomain,sum(t.pv) as spv,count(DISTINCT t.mobile) FROM m_surfoutproduct t WHERE t.dt='20120116' GROUP BY t.dt,t.product,t.topdomain,t.secdomain order by spv desc,ttopdomain;
SELECT t.dt,t.topdomain as ttopdomain,sum(t.pv) as spv,count(DISTINCT t.mobile) FROM m_surfoutproduct t WHERE t.dt='20120116' GROUP BY t.dt,t.topdomain order by spv desc,ttopdomain;
SELECT t.dt,t.topdomain as ttopdomain,t.secdomain,sum(t.pv) as spv,count(DISTINCT t.mobile) FROM m_surfoutproduct t WHERE t.dt='20120116' GROUP BY t.dt,t.topdomain,t.secdomain order by spv desc,ttopdomain;

#助手日报
LOAD DATA LOCAL INPATH '/home/hadoop/tmp/hit116.tsv' INTO TABLE s_surfasHit PARTITION (dt='20120116');

select count(*) FROM s_surfasHit2 t1 where t1.dt='20120318' and t1.orgin!='3' and functype !='ta' and t1.mobile != '';
select count(*) FROM s_surfasHit2 t1 where t1.dt='20120318' and t1.orgin!='3' and functype !='ta';
select count(DISTINCT mobile) FROM s_surfasHit2 t1 where t1.dt='20120318' and t1.orgin!='3' and functype !='ta';
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/huaian'
select DISTINCT mobile FROM s_surfasHit2 t1 where t1.dt='20120318' and t1.orgin!='3' and functype !='ta' and cityinfo='淮安';
select DISTINCT mobile FROM s_surfasHit2 t1 where t1.dt='20120318' and t1.orgin!='3' and stats_region(mobile,'province')='安徽';
select * from s_apache where dt='20120318' and (mobile='8613557072733' or mobile='13557072733');

INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/m_surfasaccess'
select * from m_surfasaccess t where t.dt='20120116' order by t.province,t.city;

select t.province,sum(t.mmssend),sum(t.mmsreceive),sum(t.mmsreceiveUser),sum(t.mmsuv)
from m_surfasAccessMonth t where t.dt='201201' group by t.province
;
select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(m.mobile) as mmspv,count(DISTINCT m.mobile) as mmsuv from m_surfassend m where m.dt like '201201%' and m.type='pvmms' and stats_region(m.mobile,'province')='新疆' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city');
select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(m.mobile) as mmspv,count(DISTINCT m.mobile) as mmsuv from m_surfassend m where m.dt like '201201%' and m.type='mm7rp' and stats_region(m.mobile,'province')='新疆' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city');
select DISTINCT m.mobile from m_surfassend m where m.dt like '201201%' and m.type='pvmms' and stats_region(m.mobile,'province')='新疆';
select DISTINCT m.mobile from m_surfassend m where m.dt like '201201%' and m.type='mm7rp' and stats_region(m.mobile,'province')='新疆';

select * FROM s_surfasHit where dt like '201201%' and receiveType!='t' and receiveType!='w' and mobile='15809077520';

LOAD DATA local INPATH '/home/hadoop/tmp/webNavigation.log' INTO TABLE s_urlnavigation PARTITION (dt='20120117');
select * from s_urlnavigation where dt='20120117' and categoryname is not null and level='1';
select * from s_urlnavigation where dt='20120117' and level='1' limit 10;
select category,secondcategory,sitename,url from s_urlnavigation where dt='20120117' and type='out';
ALTER TABLE s_urlnavigation DROP PARTITION (dt='20120117');

INSERT OVERWRITE local DIRECTORY '/tmp/yangzhou_mms_0501'
select mobile from m_surfassend v1 where dt='20120501' and type='mm7s' and stats_region(mobile,'city')='扬州'
left semi join
(select mobile from m_surfassend where dt='20120501' and type='mm7rp') v2
on (v1.mobile=v2.mobile)


#爱分享
INSERT OVERWRITE local DIRECTORY '/tmp/ishare1' select concat_ws(',',smobile,stats_region(sMobile,'city'),rmobile,stats_region(rmobile,'city'),sharetitle,shareurl,createtime) from s_ishare where dt='20121125' and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154';
INSERT OVERWRITE local DIRECTORY '/tmp/ishare2' select concat_ws(',',smobile,cast(count(rmobile) as String),sharetitle,shareurl,createtime) from s_ishare where dt='20121125' and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154' group by smobile,sharetitle,shareurl,createtime;


LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/ishare/20120116/*log' INTO TABLE s_ishare PARTITION (dt='20120116');
LOAD DATA LOCAL INPATH '/home/hadoop/tmp/receive_mobile.txt' INTO TABLE t_mobile PARTITION (type='tmp');

select count(*),count(DISTINCT mobile) from s_ishare where dt='20120311' and success>0 and stats_region(sMobile,'city')='常州';
select count(*) from s_ishare where dt='20120311' and success>0 and stats_region(sMobile,'city')='常州' and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154';
select mobile from t_mobile where type='tmp';
create temporary function stats_mobilein as 'com.cplatform.statistics.util.HiveUDFMobileIn';
DROP TEMPORARY FUNCTION IF EXISTS stats_mobilein;

select count(*) from m_ishareMobile where dt='total' and type='receive';

INSERT OVERWRITE TABLE m_ishareMobile PARTITION (dt='total',type='send')
select mobile from m_ishareMobile where dt='total' and type='send' and mobile !='13585442484' and mobile !='13961494194' and mobile !='13961494154'
;
INSERT OVERWRITE TABLE m_ishareMobile PARTITION (dt='total',type='receive')
select mobile from m_ishareMobile where dt='total' and type='receive' and stats_mobilein(mobile)='f'
;
INSERT OVERWRITE TABLE m_ishareMobile PARTITION (dt='total',type='all')
select mobile from m_ishareMobile where dt='total' and type='all' and stats_mobilein(mobile)='f'
;

from s_ishare
INSERT OVERWRITE TABLE m_ishareMobile PARTITION(dt='20120116',type='send')
select DISTINCT sMobile where dt='20120116'
INSERT OVERWRITE TABLE m_ishareMobile PARTITION(dt='20120116',type='receive')
select DISTINCT rMobile where dt='20120116'
;
INSERT OVERWRITE TABLE m_ishareMobile PARTITION(dt='20120116',type='all')
select DISTINCT mobile from m_ishareMobile where dt='20120116' and (type='send' or type='receive')
;

INSERT OVERWRITE TABLE m_ishareMobile PARTITION (dt='total',type='all')
select DISTINCT mobile from
(select mobile from m_ishareMobile where dt='20120116' and type='all'
union all select mobile from m_ishareMobile where dt='total' and type='all') u
;
INSERT OVERWRITE TABLE m_ishareMobile PARTITION (dt='total',type='send')
select DISTINCT mobile from
(select mobile from m_ishareMobile where dt='20120116' and type='send'
union all select mobile from m_ishareMobile where dt='total' and type='send') u
;
INSERT OVERWRITE TABLE m_ishareMobile PARTITION (dt='total',type='receive')
select DISTINCT mobile from
(select mobile from m_ishareMobile where dt='20120116' and type='receive'
union all select mobile from m_ishareMobile where dt='total' and type='receive') u
;

INSERT OVERWRITE TABLE m_ishare PARTITION (dt='20120116')
select v1.province,v1.city,v1.sharecount,v2.shareHit,v3.shareSelfCount,v4.shareSelfHit from
(select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as shareCount from s_ishare where dt='20120116' group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v1
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as shareHit from s_ishare where dt='20120116' and success>0 group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v2
on (v1.province=v2.province and v1.city=v2.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as shareSelfCount from s_ishare where dt='20120116' and sMobile=rMobile group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v3
on (v1.province=v3.province and v1.city=v3.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as shareSelfHit from s_ishare where dt='20120116' and sMobile=rMobile and success>0 group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v4
on (v1.province=v4.province and v1.city=v4.city)
;

INSERT OVERWRITE TABLE r_ishare PARTITION (dt='20120116')
select v1.province,v1.city,v1.totalUser,v2.totalSendUser,v3.totalReceiveUser,v4.sendUser,v5.receiveUser,stats_percent(v4.sendUser/v2.totalSendUser),v6.sharecount,v6.shareHit,stats_percent(v6.shareHit/v6.sharecount),v7.shareHitUser,v7.shareHitUser/ v5.receiveUser,v6.shareSelfCount,stats_percent(v6.shareSelfHit/v6.shareSelfCount),v6.sharecount/v4.sendUser,v5.receiveUser/v4.sendUser,v6.sharecount/v5.receiveUser,v1.totalUser-v8.totalUser,v2.totalSendUser-v8.totalSendUser,v3.totalReceiveUser-v8.totalReceiveUser,v9.mmsCount,v10.smsCount
from (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as totalUser from m_ishareMobile where dt='total' and type='all' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v1
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as totalSendUser from m_ishareMobile where dt='total' and type='send' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v2
on (v1.province=v2.province and v1.city=v2.city)
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as totalReceiveUser from m_ishareMobile where dt='total' and type='receive' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v3
on (v1.province=v3.province and v1.city=v3.city)
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as sendUser from m_ishareMobile where dt='20120116' and type='send' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v4
on (v1.province=v4.province and v1.city=v4.city)
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as receiveUser from m_ishareMobile where dt='20120116' and type='receive' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v5
on (v1.province=v5.province and v1.city=v5.city)
left OUTER join (select province,city,sharecount,shareHit,shareSelfCount,shareSelfHit from m_ishare where dt='20120116') v6
on (v1.province=v6.province and v1.city=v6.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(DISTINCT rMobile) as shareHitUser from s_ishare where dt='20120116' and success>0 group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v7
on (v1.province=v7.province and v1.city=v7.city)
left OUTER join (select province,city,totalUser,totalSendUser,totalReceiveUser from r_ishare where dt='20120115') v8
on (v1.province=v8.province and v1.city=v8.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as mmsCount from s_ishare where dt='20120116' and (shareType='1' or shareType='2') group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v9
on (v1.province=v9.province and v1.city=v9.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as smsCount from s_ishare where dt='20120116' and (shareType='0' or shareType='6') group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v10
on (v1.province=v10.province and v1.city=v10.city)
;
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/r_ishare20120116'
select * from r_ishare where dt='20120116' order by province,city;
select sMobile,count(rMobile) from s_ishare where dt='20120115' and stats_region(sMobile,'city')='常州' group by sMobile;


#重定向
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/01/in/*.log' INTO TABLE s_rdIn PARTITION (dt='20120101');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/01/out/*.log' INTO TABLE s_rdOut PARTITION (dt='20120101');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/01/rc/*.log' INTO TABLE s_rdrecommend PARTITION (dt='20120101');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/01/search/*.log' INTO TABLE s_rdsearch PARTITION (dt='20120101');

LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/02/in/*.log' INTO TABLE s_rdIn PARTITION (dt='20120102');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/02/out/*.log' INTO TABLE s_rdOut PARTITION (dt='20120102');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/02/rc/*.log' INTO TABLE s_rdrecommend PARTITION (dt='20120102');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/02/search/*.log' INTO TABLE s_rdsearch PARTITION (dt='20120102');

LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/03/in/*.log' INTO TABLE s_rdIn PARTITION (dt='20120103');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/03/out/*.log' INTO TABLE s_rdOut PARTITION (dt='20120103');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/03/rc/*.log' INTO TABLE s_rdrecommend PARTITION (dt='20120103');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/03/search/*.log' INTO TABLE s_rdsearch PARTITION (dt='20120103');

LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/04/in/*.log' INTO TABLE s_rdIn PARTITION (dt='20120104');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/04/out/*.log' INTO TABLE s_rdOut PARTITION (dt='20120104');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/04/rc/*.log' INTO TABLE s_rdrecommend PARTITION (dt='20120104');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/04/search/*.log' INTO TABLE s_rdsearch PARTITION (dt='20120104');

LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/08/in/*.log' INTO TABLE s_rdIn PARTITION (dt='20120108');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/08/out/*.log' INTO TABLE s_rdOut PARTITION (dt='20120108');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/08/rc/*.log' INTO TABLE s_rdrecommend PARTITION (dt='20120108');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/08/search/*.log' INTO TABLE s_rdsearch PARTITION (dt='20120108');

LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/09/in/*.log' INTO TABLE s_rdIn PARTITION (dt='20120109');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/09/out/*.log' INTO TABLE s_rdOut PARTITION (dt='20120109');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/09/rc/*.log' INTO TABLE s_rdrecommend PARTITION (dt='20120109');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/09/search/*.log' INTO TABLE s_rdsearch PARTITION (dt='20120109');

LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/10/in/*.log' INTO TABLE s_rdIn PARTITION (dt='20120110');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/10/out/*.log' INTO TABLE s_rdOut PARTITION (dt='20120110');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/10/rc/*.log' INTO TABLE s_rdrecommend PARTITION (dt='20120110');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/10/search/*.log' INTO TABLE s_rdsearch PARTITION (dt='20120110');

LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/11/in/*.log' INTO TABLE s_rdIn PARTITION (dt='20120111');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/11/out/*.log' INTO TABLE s_rdOut PARTITION (dt='20120111');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/11/rc/*.log' INTO TABLE s_rdrecommend PARTITION (dt='20120111');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2012/01/11/search/*.log' INTO TABLE s_rdsearch PARTITION (dt='20120111');






INSERT OVERWRITE TABLE m_surfassend PARTITION(dt='20120116',type='pvpush')
select u.mobile
from (select v1.mobile
      from (select t1.mobile FROM s_surfasHit2 t1 where t1.dt='20120116' and (t1.orgin='1' or t1.orgin='2')) v1
      left SEMI join (select t2.mobile from m_surfassend t2 where t2.dt='20120116' and (t2.type='sms' or t2.type='mm7s')) v2
      on (v1.mobile=v2.mobile)
      union all select t3.mobile FROM s_surfasHit2 t3 where t3.dt='20120116' and (t3.orgin='1' or t3.orgin='2') and t3.mobile='') u;

INSERT OVERWRITE TABLE m_surfassend PARTITION(dt='20120116',type='pvmms')
select u.mobile
from (select v1.mobile
      from (select mobile FROM s_surfasHit2 where dt='20120116' and receiveType='0') v1
      left SEMI join (select t2.mobile from m_surfassend t2 where t2.dt='20120116' and (t2.type='sms' or t2.type='mm7s')) v2
      on (v1.mobile=v2.mobile)
      union all select mobile FROM s_surfasHit2 where dt='20120116' and receiveType='0' and mobile='') u;
