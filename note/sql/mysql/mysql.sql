mysqld --initialize   #ֱ�ӳ�ʼ��mysql������data�ļ����е��ļ���
mysqld  install(mysqld -remove) #��װmysql��������        
net start mysql(net stop mysql)#����������
mysqladmin -u root password password;		#��������
set password for 'root'@'localhost'=password('password');	#�޸�


#��¼mysql
mysql -u root -p				
show databases;					#��ʾ�������ݿ�
create database yt;(drop database yt;)		#�������ݿ�yt   
use yt;						#ѡ�����ݿ�yt����
show tables;					#��ʾ���ݿ�yt�������ݱ�
#�������ݱ�account ���������У��ֶΣ�user_id user_name password
create table account(
user_id int not null auto_increment,		#auto_increment ���Ƕ����� id �Զ����ӱ�ŵ�
user_name varchar(100) not null,
password varchar(100) not null,
primary key (user_id));(drop table account;)

show tables;
show columns from account;			#��ѯ���ݱ��У��ֶΣ�����


insert into account				#����һ����¼
(user_id,user_name,password)
values
(1,'yt','123456');

select * from account;				#��ѯ
select * from account where user_id=1;

#���涼�Ǳ�ʾ��ȡ��ĵ�10��11��12��13������
���1��select * from student limit 9,4
���2��slect * from student limit 4 offset 9
limit n �ȼ��� limit 0,n

delete from account;				#ɾ��
delete from account where user_id=1;

update account set user_name='lyt'; 		#����
update account set user_name='lyt' where user_id=1;
UPDATE user SET Password=PASSWORD('password') where USER='root'
grant all privileges on *.*  to  'root'@'%'  identified by 'password'  with grant option;
flush privileges;

C:\Windows\System32\cmd.exe "C:\mysql\mysql-5.6.24-win32\bin" /k mysql -uroot -p

#���ݿ�ű�����ִ�з���
mysql -u root -p < schema.sql
mysql> source C:\Users\Administrator\Desktop\creat.sql


# ���������޸�mysql���ݿ����뷽��
#1.ֹͣmysql���ݿ�
/etc/init.d/mysqld stop
#2.ִ����������
mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
#3.ʹ��root��¼mysql���ݿ�
mysql -u root mysql
#4.����root����
mysql> UPDATE user SET Password=PASSWORD('newpassword') where USER='root';
#���°�MySQL���������SQL��
mysql> UPDATE user SET authentication_string=PASSWORD('newpassword') where USER='root';
#5.ˢ��Ȩ��
mysql> FLUSH PRIVILEGES;
#6.�˳�mysql
mysql> quit
#7.����mysql
/etc/init.d/mysqld restart





#mysql ������ʾ��
CREATE TABLE `unit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL COMMENT '��λ����',
  `domain` varchar(50) DEFAULT NULL COMMENT '��������',
  `dbHost` varchar(50) DEFAULT NULL,
  `dbName` varchar(30) DEFAULT NULL COMMENT '���ݿ����ƣ�������ǰ̨���ú��Զ�������ʵ����',
  `dbUser` varchar(30) DEFAULT NULL,
  `dbPassword` varchar(30) DEFAULT NULL,
  `searchIndex` varchar(255) DEFAULT NULL COMMENT '��������URL',
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `indexPrefix` varchar(32) DEFAULT NULL,
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_domain` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='��λ���ñ�';