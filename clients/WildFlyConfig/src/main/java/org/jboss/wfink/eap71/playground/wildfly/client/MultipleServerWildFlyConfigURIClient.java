/**
 * 
 */
package org.jboss.wfink.eap71.playground.wildfly.client;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Properties;
import java.util.logging.Logger;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.jboss.wfink.eap71.playground.Simple;
import org.jboss.wfink.eap71.playground.client.logging.AbstractLoggerMain;
import org.wildfly.naming.client.WildFlyInitialContextFactory;

/**
 * <p>
 * Simple client which check the server names returned by an EJB to show ejb invocation with multiple URL's or against a cluster.
 * A wildfly-config.xml file need to be added to the classpath!
 * </p>
 *
 * @author <a href="mailto:wfink@redhat.com">Wolf-Dieter Fink</a>
 */
public class MultipleServerWildFlyConfigURIClient extends AbstractLoggerMain {
	private static final Logger log = Logger.getLogger(MultipleServerWildFlyConfigURIClient.class.getName());
	
	public static void main(String[] args) throws NamingException {
		checkArgs(args);

		// Set I_C_F with properties and use wildfly-config.xml to set the server URI and credentials
		Properties p = new Properties();
		p.put(Context.INITIAL_CONTEXT_FACTORY, WildFlyInitialContextFactory.class.getName());
		InitialContext ic = new InitialContext(p);
		
		Simple proxy = (Simple) ic.lookup("ejb:EAP71-PLAYGROUND-server/ejbOne/SimpleBean!" + Simple.class.getName());
		log.fine("Proxy is : " + proxy);
		
		HashSet<String> serverList = new HashSet<>();
		
		for (int i = 0; i < 20; i++) {
			serverList.add(proxy.getJBossServerName());
		}
		
		if(serverList.size() > 1) {
			log.info("Server should be part of a cluster or multiple URL's as the invocation was executed on the following servers : " + serverList);
		}else if(serverList.size() == 1) {
			log.warning("Server is not part of a cluster with multiple nodes, or did not have multiple PROVIDER URL's, as the invocation was executed on a single server : " + new ArrayList<String>(serverList).get(0));
		}else{
			throw new RuntimeException("Unexpected result, no server list!");
		}
	}
}
