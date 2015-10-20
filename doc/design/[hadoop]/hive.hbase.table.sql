#hbase=================================--------------------------------------------=
#hbase(main):019:0> create ‘sunwg02′, { NAME => ‘f1′, COMPRESSION => ‘GZ’}   create ‘sunwg01′,{NAME => ‘f1′,TTL => ’10′}   create 't1', {NAME => 'f1', VERSIONS => 5}
#alter 'hbase_m_ashitnews_pro', METHOD => 'table_att','coprocessor'=>'hdfs://jobtracker:3001/jar/hbase-coprocessor-1.0.0.jar|com.foo.FooRegionObserver|1001|arg1=1,arg2=2'
#Priority: An integer. The framework will determine the execution sequence of all configured observers registered at the same hook using priorities. This field can be left blank. In that case the framework will assign a default priority value.
#Arguments: This field is passed to the coprocessor implementation.

#hive建立的hbase关联表数值型的字段还是存储的是字符串，不能用hbase的工具类按数值转换，hive写，hbase用string读
#hbase写入的数值是指定的字节数，hive读不出来，是NULL，若hive要用，则应该都设计为String型
#可以考虑将column设计到rowkey的方法解决。例如原来的rowkey是uid1,，column是uid2，uid3...。重新设计之后rowkey为<uid1>~<uid2>，<uid1>~<uid3>...这种方式如何查询，如果要查询uid1下面的所有uid怎么办。这里说明一下hbase并不是只有get一种随机读取的方法。而是含有scan(startkey,endkey)的扫描方法，需要取得uid1下的记录只需要new Scan("uid1~","uid1~~")即可。
#注意，其中InMemory队列用于保存HBase meta表的元数据信息，因此如果将数据量很大的用户表设置为InMemory的话，可能会导致meta表访问时缓存失效，进而对整个集群的性能产生影响。
#version为0就没有记录了

#hive--------------------------------------------------------------------
#describe extended  tb1;返回表tb1字段，存储格式类型，位置，修改时间等等关于表的详细信息
#show functions;显示可以用的函数列表，包括可用的udf函数。
#describe function length; 返回length函数的说明，执行输出length(str) - Returns the length of str
#hive --hiveconf  hive.root.logger=DEBUG,console 设置进入本次session中的参数值,这里设置调试信息发送到控制台
#set hive.groupby.skewindata=true      在执行某条可能会出现数据倾斜的HQL前设置，会分两个阶段来执行HQL解决数据倾斜。
#explain HQL                可以查看HQL的查询计划
#
#SHOW PARTITIONS page_view;
#SHOW TABLES 'page.*';
#DESCRIBE EXTENDED page_view PARTITION (ds='2008-08-08');
#ALTER TABLE tab1 ADD COLUMNS (c1 INT COMMENT 'a new int column', c2 STRING DEFAULT 'def val');
#
#对于数据量比较大的排重select count(sid) from tb1 group by sid;会比select count(distinct sid) from tb1更有效。
#hive0.6.0以后支持create datebase dbname,use dbname,drop database dbname来进行分库操作
#load数据是一个移动操作，加上local关键字，hive会把本地文件系统的数据复制到hive仓库目录，在同一个文件系统中就会变成复制
#查看rcfile格式存储的文件内容
#hive -rcfilecat   /user/hive/warehouse/tb1/dt=20120325/hour=15/000000_0
#顺便说下hadoop查看顺序文件内容，可以使压缩文件，例如
#hadoop fs -text /user/hive/warehouse/tb1/dt=20120317/20120317.lzo


bin/hbase-daemon.sh restart regionserver
/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash /jar/hbase-coprocessor-1.0.0.jar;
/home/hadoop/hadoop-1.0.4/bin/hadoop fs -put /home/hadoop/app/hbase-coprocessor-1.0.0.jar /jar/hbase-coprocessor-1.0.0.jar;

#key=time+id+id+province+mobile,date,pv                    key加date更好删除？一天建一个表？
drop table hbase_m_ashitnews_pro;
CREATE TABLE hbase_m_ashitnews_pro(id string,dt string,pv BIGINT)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES (
"hbase.columns.mapping" = ":key,cf:dt,cf:pv"
);
desc hbase_m_ashitnews_pro;
desc extended hbase_m_ashitnews_pro;

