add jar /home/hadoop/hive-0.7.1/lib/jdom.jar;
add jar /home/hadoop/hive-0.7.1/lib/ojdbc14_g.jar;
add jar /home/hadoop/hive-0.7.1/lib/cplatform.tools.jar;
add jar /home/hadoop/hive-0.7.1/lib/WorkManager.jar;

#describe s_apache;
#drop table t_mobile;

#drop table s_apache;
#drop table s_surfasout;
#drop table s_surfasmsgcreat;
#drop table s_surfassms2;
#drop table s_surfassms3;
#drop table s_surfasmm7;
#drop table s_surfasmm7batch;
#drop table s_surfasmm7rp;
#drop table s_surfasuser;
#drop table s_surfasHit;
#drop table s_surfasHit2;
#drop table s_rdIn;
#drop table s_rdOut;
#drop table s_rdrecommend;
#drop table s_urlnavigation;
#drop table s_ishare;
#drop table s_asconf;

#drop table m_surfinproduct;
#drop table m_surfoutproduct;
#drop table m_surfassend;
#drop table m_surfasaccess;
#drop table m_surfasAccessMonth;
#drop table m_rdArea;
#drop table m_rdAreaURL;
#drop table m_rderror;
#drop table m_rderror735;
#drop table m_ishareMobile;
#drop table m_ishare;

#drop table r_surfinproduct;
#drop table r_surfoutproduct;
#drop table r_surfasaccess;
#drop table r_surfasAccessMonth;
#drop table r_rdArea;
#drop table r_rdAreaurl;
#drop table r_rderror;
#drop table r_rderror735;
#drop table r_rderrordomain;
#drop table r_ishare;
#drop table r_urlNavigationHit;

#CREATE TABLE s_surfasout
#(
#  createTime    STRING,
#  mobile        STRING,
#  uid           STRING,
#  url           STRING,
#  producttype   STRING
#)
#PARTITIONED BY(dt STRING);
#CREATE EXTERNAL TABLE s_surfasHit
#(
#  contentId      STRING,
#  createTime     STRING,
#  mobile         STRING,
#  type           STRING,
#  uid            STRING,
#  receiveType    STRING,
#  issueId        STRING,
#  subType        STRING
#)
#PARTITIONED BY(dt STRING)
#ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

CREATE TABLE s_asconf
(
  MOBILE      STRING,
  CREATETIME      STRING,
  SEND_TIME      STRING,
  SEND_TYPE      STRING,
  STATUS      STRING,
  QX_TIME      STRING,
  CUSTOMER_ID      STRING,
  OPR_SRC      STRING,
  BRAND_TYPE      STRING,
  PROV_CONTENT      STRING,
  CITY_CONTENT      STRING,
  BOSS_PROCESS_TIME      STRING,
  SEND_PERIOD      STRING,
  IS_SEND_WEEKLY   STRING
)
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
CREATE TABLE m_asconfuser
(
  province      STRING,
  city          STRING,
  mmsuser       INT,
  pushuser      INT,
  totaluser     INT,
  todayadduser  INT,
  todayremoveuser INT,
  monthadduser  INT
)
PARTITIONED BY(dt STRING);


CREATE TABLE t_mobile
(
  mobile        STRING
)
PARTITIONED BY(type STRING);


CREATE EXTERNAL TABLE s_apache
(
  mobile        STRING,
  createTime    STRING,
  httpmethod    STRING,
  url           STRING,
  httpProtocol  STRING,
  httpcode      STRING,
  httpsize      STRING,
  refurl        STRING,
  ua            STRING,
  ip            STRING
)
PARTITIONED BY(dt STRING)
CLUSTERED BY(mobile) INTO 8 BUCKETS
ROW FORMAT SERDE 'com.cplatform.statistics.util.ApacheSerDe';

