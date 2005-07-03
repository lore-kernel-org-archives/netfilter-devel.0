From: David Stes <stes@pandora.be>
Subject: svn diff for Legato NetWorker RPC/RSH modules
Date: Sun, 03 Jul 2005 14:48:45 +0200
Message-ID: <42C7DEAD.4010209@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hello,

Here is the result of a "svn diff" for some changes to the 
"patch-o-matic-ng" .

These changes are for using the RPC/RSH modules for Legato NetWorker 
traffic over a netfilter firewall.

Is it please possible to commit this diff ?
When I try to commit the changes myself, I get a "Forbidden" (permission 
denied).
Here is the DIFF :

Index: patchlets/rsh/linux/net/ipv4/netfilter/ip_conntrack_rsh.c
===================================================================
--- patchlets/rsh/linux/net/ipv4/netfilter/ip_conntrack_rsh.c	(revision 4087)
+++ patchlets/rsh/linux/net/ipv4/netfilter/ip_conntrack_rsh.c	(working copy)
@@ -2,6 +2,9 @@
  * (C) 2002 by Ian (Larry) Latter <Ian.Latter@mq.edu.au>
  * based on HW's ip_conntrack_irc.c	
  *
+ * (C) 2004,2005 by David Stes <stes@pandora.be>
+ * Modification for Legato NetWorker range [7937-9936] instead of [0:1023]
+ *
  * ip_conntrack_rsh.c,v 1.0 2002/07/17 14:49:26
  *
  *      This program is free software; you can redistribute it and/or
@@ -10,10 +13,11 @@
  *      2 of the License, or (at your option) any later version.
  **
  *	Module load syntax:
- * 	insmod ip_conntrack_rsh.o ports=port1,port2,...port<MAX_PORTS>
+ * 	insmod ip_conntrack_rsh.o range=1023,ports=port1,port2,...port<MAX_PORTS>
  *	
  * 	please give the ports of all RSH servers You wish to connect to.
  *	If You don't specify ports, the default will be port 514
+ *      If you don't specify any range, the default will be 1023
  **
  *      Note to all:
  *        RSH blows ... you should use SSH (openssh.org) to replace it,
@@ -109,6 +113,8 @@
 #include <linux/netfilter_ipv4/ip_conntrack_rsh.h>
 
 #define MAX_PORTS 8
+static int range; /* defaults to = 1023 */
+static unsigned short rangemask; /* defaults to = 0xfc00 */
 static int ports[MAX_PORTS];
 static int ports_n_c = 0;
 
@@ -116,6 +122,8 @@
 MODULE_DESCRIPTION("RSH connection tracking module");
 MODULE_LICENSE("GPL");
 #ifdef MODULE_PARM
+MODULE_PARM(range, "i");
+MODULE_PARM_DESC(range, "max port of reserved range (default is 1023)");
 MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
 MODULE_PARM_DESC(ports, "port numbers of RSH servers");
 #endif
@@ -198,8 +206,8 @@
 
 	/* dont relate sessions that try to expose the client */
 	DEBUGP("found port %u\n", port);
