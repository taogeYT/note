 #### EPEL源  
  yum install epel-release    
  yum clean all    
  yum list    
  #### python安装：  
  wget https://www.python.org/ftp/python/3.5.3/Python-3.5.3.tgz    
  yum -y install gcc    
  yum -y install zlib-devel readline-devel sqlite-devel openssl-devel tk-devel tcl-devel    
  ./configure --prefix=/usr/local/python35    
  make && make install    
  #### python 内存泄漏工具安装使用  
  yum -y install python-gtk2 graphviz # 能使objgraph工具直接生成png格式图片  
  #### python 扩展包离线安装  
  python setup.py sdist upload -r pypi  
  pip3 install --download d:\packs pandas(-r requirements.txt)  
  pip3 install --no-index --find-links=d:\packs\ pandas (-r requirements.txt)  
  #### python 快速起http服务  
  python -m SimpleHTTPServer 8000  
  python3 -m http.server 8000  
  #### 源文件安装  
  python3 setup.py install  
  #### pip安装包缓存目录  
  win7:  
  c:\用户\(你的用户名)\AppData\Local\pip\cache  
  linux:  
  ~/.cache/pip  
  没必要去删除cache的，加入--no-cache-dir 就可以禁用缓存了  
  #### 忽虐依赖安装  
  rpm -i --nodeps name.rpm  
  #### oracle instantclient安装：  
  wget http://172.16.60.100/tools/oracle/oracle-instantclient11.2-basic-11.2.0.3.0-1.x86_64.rpm  
  wget http://172.16.60.100/tools/oracle/oracle-instantclient11.2-devel-11.2.0.3.0-1.x86_64.rpm  
  wget http://172.16.60.100/tools/oracle/oracle-instantclient11.2-sqlplus-11.2.0.3.0-1.x86_64.rpm  
  rpm -ivh  oracle-instantclient11.2-basic-11.2.0.3.0-1.x86_64.rpm  
  rpm -ivh  oracle-instantclient11.2-sqlplus-11.2.0.3.0-1.x86_64.rpm  
  rpm -ivh  oracle-instantclient11.2-devel-11.2.0.3.0-1.x86_64.rpm  
  pip3 install cx_Oracle  
    
  #### flask 框架依赖包安装  
  pip install -r requirement.txt  
    
  #### nginx安装：  
  yum -y install make zlib zlib-devel gcc-c++ libtool  openssl openssl-devel  
  ##安装 pcre  
  wget http://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.gz  
  wget http://nginx.org/download/nginx-1.6.2.tar.gz  
  ./configure --prefix=/usr/local/nginx  
  make && make install  
  /usr/local/nginx/sbin/nginx -v  
  nginx -s reload  
    
  #### linux静态地址配置  
  BOOTPROTO=static  
  IPADDR=192.168.152.210  
  NETMASK=255.255.255.0  
  GATEWAY=192.168.152.2  
  DNS1=192.168.152.2  
  DOMAIN=localdomain  
    
  #### elasticsearch 插件安装  
  bin/plugin install mobz/elasticsearch-head  
    
  #### oracle exp/imp 工具安装  
  从oracle服务器bin文件copy imp/exp oracle instantclient bin 目录下  
  再copy 对应配置文件 rdbms/mesg/impus.msb 和 expus.msb  
  配置环境变量：  
  LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH  
  ORACLE_HOME=/usr/lib/oracle/11.2/client64  
  PATH=$PATH:$ORACLE_HOME/bin  
  export PATH LD_LIBRARY_PATH ORACLE_HOME  
  example:  
      exp jwdn/lyt@local:1521/xe file=test tables=SSQ  
      imp lyt/lyt@local:1521/xe file=test fromuser=jwdn touser=lyt  
    
  #### sublime 查询快捷键 command  
  CTRL +`(显示控制台)  
  sublime.log_commands(True)  
  