CREATE EXTERNAL TABLE s_surfasmsgcreat
(
  tasktype      STRING,
  taskid        STRING
)
PARTITIONED BY(dt STRING)
ROW FORMAT SERDE 'com.cplatform.statistics.util.MsgCreateSerDe';
CREATE EXTERNAL TABLE s_surfassms2
(
  mobile        STRING,
  serial        STRING,
  taskid        STRING,
  status        STRING
)
PARTITIONED BY(dt STRING)
ROW FORMAT SERDE 'com.cplatform.statistics.util.Sms2SerDe';
CREATE EXTERNAL TABLE s_surfassms3
(
  taskid        STRING,
  mobile        STRING
)
PARTITIONED BY(dt STRING)
ROW FORMAT SERDE 'com.cplatform.statistics.util.Sms3SerDe';
CREATE EXTERNAL TABLE s_surfasmm7
(
  taskid        STRING,
  serial        STRING,
  mobile        STRING,
  status        STRING
)
PARTITIONED BY(dt STRING)
ROW FORMAT SERDE 'com.cplatform.statistics.util.Mm7SerDe';
CREATE EXTERNAL TABLE s_surfasmm7batch
(
  taskid        STRING,
  serial        STRING,
  mobiles       array<string>,
  status        STRING
)
PARTITIONED BY(dt STRING)
ROW FORMAT SERDE 'com.cplatform.statistics.util.Mm7BatchSerDe';
CREATE EXTERNAL TABLE s_surfasmm7rp
(
  serial        STRING,
  mobile        STRING,
  status        STRING
)
PARTITIONED BY(dt STRING)
ROW FORMAT SERDE 'com.cplatform.statistics.util.Mm7RpSerDe';
CREATE EXTERNAL TABLE s_surfasuser
(
  province      STRING,
  city          STRING,
  mmsuser       INT,
  pushuser      INT,
  totaluser     INT,
  todayadduser  INT,
  todayremoveuser INT,
  monthadduser  INT
)
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
CREATE EXTERNAL TABLE s_surfasHit2
(
  createTime    STRING,
  mobile        STRING,
  uid           STRING,
  provinfo      STRING,
  cityinfo      STRING,
  urltype       STRING,
  columnid      STRING,
  contentid     STRING,
  columnframe   STRING,
  contentline   STRING,
  orgin         STRING,
  functype      STRING,
  url           STRING
)
PARTITIONED BY(dt STRING);

CREATE EXTERNAL TABLE s_rdIn
(
  createTime    STRING,
  mobile        STRING,
  errorCode     STRING,
  UA            STRING,
  errorUrl      STRING,
  rcUrl         STRING,
  MSIP          STRING,
  network       STRING,
  wapType       STRING,
  testPage      STRING,
  gateway       STRING,
  UUID          STRING
)
PARTITIONED BY(dt STRING)
CLUSTERED BY(UUID) INTO 8 BUCKETS
ROW FORMAT SERDE 'com.cplatform.statistics.util.RD2SerDe';
CREATE EXTERNAL TABLE s_rdOut
(
  createTime    STRING,
  url           STRING,
  mobile        STRING,
  areaType      STRING,
  sectionName   STRING,
  wapType       STRING,
  testPage      STRING,
  gateway       STRING,
  UUID          STRING
)
PARTITIONED BY(dt STRING)
CLUSTERED BY(UUID) INTO 2 BUCKETS
ROW FORMAT SERDE 'com.cplatform.statistics.util.RD2SerDe';
CREATE EXTERNAL TABLE s_rdrecommend
(
  createTime    STRING,
  mobile        STRING,
  errorCode     STRING,
  errorUrl      STRING,
  rcUrl         STRING,
  rcdomaintype  STRING,
  wapType       STRING,
  UUID          STRING
)
PARTITIONED BY(dt STRING)
CLUSTERED BY(UUID) INTO 2 BUCKETS
ROW FORMAT SERDE 'com.cplatform.statistics.util.RD2SerDe';

CREATE EXTERNAL TABLE s_urlnavigation
(
createtime      string,
type    string,
mobile  string,
province        string,
city    string,
version string,
level   string,
sitename        string,
secondcategory  string,
category        string,
pagelevel       string,
categoryname    string,
url     string
)
PARTITIONED BY(dt STRING);

