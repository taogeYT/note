---
title: 空间字段 SDO_GEOMETRY 查询使用方法
date: 2017-10-26 21:37:42
tags: oracle
---
### 建立空间字段索引
##### 第一步：向元数据表(user_sdo_geom_metadata)插入某表(TMP)的空间字段(SHAPE)的约束
    insert into user_sdo_geom_metadata(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID)
    values(
        'TMP',
        'SHAPE',
        MDSYS.SDO_DIM_ARRAY(
            MDSYS.SDO_DIM_ELEMENT('X',-180,180,0.00000001),
            MDSYS.SDO_DIM_ELEMENT('Y',-90,90,0.00000001)
        ),
        NULL
    );
    查看元数据表
    select * from user_sdo_geom_metadata;

##### 第二步：创建空间字段的索引
    Create INDEX TMP_SG_SIDX on TMP_SG(SHAPE) Indextype is MDSYS.SPATIAL_INDEX;
    查看表的索引
    select * from user_indexes where table_name='TMP_SG';

### 空间字段查询使用
##### 1.查询指定距离范围内的空间对象对象
    SELECT LINK_ID,A.SHAPE.SDO_ORDINATES FROM
    TMP A
    WHERE
    SDO_WITHIN_DISTANCE(
        A.SHAPE,
        MDSYS.SDO_GEOMETRY(2001,NULL,MDSYS.SDO_POINT_TYPE(120.726830,31.306243,NULL),NULL,NULL),--表示点图形
       'DISTANCE=0.001' --DISTANCE 的值为坐标单位
    ) = 'TRUE'
    
##### 2.查询最近的N个空间位置结果通过约束'SDO_NUM_RES' = N
    SELECT * FROM
    TMP A
    WHERE
    SDO_NN(
        A.SHAPE,
        MDSYS.SDO_GEOMETRY(2001,NULL,MDSYS.SDO_POINT_TYPE(120.726830,31.306243,NULL),NULL,NULL),--表示点图形
        'SDO_NUM_RES=1',1
    ) = 'TRUE'
##### 3.两种查询结合应用来查找事故所属路段
    create TABLE SG_LD AS(
        SELECT A.LINK_ID,C.ID FROM
        TMP A,(
            SELECT * FROM TMP_SG
            WHERE ID IN (
                SELECT B.ID FROM TMP_SG B,TMP A
                WHERE SDO_WITHIN_DISTANCE(
                        B.SHAPE,
                        A.SHAPE,
                        'DISTANCE=0.002' --DISTANCE 的值为坐标单位
                ) = 'TRUE'
            )
        ) C
        WHERE SDO_NN(
            A.SHAPE,
            C.SHAPE,
            'SDO_NUM_RES=1',1
        ) = 'TRUE'
    )
