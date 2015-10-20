add jar /home/hadoop/hive-0.7.1/lib/jdom.jar;
add jar /home/hadoop/hive-0.7.1/lib/ojdbc14_g.jar;
add jar /home/hadoop/hive-0.7.1/lib/cplatform.tools.jar;
add jar /home/hadoop/hive-0.7.1/lib/WorkManager.jar;
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




INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/hadoop-hadoop/tmp/zsh/ashit/20120724'
select contentid,createtime,mobile,urltype,uid,orgin,issueid,functype from s_surfashit2 where dt='20120724';
