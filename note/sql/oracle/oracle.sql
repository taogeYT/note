lsnrctl start /lsnrctl stop
-- 创建普通用户并授权jwdn
create user jwdn identified by password;
grant dba to jwdn;
grant connect,resource to jwdn;
alter user jwdn default tablespace users;
-- 相关查询
select * from user_tab_columns where column_name='ID';-- 查询字段长度
select * from user_objects where object_name='T1';-- 查询创建时间等一些信息
select * from user_tables where table_name='T1';-- 查询用户表
-- 创建/删除表
create table t1(id number,name varchar2(100))/drop table t2;
create table t1 as select * from t2;
insert into t1 select * from t2;
-- 创建索引
create index t1_idx on t1(id);
drop index t1_idx;
-- 清空表操作
truncate table t1
delete from t1
-- 常用函数
substr, instr, trim
-- 通过LISTAGG函数将字段聚合
-- 用法: LISTAGG(field_name, ',') WITHIN GROUP(ORDER by NULL)
select id, listagg(wayname, ',') within group(order by null) as name from sz group by id;
-- 修改字段名语法：alter table <table_name> rename column <column_old> to <column_new>;
-- 添加字段的语法：alter table <table_name> add (<column> datatype [default value][null/not null],….);
-- 修改字段的语法：alter table <table_name> modify (<column> datatype [default value][null/not null],….);
-- 删除字段的语法：alter table <table_name> drop (<column>);

--随机抽取10条数据
select * from (select * from t1 order by sys_guid()) where rownum<10;
--随机数
 select abs(mod(dbms_random.random,100)) from dual
 select trunc(dbms_random.value(0,100)) from dual
--随机取一条数据
select * from (select * from t1 order by dbms_random.value) where rownum<2;

-- complex 混合类型字段
create table test_complex(x varchar2(20), y varchar2(20));
--1.显示定义
declare
type complex_column is record (
    x test_complex.x%type,
    y test_complex.y%type
);
-- 声明一个记录类型变量r_record
r_record complex_column ;
--2.隐式定义
r_record test_complex%rowtype;

--rowid使用,删除重复字段
DELETE FROM WAYS
WHERE ROWID NOT IN (SELECT MIN(ROWID) FROM WAYS GROUP BY WAYID)
AND WAYID IN (SELECT WAYID FROM WAYS GROUP BY WAYID HAVING COUNT(WAYID)>1);
--code和name都是非空约束可以使用下面语句去重
DELETE FROM TEST WHERE ROWID NOT IN (SELECT MIN(ROWID) FROM TEST GROUP BY CODE,NAME);

-- TO_DATE格式
SELECT TO_DATE('03-10月-16 12:15:00','dd-mon-yy hh24:mi:ss','nls_date_language=''Simplified Chinese''') from dual
-- Year:
-- yy two digits 两位年                显示值:07
-- yyy three digits 三位年                显示值:007
-- yyyy four digits 四位年                显示值:2007

-- Month:
-- mm    number     两位月              显示值:11
-- mon    abbreviated 字符集表示          显示值:11月,若是英文版,显示nov
-- month spelled out 字符集表示          显示值:11月,若是英文版,显示november

-- Day:
-- dd    number         当月第几天        显示值:02
-- ddd    number         当年第几天        显示值:02
-- dy    abbreviated 当周第几天简写    显示值:星期五,若是英文版,显示fri
-- day    spelled out   当周第几天全写    显示值:星期五,若是英文版,显示friday
-- ddspth spelled out, ordinal twelfth

      -- Hour:
      -- hh    two digits 12小时进制            显示值:01
      -- hh24 two digits 24小时进制            显示值:13

      -- Minute:
      -- mi    two digits 60进制                显示值:45

      -- Second:
      -- ss    two digits 60进制                显示值:25

      -- 其它
      -- Q     digit         季度                  显示值:4
      -- WW    digit         当年第几周            显示值:44
      -- W    digit          当月第几周            显示值:1

    -- 24小时格式下时间范围为： 0:00:00 - 23:59:59....
    -- 12小时格式下时间范围为： 1:00:00 - 12:59:59 ....


-- Oracle主键外键作用：
-- 主键：唯一标识，不能为空，加快查询速度，自动创建索引
-- 外键：约束内表的数据的更新，从定义外键时可以发现 外键是和主键表联系，数据类型要统一，长度(存储大小)要统一。这样在更新数据的时候会保持一致性

-- student表是学生表 里面有字段：学号和姓名 学号是主键
-- sc表是成绩表  里面有字段：学号和学科号 还有成绩  这里面的学号就是外键，关联着 student表的主键学号

-- 简单来说：一个表的外键关联着 另外一个表的主键

-- 外键的作用 保持数据完整性 .......
-- 拿上面的例子说：如果学生表 学号为1的记录删除了 ，那成绩表sc里面对应有学号为1的记录 是不是应该也删除呢？ 所以一般设置级联删除 这样删除了主键 外键的值跟着删除

