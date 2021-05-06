-- {"id":100,"name":"lb james阿道夫","money":293.899778,"dateone":"2020-07-30 10:08:22","age":"33","datethree":"2020-07-30 10:08:22.123","datesix":"2020-07-30 10:08:22.123456","datenigth":"2020-07-30 10:08:22.123456789","dtdate":"2020-07-30","dttime":"10:08:22"}
CREATE TABLE source
(
    id        INT,
    name      STRING,
    money     decimal,
    dateone   timestamp,
    age       bigint,
    datethree timestamp,
    datesix   timestamp(6),
    datenigth timestamp(9),
    dtdate    date,
    dttime    time,
    PROCTIME AS PROCTIME()
) WITH (
      'connector' = 'kafka-x'
      ,'topic' = 'da'
      ,'properties.bootstrap.servers' = 'kudu1:9092'
      ,'properties.group.id' = 'luna_g'
      ,'scan.startup.mode' = 'earliest-offset'
      -- ,'scan.startup.mode' = 'latest-offset'
      ,'format' = 'json'
      ,'json.timestamp-format.standard' = 'SQL'
      );

-- CREATE TABLE `flink_out` (
--                              `id` int(11) DEFAULT NULL,
--                              `name` varchar(255) DEFAULT NULL,
--                              `money` decimal(9,6) DEFAULT NULL,
--                              `age` bigint(20) DEFAULT NULL,
--                              `datethree` timestamp NULL DEFAULT NULL,
--                              `datesix` timestamp NULL DEFAULT NULL,
--                              `phone` bigint(20) DEFAULT NULL,
--                              `wechat` varchar(255) DEFAULT NULL,
--                              `income` decimal(9,6) DEFAULT NULL,
--                              `birthday` timestamp NULL DEFAULT NULL,
--                              `dtdate` date DEFAULT NULL,
--                              `dttime` time DEFAULT NULL,
--                              `today` date DEFAULT NULL,
--                              `timecurrent` time DEFAULT NULL,
--                              `dateone` timestamp NULL DEFAULT NULL
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- INSERT INTO test.flink_out (id, name, money, age, datethree, datesix, phone, wechat, income, birthday, dtdate, dttime, today, timecurrent, dateone) VALUES (100, 'kobe james阿道夫', 30.230000, 30, '2020-03-03 03:03:03', '2020-06-06 06:06:06', 11111111111111, '这是我的wechat', 23.120000, '2020-10-10 10:10:10', '2020-12-12', '12:12:12', '2020-10-10', '10:10:10', '2020-01-01 01:01:01');
-- INSERT INTO test.flink_out (id, name, money, age, datethree, datesix, phone, wechat, income, birthday, dtdate, dttime, today, timecurrent, dateone) VALUES (100, 'kobe james阿道夫', 30.230000, 30, '2020-03-03 03:03:03', '2020-06-06 06:06:06', 11111111111111, '这是我的wechat', 23.120000, '2020-10-10 10:10:10', '2020-12-12', '12:12:12', '2020-10-10', '10:10:10', '2020-01-01 01:01:01');

CREATE TABLE side
(
    id          int,
    name        varchar,
    money       decimal,
    dateone     timestamp,
    age         bigint,
    datethree   timestamp,
    datesix     timestamp,
    phone       bigint,
    wechat      varchar,
    income      decimal,
    birthday    timestamp,
    dtdate      date,
    dttime      time,
    today       date,
    timecurrent time,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'mysql-x',
      'url' = 'jdbc:mysql://localhost:3306/test',
      'table-name' = 'flink_out',
      'username' = 'root',
      'password' = 'abc123',
      'lookup.cache-type' = 'lru'
      );


-- CREATE TABLE `flink_type` (
--                               `id` int(11) DEFAULT NULL,
--                               `name` varchar(255) DEFAULT NULL,
--                               `money` decimal(9,6) DEFAULT NULL,
--                               `age` bigint(20) DEFAULT NULL,
--                               `datethree` timestamp NULL DEFAULT NULL,
--                               `datesix` timestamp NULL DEFAULT NULL,
--                               `phone` bigint(20) DEFAULT NULL,
--                               `wechat` varchar(255) DEFAULT NULL,
--                               `income` decimal(9,6) DEFAULT NULL,
--                               `birthday` timestamp NULL DEFAULT NULL,
--                               `dtdate` date DEFAULT NULL,
--                               `dttime` time DEFAULT NULL,
--                               `today` date DEFAULT NULL,
--                               `timecurrent` time DEFAULT NULL,
--                               `dateone` timestamp NULL DEFAULT NULL
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE sink
(
    id          int,
    name        varchar,
    money       decimal,
    dateone     timestamp,
    age         bigint,
    datethree   timestamp,
    datesix     timestamp,
    phone       bigint,
    wechat      varchar,
    income      decimal,
    birthday    timestamp,
    dtdate      date,
    dttime      time,
    today       date,
    timecurrent time
) WITH (
      -- 'connector' = 'stream'

      'connector' = 'mysql-x',
      'url' = 'jdbc:mysql://localhost:3306/test',
      'table-name' = 'flink_type',
      'username' = 'root',
      'password' = 'abc123',
      'sink.buffer-flush.max-rows' = '1',
      'sink.allReplace' = 'true'
      );

create
TEMPORARY view view_out
  as
select u.id
     , u.name
     , u.money
     , u.dateone
     , u.age
     , u.datethree
     , u.datesix
     , s.phone
     , s.wechat
     , s.income
     , s.birthday
     , u.dtdate
     , u.dttime
     , s.today
     , s.timecurrent
from source u
         left join side FOR SYSTEM_TIME AS OF u.PROCTIME AS s
                   on u.id = s.id;

insert into sink
select *
from view_out;