-	if (port > 1023) {
-		DEBUGP("skipping, expected port size is greater than 1023!\n");
+	if (port > range) {
+		DEBUGP("skipping, expected port size is greater than range!\n");
 		return NF_ACCEPT;
 	}
 
@@ -229,8 +237,8 @@
 	exp->mask.src.ip = 0xffffffff;
 	exp->mask.dst.ip = 0xffffffff;
 
-	exp->mask.src.u.tcp.port = htons(0xfc00);
-	exp->mask.dst.u.tcp.port = htons(0xffff);
+	exp->mask.src.u.tcp.port = htons(rangemask);
+	exp->mask.dst.u.tcp.port = htons(rangemask);
 	exp->mask.dst.protonum = 0xffff;
 
 	exp->expectfn = NULL;
@@ -267,6 +275,16 @@
 	if (ports[0] == 0)
 		ports[0] = RSH_PORT;
 
+	/* the check on reserved port <1023 doesn't work with Legato */
+        /* for Legato NetWorker, the check should be that port <= 9936 */ 
+
+        if (range == 0) 
+		range = 1023;
+
+	/* Legato uses range [ 7937 : 9936 ] -> 7937 by default */
+
+        rangemask = 0xffff ^ range; /* defaults to = 0xfc00 */
+
 	for (port = 0; (port < MAX_PORTS) && ports[port]; port++) {
 		memset(&rsh_helpers[port], 0, sizeof(struct ip_conntrack_helper));
 
@@ -287,8 +305,8 @@
 
 		/* RSH must come from ports 0:1023 to ports[port] (514) */
 		rsh_helpers[port].tuple.src.u.tcp.port = htons(ports[port]);
-		rsh_helpers[port].mask.src.u.tcp.port = htons(0xfc00);
-		rsh_helpers[port].mask.dst.u.tcp.port = htons(0xfc00);
+		rsh_helpers[port].mask.src.u.tcp.port = htons(rangemask);
+		rsh_helpers[port].mask.dst.u.tcp.port = htons(rangemask);
 
 		rsh_helpers[port].help = help;
 
Index: patchlets/rsh/linux/Documentation/Configure.help.ladd
===================================================================
--- patchlets/rsh/linux/Documentation/Configure.help.ladd	(revision 4087)
+++ patchlets/rsh/linux/Documentation/Configure.help.ladd	(working copy)
@@ -16,6 +16,8 @@
            practice" to use RSH, use SSH in all instances.
            (see rfc1244, rfc1948, rfc2179, etc ad-nauseum)
 
+  The RSH connection module supports Legato NetWorker's nsrexec.
+  For support of Legato NetWorker, you will need the RPC and the RSH modules.
 
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.
Index: patchlets/rsh/help
===================================================================
--- patchlets/rsh/help	(revision 4087)
+++ patchlets/rsh/help	(working copy)
@@ -38,8 +38,22 @@
            --sport 0:1023 -d ${server} --dport 0:1023 ! --syn
            --state ESTABLISHED -j ACCEPT
 
+The nsrexec option of the RSH/RPC module supports Legato NetWorker backup.
 
+For Legato NetWorker,
 
+add options ip_conntrack_rsh range=9936 ports=7937
+add options ipt_rpc ports=7938
+add options ip_conntrack_rpc_tcp nsrexec=7937 ports=7938
+add options ip_conntrack_rpc_udp ports=7938
+
+iptables -A FORWARD -j ACCEPT -p tcp -m state --state NEW -m tcp --dport 7937
+iptables -A FORWARD -j ACCEPT -p tcp -m state --state NEW -m tcp --dport 7938
+iptables -A FORWARD -j ACCEPT -p udp -m state --state NEW -m udp --dport 7938
+iptables -A FORWARD -m state --state ESTABLISHED -j ACCEPT
+iptables -A FORWARD -m state --state RELATED -j ACCEPT
+iptables -A FORWARD -m rpc --rpcs nsrd,nsrmmd,nsrindexd,nsrmmdbd,nsrstat,nsrjb,rap,rapserv -j ACCEPT
+
 Warning:
 
   This module could be dangerous. It is not "best practice" to use
Index: patchlets/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c
===================================================================
--- patchlets/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c	(revision 4087)
+++ patchlets/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c	(working copy)
@@ -9,6 +9,9 @@
  * (C) 2002,2003 by Ian (Larry) Latter <Ian.Latter@mq.edu.au>
  *	- upgraded conntrack modules to newnat api - kernel 2.4.20+
  *	- extended matching to support filtering on procedures
+ * 
+ * (c) 2004,2005 by David Stes <stes@pandora.be>
+ *      - add nsrexec option for Legato NetWorker
  *
  * ip_conntrack_rpc_tpc.c,v 2.2 2003/01/12 18:30:00
  *
@@ -18,10 +21,15 @@
  *	2 of the License, or (at your option) any later version.
  **
  *	Module load syntax:
- *	insmod ip_conntrack_rpc_tcp.o ports=port1,port2,...port<MAX_PORTS>
+ *	insmod ip_conntrack_rpc_tcp.o nsrexec=<n>,ports=port1,...port<MAX_PORTS>
  *
  *	Please give the ports of all RPC servers you wish to connect to.
- *	If you don't specify ports, the default will be port 111.
+ *      For example, ports=111,7938 for Legato NetWorker's portmapper on 7938.
+ *	If you don't specify ports, the default will be port 111 (SUN portmap).
+ *
+ *      Please specify nsrexec, the TCP port of the rexec() service of
+ *      Legato NetWorker.  For example, nsrexec=7937
+ *
  **
  *	Note to all:
  *
@@ -62,8 +70,11 @@
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_n_c = 0;
+static int nsrexec = 0;
 
 #ifdef MODULE_PARM
+MODULE_PARM(nsrexec, "i");
+MODULE_PARM_DESC(nsrexec, "TCP port of Legato NetWorker's rexec service");
 MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
 MODULE_PARM_DESC(ports, "port numbers (TCP/UDP) of RPC portmapper servers");
 #endif
@@ -280,7 +291,7 @@
 		 * expectation ...  if port == 0, then this service is 
 		 * not going to be registered.
 		 */
-		if (port_buf) {
+		if (port_buf && port_buf != nsrexec) {
 			DEBUGP("port found: %u\n", port_buf);
 
 			memset(&expect, 0, sizeof(expect));
Index: patchlets/rpc/linux/Documentation/Configure.help.ladd
===================================================================
--- patchlets/rpc/linux/Documentation/Configure.help.ladd	(revision 4087)
+++ patchlets/rpc/linux/Documentation/Configure.help.ladd	(working copy)
@@ -25,6 +25,22 @@
   procedures per iptables rule, may be specified by the user,
   to enable effective RPC management.
 
+  The nsrexec option of the RSH/RPC module supports Legato NetWorker backup.
 
+For Legato NetWorker,
+
+add options ip_conntrack_rsh range=9936 ports=7937
+add options ipt_rpc ports=7938
+add options ip_conntrack_rpc_tcp nsrexec=7937 ports=7938
+add options ip_conntrack_rpc_udp ports=7938
+
+iptables -A FORWARD -j ACCEPT -p tcp -m state --state NEW -m tcp --dport 7937
+iptables -A FORWARD -j ACCEPT -p tcp -m state --state NEW -m tcp --dport 7938
+iptables -A FORWARD -j ACCEPT -p udp -m state --state NEW -m udp --dport 7938
+iptables -A FORWARD -m state --state ESTABLISHED -j ACCEPT
+iptables -A FORWARD -m state --state RELATED -j ACCEPT
+iptables -A FORWARD -m rpc --rpcs nsrd,nsrmmd,nsrindexd,nsrmmdbd,nsrstat,nsrjb,rap,rapserv -j ACCEPT
+
+
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.
Index: patchlets/rpc/help
===================================================================
--- patchlets/rpc/help	(revision 4087)
+++ patchlets/rpc/help	(working copy)
@@ -56,6 +56,23 @@
      user@client# rusers $server
 
 
+The nsrexec option of the RSH/RPC module supports Legato NetWorker backup.
+
+For Legato NetWorker,
+
+add options ip_conntrack_rsh range=9936 ports=7937
+add options ipt_rpc ports=7938
+add options ip_conntrack_rpc_tcp nsrexec=7937 ports=7938
+add options ip_conntrack_rpc_udp ports=7938
+
+iptables -A FORWARD -j ACCEPT -p tcp -m state --state NEW -m tcp --dport 7937
+iptables -A FORWARD -j ACCEPT -p tcp -m state --state NEW -m tcp --dport 7938
+iptables -A FORWARD -j ACCEPT -p udp -m state --state NEW -m udp --dport 7938
+iptables -A FORWARD -m state --state ESTABLISHED -j ACCEPT
+iptables -A FORWARD -m state --state RELATED -j ACCEPT
+iptables -A FORWARD -m rpc --rpcs nsrd,nsrmmd,nsrindexd,nsrmmdbd,nsrstat,nsrjb,rap,rapserv -j ACCEPT
+
+
 Warning:
 
   RPCs should not be exposed to the internet - ask the Pentagon;
