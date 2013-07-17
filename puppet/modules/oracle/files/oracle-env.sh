export LC_ALL=en_US.utf8
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export ORACLE_SID=XE
export NLS_LANG=`$ORACLE_HOME/bin/nls_lang.sh`
export ORACLE_BASE=/u01/app/oracle
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME/bin:$PATH

export ORACLE_ENHANCED=true
export DATABASE_SYS_PASSWORD=oracle
export DATABASE_VERSION=11.2.0.2
export ARUNIT_DB_NAME=${ORACLE_SID}
export DATABASE_HOST=localhost
export DATABASE_PORT=1521
export DATABASE_NAME=${ORACLE_SID}

