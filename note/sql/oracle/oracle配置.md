---
title: oracle 配置
date: 2017-10-26 21:37:42
tags: oracle
---
##### 1.启动
    lsnrctl start /lsnrctl stop
    sqlplus /as sysdba;
    # 启动数据库
    startup;
    #停止数据库
    shutdown immediate;
    #密码不过期
    ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
#### 2 建立表空间和用户
    # 临时表空间
    create temporary tablespace lyt_temp tempfile '/oradata/temp.dbf' size 50m autoextend on next 50m maxsize 20480m extent management local;
    # 表空间
    create tablespace lyt_data logging datafile '/oradata/data.dbf' size 50m autoextend on next 50m maxsize 20480m extent management local;
    alter tablespace lyt_data add datafile '/oradata/data2.dbf' size 20480m;
    # 表空间文件查询
    select * from SYS.DBA_DATA_FILES where tablespace_name ='LYT_DATA';
    # 创建用户并指定表空间
    create user lyt identified by password default tablespace lyt_data temporary tablespace temp;
    alter user lyt default tablespace users;
    grant connect,resource,dba to lyt;
    grant create view to lyt;
#### 4 oracle导入导出工具
    创建授权操作目录
    create directory dir_name as '/home/lyt/';
    grant read,write on directory dir_name to lyt;
    impdp lyt/password DIRECTORY=dir_name DUMPFILE=filename.dmp TABLESPACES=src_spaces REMAP_SCHEMA=src_name:user REMAP_TABLESPACE=src_spaces:user_spaces TRANSFORM=SEGMENT_ATTRIBUTES:N:INDEX TRANSFORM=SEGMENT_ATTRIBUTES:N:CONSTRAINT EXCLUDE=STATISTICS

