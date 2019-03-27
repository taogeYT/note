mysqld --initialize   #直接初始化mysql，生成data文件夹中的文件。
mysqld  install(mysqld -remove) #安装mysql启动服务        
net start mysql(net stop mysql)#启动服务器
mysqladmin -u root password password;		#设置密码
set password for 'root'@'localhost'=password('password');	#修改


#登录mysql
mysql -u root -p				
show databases;					#显示所有数据库
create database yt;(drop database yt;)		#创建数据库yt   
use yt;						#选择数据库yt进入
show tables;					#显示数据库yt所有数据表
#创建数据表account 包含三个列（字段）user_id user_name password
create table account(
user_id int not null auto_increment,		#auto_increment 就是对主键 id 自动增加编号的
user_name varchar(100) not null,
password varchar(100) not null,
primary key (user_id));(drop table account;)

show tables;
show columns from account;			#查询数据表列（字段）属性


insert into account				#插入一条记录
(user_id,user_name,password)
values
(1,'yt','123456');

select * from account;				#查询
select * from account where user_id=1;

#下面都是表示读取表的第10，11，12，13行数据
语句1：select * from student limit 9,4
语句2：slect * from student limit 4 offset 9
limit n 等价于 limit 0,n

delete from account;				#删除
delete from account where user_id=1;

update account set user_name='lyt'; 		#更新
update account set user_name='lyt' where user_id=1;
UPDATE user SET Password=PASSWORD('password') where USER='root'
grant all privileges on *.*  to  'root'@'%'  identified by 'password'  with grant option;
flush privileges;

C:\Windows\System32\cmd.exe "C:\mysql\mysql-5.6.24-win32\bin" /k mysql -uroot -p

#数据库脚本导入执行方法
mysql -u root -p < schema.sql
mysql> source C:\Users\Administrator\Desktop\creat.sql


# 忘记密码修改mysql数据库密码方法
#1.停止mysql数据库
/etc/init.d/mysqld stop
#2.执行如下命令
mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
#3.使用root登录mysql数据库
mysql -u root mysql
#4.更新root密码
mysql> UPDATE user SET Password=PASSWORD('newpassword') where USER='root';
#最新版MySQL请采用如下SQL：
mysql> UPDATE user SET authentication_string=PASSWORD('newpassword') where USER='root';
#5.刷新权限
mysql> FLUSH PRIVILEGES;
#6.退出mysql
mysql> quit
#7.重启mysql
/etc/init.d/mysqld restart





#mysql 表的设计示例
CREATE TABLE `unit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL COMMENT '单位名称',
  `domain` varchar(50) DEFAULT NULL COMMENT '三级域名',
  `dbHost` varchar(50) DEFAULT NULL,
  `dbName` varchar(30) DEFAULT NULL COMMENT '数据库名称，可用于前台配置后自动生成新实例库',
  `dbUser` varchar(30) DEFAULT NULL,
  `dbPassword` varchar(30) DEFAULT NULL,
  `searchIndex` varchar(255) DEFAULT NULL COMMENT '搜索引擎URL',
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `indexPrefix` varchar(32) DEFAULT NULL,
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_domain` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='单位配置表';