list
disable 'hbase_m_ashitnews_pro'
alter 'hbase_m_ashitnews_pro', {NAME => 'cf', VERSIONS => 1}
#alter 'hbase_m_ashitnews_pro', METHOD => 'table_att','coprocessor'=>'hdfs://jobtracker:3001/jar/hbase-coprocessor-1.0.0.jar|com.cpf.surf.util.HbaseAggregationEndpoint|1001|'
#可以加多个，会自动用  coprocessor$ X 区分
alter 'hbase_m_ashitnews_pro', METHOD => 'table_att','coprocessor'=>'hdfs://master1:3001/jar/hbase-coprocessor-1.0.0.jar|com.cpf.surf.util.HbaseAggregationEndpoint|1001|'
enable 'hbase_m_ashitnews_pro'
describe 'hbase_m_ashitnews_pro'
#status 'detailed'     truncate "hbase_m_ashitnews_pro"    count "hbase_m_ashitnews_pro"     scan "hbase_m_ashitnews_pro"
#alter 'hbase_m_ashitnews_pro', METHOD => 'table_att_unset', NAME => 'coprocessor$1'

INSERT into TABLE hbase_m_ashitnews_pro
select concat_ws('@@','0000',columnid,contentid,provinfo,mobile),'20121115',count(1) pv from s_surfasHit_wall where dt='20121115' and hour='00' and minute='00' and columnid is not null and columnid !='null' and contentid is not null and contentid !='null' group by columnid,contentid,mobile,provinfo;
INSERT into TABLE hbase_m_ashitnews_pro
select concat_ws('@@','0015',columnid,contentid,provinfo,mobile),'20121115',count(1) pv from s_surfasHit_wall where dt='20121115' and hour='00' and minute='15' and columnid is not null and columnid !='null' and contentid is not null and contentid !='null' group by columnid,contentid,mobile,provinfo;
INSERT into TABLE hbase_m_ashitnews_pro
select concat_ws('@@','0030',columnid,contentid,provinfo,mobile),'20121115',count(1) pv from s_surfasHit_wall where dt='20121115' and hour='00' and minute='30' and columnid is not null and columnid !='null' and contentid is not null and contentid !='null' group by columnid,contentid,mobile,provinfo;
INSERT into TABLE hbase_m_ashitnews_pro
select concat_ws('@@','0045',columnid,contentid,provinfo,mobile),'20121115',count(1) pv from s_surfasHit_wall where dt='20121115' and hour='00' and minute='45' and columnid is not null and columnid !='null' and contentid is not null and contentid !='null' group by columnid,contentid,mobile,provinfo;
INSERT into TABLE hbase_m_ashitnews_pro
select concat_ws('@@','0100',columnid,contentid,provinfo,mobile),'20121115',count(1) pv from s_surfasHit_wall where dt='20121115' and hour='01' and minute='00' and columnid is not null and columnid !='null' and contentid is not null and contentid !='null' group by columnid,contentid,mobile,provinfo;
INSERT into TABLE hbase_m_ashitnews_pro
select concat_ws('@@','0115',columnid,contentid,provinfo,mobile),'20121115',count(1) pv from s_surfasHit_wall where dt='20121115' and hour='01' and minute='15' and columnid is not null and columnid !='null' and contentid is not null and contentid !='null' group by columnid,contentid,mobile,provinfo;
INSERT into TABLE hbase_m_ashitnews_pro
select concat_ws('@@','0130',columnid,contentid,provinfo,mobile),'20121115',count(1) pv from s_surfasHit_wall where dt='20121115' and hour='01' and minute='30' and columnid is not null and columnid !='null' and contentid is not null and contentid !='null' group by columnid,contentid,mobile,provinfo;
INSERT into TABLE hbase_m_ashitnews_pro
select concat_ws('@@','0145',columnid,contentid,provinfo,mobile),'20121115',count(1) pv from s_surfasHit_wall where dt='20121115' and hour='01' and minute='45' and columnid is not null and columnid !='null' and contentid is not null and contentid !='null' group by columnid,contentid,mobile,provinfo;