CREATE EXTERNAL TABLE s_ishare
(
  sMobile       STRING,
  rMobile       STRING,
  createTime    STRING,
  updateTim     STRING,
  shareType     STRING,
  success       STRING,
  shareUrl      STRING,
  shareTitle    STRING,
  successCount  INT,
  websiteId     STRING,
  plugType      STRING
)
PARTITIONED BY(dt STRING)
ROW FORMAT SERDE 'com.cplatform.statistics.util.RD2SerDe';



CREATE TABLE m_surfinproduct
(
  partner       STRING,
  mobile        STRING,
  pv            BIGINT
)
PARTITIONED BY(dt STRING,product STRING);
CREATE TABLE m_surfoutproduct
(
  mobile        STRING,
  topdomain     STRING,
  secdomain     STRING,
  pv            BIGINT
)
PARTITIONED BY(dt STRING,product STRING);

CREATE TABLE m_surfassend
(
  mobile        STRING
)
PARTITIONED BY(dt STRING,type STRING)
CLUSTERED BY(mobile) INTO 8 BUCKETS;
CREATE TABLE m_surfasaccess
(
  province      STRING,
  city          STRING,
  mmsuser       INT,
  pushuser      INT,
  totaluser     INT,
  todayadduser  INT,
  todayremoveuser INT,
  monthadduser  INT,
  mmssend       INT,
  mmsreceive    INT,
  mmspv         INT,
  pushsend      INT,
  pushpv        INT,
  mmsuv         INT,
  pushuv        INT
)
PARTITIONED BY(dt STRING);
CREATE TABLE m_surfasAccessMonth
(
  province      STRING,
  city          STRING,
  mmsuser       INT,
  pushuser      INT,
  totaluser     INT,
  todayadduser  INT,
  todayremoveuser INT,
  monthadduser  INT,
  mmssend       INT,
  mmsreceive    INT,
  mmsreceiveUser INT,
  mmspv         INT,
  pushsend      INT,
  pushsendUser  INT,
  pushpv        INT,
  mmsuv         INT,
  pushuv        INT
)
PARTITIONED BY(dt STRING);

CREATE TABLE m_rdArea
(
  wapType       STRING,
  mobile        STRING,
  areaType      STRING,
  pv            BIGINT
)
PARTITIONED BY(dt STRING);
CREATE TABLE m_rdAreaURL
(
  wapType       STRING,
  mobile        STRING,
  areaType      STRING,
  url           STRING,
  sectionName   STRING,
  pv            BIGINT
)
PARTITIONED BY(dt STRING);

CREATE TABLE m_rderror
(
  wapType       STRING,
  mobile        STRING,
  errorcode     STRING,
  errordomain   STRING,
  outmobile     STRING
)
PARTITIONED BY(dt STRING);
CREATE TABLE m_rderror735
(
  wapType       STRING,
  mobile        STRING,
  errordomain   STRING,
  rcdomain      STRING,
  outmobile     STRING
)
PARTITIONED BY(dt STRING);

CREATE TABLE m_ishareMobile
(
  mobile        STRING
)
PARTITIONED BY(dt STRING,type STRING)
CLUSTERED BY(mobile) INTO 8 BUCKETS;
CREATE TABLE m_ishare
(
  province      STRING,
  city          STRING,
  shareCount    INT,
  shareHit      INT,
  shareSelfCount INT,
  shareSelfHit   INT
)
PARTITIONED BY(dt STRING);


CREATE TABLE r_surfinproduct
(
  province      STRING,
  partner       STRING,
  product       STRING,
  pv            BIGINT,
  uv            BIGINT
)
PARTITIONED BY(dt STRING);
CREATE TABLE r_surfoutproduct
(
  product       STRING,
  topdomain     STRING,
  secdomain     STRING,
  pv            BIGINT,
  uv            BIGINT
)
PARTITIONED BY(dt STRING);

