if [ -z "$JBOSS_HOME" ];then
  echo "JBOSS_HOME not set"
  exit 1
fi

if [ -z "$JAVA_HOME" ];then
  JAVACMD="java"
else
  JAVACMD="$JAVA_HOME/bin/java"
fi

CLASSPATH="clients/WildFlyConfig/target/eap71-playground-clients-WildFlyConfigClient.jar:clients/common/target/eap71-playground-clients-common.jar:server/ejb/target/eap71-playground-server-ejb-client.jar"
CLASSPATH="$CLASSPATH:$JBOSS_HOME/bin/client/jboss-client.jar"


echo $CLASSPATH

echo
echo " run SimpleClient with java.naming.InitialContext, jndi.properties and wildfly-config [user1]  -- testclient clients SimpleWildFlyConfigClient clients/WildFlyConfig/config/user1"
echo U
read -p "  run [y]? " yn
echo
[ "$yn" = "y" ] && $JAVACMD -cp $CLASSPATH:clients/WildFlyConfig/config/user1 org.jboss.wfink.eap71.playground.wildfly.client.SimpleWildFlyConfigClient $CLIENT_ARGS

echo
echo " run SimpleClient with java.naming.InitialContext and wildfly-config [user1]  -- testclient clients UserOverrideWildFlyConfigClient clients/WildFlyConfig/config/user1"
echo "  InitialContext will override the user, expected to work"
read -p "  run [y]? " yn
echo
[ "$yn" = "y" ] && $JAVACMD -cp $CLASSPATH:clients/WildFlyConfig/config/user1 org.jboss.wfink.eap71.playground.wildfly.client.UserOverrideWildFlyConfigClient $CLIENT_ARGS

echo
echo " run SimpleClient with WildFlyInitialContext and wildfly-config [admin]  -- testclient clients WildFlyICConfigClient clients/WildFlyConfig/config/admin"
read -p "  run [y]? " yn
echo
[ "$yn" = "y" ] && $JAVACMD -cp $CLASSPATH:clients/WildFlyConfig/config/admin org.jboss.wfink.eap71.playground.wildfly.client.WildFlyICConfigClient $CLIENT_ARGS

echo
echo " run SimpleClient with WildFlyInitialContext and wildfly-config.xml @8080 @8180 [user1]  -- testclient clients MultipleServerWildFlyConfigURIClient clients/WildFlyConfig/config/twoServers"
echo "  should run with one of each and loadbalance if both are available (even if not in HA mode)"
read -p "  run [y]? " yn
echo
[ "$yn" = "y" ] && $JAVACMD -cp $CLASSPATH:clients/WildFlyConfig/config/twoServers org.jboss.wfink.eap71.playground.wildfly.client.MultipleServerWildFlyConfigURIClient $CLIENT_ARGS

echo
echo " run UserTransactionClient with WildFlyInitialContext and wildfly-config.xml @8080 @8180 [user1]  -- testclient clients UserTransactionWildFlyConfigClient clients/WildFlyConfig/config/twoServers"
echo "  should show stickyness for transaction for multiple servers not in HA mode"
read -p "  run [y]? " yn
echo
[ "$yn" = "y" ] && $JAVACMD -cp $CLASSPATH:clients/WildFlyConfig/config/twoServers org.jboss.wfink.eap71.playground.wildfly.client.UserTransactionWildFlyConfigClient $CLIENT_ARGS

echo
echo " run UserTransactionClient with mixed WildFlyInitialContext and wildfly-config.xml @8080 @8180 [user1]  -- testclient clients UserTransactionWildFlyConfigClient clients/WildFlyConfig/config/user1Only"
echo "  should show stickyness for transaction for multiple servers not in HA mode"
read -p "  run [y]? " yn
echo
[ "$yn" = "y" ] && $JAVACMD -cp $CLASSPATH:clients/WildFlyConfig/config/user1WithJNDIproperties org.jboss.wfink.eap71.playground.wildfly.client.UserTransactionWildFlyConfigClient $CLIENT_ARGS