#  select id,dt,province,pv from hbase_m_ashitnews_pro limit 100;   select count(1) from hbase_m_ashitnews_pro; select id from hbase_m_ashitnews_pro;
# INSERT OVERWRITE TABLE hbase_m_ashitnews_pro select '1430@@1@@111245@@15199945007','20120927','新疆','1' from r_province;
select count(*) from s_surfasHit_wall where dt='20121115' and hour='00' and columnid='1' and contentid='131450';
select mobile,provinfo from s_surfasHit_wall where dt='20121115' and hour='00' and columnid='1' and contentid='131450';
select count(DISTINCT mobile) from s_surfasHit_wall where dt='20121115' and hour='00' and columnid='1' and contentid='131450';
select * from hbase_m_ashitnews_pro where id like '00__@@1@@131450@@%';
select * from s_surfasHit_wall where dt='20121115' and columnid='990007' and contentid='131492' and provinfo='黑龙江';
select * from hbase_m_ashitnews_pro where id like '00%@@990007@@131492@@黑龙江@@%';


#key=?+id+id+?,date,pv,uv
drop table hbase_r_ashitnews_pro;
CREATE TABLE hbase_r_ashitnews_pro(id string,dt string,pv BIGINT,uv BIGINT)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES (
"hbase.columns.mapping" = ":key,cf:dt,cf:pv,cf:uv"
);

disable 'hbase_r_ashitnews_pro'
alter 'hbase_r_ashitnews_pro', {NAME => 'cf', VERSIONS => 1}
alter 'hbase_r_ashitnews_pro', {NAME => 'cf', IN_MEMORY => true}
enable 'hbase_r_ashitnews_pro'
describe 'hbase_r_ashitnews_pro'
#  truncate "hbase_r_ashitnews_pro"      count "hbase_r_ashitnews_pro"     scan "hbase_r_ashitnews_pro"

desc hbase_r_ashitnews_pro;
select * from hbase_r_ashitnews_pro where id='day@@990007@@131371';
select * from hbase_r_ashitnews_pro where id like '990007@@131492@@%';



#drop table hbase_province;
#CREATE TABLE hbase_province(id int, province string)
#STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
#WITH SERDEPROPERTIES (
#"hbase.columns.mapping" = ":key,cf:province"
#);
#INSERT OVERWRITE TABLE hbase_province select * from r_province;





#INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/hadoop-hadoop/ftpdata/hiveAssistantWall2/'
#select concat_ws('@@',columnid,contentid,'201209270330','9','1',if (t1.province is null or t1.province='null','未知省份',t1.province),cast(t2.id as string),cast(pv as string),cast(uv as string),stats_percent(pv,165684)) from
#(	select v1.columnid,v1.contentid,provinfo province,count(v1.columnid) pv,count(distinct mobile) uv from
#		(select columnid,contentid from m_surfasHit_wall_news where dt='20120927' and time='0330') v1
#		left OUTER join (select columnid,contentid,provinfo,mobile from s_surfasHit_wall where dt='20120927') v2
#		on (v1.columnid=v2.columnid and v1.contentid=v2.contentid)
#	group by v1.columnid,v1.contentid,provinfo
#) t1
#left OUTER join
#(select id,province from r_province) t2
#on (t1.province=t2.province)

#INSERT OVERWRITE TABLE r_province select DISTINCT id,province from t_r_province where id is not null;
#INSERT OVERWRITE TABLE r_province select * from r_province where id is not null;

#分区表不好使
#CREATE TABLE hbase_table_2(key int, value string)
#PARTITIONED BY(dt STRING)
#STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
#WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,cf1:val")
#TBLPROPERTIES ("hbase.table.name" = "xyz");
#INSERT OVERWRITE TABLE hbase_table_2 PARTITION (dt='1') SELECT * FROM r_province WHERE id is not null;
#scan "xyz"
#select * from hbase_table_2;
#select key,value,dt from hbase_table_2;
#INSERT OVERWRITE TABLE hbase_table_2 PARTITION (dt='2') SELECT * FROM r_province WHERE id is not null;
#INSERT into TABLE hbase_table_2 PARTITION (dt='3') SELECT * FROM r_province WHERE id is not null;
#INSERT into TABLE hbase_table_2 PARTITION (dt='4') select '2','china' FROM r_province;

#CREATE TABLE hbase_table_1(key int, value1 string, value2 int, value3 int)
#PARTITIONED BY(dt STRING)
#STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
#WITH SERDEPROPERTIES (
#"hbase.columns.mapping" = ":key,a:b,a:c,d:e"
#);

#disable 'newshit'
#drop 'newshit'
#
#create 'newshit', 'timehit'
#
#exit
