python 通过thrift 连接hive和impala(kerberos认证) 环境配置
===================================
    yum install gcc-c++ python-devel
    yum install cyrus-sasl-plain  cyrus-sasl-devel  cyrus-sasl-gssapi

    sasl==0.2.1
    thrift==0.9.3
    thrift-sasl==0.2.1
    thriftpy==0.3.9
    impyla==0.14.0

#### hive:
{'user': 'hive', 'port': 10000, 'password': 'hive', 'host': 'localhost', 'database': 'default', 'auth_mechanism': 'PLAIN'}

#### impala:
{'host': '172.16.17.18', 'use_kerberos': True, 'kerberos_service_name': 'impala', 'port': 21050, 'timeout': 3600}
