查看表空间情况
----------------
    select * from dba_users;
    select * from dba_data_files;
    SELECT UPPER(F.TABLESPACE_NAME) "表空间名",
    D.TOT_GROOTTE_MB "表空间大小(M)",
    D.TOT_GROOTTE_MB - F.TOTAL_BYTES "已使用空间(M)",
    TO_CHAR(ROUND((D.TOT_GROOTTE_MB - F.TOTAL_BYTES) / D.TOT_GROOTTE_MB * 100,2),'990.99') "使用比",
    F.TOTAL_BYTES "空闲空间(M)",
    F.MAX_BYTES "最大块(M)"
    FROM (SELECT TABLESPACE_NAME,
    ROUND(SUM(BYTES) / (1024 * 1024), 2) TOTAL_BYTES,
    ROUND(MAX(BYTES) / (1024 * 1024), 2) MAX_BYTES
    FROM SYS.DBA_FREE_SPACE
    GROUP BY TABLESPACE_NAME) F,
    (SELECT DD.TABLESPACE_NAME,
    ROUND(SUM(DD.BYTES) / (1024 * 1024), 2) TOT_GROOTTE_MB
    FROM SYS.DBA_DATA_FILES DD
    GROUP BY DD.TABLESPACE_NAME) D
    WHERE D.TABLESPACE_NAME = F.TABLESPACE_NAME
    ORDER BY 4 DESC;

修改oracle用户密码永不过期
-----------------------------
1.查看用户的proifle是哪个，一般是default：

    sql>SELECT username,PROFILE FROM dba_users;

2.查看指定概要文件（如default）的密码有效期设置：

    sql>SELECT * FROM dba_profiles s WHERE s.profile='DEFAULT' AND resource_name='PASSWORD_LIFE_TIME';

3.将密码有效期由默认的180天修改成“无限制”：

    ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;

修改之后不需要重启动数据库，会立即生效。

4.修改后，还没有被提示ORA-28002警告的帐户不会再碰到同样的提示；

已经被提示的帐户必须再改一次密码，举例如下：

     $sqlplus / as sysdba

    sql> alter user smsc identified by <原来的密码> ---不用换新密码

创建触发器
--------------------------------
    CREATE OR REPLACE TRIGGER "LYT"."UPDATE_TABLE" AFTER INSERT OR DELETE OR UPDATE ON "LYT"."TEST" REFERENCING OLD AS "OLD" NEW AS "NEW" FOR EACH ROW BEGIN
    IF INSERTING THEN
        INSERT INTO TEST2 VALUES(:NEW.CODE,:NEW.NAME);
    ELSIF UPDATING THEN
        UPDATE TEST2 SET CODE=:NEW.CODE,NAME=:NEW.NAME WHERE CODE=:NEW.CODE;
    ELSIF DELETING THEN
        DELETE FROM TEST2 WHERE CODE=:OLD.CODE;
    END IF;
    END;

oracle 同结构表取差集和交集和并集
-------------------------------
#### 差集
SELECT * FROM TEST MINUS SELECT * FROM TEST2
#### 交集
SELECT * FROM TEST INTERSECT  SELECT * FROM TEST2
#### 并集
SELECT * FROM TEST UNION ALL SELECT * FROM TEST2

UNION ALL 不去重 UNION 会去重，所以UNION ALL的效率高

oracle 账号解锁
---------------------
ALTER USER user_name ACCOUNT UNLOCK;