-- # 创建主键
-- 1.先清理现有的数据并规划只能一个主键，或者考虑组合主键(即ID列与另一个关键列组合成主键)
-- 2.通过SQL增加主键：alter table tabname add  constraint tabname_pk primary key (id) enable validate;
-- 3.组合键：alter table tabname add  constraint tabname_pk primary key (id,另一列名) enable validate;


-- 批量删除用户下以xx开头的表
declare
begin
  for vcur in (select t.TABLE_NAME from user_tables t where t.TABLE_NAME like 'S32%') loop
    execute immediate 'drop table '||vcur.table_name;
  end loop;
end;

-- 字段自增长设置
-- 创建增长序列 autoinc_id
create sequence autoinc_id
    minvalue 1
    maxvalue 9999999999999999999999999999
    start with 1
    increment by 1
    nocache;
--创建触发器
create or replace trigger t1_autoinc
    before insert on t1
    for each row
        begin
            select autoinc_id.nextval into :new.id from dual;
        end;

--空间字段 SDO_GEOMETRY 查询使用方法------------------------------------------------------------------------------
--元数据表插入对应'WAYS'表中对空间字段'POSITION'的约束
insert into user_sdo_geom_metadata(table_name,COLUMN_NAME,DIMINFO,SRID)
values(
    'WAYS',
    'POSITION',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X',-180,180,0.0000000001),
        MDSYS.SDO_DIM_ELEMENT('Y',-90,90,0.0000000001)
    ),
    NULL
);
-- --         MDSYS.SDO_DIM_ELEMENT('X',-648000,648000,0.000000001),
-- --         MDSYS.SDO_DIM_ELEMENT('Y',-324000,324000,0.000000001)
--查看元数据表
select * from user_sdo_geom_metadata;
--创建空间索引
Create INDEX WAYS_SIDX on WAYS(POSITION) Indextype is MDSYS.SPATIAL_INDEX;
-- 查看表的索引
select * from user_indexes where table_name='WAYS';

--空间字段查询使用
SELECT * FROM
WAYS A
WHERE
SDO_WITHIN_DISTANCE(
    A.POSITION,
    MDSYS.SDO_GEOMETRY(2001,NULL,MDSYS.SDO_POINT_TYPE(58865.7200999931,45831.047199994304,NULL),NULL,NULL),
    'DISTANCE=1' --DISTANCE 的值为坐标单位
) = 'TRUE'

--最近的一个空间位置结果 SDO_NUM_RES = 1
SELECT * FROM
WAYS A
WHERE
SDO_NN(
    A.POSITION,
    MDSYS.SDO_GEOMETRY(2001,NULL,MDSYS.SDO_POINT_TYPE(58864.7200999931,45832.047199994304,NULL),NULL,NULL),'SDO_NUM_RES=1',1
) = 'TRUE'


--查找事故所属路段
create TABLE SG_LD AS(SELECT A.LINK_ID,C.ID FROM
TMP A,
(SELECT * FROM TMP_SG
    WHERE ID IN (SELECT B.ID FROM TMP_SG B,TMP A
        WHERE
        SDO_WITHIN_DISTANCE(
            B.SHAPE,
            A.SHAPE,
            'DISTANCE=0.002' --DISTANCE 的值为坐标单位
        ) = 'TRUE')
) C
WHERE
SDO_NN(
    A.SHAPE,
    C.SHAPE ,'SDO_NUM_RES=1',1
) = 'TRUE')


-- 空间字段应用
insert into user_sdo_geom_metadata(table_name,COLUMN_NAME,DIMINFO,SRID)
values(
    'TMP',
    'SHAPE',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X',-180,180,0.00000001),
        MDSYS.SDO_DIM_ELEMENT('Y',-90,90,0.00000001)
    ),
    NULL
);
select * from user_sdo_geom_metadata;
Create INDEX TMP_SG_SIDX on TMP_SG(SHAPE) Indextype is MDSYS.SPATIAL_INDEX
select * from user_indexes where table_name='TMP_SG';

SELECT * FROM
TMP A
WHERE
SDO_NN(
    A.SHAPE,
    MDSYS.SDO_GEOMETRY(2001,NULL,MDSYS.SDO_POINT_TYPE(120.726830,31.306243,NULL),NULL,NULL),
    'SDO_NUM_RES=1',1
) = 'TRUE'

SELECT LINK_ID,A.SHAPE.SDO_ORDINATES FROM
TMP A
WHERE
SDO_WITHIN_DISTANCE(
    A.SHAPE,
    MDSYS.SDO_GEOMETRY(2001,NULL,MDSYS.SDO_POINT_TYPE(120.726830,31.306243,NULL),NULL,NULL),
    'DISTANCE=0.001'


-- 创建定时任务
CREATE OR REPLACE  PROCEDURE SBLXZ IS
BEGIN
DELETE FROM HUMAN_TRACE;
COMMIT;
END SBLXZ;

DECLARE job_id NUMBER;
BEGIN
SYS.dbms_job.submit(
    job_id,'SBLXZ;',SYSDATE,'trunc(sysdate)+1/24+1'
);
COMMIT;
END;
#查看任务ID
SELECT * FROM DBA_JOBS;
#删除任务
BEGIN
dbms_job.remove(21);
COMMIT;
end;
