---
title: MERGE新特性(UPDATE WHERE,DELETE WHERE,INSERT WHERE)
date: 2017-10-26 21:37:42
tags: oracle
---
    通过MERGE语句，根据一张表或子查询的连接条件对另外一张表进行查询，连接条件匹配上的进行UPDATE，无法匹配的执行INSERT。
    这个语法仅需要一次全表扫描就完成了全部工作，执行效率要高于INSERT＋UPDATE。 
    语法为:
    *************************************************************
    MERGE [INTO [schema .] table [t_alias] 
    USING [schema .] { table | view | subquery } [t_alias] 
    ON ( condition ) 
    WHEN MATCHED THEN merge_update_clause 
    WHEN NOT MATCHED THEN merge_insert_clause
    **************************************************************
    特别说明：
    DELETE字句只能写在MATCHED情况中，不匹配时无法删除会报错。
    当DELETE跟在UPDATE字句之后时，DELETE字句是针对UPDATE字句修改后的数据进行过滤的。
    比如需要删除所有C字段="1"的数据，UPDATE字句将所有数据的C字段都更新为1，那么会删除所有数据，而不是原本为1的数据。
    
##### 应用实例，重复的数据合并

    SELECT * FROM W;

    MERGE INTO W X
    USING (SELECT * FROM W WHERE (ID,TT) IN (SELECT ID,MIN(TT) FROM W GROUP BY ID HAVING count(id)>1)) Y
    ON (X.ID=Y.ID)
    WHEN MATCHED THEN
        UPDATE SET
        X.AA=NVL(X.AA,Y.AA),
        X.BB=NVL(X.BB,Y.BB),
        X.CC=NVL(X.CC,Y.CC),
        X.TT=NVL(X.TT,Y.TT)
        WHERE (X.ID,X.TT) 
        IN (select ID,TT from (SELECT ID,TT,row_number()over(partition by ID order by TT)n FROM W) WHERE n<=2)
        DELETE WHERE X.TT=Y.TT; --从更新后的结果集里删除满足条件的记录

    SELECT * FROM W;
    特别说明：
    (select ID,TT from (SELECT ID,TT,row_number()over(partition by ID order by TT)n FROM W) WHERE n<=2)
    改语句能从group分组中取指定的某行或几行的方法