CREATE TABLE r_surfasaccess
(
  province      STRING,
  mmsuser       INT,
  pushuser      INT,
  totaluser     INT,
  todayadduser  INT,
  todayremoveuser INT,
  monthadduser  INT,
  mmssend       INT,
  mmsreceive    INT,
  mmsreceiverate STRING,
  mmspv         INT,
  pushsend      INT,
  pushpv        INT,
  mmsuv         INT,
  pushuv        INT,
  mmsuvrate     STRING,
  pushuvrate    STRING
)
PARTITIONED BY(dt STRING);
CREATE TABLE r_surfasAccessMonth
(
  province      STRING,
  mmsuser       INT,
  pushuser      INT,
  totaluser     INT,
  todayadduser  INT,
  todayremoveuser INT,
  monthadduser  INT,
  mmssend       INT,
  mmsreceive    INT,
  mmsreceiveUser INT,
  mmsreceiverate STRING,
  mmspv         INT,
  pushsend      INT,
  pushsendUser  INT,
  pushpv        INT,
  mmsuv         INT,
  pushuv        INT,
  mmsuvrate     STRING,
  pushuvrate    STRING
)
PARTITIONED BY(dt STRING);

CREATE TABLE r_rdArea
(
  wapType       STRING,
  province      STRING,
  city          STRING,
  areaType      STRING,
  pv            BIGINT,
  uv            BIGINT
)
PARTITIONED BY(dt STRING);
CREATE TABLE r_rdAreaurl
(
  wapType       STRING,
  province      STRING,
  city          STRING,
  areaType      STRING,
  url           STRING,
  sectionName   STRING,
  pv            BIGINT,
  uv            BIGINT
)
PARTITIONED BY(dt STRING);

CREATE TABLE r_rderror
(
  wapType       STRING,
  province      STRING,
  errorcode     STRING,
  inpv          BIGINT,
  inuv          BIGINT,
  outpv         BIGINT,
  outuv         BIGINT,
  pvrate        FLOAT,
  uvrate        FLOAT
)
PARTITIONED BY(dt STRING);
CREATE TABLE r_rderror735
(
  wapType       STRING,
  province      STRING,
  errordomain   STRING,
  rcdomain      STRING,
  inpv          BIGINT,
  inuv          BIGINT,
  outpv         BIGINT,
  outuv         BIGINT,
  pvrate        FLOAT
)
PARTITIONED BY(dt STRING);
CREATE TABLE r_rderrordomain
(
  wapType       STRING,
  province      STRING,
  errordomain   STRING,
  inpv          BIGINT,
  inuv          BIGINT,
  pvperuv       FLOAT,
  outpv         BIGINT,
  outuv         BIGINT
)
PARTITIONED BY(dt STRING);

CREATE TABLE r_ishare
(
  province      STRING,
  city          STRING,
  totalUser     INT,
  totalSendUser INT,
  totalReceiveUser INT,
  sendUser      INT,
  receiveUser   INT,
  sendUserRate  STRING,
  shareCount    INT,
  shareHit      INT,
  shareHitRate  STRING,
  shareHitUser  INT,
  shareHitUserRate  STRING,
  shareSelfCount INT,
  shareSelfHitRate  STRING,
  shareCountPerSender FLOAT,
  shareReceiverPerSender FLOAT,
  shareCountPerReceiver  FLOAT,
  addUser         INT,
  addSender       INT,
  addReceiver     INT,
  mmsCount        INT,
  smsCount        INT
)
PARTITIONED BY(dt STRING);

CREATE TABLE r_urlNavigationHit
(
  category         STRING,
  secondcategory   STRING,
  sitename         STRING,
  url              STRING,
  uv               INT,
  pv               INT
)
PARTITIONED BY(dt STRING,type STRING);
CREATE TABLE r_urlNavigationTimeHit
(
  timeInterval   STRING,
  inpv           INT,
  inuv           INT,
  outpv          INT,
  outuv          INT
)
PARTITIONED BY(dt STRING,type STRING);

