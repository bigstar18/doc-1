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
create temporary function stats_timeInterval as 'com.cplatform.statistics.util.HiveUDFTimeInterval';
create temporary function stats_numformat as 'com.cplatform.statistics.util.HiveUDFNumFormater';
create temporary function stats_mobilein as 'com.cplatform.statistics.util.HiveUDFMobileIn';

create temporary function time_format_US as 'com.cplatform.statistics.util.HiveUDFTimeUSFormat';
create temporary function partner_out_domain as 'com.cplatform.statistics.util.HiveUDFPartnerOut';


#TRUE if string A matches the SQL simple regular expression B, otherwise FALSE. The comparison is done character by character. The _ character in B matches any character in A (similar to . in posix regular expressions), and the % character in B matches an arbitrary number of characters in A (similar to .* in posix regular expressions). For example, 'foobar' LIKE 'foo' evaluates to FALSE where as 'foobar' LIKE 'foo___' evaluates to TRUE and so does 'foobar' LIKE 'foo%'. To escape % use \ (% matches one % character). If the data contains a semi-colon, and you want to search for it, it needs to be escaped, columnValue LIKE 'a\;b'

#LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfasout/20120116/*.log' INTO TABLE s_surfasout PARTITION (dt='20120116');
#FROM s_surfasout t
#INSERT OVERWRITE TABLE m_surfoutproduct PARTITION(dt='20120116',product='助手')
#SELECT t.mobile,surf_domain(t.url,'top'),surf_domain(t.url,'sec'),count(*) WHERE t.dt='20120116' and t.producttype='a' GROUP BY t.mobile,surf_domain(t.url,'top'),surf_domain(t.url,'sec')
#INSERT OVERWRITE TABLE m_surfoutproduct PARTITION(dt='20120116',product='wap导航2')
#SELECT t.mobile,surf_domain(t.url,'top'),surf_domain(t.url,'sec'),count(*) WHERE t.dt='20120116' and t.producttype='w' GROUP BY t.mobile,surf_domain(t.url,'top'),surf_domain(t.url,'sec');
#select t.dt,t.topdomain as top,t.secdomain as sec,sum(t.pv) as pvall,sum(t.uv) as uvall from r_surfoutproduct t where t.dt='20120116' and (t.product='wap导航' or t.product='wap导航2') group by t.dt,t.topdomain,t.secdomain order by pvall desc,top,sec;

#LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfas/hit/20120116/*log' INTO TABLE s_surfasHit PARTITION (dt='20120116');
#INSERT OVERWRITE TABLE m_surfassend PARTITION(dt='20120116',type='pvpush')
#select u.mobile
#from (select v1.mobile
#      from (select t1.mobile FROM s_surfasHit t1 where t1.dt='20120116' and (t1.receiveType='t' or t1.receiveType='w')) v1
#      left SEMI join (select t2.mobile from m_surfassend t2 where t2.dt='20120116' and (t2.type='sms' or t2.type='mm7s')) v2
#      on (v1.mobile=v2.mobile)
#      union all select t3.mobile FROM s_surfasHit t3 where t3.dt='20120116' and (t3.receiveType='t' or t3.receiveType='w') and t3.mobile='') u;
#
#INSERT OVERWRITE TABLE m_surfassend PARTITION(dt='20120116',type='pvmms')
#select u.mobile
#from (select v1.mobile
#      from (select mobile FROM s_surfasHit where dt='20120116' and receiveType!='t' and receiveType!='w') v1
#      left SEMI join (select t2.mobile from m_surfassend t2 where t2.dt='20120116' and (t2.type='sms' or t2.type='mm7s')) v2
#      on (v1.mobile=v2.mobile)
#      union all select mobile FROM s_surfasHit where dt='20120116' and receiveType!='t' and receiveType!='w' and mobile='') u;


#助手活跃用户给热推用，助手日报任务后运行该任务
from m_surfassend
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/forHot/jiangsu'
select DISTINCT mobile where dt >='20120312' and dt <='20120317' and type like 'pv%' and  stats_region(mobile,'province')='江苏';

LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/apache/20120116/*.log' INTO TABLE s_apache PARTITION (dt='20120116');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfasout/20120116/*.log' INTO TABLE s_surfasHit2 PARTITION (dt='20120116');
#冲浪来源统计、分域名冲浪访问统计=========================================================================
FROM s_apache t
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='导航条')
SELECT surf_navigation(t.url),t.mobile,count(*) WHERE t.dt='20120116' and (t.url like '/assistant.do?sid=30002%' or t.url like '/bookmark.do?method=preAdd&sid=30003&u=%' or t.url like '/share/shareImage.do?method=preShareText&sid=30004&share\_url=%' or t.url like '/?sid=30005%' or t.url like '/tools/bookmark\_load.jsp?sid=30006%') GROUP BY surf_navigation(t.url),t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='书签')
SELECT null,t.mobile,count(*) WHERE t.dt='20120116' and t.url like '/?adid=%' GROUP BY t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='浏览器')
SELECT null,t.mobile,count(*) WHERE t.dt='20120116' and t.ua like '%SurfBrowser%' GROUP BY t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='助手')
SELECT null,t.mobile,count(*) WHERE t.dt='20120116' and t.url RLIKE  '^/([cdptw]|n[cdptw])/.*$' GROUP BY t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='热推')
SELECT null,t.mobile,count(*) WHERE t.dt='20120116' and t.url like '/ta/%' GROUP BY t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='爱分享')
SELECT surf_isharepartner(t.url),t.mobile,count(*) WHERE t.dt='20120116' and t.url like '/ishare.do%' GROUP BY surf_isharepartner(t.url),t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='助手插件')
SELECT surf_assistantpartner(t.url),t.mobile,count(*) WHERE t.dt='20120116' and t.url like '/sub.do%' GROUP BY surf_assistantpartner(t.url),t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='合作网站')
SELECT surf_cooperation(t.url),t.mobile,count(*) WHERE t.dt='20120116' and t.url like '/co/surf.jsp?adid=%' GROUP BY surf_cooperation(t.url),t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='书签下载页面')
SELECT surf_bookmarkdownpage(t.url),t.mobile,count(*) WHERE t.dt='20120116' and t.url like '/tools/bookmark\_load.jsp?adid=%' GROUP BY surf_bookmarkdownpage(t.url),t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='浏览器下载页面')
SELECT surf_browserdownpage(t.url),t.mobile,count(*) WHERE t.dt='20120116' and t.url like '/tools/browser.jsp?adid=%' GROUP BY surf_browserdownpage(t.url),t.mobile
INSERT OVERWRITE TABLE m_surfinproduct PARTITION(dt='20120116',product='浏览器下载链接')
SELECT surf_browserpackagedown(t.url),t.mobile,count(*) WHERE t.dt='20120116' and t.url like '/msb\_server/download/%.apk%' GROUP BY surf_browserpackagedown(t.url),t.mobile
INSERT OVERWRITE TABLE m_surfoutproduct PARTITION(dt='20120116',product='wap导航')
SELECT t.mobile,surf_domain(t.url,'top'),surf_domain(t.url,'sec'),count(*) WHERE t.dt='20120116' and (t.url like '/awstats.do%g3url=%' or t.url like '/a.do%p=p%' or t.url like '/awstatsNew.do%g3url=%') and surf_domain(t.url,'top')!='空域名' GROUP BY t.mobile,surf_domain(t.url,'top'),surf_domain(t.url,'sec')
;

FROM m_surfinproduct t
INSERT OVERWRITE TABLE r_surfinproduct PARTITION(dt='20120116')
SELECT stats_region(t.mobile,'province'),t.partner,t.product,sum(t.pv),count(DISTINCT t.mobile)
WHERE t.dt='20120116'
GROUP BY stats_region(t.mobile,'province'),t.partner,t.product;

FROM s_surfasHit2 t
INSERT OVERWRITE TABLE m_surfoutproduct PARTITION(dt='20120116',product='助手')
SELECT t.mobile,surf_domain(t.url,'top'),surf_domain(t.url,'sec'),count(*) WHERE t.dt='20120116' and surf_domain(t.url,'top')!='空域名' GROUP BY t.mobile,surf_domain(t.url,'top'),surf_domain(t.url,'sec');

SELECT dt,topdomain,secdomain,sum(t.pv),count(DISTINCT t.mobile) FROM m_surfoutproduct
WHERE dt='20120116' and product='助手' GROUP BY dt,topdomain,secdomain order by pvall desc,top,sec;
SELECT dt,topdomain,secdomain,sum(t.pv),count(DISTINCT t.mobile) FROM m_surfoutproduct
WHERE dt='20120116' and product='wap导航' GROUP BY dt,topdomain,secdomain order by pvall desc,top,sec;


#冲浪助手运营数据=====================================================================================
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfas/msgcreate/20120116/*.log' INTO TABLE s_surfasmsgcreat PARTITION (dt='20120116');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfas/sms2/20120116/*.log' INTO TABLE s_surfassms2 PARTITION (dt='20120116');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfas/sms3/20120116/*.log' INTO TABLE s_surfassms3 PARTITION (dt='20120116');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfas/mms7mt/20120116/*mt' INTO TABLE s_surfasmm7 PARTITION (dt='20120116');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfas/mms7mtbatch/20120116/*mt' INTO TABLE s_surfasmm7batch PARTITION (dt='20120116');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfas/mms7report/20120116/*report' INTO TABLE s_surfasmm7rp PARTITION (dt='20120116');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfas/user/20120116/*txt' INTO TABLE s_surfasuser PARTITION (dt='20120116');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfas/user/M201112/*txt' INTO TABLE s_surfasuser PARTITION (dt='M201112');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/surfasout/20120116/*.log' INTO TABLE s_surfasHit2 PARTITION (dt='20120116');

INSERT OVERWRITE TABLE m_surfassend PARTITION(dt='20120116',type='sms')
select DISTINCT v1.mobile
FROM (select t1.taskid,t1.mobile from s_surfassms2 t1 where t1.dt='20120116' union all select t2.taskid,t2.mobile from s_surfassms3 t2 where t2.dt='20120116') v1
left semi join (select t3.taskid from s_surfasmsgcreat t3 where t3.dt='20120116' and (t3.tasktype='S' or t3.tasktype='W')) v2
on (v1.taskid=v2.taskid);

INSERT OVERWRITE TABLE m_surfassend PARTITION(dt='20120116',type='mm7s')
select DISTINCT v1.mobile
from (select taskid,mobile FROM s_surfasmm7 where dt='20120116'
      union all
      select taskid,mobiles[0] as mobile FROM s_surfasmm7batch where dt='20120116'
      union all
      select taskid,mobiles[1] as mobile FROM s_surfasmm7batch where dt='20120116' and size(mobiles)>1
      union all
      select taskid,mobiles[2] as mobile FROM s_surfasmm7batch where dt='20120116' and size(mobiles)>2
      union all
      select taskid,mobiles[3] as mobile FROM s_surfasmm7batch where dt='20120116' and size(mobiles)>3
      union all
      select taskid,mobiles[4] as mobile FROM s_surfasmm7batch where dt='20120116' and size(mobiles)>4
      union all
      select taskid,mobiles[5] as mobile FROM s_surfasmm7batch where dt='20120116' and size(mobiles)>5
      union all
      select taskid,mobiles[6] as mobile FROM s_surfasmm7batch where dt='20120116' and size(mobiles)>6
      union all
      select taskid,mobiles[7] as mobile FROM s_surfasmm7batch where dt='20120116' and size(mobiles)>7
      union all
      select taskid,mobiles[8] as mobile FROM s_surfasmm7batch where dt='20120116' and size(mobiles)>8
      union all
      select taskid,mobiles[9] as mobile FROM s_surfasmm7batch where dt='20120116' and size(mobiles)>9) v1
left semi join (select t2.taskid from s_surfasmsgcreat t2 where t2.dt='20120116' and (t2.tasktype='PM' or t2.tasktype='DM')) v2
on (v1.taskid=v2.taskid);

INSERT OVERWRITE TABLE m_surfassend PARTITION(dt='20120116',type='mm7rp')
select DISTINCT v3.mobile
from (select serial,mobile FROM s_surfasmm7rp where dt='20120116' and (status='1000' or status='2000' or status='2001' or status='4446')) v3
left semi join (select serial
                from (select taskid,serial from s_surfasmm7 where dt='20120116'
                      union all
                      select taskid,serial from s_surfasmm7batch where dt='20120116') v1
                left semi join (select taskid from s_surfasmsgcreat where dt='20120116' and (tasktype='PM' or tasktype='DM')) v2
                on (v1.taskid=v2.taskid)) v4
on (v3.serial=v4.serial);

INSERT OVERWRITE TABLE m_surfassend PARTITION(dt='20120116',type='pvpush')
select v1.mobile
from (select t1.mobile FROM s_surfasHit2 t1 where t1.dt='20120116' and t1.functype !='ta' and t1.orgin !='3')) v1
left SEMI join (select t2.mobile from m_surfassend t2 where t2.dt='20120116' and t2.type='sms') v2
on (v1.mobile=v2.mobile)

INSERT OVERWRITE TABLE m_surfassend PARTITION(dt='20120116',type='pvmms')
select v1.mobile
from (select mobile FROM s_surfasHit2 where dt='20120116' and orgin !='3' functype !='ta') v1
left SEMI join (select t2.mobile from m_surfassend t2 where t2.dt='20120116' and t2.type='mm7s') v2
on (v1.mobile=v2.mobile)

INSERT OVERWRITE TABLE m_surfasaccess PARTITION(dt='20120116')
select v1.province,v1.city,v1.mmsuser,v1.pushuser,v1.totaluser,v1.todayadduser,v1.todayremoveuser,v1.monthadduser,v6.mmssend,v2.mmsreceive,v3.mmspv,v4.pushsend,v5.pushpv,v3.mmsuv,v5.pushuv
from (select * from s_surfasuser m where m.dt='20120116') v1
left OUTER join (select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(DISTINCT m.mobile) as mmssend from m_surfassend m where m.dt='20120116' and m.type='mm7s' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city')) v6
on (v1.province=v6.province and v1.city=v6.city)
left OUTER join (select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(DISTINCT m.mobile) as mmsreceive from m_surfassend m where m.dt='20120116' and m.type='mm7rp' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city')) v2
on (v1.province=v2.province and v1.city=v2.city)
left OUTER join (select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(DISTINCT m.mobile) as pushsend from m_surfassend m where m.dt='20120116' and m.type='sms' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city')) v4
on (v1.province=v4.province and v1.city=v4.city)
left OUTER join (select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(m.mobile) as mmspv,count(DISTINCT m.mobile) as mmsuv from m_surfassend m where m.dt='20120116' and m.type='pvmms' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city')) v3
on (v1.province=v3.province and v1.city=v3.city)
left OUTER join (select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(m.mobile) as pushpv,count(DISTINCT m.mobile) as pushuv from m_surfassend m where m.dt='20120116' and m.type='pvpush' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city')) v5
on (v1.province=v5.province and v1.city=v5.city)
;

INSERT OVERWRITE TABLE r_surfasaccess PARTITION(dt='20120116')
select t.province,sum(t.mmsuser),sum(t.pushuser),sum(t.totaluser),sum(t.todayadduser),sum(t.todayremoveuser),sum(t.monthadduser),sum(t.mmssend),sum(t.mmsreceive),stats_percent(sum(t.mmsreceive)/sum(t.mmssend)),sum(t.mmspv),sum(t.pushsend),sum(t.pushpv),sum(t.mmsuv),sum(t.pushuv),stats_percent(sum(t.mmsuv)/sum(t.mmsreceive)),stats_percent(sum(t.pushuv)/sum(t.pushsend))
from m_surfasaccess t where t.dt='20120116' group by t.province
;

INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/r_surfasaccess'
select * from r_surfasaccess t where t.dt='20120116' order by t.mmsuser desc;
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/r_surfasaccess_js'
select t.province,t.city,t.mmsuser,t.pushuser,t.totaluser,t.todayadduser,t.todayremoveuser,t.monthadduser,t.mmssend,t.mmsreceive,stats_percent(t.mmsreceive/t.mmssend),t.mmspv,t.pushsend,t.pushpv,t.mmsuv,t.pushuv,stats_percent(t.mmsuv/t.mmsreceive),stats_percent(t.pushuv/t.pushsend) from m_surfasaccess t where t.dt='20120116' and t.province='江苏' order by t.mmsuser desc;

#month report
INSERT OVERWRITE TABLE m_surfasAccessMonth PARTITION(dt='201112')
select v1.province,v1.city,v1.mmsuser,v1.pushuser,v1.totaluser,v1.todayadduser,v1.todayremoveuser,v1.monthadduser,v2.tmmssend,v2.tmmsreceive,v3.mmsreceiveUser,v2.tmmspv,v2.tpushsend,v4.pushsendUser,v2.tpushpv,v5.mmsuv,v6.pushuv
(select * from s_surfasuser where dt='M201112') v1
left OUTER join (select province,city,sum(mmssend) as tmmssend,sum(mmsreceive) as tmmsreceive,sum(mmspv) as tmmspv,sum(pushsend) as tpushsend,sum(pushpv) as tpushpv
from m_surfasaccess where dt like '201112%' group by province,city) v2
on (v1.province=v2.province and v1.city=v2.city)
left OUTER join (select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(DISTINCT m.mobile) as mmsreceiveUser from m_surfassend m where m.dt like '201112%' and m.type='mm7rp' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city')) v3
on (v1.province=v3.province and v1.city=v3.city)
left OUTER join (select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(DISTINCT m.mobile) as pushsendUser from m_surfassend m where m.dt like '201112%' and m.type='sms' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city')) v4
on (v1.province=v4.province and v1.city=v4.city)
left OUTER join (select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(m.mobile) as mmspv,count(DISTINCT m.mobile) as mmsuv from m_surfassend m where m.dt like '201112%' and m.type='pvmms' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city')) v5
on (v1.province=v5.province and v1.city=v5.city)
left OUTER join (select stats_region(m.mobile,'province') as province,stats_region(m.mobile,'city') as city,count(m.mobile) as pushpv,count(DISTINCT m.mobile) as pushuv from m_surfassend m where m.dt like '201112%' and m.type='pvpush' group by stats_region(m.mobile,'province'),stats_region(m.mobile,'city')) v6
on (v1.province=v6.province and v1.city=v6.city)
;
INSERT OVERWRITE TABLE r_surfasAccessMonth PARTITION(dt='201112')
select t.province,sum(t.mmsuser),sum(t.pushuser),sum(t.totaluser),sum(t.todayadduser),sum(t.todayremoveuser),sum(t.monthadduser),sum(t.mmssend),sum(t.mmsreceive),sum(t.mmsreceiveUser),stats_percent(sum(t.mmsreceive)/sum(t.mmssend)),sum(t.mmspv),sum(t.pushsend),sum(t.pushsendUser),sum(t.pushpv),sum(t.mmsuv),sum(t.pushuv),stats_percent(sum(t.mmsuv)/sum(t.mmsreceiveUser)),stats_percent(sum(t.pushuv)/sum(t.pushsendUser))
from m_surfasAccessMonth t where t.dt='201112' group by t.province
;


#ishare报表=============================================================================================
#LOAD DATA LOCAL INPATH '/home/hadoop/hadoop-hadoop/local/stats/share/mobile.txt' INTO TABLE m_ishareMobile PARTITION (dt='total',type='all');
#LOAD DATA LOCAL INPATH '/home/hadoop/hadoop-hadoop/local/stats/share/send_mobile.txt' INTO TABLE m_ishareMobile PARTITION (dt='total',type='send');
#LOAD DATA LOCAL INPATH '/home/hadoop/hadoop-hadoop/local/stats/share/recv_mobile.txt' INTO TABLE m_ishareMobile PARTITION (dt='total',type='receive');
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/ishare/20120115/*log' INTO TABLE s_ishare PARTITION (dt='20120115');

from s_ishare
INSERT OVERWRITE TABLE m_ishareMobile PARTITION(dt='20120115',type='send')
select DISTINCT sMobile where dt='20120115' and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154'
INSERT OVERWRITE TABLE m_ishareMobile PARTITION(dt='20120115',type='receive')
select DISTINCT rMobile where dt='20120115' and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154'
;
INSERT OVERWRITE TABLE m_ishareMobile PARTITION(dt='20120115',type='all')
select DISTINCT mobile from m_ishareMobile where dt='20120115' and (type='send' or type='receive')
;

INSERT OVERWRITE TABLE m_ishareMobile PARTITION (dt='total',type='all')
select DISTINCT mobile from
(select mobile from m_ishareMobile where dt='20120115' and type='all'
union all select mobile from m_ishareMobile where dt='total' and type='all') u
;
INSERT OVERWRITE TABLE m_ishareMobile PARTITION (dt='total',type='send')
select DISTINCT mobile from
(select mobile from m_ishareMobile where dt='20120115' and type='send'
union all select mobile from m_ishareMobile where dt='total' and type='send') u
;
INSERT OVERWRITE TABLE m_ishareMobile PARTITION (dt='total',type='receive')
select DISTINCT mobile from
(select mobile from m_ishareMobile where dt='20120115' and type='receive'
union all select mobile from m_ishareMobile where dt='total' and type='receive') u
;

INSERT OVERWRITE TABLE m_ishare PARTITION (dt='20120115')
select v1.province,v1.city,v1.sharecount,v2.shareHit,v3.shareSelfCount,v4.shareSelfHit from
(select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as shareCount from s_ishare where dt='20120115' and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154' group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v1
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as shareHit from s_ishare where dt='20120115' and success>0 and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154' group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v2
on (v1.province=v2.province and v1.city=v2.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as shareSelfCount from s_ishare where dt='20120115' and sMobile=rMobile group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v3
on (v1.province=v3.province and v1.city=v3.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as shareSelfHit from s_ishare where dt='20120115' and sMobile=rMobile and success>0 group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v4
on (v1.province=v4.province and v1.city=v4.city)
;

INSERT OVERWRITE TABLE r_ishare PARTITION (dt='20120115')
select v1.province,v1.city,v1.totalUser,v2.totalSendUser,v3.totalReceiveUser,v4.sendUser,v5.receiveUser,stats_percent(v4.sendUser/v2.totalSendUser),v6.sharecount,v6.shareHit,stats_percent(v6.shareHit/v6.sharecount),v7.shareHitUser,stats_numformat(v7.shareHitUser/ v5.receiveUser),v6.shareSelfCount,stats_percent(v6.shareSelfHit/v6.shareSelfCount),stats_numformat(v6.sharecount/v4.sendUser),stats_numformat(v5.receiveUser/v4.sendUser),stats_numformat(v6.sharecount/v5.receiveUser),v1.totalUser-v8.totalUser,v2.totalSendUser-v8.totalSendUser,v3.totalReceiveUser-v8.totalReceiveUser,v9.mmsCount,v10.smsCount
from (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as totalUser from m_ishareMobile where dt='total' and type='all' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v1
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as totalSendUser from m_ishareMobile where dt='total' and type='send' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v2
on (v1.province=v2.province and v1.city=v2.city)
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as totalReceiveUser from m_ishareMobile where dt='total' and type='receive' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v3
on (v1.province=v3.province and v1.city=v3.city)
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as sendUser from m_ishareMobile where dt='20120115' and type='send' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v4
on (v1.province=v4.province and v1.city=v4.city)
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(mobile) as receiveUser from m_ishareMobile where dt='20120115' and type='receive' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v5
on (v1.province=v5.province and v1.city=v5.city)
left OUTER join (select province,city,sharecount,shareHit,shareSelfCount,shareSelfHit from m_ishare where dt='20120115') v6
on (v1.province=v6.province and v1.city=v6.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(DISTINCT rMobile) as shareHitUser from s_ishare where dt='20120115' and success>0 and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154' group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v7
on (v1.province=v7.province and v1.city=v7.city)
left OUTER join (select province,city,totalUser,totalSendUser,totalReceiveUser from r_ishare where dt='20120114') v8
on (v1.province=v8.province and v1.city=v8.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as mmsCount from s_ishare where dt='20120115' and (shareType='1' or shareType='2') and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154' group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v9
on (v1.province=v9.province and v1.city=v9.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(*) as smsCount from s_ishare where dt='20120115' and (shareType='0' or shareType='6') and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154' group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v10
on (v1.province=v10.province and v1.city=v10.city)
;

INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/tmp/r_ishare20120115'
select * from r_ishare where dt='20120115' order by province,city;

#month report
INTO OVERWRITE TABLE r_ishare PARTITION (dt='M201201')
select v1.province,v1.city,v1.totalUser,v1.totalSendUser,v1.totalReceiveUser,v2.sendUser,v3.receiveUser,stats_percent(v2.sendUser/v1.totalSendUser),v4.sharecount,v4.shareHit,stats_percent(v4.shareHit/v4.sharecount),v5.shareHitUser,v5.shareHitUser/ v3.receiveUser,v4.shareSelfCount,stats_percent(v4.shareSelfHit/v4.shareSelfCount),v4.sharecount/v2.sendUser,v3.receiveUser/v2.sendUser,v4.sharecount/v3.receiveUser,v1.totalUser-v6.totalUser,v1.totalSendUser-v6.totalSendUser,v1.totalReceiveUser-v6.totalReceiveUser,0,0
from (select province,city,totalUser,totalSendUser,totalReceiveUser from r_ishare where dt='20120131') v1
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(DISTINCT mobile) as sendUser from m_ishareMobile where dt like '201201%' and type='send' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v2
on (v1.province=v2.province and v1.city=v2.city)
left OUTER join (select stats_region(mobile,'province') as province,stats_region(mobile,'city') as city,count(DISTINCT mobile) as receiveUser from m_ishareMobile where dt like '201201%' and type='receive' group by stats_region(mobile,'province'),stats_region(mobile,'city')) v3
on (v1.province=v3.province and v1.city=v3.city)
left OUTER join (select province,city,sum(sharecount) as sharecount,sum(shareHit) as shareHit,sum(shareSelfCount) as shareSelfCount,sum(shareSelfHit) as shareSelfHit from m_ishare where dt like '201201%' group by province,city) v4
on (v1.province=v4.province and v1.city=v4.city)
left OUTER join (select stats_region(sMobile,'province') as province,stats_region(sMobile,'city') as city,count(DISTINCT rMobile) as shareHitUser from s_ishare where dt like '201201%' and success>0 and sMobile !='13585442484' and sMobile !='13961494194' and sMobile !='13961494154' group by stats_region(sMobile,'province'),stats_region(sMobile,'city')) v5
on (v1.province=v5.province and v1.city=v5.city)
left OUTER join (select province,city,totalUser,totalSendUser,totalReceiveUser from r_ishare where dt='20111231') v6
on (v1.province=v6.province and v1.city=v6.city)
;


#网址导航部分报表=============================================================================================
LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/navigation/20120117/*.log' INTO TABLE s_urlnavigation PARTITION (dt='20120117');

from s_urlnavigation
INSERT OVERWRITE TABLE r_urlNavigationHit PARTITION(dt='20120117',type='all')
select category,secondcategory,sitename,url,count(DISTINCT mobile),count(*) as pv where dt='20120117' and type='out' group by category,secondcategory,sitename,url order by pv desc
INSERT OVERWRITE TABLE r_urlNavigationHit PARTITION(dt='20120117',type='normal')
select category,secondcategory,sitename,url,count(DISTINCT mobile),count(*) as pv where dt='20120117' and type='out' and version='0' group by category,secondcategory,sitename,url order by pv desc
INSERT OVERWRITE TABLE r_urlNavigationHit PARTITION(dt='20120117',type='show')
select category,secondcategory,sitename,url,count(DISTINCT mobile),count(*) as pv where dt='20120117' and type='out' and version='1' group by category,secondcategory,sitename,url order by pv desc
INSERT OVERWRITE TABLE r_urlNavigationHit PARTITION(dt='20120117',type='color')
select category,secondcategory,sitename,url,count(DISTINCT mobile),count(*) as pv where dt='20120117' and type='out' and version='2' group by category,secondcategory,sitename,url order by pv desc
INSERT OVERWRITE TABLE r_urlNavigationHit PARTITION(dt='20120117',type='sectionAll')
select category,secondcategory,null,null,count(DISTINCT mobile),count(*) as pv where dt='20120117' and (type='out' or type='into') group by category,secondcategory order by pv desc
INSERT OVERWRITE TABLE r_urlNavigationHit PARTITION(dt='20120117',type='sectionNormal')
select category,secondcategory,null,null,count(DISTINCT mobile),count(*) as pv where dt='20120117' and (type='out' or type='into') and version='0' group by category,secondcategory order by pv desc
INSERT OVERWRITE TABLE r_urlNavigationHit PARTITION(dt='20120117',type='sectionShow')
select category,secondcategory,null,null,count(DISTINCT mobile),count(*) as pv where dt='20120117' and (type='out' or type='into') and version='1' group by category,secondcategory order by pv desc
INSERT OVERWRITE TABLE r_urlNavigationHit PARTITION(dt='20120117',type='sectionColor')
select category,secondcategory,null,null,count(DISTINCT mobile),count(*) as pv where dt='20120117' and (type='out' or type='into') and version='2' group by category,secondcategory order by pv desc
;

INSERT OVERWRITE TABLE r_urlNavigationTimeHit PARTITION(dt='20120117',type='all')
select v1.timeInterval,v1.inpv,v1.inuv,v2.outpv,v2.outuv from
(select stats_timeInterval(createtime) as timeInterval,count(*) as inpv,count(DISTINCT mobile) as inuv from s_urlnavigation where dt='20120117' and (type='in' or type='into') group by stats_timeInterval(createtime)) v1
left OUTER join (select stats_timeInterval(createtime) as timeInterval,count(*) as outpv,count(DISTINCT mobile) as outuv from s_urlnavigation where dt='20120117' and type='out' group by stats_timeInterval(createtime)) v2
on (v1.timeInterval=v2.timeInterval)
order by timeInterval
;
INSERT OVERWRITE TABLE r_urlNavigationTimeHit PARTITION(dt='20120117',type='normal')
select v1.timeInterval,v1.inpv,v1.inuv,v2.outpv,v2.outuv from
(select stats_timeInterval(createtime) as timeInterval,count(*) as inpv,count(DISTINCT mobile) as inuv from s_urlnavigation where dt='20120117' and (type='in' or type='into') and version='0' group by stats_timeInterval(createtime)) v1
left OUTER join (select stats_timeInterval(createtime) as timeInterval,count(*) as outpv,count(DISTINCT mobile) as outuv from s_urlnavigation where dt='20120117' and type='out' and version='0' group by stats_timeInterval(createtime)) v2
on (v1.timeInterval=v2.timeInterval)
order by timeInterval
;
INSERT OVERWRITE TABLE r_urlNavigationTimeHit PARTITION(dt='20120117',type='show')
select v1.timeInterval,v1.inpv,v1.inuv,v2.outpv,v2.outuv from
(select stats_timeInterval(createtime) as timeInterval,count(*) as inpv,count(DISTINCT mobile) as inuv from s_urlnavigation where dt='20120117' and (type='in' or type='into') and version='1' group by stats_timeInterval(createtime)) v1
left OUTER join (select stats_timeInterval(createtime) as timeInterval,count(*) as outpv,count(DISTINCT mobile) as outuv from s_urlnavigation where dt='20120117' and type='out' and version='1' group by stats_timeInterval(createtime)) v2
on (v1.timeInterval=v2.timeInterval)
order by timeInterval
;
INSERT OVERWRITE TABLE r_urlNavigationTimeHit PARTITION(dt='20120117',type='color')
select v1.timeInterval,v1.inpv,v1.inuv,v2.outpv,v2.outuv from
(select stats_timeInterval(createtime) as timeInterval,count(*) as inpv,count(DISTINCT mobile) as inuv from s_urlnavigation where dt='20120117' and (type='in' or type='into') and version='2' group by stats_timeInterval(createtime)) v1
left OUTER join (select stats_timeInterval(createtime) as timeInterval,count(*) as outpv,count(DISTINCT mobile) as outuv from s_urlnavigation where dt='20120117' and type='out' and version='2' group by stats_timeInterval(createtime)) v2
on (v1.timeInterval=v2.timeInterval)
order by timeInterval
;


#重定向部分报表=============================================================================================
#LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2011/12/25/in/*.log' INTO TABLE s_rdIn PARTITION (dt='20120116');
#LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2011/12/25/out/*.log' INTO TABLE s_rdOut PARTITION (dt='20120116');
#LOAD DATA INPATH '/home/hadoop/hadoop-hadoop/data/stats/redirect/2011/12/25/rc/*.log' INTO TABLE s_rdrecommend PARTITION (dt='20120116');

#FROM s_rdOut t
#INSERT OVERWRITE TABLE m_rdArea PARTITION(dt='20120116')
#SELECT t.wapType,t.mobile,t.areaType,count(*) WHERE t.dt='20120116' GROUP BY t.wapType,t.mobile,t.areaType
#INSERT OVERWRITE TABLE m_rdAreaURL PARTITION(dt='20120116')
#SELECT t.wapType,t.mobile,t.areaType,t.url,t.sectionName,count(*) WHERE t.dt='20120116' GROUP BY t.wapType,t.mobile,t.areaType,t.url,t.sectionName;
#
#FROM m_rdArea t
#INSERT OVERWRITE TABLE r_rdArea PARTITION(dt='20120116')
#SELECT t.wapType,stats_region(t.mobile,'province'),stats_region(t.mobile,'city'),rd_area(t.areaType),sum(t.pv),count(*)
#WHERE t.dt='20120116'
#GROUP BY t.wapType,stats_region(t.mobile,'province'),stats_region(t.mobile,'city'),rd_area(t.areaType);
#
#FROM m_rdAreaurl t
#INSERT OVERWRITE TABLE r_rdAreaurl PARTITION(dt='20120116')
#SELECT t.wapType,stats_region(t.mobile,'province'),stats_region(t.mobile,'city'),rd_area(t.areaType),t.url,t.sectionName,sum(t.pv),count(*)
#WHERE t.dt='20120116'
#GROUP BY t.wapType,stats_region(t.mobile,'province'),stats_region(t.mobile,'city'),rd_area(t.areaType),t.url,t.sectionName;
#
#
#INSERT OVERWRITE TABLE m_rderror PARTITION(dt='20120116')
#select t1.waptype,t1.mobile,t1.errorcode,t1.errorUrl,t2.mobile
#from s_rdin t1 left OUTER join s_rdout t2 on (t1.uuid=t2.uuid AND t1.dt='20120116' AND t2.dt='20120116');
#
#INSERT OVERWRITE TABLE r_rderror PARTITION(dt='20120116')
#select v1.waptype,v1.province,v1.errorcode,v2.inpv,v2.inuv,v1.outpv,v1.outuv,v1.outpv/v2.inpv,v1.outuv/v2.inuv
#from (select m.waptype,stats_region(m.mobile,'province') as province,m.errorcode,count(m.outmobile) as outpv,count(DISTINCT m.outmobile) as outuv from m_rderror m where m.dt='20120116' group by m.waptype,stats_region(m.mobile,'province'),m.errorcode) v1
#join (select t1.waptype,stats_region(t1.mobile,'province') as province,t1.errorcode,count(*) as inpv,count(DISTINCT t1.mobile) as inuv from s_rdin t1 where t1.dt='20120116' group by t1.waptype,stats_region(t1.mobile,'province'),t1.errorcode) v2
#on (v1.waptype=v2.waptype and v1.province=v2.province and v1.errorcode=v2.errorcode);
#
#
#INSERT OVERWRITE TABLE m_rderror735 PARTITION(dt='20120116')
#select t1.waptype,t1.mobile,t1.errorUrl,t1.rcurl,t2.mobile
#from s_rdrecommend t1 left OUTER join s_rdout t2 on (t1.uuid=t2.uuid AND t1.dt='20120116' AND t2.dt='20120116');
#
#INSERT OVERWRITE TABLE r_rderror735 PARTITION(dt='20120116')
#select v1.waptype,v1.province,v1.edomain,v1.rcdomain,v2.inpv,v2.inuv,v1.outpv,v1.outuv,v1.outpv/v2.inpv
#from (select m.waptype,stats_region(m.mobile,'province') as province,stats_domain(m.errordomain) as edomain,m.rcdomain,count(m.outmobile) as outpv,count(DISTINCT m.outmobile) as outuv from m_rderror735 m where m.dt='20120116' group by m.waptype,stats_region(m.mobile,'province'),stats_domain(m.errorcode),m.rcdomain) v1
#join (select t1.waptype,stats_region(t1.mobile,'province') as province,stats_domain(t1.errorUrl) as edomain,t1.rcurl,count(*) as inpv,count(DISTINCT t1.mobile) as inuv from s_rdrecommend t1 where t1.dt='20120116' group by t1.waptype,stats_region(t1.mobile,'province'),stats_domain(t1.errorUrl),t1.rcurl) v2
#on (v1.waptype=v2.waptype and v1.province=v2.province and v1.edomain=v2.edomain and v1.rcdomain=v2.rcurl);
#
#
#INSERT OVERWRITE TABLE r_rderrordomain PARTITION(dt='20120116')
#select v1.waptype,v1.province,v1.edomain,v2.inpv,v2.inuv,v2.inpv/v2.inuv,v1.outpv,v1.outuv
#from (select m.waptype,stats_region(m.mobile,'province') as province,stats_domain(m.errordomain) as edomain,count(m.outmobile) as outpv,count(DISTINCT m.outmobile) as outuv from m_rderror m where m.dt='20120116' group by m.waptype,stats_region(m.mobile,'province'),stats_domain(m.errorcode)) v1
#join (select t1.waptype,stats_region(t1.mobile,'province') as province,stats_domain(t1.errorUrl) as edomain,count(*) as inpv,count(DISTINCT t1.mobile) as inuv from s_rdin t1 where t1.dt='20120116' group by t1.waptype,stats_region(t1.mobile,'province'),stats_domain(t1.errorUrl)) v2
#on (v1.waptype=v2.waptype and v1.province=v2.province and v1.edomain=v2.edomain);
